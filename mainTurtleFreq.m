clear all; close all; clc;


stock = 'MENT';

FAKER = 1;
REALER = 0;
PLOT = 0;

signal = signalGenerator(stock, FAKER, REALER, PLOT);

% [totalX] = twoDMapOfTurtles(signal);

HeatMapofTurtles(signal);