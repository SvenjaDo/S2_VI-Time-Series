# S2_VI_TimeSeries_GEE:
Time Series Analysis for Vegetaion Indices with Sentinel-2 data in Google Earth Engine. 

This repository was created for a project analyzing the response of savannah grasses to precipitation.
A collection of Sentinel-2 data for 14 grass plots within Kruger Nationalpark from 06.2019 to mid 2023 is created. Pre-processing of the collection includes cloud filter, cloud masking. BRDF Correction and Re-alignment is performed following https://github.com/ndminhhus/geeguide. 
The calculated vegetation indices are: ndvi, savi, evi, gndvi, tvi, ipvi and cvi. 
A full time series as well as a monthly time series is created. The results can be downloaded as .png or .csv files. 

# TS_ggplot

This script is used to visualize the time Series results. Inputs are .csv results downloaded from Google Earth Engine as well as precipitation data for the corresponding area. The results will be shown in a Time Series Plot showing the measurements for the 14 Aoi´s as well as rainfall data as a barplot. A smoothing function over all Aois can be added. 


![Time Series Plot](https://github.com/SvenjaDo/S2_VI-Time-Series/blob/main/results/SAVI_TS_median_prec.png "Time Series Plot")

