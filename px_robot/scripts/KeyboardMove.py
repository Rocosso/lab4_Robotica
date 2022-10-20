import rospy
import numpy
import time
import termios, sys, os
from dynamixel_workbench_msgs.srv import DynamixelCommand
TERMIOS = termios

## Con esta funcion se crea el servicio para controlar los motores dynamixel
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

## Esta funcion lee y retorna la tecla presionada.
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

## Esta funcion imprime el nombre y numero de articulacion que se esta manipulando actualmente.
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

## Esta es la funcion main 
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