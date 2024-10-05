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
q = [0 0 0 0 0 0];

% desplazamiento del rango articular
R.offset = [pi/2 pi/2 0 pi pi/2  0];

% workspace
workspace   = [-4 4 -4 4 -0 4];

% vector de colores
colores = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F", "#FFFF00"];