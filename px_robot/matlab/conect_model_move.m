%%Grafica del robot
l = [14, 10.6, 10.7, 11]; % Longitud de eslabones
% Definicion de links y robot
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
PhantomX = SerialLink(L,'name','Px');
PhantomX.tool = [0 0 1 l(4); -1 0 0 0; 0 -1 0 0; 0 0 0 1];
ws = [-50 50];
% Graficar robot
q = [0, 0, 0, 0, 0; 
    -20, 20, -20, 20, 0;
     30,-30, 30, -30, 0;
    -90, 15, -55, 17, 0;
    -90, 45, -55, 45, 10]
q_rad = deg2rad(q);
pose = 1;
PhantomX.plot(q_rad(pose,1:4),'notiles','noname');
hold on
trplot(eye(4),'rgb','arrow','length',15,'frame','0')
axis([repmat(ws,1,2) 0 60])
% Dibujar Frames
M = eye(4);
for i=1:PhantomX.n
    M = M * L(i).A(q_rad(i));
    trplot(M,'rgb','arrow','frame',num2str(i),'length',12)
end
%% Conexion con ROS
%rosinit('http://172.17.0.1:11311');
rosinit;
%rostopic list
%rostopic info /tf
%%
motorSvcClient = rossvcclient('dynamixel_workbench/dynamixel_command');%Client creation
motorCommandMsg = rosmessage(motorSvcClient);%Message creation
%% Ejecucion de movimiento
motorCommandMsg.AddrName = "Goal_Position";
for i=1:length(q)
    motorCommandMsg.Id = i;
    motorCommandMsg.Value = round(mapfun(q(pose,i),-150,150,0,1023));
    call(motorSvcClient,motorCommandMsg);
end