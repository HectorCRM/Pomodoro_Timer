#!/bin/bash

version="1.1"
path_script=$(pwd)
path_pomodoros="$path_script/pomodoros"
path_configuraciones="$path_script/configuraciones"
#COLORES TERMINAL
morado="\e[35m"
rojo="\e[31m"
verde="\e[32m"
amarillo="\e[33m"
azul="\e[34m"
cian="\e[36m"
gris="\e[37m"
blanco="\e[38m"
negro="\e[30m"
reset_color="\e[39m"

contador(){
	local duracion=$1
	local total_segundos=$((duracion * 60))
	
	tput civis #oculta el cursor
	
	while [ $total_segundos -gt 0 ]; do
		local minutos=$((total_segundos / 60))
		local segundos=$((total_segundos % 60))
		printf "\r\e[KQuedan: %02d minutos %02d segundos" "$minutos" "$segundos"
		read -n 1 -t 1 pausa
		if [[ $pausa == [pP] ]]; then
			fin_pausa=false
			while [[ $fin_pausa == false ]]; do
				printf "\r\e[K\e[5;37mPausa \e[0m"
				read -n 1 continuar
				if [[ $continuar == [pP] ]]; then
					fin_pausa=true
				fi
			done
		fi
		#sleep 1
		((total_segundos--))
	done
	tput cnorm #restaura el cursor
	printf "\r\e[K¡Tiempo finalizado!"
	printf '\a'
	sleep 1
	printf '\a'
	sleep 1
	printf '\a'
	sleep 1
	printf '\a'
	sleep 0.5
	printf '\a'
	sleep 0.5
	printf '\a'
	echo
}

#METODO PARA MOSTRAR LA CABECERA DEL PROGRAMA
header(){
if [ ! $color_header ]; then
	echo -e "$morado"
	configuracion="Por defecto"
else
	echo -e "${!color_header}"
	configuracion=$nombre_config
fi

echo "██████╗  ██████╗ ███╗   ███╗ ██████╗ ██████╗  ██████╗ ██████╗  ██████╗     ";
echo "██╔══██╗██╔═══██╗████╗ ████║██╔═══██╗██╔══██╗██╔═══██╗██╔══██╗██╔═══██╗    ";
echo "██████╔╝██║   ██║██╔████╔██║██║   ██║██║  ██║██║   ██║██████╔╝██║   ██║    ";
echo "██╔═══╝ ██║   ██║██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██╔══██╗██║   ██║    ";
echo "██║     ╚██████╔╝██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝██║  ██║╚██████╔╝    ";
echo "╚═╝      ╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝     ";
echo "                                                                           ";
echo "            ████████╗██╗███╗   ███╗███████╗██████╗                         ";
echo "            ╚══██╔══╝██║████╗ ████║██╔════╝██╔══██╗                        ";
echo "               ██║   ██║██╔████╔██║█████╗  ██████╔╝                        ";
echo "               ██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗                        ";
echo "               ██║   ██║██║ ╚═╝ ██║███████╗██║  ██║                        ";
echo "               ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝                        ";
echo "                                                                           ";
echo "                  Versión: $version                                        ";
echo "                  By: Héctor Monroy Fuertes                                ";
echo -e "                  Pomodoro seleccionado:$reset_color$rojo $nombre_pomodoro $reset_color"
if [ ! $color_header ]; then
	echo -e "$morado                  Configuración:$reset_color$rojo $configuracion$reset_color"
else
	echo -e "${!color_header}                  Configuración:$reset_color$rojo $configuracion$reset_color "
fi
if [ ! $color_header ]; then
	echo -e "$morado *************************************************************************** $reset_color"
else
	echo -e "${!color_header}*************************************************************************** $reset_color"
fi
}

 
while true; do
header
if [ ! $color_header ]; then
	echo -e "$azul"
else
	echo -e "${!color_menu}"
fi
echo "1. Iniciar Pomodoro"
echo "2. Seleccionar Pomodoro"
echo "3. Crear nuevo Pomodoro"
echo "4. Ver Pomodoro seleccionado"
echo "5. Configuración"
echo "0. Salir"
read -rp "Elige opción: " opcion
echo -e "$reset_color"

	case $opcion in
		1)
			if [[ ! $nombre_pomodoro ]]; then
				echo -e "$rojo No se ha seleccionado ningun pomodoro $reset_color"
				sleep 1
				clear
			else
				echo -e "Pomodoro configurado:$rojo $nombre_pomodoro $reset_color"
				echo -e "Tiempo de estudio:$rojo $duracion_pomodoro $reset_color"
				echo -e "Tiempo de descanso:$rojo $descanso_pomodoro $reset_color"
				read -rp "¿Qieres utilizarlo?[s/n]: " respuesta
				((veces_utilizado++))
				if [[ $respuesta == [sS] ]]; then
					((veces_utilizado++))
					echo "De acuerdo."
					read -rp "¿Cuantas veces quieres utilizarlo?: " resp_veces
					tiempo_total=$(( duracion_pomodoro * resp_veces ))
					echo -e "Tiempo total de estudio:$rojo $tiempo_total minutos $reset_color"
					echo -e "Recuerda que puedes pulsar 'p' en cualquier momento para pausar el temporizador$reset_color"
					sleep 2
					for (( i=1; i<=resp_veces; i++ )); do
						echo -e "$morado¡Estudia!$reset_color"
						#ver iconos de notify-send desde terminal:  gtk3-icon-browser
						notify-send -i "media-playback-start" "¡A LA CARGA!" "¡Vamos con $duracion_pomodoro minutos de trabajo duro!" --action "pressed=De acuerdo" 
						contador $duracion_pomodoro
						if [ "$i" -lt "$resp_veces" ]; then
							echo -e "$verde¡A descansar! $reset_color"
							notify-send -i "media-playback-pause" "¡DESCANSO!" "Comienza el descanso de $descanso_pomodoro minutos" --action "pressed=De acuerdo"
							contador "$descanso_pomodoro"
						fi
					done
					clear
				else
					echo "Cancelado..."
				fi
			fi	
		;;
		2) #SELECION DE POMODOROS
			echo -e "$gris"
			cd $path_pomodoros
			basename -s .conf *.conf
		    	echo -e "$reset_color"
			read -rp "Selecciona un Pomodoro de la lista: " pomodoro
			source "$pomodoro.conf"
			cd $path_script
			clear
		;;
		3) #CREACION DE POMODOROS
			
			read -rp "Elige un nombre para el Pomodoro: " nombre
			read -rp "Elige una duración de estudio en minutos: " duracion
			read -rp "Elige una duracion de descanso en minutos: " descanso
			timestamp=$(date +"%A %d/%m/%Y a las %H:%M:%S")
			cat <<EOF >> $path_pomodoros/$nombre.conf
#[options]
nombre_pomodoro=$nombre
duracion_pomodoro=$duracion
descanso_pomodoro=$descanso
creado="$timestamp"
veces_utilizado=0
EOF
		clear
		;;
		4)
			echo -e "Nombre:$rojo $nombre_pomodoro $reset_color"
			echo -e "Duración de estudio:$rojo $duracion_pomodoro minutos $reset_color"
			echo -e "Duración de descanso:$rojo $descanso_pomodoro minutos $reset_color"
			echo -e "Fecha y hora creacion:$rojo $creado $reset_color"
			echo -e "Veces utilizado:$rojo $veces_utilizado $reset_color"
			echo
			read -rp "Pulsa 'Enter' para volver"
			clear
			;;
		5)
			clear
			while true; do
			header
			echo "Este menu de configuración permite crear configuraciones de color personalizadas"
			if [ ! $color_header ]; then
				echo -e "$azul"
			else
				echo -e "${!color_menu}"
			fi
			echo "1. Crear configuración"
			echo "2. Seleccionar configuración"
			echo "3. Eliminar configuración"
			echo "0. Salir"
			read -rp "Elige una opción: " opcion_config
			echo -e "$reset_color"
				case $opcion_config in
				1)
					echo -e "$azul"
					echo -e "Colores disponibles:$morado morado$reset_color$verde verde$reset_color$rojo rojo$reset_color$amarillo amarillo$reset_color$azul azul$reset_color$cian cian$reset_color$gris gris$reset_color$blanco blanco$reset_color$negro negro$reset_color"
					read -rp "Elige un color para la cabecera: " color_cabecera
					read -rp "Elige un color para los menus: " color_menus
					read -rp "Dale un nombre a esta configuración: " nombre_conf
					echo -e "$reset_color"
					timestamp=$(date +"%A %d/%m/%Y a las %H:%M:%S")
					cat <<EOF >> $path_configuraciones/$nombre_conf.color
#[options]
nombre_config=$nombre_conf
color_header=$color_cabecera
color_menu=$color_menus
modificado="$timestamp"

EOF
				;;
				2)
					echo -e "$gris"
					cd $path_configuraciones
					basename -s .color *.color
					echo -e "$reset_color"
					read -rp "Selecciona una configuración de la lista: " select_configuracion
					source "$select_configuracion.color"
					cd $path_script
				;;
				3)
					echo -e "$rojo"
					echo $(ls *.color)
					echo -e "$reset_color"
					read -rp "Elige que configuración quieres eliminar: " rm_config
					rm $rm_config.color
					echo -e "Eliminada configuración $rojo$rm_config$reset_color"
					sleep 1
					break
				;;
				0)
					clear
					break
				;;
				*)
					echo -e "$rojo Opción no valida $reset_color"
				;;
				esac
			done
			
			;;
		
		0)
			echo "¡Adiós!"
			sleep 1
			exit 0
			;;
		
		*)
			echo "Opción no valida"
		;;
	esac
done



