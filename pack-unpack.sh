#!/usr/bin/env bash

versao() {
    echo -n "$(basename "$0")"
    grep '^# Versão ' "$0" | tail -1 | cut -d : -f 2 | tr -d ' '
    exit 0
}

uso() {
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

compactar_arquivos() {
    local arquivos=("$@")
    echo "${arquivos[@]}"
    echo -e "      *Menu de opções*\n     "
    echo "1. .Tar"
    echo "2. .Tar.gz"
    echo "3. .Tar.bz2"
    echo "4. .Zip"
    echo "5. .Rar"
    
    read -p "Sua opção: " option
    read -p "Insira um nome para o arquivo a ser criado: " arqname

    case $option in
        1) tar -cvf "$arqname.tar" "${arquivos[@]}" ;;
        2) tar -zcvf "$arqname.tar.gz" "${arquivos[@]}" ;;
        3) tar -jcvf "$arqname.tar.bz2" "${arquivos[@]}" ;;
        4) zip "$arqname.zip" "${arquivos[@]}" ;;
        5) rar a "$arqname.rar" "${arquivos[@]}" ;;
        *) echo "Formato não suportado"; exit 1 ;;
    esac
    echo "status da operação: $?"
}

listar_pacote () {
    local arquivos=("$@")
    echo "Modo: LISTAGEM"
    for file in "${arquivos[@]}"; do
        local ext="${file##*.}"
        echo -e "\n arquivo: $file\n"
        case $ext in
            zip) unzip -l "$file" ;;
            rar) unrar l "$file" ;;
            tar | bz2 | gz) tar -tvf "$file" ;;
            *) echo "Formato não suportado"; exit 1 ;;
        esac
    done
    echo -e "______________________________________________\n"
}

descompactar_arquivos() {
    local arquivos=("$@")
    echo "Modo: EXTRAÇÃO"
    for file in "${arquivos[@]}"; do
        local ext="${file##*.}"
        echo -e "\n arquivo: $file\n"
        read -p "Insira um nome para o diretório destino: " dirname
        mkdir -p "./$dirname"

        case $ext in
            zip) unzip "$file" -d ./"$dirname" ;;
            rar) unrar x "$file" ./"$dirname" ;;
            tar) tar -xvf "$file" -C ./"$dirname" ;;
            bz2) tar -jxvf "$file" -C ./"$dirname" ;;
            gz) tar -zxvf "$file" -C ./"$dirname" ;;
            *) echo "Formato não suportado"; exit 1 ;;
        esac
        echo "$?"
    done
    echo -e "______________________________________________\n"
}

# Verifica dependências
# verificar_dependencias

# Variáveis
SELETOR=0
declare -a arquivos

# Tratamento de opções
while getopts ":c:l:x:hv" opcoes; do
    case $opcoes in
        c) SELETOR=1 ;;
        l) SELETOR=2 ;;
        x) SELETOR=3 ;;
        h) uso ;;
        v) versao ;;
        \?) echo "Opção inválida: -$OPTARG"; uso ;;  # Opção inválida
        :) echo "A opção -$OPTARG requer um argumento."; uso ;;   # Falta argumento para uma opção
    esac
done

# Remove as opções da lista de argumentos
shift $((OPTIND - 2))

# Coleta arquivos restantes após as opções
if [ "$#" -gt 0 ]; then
    arquivos+=("$@")
else
    echo "Você deve fornecer arquivos."
    uso
fi

# Escolhe o modo de execução
case $SELETOR in
    1) compactar_arquivos "${arquivos[@]}" ;;
    2) listar_pacote "${arquivos[@]}" ;;
    3) descompactar_arquivos "${arquivos[@]}" ;;
esac

echo "Obrigado!"
exit 0
