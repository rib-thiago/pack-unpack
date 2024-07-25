#!/usr/bin/env bash
# 
# Script: pack-unpack.sh
#
# Lista, extrai ou compacta arquivos passados como parâmetros
# após opções
# Obs.:  Utiliza as ferramentas Tar, Gzip. Bzip2, Zip e Rar
# Obs1.: Nesta versão, não estão disponíveis os formatos zip e rar
# Obs2.: Para testar nesta plataforma: antes atribua a permissão de executável ao arquivo:
#        chmod +x main.sh
#
#  Para executar no Console:
#        ./main [OPÇÕES] arquivos
#
#
# Versão 0.1: Primeira versão do script
# Versão 0.2: Testando a seleção por formato de arquivo
# Versão 0.3: Adicionando suporte à opções pela linha de comando
# Versão 0.4: Instruções adaptadas à plataforma replit
#
# Autor: Thiago Ribeiro <mackandalls@gmail.com>
# Data : 15/07/21
#


# Chave, variéveis e mensagens 
SELETOR=0            # Seleciona as opções do script (1. compacta, 2. lista, 3. extrai)   
count=1 	      # Variável do contador	

MENSAGEM_USO="

Uso: $(basename "$0") [OPÇÕES] arq01..arqN

OPÇÕES:

	-c 			Modo COMPACTAÇÃO
	-l			Modo LISTAGEM
	-x			Modo EXTRAÇÃO

	-h, --help		Exibe este menu de ajuda e encerra programa
	-v, --version		Exibe nome e versão do programa

"

MENSAGEM_ERRO="

Insira uma opção válida.
Para acessar ajuda, digite

	./pack-unpack.sh -h ou --help

"


## função compactação - recebe um array com arquivos para serem compactados. 

compactArq () {

	echo -e "\nModo: COMPACTAÇÃO\n"
	read -p "${arquivo[*]}"

	echo -e  "      *Menu de opções*\n     "
	echo     "1. .Tar"
	echo     "2. .Tar.gz"
	echo     "3. .Tar.bz2"
	echo     "4. .Zip"
	echo -e  "5. .Rar\n\n"
	read -p  "Sua opção: " option
	read -p "Insira um nome para o arquivo a ser criado: " arqname 

	case  $option in
		1) tar -cvf $arqname.tar ${arquivo[@]} ;;
		2) tar -zcvf $arqname.tar.gz  ${arquivo[@]} ;;
		3) tar -jcvf $arqname.tar.bz2  ${arquivo[@]} ;;
		4) zip $arqname.zip  ${arquivo[@]} ;;			
		5) rar a $arqname.rar  ${arquivo[@]} ;;
		*) read -p "Formato não suportado"; exit 1 ;;
	esac
	echo "status da operação: $?"
	read -p "Pressione enter para avançar "
} 


## função listagem - recebe um array com arquivos empacotados/compactados e lista seu conteúdo. 
## laço for para listar um arquivo por vez

listarPct () {

	read -p "Modo: LISTAGEM"
	read -p "${arquivo[*]}"

	for file in ${arquivo[@]}
	do
	  ext=${file: -3:3}
	  
	  echo -e "\n arquivo: $file\n"
	  case $ext in
	        zip) unzip -l $file ;;
	        rar) unrar l $file ;;
    tar | bz2 | .gz) tar -tvf $file ;;
	          *) read -p "Formato não suportado" ; exit 1 ;;
	  esac
	  echo -e "\n"
	  read -p "Pressione enter para avançar"
	done
	echo -e "______________________________________________\n"
}

## função extração - recebe um array com arquivos empactodaos/compactados e extrai seu conteúdo

descompactArq () {

	read -p "Modo: EXTRAÇÃO"
	read -p "${arquivo[*]}"

	for file in ${arquivo[@]}
	do
	  var2=${file: -3:3}
	  echo -e "\n arquivo: $file\n"
	  read -p "Insira um nome para o diretório destino: " dirname 
	  mkdir ./$dirname

	  case $var2 in
	    zip) unzip $file -d ./$dirname ;;
	    rar) unrar x $file ./$dirname ;;
	    tar) tar -xvf $file -C ./$dirname ;;
	    bz2) tar -jxvf $file -C ./$dirname ;;
	    .gz) tar -zxvf $file -C ./$dirname ;;
	    *) read -p "Formato não suportado" ; exit 1 ;;
	  esac
	  echo "$?" 
	  read -p "Pressione enter para avançar"
	done
	echo -e "______________________________________________\n"
}





printf   "\033[2J\033[H"
echo -e  "~pack-Unpack~ "
sleep 1

## tratamento das variáveis que chegam da linha de comando. após o teste com $1, o comando shift retira ele da lista de argumentos
## e o próximo argumento é testado como sendo $1. Quando acabarem os argumentos da lista, o script sai do laço while

while test -n "$1"
do

	case "$1" in
	
	# Opções que ligam/desligam chaves
	-h | --help ) 
		echo "$MENSAGEM_USO"
		exit 0
	;;
	-v | --version)
		echo -n $(basename "$0")
		# Extrai a versão diretamente dos cabeçalhos do programa
		grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
		exit 0
	;;

	
	
	-c ) SELETOR=1 ;;
	-l ) SELETOR=2 ;;
	-x ) SELETOR=3 ;;
	 * ) 
	 	# array que armazena arquivos a serem tratados. índice é a variável contadora que é incrementada ao final de
	 	# cada ciclo do loop
	 	arquivo[$count]="$1" 
	 ;;
	esac

	# A Opção $1 já processada, a fila deve andar
	shift
	
	# incrementa o contador que serve de índice para o array que armazena os arquivos a serem tratados pelo script
	((count++))
done

# Escolhe o modo de execução
case $SELETOR in
	1) compactArq ${arquivo} ;;	#Compacta/Empacota
	2) listarPct ${arquivo} ;;	#Lista conteúdo	
	3) descompactArq ${arquivo} ;; #Descompacta
	*) echo "$MENSAGEM_ERRO" ; exit 1 ;;
esac


read -p "Obrigado!"

exit
