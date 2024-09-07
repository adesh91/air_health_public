# -*- coding: utf-8 -*-
"""
Created on Wed Feb  8 15:53:50 2023

@author: f
"""

import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from urllib.request import urlopen
import json
import requests
import matplotlib.patches as mpatches

# 1.读取Excel文件
df = pd.read_excel('PM25_O3_color.xlsx', sheet_name='N50R-17Jul', usecols=['A', 'B', 'C'])

# 从URL读取地理边界文件
url = 'https://eric.clst.org/assets/wiki/uploads/Stuff/gz_2010_us_050_00_500k.json'
response = requests.get(url)
counties = response.content.decode('ISO-8859-1')
counties = json.loads(counties)

# 将GeoJSON数据转换为GeoDataFrame
usa_counties = gpd.GeoDataFrame.from_features(counties)

# 设置初始坐标参考系为WGS 84
usa_counties = usa_counties.set_crs(epsg=4326)

# 将'GEO_ID'列和Excel数据的'A'列都转换为字符串类型，以便进行数据合并
usa_counties['GEO_ID'] = usa_counties['GEO_ID'].astype(str)
df['A'] = df['A'].astype(str)

# 合并数据
merged = usa_counties.merge(df, left_on='GEO_ID', right_on='A')

# 2.根据BC列的数据设置颜色
def set_color(row):
    if row['B'] < 0 and row['C'] < 0:
        return '#06D6A0'
    elif row['B'] < 0 and row['C'] > 0:
        return '#118AB2'
    elif row['B'] > 0 and row['C'] < 0:
        return '#FFD166'
    elif row['B'] > 0 and row['C'] > 0:
        return '#EF476F'
    else:
        return 'white'

merged['color'] = merged.apply(set_color, axis=1)

# 输出color列的数据到txt文件
with open('color_data.txt', 'w') as f:
    f.write(merged['color'].to_string())

# 将数据转换为Lambert Conformal Conic投影
Atlas_crs = 'EPSG:2163'
merged = merged.to_crs(Atlas_crs)

# 3.画图
fig, ax = plt.subplots(1, 1)
merged.plot(color=merged['color'], legend=True, ax=ax, linewidth=0.1, edgecolor='grey')

# Create a list of patches for the legend
patches = [
    mpatches.Patch(color='#06D6A0', label='PM decreases and ozone decreases'),
    mpatches.Patch(color='#118AB2', label='PM decreases but ozone increases'),
    mpatches.Patch(color='#FFD166', label='PM increases but ozone decreases'),
    mpatches.Patch(color='#EF476F', label='PM increases and ozone increases')
]

# 在图中添加图例
#leg = ax.legend(handles=patches, bbox_to_anchor=(0, 0), loc='lower left', borderaxespad=0., fontsize=5)

# 删除图例边框
#leg.get_frame().set_linewidth(0.0)

# 去掉x轴y轴坐标
ax.axis('off')

# 去掉图片边框
for spine in ax.spines.values():
    spine.set_visible(False)

#ax.set_title('NZ2050$_{RCP8.5}$ - 2017', fontsize=10)

# 保存图表为图像文件
plt.savefig('PM25_O3_color_N50R-17Jul.png', bbox_inches='tight', dpi=1000)

# 显示图表
plt.show()







