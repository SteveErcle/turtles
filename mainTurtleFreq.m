clear all; close all; clc;


stock = 'MENT';

FAKER = 1;
REALER = 0;
PLOT = 1;


A = [0.5, 1, 1.5, 2, 4, 7]/4;
P = [24, 31, 52, 84, 122, 543]; 
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2];


signal = signalGenerator(stock, FAKER, REALER, PLOT, A, P, ph);

% [totalX] = twoDMapOfTurtles(signal);

% HeatMapofTurtles(signal);

theta = TideFinder(signal, PLOT,  A, P);
% [theta,cost] = TideFinderGD(signal, PLOT,  A, P);


ph
theta


