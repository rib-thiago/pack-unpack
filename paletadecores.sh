# Cores
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

# Cores de fundo
BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_WHITE="\033[47m"

# Estilos
RESET="\033[0m"
BOLD="\033[1m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
INVERT="\033[7m"
HIDDEN="\033[8m"

NEWLINE="\n"


echo -e "${BLACK}Texto em preto${RESET}"
echo -e "${RED}Texto em vermelho${RESET}"
echo -e "${GREEN}Texto em verde${RESET}"
echo -e "${YELLOW}Texto em amarelo${RESET}"
echo -e "${BLUE}Texto em azul${RESET}"
echo -e "${MAGENTA}Texto em magenta${RESET}"
echo -e "${CYAN}Texto em ciano${RESET}"
echo -e "${WHITE}Texto em branco${RESET}"

echo -e "${BG_BLACK}Texto com fundo preto${RESET}"
echo -e "${BG_RED}Texto com fundo vermelho${RESET}"
echo -e "${BG_GREEN}Texto com fundo verde${RESET}"
echo -e "${BG_YELLOW}Texto com fundo amarelo${RESET}"
echo -e "${BG_BLUE}Texto com fundo azul${RESET}"
echo -e "${BG_MAGENTA}Texto com fundo magenta${RESET}"
echo -e "${BG_CYAN}Texto com fundo ciano${RESET}"
echo -e "${BG_WHITE}Texto com fundo branco${RESET}"

echo -e "${RESET}Texto normal${RESET}"
echo -e "${BOLD}Texto em negrito${RESET}"
echo -e "${ITALIC}Texto em itálico${RESET}"
echo -e "${UNDERLINE}Texto sublinhado${RESET}"
echo -e "${BLINK}Texto piscante${RESET}"
echo -e "${INVERT}Texto invertido${RESET}"
echo -e "${HIDDEN}Texto oculto${RESET}"

echo -e "Linha 1${NEWLINE}Linha 2"
