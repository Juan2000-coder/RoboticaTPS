clc; clear; close all;

dh = [0.0   0.1807   0       pi/2    0   ;
      0.0   0.17415 0.6127   0       0   ;
      0.0   0       0.57155  0       0   ;
      0.0   0        0       pi/2    0   ;
      0.0   0.11985  0       pi/2    0   ;
      0.0   0.11655  0       0       0   ];

R = SerialLink(dh,'name','UR10e');
q = [1,1,1,1,1,1];

R.qlim = [-2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi];

R.offset = [pi/2 pi/2 0 pi/2 -pi 0];

x_base        = 0;
y_base        = 0;
z_base        = 0.1;
roll_base     = 0;
pitch_base    = 0;
yawn_base     = 0;

x_tool        = 0;
y_tool        = 0;
z_tool        = 0;
roll_tool     = 0;
pitch_tool    = 0;
yawn_tool     = 0;

R.base        = transl(x_base, y_base, z_base)*trotx(roll_base)*troty(pitch_base)*trotz(yawn_base);
R.tool        = transl(x_tool, y_tool, z_tool)*trotx(roll_tool)*troty(pitch_tool)*trotz(yawn_tool);

R.plot(q,'workspace',[-0.5 0.5 0 0.5 -z_base 1.5])
R.plot(q,'scale',0.5,'trail',{'r', 'LineWidth', 2})
R.teach()