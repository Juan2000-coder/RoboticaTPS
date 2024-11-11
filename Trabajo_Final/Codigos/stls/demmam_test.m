% Al ejecutar pasa los archivos stls en este directotio de mm a m
% No es necesario 
p = fileparts(mfilename('fullpath')); % ruta al directorio de este archivo
demmam(p, p)                          % conversión de stls de mm a m (se sobreescriben)