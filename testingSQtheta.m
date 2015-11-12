% testingSQtheta

clear all
clc
close all

t = 0:99;

sigMod = (cos(2*pi*1/33*t + 1.5) + 2*cos(2*pi*1/55*t + 1.1))';

A = [1, 2];
P = [33, 55];

t = TideFinder(sigMod, A, P);

[theta] = t.getTheta('SQ')