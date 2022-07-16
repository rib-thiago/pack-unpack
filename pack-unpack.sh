#!/usr/bin/env bash
# ---------------------------------------------------------------
# Script    : pack-unpack.sh
# Descrição : Compacta, Lista ou Extrai arquivos de pacotes
# Autor     : Thiago Ribeiro <thiago.bernardes@aluno.ifsp.edu.br>
# Data      : 15/07/21
# Licença   : 
# ---------------------------------------------------------------
# Uso: ./pack-unpack [OPÇÕES] <diretórios> ou <arquivos>
# ---------------------------------------------------------------
# Versão 0.1: Primeira versão do script
# Versão 0.2: Adaptado ao getopts (12/04/22)
# Versão 1.0: Suporte a Cpio e formatação de nomes de arquivos de entrada (14/07/2022)
# Versão 1.1: Opção de Extrair após listar (15/05/2022)




# Chave, variéveis e mensagens 
SELETOR=0            # Seleciona as opções do script (1. compacta, 2. lista, 3. extrai)   

versao () {

echo -n "$(basename "$0")" 
grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
exit 0

}

MENSAGEM_USO="

Uso: $(basename "$0") [OPÇÕES] <dir> ou arq1...arqN

OPÇÕES:

	-c  Modo COMPACTAÇÃO
	-l  Modo LISTAGEM
	-x  Modo EXTRAÇÃO
	-h  Exibe este menu de ajuda e encerra programa
	-v  Exibe nome e versão do programa
	
FORMATOS SUPORTADOS: Tar, Gzip, Bzip, Rar, Zip e Cpio

"

MENSAGEM_ERRO_1="

Insira uma opção válida.
Para acessar ajuda, digite

	./pack-unpack.sh -h ou --help

"

MENSAGEM_ERRO_2="

Erro: Faltou argumento para o comando.

Para acessar ajuda, digite

	./pack-unpack.sh -h ou --help
"


## função compactação 

compactArq () {

	echo -e "\nModo: COMPACTAÇÃO\n"
	
	lenght=${#arquivo[*]}
	for ((i=0; i<lenght; i++)); do
		find ${arquivo[i]} -iname "* *" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
		arquivos=($(find ${arquivo[i]} -type f))
	done
	
	comprimento=${#arquivos[*]}
	for ((i=0; i<comprimento; i++)); do
		echo -e ${arquivos[i]}
	done
	
	echo " "
	
	echo -e  "      *Menu de opções*\n     "
	echo     "1. .Tar"
	echo     "2. .Tar.gz"
	echo     "3. .Tar.bz2"
	echo     "4. .Zip"
	echo     "5. .Rar"
	echo -e  "6. .Cpio"
	read -p  "Sua opção: " option
	read -p "Insira um nome para o pacote a ser criado: " arqname 
	
	case  $option in
		1) tar -cvf $arqname.tar ${arquivo[@]} ;;
		2) tar -zcvf $arqname.tar.gz  ${arquivo[@]} ;;
		3) tar -jcvf $arqname.tar.bz2  ${arquivo[@]} ;;
		4) zip -r $arqname.zip  ${arquivo[@]} ;;			
		5) rar a $arqname.rar  ${arquivo[@]} ;;
		6) find ${arquivo[@]} | cpio -o > $arqname.cpio ;;
		*) read -p "Formato não suportado"; exit 1 ;;
	esac
	echo  " "
	read -p "Pressione enter para avançar"
	
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
    		pio) cpio -t < $file;;
	          *) read -p "Formato não suportado" ; exit 1 ;;
	  esac
	  echo  " "
	  read -p "Pressione enter para avançar"
	done
	echo  " "
	read -p "Digite sim para extrair " sim
	[ $sim = "sim" ] 2> /dev/null && descompactArq $* 
}

## função extração 

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
	    pio) cpio -D ./$dirname -iu < $file ;;
	    *) read -p "Formato não suportado" ; exit 1 ;;
	  esac
	  echo  " "
	  read -p "Pressione enter para avançar"
	done
	
}

## cabeçalho do script

printf   "\033[2J\033[H"
echo -e  "~pack-Unpack~ "
sleep 1


## tratamento das variáveis que chegam da linha de comando.

test -z "$1" && echo "$MENSAGEM_ERRO_2" && exit 1


while getopts ":c:l:x:hv" opcoes
do
  case $opcoes in
     c) SELETOR=1   ;; 
     l) SELETOR=2   ;; 
     x) SELETOR=3   ;; 
     h) echo "$MENSAGEM_USO" ; exit 0 ;;
     v) versao ;;
  esac
	shift
	arquivo="$*"
done



# Escolhe o modo de execução
case $SELETOR in
	1) compactArq $* ;;	
	2) listarPct $* ;;		
	3) descompactArq $* ;;
	*) echo "$MENSAGEM_ERRO_1" ; exit 1 ;;
esac


read -p "Obrigado!"

exit
