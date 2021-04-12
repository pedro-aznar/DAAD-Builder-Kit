#!/bin/bash

# VARIABLES

	# DIRECTORIOS	
	
	# Directorio de Triz2SCE (en Mac): donde tenemos el archivo de Python del 
	# conversor:
	dirTrizbort=../../Triz2SCE

	# Directorio raiz donde guardaremos todo sobre el desarrollo de nuestras 
	# aventuras. Es una buena idea que la tengamos en iCloud, Dropbox, etc... 
	dirAventuras=/Users/pedroaznar/Documents/AVENTURAS/
	# Directorio mapeado del proyecto para DosBox:
	dirProyecto=c:\\00_PROYECTOS\\RUTA
	# Directorio del proyecto actual (en nuestro Mac):
	dirProyectoMac=../../00_PROYECTOS/RUTA
	# Directorio donde hemos descargado la última versión del DAAD 
	dirDAAD=c:\\01_DAAD
	# Directorio de recursos en nuestro Mac, que debe contener estos archivos:
	# DCPCIS.Z80: para compilar para CPC en Español
	# GFX.BIN: archivo de gráficos vacío (se utilizará si no tenemos ninguno)
	# iDSK: herramienta línea de comandos para añadir archivos a .DSK.
	#       Si lo no lo tenéis compilado, podéis obtenerlo desde CPCtelera: 
	#       https://lronaldo.github.io/cpctelera/files/readme-txt.html
	# mcrf: Versión DAAD Reborn Compiler, para compilar la versión de Amstrad
	#		sin utilizar CPM.
	dirRecursos=../../02_RECURSOS 
	# Directorio donde tenemos descargado el DAAD, en nuestro Mac:
	dirDAADMac=../../01_DAAD

	# VARIOS
	#
	# Nombre del proyecto: se utilizará en el nombre de los archivos que se generan 
	# y se utilizan en el script
	nomProyecto=RUTA
	# Anexo al nombre del DSK por si queremos utilizarlo para versionado.
	nomDSKver=_TEST.DSK
	# Nombre del DSK, que es el nombre del proyecto, más anexo concatenado.
	nomDSK=$nomProyecto$nomDSKver
	# Nombre del DSK con la ruta del proyecto en el Mac para referencia.
	nomPathDSKver=$dirProyectoMac/$nomDSK
	# Archivo donde tendremos los gráficos de nuestra aventura.
	nomGraficos=GFX.BIN

# FUNCIONES

	# Pausa con mensaje personalizado
	function pause(){
		read -p "$*"
	}

	# Comprueba si existe un archivo
	# Parámetro 1 = Archivo a comprobar
	# Retorna 0 si no existe y 1 si existe
	function existeArchivo(){
	
		if [ -f "$1" ]; then
			existe=1
		else 
			existe=0
		fi

	}

	# Crea archivo SCE a partir de un mapa de Trizbort
	function trizbort()
	{
		python3.9 $dirTrizbort/triz2sce.py $nomProyecto.trizbort
		echo
		pause "Pulsa una tecla..."
		menu
	}

	# [PC] Compila el SCE a DDB y lanza el intérprete de PC en Dosbox
	function interprete()
	{
		open -a dosbox-x --args -c "mount -u C" -c "mount C $dirAventuras" -c "c:" -c "cd $dirProyecto" -c "$dirDAAD\dc $nomProyecto.sce" -c "pause" -c "DEL $dirDAAD\INTERP\$nomProyecto.DDB" -c "COPY $nomProyecto.DDB $dirDAAD\INTERP" -c "cd $dirDAAD\INTERP" -c "INTSD $nomProyecto.DDB"
		menu
	}

	# [AMSTRAD] Crea el .DDB para Amstrad CPC
	function ddb()
	{
		open -a dosbox-x --args -c "mount -u C" -c "mount C $dirAventuras" -c "c:" -c "cd $dirProyecto" -c "$dirDAAD\dc $nomProyecto.sce $nomProyecto -c3 -m3" -c "pause"
		menu
	}

	# [AMSTRAD] Crea el .BIN para Amstrad CPC
	function binario()
	{
		# Verificamos si existe ya BIN con los gráficos
		# O utilizamos uno en blanco desde la carpeta de recursos
		existeArchivo "$nomGraficos"
		if [ "$existe" == 1 ]
		then
			echo "OK: Usango BIN con gráficos en el directorio de proyecto."
		else 
			echo "El BIN con gráficos no existe: importando desde recursos."
			cp $dirRecursos/$nomGraficos $dirProyectoMac
		fi

		$dirRecursos/./mcrf $nomProyecto.bin $dirRecursos/DCPCIS.Z80 $nomProyecto.ddb $dirProyectoMac/$nomGraficos
		pause "Pulsa una tecla..."
		menu
	}

	# [AMSTRAD] Crea la versión en DSK
	function version()
	{
		# Verificamos si existe ya el DSK en el directorio
		existeArchivo "$nomDSK"
		if [ "$existe" == 1 ]
		then
			echo "El DSK existe: se utilizará en la compilación"
		else 
			echo "El DSK no existe: creando uno desde la plantilla..."
			cp $dirDAADMac/LIB/CPC/DAAD_CPC.DSK $dirProyectoMac
			mv DAAD_CPC.DSK $nomDSK
		fi

		#Añadimos la compilación de Amstrad al DSK
		$dirRecursos/./iDSK $nomPathDSKver -i $dirProyectoMac/$nomProyecto.bin
		#Añadimos el archivo de gráficos al DSK
		$dirRecursos/./iDSK $nomPathDSKver -i $dirProyectoMac/$nomGraficos
		pause "Pulsa una tecla..."
		menu
	}

# MENÚ

	function menu(){
	
		clear

		echo
		echo " ██████╗░░█████╗░░█████╗░██████╗░"
		echo " ██╔══██╗██╔══██╗██╔══██╗██╔══██╗"
		echo " ██║░░██║███████║███████║██║░░██║"
		echo " ██║░░██║██╔══██║██╔══██║██║░░██║"
		echo " ██████╔╝██║░░██║██║░░██║██████╔╝"
		echo " ╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░"
		echo
		echo " ********************************"
		echo " *     DAAD Builder Kit v0.01   *"
		echo " *        por @pedroaznar       *"
		echo " ********************************"
		echo " > AVENTURA: $nomProyecto"
		echo 
		echo "  1 Convertir de Trizbort a SCE"
		echo
		echo "  2 [PC] Compilar SCE a DDB y lanzar Interprete"
		echo
		echo "  3 [AMSTRAD] Compilar SCE a DDB"
		echo
		echo "  4 [AMSTRAD] Compilar DDB a BIN"
		echo
		echo "  5 [AMSTRAD] Crea la versión en DSK"
		echo
		echo "  0 SALIR"
		echo
		printf " Elige opción: "
		read opcion

		if [ $opcion -eq 1 ];
		then
			trizbort
		fi

		if [ $opcion -eq 2 ];
		then
			interprete
		fi

		if [ $opcion -eq 3 ];
		then
			ddb
		fi

		if [ $opcion -eq 4 ];
		then
			binario
		fi

		if [ $opcion -eq 5 ];
		then
			version
		fi

		if [ $opcion -eq 0 ];
		then
			exit
		fi

	}

# MAIN

	menu