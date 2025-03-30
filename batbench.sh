#!/bin/bash

batStatus () {
	#Extraindo a Porcentagem Atual da Bateria do acpi
	BatAtual=`acpi -b | gawk -F ',' -P '{ print $2 }' | gawk -P '{ print $1 }'`

	#Extraindo o tempo restante do acpi
	TempoRestante=`acpi -b | gawk -P '{ print $5 }'` 

	#Extraindo a Taxa de Carregamento/Descarregamento da Bateria
	Taxa=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -e 'energy-rate' | gawk -F ':' -P '{ print $2 }' | sed 's/ //g'` 

	echo "["`date +"%d-%m-%Y - %H:%M:%S"`"]" # Exibe a Data
	echo "Bateria Atual:" $BatAtual #Exibe a porcentagem da bateria
	echo "Tempo restante:" $TempoRestante #Exibe o tempo restante
	echo "Taxa:" $Taxa #Exibe a Taxa de Descarregamento
}

ajudaComandos () {
	echo "
Uso: ./bateria.sh [OPÇÕES]
Opções:
	-l	Registra o estado da Bateria a cada 5 minutos na pasta ~/Logs por algumas vezes.
	-ut	Registra o estado da Bateria por algumas vezes pelo intervalo definido pelo usuário
	-b	Registra o estado da Bateria a cada um minuto na pasta ~/Logs até a bateria atingir a porcentagem restante desejada. O valor padrão é 20%
	-h	Exibe essa tela com as opções disponíveis
"
}

criarLog () {
	if [ -d ~/Logs ]; then # Verificando se a pasta de Logs existe
		echo "" > /dev/null # Jogando a saída fora para prosseguir com o Script
	else 
		mkdir ~/Logs # Se não existe, criar a pasta de Logs
	fi

	Arquivo=~/Logs/Bat_`date +"%d-%m-%Y_%H-%M-%S"`.txt #Variável com a Data do Arquivo de Log

	touch $Arquivo # Criando o Arquivo
}

if [ $# -lt 1 ]; then # Se não tiver argumentos, executar o script normalmente
		batStatus
		exit 1
fi

if [ $1 == "-l" ]; then
	if [ $# -lt 2 ]; then # Verificando se tem as vezes em que o Log será registrado
		echo "Faltou o número de vezes em que o estado da Bateria será registrado.

Uso: ./bateria.sh -l [VEZES]
Exemplo: \"./bateria.sh -l 5\" para fazer cinco registros do estado da Bateria na pasta ~/Logs
"
		exit 1
	fi
	echo "O Log começou a ser gerado em:" `date +"%d-%m-%Y às %H:%M:%S"` "
E serão feitos" $2 "registros com um intervalo de 5 minutos entre cada um deles"
	
	criarLog
	batStatus >> $Arquivo
	
	for ((  runs=1 ; runs<=$2-1 ; runs++ )); do # Jogando a saída para o arquivo de Log
		echo "" >> $Arquivo
		sleep 300
		batStatus >> $Arquivo
	done
	
elif [ $1 == "-ut" ]; then
	if [ $# -lt 3 ]; then # Verificando se tem as vezes em que o Log será registrado
		echo "Faltou o número de vezes em que o estado da Bateria será registrado e o intervalo dos registros.

Uso: ./bateria.sh -ut [VEZES] [INTERVALO]
Exemplo: \"./bateria.sh -ut 5 10\" para fazer cinco registros do estado da Bateria na pasta ~/Logs com um intervalo de 10 minutos a cada registro"
		exit 1
	fi
	echo "O Log começou a ser gerado em:" `date +"%d-%m-%Y às %H:%M:%S"` "
E serão feitos" $2 "registros com um intervalo de" $3 "minutos entre cada um deles"

	criarLog
	batStatus >> $Arquivo
	
	for ((  runs=1 ; runs<=$2-1 ; runs++ )); do # Jogando a saída para o arquivo de Log 
		echo "" >> $Arquivo
		sleep $((60 * $3))
		batStatus >> $Arquivo
	done

elif [ $1 == "-b" ]; then
	BatBenchAtual=`acpi -b | gawk -F ',' -P '{ print $2 }' | gawk -P '{ print $1 }' | tr -d '%'` # Verificando o Valor atual da Bateria
	
	if [ $# -lt 2 ]; then # Colocou o valor na hora de dar o comando?
		BatBench=20 # O valor padrão é 20%, que é a Bateria fraca no Gnome
	else
		BatBench=$2 # O valor definido pelo usuário
	fi
	
	criarLog
	
	echo "O Log começou a ser gerado com" $BatBenchAtual"% de Bateria Restante em" `date +"%d-%m-%Y às %H:%M:%S"` " 
E será feito até" $BatBench"% de Bateria restante com registros num intervalo de um minuto entre eles"
	
	batStatus >> $Arquivo	
	until [ $BatBenchAtual == $BatBench ]; do # Um Loop para fazer o Log até a porcentagem do -b
		BatBenchAtual=`acpi -b | gawk -F ',' -P '{ print $2 }' | gawk -P '{ print $1 }' | tr -d '%'`
		sleep 60
		echo "" >> $Arquivo
		batStatus >> $Arquivo
	done
elif [ $1 == "-h" ]; then
	ajudaComandos
else
	echo "Opção Inválida! Consulte a lista de opções usando o -h"
	
	exit 1
fi
