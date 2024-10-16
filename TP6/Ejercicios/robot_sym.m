% parámetros de Denavit-Hartenberg

syms d1 d4 d5 d6 a2 a3 real
dh = [0.0   d1   0     pi/2    0   ;
      0.0   0    a2    0       0   ;
      0.0   0    a3    0       0   ;
      0.0   d4   0     pi/2    0   ;
      0.0   d5   0     pi/2    0   ;
      0.0   d6   0     0       0   ];


% objeto que representa al robot
R = SerialLink(dh,'name','UR10e');

% vector de variables articulares
syms q1 q2 q3 q4 q5 q6 real
q = [q1 q2 q3 q4 q5 q6];

% desplazamiento del rango articular
R.offset = [pi/2 pi/2 0 pi/2 -pi 0];

% traslación y rotación de la base
transl_base = [0 0 0];
roll_base   = 0;
pitch_base  = 0;
yawn_base   = 0;


% traslación y rotación de la herramienta
transl_tool = [0 0 0];
roll_tool   = 0;
pitch_tool  = 0;
yawn_tool   = 0;


% transformación de la base
R.base = transl(transl_base)*trotx(roll_base)*troty(pitch_base)*trotz(yawn_base);

% transformación de la herramienta
R.tool = transl(transl_tool)*trotx(roll_tool)*troty(pitch_tool)*trotz(yawn_tool);