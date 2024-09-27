robot;
p = 'C:\Users\Public\Documents\UNCUYO\4-Cuarto_anio\2-Octavo_Semestre\6-Robotica I\3-TPS\TPS\stls\UR10e';
%R.plot(q, 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
R.plot3d(q, 'path', p);
%R.teach();