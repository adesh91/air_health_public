# -*- coding: utf-8 -*-
"""
Created on Wed Feb  8 15:53:50 2023

@author: f
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import TwoSlopeNorm
from matplotlib.ticker import FuncFormatter, MaxNLocator

# 读取Excel数据
data = pd.read_excel('heat_map.xlsx', sheet_name='N50-N50RPM')

# 提取需要的列数据
states = data.iloc[:, 0]
growth = data.iloc[:, 1:7]

# 计算增长和降低的颜色区间
min_value = growth.min().min()
max_value = growth.max().max()

# 创建颜色映射
cmap = plt.colormaps['RdBu_r']  # 使用'RdBu_r' colormap，它是'RdBu'的反转版本
norm = TwoSlopeNorm(vmin=min_value, vcenter=0, vmax=max_value)

# 绘制表格
fig, ax = plt.subplots()
heatmap = plt.imshow(growth, cmap=cmap, norm=norm, aspect='0.2')

# 设置坐标轴标签
ax.set_xticks(np.arange(growth.shape[1]))
ax.set_yticks(np.arange(growth.shape[0]))
ax.set_xticklabels(growth.columns, fontsize=4)  # 添加ha='right'
ax.set_yticklabels(states, fontsize=4)

# 添加颜色条
cbar = ax.figure.colorbar(heatmap, ax=ax)

# 设置colorbar的刻度
cbar.locator = MaxNLocator(nbins=5)  # 设定刻度数量
cbar.update_ticks()  # 更新刻度

def to_percent(value, position):
    return f'{value * 100:.0f}%'

formatter = FuncFormatter(to_percent)
cbar.ax.yaxis.set_major_formatter(formatter)

plt.rcParams['font.size'] = 4

# Rotate x-labels 45 degrees
#plt.xticks(rotation=45)

# 保存图表为图像文件
plt.savefig('heat_map_pm2.5_N50-N50R.svg', bbox_inches='tight', dpi=1000)

# 显示图表
plt.show()