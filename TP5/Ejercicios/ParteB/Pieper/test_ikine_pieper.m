clc;clear all;
robot;
T  = R.fkine(q);
qq = ikine_pieper(R, T, q, true);