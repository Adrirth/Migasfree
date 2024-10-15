#!/bin/bash

# Script para instalación de migasfree server y client

# Colores 

rojo='\033[0;31m'
verde='\033[0;32m'
naranja='\033[0;33m'
amarillo='\033[1;33m'
azul='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
negro='\033[0;30m'
gris_claro='\033[0;37m'
blanco='\033[1;37m'
reset='\033[0m'


# Logo migasfree

logo='
888b     d888 d8b                             .d888                         
8888b   d8888 Y8P                            d88P"                          
88888b.d88888                                888                            
888Y88888P888 888  .d88b.   8888b.  .d8888b  888888 888d888 .d88b.   .d88b. 
888 Y888P 888 888 d88P"88b     "88b 88K      888    888P"  d8|  |8b d8|  |8b
888  Y8P  888 888 888  888 .d888888 \Y8888b. 888    888    88888888 88888888
888   "   888 888 Y88b 888 888  888      X88 888    888    Y8|     Y8b|    
888       888 888  \Y88888 \Y888888  88888P/ 888    888     \Y8888   \Y8888 
                       888                                                  
                  Y8b d88P                                                  
                   "Y88P"                                                   
'

# Mostrar el logo


# Ctrl + C

function ctrlc(){

    echo -e "\n${rojo}Saliendo..."
    sleep 1
    exit 1
    clear
}

trap ctrlc SIGINT


# Comprobación de paquetes

function comprobar_packets() {
    clear

    instld="${verde}Instalado${reset}"
    no_inst="${rojo}No instalado${reset}"

    if dpkg -s haveged && docker --version && docker-compose --version &>/dev/null; then
        estado=$instld
    else
        estado=$no_inst
    fi

    echo -e "Comprobando paquetes necesarios...\n"
    sleep 1
    echo -e "Paquetes necesarios para Migasfree server"
    echo -e "-----------------------------------------"
    sleep 1
    echo -e "Haveged: $estado"
    sleep 1
    echo -e "Docker: $estado"
    sleep 1
    echo -e "Docker-compose: $estado"

    sleep 2
    echo -e "\nPaquetes necesarios para Migasfree client"
    echo -e "-----------------------------------------"
    echo -e "Haveged: $estado"
    sleep 1
    echo -e "Docker: $estado"
    sleep 1
    echo -e "Docker-compose: $estado"
    echo -e "\n"
    read -p "Pulsa enter para volver al menú" x

}


# Instalación migasfree server

function instalar_server() {

    clear

    # Chequeo e instalación haveged

    if dpkg -s haveged &>/dev/null; then
        echo "${verde}Haveged está instalado${reset}"
    else
        read -p "El paquete haveged no está instalado y su instalación es necesaria, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            echo -e "${azul}Instalando haveged...\n${reset}"
        else
            echo -e "${rojo}Saliendo...${reset}"
            mostrar_menu
        fi
            
    # echo "sudo apt-get install haveged"
        sleep 1
    fi

    # Chequeo e instalación docker

    if docker --version &>/dev/null; then
        echo -e "${verde}Docker está instalado\n${reset}"
    else
        read -p "El paquete docker no está instalado y su instalación es necesaria, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            # echo apt-get install docker
            echo -e "${azul}Instalando docker...\n${reset}"
        else
            echo -e "${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
        fi
        sleep 1
    fi

    # Chequeo e instalación docker-compose

    if dpkg -s docker-compose &>/dev/null; then
        echo -e "${verde}Docker está instalado\n"
    else
        read -p "El paquete docker-compose no está instalado y su instalación es necesaria, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            # echo apt-get install docker-compose
            echo -e "${azul}Instalando docker-compose...\n${reset}"
        else
            echo -e "${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
        fi
        sleep 1
    fi
}


# function instalar_client() {}


# Función menú

function mostrar_menu() {
menu="${azul}-----Menu----${reset}\n\n1. Comprobar paquetes\n2. Instalar Migasfree server\n3. Instalar Migasfree client\n4. Salir${reset}"

while [[ $op != 4 ]]; do
    clear
    echo -e "${naranja}$logo"
    echo -e $menu 
    read -p "${cyan}Elige una opción: ${reset}" op

    case $op in

        1)
            echo -e "${verde}Preparando comprobación de paquetes...${reset}"
            sleep 1
            comprobar_packets
            ;;
        2)
            echo -e "${azul}Preparando instalación de migasfree server...${reset}"
            sleep 2
            instalar_server
            ;;

        3)
            echo -e "${azul}Preparando instalación de migasfree client...${reset}"
            sleep 2
            ;;
        4)
            echo -e "${rojo}Saliendo..."
            sleep 1
            ;;
        *)
            echo -e "${rojo}Opción no válida${reset}"
            sleep 1
            ;;
    esac

done

}

mostrar_menu