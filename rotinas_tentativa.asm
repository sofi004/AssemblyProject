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
SUSPENDE_SOM_VIDEO  EQU COMANDOS + 5EH   ; endereço do comando para pausar video ou som
CONTINUA_SOM_VIDEO  EQU COMANDOS + 60H   ; endereço do comando para continuar video ou som
TERMINA_SOM_VIDEO  EQU COMANDOS + 66H   ; endereço do comando para terminar a reprodução do som ou video

COR_PIXEL_VERDE  EQU 0C0F0H   ; cor do pixel: verde em ARGB

; ##############################################################################
; * ZONA DE DADOS 
; ##############################################################################
PLACE  1000H
STACK 100H   ; espaço reservado para a pilha 200H bytes, 100H words
	SP_init:
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
    MOV SP, SP_init
    MOV  R0, 0   ; inicializa R0 a 0 para simbolizar que o jogo ainda não está a correr
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS   ; endereço do periférico dos displays
    MOV  R5, 0100H   ; inicializa o valor de R5 a 100H para colocar no display
    MOV  [R4], R5   ; inicializa o display a 100

; ******************************************************************************
; corpo principal do programa
; ******************************************************************************
ciclo: 
    CALL  teclado   ; verifica se alguma tecla foi carregada
    CALL  escolhe_rotina   ;escolhe a rotina a usar tendo em conta a tecla primida
    CMP  R0, 1   ; o jogo está a correr?
    JNZ  ciclo   ; só desenha o asteroide se o jogo estiver a correr
    CALL asteroide_bom   ; desenha o asteroide bom no canto superior esquerdo
    JMP  ciclo

; ******************************************************************************
; teclado - Processo que detecta quando se carrega numa tecla do teclado.
; ******************************************************************************
teclado:
    PUSH  R0
    PUSH  R2
    PUSH  R4

restart_linhas:
    MOV R1, LINHA   ; coloca 16 = 10000B em R1

espera_tecla:   ; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1   ; passa para a linha seguinte
    CMP  R1, 0   ; verifica se ja passamos pelas linhas todas
    JZ  restart_linhas ; voltamos ao inicio das linhas 
    MOVB  [R2], R1   ; escrever no periférico de saída (linhas)
    MOVB  R0, [R3]   ; ler do periférico de entrada (colunas)
    MOV  R4, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    AND  R0, R4   ; elimina bits para além dos bits 0-3
    CMP  R0, 0   ; há tecla premida?
    JZ   espera_tecla   ; se nenhuma tecla for primida, repete
    SHL  R1, 4   ; coloca linha no nibble high
    OR   R1, R0   ; junta coluna (nibble low)

    POP  R4
    POP  R2
    POP  R0
    RET
; ******************************************************************************
; escolhe_rotina - Processo que executa a instrução associada à tecla primida
; ******************************************************************************
escolhe_rotina:
    PUSH  R4
    PUSH  R5

    MOV  R4, 0081H       
    CMP  R1, R4   ; verifica se a tecla primida é a c
    JZ  inicia_jogo_verificação   ; se a tecla primida for c, executa inicia_jogo
    CMP  R0, 0   ; o jogo ainda não está a correr?
    JNZ  fases_jogo   ; se o jogo já começou
    JMP retorna_ciclo; se a tecla primida não está associada a nenhuma função volta a restart_linhas

inicia_jogo_verificação:
    CMP  R0, 0   ; o jogo está a correr?
    JZ  inicia_jogo   ; se o jogo não está a correr vamos pô-lo a correr 
    JMP  retorna_ciclo  ; senão vamos esperar pela tecla c para o por a correr
inicia_jogo:
    MOV  R0, 1   ; coloca 1 no registo para sabermos se o jogo está a correr ou não
    MOV  R5, 0   ; video número 0
    MOV  [SELECIONA_SOM_VIDEO], R5   ; seleciona um video para cenário de fundo
    MOV  [REPRODUZ_SOM_VIDEO], R5   ; inicia a reprodução do video de fundo do jogo
    JMP  retorna_ciclo   ; depois de iniciar o jogo volta a restart linhas 
    
 fases_jogo:
    MOV  R4, 0082H       
    CMP  R1, R4   ; verifica se a tecla primida é a d
    JZ  suspende_jogo   ; se a tecla primida for d, executa suspende_jogo
    MOV  R4, 0084H      
    CMP  R1, R4   ; verifica se a tecla primida é a e
    JZ  termina_jogo   ; se a tecla primida for e, executa termina_jogo
    JMP  retorna_ciclo
suspende_jogo:
    CMP  R0, 2   ; o jogo já começou e está parado?
    JZ   continua_jogo   ;   prosseguir com o jogo
    MOV  R5, 0
    MOV  [SUSPENDE_SOM_VIDEO], R5  ; pausa o video de fundo do jogo
    MOV  R0, 2   ; coloca o valor 2 no R0, simbolizando o facto de o jogo já ter começado, mas estar parado
    MOV  R5, 0
    MOVB  [R3], R5
    JMP  retorna_ciclo

continua_jogo:
    MOV  R5, 0
    MOV  [CONTINUA_SOM_VIDEO], R5  ; continua o video de fundo do jogo
    MOV  R0, 1   ; coloca novamente R0 a 1 uma vez que depois deste ciclo o jogo volta a correr
    MOV  R5, 0
    MOVB  [R3], R5
    JMP  retorna_ciclo

termina_jogo:
    MOV  R5, 0   ; video número 0
    MOV  [TERMINA_SOM_VIDEO], R5   ; pausa o video número 0
    MOV  R5, 1   ; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R5 ; seleciona o cenário de fundo
    MOV  R0, 0   ; no caso em que o jogo foi terminado coloca-se R0 a 0, porque o jogo não está a correr
    JMP  retorna_ciclo

retorna_ciclo:
    POP  R5
    POP  R4
    RET 

; ******************************************************************************
; asteroide_bom - Processo que desenha o asteroide bom 
; ******************************************************************************

asteroide_bom:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R7

    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET