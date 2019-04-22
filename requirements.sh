#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo -e "Por favor, rode como root."
  exit
fi

red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
nc='\e[0m'

programs=("ssh" "git" "python3")

for item in "${programs[@]}"; do
    $(which $item &> /dev/null)

    if [[ $? -ne 0 ]]; then
        if [[ 'git' == $item ]]; then
            $(add-apt-repository ppa:git-core/ppa -y)
        elif [[ 'ssh' == "$item" ]]; then
            item="openssh-server"
        fi

        echo -e "Instalando ${yellow}${item}${nc}...."
        apt-get install ${item} &> /dev/null
        
        if [[ $? -ne 0 ]]; then
            echo -e "${red}[ERRO] Nao foi possivel instalar o programa${nc}${yellow}$item${nc}. ${red}Por favor, contate Lucas Hillebrandt ${yellow}( lucas@lucashillebrandt.com.br )${nc} para tratar este problema.${nc}"
            exit 1
        else
            echo -e "${green}[SUCESSO]${nc} O programa ${yellow}$item${nc} foi instalado com sucesso."
        fi
    else
        echo -e "${green}[SUCESSO]${nc} O programa ${yellow}$item${nc} ja esta instalado."
    fi
done


bits=$(uname -m)

if [[ "x86_64" != "${bits}" ]]; then
    echo -e "${red}[ERRO]${nc} O Sistema instalado nao e 64 bits."
    exit 1
fi

code () {
    $(sh -c 'echo -e "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' &> /dev/null)
    echo -e "Fazendo o Download do ${yellow} Visual Studio Code ${nc}"
    $(curl -sS  --progress-bar https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &> /dev/null)
    $(mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg &> /dev/null)
    $(apt-get update &> /dev/null)
    echo -e "Installando o ${yellow} Visual Studio Code ${nc}"
    $(apt-get install code)

    if [[ $? -ne 0 ]]; then
        echo -e "${red}[ERRO]${nc} Nao foi possivel instalar o${yellow} Visual Studio Code${nc}. Por favor, contate Lucas Hillebrandt ${yellow}( lucas@lucashillebrandt.com.br )${nc} para tratar este problema."
    fi
}

code
