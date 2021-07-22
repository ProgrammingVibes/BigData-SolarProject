clear variables;
close all;
clc;

raw = readtable("X after PCA_Y.csv");
raw = table2array(raw);

XPCA = raw(:,1:41);
Y3 = raw(:,42:end);
Y_solarsysperhouse = raw(:,42);
Y_panelareaperarea = raw(:,43);
Y_panelareapercap = raw(:,44);

XPCA_CS = (XPCA - mean(XPCA))./std(XPCA); % mean center and scale data
Y3_CS = (Y3 - mean(Y3))./std(Y3); % mean center and scale data

Y_solarsysperhouse_CS = Y3_CS(:,1);
Y_panelareaperarea_CS = Y3_CS(:,2);
Y_panelareapercap_CS = Y3_CS(:,3);