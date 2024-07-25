#!/usr/bin/env bash

# Caracteres de Escape
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
RESET="\033[0m"
NEWLINE="\n"
NULL="/dev/null"

versao() {
    echo -n "$(basename "$0")"
    grep '^# Versão ' "$0" | tail -1 | cut -d : -f 2 | tr -d ' '
    exit 0
}

uso() {
    echo -e "
${YELLOW}
Uso: $(basename "$0") [OPÇÕES] arq01..arqN

OPÇÕES:

  -c  Modo COMPACTAÇÃO
  -l  Modo LISTAGEM
  -x  Modo EXTRAÇÃO
  -h  Exibe este menu de ajuda e encerra programa
  -v  Exibe nome e versão do programa
${RESET}
"
    exit 0
}

# Função para verificar dependências
verificar_dependencias() {
    local dependencias=("tar" "gzip" "bzip2" "zip" "rar" "unrar" "unzip")
    for dep in "${dependencias[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${NEWLINE}${RED}Erro: Dependência '$dep' não encontrada. Instale-a e tente novamente.${RESET}"
            exit 1
        fi
    done
}

modo_interativo() {
    clear
    echo -e "${GREEN}MENU INTERATIVO${RESET}"
    echo -e "${NEWLINE} Informe os arquivos ou pacotes: ${NEWLINE}"
    read -a arquivos
    echo -e "${NEWLINE} Escolha o modo: ${NEWLINE}"
    echo "1. Compactar"
    echo "2. Listar"
    echo -e "3. Extrair ${NEWLINE}"
    read -p "Sua opção: " SELETOR
    echo -e "${NEWLINE}"
    clear
}

compactar_arquivos() {
    local arquivos=("$@")
    echo -e "${GREEN}Modo: COMPACTAÇÃO${RESET}"
    echo -e "${NEWLINE}Arquivos:${NEWLINE}"
    echo -e "${YELLOW}${arquivos[@]}${RESET}"
    echo -e "${NEWLINE}FORMATOS DISPONÍVEIS: ${NEWLINE}     "
    echo "1. Tar"
    echo "2. Tar.gz"
    echo "3. Tar.bz2"
    echo "4. Zip"
    echo -e "5. Rar${NEWLINE}"
    
    read -p "Sua opção: " option
    echo -e "${NEWLINE}"
    read -p "Insira um nome para o arquivo a ser criado: " arqname
    echo -e "${NEWLINE}"

    case $option in
        1) tar -cvf "$arqname.tar" "${arquivos[@]}" &> ${NULL} ;;
        2) tar -zcvf "$arqname.tar.gz" "${arquivos[@]}" &> ${NULL} ;;
        3) tar -jcvf "$arqname.tar.bz2" "${arquivos[@]}" &> ${NULL} ;;
        4) zip "$arqname.zip" "${arquivos[@]}" &> ${NULL} ;;
        5) rar a "$arqname.rar" "${arquivos[@]}" &> ${NULL} ;;
        *) echo -e "${RED}Formato não suportado${RESET}"; exit 1 ;;
    esac

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Operação de compactação concluída com sucesso!${RESET}"
    else
        echo -e "${RED}Erro na operação de compactação.${RESET}"
    fi


}

listar_pacote () {
    local arquivos=("$@")
    echo -e "${GREEN}Modo: LISTAGEM${RESET}"
    for file in "${arquivos[@]}"; do
        local ext="${file##*.}"
        echo -e "${NEWLINE}Pacote:${NEWLINE}"
        echo -e "${YELLOW}$file${RESET}${NEWLINE}"
        echo -e "Conteúdo:${NEWLINE}"
        
        # Verificar se o arquivo existe
        if [[ ! -e "$file" ]]; then
            echo -e "${RED}Não é possível abrir $file${RESET}"
            echo -e "${RED}Arquivo ou diretório inexistente${RESET}"
            continue
        fi

        # Processar o arquivo
        case $ext in
            zip) unzip -l "$file" 2>/dev/null | awk 'NR>3 {print $4}' | sed '$d' ;;
            rar) unrar l "$file" 2>/dev/null | sed '1,8d' | tac | sed '1,3d' | tac | awk '{print $NF}' ;;
            tar | bz2 | gz) tar -tf "$file" 2>/dev/null ;;
            *) echo -e "${RED}Formato não suportado${RESET}"; exit 1 ;;
        esac
    done
}

descompactar_arquivos() {
    local arquivos=("$@")
    echo -e "${GREEN}Modo: EXTRAÇÃO${RESET}"
    for file in "${arquivos[@]}"; do
        local ext="${file##*.}"
        echo -e ""${NEWLINE}"Arquivo:${NEWLINE}"
        echo -e "${YELLOW}$file${RESET}${NEWLINE}"
        read -p "Insira um nome para o diretório destino: " dirname
        echo -e "${NEWLINE}"
        mkdir -p "./$dirname"

        case $ext in
            zip) unzip "$file" -d ./"$dirname" &> ${NULL} ;;
            rar) unrar x "$file" ./"$dirname" &> ${NULL} ;;
            tar) tar -xvf "$file" -C ./"$dirname" &> ${NULL} ;;
            bz2) tar -jxvf "$file" -C ./"$dirname" &> ${NULL} ;;
            gz) tar -zxvf "$file" -C ./"$dirname" &> ${NULL} ;;
            *) echo -e "${RED}Formato não suportado${RESET}"; exit 1 ;;
        esac
#       echo "$?"
    done
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Arquivo ${YELLOW}$file${GREEN} extraído com sucesso em ${YELLOW}$dirname${GREEN}.${RESET}"
    else
        echo -e "${RED}Erro ao extrair o arquivo ${YELLOW}$file${RED}.${RESET}"
    fi
}

# Verifica dependências
verificar_dependencias

# Variáveis
SELETOR=0
declare -a arquivos

# Tratamento de opções
while getopts ":c:l:x:ihv" opcoes; do
    case $opcoes in
        c) SELETOR=1; shift $((OPTIND - 2)); arquivos+=("$@") ;;
        l) SELETOR=2; shift $((OPTIND - 2)); arquivos+=("$@");;
        x) SELETOR=3; shift $((OPTIND - 2)); arquivos+=("$@") ;;
        i) modo_interativo "$SELETOR" "$arquivos" ;;
        h) uso ;;
        v) versao ;;
        \?) echo -e "${RED}Opção inválida: -$OPTARG${RESET}"; uso ;;  # Opção inválida
        :) echo -e "${RED}A opção -$OPTARG requer um argumento.${RESET}"; uso ;;   # Falta argumento para uma opção
    esac
done

# Escolhe o modo de execução
case $SELETOR in
    1) compactar_arquivos "${arquivos[@]}" ;;
    2) listar_pacote "${arquivos[@]}" ;;
    3) descompactar_arquivos "${arquivos[@]}" ;;
esac

echo -e "${NEWLINE}${GREEN}Obrigado!${RESET}"
exit 0
