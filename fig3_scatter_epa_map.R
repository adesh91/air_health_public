# set up environment
libs <- c('viridis', 'tidycensus', 'raster', 'sf', 'tidyverse', 'exactextractr', 'ggridges', 'forcats', 'ggpubr', 
	'ggrepel', 'gridExtra')
lapply(libs, library, character.only = TRUE)

data_dir <- c('/Users/ani/Documents/phd/research/scovronick/air_health/data/')
plot_dir <- c('/Users/ani/Documents/phd/research/scovronick/air_health/plots/')
# read in data
## exposure
pm <- read.csv(paste0(data_dir, 'county_PM2.5.csv'))

# epa regions
states_epa <- read.csv(paste0(data_dir, 'states_epa.csv'))

demo <- get_acs(variables = c('B01003_001'
	), 
	year = 2017, geography = 'county')

demo_df <- demo %>%
	dplyr::select(-moe, -variable) %>%
	mutate(GEOID = as.numeric(GEOID)) %>%
	left_join(dplyr::select(pm, STNAME, GEOID = FIPS)) %>%
	left_join(states_epa)

demo_sf <- get_acs(variables = c('B01003_001'), 
	year = 2017, geography = 'county', geometry = TRUE)
demo_sf$GEOID <- as.numeric(demo_sf$GEOID)

demo_sf <- left_join(demo_sf, demo_df)

epa_map <- ggplot(filter(demo_sf, !is.na(EPA))) +
	geom_sf(aes(fill = as.factor(EPA)), lwd = 0) +
	# annotate("rect", xmin = -72.5, xmax = -71.5, ymin = 42, ymax = 43,fill = "white") +
	# annotate("text", y = 42.5, x = -72, label = "1", col = 'Black', size = 3) +
	# annotate("rect", xmin = -75.5, xmax = -74.5, ymin = 42, ymax = 43,fill = "white") +
	# annotate("text", y = 42.5, x = -75, label = "2", col = 'Black', size = 3) +
	# annotate("rect", xmin = -79, xmax = -78, ymin = 39.5, ymax = 40.5,fill = "white") +
	# annotate("text", y = 40, x = -78.5, label = "3", col = 'Black', size = 3) +
	# annotate("rect", xmin = -84.5, xmax = -83.5, ymin = 33, ymax = 34, fill = "white") +
	# annotate("text", y = 33.5, x = -84, label = "4", col = 'Black', size = 3) +
	# annotate("rect", xmin = -86.5, xmax = -85.5, ymin = 39.5, ymax = 40.5, fill = "white") +
	# annotate("text", y = 40, x = -86, label = "5", col = 'Black', size = 3) +
	# annotate("rect", xmin = -97.5, xmax = -96.5, ymin = 33, ymax = 34, fill = "white") +
	# annotate("text", y = 33.5, x = -97, label = "6", col = 'Black', size = 3) +
	# annotate("rect", xmin = -97.5, xmax = -96.5, ymin = 39.5, ymax = 40.5, fill = "white") +
	# annotate("text", y = 40, x = -97, label = "7", col = 'Black', size = 3) +
	# annotate("rect", xmin = -106.5, xmax = -105.5, ymin = 44.5, ymax = 45.5, fill = "white") +
	# annotate("text", y = 45, x = -106, label = "8", col = 'Black', size = 3) +
	# annotate("rect", xmin = -117.5, xmax = -116.5, ymin = 34.5, ymax = 35.5, fill = "white") +
	# annotate("text", y = 35, x = -117, label = "9", col = 'Black', size = 3) +
	# annotate("rect", xmin = -117.5, xmax = -116.5, ymin = 44.5, ymax = 45.5, fill = "white") +
	# annotate("text", y = 45, x = -117, label = "10", col = 'Black', size = 3) +
	theme(legend.position = 'none') +
	scale_fill_manual(name = 'EPA Regions',
		values = c('#c73737', '#32caac', '#56d400', '#2a29fe', '#ac36c9',
		'#666666', '#fed42a', '#a0892c' ,'#ff6600', '#008081')) +
	coord_sf() +
	theme_bw() +
	theme(legend.position = 'none', axis.text = element_blank(), axis.ticks = element_blank()) +
	xlab('') + ylab('') + ggtitle('Legend')

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
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
	left_join(dplyr::select(pm, STNAME, GEOID = FIPS, X2017, REF2050, NZ2050, NZ2050RCP)) %>%
	mutate(non_hispanic = total - hispanic) %>%
	mutate(race_cat = ifelse(black/total > 0.67, 'Black',
		ifelse(white/total > 0.67, 'White', 'Mixed'))) %>% 
	left_join(states_epa) %>%
	left_join(urban_pct) %>%
	mutate(POPPCT_URB = as.numeric(substr(POPPCT_URB, 1, 4))/100) %>%
	mutate(urban = total*POPPCT_URB, rural = total - urban)

demo_df_abs <- demo_df %>%
	mutate(REF2050 = X2017 - REF2050, NZ2050 = X2017 - NZ2050, NZ2050RCP = X2017 - NZ2050RCP)
pm_rel_red <- demo_df %>%
	mutate(REF2050 = (X2017 - REF2050)/X2017, NZ2050 = (X2017 - NZ2050)/X2017,
	 NZ2050RCP = (X2017 - NZ2050RCP)/X2017)

#### Absolute Change
race_wt_df_abs <- pm_rel_red %>%
	dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP,
		white, black, total, EPA) %>%
	pivot_longer(cols = c('white', 'black', 'total'), names_to = "race",
		values_to = 'count') %>%
	pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario",
		values_to = 'pm')
race_wt_df_abs$scenario <- ifelse(race_wt_df_abs$scenario == 'X2017', '2017', 
	ifelse(race_wt_df_abs$scenario == 'NZ2050RCP', 'NZ2050RCP8.5', race_wt_df_abs$scenario))
race_wt_df_abs <- mutate(race_wt_df_abs, 
	scenario = fct_relevel(scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
race_wt_df_abs$race <- ifelse(race_wt_df_abs$race == 'white', 'White',
	ifelse(race_wt_df_abs$race == 'black', 'Black', 'Total'))
race_wt_df_abs$race <- fct_relevel(race_wt_df_abs$race, 'Black', 'White', 'Total')
race_wt_df_abs <- race_wt_df_abs %>%
	group_by(race, STNAME, EPA, scenario) %>%
	summarize(pm = weighted.mean(x = pm, w = count, na.rm = TRUE))

race_wt_df_abs_17 <- filter(race_wt_df_abs, scenario == '2017') %>%
 	rename(x2017 = pm) %>%
 	dplyr::select(-scenario)

race_wt_df_abs <- left_join(filter(race_wt_df_abs, scenario != '2017'), race_wt_df_abs_17)

race_wt_df_abs_rename <- race_wt_df_abs
race_wt_df_abs_rename$scenario <- ifelse(race_wt_df_abs_rename$scenario == 'REF2050', 'Reference',
	ifelse(race_wt_df_abs_rename$scenario == 'NZ2050', 'Net Zero', 'Net Zero Hot'))
race_wt_df_abs_rename$scenario <- fct_relevel(race_wt_df_abs_rename$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')

gg1 <- ggplot(filter(race_wt_df_abs_rename, race == 'Total', !is.na(EPA))) +
	geom_point(aes(x = x2017, y = pm*100, col = as.factor(EPA))) +
	geom_text_repel(data = filter(race_wt_df_abs_rename, race == 'Total', STNAME %in% c('Missouri', 'Georgia',
		'California')),
	aes(x = x2017, y = pm*100, label = STNAME), max.overlaps = 500) +
	facet_wrap(. ~ scenario) +
	xlab(bquote('PM2.5 in 2017 '(μg/m^3))) +
	ylab('Reduction in PM2.5 (%)') +
	theme_bw() +
	scale_color_manual(name = 'EPA Regions',
		values = c('#c73737', '#32caac', '#56d400', '#2a29fe', '#ac36c9',
		'#666666', '#fed42a', '#a0892c' ,'#ff6600', '#008081')) +
	# geom_abline(slope = 1, intercept = 0, col = 'black', linetype = 'dashed') +
	# xlim(0, 12.3) + ylim(0, 12.3) +
	theme(legend.position = 'none') +
	labs(tag = 'A')

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
pm <- read.csv(paste0(data_dir, 'ozone_summer.csv'))

demo_df <- left_join(demo, var_df) %>%
	dplyr::select(-moe, -variable) %>%
	pivot_wider(names_from = var_name, values_from = estimate) %>%
	mutate(GEOID = as.numeric(GEOID)) %>%
	left_join(dplyr::select(pm, STNAME, GEOID = FIPS, X2017, REF2050, NZ2050, NZ2050RCP)) %>%
	mutate(non_hispanic = total - hispanic) %>%
	mutate(race_cat = ifelse(black/total > 0.67, 'Black',
		ifelse(white/total > 0.67, 'White', 'Mixed'))) %>% 
	left_join(states_epa) %>%
	left_join(urban_pct) %>%
	mutate(POPPCT_URB = as.numeric(substr(POPPCT_URB, 1, 4))/100) %>%
	mutate(urban = total*POPPCT_URB, rural = total - urban)

demo_df_abs <- demo_df %>%
	mutate(REF2050 = X2017 - REF2050, NZ2050 = X2017 - NZ2050, NZ2050RCP = X2017 - NZ2050RCP)
oz_rel_red <- demo_df %>%
	mutate(REF2050 = (X2017 - REF2050)/X2017, NZ2050 = (X2017 - NZ2050)/X2017,
	 NZ2050RCP = (X2017 - NZ2050RCP)/X2017)

#### Absolute Change
race_wt_df_abs <- oz_rel_red %>%
	dplyr::select(GEOID, NAME, STNAME, X2017, REF2050, NZ2050, NZ2050RCP,
		white, black, total, EPA) %>%
	pivot_longer(cols = c('white', 'black', 'total'), names_to = "race",
		values_to = 'count') %>%
	pivot_longer(cols = c('X2017', 'REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario",
		values_to = 'pm')
race_wt_df_abs$scenario <- ifelse(race_wt_df_abs$scenario == 'X2017', '2017', 
	ifelse(race_wt_df_abs$scenario == 'NZ2050RCP', 'NZ2050RCP8.5', race_wt_df_abs$scenario))
race_wt_df_abs <- mutate(race_wt_df_abs, 
	scenario = fct_relevel(scenario, '2017', 'REF2050', 'NZ2050', 'NZ2050RCP8.5'))
race_wt_df_abs$race <- ifelse(race_wt_df_abs$race == 'white', 'White',
	ifelse(race_wt_df_abs$race == 'black', 'Black', 'Total'))
race_wt_df_abs$race <- fct_relevel(race_wt_df_abs$race, 'Black', 'White', 'Total')
race_wt_df_abs <- race_wt_df_abs %>%
	group_by(race, STNAME, EPA, scenario) %>%
	summarize(pm = weighted.mean(x = pm, w = count, na.rm = TRUE))

race_wt_df_abs_17 <- filter(race_wt_df_abs, scenario == '2017') %>%
 	rename(x2017 = pm) %>%
 	dplyr::select(-scenario)

race_wt_df_abs <- left_join(filter(race_wt_df_abs, scenario != '2017'), race_wt_df_abs_17)

race_wt_df_abs_rename <- race_wt_df_abs
race_wt_df_abs_rename$scenario <- ifelse(race_wt_df_abs_rename$scenario == 'REF2050', 'Reference',
	ifelse(race_wt_df_abs_rename$scenario == 'NZ2050', 'Net Zero', 'Net Zero Hot'))
race_wt_df_abs_rename$scenario <- fct_relevel(race_wt_df_abs_rename$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')

gg2 <- ggplot(filter(race_wt_df_abs_rename, race == 'Total', !is.na(EPA))) +
	geom_point(aes(x = x2017, y = pm*100, col = as.factor(EPA))) +
	geom_text_repel(data = filter(race_wt_df_abs_rename, race == 'Total', STNAME %in% c('Missouri', 'Georgia',
		'California')),
	aes(x = x2017, y = pm*100, label = STNAME), max.overlaps = 500) +
	facet_wrap(. ~ scenario) +
	xlab('Ozone in 2017 (ppb)') +
	ylab('Reduction in Ozone (%)') +
	theme_bw() +
	scale_color_manual(name = 'EPA Regions',
		values = c('#c73737', '#32caac', '#56d400', '#2a29fe', '#ac36c9',
		'#666666', '#fed42a', '#a0892c' ,'#ff6600', '#008081')) +
	# geom_abline(slope = 1, intercept = 0, col = 'black', linetype = 'dashed') +
	# xlim(0, 12.3) + ylim(0, 12.3) +
	theme(legend.position = 'none') +
	labs(tag = 'B')

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################


pm_rel_red2 <- dplyr::select(pm_rel_red, REF2050, NZ2050, NZ2050RCP, total, EPA, STNAME) %>%
	pivot_longer(cols = c('REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario", values_to = 'pm') %>%
	group_by(STNAME, EPA, scenario) %>%
	summarize(pm = weighted.mean(x = pm, w = total))

oz_rel_red2 <- dplyr::select(oz_rel_red, REF2050, NZ2050, NZ2050RCP, total, EPA, STNAME) %>%
	pivot_longer(cols = c('REF2050', 'NZ2050', 'NZ2050RCP'), names_to = "scenario", values_to = 'oz') %>%
	group_by(STNAME, EPA, scenario) %>%
	summarize(oz = weighted.mean(x = oz, w = total))

pol_rel_red <- left_join(pm_rel_red2, oz_rel_red2) %>%
	mutate(scenario = fct_relevel(scenario, 'REF2050', "NZ2050", 'NZ2050RCP'))

pol_rel_red_rename <- pol_rel_red
pol_rel_red_rename$scenario <- ifelse(pol_rel_red_rename$scenario == 'REF2050', 'Reference',
	ifelse(pol_rel_red_rename$scenario == 'NZ2050', 'Net Zero', 'Net Zero Hot'))
pol_rel_red_rename$scenario <- fct_relevel(pol_rel_red_rename$scenario, '2017', 'Reference', 'Net Zero', 'Net Zero Hot')


gg3 <- ggplot(filter(pol_rel_red_rename, !is.na(EPA))) +
	geom_vline(xintercept = 0) +
	geom_hline(yintercept = 0) +
	geom_abline(slope = 1, intercept = 0, linetype = 'dashed') +
	geom_point(aes(x = pm*100, y = oz*100, col = as.factor(EPA))) +
	geom_text_repel(data = filter(pol_rel_red_rename, STNAME %in% c('Missouri', 'Georgia',
		'California')),
		aes(x = pm*100, y = oz*100, label = STNAME), max.overlaps = 500) +
	theme_bw() +
	scale_color_manual(name = 'EPA Regions',
		values = c('#c73737', '#32caac', '#56d400', '#2a29fe', '#ac36c9',
		'#666666', '#fed42a', '#a0892c' ,'#ff6600', '#008081')) +
	xlab('Reduction in PM2.5 (%)') + 
	ylab('Reduction in Ozone (%)') +
	facet_wrap(. ~ scenario) +
	ylim(-7.5, 42.5) + xlim(-7.5, 42.5) +
	theme(legend.position = 'none') +
	labs(tag = 'C')

# gg1 <- gg1 + ylim(NA, NA)
# gg2 <- gg2 + ylim(NA, NA) 

jpeg(paste0(plot_dir, '/fig3_', Sys.Date(), '.jpg'), width = 16, height = 9, quality = 1, units = 'in', res = 300)
print(
	grid.arrange(
  	grobs = list(gg1, gg2, gg3, epa_map),
  	layout_matrix = rbind(c(1, 1, 2, 2), c(1, 1, 2, 2), c(3, 3, 4, 5), c(3, 3, 6, 7))
	)
)
dev.off()