function Out = RosConect()%inicio y suscripcion a topicos de ros
rosshutdown
rosinit
% Cadera
waistSub = rossubscriber('/waist_controller/state');         % Subscriptor del topic de posición                                                    % Retardo entre muestras
                                                         % Se muestra la posición actual
waistPub = rospublisher('/waist_controller/command','std_msgs/Float64'); 
msg1 = rosmessage(waistPub);
% Hombro
shoulderSub = rossubscriber('/shoulder_controller/state');         % Subscriptor del topic de posición                                                    % Retardo entre muestras
                                                          % Se muestra la posición actual
shoulderPub = rospublisher('/shoulder_controller/command','std_msgs/Float64'); 
msg2 = rosmessage(waistPub);
% Codo
elbowSub = rossubscriber('/elbow_controller/state');         % Subscriptor del topic de posición                                                    % Retardo entre muestras
                                                          % Se muestra la posición actual
elbowPub = rospublisher('/elbow_controller/command','std_msgs/Float64'); 
msg3 = rosmessage(elbowPub);

% Muñeca
wristSub = rossubscriber('/wrist_controller/state');         % Subscriptor del topic de posición                                                    % Retardo entre muestras
                                                          % Se muestra la posición actual
wristPub = rospublisher('/wrist_controller/command','std_msgs/Float64'); 
msg4 = rosmessage(wristPub);
% Mano
handSub = rossubscriber('/hand_controller/state');         % Subscriptor del topic de posición                                                    % Retardo entre muestras
                                                          % Se muestra la posición actual
handPub = rospublisher('/hand_controller/command','std_msgs/Float64'); 
msg5 = rosmessage(handPub);
%%-----------------------------
%Control de velocidad y torque
% Velocidad cintura
[vel1,velreqmsg1] = rossvcclient('/waist_controller/set_speed'); % Cliente de velocidad
velrequest1 = rosmessage(vel1);
velrequest1.Speed = 1;
response = call(vel1,velrequest1);
% Torque y enable cintura
[tor1,torreqmsg1] = rossvcclient('/waist_controller/set_torque_limit'); % Cliente de torque
torrequest1 = rosmessage(tor1);
torrequest1.TorqueLimit = 1;
response = call(tor1,torrequest1);
[tor1e,torreqmsg1e] = rossvcclient('/waist_controller/torque_enable'); % Cliente de torque
torrequest1e = rosmessage(tor1e);
torrequest1e.TorqueEnable = 1;
response = call(tor1e,torrequest1e);

% Velocidad hombro
[vel2,velreqmsg2] = rossvcclient('/shoulder_controller/set_speed'); % Cliente de velocidad
velrequest2 = rosmessage(vel2);
velrequest2.Speed = 1;
response = call(vel2,velrequest2);
% Torque y enable hombro
[tor2,torreqmsg2] = rossvcclient('/shoulder_controller/set_torque_limit'); % Cliente de torque
torrequest2 = rosmessage(tor2);
torrequest2.TorqueLimit = 1;
response = call(tor2,torrequest2);
[tor2e,torreqmsg2e] = rossvcclient('/shoulder_controller/torque_enable'); % Cliente de torque
torrequest2e = rosmessage(tor2e);
torrequest2e.TorqueEnable = 1;
response = call(tor2e,torrequest2e);

% Velocidad codo
[vel3,velreqmsg3] = rossvcclient('/elbow_controller/set_speed'); % Cliente de velocidad
velrequest3 = rosmessage(vel3);
velrequest3.Speed = 1;
response = call(vel3,velrequest3);
% Torque y enable cintura
[tor3,torreqmsg3] = rossvcclient('/elbow_controller/set_torque_limit'); % Cliente de torque
torrequest3 = rosmessage(tor3);
torrequest3.TorqueLimit = 1;
response = call(tor3,torrequest3);
[tor3e,torreqmsg3e] = rossvcclient('/elbow_controller/torque_enable'); % Cliente de torque
torrequest3e = rosmessage(tor3e);
torrequest3e.TorqueEnable = 1;
response = call(tor3e,torrequest3e);

% Velocidad muñeca
[vel4,velreqmsg4] = rossvcclient('/wrist_controller/set_speed'); % Cliente de velocidad
velrequest4 = rosmessage(vel4);
velrequest4.Speed = 1;
response = call(vel4,velrequest4);
% Torque y enable cintura
[tor4,torreqmsg4] = rossvcclient('/wrist_controller/set_torque_limit'); % Cliente de torque
torrequest4 = rosmessage(tor4);
torrequest4.TorqueLimit = 1;
response = call(tor4,torrequest4);
[tor4e,torreqmsg4e] = rossvcclient('/wrist_controller/torque_enable'); % Cliente de torque
torrequest4e = rosmessage(tor4e);
torrequest4e.TorqueEnable = 1;
response = call(tor4e,torrequest4e);
Out=0;
q0=[0,0,0,0,0];
Rospub(q0,waistPub,msg1,shoulderPub,msg2,elbowPub,msg3,wristPub,msg4,handPub,msg5)
end

