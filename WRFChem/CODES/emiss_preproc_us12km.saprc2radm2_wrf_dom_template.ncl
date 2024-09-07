load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"



yy = (/ "2017" /)
mm = (/ "01"/)
dd = (/ "01", "01","03"/)
date = yy+mm+dd
vars = (/ "CO","NO","NO2","SO2","NH3","ACET","ALK1","ALK2","ALK3","ALK4","ALK5","ARO1","ARO2","BACL","BALD","CCHO","CCO_OH","CRES","ETHENE","GLY","HCHO","HCOOH","IPROD","ISOPRENE","MACR","MEK","MEOH","MGLY","NR","OLE1","OLE2","PHEN","PROD2","RCHO","RCO_OH","TRP1","PEC","POC","PSO4","PNO3","PNH4","PMFINE","PMC","PNA","PCL","PMOTHR","PAL","PCA","PFE","PK","PH2O","PMG","PMN","PSI","PTI","PNCOM" /)

print(vars)

;ntime = 25
nvar  = dimsizes(vars)
print (nvar)
print("nvar is obtain above")
ndate   = dimsizes(date)

do n = 0, ndate-1

  layer1FileRaw = "emis_mole_all_"+ date(n)+"_12US1_nobeis_withrwc_2017gb_17j.ncf"


wrfgrid = addfile("wrfdomain.nc","r")

wrflat = wrfgrid->XLAT(0,:,:)
wrflon = wrfgrid->XLONG(0,:,:)

wrflonmin = min(wrflon)
wrflonmax = max(wrflon)
wrflatmin = min(wrflat)
wrflatmax = max(wrflat)

wrfdim = dimsizes(wrflat)
nrow_wrf = wrfdim(0)
ncol_wrf = wrfdim(1)
print(nrow_wrf)
print(ncol_wrf)
WRF_grid_area = (wrfgrid@DX * wrfgrid@DY) / 1e6 ; km^2

print("area emissions interpolation")


in = addfile(layer1FileRaw, "r")
dSizes = getfiledimsizes(in)  
   print (dSizes)
ntime=dSizes(0)
nlay_emis= dSizes(2)
print(nlay_emis)
nrow_emis=dSizes(4)
ncol_emis=dSizes(5)
print(nrow_emis)
print(ncol_emis)
;area = new( (/ ntime,nlay_emis, nrow_emis, ncol_emis, nvar /), "float", "No_FillValue" )
area = new( (/ ntime,nlay_emis, nrow_wrf, ncol_wrf, nvar /), "float", "No_FillValue" )
area!0 = "TSTEP"
area!1 = "LAY"
area!2 = "ROW"
area!3 = "COL"
area!4 = "VAR"

do l = 0, nvar - 1
  if (isfilevar(in, vars(l))) then
    dat = in->$vars(l)$(:,:,:,:)
;datdim = dimsizes(dat)
;print(datdim(0))
;print(datdim(1))
;print(datdim(2))
  area(:,:,3:nrow_wrf-1,14:ncol_wrf-1,l) = area(:,:,3:nrow_wrf-1,14:ncol_wrf-1,l) + dat(:,:,0:nrow_wrf-4,0:ncol_wrf-15) 
    delete(dat)
    print("done with "+vars(l))
  end if
end do


; all area CO is anthropogenic CO
;area(:,:,:,ind(vars .eq. "CO_A")) = area(:,:,:,ind(vars .eq. "CO"))


; fill missing values with zeros
area = where(ismissing(area), 0.0, area)


nvarout=42
outvars  = new( nvarout, "string", "No_FillValue" )

out       = new( (/ ntime, nlay_emis,  nrow_wrf, ncol_wrf, nvarout /), "float", "No_FillValue" )
out!0      = "TSTEP"
out!1      = "LAY"
out!2      = "ROW"
out!3      = "COL"
out!4      = "VAR"

out(:,:,:,:,:) = 0.0

i=0
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "CO"))
outvars(i)     = "E_CO"
i=i+1

out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ISOPRENE"))
outvars(i)     = "E_ISO"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "NO"))
outvars(i)     = "E_NO"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "NO2"))
outvars(i)     = "E_NO2"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "SO2"))
outvars(i)     = "E_SO2"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "NH3"))
outvars(i)     = "E_NH3"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ALK1"))
outvars(i)     = "E_ETH"

i=i+1
out(:,:,:,:,i) = 0.6*area(:,:,:,:,ind(vars .eq. "ALK2"))+ area(:,:,:,:,ind(vars .eq. "ALK3")) +0.402*area(:,:,:,:,ind(vars .eq. "MEOH"))
outvars(i)     = "E_HC3"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ALK4"))+0.956*area(:,:,:,:,ind(vars .eq. "PROD2"))
outvars(i)     = "E_HC5"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ALK5"))+0.5*area(:,:,:,:,ind(vars .eq. "ARO1"))
outvars(i)     = "E_HC8"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ARO2"))
outvars(i)     = "E_XYL"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "ETHENE"))
outvars(i)     = "E_OL2"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "OLE1"))
outvars(i)     = "E_OLT"

i=i+1
out(:,:,:,:,i) = 0.5*area(:,:,:,:,ind(vars .eq. "OLE2"))+area(:,:,:,:,ind(vars .eq. "TRP1"))
outvars(i)     = "E_OLI"

i=i+1
out(:,:,:,:,i) = 0.5*area(:,:,:,:,ind(vars .eq. "ARO1"))+0.5*area(:,:,:,:,ind(vars .eq. "OLE2"))
outvars(i)     = "E_TOL"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "PHEN")) + area(:,:,:,:,ind(vars .eq. "CRES"))
outvars(i)     = "E_CSL"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "HCHO"))
outvars(i)     = "E_HCHO"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "CCHO"))+area(:,:,:,:,ind(vars .eq. "RCHO"))
outvars(i)     = "E_ALD"

i=i+1
out(:,:,:,:,i) = 0.253*area(:,:,:,:,ind(vars .eq. "ACET"))+area(:,:,:,:,ind(vars .eq. "MEK"))
outvars(i)     = "E_KET"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "HCOOH"))
outvars(i)     = "E_ORA1"

i=i+1
out(:,:,:,:,i) = 0.4*area(:,:,:,:,ind(vars .eq. "ALK2"))+area(:,:,:,:,ind(vars .eq. "CCO_OH"))+area(:,:,:,:,ind(vars .eq. "RCO_OH"))
outvars(i)     = "E_ORA2"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "GLY"))
outvars(i)     = "E_GLY"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "MACR")) + area(:,:,:,:,ind(vars .eq. "IPROD"))
outvars(i)     = "E_MACR"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "MGLY")) + area(:,:,:,:,ind(vars .eq. "BACL"))
outvars(i)     = "E_MGLY"

i=i+1
out(:,:,:,:,i) = area(:,:,:,:,ind(vars .eq. "NR")) + area(:,:,:,:,ind(vars .eq. "BALD"))
outvars(i)     = "E_NR"

nvargas=i+1   
print(nvargas)
;;;25

;;;;aerosols species
aFrac=0.1

i=i+1
out(:,:,:,:,i) = aFrac * area(:,:,:,:,ind(vars .eq. "PMOTHR")) + aFrac * area(:,:,:,:,ind(vars .eq. "PAL")) + aFrac * area(:,:,:,:,ind(vars .eq. "PCA"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PFE"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PK"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PSI"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PTI"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PCL"))+ aFrac * area(:,:,:,:,ind(vars .eq. "PNH4"))+ aFrac* area(:,:,:,:,ind(vars .eq. "PH2O"))+ aFrac* area(:,:,:,:,ind(vars .eq. "PMN"))+ aFrac* area(:,:,:,:,ind(vars .eq. "PMG"))+ aFrac* area(:,:,:,:,ind(vars .eq. "PNCOM"))
outvars(i)     = "E_PM25I"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PMOTHR")) + (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PAL")) + (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PCA"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PFE"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PK"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PSI"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PTI"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PCL"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PNH4"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PH2O"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PMN"))+ (1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PMG"))+(1.0-aFrac)* area(:,:,:,:,ind(vars .eq. "PNCOM"))
outvars(i)     = "E_PM25J"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PNA"))
outvars(i)     = "E_NAAI"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PNA"))
outvars(i)     = "E_NAAJ"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PCL"))
outvars(i)     = "E_CLI"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PCL"))
outvars(i)     = "E_CLJ"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PEC"))
outvars(i)     = "E_ECI"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PEC"))
outvars(i)     = "E_ECJ"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "POC"))
outvars(i)     = "E_ORGI"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "POC"))
outvars(i)     = "E_ORGJ"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PSO4"))
outvars(i)     = "E_SO4I"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PSO4"))
outvars(i)     = "E_SO4J"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PNO3"))
outvars(i)     = "E_NO3I"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PNO3"))
outvars(i)     = "E_NO3J"

i=i+1
out(:,:,:,:,i) = aFrac*area(:,:,:,:,ind(vars .eq. "PNH4"))
outvars(i)     = "E_NH4I"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PNH4"))
outvars(i)     = "E_NH4J"

i=i+1
out(:,:,:,:,i) = (1.0-aFrac)*area(:,:,:,:,ind(vars .eq. "PMC"))
outvars(i)     = "E_PM_10"

; -----------------------------------------------------------------------------
; create wrfchemi files
; -----------------------------------------------------------------------------

print("output")

;do j = 0, nvar - 1
;  dmp->$vars(j)$ = area(:,:,:,j)
;end dog
;delete(dmp)
;delete(area)

; copy global attributes from WRF domain file
attsToCopy = (/ "SIMULATION_START_DATE", "WEST-EAST_GRID_DIMENSION", \
                "SOUTH-NORTH_GRID_DIMENSION", "BOTTOM-TOP_GRID_DIMENSION", \
                "DX", "DY", "GRIDTYPE", "DIFF_OPT", "KM_OPT", "DAMP_OPT", \
                "DAMPCOEF", "KHDIF", "KVDIF", "MP_PHYSICS", "RA_LW_PHYSICS", \
                "RA_SW_PHYSICS", "SF_SFCLAY_PHYSICS", "SF_SURFACE_PHYSICS", \
                "BL_PBL_PHYSICS", "CU_PHYSICS", "SURFACE_INPUT_SOURCE", \
                "SST_UPDATE", "GRID_FDDA", "GFDDA_INTERVAL_M", "GFDDA_END_H", \
                "GRID_SFDDA", "SGFDDA_INTERVAL_M", "SGFDDA_END_H", \
                "HYPSOMETRIC_OPT", "WEST-EAST_PATCH_START_UNSTAG", \
                "WEST-EAST_PATCH_END_UNSTAG", "WEST-EAST_PATCH_START_STAG", \
                "WEST-EAST_PATCH_END_STAG", "SOUTH-NORTH_PATCH_START_UNSTAG", \
                "SOUTH-NORTH_PATCH_END_UNSTAG", \
                "SOUTH-NORTH_PATCH_START_STAG", \
                "SOUTH-NORTH_PATCH_END_STAG", \
                "BOTTOM-TOP_PATCH_START_UNSTAG", \
                "BOTTOM-TOP_PATCH_END_UNSTAG", \
                "BOTTOM-TOP_PATCH_START_STAG", \
                "BOTTOM-TOP_PATCH_END_STAG", "GRID_ID", "PARENT_ID", \
                "I_PARENT_START", "J_PARENT_START", "PARENT_GRID_RATIO", \
                "DT", "CEN_LAT", "CEN_LON", "TRUELAT1", "TRUELAT2", \
                "MOAD_CEN_LAT", "STAND_LON", "POLE_LAT", "POLE_LON", "GMT", \
                "JULYR", "JULDAY", "MAP_PROJ", "MMINLU", "NUM_LAND_CAT", \
                "ISWATER", "ISLAKE", "ISICE", "ISURBAN", "ISOILWATER" /)
natts = dimsizes(attsToCopy)

att = True
do i = 0, natts - 1
  att@$attsToCopy(i)$ = wrfgrid@$attsToCopy(i)$
end do

; dimensions
dimNames = (/ "Time", "emissions_zdim_stag", "south_north", "west_east", "DateStrLen" /)
dimSizes = (/   -1  ,     nlay_emis,      nrow_wrf   ,  ncol_wrf  ,      19      /)
dimUnlim = (/  True ,        False         ,     False    ,   False    ,     False    /)

; unit conversion

; gases: moles s-1 -> moles km-2 hr-1
conv_gas = 3600.0 / WRF_grid_area
; area interpolation (better: aggregation) should have conserved mass, 
; point sources were just added to each cell...

; aerosols: g s-1 -> ug m-2 s-1
conv_aer =    1.0 / WRF_grid_area

do t = 0, ntime - 1

  year  = str_get_cols(date(n), 0, 3)
  month = str_get_cols(date(n), 4, 5)
  day   = str_get_cols(date(n), 6, 7)

  hour  = "0"+t
  if (t .gt. 9) 
    hour = tostring(t)
  end if
  
  niceDate = year + "-" + month + "-" + day + "_" + hour + ":00:00"
  outfileName = "./output/wrfchemi_d01_"+niceDate+".nc"

  if (isfilepresent(outfileName)) then
    system("rm "+outfileName)
  end if

  outfile = addfile(outfileName, "c")
  
  setfileoption(outfile, "DefineMode", True)
  
  ; global attributes
  fileattdef( outfile, att )
  
  ; dimensions
  filedimdef(outfile, dimNames, dimSizes, dimUnlim)
  
  setfileoption(outfile, "DefineMode", False)
   times = new((/1,19/), character)
  times!0 = "Time"
  times!1 = "DateStrLen"

  outfile->Times = times

  niceDateC = stringtochar(niceDate)
  outfile->Times(0,:)  = (/ niceDateC(:18) /)
    
;  delete(times)
  
;  delete(outfile)
  
  print("Written wrfchemi file for "+niceDate)


 
  do j = 0, nvarout - 1
  
    var    = new( (/ 1, nlay_emis, nrow_wrf, ncol_wrf /), "float", "No_FillValue" )
    var!0  = "Time"
    var!1  = "emissions_zdim_stag"
    var!2  = "south_north"
    var!3  = "west_east"
    
    var@FieldType = 104
    var@MemoryOrder = "XYZ"
    var@description = "EMISSIONS"
    
    conv_var = 1.0
    if( j.lt.nvargas)
      ; gases
      var@units = "mole km-2 hr-1"
      conv_var  = conv_gas
    else
      var@units="ug m-2 s-1"
      conv_var = conv_aer
    end if
    
    var    = (/ out(t,:,:,:,j) * conv_var /)
    
    outfile->$outvars(j)$ = var
    
    delete(var)
  end do
end do
end do
