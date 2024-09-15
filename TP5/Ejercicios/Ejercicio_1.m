clc; clear all; close all;
a1          = 1;
a2          = 1;
DH          =      [0 0 a1 0;
                    0 0 a2 0];
robot       = SerialLink(DH, 'name', '2R');
robot.qlim  = [-pi/2 pi/2
              -pi/2 pi/2];
q = [0 0];
robot.plot(q, 'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);
robot.teach(q);