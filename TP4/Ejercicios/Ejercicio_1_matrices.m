Ejercicio_1
sz = size(totales);
N  = sz(2);

for i = 1:N
    T = round(totales{i}, 4);
    disp(latex(sym(vpa(T))));
end