#!/usr/bin/env bash
#
#Script: pack-unpack.sh
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
# Versão 0.5: Adaptado ao getopts (12/04/22)
#
# Autor: Thiago Ribeiro <mackandalls@gmail.com>
# Data : 15/07/21
#
#
#

#
# SELETOR=0

versao (){

echo -n "$(basename "$0")" 
grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
exit 0

}


uso (){
  echo "
Uso: $(basename "$0") [OPÇÕES] arq01..arqN

OPÇÕES:

  -c  Modo COMPACTAÇÃO
  -l  Modo LISTAGEM
  -x  Modo EXTRAÇÃO
  -h  Exibe este menu de ajuda e encerra programa
  -v  Exibe nome e versão do programa
"
  exit 0
}

# Função para verificar dependências
verificar_dependencias() {
  local dependencias=("tar" "gzip" "bzip2" "zip" "rar" "unrar" "unzip")
  for dep in "${dependencias[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
      echo "Erro: Dependência '$dep' não encontrada. Instale-a e tente novamente."
      exit 1
    fi
  done
}

# MENSAGEM_ERRO_1="
# 
# Insira uma opção válida.
# Para acessar ajuda, digite
# 
# 	./pack-unpack.sh -h ou --help
# 
# "
# 
# MENSAGEM_ERRO_2="
# 
# Erro: Faltou argumento para: $OPTARG
# 
# Para acessar ajuda, digite
# 
# 	./pack-unpack.sh -h ou --help
# "

compactar_arquivos () {

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


listar_pacote () {

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

descompactar_arquivos () {

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



# Verifica dependências
verificar_dependencias

echo -e  "~pack-Unpack~ "

## tratamento das variáveis que chegam da linha de comando. após o teste com $1, o comando shift retira ele da lista de argumentos
## e o próximo argumento é testado como sendo $1. Quando acabarem os argumentos da lista, o script sai do laço while

#test "$1" == 0 && echo "$MENSAGEM_ERRO_1" 

SELETOR=0
test -z "$1" && echo "$MENSAGEM_ERRO_1" 



while getopts ":c:l:x:hv" opcoes
do
  case $opcoes in
     c) SELETOR=1   ;; 
     l) SELETOR=2   ;; 
     x) SELETOR=3   ;; 
     h) echo "$MENSAGEM_USO" ; exit 0 ;;
     v) versao ;;
     ?) echo "$MENSAGEM_ERRO_1" ; exit 0 ;;
     :) echo "$MENSAGEM_ERRO_2" ; exit 0 ;;
  esac
	shift
	arquivo="$*"
done



# Escolhe o modo de execução
case $SELETOR in
	1) compactar_arquivos $* ;;	#Compacta/Empacota
	2) listar_pacote $* ;;	#Lista conteúdo	
	3) descompactar_arquivos $* ;; #Descompacta
#	*) echo "$MENSAGEM_ERRO" ; exit 1 ;;
esac


read -p "Obrigado!"

exit