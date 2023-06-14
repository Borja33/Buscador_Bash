#!/bin/bash

#Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
blueColour="\033[1;34m"
yellowColour="\033[1;33m"
purpleColour="\033[1;35m"
turquoiseColour="\033[1;36m"
grayColour="\033[1;37m"

#Variables Globales
main_url="https://htbmachines.github.io/bundle.js"

function ctrl_c()
{
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm
  exit 1
}

function helpPanel()
{
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
	echo -e "\t${purpleColour}u)${endColour}${grayColour}Descargar o actualizar archivos necesarios${endColour}"
	echo -e "\t${purpleColour}m)${endColour}${grayColour}Buscar por un nombre de máquina${endColour}"
	echo -e "\t${purpleColour}i)${endColour}${grayColour}Buscar por dirección IP${endColour}"	
	echo -e "\t${purpleColour}d)${endColour}${grayColour}Buscar por dificultad${endColour}"
	echo -e "\t${purpleColour}o)${endColour}${grayColour}Buscar por SO${endColour}"
	echo -e "\t${purpleColour}c)${endColour}${grayColour}Buscar por Certificacion${endColour}"
	echo -e "\t${purpleColour}y)${endColour}${grayColour}Obtener Link de la resolucion de la maquina en youtube${endColour}"
	echo -e "\t${purpleColour}h)${enColour}${grayColour}Mostrar panel de ayuda\n${endColour}"
}

function searchMachine()
{
	machineName="$1"

	validacion=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')

	if [ "$validacion" ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la maquina${endColour}${blueColour} $machineName${endColour}\n"
		cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
	else
		echo -e "\n${redColour}[!]${endColour}${grayColour} No existe la maquina${endColour}${blueColour} $machineName${endColour}\n"
	fi
}

function searchIP()
{
	ip="$1"

	machineName=$(cat bundle.js | grep "ip: \"$ip\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

	if [ $machineName ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} La maquina con IP${endColour}${blueColour} $ip${endColour}${grayColour} es la maquina${endColour}${blueColour} $machineName${endColour}\n"
	else
		echo -e "\n${redColour}[!]${endColour}${grayColour} La direccion IP${endColour}${blueColour} $ip${endColour}${grayColor} no coincide con ninguna maquina${endColour}\n"
	fi
}

function searchLink()
{
	machineName=$1
	
	youtubeLink=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube: | awk 'NF{print $NF}')

	if [ $youtubeLink ]
    then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El link de youtube de la maquina${endColour}${blueColour} $machineName${endColour}${grayColour} es ${endColour}${blueColour} $youtubeLink ${endColour}\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} No existe la maquina${endColour}${blueColour} $machineName${endColour}\n"
    fi
}

function searchDifficulty()
{
	difficulty=$1

	validacion=$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

	if [ "$validacion" ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las maquinas con dificultad${endColour}${blueColour} $dificulty${endColour}\n"
		cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else
		echo -e "\n${redColour}[!]${endColour}${grayColour} No existen maquinas con esa dificultad${endColour}${blueColour} $difficulty${endColour}\n"
	fi
}

function searchSO()
{
	system=$1

	validacion=$(cat bundle.js | grep "so: \"$system\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

	if [ "$validacion" ]
    then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las maquinas con SO${endColour}${blueColour} $system${endColour}\n"
        cat bundle.js | grep "so: \"$system\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' 
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} No existen maquinas con SO${endColour}${blueColour} $system${endColour}\n"
    fi
}

function searchCertification()
{
	certification=$1

	validacion=$(cat bundle.js | grep "like: \"$certification \"*" -C 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

	if [ "$validacion" ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las maquinas con Certificacion${endColour}${blueColour} $certification${endColour}\n"
		cat bundle.js | grep "like: \"$certification \"*" -C 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else
		 echo -e "\n${redColour}[!]${endColour}${grayColour} No existen maquinas con esas certificacion${endColour}${blueColour} $certification${endColour}\n"
	fi
}

function getOSDifficultyMachines()
{
	system=$2
	difficulty=$1

    validacion=$(cat bundle.js | grep "so: \"$system\"" -C 5 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

    if [ "$validacion" ]
    then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las maquinas con SO${endColour}${blueColour} $system${endColour}${grayColour} y dificultad${endColour}${blueColour} $difficulty${endColour}\n"
        cat bundle.js | grep "so: \"$difficulty\"" -C 5 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} No existen maquinas con SO${endColour}${blueColour} $system${endColour}${grayColour} y dificultad${endColour}${blueColour} $difficulty${endColour}\n"
    fi
}

function getCertificationDifficulty()
{
	certification=$1
	difficulty=$2

	validacion=$(cat bundle.js | grep "dificultad: \"$difficulty\"" -C 5 | grep "like: \"$certification \"*" -B 7 | awk "/name:/,/like:/")

	if [ "$validacion" ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las maquinas con Certificacion${endColour}${blueColour} $certification${endColour}${grayColour} y dificultad${endColour}${blueColour} $difficulty${endColour}\n"
		cat bundle.js | grep "dificultad: \"$difficulty\"" -C 5 | grep "like: \"$certification \"*" -B 7 | grep -vE "id:|sku:|ip|so:|skills:" | sed -e 's#name#\"\n\""name#g' -e 's/like/certificacion/g' | tr -d '"' | tr -d ',' 
	else
		echo -e "\n${redColour}[!]${endColour}${grayColour} No existen maquinas con Certificacion${endColour}${blueColour} $certification${endColour}${grayColour} y dificultad${endColour}${blueColour} $difficulty${endColour}\n"
	fi
}

function updateFiles()
{
	tput civis
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando validez de archivos...${endColour}"
	sleep 2
	
	if [ ! -f bundle.js ]
	then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}\n"
		curl -s $main_url > bundle.js 
		js-beautify bundle.js | sponge bundle.js
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados${enColour}\n"
		tput cnorm
	else
		curl -s $main_url > bundle_temp.js
		js-beautify bundle_temp.js | sponge bundle_temp.js
		md5value=$(md5sum bundle.js | awk '{print $1}')
		md5value_temp=$(md5sum bundle_temp.js | awk '{print $1}')
		if [ "$md5value" == "$md5value_temp" ]
		then
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} No hay actualizaciones${endColour}\n"
			rm bundle_temp.js
		else
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Hay actucalizaciones${endColour}\n"
			rm bundle.js
			mv bundle_temp.js bundle.js
		fi
		tput cnorm
	fi
}

#Ctrl+C
trap ctrl_c INT

#Indicadores
declare -i parameter_counter=0

#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_system=0
declare -i chivato_certification=0

while getopts "m:ui:y:d:o:c:h" arg; do
	case $arg in
		m) machineName="$OPTARG"; let parameter_counter+=1;;
		u) let parameter_counter+=2;;
		i) ip="$OPTARG"; let parameter_counter+=3;;
		y) machineName="$OPTARG"; let parameter_counter+=4;;
		d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
		o) system="$OPTARG"; chivato_system=1; let parameter_counter+=6;;
		c) certification="$OPTARG"; chivato_certification=1; let parameter_counter+=7;;
		h) ;;
	esac
done

if [ $parameter_counter -eq 1 ]
then
	searchMachine $machineName
elif [ $parameter_counter -eq 2 ]
then
	updateFiles
elif [ $parameter_counter -eq 3 ]
then
	searchIP $ip
elif [ $parameter_counter -eq 4 ]
then
	searchLink $machineName
elif [ $parameter_counter -eq 5 ]
then
	searchDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]
then
	searchSO $system
elif [ $parameter_counter -eq 7 ]
then
	searchCertification $certification
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_system -eq 1 ]
then
	getOSDifficultyMachines $difficulty $system
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_certification -eq 1 ]
then
	getCertificationDifficulty $certification $difficulty
else
	helpPanel
fi
