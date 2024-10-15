#!/bin/bash

#############################################################
#                                                           #
#   Script para instalación de migasfree server y client    #
#                                                           #
#############################################################


# Colores 

rojo='\033[0;31m'
verde='\033[0;32m'
naranja='\033[0;33m'
amarillo='\033[1;33m'
azul='\033[0;34m'
magenta='\033[0;35m'
cian='\033[0;36m'
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


# Salir con Ctrl + C

function ctrlc(){

    echo -e "\n\n${rojo}Saliendo..."
    sleep 1
    #clear
    exit 1
}

trap ctrlc SIGINT

# Barra de progreso

function barra_prog(){

    pasos_totales=10

    long_barra=20
    caracter='#'
    barra=''

    echo -e "\n${azul}Instalando...${reset}"

    for ((i=0; i<pasos_totales; i++)); do
        porcentaje=$((i*100/pasos_totales))

        barra=$(printf %${long_barra}s | tr ' ' "${caracter}")
        echo -ne "\r[${barra}] ${porcentaje}%\r"

        sleep 0.5
    done
    echo ""
    echo -ne "\nInstalación completa"

    echo -ne "\n\n"

}

# Comprobación de paquetes

function comprobar_packets() {
    clear

    instld="${verde}Instalado${reset}"
    no_inst="${rojo}No instalado${reset}"

    if dpkg -s haveged &>/dev/null; then
        haveged=$instld
    else
        haveged=$no_inst
    fi

    if docker --version &>/dev/null; then
        docker=$instld
    else
        docker=$no_inst
    fi

    if docker-compose --version &>/dev/null; then
        compose=$instld
    else
        compose=$no_inst
    fi

    echo -e "Comprobando paquetes necesarios...\n"
    sleep 1
    echo -e "Paquetes necesarios para Migasfree server"
    echo -e "-----------------------------------------"
    sleep 1
    echo -e "Haveged: $haveged"
    sleep 1
    echo -e "Docker: $docker"
    sleep 1
    echo -e "Docker-compose: $compose"

    sleep 2
    echo -e "\nPaquetes necesarios para Migasfree client"
    echo -e "-----------------------------------------"
    echo -e "Haveged: $haveged"
    sleep 1
    echo -e "Docker: $docker"
    sleep 1
    echo -e "Docker-compose: $compose"
    echo -e "\n"
    read -p "Pulsa enter para volver al menú" x

}

# Instalación migasfree server

function instalar_server() {

    clear

    necesario=()

    # Chequeo e instalación haveged

    echo -e "\nInstalación de Migasfree server"
    echo -e "${cian}---------------------------------------${reset}"
    echo -e "\nComprobación de paquetes necesarios:\n"
    sleep 1

    if dpkg -s haveged &>/dev/null; then
        echo "\n${verde}Haveged está instalado${reset}"
        necesario+=("haveged")
        sleep 1
    else
        read -p "El paquete haveged no está instalado y es necesario, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            barra_prog
            necesario+=("haveged")

        elif [[ ! ($op == "s" || $op == "S" || $op == "n" || $op == "N") ]]; then
            echo $'\n\e[31mElige una opción válida, pulsa enter\e[0m'
            read -p ""
            instalar_server
        
        else
            true
            : '
            echo -e "\n${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
            '
        fi
            
        sleep 1
    fi

    # Chequeo e instalación docker

    if docker --version &>/dev/null; then
        echo -e "\n${verde}Docker está instalado\n${reset}"
        necesario+=("docker")
        sleep 1
    else
        read -p "El paquete docker no está instalado y es necesario, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            barra_prog
            necesario+=("docker")

        elif [[ ! ($op == "s" || $op == "S" || $op == "n" || $op == "N") ]]; then
            echo "${rojo}Opción no válida, elige si o no"
            read -p $'\n\e[31mElige una opción válida, pulsa enter\e[0m'
            instalar_server
        else
            true
            : '
            echo -e "\n${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
            '
        fi
        sleep 1
    fi

    # Chequeo e instalación docker-compose

    if dpkg -s docker-compose &>/dev/null; then
        echo -e "${verde}Docker está instalado\n"
        necesario+=("docker-compose")
    else
        read -p "El paquete docker-compose no está instalado y su instalación es necesaria, ¿Quieres instalarlo (s/n)?: " op
        if [[ "$op" == "s" ]]; then
            barra_prog
            necesario+=("docker-compose")

        elif [[ ! ($op == "s" || $op == "S" || $op == "n" || $op == "N") ]]; then
            echo $'\n\e[31mElige una opción válida, pulsa enter\e[0m'
            read -p ""
            instalar_server

        else
            true
            : '
            echo -e "\n${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
            '
        fi
        sleep 1
    fi

    paquetes=${#necesario[@]}

    if [[ $paquetes == 3 ]]; then
        read -p "Todo listo para instalar Migasfree server, deseas instalarlo? (s/n)"
        
        sleep 1
        if [[ "$op" == "s" ]]; then
            echo -e "\nProcediendo a instalar y lanzar Migasfree server..."
            barra_prog
            read -p "Pulsa enter para volver al menú..."

        elif [[ ! ($op == "s" || $op == "S" || $op == "n" || $op == "N") ]]; then
            echo $'\n\e[31mElige una opción válida, pulsa enter\e[0m'
            read -p ""
            mostrar_menu

        else
            true
            echo -e "\n${rojo}Saliendo...${reset}"
            sleep 1
            mostrar_menu
        fi
        sleep 1
        
    else
        read -p "Paquetes insuficientes, pulsa enter para volver al menú..."
    fi
}


# function instalar_client() {}



# Función menú

function mostrar_menu() {
    menu="${azul}------- Menu ------${reset}\n\n1. Comprobar paquetes\n2. Instalar Migasfree server\n3. Instalar Migasfree client\n4. Salir${reset}\n"

    while [[ $op != 4 ]]; do

        clear
        echo -e "${naranja}$logo"
        echo -e $menu 
        read -p $'\e[36mElige una opción\e[0m: ' op # Mostra entrada en cian

        case $op in

            1)
                echo -e "\n${verde}Preparando comprobación de paquetes...${reset}"
                sleep 1
                comprobar_packets
                ;;
            2)
                echo -e "\n${azul}Preparando instalación de migasfree server...${reset}"
                sleep 1
                instalar_server
                ;;

            3)
                echo -e "\n${azul}Preparando instalación de migasfree client...${reset}"
                sleep 1
                ;;
            4)
                echo -e "\n${rojo}Saliendo..."
                sleep 1
                exit 1
                ;;
            *)
                echo -e "\n${rojo}Opción no válida${reset}"
                mostrar_menu
                sleep 1
                ;;
        esac

    done

}

# Lanzar menú

mostrar_menu



#-------------------------------------------------------------------------

# Referencias

# Colores: https://www.shellhacks.com/bash-colors/

# Barra de progreso: https://www.golinuxcloud.com/create-bash-progress-bar/

# Logo: https://www.asciiart.eu/text-to-ascii-art