close all;
clear;
clc;

% Parametros DH robot
%% Parámetros DH Fanuc
dh = [0 0.450 0.075 -pi/2 0;
      0 0.000 0.300  0.0  0;
      0 0.000 0.075 -pi/2 0;
      0 0.320 0.000  pi/2 0;
      0 0.000 0.000 -pi/2 0;
      0 0.008 0.000  0.0  0];

% Variables articulares
q  = [0 0 0 0 0 0];

% Construcción del robot
fanuc      = SerialLink(dh, 'name', 'FANUC Paint Mate 200iA');

% Offsets iniciales
fanuc.offset = [0.0 0.0 0.0 0.0 0.0 0.0];

% Límites obtenidos del datasheet del robot
fanuc.qlim   = deg2rad([-170   170;
                        -100   100;
                        -194   194;
                        -190   190;
                        -120   120;
                        -360   360]);