robot;
p = fileparts(mfilename('fullpath'));  % ruta al directorio de este archivo
p = fullfile(p, 'stls'); % ruta al directorio de los stls 

%% plotear solamente el modelo cinemático
%R.plot(q,'scale', 0.00001,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1}, 'nojoints', 'nobase', 'notiles');
R.plot(q,'scale', 0.001,'jointdiam', 0.001, 'trail', {'r', 'LineWidth', 0.1});

%% Plotear con el modelo 3D
R.plot3d(q, 'path', p);
%[v,f,n,c] = stlread(fullfile(p,'Mesa_stl.stl'));

%translation=[-550 750 0];

%patch('Faces',f,'Vertices',bsxfun(@plus, v.Points, translation),'FaceVertexCData',c,'FaceColor','flat','EdgeColor','none');

%% teach
R.teach();