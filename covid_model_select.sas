data covid;
title 'COVID-19 Data for all 50 U.S. States';
infile 'covid_data_updated.csv' firstobs=2 dlm = ',';
input obs State :$13. Total_Cases Total_Deaths Population PopulationWeighted_Density
	  retail grocery parks transit workplaces residential age low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over
	  Race_param_1 Race_param_2 Race_param_3 Race_param_4 Obesity_Rates 
	  Average_Relative_Humidity Average_Dew_Point
	  Average_Annual_Temperature_C Average_Annual_Percipitation_mm 
	  State_of_emergency_declared Avge_Spring_Temp Avge_Spring_Precip
	  relative_humidity_morning relative_humidity_afternoon UV_index;
	  ndeath = Total_Deaths/100000; * analysis can be done with this response instead, if desired;
	  
label State = 'State' Total_Cases = 'Total Cases' Total_Deaths = 'Total Deaths'
	  Population = 'Population' PopulationWeighted_Density = 'Population Weighted Density'
	  retail = 'Travel to Retail Locations' 
	  grocery = 'Travel to Grocery Locations' parks = 'Travel to Outdoor Park Locations' 
	  transit = 'Travel to Transit Locations' workplaces = 'Travel to Workplace Locations'
	  residential = 'Change in Residential Population' age = 'Average Age of Residents'
	  low_indust_toxins = 'Measure of Industrial Toxins' 
	  low_pollution_health_risk = 'Low Pollution Health Risk'
	  Chron_Low_Resp_Death_Rate = 'Chronic Lower Resperitory Death Rate'
	  age_65_years_and_over = 'Age 65 Years and Over' Race_param_1 = 'Race 1' 
	  Race_param_2 = 'Race 2' Race_param_3 = 'Race 3' Race_param_4 = 'Race 4' 
	  Obesity_Rates = 'Obesity Rate' Average_Relative_Humidity = 'Average Relative Humidity'
	  Average_Dew_Point = 'Average Dew Point'
	  Average_Annual_Temperature_C = 'Average Annual Temperature (C)'
	  Average_Annual_Percipitation_mm = 'Average Annual Percipitation (mm)'
	  State_of_emergency_declared = 'Date State of Emergency Declared (Date Declared - First Lab Reported Case)'
	  Avge_Spring_Temp = 'Average Spring Temperature (C)'
	  Avge_Spring_Precip = 'Average Spring Precipitation (mm)'
	  relative_humidity_morning = 'Relative Morning Humidity' 
	  relative_humidity_afternoon = 'Relative Afternoon Humidity'
	  UV_index = 'UV Index' ndeath = 'Number of Deaths Per 100,000';
run;



proc print data=covid;
run;

proc means mean median std min max data=covid;
 var  Total_Cases Total_Deaths Population PopulationWeighted_Density
	  retail grocery parks transit workplaces residential age low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over
	  Race_param_1 Race_param_2 Race_param_3 Race_param_4 Obesity_Rates 
	  Average_Relative_Humidity Average_Dew_Point
	  Average_Annual_Temperature_C Average_Annual_Percipitation_mm 
	  State_of_emergency_declared Avge_Spring_Temp Avge_Spring_Precip
	  relative_humidity_morning relative_humidity_afternoon UV_index; 
run;

ods graphics on;

proc glmselect data=covid plots=all seed=907;
title '10-Fold CV Without State Variable';
model Total_Deaths = Total_Cases Population PopulationWeighted_Density
	  retail grocery parks transit workplaces residential age low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over
	  Race_param_1 Race_param_2 Race_param_3 Race_param_4 Obesity_Rates 
	  Average_Relative_Humidity Average_Dew_Point
	  Average_Annual_Temperature_C Average_Annual_Percipitation_mm 
	  State_of_emergency_declared Avge_Spring_Temp Avge_Spring_Precip
	  relative_humidity_morning relative_humidity_afternoon UV_index
/selection=LASSO(stop=none choose=cv) cvmethod=random(10); 
run;

proc glmselect data=covid plots=all;
title 'LASSO AIC Without State Variable';
model Total_Deaths = Total_Cases Population PopulationWeighted_Density
	  retail grocery parks transit workplaces residential age low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over
	  Race_param_1 Race_param_2 Race_param_3 Race_param_4 Obesity_Rates 
	  Average_Relative_Humidity Average_Dew_Point
	  Average_Annual_Temperature_C Average_Annual_Percipitation_mm 
	  State_of_emergency_declared Avge_Spring_Temp Avge_Spring_Precip
	  relative_humidity_morning relative_humidity_afternoon UV_index
/selection=LASSO(stop=none choose=AIC); 
run;


proc glmselect data=covid plots=all;
title 'Stepwise AIC Without State Variable';
model Total_Deaths = Total_Cases Population PopulationWeighted_Density
	  retail grocery parks transit workplaces residential age low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over
	  Race_param_1 Race_param_2 Race_param_3 Race_param_4 Obesity_Rates 
	  Average_Relative_Humidity Average_Dew_Point
	  Average_Annual_Temperature_C Average_Annual_Percipitation_mm 
	  State_of_emergency_declared Avge_Spring_Temp Avge_Spring_Precip
	  relative_humidity_morning relative_humidity_afternoon UV_index
/selection=stepwise(stop=none choose=AIC); 
run;


/*Fit the best model found for further assumption analysis*/

proc reg data=covid plots=(diagnostics(stats=all) fit(stats=(aic sbc)));
title 'Fitting LASSO AIC Selected Model';
model Total_Deaths = Total_Cases Population PopulationWeighted_Density 
	  retail grocery parks transit workplaces residential low_indust_toxins
	  low_pollution_health_risk Chron_Low_Resp_Death_Rate age_65_years_and_over 
	  Race_param_1 Race_param_3 Race_param_4 Obesity_Rates Average_Dew_Point
	  Average_Annual_Percipitation_mm State_of_emergency_declared 
	  Avge_Spring_Temp Avge_Spring_Precip relative_humidity_morning 
	  relative_humidity_afternoon UV_index
	  / clb clm cli r;
output out=residout predicted=pred rstudent=resid;
run;

proc univariate data=residout normal;
var resid;
run;

proc reg data=covid plots=(diagnostics(stats=all) fit(stats=(aic sbc)));
title 'Fitting stepwise AIC Selected Model';
model Total_Deaths = Total_Cases Population PopulationWeighted_Density 
	  Race_param_2 Average_Relative_Humidity Avge_Spring_Temp
	  / clb clm cli r;
run;
