#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 13 10:14:14 2022

@author: Pengfei
"""

from matplotlib import pyplot as plt
import numpy as np

fig, ((ax11, ax12, ax13), (ax21, ax22, ax23), (ax31, ax32, ax33)) = plt.subplots(3, 3, sharex=True, figsize=(20, 10))

#ax1 = plt.subplot(211)
x = ['NEI-2017','REF-2030','NZ-2030']


y112 = np.array([5.39E-02,	1.28E-01,		0.121473578])
y113 = np.array([0.005125447,	0.001392044,		0.001368688])
y114 = np.array([0.051344946,	0.02503204,		0.026036201])
y115 = np.array([0.056261376,	0.042211799,		0.034571592])


y122 = np.array([7.97E+00,	8.73E+00,		4.457469844])
y123 = np.array([0.035300656,	0.059739792,		0.04016216])
y124 = np.array([1.250749844,	0.194693047,		0.186908276])
y125 = np.array([0.072707761,	0.091878373,		0.085643493])


y132 = np.array([1.14E+01,	9.17E+00,		9.216217132])
y133 = np.array([5.70E-01,	0.425696321,		0.212225717])
y134 = np.array([3.723695357,	1.718569137,		1.806052235])
y135 = np.array([18.32199186,	9.246263745,		8.941247332])


y212 = np.array([5.94E-02,	6.01E-02,		0.055497818])
y213 = np.array([0.020737245,	0.04258542,		0.033667503])
y214 = np.array([0.113873244,	0.065781233,		0.065315629])
y215 = np.array([0.090640923,	0.06959096,		0.067105606])


y222 = np.array([4.00E+00,	6.11E+00,		5.474984527])
y223 = np.array([0.029906309,	0.018105065,		0.010252922])
y224 = np.array([3.59119202,	0.238595101,		0.250641719])
y225 = np.array([1.74325706,	0.932121324,		0.893754008])


y232 = np.array([1.78E+00,	2.229386804,	2.140219199])
y233 = np.array([0.765996216,	0.527732861,	0.200151269])
y234 = np.array([0.487761057,	0.403832517,		0.385352037])
y235 = np.array([2.800666976,	1.679683841,		1.522323758])


y312 = np.array([0.067973815,	0.091903377,		0.092227052])
y313 = np.array([0.017607777,	0.008759913,		0.007622042])
y314 = np.array([0.40396928,	0.234004497,		0.245414688])
y315 = np.array([0.040092796,	0.031343,		0.025960788])


y322 = np.array([0.20663477,	0.453928977,		0.426609452])
y323 = np.array([0.081334112,	0.052320755,		0.015573204])
y324 = np.array([1.046728435,	0.083927979,		0.087491341])
y325 = np.array([0.035085078,	0.007139814,		0.004432713])


y332 = np.array([0.605810159,	0.965529784,		0.845570302])
y333 = np.array([1.295168392,	0.562827219,		0.097283043])
y334 = np.array([0.159565327,	0.094408783,		0.094124264])
y335 = np.array([0.043296845,	0.029666425,		0.027536884])


# plot bars in stack manner
ax11.bar(x, y112, color='#3d5a80')
ax11.bar(x, y113, bottom=y112, color='#90653A')
ax11.bar(x, y114, bottom=y112+y113, color='#98c1d9')
ax11.bar(x, y115, bottom=y112+y113+y114, color='#f0c648')
ax11.set_ylim(0,0.2)
ax11.text(-0.3, 0.18, r'BC', fontsize=15)
ax11.set_yticks([0,0.1,0.2])
ax11.set_yticklabels([0,0.1,0.2], fontsize=12)
#ax11.set_title('NH3',loc='right')
ax11.spines['top'].set_visible(False)
ax11.spines['right'].set_visible(False)
#ax11.spines['bottom'].set_visible(False)
#ax11.spines['left'].set_visible(False)
#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

ax12.bar(x, y122, color='#3d5a80')
ax12.bar(x, y123, bottom=y122, color='#90653A')
ax12.bar(x, y124, bottom=y122+y123, color='#98c1d9')
ax12.bar(x, y125, bottom=y122+y123+y124, color='#f0c648')
ax12.set_ylim(0,12)
ax12.text(-0.3, 10.8, r'CH$_4$', fontsize=15)
ax12.set_yticks([0,6,12])
ax12.set_yticklabels([0,6,12], fontsize=12)
#ax12.set_title('CH4',loc='right')
ax12.spines['top'].set_visible(False)
ax12.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 20.1, 2)
#plt.yticks(my_y_ticks)

ax13.bar(x, y132, color='#3d5a80')
ax13.bar(x, y133, bottom=y132, color='#90653A')
ax13.bar(x, y134, bottom=y132+y133, color='#98c1d9')
ax13.bar(x, y135, bottom=y132+y133+y134, color='#f0c648')
ax13.set_ylim(0,40)
ax13.text(-0.3, 36, r'CO', fontsize=15)
ax13.set_yticks([0,20,40])
ax13.set_yticklabels([0,20,40], fontsize=12)
#ax13.set_title('OC',loc='right')
ax13.spines['top'].set_visible(False)
ax13.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

ax21.bar(x, y212, color='#3d5a80')
ax21.bar(x, y213, bottom=y212, color='#90653A')
ax21.bar(x, y214, bottom=y212+y213, color='#98c1d9')
ax21.bar(x, y215, bottom=y212+y213+y214, color='#f0c648')
ax21.set_ylim(0,0.4)
ax21.text(-0.3, 0.36, r'NH$_3$', fontsize=15)
ax21.set_yticks([0,0.2,0.4])
ax21.set_yticklabels([0,0.2,0.4], fontsize=12)
ax21.set_ylabel("National annual total emission (Tg)", fontsize=12)
#ax21.set_title('VOC',loc='right')
ax21.spines['top'].set_visible(False)
ax21.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

ax22.bar(x, y222, color='#3d5a80')
ax22.bar(x, y223, bottom=y222, color='#90653A')
ax22.bar(x, y224, bottom=y222+y223, color='#98c1d9')
ax22.bar(x, y225, bottom=y222+y223+y224, color='#f0c648')
ax22.set_ylim(0,12)
ax22.text(-0.3, 10.8, r'NMVOC', fontsize=15)
ax22.set_yticks([0,6,12])
ax22.set_yticklabels([0,6,12], fontsize=12)
#ax22.set_title('CO',loc='right')
ax22.spines['top'].set_visible(False)
ax22.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 20.1, 2)
#plt.yticks(my_y_ticks)

ax23.bar(x, y232, color='#3d5a80', label='Industry')
ax23.bar(x, y233, bottom=y232, color='#90653A', label='Power')
ax23.bar(x, y234, bottom=y232+y233, color='#98c1d9', label='Residential & Commercial')
ax23.bar(x, y235, bottom=y232+y233+y234, color='#f0c648', label='Transportation')
ax23.set_ylim(0,8)
ax23.text(-0.3, 7.2, r'NO$_X$', fontsize=15)
ax23.set_yticks([0,4,8])
ax23.set_yticklabels([0,4,8], fontsize=12)
#ax23.set_xticks([])
#ax23.legend(reversed(handles), reversed(labels),"Agriculture","Industry","Power","Residential & Commercial","Transportation","Wildfire",bbox_to_anchor=(2.3,0.4),loc='right',frameon=False,fontsize=12)
#ax23.legend(["Agriculture","Industry","Power","Residential & Commercial","Transportation","Wildfire"],bbox_to_anchor=(2.3,0.4),loc='right',frameon=False,fontsize=12)
handles, labels = ax23.get_legend_handles_labels()
ax23.legend(reversed(handles), reversed(labels),bbox_to_anchor=(2,0.4),loc='right',frameon=False,fontsize=12)
#ax23.set_title('BC',loc='right')
ax23.spines['top'].set_visible(False)
ax23.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

ax31.bar(x, y312, color='#3d5a80')
ax31.bar(x, y313, bottom=y312, color='#90653A')
ax31.bar(x, y314, bottom=y312+y313, color='#98c1d9')
ax31.bar(x, y315, bottom=y312+y313+y314, color='#f0c648')
ax31.set_ylim(0,0.6)
ax31.text(-0.3, 0.54, r'OC', fontsize=15)
ax31.set_yticks([0,0.3,0.6])
ax31.set_yticklabels([0,0.3,0.6], fontsize=12)
ax31.set_xticklabels(x, fontsize=12)
#ax31.set_xticklabels(fontsize=12)
#ax31.set_title('NO$_x$',loc='right')
ax31.spines['top'].set_visible(False)
ax31.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

ax32.bar(x, y322, color='#3d5a80')
ax32.bar(x, y323, bottom=y322, color='#90653A')
ax32.bar(x, y324, bottom=y322+y323, color='#98c1d9')
ax32.bar(x, y325, bottom=y322+y323+y324, color='#f0c648')
ax32.set_ylim(0,1.6)
ax32.text(-0.3, 1.44, r'Other Primary PM$_2$$_.$$_5$', fontsize=15)
ax32.set_yticks([0,0.8,1.6])
ax32.set_yticklabels([0,0.8,1.6], fontsize=12)
ax32.set_xticklabels(x, fontsize=12)
#ax32.set_title('PM$_2$$_.$$_5$',loc='right')
ax32.spines['top'].set_visible(False)
ax32.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 20.1, 2)
#plt.yticks(my_y_ticks)

ax33.bar(x, y332, color='#3d5a80')
ax33.bar(x, y333, bottom=y332, color='#90653A')
ax33.bar(x, y334, bottom=y332+y333, color='#98c1d9')
ax33.bar(x, y335, bottom=y332+y333+y334, color='#f0c648')
ax33.set_ylim(0,2.6)
ax33.text(-0.3, 2.34, r'SO$_2$', fontsize=15)
ax33.set_yticks([0,1.3,2.6])
ax33.set_yticklabels([0,1.3,2.6], fontsize=12)
ax33.set_xticklabels(x, fontsize=12)
#ax33.set_title('SO$_2$',loc='right')
ax33.spines['top'].set_visible(False)
ax33.spines['right'].set_visible(False)
#my_y_ticks = np.arange(0, 5.1, 1)
#plt.yticks(my_y_ticks)

#my_y_ticks = np.arange(0, 4.1, 1)
#plt.yticks(my_y_ticks)

#my_y_ticks = np.arange(0, 20.1, 2)
#plt.yticks(my_y_ticks)
#plt.xlabel("Teams")


plt.savefig('GCAM_NEI_four_category_2030.svg', bbox_inches='tight', dpi=1000)
plt.show()
