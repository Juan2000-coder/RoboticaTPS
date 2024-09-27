robot;
p = fileparts(mfilename('fullpath'))
%R.plot(q, 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

% find the path to this specific model
p = fullfile(p, '../../../../stls/UR10e')
R.plot3d(q, 'path', p);

%R.teach();