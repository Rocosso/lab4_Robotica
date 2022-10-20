%%
rosinit;
%%
motorSvcClient = rossvcclient('dynamixel_workbench/dynamixel_command');%Client creation
motorCommandMsg = rosmessage(motorSvcClient);%Message creation
%%
motorCommandMsg.AddrName = "Goal_Position";
motorCommandMsg.Id = 1;
motorCommandMsg.Value = 400;
call(motorSvcClient,motorCommandMsg); %Service call