# Laboratorio 4 de Robotica 2022

Por:

Luis Alberto Chavez
Camilo Pineda Correa


En este documento se explica como se configura y se ejecuta el servicio de conexión entre un PINCHERx y ROS instalado en Ubuntu mediante Matlab y Python

# Cinematica directa:

## Modelo y Medidas

Las dimenciones medidas sobre los robots al igual que las disposiciones de los ejes para cada articulación se muestran a continuación. 

![Script](/imagenes/DH_Pincher.png)

estos modelosson independientes del software empleado, sea MatLab, ROS, Python.

## Parametros DH

Los parametros de DH-standard para el robot:

| Link |	alpha |	a	| d |	theta	| offset |
| -- | -- | -- | -- | -- | -- |
| 1	| 90°	| 0	| L1	| q1	| 0 | 
| 2	| 0	| L2	| 0	| q2	| 90° | 
| 3	| 0	| L3	| 0	| q3	| 0 | 
| 4	| 0	| L4	| 0	| q4	| 0 | 


## ROS

Se ha creado un script de python que permite realizar la conexión con ROS y y permite generar el movimiento de cada articuación entre dos posiciones, la primera es el home y la segunda es la psicion de target ue se ha planteado y se definen empleando el nombre de cada articulacion y sus valores en bits.

    Waist
        Home: 0° (512 bits)
        Objective: 32,6° (400 bits)
    Shoulder
        Home: 0° (512 bits)
        Objective: 32,6° (400 bits)
    Elbow
        Home: 0° (512 bits)
        Objective: 32,6° (400 bits)
    Wrist
        Home: 0° (512 bits)
        Objective: 32,6° (400 bits)

este Script permite co
## Explicacion de código

## Video

## Toolbox

## Conexión Matlab 

## Matlab + ROS + Toolbox

## Plot del Robot

## Conexión con ROS

## Conclusiones

