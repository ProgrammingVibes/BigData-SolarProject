clear;
close all;

%% y data
load('outcomes.mat')
outcomesMat=table2array(outcomes);
outcomesMat_CS=(outcomesMat-repmat(mean(outcomesMat),7272,1))./std(outcomesMat);
%%
load("employment.mat")
employmentMat=table2array(employment);
load("transportation.mat")
transportationMat=table2array(transportation);
load("politics.mat")
politicsMat=table2array(dataprojectapr9S3);
load("energy.mat")
energyMat=table2array(dataprojectapr9S4);
load("population.mat")
populationMat=table2array(dataprojectapr9S5);
load("geography.mat")
geographyMat=table2array(dataprojectapr9S6);

bigMat=[employmentMat,transportationMat,politicsMat,energyMat,populationMat,geographyMat];
bigMat_CS=(bigMat-repmat(mean(bigMat),7272,1))./std(bigMat);
%%
[Q,components]=Q_score_calc(bigMat_CS);
%%
[t,p,R2]=eigdecomp(bigMat_CS,components);
dataset=["occupation_construction_rate","occupation_public_rate","occupation_information_rate","occupation_finance_rate","occupation_education_rate","occupation_administrative_rate","occupation_manufacturing_rate","occupation_wholesale_rate","occupation_retail_rate","occupation_transportation_rate","occupation_arts_rate","occupation_agriculture_rate","occupancy_vacant_rate","occupancy_owner_rate","mortgage_with_rate","employ_rate","poverty_family_below_poverty_level_rate","poverty_family_below_poverty_level","poverty_family_count","unemployed","average_household_income","gini_index","per_capita_income",...
    "travel_time_average","transportation_home_rate","transportation_car_alone_rate","transportation_walk_rate","transportation_carpool_rate","transportation_motorcycle_rate","transportation_bicycle_rate","transportation_public_rate","travel_time_less_than_10_rate","travel_time_10_19_rate","travel_time_20_29_rate","travel_time_30_39_rate","travel_time_40_59_rate","travel_time_60_89_rate",...
    "incentive_count_residential","incentive_count_nonresidential","incentive_residential_state_level","incentive_nonresidential_state_level","net_metering","feedin_tariff","property_tax","sales_tax","rebate","voting_2016_dem_percentage","voting_2016_gop_percentage",...
    "avg_electricity_retail_rate","heating_design_temperature","cooling_design_temperature","heating_fuel_gas_rate","heating_fuel_electricity_rate","heating_fuel_fuel_oil_kerosene_rate","heating_fuel_coal_coke_rate","heating_fuel_solar_rate","heating_fuel_other_rate","heating_fuel_none_rate","median_household_income","electricity_price_residential","electricity_price_commercial","electricity_price_industrial","electricity_price_transportation","electricity_price_overall","electricity_consume_residential","electricity_consume_commercial","electricity_consume_industrial","electricity_consume_total",...
    "number_of_years_of_education","diversity","health_insurance_public_rate","health_insurance_none_rate","age_median","age_18_24_rate","age_25_34_rate","age_more_than_85_rate","age_75_84_rate","age_35_44_rate","age_45_54_rate","age_65_74_rate","age_55_64_rate","age_10_14_rate","age_15_17_rate","age_5_9_rate","household_type_family_rate","dropout_16_19_inschool_rate","household_count","average_household_size","housing_unit_count","housing_unit_occupied_count","housing_unit_median_value","housing_unit_median_gross_rent","education_less_than_high_school_rate","education_high_school_graduate_rate","education_college_rate","education_bachelor_rate","education_master_rate","education_professional_school_rate","education_doctoral_rate","race_white_rate","race_black_africa_rate","race_indian_alaska_rate","race_asian_rate","race_islander_rate","race_other_rate","race_two_more_rate","population","population_density",...
    "earth_temperature_amplitude","frost_days","air_temperature","relative_humidity","daily_solar_radiation","atmospheric_pressure","wind_speed","earth_temperature","heating_degree_days","cooling_degree_days","lat","lon","elevation","total_area","water_area","land_area"];
%loading_plot(p(:,1),1);
%loading_plot(p(:,2),2);
score_loading_plot(t(:,1),t(:,2),p(:,1),p(:,2),dataset)

%%

psquared=p(:,1:20).^2;
psquared=psquared';
psum=sum(psquared);
psum=psum';
datasetFilt=[];
indexes=[];
for i=1:size(psum,1)
    if(psum(i,1)>0.179)
        datasetFilt=[datasetFilt,dataset(1,i)];
        indexes=[indexes,i];
    end
end

%% 

%loading_plot(p(:,1),1);
%loading_plot(p(:,2),2);
%score_loading_plot(t(:,1),t(:,2),p(:,1),p(:,2),dataset)
filtBigMat=bigMat(:,indexes);
filtBigMat_CS=(bigMat(:,indexes)-mean(bigMat(:,indexes)))./std(bigMat(:,indexes));
[Q,components]=Q_score_calc(filtBigMat_CS);
[t,p,R2]=eigdecomp(filtBigMat_CS,components);
score_loading_plot(t(:,1),t(:,2),p(:,1),p(:,2),datasetFilt) 

%% PCR
syms t_employment [1 components]
a=(t'*t)^-1*t'*outcomesMat_CS;
y_hat=t_employment*a;
%%
y_hat_calc=zeros(7272,size(outcomesMat_CS,2));
for i=1:size(t,1)
    y_hat_calc(i,:)=double(subs(y_hat,t_employment,t(i,:))) %% takes a while, save it
end


%% plot pcrs
figure
scatter3(t(:,1),t(:,2),y_hat_calc(:,1));
xlabel("t1")
ylabel("t2")
zlabel("Number of Solar Systems/Household (CAS)")
title("PCR - Number of Solar Systems/Household")

figure
scatter3(t(:,1),t(:,2),y_hat_calc(:,5));
xlabel("t1")
ylabel("t2")
zlabel("Solar Panel Area/District Area (CAS)")
title("PCR - Solar Panel Area/District Area")

figure
scatter3(t(:,1),t(:,2),y_hat_calc(:,6));
xlabel("t1")
ylabel("t2")
zlabel("Solar Panel Area/Capita (CAS)")
title("PCR - Solar Panel Area/Capita")

%% find PLS ideal components
[Q_PLS,ideal_components_PLS]=Q_score_calc_PLS(filtBigMat_CS,outcomesMat_CS);

%%
datasetOut=["number_of_solar_system_per_household","solar_panel_divided_by_area","solar_panel_area_per_capita"];
[t_PLS, u_PLS, w_star, c, p_PLS, R2_PLS,w]= nipalspls(filtBigMat,outcomesMat_CS,ideal_components_PLS);
score_loading_plot(t_PLS(:,1),t_PLS(:,2),[w_star(:,1);c([1 5 6],1)],[w_star(:,2);c([1 5 6],2)],[datasetFilt,datasetOut])

%% plot PLSs
y_hat_PLS=t_PLS*c';
figure
scatter3(t_PLS(:,1),t_PLS(:,2),y_hat_PLS(:,1));
xlabel("t1")
ylabel("t2")
zlabel("Number of Solar Systems/Household (CAS)")
title("PLS - Number of Solar Systems/Household")

figure
scatter3(t_PLS(:,1),t_PLS(:,2),y_hat_PLS(:,5));
xlabel("t1")
ylabel("t2")
zlabel("Solar Panel Area/District Area (CAS)")
title("PLS - Solar Panel Area/District Area")

figure
scatter3(t_PLS(:,1),t_PLS(:,2),y_hat_PLS(:,6));
xlabel("t1")
ylabel("t2")
zlabel("Solar Panel Area/Capita (CAS)")
title("PLS - Solar Panel Area/Capita")

%% PCR value comparisons
tiledlayout(3,1)
load('y_hat_calc_importants.mat')

nexttile
hold on
idx=randi(7272,10,1)
i=1:7272
plot(i,y_hat_calc(:,1))
plot(i,outcomesMat_CS(:,1))
xlabel("Data point")
ylabel("Number of Solar Systems/Household (CAS)")
title("PCR vs Actual Results - Number of Solar Systems/Household")
legend("Predicted","Actual")
hold off 

nexttile
hold on
idx=randi(7272,10,1)
i=1:7272
plot(i,y_hat_calc(:,5))
plot(i,outcomesMat_CS(:,5))
xlabel("Data point")
ylabel("Solar Panel Area/District Area (CAS)")
title("PCR vs Actual Results - Solar Panel Area/District Area (CAS)")
legend("Predicted","Actual")
hold off 

nexttile
hold on
i=1:7272
plot(i,y_hat_calc(:,6))
plot(i,outcomesMat_CS(:,6))
xlabel("Data point")
ylabel("Solar Panel Area/Capita (CAS)")
title("PCR vs Actual Results - Solar Panel Area/Capita (CAS)")
legend("Predicted","Actual")
hold off 

%% plot 10 random expected Y to actual Y for PLS
tiledlayout(3,1)
nexttile 
hold on
idx=randi(7272,10,1)
i=1:7272
plot(i,y_hat_PLS(:,1))
plot(i,outcomesMat_CS(:,1))
xlabel("Data point")
ylabel("Number of Solar Systems/Household (CAS)")
title("PLS vs Actual Results - Number of Solar Systems/Household")
legend("Predicted","Actual")
hold off 

nexttile
hold on
idx=randi(7272,10,1)
i=1:7272
plot(i,y_hat_PLS(:,5))
plot(i,outcomesMat_CS(:,5))
xlabel("Data point")
ylabel("Solar Panel Area/District Area (CAS)")
title("PLS vs Actual Results - Solar Panel Area/District Area (CAS)")
legend("Predicted","Actual")
hold off 

nexttile 
hold on
i=1:7272
plot(i,y_hat_PLS(:,6))
plot(i,outcomesMat_CS(:,6))
xlabel("Data point")
ylabel("Solar Panel Area/Capita (CAS)")
title("PLS vs Actual Results - Solar Panel Area/Capita (CAS)")
legend("Predicted","Actual")
hold off 



