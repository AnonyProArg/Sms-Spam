#!/bin/bash
cd /etc/VPS-ARG/Sms-Spam
 
detect_distro() {
    if [[ "$OSTYPE" == linux-android* ]]; then
            distro="termux"
    fi

    if [ -z "$distro" ]; then
        distro=$(ls /etc | awk 'match($0, "(.+?)[-_](?:release|version)", groups) {if(groups[1] != "os") {print groups[1]}}')
    fi

    if [ -z "$distro" ]; then
        if [ -f "/etc/os-release" ]; then
            distro="$(source /etc/os-release && echo $ID)"
        elif [ "$OSTYPE" == "darwin" ]; then
            distro="darwin"
        else 
            distro="invalid"
        fi
    fi
}

pause() {
    read -n1 -r -p "Pulse cualquier tecla para continuar..." key
}
banner() {
    clear
    echo -e "\e[1;31m"
    if ! [ -x "$(command -v figlet)" ]; then
        echo 'Inininado Spam'
    else
        figlet Spam
    fi
    if ! [ -x "$(command -v toilet)" ]; then
        echo -e "\e[4;34m SPAM-SMS creado \e[1;32mAnonyProArg \e[0m"
    else
        echo -e "\e[1;34mCreated By \e[1;34m"
        toilet -f mono12 -F border SPAM SMS
    fi
    echo -e "\e[1;34m Bienbenidos al Spam SMS\e[0m"
    echo -e "\e[1;32m    Disfruta y Trollea \e[0m"
    echo -e "\e[4;32m   No usar con fines perversos \e[0m"
    echo " "
    echo "NOTA: Por favor, muévase a la versión PIP de SPAM para mayor estabilidad."
    echo " "
}

init_environ(){
    declare -A backends; backends=(
        ["arch"]="pacman -S --noconfirm"
        ["debian"]="apt-get -y install"
        ["ubuntu"]="apt -y install"
        ["termux"]="apt -y install"
        ["fedora"]="yum -y install"
        ["redhat"]="yum -y install"
        ["SuSE"]="zypper -n install"
        ["sles"]="zypper -n install"
        ["darwin"]="brew install"
        ["alpine"]="apk add"
    )

    INSTALL="${backends[$distro]}"

    if [ "$distro" == "termux" ]; then
        PYTHON="python"
        SUDO=""
    else
        PYTHON="python3"
        SUDO="sudo"
    fi
    PIP="$PYTHON -m pip"
}

install_deps(){
    
    packages=(openssl git $PYTHON $PYTHON-pip figlet toilet)
    if [ -n "$INSTALL" ];then
        for package in ${packages[@]}; do
            $SUDO $INSTALL $package
        done
        $PIP install -r /etc/VPS-ARG/Sms-Spam/requirements.txt
    else
        echo "No pudimos instalar dependencias."
        echo "Asegúrese de tener git, python3, pip3 y los requisitos instalados."
        echo "Entonces puedes ejecutar SMS-SPAM ."
        exit
    fi
}

banner
pause
detect_distro
init_environ
if [ -f .update ];then
    echo "Todos los requisitos encontrados...."
else
    echo 'Requisitos de instalación....'
    echo .
    echo .
    install_deps
    echo Este script fue creado By AnonyProArg > .update
    echo 'Requisitos instalados....'
    pause
fi
while :
do
    banner
    echo -e "\e[4;31mLea atentamente las instrucciones !!! \e[0m"
    echo " "
    echo "1) Inicar SMS  SPAM "
    echo "2) Inicar CALL SPAM  "
    echo "3) Inicar MAIL SPAM  (Todavaia no Disaponible)"
    echo "4) Inicar (Funciona en Linux y emuladores de Linux) "
    echo "5) Salir "
    read ch
    clear
    if [ $ch -eq 1 ];then
        $PYTHON SPAM.py --sms
        exit
    elif [ $ch -eq 2 ];then
        $PYTHON SPAM.py --call
        exit
    elif [ $ch -eq 3 ];then
        $PYTHON SPAM.py --mail
        exit
    elif [ $ch -eq 4 ];then
        echo -e "\e[1;34m Descarga de archivos más recientes ..."
        rm -f .update
        $PYTHON SPAM.py --update
        echo -e "\e[1;34m Iniciando Spam nuevamente..."
        pause
        exit
    elif [ $ch -eq 5 ];then
        banner
        exit
    else
        echo -e "\e[4;32m entrada inválida !!! \e[0m"
        pause
    fi
done
