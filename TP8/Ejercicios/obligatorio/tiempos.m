dt       = 0.1;
segundos = 3;

t1 = 0:dt:3; %Desde home hasta la mesa de las pastillas y alineacion con la tapa

t2 = t1(end):dt:t1(end)+segundos; %Aproximacion a la tapa

t3 = t2(end):dt:t2(end)+segundos; %Apertura de tapa (giro de 360° antihorario)

t4 = t3(end):dt:t3(end)+segundos; %ALejamiento de la tapa (inversa de la aproxmiacion)

t5 = t4(end):dt:t4(end)+segundos; %Dejar tapa en la mesa

t6 = t5(end):dt:t5(end)+segundos; %Ir a la cámara, punto intermedio 1
t7 = t6(end):dt:t6(end)+segundos; %Ir a la cámara, punto intermedio 2
t8 = t7(end):dt:t7(end)+segundos; %Ir a la cámara, punto intermedio 3 y final

t9 = t8(end):dt:t8(end)+segundos; %Aproximacion a la tapa de la camara

t10 = t9(end):dt:t9(end)+segundos; %Apertura de tapa de la camara (giro de 360° antihorario)

t11 = t10(end):dt:t10(end)+segundos; %Alejamiento de la tapa de la camara (inversa de la aproximacion) (intermedio 3)

t12 = t11(end):dt:t11(end)+segundos; %Dejar tapa en el suelo

t13 = t12(end):dt:t12(end)+segundos; %Volver de la cámara, punto intermedio 3 y final
t14 = t13(end):dt:t13(end)+segundos; %Volver de la cámara, punto intermedio 2
t15 = t14(end):dt:t14(end)+segundos; %Volver de la cámara, punto intermedio 1

t16 = t15(end):dt:t15(end)+segundos; %Ir a la mesa (mismo punto que t1)

t17 = t16(end):dt:t16(end)+segundos; %Aproximacion a la pastilla (mismo punto que t2)

t18 = t17(end):dt:t17(end)+segundos; %Alejamiento con la pastilla (mismo punto que t4)

t19 = t18(end):dt:t18(end)+segundos; %Ir a la cámara, punto intermedio 1
t20 = t19(end):dt:t19(end)+segundos; %Ir a la cámara, punto intermedio 2
t21 = t20(end):dt:t20(end)+segundos; %Ir a la cámara, punto intermedio 3 y final

t22 = t21(end):dt:t21(end)+segundos; %Aproximacion con la pastilla a la camara (mismo punto que t9)

t23 = t22(end):dt:t22(end)+segundos; %Alejamiente de la camara sin la pastilla (mismo punto que t11)

t24 = t23(end):dt:t23(end)+segundos; %Empujar la pastilla a la camara (mismo punto que t9 y t22) con el gripper cerrado

t25 = t24(end):dt:t24(end)+segundos; %Recoger la tapa (mismo punto que t12)

t26 = t25(end):dt:t25(end)+segundos; %Aprox a la camara, punto intermedio 3 y final

t27 = t26(end):dt:t26(end)+segundos; %Cerrar tapa de la camara (mismo punto que t10) (giro de 360° horario)

t28 = t27(end):dt:t27(end)+segundos; %Alejamiento de la camara (mismo punto que t11) intermedio 3 final

t29 = t28(end):dt:t28(end)+segundos; %imtermedio 2

t30 = t29(end):dt:t29(end)+segundos; %intermedio 1

t31 = t30(end):dt:t30(end)+segundos; %Buscar la tapa de la mesa (mismo punto que t5)

t32 = t31(end):dt:t31(end)+segundos; %Aproximarse a la tapa (mismo punto q t2)

t33 = t32(end):dt:t32(end)+segundos; %cerrar la tapa (mismo punto que t3) giro 360° horario

t34 = t33(end):dt:t33(end)+segundos; %HOMING

t35 = t34(end):dt:t34(end)+segundos; %Alejamiento de la tapa (mismo punto que t4)

t36 = t35(end):dt:t35(end)+segundos; %Ir a la cámara, punto intermedio 1
t37 = t36(end):dt:t36(end)+segundos; %Ir a la cámara, punto intermedio 2
t38 = t37(end):dt:t37(end)+segundos; %Ir a la cámara, punto intermedio 3 y final

t39 = t38(end):dt:t38(end)+segundos; %Aproximacion a la tapa de la camara (mismo punto que t9)

t40 = t39(end):dt:t39(end)+segundos; %Apertura de tapa de la camara (giro de 360° antihorario)
t = [t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40];