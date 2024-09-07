library(viridis)
library(tidycensus)
library(raster)
library(sf)
library(tidyverse)
library(exactextractr)
library(ggridges)
library(forcats)
library(ggpubr)

data_dir <- c('/Users/ani/Documents/phd/research/scovronick/air_health/data/')
plot_dir <- c('/Users/ani/Documents/phd/research/scovronick/air_health/plots/')

# exposure
oz <- read.csv(paste0(data_dir, 'ozone_summer.csv'))
pm <- read.csv(paste0(data_dir, 'county_PM2.5.csv'))
get_demo_df <- function() {

	# demography
	demo <- get_acs(variables = c('B01003_001', 'B02001_002', 'B02001_003',
		'B02001_004', 'B02001_005', 'B02001_006',
		'B03001_003', 'B06011_001',

		'B19001_002', 'B19001_003', 'B19001_004', 'B19001_005', 'B19001_006', 'B19001_007',
		'B19001_008', 'B19001_009', 'B19001_010', 'B19001_011', 'B19001_012', 'B19001_013',
		'B19001_014', 'B19001_015', 'B19001_016', 'B19001_017'

		), 
		year = 2017, geography = 'county')
	var_df <- data.frame(
		variable = c('B01003_001', 'B02001_002', 'B02001_003',
		'B02001_004', 'B02001_005', 'B02001_006',
		'B03001_003', 'B06011_001',

		'B19001_002', 'B19001_003', 'B19001_004', 'B19001_005', 'B19001_006', 'B19001_007',
		'B19001_008', 'B19001_009', 'B19001_010', 'B19001_011', 'B19001_012', 'B19001_013',
		'B19001_014', 'B19001_015', 'B19001_016', 'B19001_017'

		),
		var_name = c('total', 'white', 'black', 'native_am', 'asian', 'pi', 'hispanic', 'income',
			paste0('i', 2:17))
		)
	return(list('demo' = demo, 'var_df' = var_df))
}

process_poll_df <- function(demo_list, pollutant_df) {
	
	demo <- demo_list[['demo']]
	var_df <- demo_list[['var_df']]

	# epa regions
	states_epa <- read.csv(paste0(data_dir, 'states_epa.csv'))

	# urban-rural
	urban_pct <- read.csv(paste0(data_dir, '2020_UA_COUNTY.csv'))
	urban_pct$NAME <- paste0(urban_pct$COUNTY_NAME, ' County, ', urban_pct$STATE_NAME)
	urban_pct <- dplyr::select(urban_pct, NAME, POPPCT_URB)

	demo_df <- left_join(demo, var_df) %>%
		dplyr::select(-moe, -variable) %>%
		pivot_wider(names_from = var_name, values_from = estimate) %>%
		mutate(GEOID = as.numeric(GEOID)) %>%
		left_join(dplyr::select(pollutant_df, STNAME, GEOID = FIPS, X2017, REF2050, NZ2050, NZ2050RCP)) %>%
		mutate(non_hispanic = total - hispanic) %>%
		mutate(race_cat = ifelse(black/total > 0.67, 'Black',
			ifelse(white/total > 0.67, 'White', 'Mixed'))) %>% 
		left_join(states_epa) %>%
		left_join(urban_pct) %>%
		mutate(POPPCT_URB = as.numeric(substr(POPPCT_URB, 1, 4))/100) %>%
		mutate(urban = total*POPPCT_URB, rural = total - urban)	
	return(demo_df)
}


get_wei_plot_race <- function(demo, poll) {
	demo_df <- demo
	st_pct_black <- demo_df %>%
		group_by(STNAME) %>%
		summarize(black = sum(black, na.rm = TRUE), total = sum(total, na.rm = TRUE)) %>%
		mutate(pct_black = 100*(black/total))

	race_wt_df <- demo_df %>%
		dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP,
			white, black, total, EPA) %>%
		pivot_longer(cols = c('white', 'black', 'total'), names_to = "race",
			values_to = 'count') %>%
		pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "Scenario",
			values_to = 'pm')
	race_wt_df$Scenario <- ifelse(race_wt_df$Scenario == 'X2017', '2017', 
		ifelse(race_wt_df$Scenario == 'NZ2050RCP', 'NZ2050RCP8.5', race_wt_df$Scenario))
	race_wt_df <- mutate(race_wt_df, 
		Scenario = fct_relevel(Scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
	race_wt_df$race <- ifelse(race_wt_df$race == 'white', 'White',
		ifelse(race_wt_df$race == 'black', 'Black', 'Total'))
	race_wt_df$race <- fct_relevel(race_wt_df$race, 'Black', 'White', 'Total')
	race_wt_df <- race_wt_df %>%
		group_by(race, STNAME, Scenario, EPA) %>%
		summarize(pm = weighted.mean(x = pm, w = count, na.rm = TRUE)) %>%
		filter(race != 'Total') %>%
		pivot_wider(values_from = pm, names_from = race) %>%
		mutate(disparity = (White-Black))
	wei_plot_df <- race_wt_df

	wei_plot_df_ranker <- filter(wei_plot_df, Scenario == '2017')
	wei_plot_df_ranker$higher <- ifelse(wei_plot_df_ranker$Black > wei_plot_df_ranker$White, 'Black', 'White')
	wei_plot_df_ranker$ranker <- ifelse(wei_plot_df_ranker$higher == 'Black', 20000+abs(wei_plot_df_ranker$disparity),
		10000+abs(wei_plot_df_ranker$disparity))
	wei_plot_df_ranker <- left_join(wei_plot_df_ranker, st_pct_black)
	wei_plot_df_ranker$ranker <- ifelse(wei_plot_df_ranker$pct_black < 14.2, abs(wei_plot_df_ranker$ranker),
		1000+wei_plot_df_ranker$ranker)
	wei_plot_df_ranker <- dplyr::select(ungroup(wei_plot_df_ranker), STNAME, ranker)
	wei_plot_df_plot <- left_join(wei_plot_df, wei_plot_df_ranker) %>%
		filter(!is.na(STNAME), STNAME != 'District of Columbia')

	xlab_text <- paste0('White vs. Black Disparity in ', poll, ' Exposure')
	
	wei_plot_df_plot$Scenario <- ifelse(wei_plot_df_plot$Scenario == 'REF2050', 'Reference',
		ifelse(wei_plot_df_plot$Scenario == 'NZ2050', 'Net Zero', 
			ifelse(wei_plot_df_plot$Scenario == '2017', '2017', 'Net Zero Hot')))
	wei_plot_df_plot$Scenario <- fct_relevel(wei_plot_df_plot$Scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')

	gg_wei1 <- ggplot(wei_plot_df_plot) +
		geom_point(aes(y = fct_reorder(STNAME, (ranker)), x = abs(disparity), col = Scenario), alpha = 0.75) +
		theme_bw() +
		ylab('') +
		scale_color_manual(name = 'Scenario',
			values = c('#000000', '#1b9e77', '#d95f02', '#7570b3')) 

	if (poll == 'Ozone') {
		gg_wei1 <- gg_wei1 +
			annotate("text", x = 2.5, y = 44, label = "Higher Black Population,\nBlack Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 2.5, y = 25, label = "Lower Black Population,\nBlack Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 2.5, y = 10, label = "Higher Black Population,\nWhite Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 2.5, y = 4, label = "Lower Black Population,\nWhite Population More Exposed", col = 'Black', size = 3)  +
			xlab(paste0(xlab_text, ' (ppb)')) +
			geom_hline(yintercept = 11.5) +
			geom_hline(yintercept = 8.5, linetype = 'dashed') +
			geom_hline(yintercept = 37.5, linetype = 'dashed')
	} else {
		gg_wei1 <- gg_wei1 +
			annotate("text", x = 1.5, y = 44, label = "Higher Black Population,\nBlack Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 1.5, y = 25, label = "Lower Black Population,\nBlack Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 1.5, y = 8, label = "Higher Black Population,\nWhite Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 1.5, y = 4, label = "Lower Black Population,\nWhite Population More Exposed", col = 'Black', size = 3) +
			theme(legend.position = 'none')  +
			xlab(bquote('White vs. Black Disparity in PM2.5 '(μg/m^3))) +
			geom_hline(yintercept = 9.5) +
			geom_hline(yintercept = 5.5, linetype = 'dashed') +
			geom_hline(yintercept = 38.5, linetype = 'dashed')

	}

}

get_wei_plot_income <- function(demo, poll) {
	demo_df <- demo
	st_pct_lowincome <- demo_df %>%
		mutate(low_income = (i2+i3+i4+i5+i6), mid_income = (i7+i8+i9+i10+i11+i12+i13+i14+i15),
			high_income = (i16+i17)) %>%
		group_by(STNAME) %>%
		summarize(low_income = sum(low_income, na.rm = TRUE), total = sum(total, na.rm = TRUE)) %>%
		mutate(pct_low_income = 100*(low_income/total))

	income_wt_df <- as.data.frame(demo_df) %>%
		mutate(low_income = (i2+i3+i4+i5+i6), mid_income = (i7+i8+i9+i10+i11+i12+i13+i14+i15),
			high_income = (i16+i17)) %>%
		dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP, low_income, mid_income,
			high_income, EPA) %>%
		pivot_longer(cols = c('low_income', 'mid_income', 'high_income'), names_to = "income",
			values_to = 'count') %>%
		pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "Scenario",
			values_to = 'pm')
	income_wt_df$Scenario <- ifelse(income_wt_df$Scenario == 'X2017', '2017', 
		ifelse(income_wt_df$Scenario == 'NZ2050RCP', 'NZ2050RCP8.5', income_wt_df$Scenario))
	income_wt_df <- mutate(income_wt_df, 
		Scenario = fct_relevel(Scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
	income_wt_df$income <- ifelse(income_wt_df$income == 'high_income', 'High Income',
		ifelse(income_wt_df$income == 'mid_income', 'Middle Income', 'Low Income'))
	income_wt_df$income <- fct_relevel(income_wt_df$income, 'High Income', 'Middle Income', 'Low Income')
	income_wt_df <- filter(income_wt_df, income != 'Middle Income')
	income_wt_df <- income_wt_df %>%
		group_by(income, STNAME, Scenario, EPA) %>%
		summarize(pm = weighted.mean(x = pm, w = count, na.rm = TRUE)) %>%
		pivot_wider(values_from = pm, names_from = income) %>%
		mutate(disparity = (`High Income`-`Low Income`))
	wei_plot_df <- income_wt_df

	wei_plot_df_ranker <- filter(wei_plot_df, Scenario == '2017')
	wei_plot_df_ranker$higher <- ifelse(wei_plot_df_ranker$`Low Income` > wei_plot_df_ranker$`High Income`, 'Low', 'High')
	wei_plot_df_ranker$ranker <- ifelse(wei_plot_df_ranker$higher == 'Low', 20000+abs(wei_plot_df_ranker$disparity),
		10000+abs(wei_plot_df_ranker$disparity))
	wei_plot_df_ranker <- left_join(wei_plot_df_ranker, st_pct_lowincome)
	wei_plot_df_ranker$ranker <- ifelse(wei_plot_df_ranker$pct_low_income < 20, abs(wei_plot_df_ranker$ranker),
		1000+wei_plot_df_ranker$ranker)
	wei_plot_df_ranker <- dplyr::select(ungroup(wei_plot_df_ranker), STNAME, ranker)
	wei_plot_df_plot <- left_join(wei_plot_df, wei_plot_df_ranker) %>%
		filter(!is.na(STNAME), STNAME != 'District of Columbia')

	xlab_text <- paste0('High Income vs. Low Income Disparity in ', poll, ' Exposure')

	wei_plot_df_plot$Scenario <- ifelse(wei_plot_df_plot$Scenario == 'REF2050', 'Reference',
		ifelse(wei_plot_df_plot$Scenario == 'NZ2050', 'Net Zero', 
			ifelse(wei_plot_df_plot$Scenario == '2017', '2017', 'Net Zero Hot')))
	wei_plot_df_plot$Scenario <- fct_relevel(wei_plot_df_plot$Scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')

	gg_wei1 <- ggplot(wei_plot_df_plot) +
		geom_point(aes(y = fct_reorder(STNAME, (ranker)), x = abs(disparity), col = Scenario), alpha = 0.75) +
		theme_bw() +
		ylab('') +
		scale_color_manual(name = 'Scenario',
			values = c('#000000', '#1b9e77', '#d95f02', '#7570b3')) 

	if (poll == 'Ozone') {
		gg_wei1 <- gg_wei1 +
			annotate("text", x = 2.5, y = 44, label = "Low Income Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 2.5, y = 25, label = "High Income Population More Exposed", col = 'Black', size = 3) +
			# annotate("text", x = 2.5, y = 10, label = "High Income Population More Exposed", col = 'Black', size = 3) +
			# annotate("text", x = 2.5, y = 4, label = "High Income Population More Exposed", col = 'Black', size = 3)  +
			xlab(paste0(xlab_text, ' (ppb)')) +
			geom_hline(yintercept = 38.5)
			# geom_hline(yintercept = 8.5, linetype = 'dashed') +
			# geom_hline(yintercept = 40.5, linetype = 'dashed')
	} else {
		gg_wei1 <- gg_wei1 +
			annotate("text", x = 1.5, y = 44, label = "Low Income Population More Exposed", col = 'Black', size = 3) +
			annotate("text", x = 1.5, y = 25, label = "High Income Population More Exposed", col = 'Black', size = 3) +
			# annotate("text", x = 1.5, y = 8, label = "Higher Low Income Population,\nHigh Income Population More Exposed", col = 'Black', size = 3) +
			# annotate("text", x = 1.5, y = 4, label = "Lower Low Income Population,\nHigh Income Population More Exposed", col = 'Black', size = 3) +
			theme(legend.position = 'none')  +
			xlab(bquote('High Income vs. Low Income Disparity in PM2.5 '(μg/m^3))) +
			geom_hline(yintercept = 41.5) 
			# geom_hline(yintercept = 5.5, linetype = 'dashed') +
			# geom_hline(yintercept = 40.5, linetype = 'dashed')

	}

}

demo_list <- get_demo_df()
oz_demo <- process_poll_df(demo_list = demo_list, pollutant_df = oz)
pm_demo <- process_poll_df(demo_list = demo_list, pollutant_df = pm)

gg_oz_race <- get_wei_plot_race(oz_demo, poll = 'Ozone') + labs(tag = 'B')
gg_pm_race <- get_wei_plot_race(pm_demo, poll = 'PM2.5') + labs(tag = 'A')

gg_oz_income <- get_wei_plot_income(oz_demo, poll = 'Ozone') + labs(tag = 'B')
gg_pm_income <- get_wei_plot_income(pm_demo, poll = 'PM2.5') + labs(tag = 'A')

jpeg(paste0(plot_dir, '/fig6_', Sys.Date(), '.jpg'), width = 16, height = 9, quality = 1, units = 'in', res = 300)
	print(ggarrange(gg_pm_race, gg_oz_race, common.legend = TRUE, legend = 'bottom'))
dev.off()

jpeg(paste0(plot_dir, '/fig_s3_', Sys.Date(), '.jpg'), width = 16, height = 9, quality = 1, units = 'in', res = 300)
	print(ggarrange(gg_pm_income, gg_oz_income, common.legend = TRUE, legend = 'bottom'))
dev.off()
