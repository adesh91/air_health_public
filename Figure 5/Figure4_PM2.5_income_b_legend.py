#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 13 10:14:14 2022

@author: Pengfei
"""

from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
fig = plt.figure(figsize=(3, 2))
#df11=pd.read_excel('numbers_for _figures.xlsx',sheet_name= "Figure2a") #race
df11=pd.read_excel('numbers_for _figures.xlsx',sheet_name= "Figure2b") #income
#x1 = df['x1_L','x1_H'].values

#y111g = df11.values[a11,1:19]
#ax1 = plt. subplot(211)
#x = ['2015','2020','2025', '2030','2035','2040','2045','2050']
x1 = df11.values[0:2,0]
x2 = df11.values[0:2,1]
x3 = df11.values[0:2,2]
x4 = df11.values[0:2,4]
#x11 = df12.values[0:2,4]
#x22 = df12.values[0:2,19]
#x33 = df12.values[0:2,24]
print(x1)
print(x2)
print(x3)
#print(x11)
#print(x22)
#print(x33)
#print(x7)
d1 = np.array([0,0])
d2 = np.array([0,0])



y111x1 = [' ',' ']
#y111x11 = ['3','3']
y111d1 = ['1','1']
#y111d2 = ['2','2']
y111x2 = ['Reference','Reference']
y111x3 = ['Net-zero','Net-zero']
y111x4 = ['Net-zero$_{(RCP8.5)}$','Net-zero$_{(RCP8.5)}$']
#y111x33 = [' Net-zero',' Net-zero']


#plt.plot(x33, y111x33, linestyle='solid', color='black', zorder=1)
plt.plot(x4, y111x4, linestyle='dashed', color='black', zorder=1)
plt.plot(x3, y111x3, linestyle='solid', color='black', zorder=1)
plt.plot(x2, y111x2, linestyle='solid', color='black', zorder=1)
#plt.plot(d2, y111d2, linestyle='solid', color='black', zorder=1)
plt.plot(d1, y111d1, linestyle='solid', color='black', zorder=1)
#plt.plot(x11, y111x11, linestyle='solid', color='black', zorder=1)
plt.plot(x1, y111x1, linestyle='solid', color='black', zorder=1)


x1 = df11.values[0:1,0]
x2 = df11.values[0:1,1]
x3 = df11.values[0:1,2]
x4 = df11.values[0:1,4]
#x11 = df12.values[0:1,4]
#x22 = df12.values[0:1,19]
#x33 = df12.values[0:1,24]
#print(x1)
#print(x2)
#print(x3)
#print(x4)
#print(x5)
#print(x6)
#print(x7)
d1 = np.array([0])
d2 = np.array([0])


y111x1 = [' ']
y111d1 = ['1']
#y111d2 = ['2']
y111x2 = ['Reference']
y111x3 = ['Net-zero']
y111x4 = ['Net-zero$_{(RCP8.5)}$']


#plt.scatter(d2, y111d2, marker='o', facecolors='white', color='darkorange', zorder=2)
plt.scatter(d1, y111d1, marker='o', facecolors='white', color='deepskyblue', zorder=2, label=' ')
#plt.scatter(x11, y111x11, marker='o', facecolors='white', color='deepskyblue', zorder=2)
plt.scatter(x1, y111x1, marker='o', facecolors='white', color='deepskyblue', zorder=2)
#plt.scatter(x33, y111x33, marker='o', facecolors='white', color='deepskyblue', zorder=2)
plt.scatter(x4, y111x4, marker='o', facecolors='white', color='deepskyblue', zorder=2)
plt.scatter(x3, y111x3, marker='o', facecolors='white', color='deepskyblue', zorder=2)
plt.scatter(x2, y111x2, marker='o', facecolors='white', color='deepskyblue', zorder=2)


x1 = df11.values[2:3,0]
x2 = df11.values[2:3,1]
x3 = df11.values[2:3,2]
x4 = df11.values[2:3,4]
#print(x1)
#print(x2)
#print(x3)
#print(x4)
#print(x5)
#print(x6)
#print(x7)
d1 = np.array([0])
d2 = np.array([0])


y111x1 = [' ']
y111d1 = ['1']
#y111d2 = ['2']
y111x2 = ['Reference']
y111x3 = ['Net-zero']
y111x4 = ['Net-zero$_{(RCP8.5)}$']


#plt.scatter(d2, y111d2, marker='o', color='darkorange', zorder=2)
plt.scatter(d1, y111d1, marker='|', color='red', zorder=2, label='National average')
#plt.scatter(x11, y111x11, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x1, y111x1, marker='|', color='red', zorder=2)
#plt.scatter(x33, y111x33, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x4, y111x4, marker='|', color='red', zorder=2)
plt.scatter(x3, y111x3, marker='|', color='red', zorder=2)
plt.scatter(x2, y111x2, marker='|', color='red', zorder=2)


#ax11.bar(x, y111s2, color='turquoise', bottom = y111s2)
x1 = df11.values[1:2,0]
x2 = df11.values[1:2,1]
x3 = df11.values[1:2,2]
x4 = df11.values[1:2,4]
#print(x1)
#print(x2)
#print(x3)
#print(x4)
#print(x5)
#print(x6)
#print(x7)
d1 = np.array([0])
d2 = np.array([0])


y111x1 = [' ']
y111d1 = ['1']
#y111d2 = ['2']
y111x2 = ['Reference']
y111x3 = ['Net-zero']
y111x4 = ['Net-zero$_{(RCP8.5)}$']


#plt.scatter(d2, y111d2, marker='o', color='darkorange', zorder=2)
plt.scatter(d1, y111d1, marker='o', color='deepskyblue', zorder=2, label='Median house income')
#plt.scatter(x11, y111x11, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x1, y111x1, marker='o', color='deepskyblue', zorder=1)
#plt.scatter(x33, y111x33, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x4, y111x4, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x3, y111x3, marker='o', color='deepskyblue', zorder=2)
plt.scatter(x2, y111x2, marker='o', color='deepskyblue', zorder=2)

plt.axhspan(ymin=-0.5, ymax=2.5, facecolor='grey', alpha=0.2)
plt.axhspan(ymin=3.5, ymax=4.5, facecolor='grey', alpha=0.2)
#plt.axhspan(ymin=11.5, ymax=12.5, facecolor='grey', alpha=0.2)
#plt.gca().get_yticklabels()[4].set_visible(False)
plt.gca().get_yticklabels()[3].set_visible(False)
#plt.gca().get_yticklabels()[4].set_visible(False)
#plt.gca().get_yticklabels()[8].set_visible(False)
#plt.gca().get_yticklabels()[4].set_visible(False)
#plt.gca().get_yticklabels()[6].set_visible(False)

#plt.axhline(y=1.5, color='white', linestyle='solid',  linewidth=0.5, xmin=0/5, xmax=6.5/6.5)

plt.xlim(4.5,8.5)
plt.tick_params(axis='y', length=0)
#plt.xticks([4.0, 6.0, 8.0, 10.0])
#ax11.set_xticks([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])
#ax11.set_xticklabels(['2015','2020','2025','2030','2035','2040','2045','2050','2055','2060','2065','2070','2075','2080','2085','2090','2095','2100'], fontsize=5)
plt.gca().spines['bottom'].set_visible(False)
plt.gca().spines['top'].set_visible(False)
plt.gca().spines['left'].set_visible(False)
plt.gca().spines['right'].set_visible(False)
plt.gca().xaxis.grid(True)
plt.gca().yaxis.grid(False)
#plt.gca().xaxis.label.set_color('yellow')
plt.gca().tick_params(axis='x', colors='grey')


#plt.text(0.5, -0.35, 'NA annual (777)', transform=plt.gca().transAxes, fontsize=10)
#legend = plt.legend(title='Percent white population', loc='best', shadow=False, frameon=False, title_fontsize=7, fontsize=7)
# After plotting the data points, add the legend
# After plotting the data points, add the legend below the plot
plt.legend(title=False, loc='upper center', bbox_to_anchor=(1.8, 0.5), shadow=False, frameon=False, title_fontsize=8, fontsize=8, ncol=2)

# Add the text "a" at the bbox_to_anchor position
plt.text(1.5, 0.5, 'Highest decile', transform=plt.gca().transAxes, fontweight='bold', fontsize=8)
plt.text(1.1, 0.5, 'Lowest decile', transform=plt.gca().transAxes, fontweight='bold', fontsize=8)
plt.text(1.1, 0.6, 'Average of county groups', transform=plt.gca().transAxes, fontweight='bold', fontsize=8)
#plt.text(0.01, 0.85, '2017', transform=plt.gca().transAxes, fontsize=10)
#plt.text(0.01, 0.49, '2050', transform=plt.gca().transAxes, fontsize=10)
#plt.text(-0.95, 1.0, 'a)', transform=plt.gca().transAxes, fontsize=10)
plt.text(0.3, 1.03, 'PM$_{{2.5}}$ (μg$/$m$^{3}$)', transform=plt.gca().transAxes, fontsize=10)
#plt.xlabel('μg$/$m$^{3}$', fontdict=None, labelpad=None, loc='center')
plt.savefig('Figure4_PM2.5_income_N_NR_legend.svg', bbox_inches='tight', dpi=1000)
plt.show()
