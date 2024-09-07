#!/bin/csh -f
#SBATCH --export=NONE

#PBS -N cmv12
#PBS -A URTG0029
#PBS -l walltime=12:00:00
#PBS -q regular
#PBS -j oe
#PBS -k eod
#PBS -m abe
##PBS -M pengfeiwang@psu.edu
#PBS -l select=1:ncpus=36:mpiprocs=36:ompthreads=36

limit stacksize unlimited

setenv SECTOR "cmv_c1c2_12"

if ($?SLURM_SUBMIT_DIR) then
  cd $SLURM_SUBMIT_DIR
endif

## Definitions for case name, directory structures, etc, that are used
#  by every sector in the case
#  Anything defined in directory_definitions can be overridden here 
#  if desired
source ../directory_definitions.csh

## Months for emissions processing, and spinup duration
#  In the EPA emissions modeling platforms, the only sectors that use
#    SPINUP_DURATION are biogenics and the final sector merge (Mrggrid).
#  Elsewhere, SPINUP_DURATION = 0, and when Mrggrid runs for spinup days,
#    base year emissions are used for the spinup year for all sectors except
#    biogenics.
#  Effective Jan 2019, SPINUP_DURATION now should work for all months.
#  SPINUP_MONTH_END (new for Jan 2019) specifies whether the last $SPINUP_DURATION 
#    days of quarter 2/3/4 should be run at the end of a quarter (Y), or at the start 
#    of the next quarter (N). For example, if runningwith SPINUP_DURATION = 10:
#    When N (old behavior), Q1 will include 10 day spinup and end on 3/21; Q2 will
#    cover 3/22 through 6/20. When Y, Q1 will include 10 day spinup and end on 3/31
#    (including all of March), remaining quarters will function as if spinup = 0.
setenv RUN_MONTHS "1 4 7 10" # 2 3 4 5 6 7 8 9 10 11 12"
setenv SPINUP_DURATION "0"
setenv SPINUP_MONTH_END "Y"

## Emissions modeling year
#  (i.e. meteorological year, not necessarily the inventory year"
setenv BASE_YEAR "2017"
setenv EPI_STDATE_TIME "${BASE_YEAR}-01-01 00:00:00.0"
setenv EPI_ENDATE_TIME "${BASE_YEAR}-12-31 23:59:00.0"

## Inventory case name, if inventories are coming from a different case (they usually aren't)
#  CASEINPUTS is defined in directory_definitions and optionally overridden here
#setenv INVENTORY_CASE "2011ek_cb6v2_v6_11g"
#setenv CASEINPUTS "$INSTALL_DIR/$INVENTORY_CASE/inputs"

## Inputs for all sectors
setenv AGREF "${GE_DAT}/gridding/agref_us_2017platform_24apr2020_nf_v2.txt"
setenv ARTOPNT "${GE_DAT}/artopnt_2002detroit_20aug2019_v2.txt"
setenv ATPRO_HOURLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_hourly_6nov2014_24jul2017_v5"
setenv ATPRO_HOURLY_NCF "${GE_DAT}/temporal/Gentpro_TPRO_HOUR_HOURLY_BASH_NH3.agNH3_bash_17j_12US1_smk37_newFIPS.ncf"
setenv ATPRO_MONTHLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_monthly_6nov2014_30nov2018_nf_v9"
setenv ATPRO_WEEKLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_weekly_6nov2014_09sep2016_v2"
setenv ATREF "${GE_DAT}/temporal/amptref_general_2017platform_21apr2020_nf_v2"
setenv COSTCY "${GE_DAT}/costcy_for_2017platform_24apr2020_nf_v1.txt"
setenv EFTABLES "$CASEINPUTS/onroad/eftables_aq/rateperdistance_smoke_aq_cb6_saprc_1Aug2019_2017v1nei-20191228_1049_1.csv"
setenv GRIDDESC "${GE_DAT}/gridding/griddesc_lambertonly_18jan2019_v7.txt"
setenv GSCNV "${GE_DAT}/speciation/gscnv_CB6R3_AE7_Spec_5_0_27mar2020_nf_v1.txt"
#setenv GSPROTMP_A "${GE_DAT}/speciation/gspro_cmaq_cb6ae7_2017gb_17j_01may2020.txt"
setenv GSREFTMP_A "${GE_DAT}/speciation/gsref_cmaq_cb6ae7_2017gb_17j_nf.txt"
setenv HOLIDAYS "${GE_DAT}/temporal/holidays_13feb2017_v1.txt"
setenv INVTABLE "${GE_DAT}/invtable_2014platform_integrate_21dec2018_v3.txt"
setenv MRGDATE_FILES "$INSTALL_DIR/smoke4.7/scripts/smk_dates/2017/smk_merge_dates_201701.txt"
setenv MTPRO_HOURLY "${GE_DAT}/temporal/mtpro_hourly_MOVES_2014v2_15jan2020_nf_v1"
setenv MTPRO_MONTHLY "${GE_DAT}/temporal/mtpro_monthly_MOVES_03aug2016_v1"
setenv MTPRO_WEEKLY "${GE_DAT}/temporal/mtpro_weekly_MOVES_2014v2_15jan2020_nf_v1"
setenv MTREF "${GE_DAT}/temporal/mtref_onroad_MOVES_2017NEI_16jan2020_nf_v1"
setenv NAICSDESC "${GE_DAT}/smkreport/naicsdesc_02jan2008_v0.txt"
setenv ORISDESC "${GE_DAT}/smkreport/orisdesc_04dec2006_v0.txt"
setenv PELVCONFIG "${GE_DAT}/point/pelvconfig_elevate_everything_17apr2020_v0.txt"
setenv PSTK "${GE_DAT}/point/pstk_13nov2018_v1.txt"
setenv PTPRO_HOURLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_hourly_6nov2014_24jul2017_v5"
setenv PTPRO_MONTHLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_monthly_6nov2014_30nov2018_nf_v9"
setenv PTPRO_WEEKLY "${GE_DAT}/temporal/amptpro_general_2011platform_tpro_weekly_6nov2014_09sep2016_v2"
setenv PTREF "${GE_DAT}/temporal/amptref_general_2017platform_21apr2020_nf_v2"
#setenv REPCONFIG_GRID "${GE_DAT}/smkreport/repconfig/repconfig_area_inv_grid_2016beta_07feb2019_v0.txt"
#setenv REPCONFIG_INV "${GE_DAT}/smkreport/repconfig/repconfig_area_inv_2016beta_07feb2019_v0.txt"
setenv SCCDESC "${GE_DAT}/smkreport/sccdesc_2014platform_21apr2020_nf_v5.txt"
setenv SECTORLIST "$CASESCRIPTS/sectorlist_2017gb"
setenv SRGDESC "${GE_DAT}/gridding/srgdesc_CONUS12_2017NEI_17dec2019_29apr2020_v1.txt"
setenv SRGPRO "${GE_DAT}/gridding/surrogates/CONUS12_2017NEI_18mar2020/USA_100_NOFILL.txt"

# Inputs specific to this sector
setenv GSPROTMP_A "${GE_DAT}/speciation/gspro_cmv_c1c2_12_cmaq_cb6ae7_2017gb_17j_01may2020.txt"
setenv REPCONFIG_GRID "${GE_DAT}/smkreport/repconfig/repconfig_point_invgrid_2011platform_11aug2014_v0.txt"
setenv REPCONFIG_INV2 "${GE_DAT}/smkreport/repconfig/repconfig_point_inv_nonhapvocprof_2016beta_07feb2019_v0.txt"
setenv EMISINV_C "${CASEINPUTS}/cmv_c1c2/canada_c1c2_point_2015_aisremoved_07aug2019_v0.csv"
setenv REPCONFIG_TEMP "${GE_DAT}/smkreport/repconfig/repconfig_point_temporal_2016beta_07feb2019_v0.txt"
setenv REPCONFIG_INV "${GE_DAT}/smkreport/repconfig/repconfig_point_inv_2016beta_07feb2019_v0.txt"
setenv EMISINV_A "${CASEINPUTS}/cmv_c1c2/cmv_c1c2_2017adjust_20200422_12US1_2017_US_annual_22apr2020_v0.csv"
setenv EMISINV_B "${CASEINPUTS}/cmv_c1c2/cmv_c1c2_2017adjust_20200422_12US1_2017_CA_annual_22apr2020_v0.csv"
setenv EMISHOUR_MULTI_A "${CASEINPUTS}/cmv_c1c2/cmv_c1c2_2017adjust_20200422_12US1_2017_10_CA_hourly.csv"

# Parameters for all sectors
setenv FILL_ANNUAL "N"
setenv FULLSCC_ONLY "Y"
setenv INLINE_MODE "off"
setenv IOAPI_ISPH "20"
#setenv L_TYPE "mwdss"
#setenv M_TYPE "mwdss"
setenv MRG_MARKETPEN_YN "N"
setenv MRG_REPCNY_YN "Y"
setenv MRG_REPSTA_YN "N"
setenv MTMP_OUTPUT_YN "N"
setenv NO_SPC_ZERO_EMIS "Y"
setenv OUTPUT_FORMAT "$EMF_AQM"
setenv OUTZONE "0"
setenv PLATFORM "v8"
setenv POLLUTANT_CONVERSION "Y"
setenv RAW_DUP_CHECK "N"
#setenv RENORM_TPROF "Y"
setenv REPORT_DEFAULTS "Y"
#setenv RUN_HOLIDAYS "Y"
setenv RUN_PYTHON_ANNUAL "Y"
setenv SMKINVEN_FORMULA "PMC=PM10-PM2_5"
setenv SMKMERGE_CUSTOM_OUTPUT "Y"
setenv SMK_AVEDAY_YN "N"
setenv SMK_DEFAULT_SRGID "100"
setenv SMK_MAXERROR "10000"
setenv SMK_MAXWARNING "10"
setenv SMK_PING_METHOD "0"
setenv SMK_SPECELEV_YN "N"
setenv SPC "$EMF_SPC"
setenv SPINUP_MONTH_END "Y"
setenv WEST_HSPHERE "Y"

# Sector-specific parameters
setenv USE_FF10_HOURLY_POINT "N"
setenv OUTPUT_LOCAL_TIME "Y"
setenv USE_FF10_DAILY_POINT "N"
setenv DAY_SPECIFIC_YN "N"
setenv WRITE_ANN_ZERO "Y"
setenv SMK_PROCESS_HAPS "ALL"
setenv NONHAP_TYPE "VOC"
setenv ZIPOUT "Y"
setenv NAMEBREAK_HOURLY "cmv"
setenv M_TYPE "all"
setenv L_TYPE "all"
setenv RUN_HOLIDAYS "N"
setenv RENORM_TPROF "N"

$RUNSCRIPTS/emf/smk_pt_annual_onetime_emf.csh $REGION_ABBREV $REGION_IOAPI_GRIDNAME onetime
