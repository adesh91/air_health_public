set terminal postscript portrait color enhanced 12 
set output "PM_2017_cb05_v2.ps"
set pm3d map corners2color c1
set palette maxcolors 8
set palette negative defined ( 0 '#D73027',\
                      1 '#F46D43',\
                      2 '#FDAE61',\
                      3 '#FEE090',\
                      4 '#E0F3F8',\
                      5 '#ABD9E9',\
                      6 '#74ADD1',\
                      7 '#4575B4' )
set multiplot
unset xtics
unset ytics
set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0
set size 0.85,0.8
set size ratio 0.6 

set cbrange [0:16]
set cbtics font ",12" 
set cbtics 2 
set title "2017" font ",12"
set ylabel "PM_2_._5 ({/Symbol m}g/m^3)" font ",12"
set ylabel offset -1,0,0 
set label "Populated-weighted exposure: 7.9 {/Symbol m}g/m^3 (2017)" at graph 0.5,-0.1 center font ",12"
splot [1:456][1:296] "combined_pm25_cb05.2017.matrix.PM25" matrix notitl 
splot [1:456][1:296] "county_lam.txt" u ((($1)+2736)/12-1):((($2)+1776)/12)-1:1 notitle  w l lt -1 lw 0.3

#notitle w l lt -1 lw 0.0005 lc rgb "gray"
unset label
unset ylabel
unset border 
