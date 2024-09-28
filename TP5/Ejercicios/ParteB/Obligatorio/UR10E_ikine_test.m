robotFile = fullfile(fileparts(mfilename('fullpath')), '../../../../robot/robot');
run(robotFile);
T = [0.866 -0.500 0.000 0.800;
     0.500  0.866 0.000 0.300;
     0.000  0.000 1.000 0.400;
     0.000  0.000 0.000 1.000];

Q = UR10e_ikine(R,T);