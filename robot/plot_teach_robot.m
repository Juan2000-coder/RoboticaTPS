robot;
p = fileparts(mfilename('fullpath'));  % ruta al directorio de este archivo
p = fullfile(p, '../stls/UR10e/stls'); % ruta al directorio de los stls 

%% plotear solamente el modelo cinemático
R.plot(q,'scale', 0.00001,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1}, 'nojoints', 'nobase', 'notiles');

%% Plotear con el modelo 3D
R.plot3d(q, 'path', p);

%% teach
R.teach();