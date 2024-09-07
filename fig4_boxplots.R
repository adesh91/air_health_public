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

get_demo_df <- function(pollutant_df) {
	# epa regions
	states_epa <- read.csv(paste0(data_dir, 'states_epa.csv'))

	# urban-rural
	urban_pct <- read.csv(paste0(data_dir, '2020_UA_COUNTY.csv'))
	urban_pct$NAME <- paste0(urban_pct$COUNTY_NAME, ' County, ', urban_pct$STATE_NAME)
	urban_pct <- dplyr::select(urban_pct, NAME, POPPCT_URB)
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
}

get_race_df <- function(demo_df) {
	race_wt_df <- demo_df %>%
	dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP,
		white, black, native_am, asian, pi) %>%
	pivot_longer(cols = c('white', 'black', 'native_am', 'asian', 
		'pi'), names_to = "race",
		values_to = 'count') %>%
	pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario",
		values_to = 'pm')
	race_wt_df$scenario <- ifelse(race_wt_df$scenario == 'X2017', '2017', 
		ifelse(race_wt_df$scenario == 'NZ2050RCP', 'NZ2050RCP8.5', race_wt_df$scenario))
	race_wt_df <- mutate(race_wt_df, 
		scenario = fct_relevel(scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
	race_wt_df$race <- ifelse(race_wt_df$race == 'white', 'White',
		ifelse(race_wt_df$race == 'black', 'Black',
			ifelse(race_wt_df$race == 'native_am', 'Native Am.',
				ifelse(race_wt_df$race == 'asian', 'Asian', 'P.I.'))))

	##### Clump all non-black and non-white into "other"
	race_wt_df_2 <- race_wt_df
	race_wt_df_2$race <- ifelse(race_wt_df_2$race %in% c('White', 'Black'), race_wt_df_2$race, 'Other')
	race_wt_df_2 <- filter(race_wt_df_2, race != 'Other')
}

get_income_df <- function(demo_df) {
	income_wt_df <- as.data.frame(demo_df) %>%
		mutate(low_income = (i2+i3+i4+i5+i6), mid_income = (i7+i8+i9+i10+i11+i12+i13+i14+i15),
			high_income = (i16+i17)) %>%
		dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP, low_income, mid_income,
			high_income) %>%
		pivot_longer(cols = c('low_income', 'mid_income', 'high_income'), names_to = "income",
			values_to = 'count') %>%
		pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario",
			values_to = 'pm')
	income_wt_df$scenario <- ifelse(income_wt_df$scenario == 'X2017', '2017', 
		ifelse(income_wt_df$scenario == 'NZ2050RCP', 'NZ2050RCP8.5', income_wt_df$scenario))
	income_wt_df <- mutate(income_wt_df, 
		scenario = fct_relevel(scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
	income_wt_df$income <- ifelse(income_wt_df$income == 'high_income', 'High Income',
		ifelse(income_wt_df$income == 'mid_income', 'Middle Income', 'Low Income'))
	income_wt_df$income <- fct_relevel(income_wt_df$income, 'High Income', 'Middle Income', 'Low Income')
	income_wt_df <- filter(income_wt_df, income != 'Middle Income')
	return(income_wt_df)
}

get_urban_df <- function(demo_df) {
	urban_wt_df <- demo_df %>%
		dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP,
			urban, rural) %>%
		pivot_longer(cols = c('urban', 'rural'), names_to = "Geography",
			values_to = 'count') %>%
		pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario",
			values_to = 'pm')
	urban_wt_df$scenario <- ifelse(urban_wt_df$scenario == 'X2017', '2017', 
		ifelse(urban_wt_df$scenario == 'NZ2050RCP', 'NZ2050RCP8.5', urban_wt_df$scenario))
	urban_wt_df <- mutate(urban_wt_df, 
		scenario = fct_relevel(scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
	urban_wt_df$Geography <- ifelse(urban_wt_df$Geography == 'urban', 'Urban', 'Rural')
	return(urban_wt_df)
}

calc_freq_median <- function(values, frequencies) {
  # Check if inputs are valid
  if (length(values) != length(frequencies)) {
    stop("The length of values and frequencies must be the same.")
  }
  if (any(frequencies < 0)) {
    stop("Frequencies must be non-negative.")
  }
 
  # highly critical step of sorting to ensure cumsum picks the right
  # midpoint
  sort_df <- data.frame(values, frequencies) %>%
	arrange(values)
  values <- sort_df$values
  frequencies <- sort_df$frequencies

  # Calculate cumulative frequencies
  cumulative_freq <- cumsum(frequencies)
  total <- sum(frequencies)

  # Find the position of the median
  median_position <- (total + 1) / 2

  # Find the interval containing the median
  median_interval <- which(cumulative_freq >= median_position)[1]

  # Calculate the median
  if (median_interval > 1) {
    lower_bound <- values[median_interval - 1]
    freq_before <- cumulative_freq[median_interval - 1]
  } else {
    lower_bound <- values[1]
    freq_before <- 0
  }

  median_value <- lower_bound + 
    (median_position - freq_before) / frequencies[median_interval] * 
    (values[median_interval] - lower_bound)

  return(median_value)
}


get_disp_numbers <- function(input_df, df_type) {
	input_df <- dplyr::rename(input_df, strata = any_of(df_type))
	input_df2 <- input_df[complete.cases(input_df),]
	input_df2 <- input_df2 %>%
		group_by(strata, scenario) %>%
		summarize(median = calc_freq_median(values = pm, frequencies = count)) %>%
		ungroup() %>%
		group_by(scenario) %>%
		summarize(med_diff = abs(diff(median)))
	return(input_df2)
}

get_plotlist <- function(pol_df, pol_type) {
	demo_df <- get_demo_df(pol_df)
	urban_df <- get_urban_df(demo_df)
	race_df <- get_race_df(demo_df)
	income_df <- get_income_df(demo_df)

	race_disp <- get_disp_numbers(race_df, 'race')
	urban_disp <- get_disp_numbers(urban_df, 'Geography')
	income_disp <- get_disp_numbers(income_df, 'income')

race_df$scenario <- ifelse(race_df$scenario == 'REF2050', 'Reference',
	ifelse(race_df$scenario == 'NZ2050', 'Net Zero', 
		ifelse(race_df$scenario == '2017', '2017', 'Net Zero Hot')))

urban_df$scenario <- ifelse(urban_df$scenario == 'REF2050', 'Reference',
	ifelse(urban_df$scenario == 'NZ2050', 'Net Zero', 
		ifelse(urban_df$scenario == '2017', '2017', 'Net Zero Hot')))

income_df$scenario <- ifelse(income_df$scenario == 'REF2050', 'Reference',
	ifelse(income_df$scenario == 'NZ2050', 'Net Zero', 
		ifelse(income_df$scenario == '2017', '2017', 'Net Zero Hot')))

race_disp$scenario <- ifelse(race_disp$scenario == 'REF2050', 'Reference',
	ifelse(race_disp$scenario == 'NZ2050', 'Net Zero', 
		ifelse(race_disp$scenario == '2017', '2017', 'Net Zero Hot')))

urban_disp$scenario <- ifelse(urban_disp$scenario == 'REF2050', 'Reference',
	ifelse(urban_disp$scenario == 'NZ2050', 'Net Zero', 
		ifelse(urban_disp$scenario == '2017', '2017', 'Net Zero Hot')))

income_disp$scenario <- ifelse(income_disp$scenario == 'REF2050', 'Reference',
	ifelse(income_disp$scenario == 'NZ2050', 'Net Zero', 
		ifelse(income_disp$scenario == '2017', '2017', 'Net Zero Hot')))

	race_df$scenario <- fct_relevel(race_df$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')
	urban_df$scenario <- fct_relevel(urban_df$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')
	income_df$scenario <- fct_relevel(income_df$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')
	
	race_disp$scenario <- fct_relevel(race_disp$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')
	urban_disp$scenario <- fct_relevel(urban_disp$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')
	income_disp$scenario <- fct_relevel(income_disp$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')



	gg_urban <- ggplot(urban_df) +
		geom_boxplot(aes(x = scenario, y = pm, weight = count, col = fct_relevel(Geography, 'Urban', 'Rural')), outliers = FALSE) +
		theme_bw() +
		xlab('') + ylab('') +
		scale_color_manual(name = 'Geography', values = c('#1b9e77', '#d95f02'))


	gg_income <- ggplot(income_df) +
		geom_boxplot(aes(x = scenario, y = pm, weight = count, col = income), outliers = FALSE) +
		theme_bw() +
		xlab('') + ylab('') +
		scale_color_manual(name = 'Income', values = c('#7570b3', '#e7298a'))


	gg_race <- ggplot(race_df) +
		geom_boxplot(aes(x = scenario, y = pm, weight = count, col = race), outliers = FALSE) +
		theme_bw() +
		xlab('') + ylab('') +
		scale_color_manual(name = 'Race', values = c('#66a61e', '#e6ab02'))


	if (pol_type == 'pm') {
		gg_race <- gg_race +
			ylab(bquote('PM2.5 '(μg/m^3))) +
			annotate("text", x = 1, y = 1, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 1, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 1, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 1, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'A')
		gg_urban <- gg_urban +
			annotate("text", x = 1, y = 1, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 1, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 1, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 1, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'C')
		gg_income <- gg_income +
			annotate("text", x = 1, y = 1, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 1, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 1, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 1, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'B')

	}

	if (pol_type == 'ozone') {
		gg_race <- gg_race + 
			ylab('Ozone (ppb)') +
			annotate("text", x = 1, y = 15, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 15, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 15, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 15, label = as.character(sprintf('%.1f', round(filter(race_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'D')
		gg_urban <- gg_urban +
			annotate("text", x = 1, y = 15, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 15, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 15, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 15, label = as.character(sprintf('%.1f', round(filter(urban_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'F')
		gg_income <- gg_income +
			annotate("text", x = 1, y = 15, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == '2017')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 2, y = 15, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Reference')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 3, y = 15, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Net Zero')$med_diff, 1))),
				col = 'Black', size = 3) +
			annotate("text", x = 4, y = 15, label = as.character(sprintf('%.1f', round(filter(income_disp, scenario == 'Net Zero Hot')$med_diff, 1))),
				col = 'Black', size = 3) +
			labs(tag = 'E')
	}


	return(list(gg_race, gg_income, gg_urban))
}

pm_plots <- get_plotlist(pm, pol_type = 'pm')
oz_plots <- get_plotlist(oz, pol_type = 'ozone')
all_plots <- c(pm_plots, oz_plots)

jpeg(paste0(plot_dir, '/fig4_', Sys.Date(), '.jpg'), width = 16, height = 9, quality = 1, units = 'in', res = 300)
print(ggarrange(plotlist = all_plots))
dev.off()
