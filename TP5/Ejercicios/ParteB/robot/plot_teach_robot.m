robot;
%% plotear solamente el modelo cinemático
R.plot(q, 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
R.teach();