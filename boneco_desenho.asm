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
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H ; endereço do comando para colocar uma imagem para sobrepor o resto
APAGA_CENARIO_FRONTAL EQU COMANDOS + 44H ; endereço do comando para apagar apagar o cenarios frontal
; ******************************************************************************
; * Paleta
; ******************************************************************************
COR_PIXEL_VERDE  EQU 0C0F0H   ; cor do pixel: verde em ARGB
COR_PIXEL_ROXO  EQU 0F85FH   ; cor do pixel: roxo em ARGB
COR_PIXEL_VERMELHO  EQU 0FF00H   ; cor do pixel: vermelho em ARGB
COR_PIXEL_TRANSPARENTE EQU 0FCCCH   ;cor do pixel; cinzento transparente
COR_PIXEL_CINZENTO EQU 0F777H   ;cor do pixel; cinzento transparente
; ******************************************************************************
; * Definição dos desenhos
; ******************************************************************************
LINHA_ASTEROIDE_BOM EQU 0   ; linha onde vai ser desenhado o primeiro pixel do asteroide bom
COLUNA_ASTEROIDE_BOM EQU 0   ; coluna onde vai ser desenhado o primeiro pixel do asteroide bom
LARGURA_ASTEROIDE_BOM  EQU 5  ; largura do asteroide
ALTURA_ASTEROIDE_BOM  EQU 5  ; altura do asteroide
LINHA_SONDA EQU 26   ; linha onde vai ser desenhado o primeiro pixel da sonda
COLUNA_SONDA EQU 32   ; coluna onde vai ser desenhado o primeiro pixel da sonda
COLUNA_NAVE EQU 25   ; coluna onde vai ser desenhado o primeiro pixel da nave
LINHA_NAVE EQU 27   ; linha onde vai ser desenhado o primeiro pixel da nave
LARGURA_NAVE  EQU 15  ; largura da nave
ALTURA_NAVE  EQU 5  ; altura da nave
LARGURA_ECRA_NAVE  EQU 7  ; largura do ecrã da nave
ALTURA_ECRA_NAVE  EQU 2  ; altura do ecrã da nave
; ##############################################################################
; * ZONA DE DADOS 
; ##############################################################################
PLACE  1000H
STACK  100H   ; espaço reservado para a pilha 200H bytes, 100H words
	SP_init:
	
DEF_ASTEROIDE_BOM:   ; tabela que define o asteroide bom (cor, largura, altura, pixels)
    WORD        LARGURA_ASTEROIDE   
    WORD        ALTURA_ASTEROIDE 
    WORD        0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0

DEF_ASTEROIDE_MAU:   ; tabela que define o asteroide mau (cor, largura, altura, pixels)
    WORD        LARGURA_ASTEROIDE

DEF_NAVE:	         ; tabela que define a nave (cor, largura, altura, pixels)
	WORD		LARGURA_NAVE
    WORD        ALTURA_NAVE
	WORD		0, 0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO,
                COR_PIXEL_VERMELHO,COR_PIXEL_VERMELHO,COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO,COR_PIXEL_VERMELHO,
                COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO,0,0
    WORD        0, COR_PIXEL_VERMELHO, COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE, COR_PIXEL_VERMELHO,0
    WORD        COR_PIXEL_VERMELHO,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,0,0,0,
                0, 0, 0, 0, COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE, COR_PIXEL_VERMELHO
    WORD        COR_PIXEL_VERMELHO,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,0,0,0,
                0, 0, 0, 0, COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE, COR_PIXEL_VERMELHO
    WORD        COR_PIXEL_VERMELHO,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE, COR_PIXEL_TRANSPARENTE,
                COR_PIXEL_TRANSPARENTE,COR_PIXEL_TRANSPARENTE, COR_PIXEL_VERMELHO
    
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
    MOV  SP, SP_init
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
    CALL escolhe_rotina   ;escolhe a rotina a usar tendo em conta a tecla primida
    CALL ha_tecla ; esperamos que nenhuma tecla esteja a ser premida
    CMP  R0, 0   ; o jogo está a correr?
    JZ  ciclo   ; só desenha o asteroide se o jogo estiver a correr
    CALL asteroide_bom   ; desenha o asteroide bom
    CALL nave   ; desenha a nave
    CALL sonda   ; desenha a sonda
    JMP  ciclo

; ******************************************************************************
; teclado - Processo que detecta quando se carrega numa tecla do teclado.
; ******************************************************************************
teclado:
    PUSH R0
    PUSH R2
    PUSH R4

restart_linhas:
    MOV  R1, LINHA   ; coloca 16 = 10000B em R1MOVB

espera_tecla:   ; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1   ; passa para a linha seguinte
    CMP  R1, 0   ; verifica se ja passamos pelas linhas todas
    JZ   restart_linhas ; voltamos ao inicio das linhas 
    MOVB [R2], R1   ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]   ; ler do periférico de entrada (colunas)
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

ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    PUSH R8
    PUSH R7
repeticao_tecla:
    MOV  R7, MASCARA   ; [MASCARA]
    MOVB R8, [R3]      ; ler do periférico de entrada (colunas)
    AND  R8, R7        ; elimina bits para além dos bits 0-3
    CMP  R8, 0         ; há tecla premida?
    JNZ  repeticao_tecla     ; se ainda houver uma tecla premida, espera até não haver
    POP  R7
    POP  R8
    RET
; ******************************************************************************
; escolhe_rotina - Processo que executa a instrução associada à tecla primida
; ******************************************************************************
escolhe_rotina:
    PUSH  R4
    PUSH  R5

    MOV  R4, 0081H       
    CMP  R1, R4   ; verifica se a tecla primida é a c
    JZ   inicia_jogo_verificação   ; se a tecla primida for c, executa inicia_jogo
    CMP  R0, 0   ; o jogo ainda não está a correr?
    JNZ  fases_jogo   ; se o jogo já começou
    JMP  retorna_ciclo; se a tecla primida não está associada a nenhuma função volta a restart_linhas

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
    JZ   suspende_jogo   ; se a tecla primida for d, executa suspende_jogo
    MOV  R4, 0084H      
    CMP  R1, R4   ; verifica se a tecla primida é a e
    JZ   termina_jogo   ; se a tecla primida for e, executa termina_jogo
    JMP  retorna_ciclo
suspende_jogo:
    CMP  R0, 2   ; o jogo já começou e está parado?
    JZ   continua_jogo   ;   prosseguir com o jogo
    MOV  R5, 0
    MOV  [SUSPENDE_SOM_VIDEO], R5  ; pausa o video de fundo do jogo
    MOV  R5, 2
    MOV  [SELECIONA_CENARIO_FRONTAL], R5 ; coloca cenario frontal de pausa do jogo
    MOV  R0, 2   ; coloca o valor 2 no R0, simbolizando o facto de o jogo já ter começado, mas estar parado
    JMP  retorna_ciclo

continua_jogo:
    MOV  R5, 2
    MOV  [APAGA_CENARIO_FRONTAL], R5
    MOV  R5, 0
    MOV  [CONTINUA_SOM_VIDEO], R5  ; continua o video de fundo do jogo
    MOV  R0, 1   ; coloca novamente R0 a 1 uma vez que depois deste ciclo o jogo volta a correr
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

posicão_asteroide_bom:
    MOV R0, LINHA_ASTEROIDE_BOM
    MOV R1, COLUNA_ASTEROIDE_BOM
    ADD R6, R0   
    ADD R6, ALTURA_ASTEROIDE   ; soma da altura do asteroide com a linha do asteroide
    SUB R6, 1   ; subtrai 1 à soma da altura do asteroide com a linha do asteroide

desenha_asteroide_bom:
    MOV R2, DEF_ASTEROIDE_BOM   ; endereço da tabela que define o asteroide bom
    MOV R3, [R2]   ; obtem a largura do asteroide bom
    ADD R2, 2   ; obtem  o endereço da altura do asteroide bom
    MOV R4, [R2]   ; obtem a altura da asteroide bom
    ADD R2, 2   ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels_asteroide_bom:
    MOV R5, [R2]   ;
    MOV [DEFINE_LINHA], R0   ;
    MOV [DEFINE_COLUNA], R1   ;
    MOV [DEFINE_PIXEL], R5   ;
    ADD R2, 2   ;
    ADD R1, 1   ;
    SUB R3, 1   ;
    JNZ desenha_pixels_asteroide_bom

CMP R0, R6
JZ retorna_ciclo_asteroide_bom
ADD R0, 1
MOV R1, COLUNA_ASTEROIDE_BOM
MOV R3, LARGURA_ASTEROIDE
JMP desenha_pixels_asteroide_bom

retorna_ciclo_asteroide_bom:
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; ******************************************************************************
; nave - Processo que desenha a nave
; ******************************************************************************
nave:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6

posicão_nave:
    MOV R0, LINHA_NAVE
    MOV R1, COLUNA_NAVE
    ADD R6, R0
    ADD R6, ALTURA_NAVE
    SUB R6, 1

desenha_nave:
    MOV R2, DEF_NAVE   ; endereço da tabela que define o asteroide bom
    MOV R3, [R2]   ; obtem a largura do asteroide bom
    ADD R2, 2   ; obtem  o endereço da altura do asteroide bom
    MOV R4, [R2]   ; obtem a altura da asteroide bom
    ADD R2, 2   ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels_nave:
    MOV R5, [R2]
    MOV [DEFINE_LINHA], R0
    MOV [DEFINE_COLUNA], R1
    MOV [DEFINE_PIXEL], R5
    ADD R2, 2
    ADD R1, 1
    SUB R3, 1
    JNZ desenha_pixels_nave

CMP R0, R6
JZ retorna_ciclo_nave
ADD R0, 1
MOV R1, COLUNA_NAVE
MOV R3, LARGURA_NAVE
JMP desenha_pixels_nave

retorna_ciclo_nave:
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET

; ******************************************************************************
; sonda - Processo que desenha a sonda
; ******************************************************************************
sonda:
    PUSH  R0
    PUSH  R1
    PUSH  R2

posicão_sonda:
    MOV R0, LINHA_SONDA
    MOV R1, COLUNA_SONDA
    MOV R2, COR_PIXEL_ROXO

desenha_pixel_sonda:
    MOV [DEFINE_LINHA], R0
    MOV [DEFINE_COLUNA], R1
    MOV [DEFINE_PIXEL], R2

retorna_ciclo_sonda:
    POP  R2
    POP  R1
    POP  R0
    RET
