clear all; close all; clc;


stock = 'MENT';

FAKER = 1;
REALER = 0;
PLOT = 1;

signal = signalGenerator(stock, FAKER, REALER, PLOT);

twoDMapOfTurtles(signal);