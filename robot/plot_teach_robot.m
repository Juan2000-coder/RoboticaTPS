robot;
%% plotear solamente el modelo cinemático
R.plot(q,'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
%R.teach();

%% Plotear con el modelo 3D
p = fileparts(mfilename('fullpath'));
R.plot3d(q, 'path', p);

%q = fileparts(mfilename('fullpath'));
%p = fullfile(q, '../stls/UR10e');
%demmam(p, q);