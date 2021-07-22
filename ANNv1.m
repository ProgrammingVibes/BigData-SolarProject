%4H project
%play with ann toolbox
%experiment with # of nodes per layer, testing/validation %, others...
%try 3, 5, 10, 20 nodes

%load data

clear variables;
close all;
clc;

raw = readtable("preprocessed-cleaner Y.csv");
rawgeo = readtable("Geography.csv");
rawemploy = readtable("Employment.csv");
rawenergy = readtable("Energy.csv");
rawpoli = readtable("Politics.csv");
rawpop = readtable("Population.csv");
rawtrans = readtable("Transporation.csv");

Xall = table2array(raw(:,16:140));

Xdailysolarrad = table2array(rawgeo(:,5));
Xgeo = table2array(rawgeo);
Xempl = table2array(rawemploy);
Xenergy = table2array(rawenergy);
Xpoli = table2array(rawpoli);
Xpop = table2array(rawpop);
Xtrans = table2array(rawtrans);

Yall = table2array(raw(:,4:15));
%Y578 = table2array(raw(:,[5 7 8])); % tilecount, total panel area, density
Y78 = table2array(raw(:,[7 8])); % tilecount, total panel area, density
Y7 = table2array(raw(:,7)); % total panel area


