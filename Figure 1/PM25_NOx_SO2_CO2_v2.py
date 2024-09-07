# -*- coding: utf-8 -*-
"""
Created on Wed Feb  8 15:53:50 2023

@author: f
"""

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

# 读取Excel数据
file_path = 'PM25_NOx_SO2_CO2.xlsx'
df = pd.read_excel(file_path, sheet_name='Sheet1')

# 设置柱状图参数
fig, ax1 = plt.subplots(figsize=(10, 8))

# 设置X轴标签
groups = df['Group']
x = range(len(groups))
bar_width = 0.2
space_width = 0.02  # 柱子之间的空间宽度

# 定义颜色和对应的描述文字
colors = ['silver', '#3d5a80', '#90653A', '#98c1d9', '#f0c648', 'peru', '#293241', '#00a86b']
descriptions = ['Agriculture', 'Industry', 'Power', 'Residential and Commercial', 'Transport', 'Wildfire', 'Direct air capture', 'Land Use']
pollutants = ['CO$_2$', 'SO$_2$', 'NO$_x$', 'PM$_2$$_.$$_5$']

# 绘制CO2的堆积柱状图，并设置legend
for i in range(1, 9):
    positive_bottom_CO2 = df[[f'Layer{j}_CO2' for j in range(1, i)]].apply(lambda x: x.clip(lower=0)).sum(axis=1) if i > 1 else 0
    negative_bottom_CO2 = df[[f'Layer{j}_CO2' for j in range(1, i)]].apply(lambda x: x.clip(upper=0)).sum(axis=1) if i > 1 else 0

    bars1 = ax1.bar(x, df[f'Layer{i}_CO2'].clip(lower=0), bar_width - space_width, bottom=positive_bottom_CO2, color=colors[i-1], edgecolor='black', linewidth=0)
    bars2 = ax1.bar(x, df[f'Layer{i}_CO2'].clip(upper=0), bar_width - space_width, bottom=negative_bottom_CO2, color=colors[i-1], edgecolor='black', linewidth=0)

# 在指定位置添加文字
ax1.text(0., 6.5, 'CO$_2$', fontsize=12, ha='center')
ax1.text(1., 6, 'CO$_2$', fontsize=12, ha='center')
ax1.text(2., 3.2, 'CO$_2$', fontsize=12, ha='center')

ax1.text(0.4, 2.3, 'SO$_2$', fontsize=12, ha='center')
ax1.text(1.4, 1.6, 'SO$_2$', fontsize=12, ha='center')
ax1.text(2.4, 1.1, 'SO$_2$', fontsize=12, ha='center')

ax1.text(0.2, 6, 'NO$_x$', fontsize=12, ha='center')
ax1.text(1.2, 4.6, 'NO$_x$', fontsize=12, ha='center')
ax1.text(2.2, 3.5, 'NO$_x$', fontsize=12, ha='center')

ax1.text(0.6, 2.3, 'PM$_2$$_.$$_5$', fontsize=12, ha='center')
ax1.text(1.6, 1.4, 'PM$_2$$_.$$_5$', fontsize=12, ha='center')
ax1.text(2.6, 1.2, 'PM$_2$$_.$$_5$', fontsize=12, ha='center')

ax1.text(1.85, -4.6, '2050', fontsize=12, ha='center')

# 创建第二个Y轴
ax2 = ax1.twinx()

# 绘制SO2, NOx, PM2.5的堆积柱状图，并设置legend
for i in range(1, 9):
    bottom_NOx = df[[f'Layer{j}_NOx' for j in range(1, i)]].sum(axis=1) if i > 1 else 0
    bottom_SO2 = df[[f'Layer{j}_SO2' for j in range(1, i)]].sum(axis=1) if i > 1 else 0
    bottom_PM25 = df[[f'Layer{j}_PM2.5' for j in range(1, i)]].sum(axis=1) if i > 1 else 0

    ax2.bar([p + bar_width for p in x], df[f'Layer{i}_NOx'], bar_width - space_width, bottom=bottom_NOx, color=colors[i-1], edgecolor='black', linewidth=0)
    ax2.bar([p + bar_width*2 for p in x], df[f'Layer{i}_SO2'], bar_width - space_width, bottom=bottom_SO2, color=colors[i-1], edgecolor='black', linewidth=0)
    ax2.bar([p + bar_width*3 for p in x], df[f'Layer{i}_PM2.5'], bar_width - space_width, bottom=bottom_PM25, color=colors[i-1], edgecolor='black', linewidth=0)

# 设置标签和标题
ax1.set_xlabel('', fontsize=12)
ax1.set_ylabel('CO$_2$ (Metric Billion Ton)', fontsize=12)
ax2.set_ylabel('Other Pollutants (Tg)', fontsize=12)
ax1.set_title('')

# 调整X轴刻度位置，缩短三个group之间的间隔
ax1.set_xticks([p + 1.5 * bar_width for p in x])
ax1.set_xticklabels(groups, fontsize=12)

# 设置y1和y2的刻度范围为-4到8
ax1.set_ylim(-4, 8)
ax2.set_ylim(-4, 8)

# 确保y1和y2的0刻度对齐并处理负值
ax1ylim = ax1.get_ylim()
ax2ylim = ax2.get_ylim()
ax1.tick_params(axis='y', labelsize=12)  # 设置 Y 轴刻度标签大小为 12
ax2.tick_params(axis='y', labelsize=12)  # 设置第二个 Y 轴刻度标签大小为 12

# 在0刻度处添加横线
ax1.axhline(0, color='black', linewidth=0.8)
ax2.axhline(0, color='black', linewidth=0.8)

# 计算y1和y2的最小值和最大值之间的差距
gap = ax1ylim[0] - ax2ylim[0]

# 调整y2轴的范围
ax2.set_ylim(ax2ylim[0] + gap, ax2ylim[1] + gap)

# 设置图例，根据颜色和描述文字创建legend
legend_patches = []
for color, desc in zip(colors, descriptions):
    legend_patches.append(Patch(color=color, label=desc))

ax1.legend(handles=legend_patches, frameon=False, fontsize=11)  # 修改图例字体大小

# 去掉上侧边框
ax1.spines['top'].set_visible(False)
ax2.spines['top'].set_visible(False)

# 显示图表
plt.tight_layout()

# 保存图表为图像文件
plt.savefig('PM25_NOx_SO2_CO2_v2.svg')

# 显示图表
plt.show()