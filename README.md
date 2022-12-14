# Laboratorio 4 de Robotica 2022

<div>
<p style = 'text-align:right;'>
<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpw7VUCd_3cj1avB_6YTyQgX4e7nM5mVESyeb72_sLYUPdHkqi1yaDwMyR_tryIhLiRzM&usqp=CAU" alt="Logo UN" width="250px">
</p>
</div>

Por:

*Luis Alberto Chavez* 


*Camilo Pineda Correa*


<div>
<p style = 'text-align:left;'>
<img src="https://static.generation-robots.com/14801-product_cover/phantomx-pincher-robot-arm-kit-with-ax-12-actuators-and-adapter-for-leo-rover-non-assembled.jpg" alt="PhantomX_Pincher_ax-12" width="250px">
</p>
</div>



En este documento se explica como se configura y se ejecuta el servicio de conexión entre un PINCHERx y ROS instalado en Ubuntu mediante Matlab y Python

# Cinematica directa:

## Modelo y Medidas

Las dimenciones medidas sobre los robots al igual que las disposiciones de los ejes para cada articulación se muestran a continuación. 

![Modelo del robot PhantomX Pincher AX-12 ](https://github.com/Rocosso/lab4_Robotica/blob/main/Imagenes/DH_Pincher.png)

Estos modelos son independientes del software empleado, sea MatLab, ROS, Python.

## Parametros DH

Los parametros de DH-standard para el robot:

| Link |	alpha |	a	| d |	theta	| offset |
| -- | -- | -- | -- | -- | -- |
| 1	| 90°	| 0	| L1	| q1	| 0 | 
| 2	| 0	| L2	| 0	| q2	| 90° | 
| 3	| 0	| L3	| 0	| q3	| 0 | 
| 4	| 0	| L4	| 0	| q4	| 0 | 


## ROS

![ROBOT OPERATING SYSTEM](https://www.canonicalrobots.com/images/cursos/ros-logo.png)

Se ha creado un script de python que permite realizar la conexión con ROS y y permite generar el movimiento de cada articuación entre dos posiciones, la primera es el home y la segunda es la psicion de target ue se ha planteado y se definen empleando el nombre de cada articulacion y sus valores en bits.

    * Waist
       * Home: 0° (512 bits)
       * Objective: 25,6° (600 bits)
    * Shoulder
       * Home: 0° (512 bits)
       * Objective: 11° (550 bits)
    * Elbow
       * Home: 0° (512 bits)
       * Objective: 40,1° (650 bits)
    * Wrist
       * Home: 0° (512 bits)
       * Objective: 54,7° (700 bits)

este Script esta ubicado en la carpeta del paquete de PX_robot en este repositorio y su nombre es 

'''
boardOperation.py
'''

Al ejecutar este script el PhantomX puede controlarse de la siguiente manera:

se puede escoger que articulacion se desea mover, en la consola aparecera su nombre.

Con la tecla 'W' se puede ir a la siguiete articulación, con la letra 'S' escoge la anterior articulacion y con la tecla 'D' se envia la articulacion al target escogido y configurado en el script, mientras que con la tecla 'A' se envia al Home de maquina.

Para que el script funciones primero hay que correr los siguiente comandos de ROS:

    px_controllers.launch - permite mover el robot

    px_rviz_dyna.launch - permite mover el robot pero tambien crea una visualizacion en rviz

Para ejecutar el script se debe ingresar a la carpeta del entorno catkin que se este manejando y ejecutar el script de launch del paquete.

A continuación se ingresa la carpeta de scripts del paquete px_robot y finalmente se ejecuta el archivo python.

```python
roslaunch px_robot px_rviz_dyna.launch

cd catkin_ws/src/px_robot/scripts

python boardOperation.py
```

## Explicacion de código


En esta sección del código se sealiza la importacion de librerias para poder operar. 


``` python
import rospy
import numpy
import time
import termios, sys, os
from dynamixel_workbench_msgs.srv import DynamixelCommand
TERMIOS = termios
```

posteriormente se definen las funciones, la primera esta esperando todo el tiempo para recibir la indicacion de que hacer preparada para enviar el mensaje de posicionamiento con los datos que recibe.


``` python
def jointCommand(command, id_num, addr_name, value, time):
    rospy.wait_for_service('dynamixel_workbench/dynamixel_command')                         #Espera la disponibilidad del servicio
    try:                                                                                    #Inicializada en un try para evitar que falle el proceso completo
        dynamixel_command = rospy.ServiceProxy(
            '/dynamixel_workbench/dynamixel_command', DynamixelCommand)                     #Envia el comando con sus parametros llamando la funcion 

        result = dynamixel_command(command,id_num,addr_name,value)
        rospy.sleep(time)                                                                   #Espera un tiempo para ser ejecutado  
        return result.comm_result                                                           #Retorna el resultado
    except rospy.ServiceException as exc:
        print(str(exc))
```


A continuacion la siguiente funcion definida es *getkey*  Esta funcion lee y retorna la tecla presionada.




``` python
def getkey():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    new = termios.tcgetattr(fd)
    new[3] = new[3] & ~TERMIOS.ICANON & ~TERMIOS.ECHO
    new[6][TERMIOS.VMIN] = 1
    new[6][TERMIOS.VTIME] = 0
    termios.tcsetattr(fd, TERMIOS.TCSANOW, new)
    c = None
    try:
        c = os.read(fd, 1)
    finally:
        termios.tcsetattr(fd, TERMIOS.TCSAFLUSH, old)
    return c
```



Esta funcion imprime el nombre y numero de articulacion que se esta manipulando actualmente.


``` python
def printJoint(numJoint):
    if numJoint == 1:
        print("1-waist")
    elif numJoint == 2:
        print("2-shoulder")
    elif numJoint == 3:
        print("3-elbow")
    elif numJoint == 4:
        print("4-wrist")
    elif numJoint == 5:
        print("5-griper")
```



Esta es la funcion main 

``` python
if __name__ == '__main__':
    joints = [[1, 600, 512], [2, 550, 512], [3, 650, 512], [4, 700, 512],[5, 0, 512]]       #Define un arreglo con numero de articulacion, posicion objetivo y posicion home
                                                                                            #Tener en cuenta de que # a que # van las articulaciones, en este caso de 1 a 5, otro puede ser de 6 a 10
    numJoint = 1                                                                            #Define el primer motor 
    printJoint(numJoint)
    try:                                                                                    
        jointCommand('', 1, 'Torque_Limit', 600, 0)                                         #Configura el torque de cada motor
        jointCommand('', 2, 'Torque_Limit', 500, 0)
        jointCommand('', 3, 'Torque_Limit', 400, 0)
        jointCommand('', 4, 'Torque_Limit', 400, 0)
        jointCommand('', 5, 'Torque_Limit', 300, 0)
        while 1:                                                                            #Ciclo infinito en espera de tecla presionada
            key = getkey()                                                                  #Lee la tecla presionada
            if key == b'w':                                                                 #Si es ‘w’, sube de articulación seleccionada
                a = numJoint+1
                if (a > 5):                                                                 #Cierra el ciclo conectando la ultima con la primera articulación
                    numJoint = 1
                else:
                    numJoint = numJoint+1
                printJoint(numJoint)
            if key == b's':                                                                 #Si es ‘s’, baja de articulación seleccionada
                a = numJoint-1
                if (a < 1):                                                                 #Cierra el ciclo conectando la primera con la última articulación
                    numJoint = 5
                else:
                    numJoint = numJoint-1
                printJoint(numJoint)
            if key == b'a':                                                                 #Si es ‘a’, envia el motor a su posicion home 
                jointCommand('', numJoint, 'Goal_Position', joints[numJoint-6][2], 1)
            if key == b'd':                                                                 #Si es ‘d’, envia el motor a su posicion objetivo 
                jointCommand('', numJoint, 'Goal_Position', joints[numJoint-6][1], 1)
        
    except rospy.ROSInterruptException:
        pass
```




## Video

A continuación podra ver el video del robot en movimiento dando click en la imágen sera guiado a youtube. (recomendación hacer control + click)


[![mira el video en Youtube](https://github.com/Rocosso/lab4_Robotica/blob/main/Imagenes/Video.png)](https://www.youtube.com/watch?v=1jJsIieK1R4)



## Toolbox

Se empleó el Toolbox del profesor Peter Corke para definir y visualizar los parametros del robot, asi como para mostrar el modelo , se definieron entonces para cada articulacion los parametros de DH y se definieron basados en las mediciones que se realizaron a los robots PhantomX pincher AX-12.
Luego se realiza un llamado al metodo *Tool* para lograr la orientacion de la muñeca; y finalmente se gráfica empleando el metodo *Teach*, el cual permite variar los parametros del PhantomX mediante una interfaz gráfica.



``` python
l = [14, 10.6, 10.7, 11]; % Longitud de eslabones
% Definicion de links y robot
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
PhantomX = SerialLink(L,'name','Px');
% Orientacion de la herramienta
PhantomX.tool = [0 0 1 l(4); -1 0 0 0; 0 -1 0 0; 0 0 0 1];
PhantomX.teach()
```

## Conexión Matlab 
Para la conexión desde Matlab se genero el siguiente script, que primero realiza la conexión Matlab-Ros a través de *rosinit* inicializando el nodo principal. Ahora relizaremos la comunicación con ayuda de los servicios de dynamixel motors, por lo que se hace necesario crear un cliente, el cual maneja especificamente el servicio *dynamixel_workbench/dynamixel_command* y a su vez el mensaje que le será enviado, cuyos argumentos son definidos correspondientemente a *AddrName*, *Id*, *Value*, para movimiento, número de articulacion y valor de este.


``` python
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
```

## Matlab + ROS + Toolbox
Teniendo en cuenta los 3 puntos desarrollados anteriomente (Comunicación Matlab-ROS, movimiento de robot PhantomX y graficación del mismo), se genero 1 unico script que los ejecuta conjuntamente. Este script se encuentra en la carpeta Matlab de px_robot, con el nombre de "Conect_model_move".

## Plot del Robot

![plot robot empleando PeterCorke ToolBox9.10 en MatLab](https://github.com/Rocosso/lab4_Robotica/blob/main/Imagenes/plot_PhantomX_Pincher_ax-12.png)

Nuevamente se definen las articulaciones con ayuda de *Link* y se genera el robot

``` python
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
```

Luego de esto, teniendo las poses solicitadas, se grafica el robot con la herramenta *plot*, las poses son almacenadas en una matriz *q*.

``` python
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
```

## Conexión con ROS y movimiento

Nuevamente se implementa lo desarrollado para esta comunicación con la conexión a través de *rosinit*, la creación de un cliente para el servicio *dynamixel_workbench/dynamixel_command* y la variación ciclica de los argumentos *Id*, *Value*, para movimiento, a excepcion de *AddrName*, el cual se debe mantener en "Goal_Position" para generar el movimiento. Además se cuenta con una funcion extra "mapfun", la cual realiza el mapeo entre valores en bits y ángulo de rotación, funcion agregada en la misma carpeta.

``` python
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
```

## Conclusiones
* Matlab es una herramienta muy útil para la implementación con ROS, pues a parte de realizar la conexion y comunicacion con este, cuenta con Toolbox, especificamente el de Peter Corke, que aportan una graficación de apoyo para el robot trabajado, definiendolo a partir de sus parametros DH. Y a pesar de no ser desarrollado en su totalidad en Python, cabe resaltar que este tambien cuenta con herramientas similares que permiten desarrollar el mismo ejercicio, incluyendo la herramienta de graficación.
* El trabajo con el brazo robotico PhantomX permite un acercamiento a la manipulación de estos robot a una escala academica, pequeña y sencilla que permite entender mejor su operacion, modelado y trabajo con este tipo de robots.
* ROS es una herramienta importante que estandariza el trabajo con robots, por lo que facilita que la experiencia con alguno especifico sea una buena base para entender otros, incluso de nivel industrial.
