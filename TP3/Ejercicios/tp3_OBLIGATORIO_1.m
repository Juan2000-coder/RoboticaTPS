clc; clear; close

dh = [0.0   180.7   0       pi/2    0   ;
      0.0   174.15  612.7   0       0   ;
      0.0   0       571.55  0       0   ;
      0.0   0  0    pi/2    0   ;
      0.0   119.85  0       pi/2    0   ;
      0.0   116.55  0       0       0   ]


R = SerialLink(dh,'name','UR10e');
q = [1,1,1,1,1,1];

R.qlim = [-2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi;
          -2*pi,2*pi];

R.offset = [pi/2 pi/2 0 pi/2 -pi 0];

R.plot(q,'scale',0.5,'trail',{'r', 'LineWidth', 2})
R.teach()