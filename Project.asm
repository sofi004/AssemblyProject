; ******************************************************************************
; * Projeto IAC 2022/23 - Versão Intermédia
; * Alunos: Filippo Bortoli(106103), João Gomes(106204), Sofia Piteira(106194)
; ******************************************************************************

; ******************************************************************************
; * Constantes
; ******************************************************************************
DISPLAYS  EQU 0A000H   ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN  EQU 0C000H   ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL  EQU 0E000H   ; endereço das colunas do teclado (periférico PIN)
LINHA  EQU 16   ; linha a testar (4ª linha, 1000b)
MASCARA  EQU 0FH   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
COMANDOS  EQU 6000H   ; endereço de base dos comandos do MediaCenter
DEFINE_LINHA  EQU COMANDOS + 0AH   ; endereço do comando para definir a linha
DEFINE_COLUNA  EQU COMANDOS + 0CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL  EQU COMANDOS + 12H   ; endereço do comando para escrever um pixel
APAGA_AVISO  EQU COMANDOS + 40H   ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ  EQU COMANDOS + 02H   ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H   ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_SOM_VIDEO  EQU COMANDOS + 48H   ; endereço do comando para selecionar uma video ou som
REPRODUZ_SOM_VIDEO  EQU COMANDOS + 5AH   ; endereço do comando para iniciar a reprodução dum video ou som

COR_PIXEL_VERDE  EQU 0C0F0H   ; cor do pixel: verde em ARGB

; ##############################################################################
; * ZONA DE DADOS 
; ##############################################################################
PLACE  1000H
pilha:  TABLE 100H   ; espaço reservado para a pilha 200H bytes, 100H words
; ******************************************************************************
; * Código
; ******************************************************************************
PLACE  0   ; o código tem que começar em 0000H
inicio:
    MOV  [APAGA_AVISO], R1   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1   ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0   ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1   ; seleciona o cenário de fundo


;###############################################################################

; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS   ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R6, 0100H   ; inicializa o valor de R6 a 100H para colocar no display
    MOV  [R4], R6   ; inicializa o display a 100
    MOV  R7, 0   ; inicializa R7 a 0 para simbolizar que o jogo ainda não está a correr

; corpo principal do programa

; teclado

restart_linhas:
    MOV R1, LINHA

espera_tecla:   ; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1   ; passa para a linha seguinte
    CMP  R1, 0   ; verifica se ja passamos pelas linhas todas
    JZ  restart_linhas ; a linha que estamos a ver volta ao inicio
    MOVB  [R2], R1   ; escrever no periférico de saída (linhas)
    MOVB  R0, [R3]   ; ler do periférico de entrada (colunas)
    AND  R0, R5   ; elimina bits para além dos bits 0-3
    CMP  R0, 0   ; há tecla premida?
    JZ   espera_tecla   ; se nenhuma tecla for primida, repete
    SHL  R1, 4   ; coloca linha no nibble high
    OR   R1, R0   ; junta coluna (nibble low)
    JMP escolhe_funcao   ; verifica se a tecla primida está associada a alguma função


escolhe_funcao:
    MOV  R8, 0081H       
    CMP  R1, R8   ; verifica se a tecla primida é a c
    JZ  inicia_jogo   ; se a tecla primida for c, executa inicia_jogo
    CMP  R7, 1
    JZ  fases_jogo
    JMP restart_linhas   ; se a tecla primida não está associada a nenhuma função volta a restart_linhas

inicia_jogo:
    MOV  R7, 1   ; coloca 1 no registo para sabermos se o jogo está a correr ou não
    MOV  R1, 0   ; video número 0
    MOV  [SELECIONA_SOM_VIDEO], R1   ; seleciona um video para cenário de fundo
    MOV  [REPRODUZ_SOM_VIDEO], R1   ; inicia a reprodução do video de fundo do jogo
    JMP  restart_linhas   ; depois de iniciar o jogo volta a restart linhas 
    
 fases_jogo:
	JMP fim
    
fim:
    JMP fim   ; termina o programa
