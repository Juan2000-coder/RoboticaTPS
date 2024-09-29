clear all;
syms d1 d4 d5 d6 a2 a3
syms q1 q2 q3 q4 q5 q6 q234 q23
syms S1 S2 S3 S4 S5 S6 S23 S234 C1 C2 C3 C4 C5 C6 C23 C234
syms nx ny nz
syms ox oy oz
syms ax ay az
syms px py pz

% parámetros de Denavit-Hartenberg
dh = [0.0   d1   0     pi/2    0   ;
      0.0   0    a2    0       0   ;
      0.0   0    a3    0       0   ;
      0.0   d4   0     pi/2    0   ;
      0.0   d5   0     pi/2    0   ;
      0.0   d6   0     0       0   ];

% vector de variables articulares
q  = [q1 q2 q3 q4 q5 q6]
assume(q1, 'real')
assume(q2, 'real')
assume(q3, 'real')
assume(q4, 'real')
assume(q5, 'real')
assume(q6, 'real')

% objeto que representa al robot
R = SerialLink(dh, 'name', 'UR10e');

% postura
n           = [nx; ny; nz];
o           = [ox; oy; oz];
a           = [ax; ay; az];
p           = [px; py; pz];
T           = [n o a p];
T(4, :)     = [0 0 0 1];
T           = SE3(T);

% lhs equation. T fkine q2 a q6
RHS = SE3(eye(4));
for i = 2:length(R.links)
      RHS = RHS*R.links(i).A(q(i));
end

RHS = simplify(RHS);
RHS = RHS.T;

RHS = subs(RHS, q2 + q3 + q4, q234);
RHS = subs(RHS, q2 + q3, q23);
RHS = simplify(RHS);
RHS = subs(RHS, q4 + q23, q234);

RHS = subs(RHS, sin(q234), S234);
RHS = subs(RHS, cos(q234), C234);

RHS = subs(RHS, sin(q23), S23);
RHS = subs(RHS, cos(q23), C23);

RHS = subs(RHS, sin(q2), S2);
RHS = subs(RHS, cos(q2), C2);

RHS = subs(RHS, sin(q3), S3);
RHS = subs(RHS, cos(q3), C3);

RHS = subs(RHS, sin(q4), S4);
RHS = subs(RHS, cos(q4), C4);

RHS = subs(RHS, sin(q5), S5);
RHS = subs(RHS, cos(q5), C5);

RHS = subs(RHS, sin(q6), S6);
RHS = subs(RHS, cos(q6), C6);

RHS = simplify(RHS);
RHS_latex = latex(RHS);

% rhs equation. inv(1T0)*T
LHS = R.links(1).A(q(1)).inv()*T;
LHS = simplify(LHS);
LHS = LHS.T;
LHS = subs(LHS, cos(q1), C1);
LHS = subs(LHS, sin(q1), S1);
LHS_latex = latex(LHS);

% equation
eq = LHS == RHS;
eqs = [(1:16)' eq(:)];