% parámetros de Denavit-Hartenberg
dh = [0.0000   1.0000    0.0000   pi/2    0   ;
      0.0000   0.0000    1.0000   0.0000  0   ;
      0.0000   0.0000    0.0000   pi/2    0   ;
      0.0000   1.0000    0.0000   pi/2    0   ;
      0.0000   0.0000    0.0000   pi/2    0   ;
      0.0000   1.0000    0.0000   0.0000  0   ];


% objeto que representa al robot
R = SerialLink(dh,'name','6gdl esferica');

% dominio de las variables articulares
R.qlim = [-pi, pi;
          -pi, pi;
          -pi, pi;
          -pi, pi;
          -pi, pi;
          -pi, pi];

% vector de variables articulares
q = [0.4398    -0.3770    0.3770    0.3142    0.6912    0.6912];

% desplazamiento del rango articular
R.offset = [pi/2 pi/2 0 pi pi/2  0];

% base genérica;
% R.base   = trotx(pi/4)*troty(pi/4)*trotz(pi/4)*transl([0.1 0.1 0.1]);

% tool genérica;
% R.base   = trotx(pi/12)*troty(-pi/4)*trotz(pi/4)*transl([0.1 -0.1 0.1]);