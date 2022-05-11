Ejemplo de los parametros de entrada que debe contener el archivo de texto 
'info_control.txt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EJEMPLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

km		[unidades]
-djpeg	[clas_arch]
default	[name_arch]
1		[imprimir]

0		[x_ini]
50		[x_fin]
5		[x_f]
10		[z_f]
0.25	[h]
0		[aproximacion]
3		[n_capas]
3.0		[vel_capas(1,1)]
3.5		[vel_capas(2,1)]
4.0		[vel_capas(3,1)]
10		[esp_capas(1,1)]
10		[esp_capas(2,1)]
20		[esp_capas(3,1)]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

En el archivo de texto solo deben de ir las variables SIN sus identificadores
en corchetes.

Descripción de los parametros:
[unidades] ------> 	Es una variable de tipo caracter que se utiliza en la subrutina
					que genera las figuras, para que los graficos se muestren con
					las unidades correctas.
					
[clas_arch] -----> 	De requerirse que el programa guarde las figuras en algun 
					formato especial, es necesario especificar cual mediante el 
					comando correcto. Estos formatos pueden ser (mas no se limitan
					a):
						Formato jpeg								COMANDO: -djpeg
						Formato EPS (Encapsulated PostScript)		COMANDO: -depsc
						Formato png									COMANDO: -dpng
						Formato PDF									COMANDO: -dpdf
					
						Para una lista completa de los formatos que MATLAB soporta ver
						la ayuda del comando 'print' (>help print).
				
[name_arch] ----->	Es el nombre clave que llevaran las imagenes generadas en el
					formato especificado por [clas_arch].
				
[imprimir] ------> 	Es una variable de control para indicarle al programa si debe
					guardar las imagenes con el formato [clas_arch] bajo el nombre
					especificado por [name_arch]. Acepta los siguientes valores:
					
						1 ---->	Para indicar que el programa guarde las imagenes.
						0 ----> Para indicar que el programa NO guarde las imagenes.
					
[x_ini]	--------->	Coordenada inicial del eje x.

[x_fin]	--------->	Coordenada final del eje x.

[x_f]	--------->	Coordenada x de la fuente.

[z_f]	--------->	Coordenada z de la fuente.

[h]		--------->	Intervalo de muestreo del medio.

[aproximacion] -->	Tipo de aproximacion que se realizara. A continuacion se muestran
					las opciones. Escribir el numero asociado a la opcion:
						1.- Esquema "simple".
						2.- Esquema "mixto".
						3.- Esquema "mixto simbolico"
					
[n_capas] ------->	Numero de capas. Escriba 1 para un medio homogeneo.
[vel_capas(:,1)] >
[esp_capas(:,1)] >