function demmam(p, q)
    % p: origen
    % q: destino
    files = dir(fullfile(p, '*.stl'));
    for i = 1:length(files)
        % Paso 1: Leer el archivo STL
        model    = stlread(fullfile(files(i).folder, files(i).name));

        % Paso 2: Extraer las coordenadas de los vértices
        vertices = model.Points;

        % Paso 3: Escalar las coordenadas de los vértices (de mm a metros)
        vertices = vertices * 0.001;

        % Paso 4: Crear un nuevo archivo STL en formato ASCII
        fileID   = fopen(fullfile(q, files(i).name), 'w');
        fprintf(fileID, 'solid scaled_model\n');

        % Paso 5: Escribir las caras y vértices en el archivo STL
        faces    = model.ConnectivityList;
        normals  = model.faceNormal;  % Extraer las normales originales

        for i = 1:size(faces, 1)
            %fprintf(fileID, 'facet normal 0.0 0.0 0.0\n');
            % Usar las normales originales en lugar de '0.0 0.0 0.0'
            fprintf(fileID, 'facet normal %.6f %.6f %.6f\n', normals(i, :));
            fprintf(fileID, 'outer loop\n');
            for j = 1:3
                fprintf(fileID, 'vertex %.6f %.6f %.6f\n', vertices(faces(i, j), :));
            end
            fprintf(fileID, 'endloop\n');
            fprintf(fileID, 'endfacet\n');
        end
        % Paso 6: Cerrar el archivo STL
        fprintf(fileID, 'endsolid scaled_model\n');
        fclose(fileID);
    end
end
