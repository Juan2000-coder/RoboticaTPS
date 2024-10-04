% parámetros de Denavit-Hartenberg
dh = [0.0   0.18070   0             pi/2    0   ;
      0.0   0         0.61270       0       0   ;
      0.0   0         0.57155       0       0   ;
      0.0   0.17415   0             pi/2    0   ;
      0.0   0.11985   0             pi/2    0   ;
      0.0   0.11655   0             0       0   ];


% objeto que representa al robot
R = SerialLink(dh,'name','UR10e');

% dominio de las variables articulares
R.qlim = [-2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi];

% vector de variables articulares
q = [0 0 0 0 0 0];

% desplazamiento del rango articular
R.offset = [pi/2 pi/2 0 pi/2 -pi 0];

% traslación y rotación de la base
transl_base = [0 0 0.1];
roll_base   = 0;
pitch_base  = 0;
yawn_base   = 0;

% traslación y rotación de la herramienta
transl_tool = [0 0 0];
roll_tool   = 0;
pitch_tool  = 0;
yawn_tool   = 0;matlabl

% workspace
workspace   = [-1.5 1.5 -1.5 1.5 -2 2];

% transformación de la base
R.base = transl(transl_base)*trotx(roll_base)*troty(pitch_base)*trotz(yawn_base);

% transformación de la herramienta
R.tool = transl(transl_tool)*trotx(roll_tool)*troty(pitch_tool)*trotz(yawn_tool);