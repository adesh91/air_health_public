set terminal postscript portrait color enhanced 12 
set output "O3_NZ2050RCP_m_2017_v2.ps"
#set pm3d corners2color c4 map
set pm3d map #corners2color c1
#set pm3d map
#set palette rgbformulae 22,13,-31
#set palette rgbformulae 33,13,10
#set palette negative defined ( \
#    0 '#D53E4F',\
#    1 '#F46D43',\
#    2 '#FDAE61',\
#    3 '#FEE08B',\
#    4 '#E6F598',\
#    5 '#ABDDA4',\
#    6 '#66C2A5',\
#    7 '#3288BD' )
#set palette file "hotres.palette.txt"
#set palette 
set multiplot
unset xtics
unset ytics
#set format cb ""
#unset colorbox
#cd "../result"
set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0
set size 0.85,0.8
set size ratio 0.6

set palette defined (-4 "blue" , 0 "white", 4 "red")
set cbrange [-4:4]
set cbtics font ",12" 
#set cbtics ( "48.77(Max)" 24, "21" 21, "18" 18, "15" 15, "12" 12, "9" 9, "6" 6, "3" 3, "0" 0 )
set cbtics 1 
#set origin 0,0.32   
#set title "Jul, 2017" font ",20"
set title "2050 Net-zero_(_R_C_P_8_._5_) - 2017" font ",12"
set ylabel "O_3 (ppb)" font ",12"
set ylabel offset -1,0,0 
#set label "gh-income counties in Jul, 2017" at graph 0.5,0.95 center font ",20"
set label "Populated-weighted exposure: 36.5 ppb (NZ2050_(_R_C_P_8_._5_))" at graph 0.5,-0.1 center font ",12"
splot [1:456][1:296] "wrfout.ozone_year_NZ2050RCP_m_2017" matrix notitl 
splot [1:456][1:296] "county_lam.txt" u ((($1)+2736)/12)-1:((($2)+1776)/12)-1:1 notitle  w l lt -1 lw 0.3
unset label
unset ylabel

#unset label
#set origin 0,0.07
#set cbrange [35:50]
#set label "Fall" at 105,110
#plot [1:121][1:117]  "ct22_gnuplot.la2011.txt" u  ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lw 1 lt 0,\
#                     "county_lam.txt" u ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lt -1 lw 0.3,\
#                     "site.la.season.txt"  u ((($2)+-316)/4)+1:((($3)+1220)/4)+1:($6) notitle w p  pt 7_v2.ps 1 pal
#
#unset label
#unset cbrange
#set origin 0.48,0.07
#set label "Winter" at 105,110
#plot [1:121][1:117]  "ct22_gnuplot.la2011.txt" u  ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lw 1 lt 0,\
#                     "county_lam.txt" u ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lt -1 lw 0.3,\
#                     "site.la.season.txt"  u ((($2)+-316)/4)+1:((($3)+1220)/4)+1:($7) notitle w p  pt 7_v2.ps 1 pal
#
#
#
