set terminal postscript portrait color enhanced 12 
set output "O3_Apr_wt_obs_cb05.ps"
#set pm3d corners2color c4 map
set pm3d map corners2color c1
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
set palette maxcolors 8
set palette negative defined ( 0 '#D73027',\
                      1 '#F46D43',\
                      2 '#FDAE61',\
                      3 '#FEE090',\
                      4 '#E0F3F8',\
                      5 '#ABD9E9',\
                      6 '#74ADD1',\
                      7 '#4575B4' )
#set palette defined (0 1 1 1, 5 1 1 1, 100 0 0 1 , 250 0 1 0, 500 1 1 0, 1000 1 0 0)
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

#set palette defined (-10 "blue" , 0 "white", 10  "red")
set cbrange [20:60]
set cbtics font ",12" 
#set cbtics ( "48.77(Max)" 24, "21" 21, "18" 18, "15" 15, "12" 12, "9" 9, "6" 6, "3" 3, "0" 0 )
set cbtics 5 
#set origin 0,0.32   
set title "Apr, 2017" font ",12"
set ylabel "O_3 (ppb)" font ",12"
set ylabel offset -1,0,0 
#set label "gh-income counties in Jul, 2017" at graph 0.5,0.95 center font ",20"
splot [1:456][1:296] "combined_ozone_Apr_cb05.2017.8h.matrix.O3" matrix notitl 
splot [1:456][1:296] "county_lam.txt" u ((($1)+2736)/12):((($2)+1776)/12):1 notitle  w l lt -1 lw 0.3
splot [1:456][1:296] "2017.addup_o3_Apr_EPA.txt"  u 1:2:3 notitle w p  pt 7 ps 0.3 lc 0
splot [1:456][1:296] "2017.addup_o3_Apr_EPA.txt"  u 1:2:3 notitle w p  pt 7 ps 0.3 pal
#splot [1:456][1:296] "us.state.la2011.txt" u ((($1)+2736)/12)+1:((($2)+1776)/12)+1:1 notitle  w l lt -1 lw 0.3
unset label
unset ylabel

#unset label
#set origin 0,0.07
#set cbrange [35:50]
#set label "Fall" at 105,110
#plot [1:141][1:117]  "ct22_gnuplot.la2011.txt" u  ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lw 1 lt 0,\
#                     "us.state.la2011.txt" u ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lt -1 lw 0.3,\
#                     "site.la.season.txt"  u ((($2)+-316)/4)+1:((($3)+1220)/4)+1:($6) notitle w p  pt 7 ps 1 pal
#
#unset label
#unset cbrange
#set origin 0.48,0.07
#set label "Winter" at 105,110
#plot [1:141][1:117]  "ct22_gnuplot.la2011.txt" u  ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lw 1 lt 0,\
#                     "us.state.la2011.txt" u ((($1)+-316)/4)+1:((($2)+1220)/4)+1 notitle  w l lt -1 lw 0.3,\
#                     "site.la.season.txt"  u ((($2)+-316)/4)+1:((($3)+1220)/4)+1:($7) notitle w p  pt 7 ps 1 pal
#
#
#
