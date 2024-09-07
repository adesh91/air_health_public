set terminal postscript portrait color enhanced 12 
set output "PM_NZ2050RCP_m_2017_v2.ps"
set pm3d map #corners2color c1
set multiplot
unset xtics
unset ytics
set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0
set size 0.85,0.8
set size ratio 0.6

set palette defined (-4 "blue" , 0 "white", 4 "red")
set cbrange [-4:4]
set cbtics font ",12" 
set title "2050 Net-zero_(_R_C_P_8_._5_) - 2017" font ",12"
set ylabel "PM_2_._5 ({/Symbol m}g/m^3)" font ",12"
set ylabel offset -1,0,0 
set label "Populated-weighted exposure: 6.1 {/Symbol m}g/m^3 (NZ2050_(_R_C_P_8_._5_))" at graph 0.5,-0.1 center font ",12"
splot [1:456][1:296] "wrfout.pm25_year_NZ2050RCP_m_2017"matrix notitl 
splot [1:456][1:296] "county_lam.txt" u ((($1)+2736)/12)-1:((($2)+1776)/12)-1:1 notitle  w l lt -1 lw 0.3
unset label
unset ylabel
