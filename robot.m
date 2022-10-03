
clear; close;clc
q1=0;q2=0;q3=0;q4=0;l4=9.5;
L(1) = Link([ q1,11.50,0 ,0, 0,0], 'modified',[-pi pi]);
L(2) = Link([ q2,0,0 ,pi/2, 0,pi/2], 'modified',[-pi pi]);
L(3) = Link([ q3,0,10.65 ,0, 0,0], 'modified',[-pi pi]);
L(4) = Link([ q4,0,10.95,0, 0,0], 'modified',[-pi pi]);
PINCHER = SerialLink(L,'name','PINCHER')
q0=[0 0 0 0];
A0T4=fkine(PINCHER,q0);
cosd(90);
cos(pi/2);
vpa(pi/4);
round(cos(pi/2));
A0T4(isAlways(abs(A0T4) <= eps,'Unknown','false'))=0
W=[-10 30 -10 30 -10 50];
PINCHER.tool=troty(pi/2)*trotz(pi/2)*transl(0,0,l4);
PINCHER.plot(q0,'workspace',W);
view(3)
%%mover phanton
in = [15; -17; 2; -pi/4; -1];
q2=Cinv(in)
A0T4=fkine(PINCHER,q2)
W=[-10 30 -10 30 -10 50];
PINCHER.plot(q2','workspace',W);
view(3)
%%
%Conexion ros
%RosConect();
