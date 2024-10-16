clc; clear all;
robot_sym;      % robot simbólico
pause;     
J   = R.jacob0(q);        % cálculo del jacobiano simbólico
Js  = simplify(J);       % jacobiano simplificado
dJ  = simplify(det(Js));   % determinante simplificado