; ******************************************************************************************************************************************************
; * Projeto IAC 2022/23 - Versão Intermédia
; * Alunos: Filippo Bortoli(106103), João Gomes(106204), Sofia Piteira(106194)
; ******************************************************************************************************************************************************

; ******************************************************************************************************************************************************
; * DESCRIÇÃO
; * TECLA 4 -  move o asteroide bom uma linha e coluna para baixo
; * TECLA 5 -  move a sonda uma linha para cima
; * TECLA 8 -  aumenta em uma unidade o valor nos displays
; * TECLA 9 -  diminui em uma unidade o valor nos displays
; * TECLA C -  inicia/reinicia o jogo
; * TECLA D -  pausa/ continua o jogo 
; * TECLA E -  termina o jogo 
; * [DISPLAY] = 0H - acabou-se a energia, muda-se o cenário de fundo e acaba-se o jogo
; * Quando o jogo se reinicia os displays voltam a apresentar 100 e os desenhos às suas posições iniciais
; * Enquanto o jogo está em pausa nada funciona, nem o display
; ******************************************************************************************************************************************************

; ******************************************************************************************************************************************************
; * Constantes
; ******************************************************************************************************************************************************
DISPLAYS  EQU 0A000H                            ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN  EQU 0C000H                             ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL  EQU 0E000H                             ; endereço das colunas do teclado (periférico PIN)
LINHA  EQU 16                                   ; linha a testar (4ª linha, 1000b)
MASCARA  EQU 0FH                                ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
COMANDOS  EQU 6000H                             ; endereço de base dos comandos do MediaCenter
DEFINE_LINHA  EQU COMANDOS + 0AH                ; endereço do comando para definir a linha
DEFINE_COLUNA  EQU COMANDOS + 0CH               ; endereço do comando para definir a coluna
DEFINE_PIXEL  EQU COMANDOS + 12H                ; endereço do comando para escrever um pixel
APAGA_AVISO  EQU COMANDOS + 40H                 ; endereço do comando para apagar o aviso de nenhum cenário selecionado
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H     ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_SOM_VIDEO  EQU COMANDOS + 48H         ; endereço do comando para selecionar uma video ou som
REPRODUZ_SOM_VIDEO  EQU COMANDOS + 5AH          ; endereço do comando para iniciar a reprodução dum video ou som
SUSPENDE_SOM_VIDEO  EQU COMANDOS + 5EH          ; endereço do comando para pausar video ou som
CONTINUA_SOM_VIDEO  EQU COMANDOS + 60H          ; endereço do comando para continuar video ou som
TERMINA_SOM_VIDEO  EQU COMANDOS + 66H           ; endereço do comando para terminar a reprodução do som ou video
SELECIONA_CENARIO_FRONTAL  EQU COMANDOS + 46H   ; endereço do comando para colocar uma imagem para sobrepor o resto
APAGA_CENARIO_FRONTAL  EQU COMANDOS + 44H       ; endereço do comando para apagar apagar o cenarios frontal
APAGA_ECRÃ  EQU COMANDOS + 02H                  ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_ECRÃ  EQU COMANDOS + 04H              ; seleciona um ecrã especifico
MOSTRA_ECRÃ  EQU COMANDOS + 06H                 ; mostra o ecrã especificado
ESCONDE_ECRÃ  EQU COMANDOS + 08H                ; esconde o ecrã especificado
MUTE  EQU COMANDOS + 4CH                        ; corta o volume de todos os sons ou videos a reproduzir
DESMUTE EQU  COMANDOS + 52Ħ                     ; retoma o volume de todos os sons ou videos a reproduzir 
REPRODUZ_SOM_VIDEO_CICLO EQU COMANDOS + 5CH     ; reproduz um som/ video em ciclo

; ******************************************************************************************************************************************************
; * Paleta
; ******************************************************************************************************************************************************
COR_PIXEL_VERDE  EQU 0F0F0H                     ; cor do pixel: verde em ARGB
COR_PIXEL_ROXO  EQU 0F85FH                      ; cor do pixel: roxo em ARGB
COR_PIXEL_VERMELHO  EQU 0FF00H                  ; cor do pixel: vermelho em ARGB
COR_PIXEL_TRANSPARENTE EQU 0FCCCH               ;cor do pixel; cinzento transparente
COR_PIXEL_CINZENTO EQU 0F777H                   ;cor do pixel; cinzento transparente
COR_PIXEL_AMARELO   EQU 0FFF0H                  ;cor do pixel: amarelo em ARGB
COR_PIXEL_AZUL_CLARO  EQU 0F0FFH                ;cor do pixel: azul em ARGB

; ******************************************************************************************************************************************************
; * Definição dos desenhos
; ******************************************************************************************************************************************************
LINHA_ASTEROIDE_BOM EQU 0                       ; linha onde vai ser desenhado o primeiro pixel do asteroide bom
COLUNA_ASTEROIDE_BOM EQU 0                      ; coluna onde vai ser desenhado o primeiro pixel do asteroide bom
LARGURA_ASTEROIDE  EQU 5                        ; largura do asteroide
ALTURA_ASTEROIDE  EQU 5                         ; altura do asteroide
LARGURA_SONDA EQU 1                             ; largura da sonda
ALTURA_SONDA EQU 1                              ; altura da sonda
LINHA_SONDA EQU 26                              ; linha onde vai ser desenhado o primeiro pixel da sonda
COLUNA_SONDA EQU 32                             ; coluna onde vai ser desenhado o primeiro pixel da sonda
COLUNA_NAVE EQU 25                              ; coluna onde vai ser desenhado o primeiro pixel da nave
LINHA_NAVE EQU 27                               ; linha onde vai ser desenhado o primeiro pixel da nave
LARGURA_NAVE  EQU 15                            ; largura da nave
ALTURA_NAVE  EQU 5                              ; altura da nave
COLUNA_ECRA_NAVE EQU 29                         ; coluna onde vai ser desenhado o primeiro pixel do ecra da nave
LINHA_ECRA_NAVE EQU 29                          ; linha onde vai ser desenhado o primeiro pixel do ecra da nave
LARGURA_ECRA_NAVE  EQU 7                        ; largura do ecrã da nave
ALTURA_ECRA_NAVE  EQU 2                         ; altura do ecrã da nave
JOGO_NAO_INICIADO EQU 0
JOGO_A_CORRER EQU 1
JOGO_PAUSADO EQU 2



; ######################################################################################################################################################
; * ZONA DE DADOS 
; ######################################################################################################################################################
PLACE  1000H
STACK 100H			                            ; espaço reservado para a pilha do processo "programa principal"
    SPinit_principal:		                    ; este é o endereço com que o SP deste processo deve ser inicializado
STACK  100H                                     ; espaço reservado para a pilha 200H bytes, 100H words
	SPinit_teclado:	
STACK  100H
    SPinit_desenhos:
STACK 100H
    SPinit_display:
STACK 100H
    SPinit_painelnave:

    				
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_display			                    ; rotina de atendimento da interrupção 

evento_init_display:
    LOCK 0
evento_tecla_carregada:
    LOCK 0
evento_init_jogo:
    LOCK 0

tecla_premida WORD 0

jogo_estado WORD JOGO_NAO_INICIADO
DEF_ASTEROIDE_BOM:                              ; tabela que define o asteroide bom (cor, largura, altura, pixels)
    WORD        LARGURA_ASTEROIDE   
    WORD        ALTURA_ASTEROIDE 
    WORD        0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE
    WORD        0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0

DEF_ASTEROIDE_MAU:                              ; tabela que define o asteroide mau (cor, largura, altura, pixels)
    WORD        LARGURA_ASTEROIDE
    WORD        ALTURA_ASTEROIDE
    WORD        COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO
    WORD        0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0
    WORD        COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
    WORD        0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0
    WORD        COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO

DEF_NAVE:	                                    ; tabela que define a nave (cor, largura, altura, pixels)
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

DEF_SONDA:                                      ; tabela que define o asteroide bom (cor, largura, altura, pixels)
    WORD        LARGURA_SONDA
    WORD        ALTURA_SONDA
    WORD        COR_PIXEL_ROXO

DEF_ECRA_NAVE_1:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE
    
DEF_ECRA_NAVE_2:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO,COR_PIXEL_AZUL_CLARO, COR_PIXEL_VERMELHO

DEF_ECRA_NAVE_3:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO,COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO
    
DEF_ECRA_NAVE_4:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_VERDE, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO,COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO

DEF_ECRA_NAVE_5:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO,COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO

DEF_ECRA_NAVE_6:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO,COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

DEF_ECRA_NAVE_7:
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO,COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

; ******************************************************************************************************************************************************
; * Código
; ******************************************************************************************************************************************************
PLACE   0                                       ; o código tem de começar em 0000H
inicio:
    MOV    SP, SPinit_principal
    MOV    BTE, tab 
    MOV    [APAGA_AVISO], R1                    ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV    [APAGA_ECRÃ], R1                     ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	   R1, 0                                ; cenário de fundo número 0
    MOV    [SELECIONA_CENARIO_FUNDO], R1        ; seleciona o cenário de fundo
    MOV    R9, 2                                ; som número 2
    MOV    [SELECIONA_SOM_VIDEO], R9            ; seleciona um som para a intro do jogo
    MOV    [REPRODUZ_SOM_VIDEO], R9             ; inicia a reprodução do som da intro
    EI0
    EI

; ******************************************************************************************************************************************************
; inicializações
; ******************************************************************************************************************************************************

    MOV    R0, 0                                ; inicializa R0 a 0 para simbolizar que o jogo ainda não está a correr
    MOV    R4, DISPLAYS                         ; endereço do periférico dos displays
    MOV    R5, 0100H                            ; inicializa o valor de R5 a 100H para colocar no display
    MOV    [R4], R5                             ; inicializa o display a 100
    MOV    R5, 0064H                            ; 64 em hexadecimal é 100 é decimal
    MOV    R6, 0                                ; inicializa o contador da tecla 4 para mover o asteroide 
    MOV    R7, 0                                ; inicializa o contador da tecla 5 para mover a sonda
    CALL   teclado                              ; verifica se alguma tecla foi carregada
    CALL   ha_tecla                             ; esperamos que nenhuma tecla esteja a ser premida

; ******************************************************************************************************************************************************
; corpo principal do programa
; ******************************************************************************************************************************************************


verifica_init_jogo:
    MOV    R0, [evento_tecla_carregada]         ; bloqueia aqui o processo caso nao haja tecla carregada
    MOV    R4, 0081H       
    MOV    R1, [tecla_premida]                  ; movemos a tecla premida no teclado para o R1
    CMP    R1, R4                               ; verifica se a tecla premida é a c
    JZ     testa_C                              ; se a tecla premida for c, executa inicia_jogo
    CMP    R1, 0082H                            ; o jogo ainda não está a correr?
    JZ     testa_D                              ; se o jogo já começou
ciclo: 

    CMP    R0, 1                                ; o jogo está a correr?
    JZ     desenhar_lock                             ; se o jogo está a correr desenhamos a nave, os asteroides e a sonda   
    CMP    R0, 4                                ; a tecla 4 foi premida?
    JZ     move_asteroide_lock                       ; move-se o asteroide uma linha e coluna para baixo
    CMP    R0, 5                                ; a tecla 5 foi premida?
    JZ     move_sonda_lock                           ; move-se a sonda uma linha para cima 
    MOV    R9, 8                                ; mete-se 8 num registo, porque cmp só dá para usar diretamente com números até 7
    CMP    R0, R9                               ; a tecla 8 foi premida?
    JZ     energia_mais_lock                         ; aumenta-se o número no display uma unidade
    MOV    R9, 9                                ; mete-se 9 num registo, porque cmp só dá para usar diretamente com números até 7
    CMP    R0, R9                               ; a tecla 9 foi premida?
    JZ     energia_menos_lock                        ; diminui-se o número no display uma unidade
    JMP    ciclo                                  

testa_C:
    MOV    R0, [jogo_estado]          
    CMP    R0, JOGO_NAO_INICIADO                ; o jogo está a correr?
    JZ     init_jogo_lock
    JMP    fim_proc_principal
init_jogo_lock:
    MOV    [evento_init_jogo], R0               ; colocamos o lock a "verde" para a seguir iniciar jogo
 testa_D:
    MOV    R4, 0082H     
    CMP    R1, R4                               ; verifica se a tecla premida é a d
    JZ     suspende_jogo                        ; se a tecla premida for d, executa suspende_jogo

testa_E:
    MOV    R4, 0084H    
    CMP    R1, R4                               ; verifica se a tecla premida é a e
    JZ     termina_jogo                         ; se a tecla premida for e, executa termina_jogo

fim_proc_principal:
    














; ******************************************************************************************************************************************************
; teclado - Processo que deteta quando se carrega numa tecla do teclado.
; ******************************************************************************************************************************************************
PROCESS SPinit_teclado

teclado:
    MOV    R2, TEC_LIN                          ; endereço do periférico das linhas
    MOV    R3, TEC_COL                          ; endereço do periférico das colunas
restart_linhas:
    MOV    R1, LINHA                            ; coloca 16 = 10000 em binário no registo 1

espera_tecla:                                   ; neste ciclo espera-se até uma tecla ser premida
    WAIT
    SHR    R1, 1                                ; passa para a linha seguinte
    CMP    R1, 0                                ; verifica se ja passamos pelas linhas todas
    JZ     restart_linhas                       ; voltamos ao inicio das linhas 
    MOVB   [R2], R1                             ; escrever no periférico de saída (linhas)
    MOVB   R0, [R3]                             ; ler do periférico de entrada (colunas)
    MOV    R4, MASCARA                          ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    AND    R0, R4                               ; elimina bits para além dos bits 0-3
    CMP    R0, 0                                ; há tecla premida?
    JZ     espera_tecla                         ; se nenhuma tecla for premida, repete
    SHL    R1, 4                                ; coloca linha no nibble high
    OR     R1, R0                               ; junta coluna (nibble low)
    MOV    [tecla_premida], R1                  ; guardamos a tecla premida na memória
    MOV    [evento_tecla_carregada], R0            ; coloca o nosso 

repeticao_tecla:
    YIELD
    MOV    R8, 0
    MOV    R7, MASCARA                            
    MOVB   R8, [R3]                             ; ler do periférico de entrada (colunas)
    AND    R8, R7                               ; elimina bits para além dos bits 0-3
    CMP    R8, 0                                ; há tecla premida?
    JNZ    repeticao_tecla                      ; se ainda houver uma tecla premida, espera até não haver
    JMP	   espera_tecla                         ; PERIGO SE PROGRAMA NAO FUNCIONAR TIRAR ESTA LINHA

; ******************************************************************************************************************************************************
; Restos dos processos.
; ******************************************************************************************************************************************************


























; ******************************************************************************************************************************************************
; ha_tecla - Processo que espera que se pare de clicar na tecla
; ******************************************************************************************************************************************************

