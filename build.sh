#!/bin/bash
PLATFORMIO_DIR=~/.platformio/packages/framework-arduinoespressif32/
ARDUINO_DIR=~/.arduino15/packages/esp32/hardware/esp32/1.0.6/
clear
echo 
echo " + Elige idioma / Select language : "
S_LANG=0
PS3='  -- >  Idioma/Language/: '
options=("Español" "English" "Salir/Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Español")
            echo "        Elegiste $opt"
            S_LANG=1
            break;
            ;;
        "English")
            S_LANG=2
            echo "        Selected $opt"
            break;
            ;;
        "Salir/Quit")
            exit
            ;;
        *) echo " ! Me don't entender what you are diciendo. ( $REPLY )";;
    esac
done

if [ "$S_LANG" -eq "1" ]; then
    echo 
    echo " -------------  -- -- -- -- --   ----   ---   ---   --  --  --   -   -   -     - "
    echo
    echo " + Hola! "
    echo "   Este script recompila el codigo que usa Arduino y Platform.io para programar tus chips esp32."
    echo 
    echo " ~ el dialogo de menuconfig va a aparecer, y podes hacerle cambios.  Tene cuidado! "
    echo 
    echo " ~ la primera vez, todo el proceso puede tardar mas de una hora. +1 paciencia. "
    echo 
    echo "   <url > Usando el script para compilar :  https://github.com/espressif/esp32-arduino-lib-builder.git "
    echo "   <info> Mas informacion sobre las librerias en https://github.com/espressif "
    echo "   <me  > github https://github.com/sabado/esp32-easy-menuconfig "
    echo 
    echo " -----     -----     ---   ---   ---   --  --  --  --  --  -  -   -   -     -     "
    echo "   "
    echo "   Queres instalar las libraries en Arduino/Platform.io cuando termine de compilar ? "
    echo "  "
    PS3=' Elegiste: '
    LANG_SELECTION='Elegido'
    LANG_SELECTION_BOTH='Elegiste ambas plataformas '
    LANG_INVALID_OPTION="Opcion inválida"
    LANG_VALID_PLATFORMIO_DIRECTORIES='Buscando posibles rutas de instalación: Esperá ...'
    LANG_INSTALL="Actualizando las librerías en el directorio "
    LANG_PATH_NOT_EXISTS="La ubicación no existe!"
    LANG_INPUT_SDK_DIR=" Copia una de las rutas anteriores, o ingresa un directorio válido:"
elif [ "$S_LANG" -eq "2" ]; then
    echo 
    echo " -------------  -- -- -- -- --   ----   ---   ---   --  --  --   -   -   -     - "
    echo
    echo " + Hi there! "
    echo "   This script recompile Arduino and Platform.io code used to program your esp32 chips."
    echo 
    echo " ~ menuconfig dialog must appear, allowing changes on esp32 options.  Take care about it. "
    echo 
    echo " ~ full process can take more than an hour to finish, be noticed."
    echo 
    echo "   <url > Using compiler script from :  https://github.com/espressif/esp32-arduino-lib-builder.git "
    echo "   <info> Get more info about libraries on https://github.com/espressif "
    echo "   <me  > github https://github.com/sabado/esp32-easy-menuconfig "
    echo 
    echo " -----     -----     ---   ---   ---   --  --  --  --  --  -  -   -   -     -     "
    echo "   "
    echo "   When build finish. Do you like to install the libraries into Arduino/Platform.io  ? "
    echo "  "
    PS3=' Do your choice: '
    LANG_SELECTION='Selected'
    LANG_SELECTION_BOTH='Selected both platforms '
    LANG_INVALID_OPTION="Invalid option"
    LANG_VALID_PLATFORMIO_DIRECTORIES='Looking for Platform.io installation. Please wait...'
    LANG_INSTALL="Updating libraries on directory "
    LANG_PATH_NOT_EXISTS="Path Not Exists!"
    LANG_INPUT_SDK_DIR="Input sdk path on your installation:"
fi


options=("Platform.io" "Arduino IDE" "Both" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Platform.io")
            echo " + $LANG_SELECTION $opt"
            break;
            ;;
        "Arduino IDE")
            echo " + $LANG_SELECTION $opt"
            break;
            ;;
        "Both")
            echo " + $LANG_SELECTION_BOTH"
            break;
            ;;
        "Quit")
            exit
            ;;
        *) echo "$LANG_INVALID_OPTION $REPLY";;
    esac
done
build(){
    git clone --branch "release/v3.3" https://github.com/espressif/esp32-arduino-lib-builder.git base
    cd base && git apply ../patch/enable.menuconfig.patch
    ./build.sh
}
_DIRTEST=" "
_SELECTED_DIR=" "
input_directory(){
    read -p " ? $LANG_INPUT_SDK_DIR" _DIRTEST
    [[ -d "$_DIRTEST" ]] && _SELECTED_DIR=$_DIRTEST || _DIRTEST=" "
}

find_arduino(){
    echo " + $LANG_VALID_PLATFORMIO_DIRECTORIES"
    find ~/ -path "*esp32/hardware/esp32/1.0.6/" 2>/dev/null
    while [[ $_DIRTEST = " " ]]; do
        input_directory
    done
    ARDUINO_DIR=$_SELECTED_DIR
}

find_platformio(){
    echo " + $LANG_VALID_PLATFORMIO_DIRECTORIES"
    find ~/ -path "*packages/framework-arduinoespressif32/" 2>/dev/null
    while [[ $_DIRTEST = " " ]]; do
        input_directory
    done
    PLATFORMIO_DIR=$_SELECTED_DIR
}

update_platformio_sdk(){
    if [ -d "$PLATFORMIO_DIR" ]; then
        # Take action if $DIR exists. #
        echo " + $LANG_INSTALL ${PLATFORMIO_DIR}"
    else

        echo " ! ERROR  < Platformio > : $LANG_PATH_NOT_EXISTS"
        echo "          ${PLATFORMIO_DIR} "
        find_platformio;

         echo " + $LANG_INSTALL ${PLATFORMIO_DIR}"
    fi

    cp out/* ${PLATFORMIO_DIR} -Rf
}

update_arduino_sdk(){

    if [ -d "$ARDUINO_DIR" ]; then
        # Take action if $DIR exists. #
        echo " + $LANG_INSTALL ${ARDUINO_DIR}"
    else
        echo " ! ERROR  < Arduino > : $LANG_PATH_NOT_EXISTS"
        echo "          ${ARDUINO_DIR} "
        find_arduino;
        echo " + $LANG_INSTALL ${ARDUINO_DIR}"
    fi    
    cp out/* ${ARDUINO_DIR} -Rf
}

build

if [ "$REPLY" -eq "1" ]; then
    update_platformio_sdk
fi

if [ "$REPLY" -eq "2" ]; then
    update_arduino_sdk
fi

if [ "$REPLY" -eq "3" ]; then
    update_platformio_sdk
    _DIRTEST=" "
    _SELECTED_DIR=" "
    update_arduino_sdk
fi
