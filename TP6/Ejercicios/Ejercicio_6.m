clc;
robot_sym;      % robot simbólico    
J   = R.jacob0(q);        % cálculo del jacobiano simbólico
Js  = simplify(J);       % jacobiano simplificado
dJ  = simplify(det(Js));   % determinante simplificado
dJsimp = dJ*2/(a2*a3*sin(q5));
