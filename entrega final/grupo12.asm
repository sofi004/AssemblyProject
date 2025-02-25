; ******************************************************************************************************************************************************
; * Projeto IAC 2022/23 - Versão Final
; * Alunos: Filippo Bortoli(106103), João Gomes(106204), Sofia Piteira(106194)
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
DESMUTE EQU  COMANDOS + 52H                     ; retoma o volume de todos os sons ou videos a reproduzir 
REPRODUZ_SOM_VIDEO_CICLO EQU COMANDOS + 5CH     ; reproduz um som/ video em ciclo
JOGO_NAO_INICIADO EQU 0                         ; número que representa o estado em que o jogo ainda não está iniciado
JOGO_A_CORRER EQU 1                             ; número que representa o estado em que o jogo já está a correr
JOGO_PAUSADO EQU 2                              ; número que representa o estado em que o jogo está em pausa
TECLA_C EQU 0081H                               ; número devolvido pelo teclado quando a tecla c é premida
TECLA_D EQU 0082H                               ; número devolvido pelo teclado quando a tecla d é premida
TECLA_E EQU 0084H                               ; número devolvido pelo teclado quando a tecla e é premida
TECLA_0 EQU 0011H                               ; número devolvido pelo teclado quando a tecla 0 é premida
TECLA_1 EQU 0012H                               ; número devolvido pelo teclado quando a tecla 1 é premida
TECLA_2 EQU 0014H                               ; número devolvido pelo teclado quando a tecla 2 é premida
TAMANHO_PILHA EQU  100H                         ; tamanho de cada pilha, em words
N_ASTEROIDES EQU  5		                        ; número de bonecos
N_MAX_SONDAS EQU 3                              ; num max sondas
LINHA_INICIAL_SONDA EQU 31                      ; linha inicial da sonda
COLUNA_INICIAL_SONDA EQU 32                     ; coluna inicial da sonda

; ******************************************************************************************************************************************************
; * Paleta
; ******************************************************************************************************************************************************
COR_PIXEL_VERDE  EQU 0F0F0H                     ; cor do pixel: verde em ARGB
COR_PIXEL_ROXO  EQU 0F85FH                      ; cor do pixel: roxo em ARGB
COR_PIXEL_VERMELHO  EQU 0FF00H                  ; cor do pixel: vermelho em ARGB
COR_PIXEL_TRANSPARENTE EQU 0FCCCH               ; cor do pixel; cinzento transparente
COR_PIXEL_CINZENTO EQU 0F777H                   ; cor do pixel; cinzento transparente
COR_PIXEL_AMARELO   EQU 0FFF0H                  ; cor do pixel: amarelo em ARGB
COR_PIXEL_AZUL_CLARO  EQU 0F0FFH                ; cor do pixel: azul em ARGB
COR_PIXEL_LARANJA  EQU   0FF88H

; ******************************************************************************************************************************************************
; * Definição dos desenhos
; ******************************************************************************************************************************************************
LINHA_ASTEROIDE EQU 0                           ; linha onde vai ser desenhado o primeiro pixel do asteroide 0
COLUNA_ASTEROIDE0 EQU 0                         ; coluna onde vai ser desenhado o primeiro pixel do asteroide 0
COLUNA_ASTEROIDE1 EQU 25                        ; coluna onde vai ser desenhado o primeiro pixel do asteroide 1
COLUNA_ASTEROIDE2 EQU 30                        ; coluna onde vai ser desenhado o primeiro pixel do asteroide 2
COLUNA_ASTEROIDE3 EQU 35                        ; coluna onde vai ser desenhado o primeiro pixel do asteroide 3
COLUNA_ASTEROIDE4 EQU 60                        ; coluna onde vai ser desenhado o primeiro pixel do asteroide 4
LARGURA_ASTEROIDE  EQU 5                        ; largura do asteroide
ALTURA_ASTEROIDE  EQU 5                         ; altura do asteroide
LARGURA_SONDA EQU 1                             ; largura da sonda
ALTURA_SONDA EQU 1                              ; altura da sonda
COLUNA_NAVE EQU 25                              ; coluna onde vai ser desenhado o primeiro pixel da nave
LINHA_NAVE EQU 27                               ; linha onde vai ser desenhado o primeiro pixel da nave
LARGURA_NAVE  EQU 15                            ; largura da nave
ALTURA_NAVE  EQU 5                              ; altura da nave
COLUNA_ECRA_NAVE EQU 29                         ; coluna onde vai ser desenhado o primeiro pixel do ecra da nave
LINHA_ECRA_NAVE EQU 29                          ; linha onde vai ser desenhado o primeiro pixel do ecra da nave
LARGURA_ECRA_NAVE  EQU 7                        ; largura do ecrã da nave
ALTURA_ECRA_NAVE  EQU 2                         ; altura do ecrã da nave
LARGURA_EFEITO_ASTEROIDE EQU 6                  ; largura do boneco desenhado na animação, quando um asteroide explode 
ALTURA_EFEITO_ASTEROIDE EQU 6                   ; altura do boneco desenhado na animação, quando um asteroide explode 

; ######################################################################################################################################################
; * ZONA DE DADOS 
; ######################################################################################################################################################
PLACE       1000H

STACK TAMANHO_PILHA			                    ; espaço reservado para a pilha do processo "programa principal"
    SPinit_principal:		                    ; este é o endereço com que o SP deste processo deve ser inicializado

STACK  TAMANHO_PILHA                            ; espaço reservado para a pilha do processo teclado
	SPinit_teclado:	

STACK  TAMANHO_PILHA * N_ASTEROIDES             ; espaço reservado para a pilha do processo boneco
    SPinit_boneco:

STACK TAMANHO_PILHA                             ; espaço reservado para a pilha do processo painel_nave
    SPinit_painelnave:

STACK TAMANHO_PILHA                             ; espaço reservado para a pilha do processo energia_tempo
    SPinit_display:

STACK TAMANHO_PILHA * N_MAX_SONDAS              ; espaço reservado para a pilha do processo incremento_sonda
    SPinit_sonda:      

STACK TAMANHO_PILHA * N_MAX_SONDAS              ; espaço reservado para a pilha do processo explosao
    SPinit_explosao:    

evento_init_boneco:                             ; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
    LOCK 0 

evento_tecla_carregada:                         ; LOCK para o teclado comunicar aos restantes processos que tecla detetou
    LOCK 0

evento_init_nave:                               ; LOCK para a rotina de interrupção comunicar ao processo painel_nave que a interrupção ocorreu
    LOCK 0

evento_init_display:                            ; LOCK para a rotina de interrupção comunicar ao processo energia_tempo que a interrupção ocorreu
    LOCK 0

evento_init_sonda:                              ; LOCK para a rotina de interrupção comunicar ao processo move_sonda que a interrupção ocorreu
    LOCK 0

tab:                                            ; Tabela das rotinas de interrupção
	WORD rot_int_boneco			                ; rotina de atendimento da interrupção 0
    WORD rot_int_sonda                          ; rotina de atendimento da interrupção 1
    WORD rot_int_display                        ; rotina de atendimento da interrupção 2
    WORD rot_int_painel_nave                    ; rotina de atendimento da interrupção 3

valor_aleatorio: WORD 1                         ; valor aleatório que decide se o asteroide a criar é bom ou mau

jogo_estado: WORD JOGO_NAO_INICIADO             ; o estado 0 simboliza que o jogo ainda não começou
                                                ; o estado 1 simboliza que o jogo está a correr
                                                ; o estado 2 simboliza que o jogo está em pausa

incremento_horizontal_sonda: WORD 0             ; variável que guarda o incremento horizontal da sonda

valor_display: WORD 0064H                       ; valor em hexadecimal que está no display

posicao_sondas:
    WORD LINHA_INICIAL_SONDA, COLUNA_INICIAL_SONDA  ; sabe onde se encontra a sonda 0 no momento
    WORD LINHA_INICIAL_SONDA, COLUNA_INICIAL_SONDA  ; sabe onde se encontar a sonda 1 no momento
    WORD LINHA_INICIAL_SONDA, COLUNA_INICIAL_SONDA  ; sabe onde se encontra a sonda 2 no momento

existe_sonda:                                   ; sabe se as sondas aparecem no ecrã ou não
    WORD 0,0,0                                  ; se estive a 0 é porque a sonda ainda não aparece no ecrã

posicao_asteroides:
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE0     ; sabe onde se encontra o asteroide 0 no momento
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE1     ; sabe onde se encontra o asteroide 1 no momento
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE2     ; sabe onde se encontra o asteroide 2 no momento
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE3     ; sabe onde se encontra o asteroide 3 no momento
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE4     ; sabe onde se encontra o asteroide 4 no momento

escolha_asteroide_posicao:                      ; tabela que guarda os valores iniciais das colunas de cada um dos asteroides
    WORD COLUNA_ASTEROIDE0                      ; coluna inicial do asteroide 0
    WORD COLUNA_ASTEROIDE1                      ; coluna inicial do asteroide 1
    WORD COLUNA_ASTEROIDE2                      ; coluna inicial do asteroide 2
    WORD COLUNA_ASTEROIDE3                      ; coluna inicial do asteroide 3
    WORD COLUNA_ASTEROIDE4                      ; coluna inicial do asteroide 4

tipo_asteroide:                                 ; 0 se o asteroide é mineravel e 1 se nao é
    WORD 0,0,0,0,0

asteroide_que_explodiu:                         ; 0 se o asteroide explodiu e 1 senão explodiu  
    WORD 0,0,0,0,0

; à linha temos sempre que incrementar 1
sentido_movimento_coluna_asteroide:             ; esta tabela serve para sabermos quanto temos de incrementar ao valor da coluna inicial de cada asteroide
    WORD 1
    WORD -1
    WORD 0
    WORD 1
    WORD -1

DEF_EFEITO_ASTEROIDE:                       ; tabela que define a animação, da explosão, do asteroide (cor, largura, altura, pixels)
    WORD LARGURA_EFEITO_ASTEROIDE  
    WORD ALTURA_EFEITO_ASTEROIDE
    WORD COR_PIXEL_AMARELO, 0, 0, 0, 0, COR_PIXEL_AMARELO
    WORD 0, COR_PIXEL_AMARELO, 0, COR_PIXEL_LARANJA, COR_PIXEL_AMARELO, 0
    WORD 0, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA, 0, 0
    WORD 0, 0, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA, 0
    WORD 0, COR_PIXEL_AMARELO, COR_PIXEL_LARANJA, 0, COR_PIXEL_AMARELO, 0
    WORD COR_PIXEL_AMARELO, 0, 0, 0, 0, COR_PIXEL_AMARELO

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

DEF_ECRA_NAVE_1:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE,COR_PIXEL_VERMELHO,COR_PIXEL_VERDE,COR_PIXEL_AZUL_CLARO
    
DEF_ECRA_NAVE_2:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO,COR_PIXEL_AZUL_CLARO, COR_PIXEL_VERMELHO

DEF_ECRA_NAVE_3:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO,COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO
    
DEF_ECRA_NAVE_4:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_VERDE, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO,COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO

DEF_ECRA_NAVE_5:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO,COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO

DEF_ECRA_NAVE_6:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_AMARELO,COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

DEF_ECRA_NAVE_7:                                ; tabela que define um dos padrões no painel da nave (cor, largura, altura, pixels)
    WORD        LARGURA_ECRA_NAVE
    WORD        ALTURA_ECRA_NAVE
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_AMARELO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
    WORD        COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO, COR_PIXEL_VERDE, COR_PIXEL_CINZENTO,COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

; ******************************************************************************************************************************************************
; * Código
; ******************************************************************************************************************************************************
PLACE       0                                   ; o código tem de começar em 0000H

inicio:
    MOV     SP, SPinit_principal                ; inicializa SP do programa principal
    MOV     BTE, tab                            ; inicializa BTE (registo de Base da Tabela de Exceções)
    MOV     [APAGA_AVISO], R1                   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV     [APAGA_ECRÃ], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV     R6, 2                                 
    MOV     [APAGA_CENARIO_FRONTAL], R6         ; quando o jogo está parado e o terminamos, apagamos o cenário frontal(2)
	MOV	    R1, 0                               ; cenário de fundo número 0
    MOV     [SELECIONA_CENARIO_FUNDO], R1       ; seleciona o cenário de fundo
    MOV     [jogo_estado], R1
    MOV     R9, 2                               ; som número 2
    MOV     [SELECIONA_SOM_VIDEO], R9           ; seleciona um som para a intro do jogo
    MOV     [REPRODUZ_SOM_VIDEO], R9            ; inicia a reprodução do som da intro
    MOV     R6, 0100H                           ; o jogo começa com 100 no display
    MOV     R0, DISPLAYS
    MOV     [R0], R6
    MOV     R0, 0064H                           ; porque 100 decimal correponde a 64 hexadecimal
    MOV     [valor_display], R0                 ; coloca na memória o valor que está no display, mas em hexadecimal
    EI0                                         ; permite interrupções 0
    EI1                                         ; permite interrupções 1
    EI2                                         ; permite interrupções 2
    EI3                                         ; permite interrupções 3
    EI                                          ; permite interrupções (geral)
    CALL    painel_nave                         ; cria o processo painel_nave
    CALL    teclado                             ; cria o processo teclado
    CALL    energia_tempo                       ; cria o processo energia_tempo
    MOV     R11, N_ASTEROIDES  

loop_asteroide:
    SUB     R11, 1                              ; subtrai-mos logo por causa da pilha
    CALL    boneco                              ; cria o processo teclado
    CMP     R11, 0                              ; verifica se já foi chamado o proceso 5 vezes
    JNZ     loop_asteroide                             
MOV     R10, -1
MOV     R11, N_MAX_SONDAS
loop_sondas:
    CALL    incremento_sonda                    ; chama o processo que move a sonda 
    ADD     R10, 1
    SUB     R11,1                               ; decrementa o R11 porque queremos que o processo ocorra 3 vezes que existam no máximo 3 sondas
    CMP     R11, 0
    JNZ     loop_sondas

;*******************************************************************************************************************************************************
; Associação de ações às tecla premidas
;*******************************************************************************************************************************************************
verifica_teclaC:
    MOV     R2, [evento_tecla_carregada]        ; bloqueia aqui o processo caso nao haja tecla carregada   
    MOV     R4, TECLA_C                          
    CMP     R2, R4                              ; verifica se a tecla c foi a premida
    JNZ     verifica_teclaD                     ; se a tecla c não for a premida vai verificar se a tecla premida é a d
    MOV     R4, [jogo_estado] 
    MOV     R1, JOGO_NAO_INICIADO
    CMP     R4, R1                              ; verifica se o jogo ainda não começou
    JNZ     verifica_teclaD                     ; se o jogo já tiver iniciado ou se estiver em pausa não é possivel carregar na tecla c
    MOV     R6, 0100H                           ; ao iniciar o jogo colocamos 100 no display
    MOV     R0, DISPLAYS
    MOV     [R0], R6
    MOV     R0, 0064H                           ; porque 100 decimal correponde a 64 hexadecimal
    MOV     [valor_display], R0                 ; coloca na memória o valor que está no display, mas em hexadecimal
    MOV     R3, JOGO_A_CORRER                   
    MOV     [jogo_estado], R3                   ; coloca o estado do jogo como iniciado
    MOV     R11, 1                              ; para indicar que é para desenhar
    MOV     R8, LINHA_NAVE                      ; passamos como argumento para o desenha_apaga_boneco a linha onde a nave vai ser desenhada
    MOV     R10, COLUNA_NAVE                    ; passamos como argumento para o desenha_apaga_boneco a coluna onde a nave vai ser desenhada
    MOV     R9, DEF_NAVE                        ; passamos como argumento para o desenha_apaga_boneco a tabela da nave
    MOV     R6, 0
    MOV     [SELECIONA_ECRÃ], R6
    CALL    desenha_apaga_boneco                ; desenha a nave
    CALL    inicia_jogo                         ; chama a rotina inicia_jogo que troca o cenário e o som de fundo  
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida

verifica_teclaD:
    MOV     R4, TECLA_D
    CMP     R2, R4                              ; verifica se a tecla d é a premida
    JNZ     verifica_teclaE                     ; se a tecla d não for a premida vai verificar se a tecla premida é a e
    MOV     R4, [jogo_estado]
    MOV     R1, JOGO_NAO_INICIADO
    CMP     R4, R1                              ; verifica se o jogo ainda não foi iniciado
    JZ      verifica_teclaE                     ; se o jogo ainda não tiver começado a tecla d não funciona
    MOV     R1, JOGO_PAUSADO                    
    CMP     R4, R1                              ; verifica se o jogo está em pausa
    JZ      continua_jogo                       ; se está então continuamos o jogo
    MOV     R1, JOGO_A_CORRER
    CMP     R4, R1                              ; verifica se o jogo está em pausa
    JZ      suspende_jogo                       ; se não está pausamos o jogo
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida

verifica_teclaE:
    MOV     R4, TECLA_E
    CMP     R2, R4                              ; verifica se a tecla e é a premida
    JNZ     verifica_tecla0                     ; se a tecla e não for a premida vai verificar se a tecla premida é a 0
    MOV     R4, [jogo_estado]
    MOV     R1, JOGO_NAO_INICIADO
    CMP     R4, R1                              ; verifica se o jogo ainda não foi iniciado
    JNZ     termina_jogo                        ; se o jogo estiver noutro estado que não iniciado então terminamos o jogo
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida

verifica_tecla0:
    MOV     R4, [jogo_estado]
    MOV     R1, JOGO_A_CORRER
    CMP     R1, R4                              ; verifica se o jogo está a correr
    JNZ     verifica_teclaC                     ; se o jogo não estiver a correr a tecla 0, 1 e 2 não funciona
    MOV     R4, TECLA_0
    CMP     R2, R4                              ; verifica se a tecla 0 é a premida
    JNZ     verifica_tecla1						; se a tecla 0 não for a premida vai verificar se a tecla premida é a 1						
    MOV     R3, -1
    MOV     [incremento_horizontal_sonda], R3
    MOV     R5, [existe_sonda]
    CMP     R5,1
    JZ      verifica_tecla1
    CALL    sonda_displays_sound                ; chama a rotina que diminui 3 no display e que reproduz um som
    MOV     R5,1
    MOV     [existe_sonda],R5                   ; mete na memória que a sonda 0 existe
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida

verifica_tecla1:
    MOV     R4, TECLA_1
    CMP     R2, R4                              ; verifica se a tecla 1 é a premida
    JNZ     verifica_tecla2                     ; se a tecla 0 não for a premida vai verificar se a tecla premida é a 1
    MOV     R3, 0
    MOV     [incremento_horizontal_sonda], R3
    MOV     R5, [existe_sonda+2]
    CMP     R5,1
    JZ      verifica_tecla2
    CALL    sonda_displays_sound                ; chama a rotina que diminui 3 no display e que reproduz um som
    MOV     R5,1 
    MOV     [existe_sonda+2],R5                 ; mete na memória que a sonda 1 existe
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida

verifica_tecla2:
    MOV     R4, TECLA_2
    CMP     R2, R4                              ; verifica se a tecla 2 é a premida
    JNZ     verifica_teclaC                     ; se a tecla 1 não for a premida vai verificar se a tecla premida é a c
    MOV     R3, 1
    MOV     [incremento_horizontal_sonda], R3
    MOV     R5, [existe_sonda+4]
    CMP     R5,1
    JZ      verifica_teclaC
    CALL    sonda_displays_sound                ; chama a rotina que diminui 5 no display e que reproduz um som
    MOV     R5, 1
    MOV     [existe_sonda+4],R5                 ; mete na memória que a sonda 2 existe
    JMP     verifica_teclaC                     ; volta à procura duma tecla premida


inicia_jogo:
    MOV    R6, 8                                ; som número 4
    MOV    [TERMINA_SOM_VIDEO], R6              ; este ciclo inicia/ reinicia o jogo
    MOV    R6, 5                                ; som número 4
    MOV    [TERMINA_SOM_VIDEO], R6              ; este ciclo inicia/ reinicia o jogo
    MOV    R6, 2   
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 2
    MOV    R6, 4                                ; som número 4
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 4
    MOV    R6, 0                                  
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona um video para cenário de fundo
    MOV    [REPRODUZ_SOM_VIDEO_CICLO], R6       ; inicia a reprodução do video de fundo do jogo
    MOV    R6, 1   
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona o som de fundo do jogo
    MOV    [REPRODUZ_SOM_VIDEO_CICLO], R6       ; inicia a reprodução do som de fundo
    CALL   reset_posicoes_objetos
    CALL   nao_existe_sondas
    RET

continua_jogo:
    MOV    R6, 2                                 
    MOV    [APAGA_CENARIO_FRONTAL], R6          ; quando o jogo está parado e o terminamos, apagamos o cenário frontal(2)
    MOV    R6, 0
    MOV    [CONTINUA_SOM_VIDEO], R6             ; continua o video de fundo do jogo(0)
    MOV    R6, 1
    MOV    [CONTINUA_SOM_VIDEO], R6             ; continua o som de fundo do jogo(1)
    MOV    R6, JOGO_A_CORRER
    MOV    [jogo_estado], R6
    JMP    verifica_teclaC

suspende_jogo:
    MOV    R6, 1
    MOV    [SUSPENDE_SOM_VIDEO], R6             ; pausa o video de fundo do jogo(1)
    MOV    R6, 0
    MOV    [SUSPENDE_SOM_VIDEO], R6             ; pausa o som de fundo do jogo(0)
    MOV    R6, 2
    MOV    [SELECIONA_CENARIO_FRONTAL], R6      ; coloca cenario frontal de pausa do jogo(2)
    MOV    R6, JOGO_PAUSADO
    MOV    [jogo_estado], R6
    JMP    verifica_teclaC

termina_jogo:
    MOV    [APAGA_ECRÃ], R6                     ; não interesssa o valor de R5, apaga todos os pixels, de todos os ecrãs
    MOV    R6, 2
    MOV    [APAGA_CENARIO_FRONTAL], R6          ; apaga o cenário frontal número 2 (transparência)
    MOV    R6, 1                      
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 1
    MOV    R6, 0   
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o video número 0
    MOV    R6, 1   
    MOV    [SELECIONA_CENARIO_FUNDO], R6        ; seleciona o cenário de fundo número 1
    MOV    R6, 4   
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona o som que diz respeito ao jogo ter terminado(4)
    MOV    [REPRODUZ_SOM_VIDEO], R6             ; inicia a reprodução do som número 4
    MOV    R6, JOGO_NAO_INICIADO
    MOV    [jogo_estado], R6
    CALL   reset_posicoes_objetos
    CALL   nao_existe_sondas
    JMP    verifica_teclaC

nao_existe_sondas:                              ; mete na memória que nenhuma das sonda aparece no ecrã
    PUSH    R0
    PUSH    R1
    PUSH    R2
    MOV     R0, N_MAX_SONDAS
    MOV     R1, existe_sonda

loop_sonda_n:
    SUB     R0, 1                               ; decrementa para que comece na sonda 2
    MOV     R2, 0
    MOV     [R1], R2                            ; põe todas as sondas como inexetentes
    ADD     R1, 2                               ; adiciona r1 ao endereço da memória para passar para a seguinte word
    CMP     R0, 0                               ; verifica se já fez o que tinha a fazer a todas as sondas
    JNZ     loop_sonda_n
    POP     R2
    POP     R1
    POP     R0
    RET

reset_posicoes_objetos:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    MOV     R3, N_ASTEROIDES

reset_posições_asteroides:
    SUB     R3, 1                               ; subtrai um porque quremos começar no asteroide 4
    MOV     R7, R3
    MOV     R4, R3                              ; para preservar o numero do asteroide
    SHL     R4, 1
    MOV     R5, escolha_asteroide_posicao       ; tabela com a coluna inicial de cada asteroide
    ADD     R5, R4
    MOV     R2, [R5]                            ; R2  agora tem a nova coluna inicial do asteroide
    MOV     R4, LINHA_ASTEROIDE
    MOV     R6, posicao_asteroides              ; tabela com a posição dos asteroide no momento
    SHL     R7, 2
    ADD     R7, 2
    ADD     R6, R7
    MOV     [R6], R2                            ; reinicia a coluna do asteroide, na tabela
    SUB     R6, 2
    MOV     [R6], R4                            ; reinicia a linha do asteroide, na tabela
    CMP     R3, 0                               ; verifica se já foi feito para todos os asteroides
    JNZ     reset_posições_asteroides
    MOV     R1, N_MAX_SONDAS

reset_posicao_sondas:
    SUB     R1, 1                               ; subtrai um porque queremos começar na sonda 2
    MOV     R0, R1                              ; para preservar o valor da sonda
    MOV     R2, posicao_sondas                  ; tabela com as posições atuais de cada uma das sondas
    SHL     R0, 2                               ; multiplica por 2 o valor da sonda para sabermos qual valor na memória por a 0
    ADD     R2, R0
    MOV     R6, LINHA_INICIAL_SONDA
    MOV     [R2], R6                            ; reinicia a linha da sonda, na tabela
    ADD     R2, 2                               ; adiciona 2 para passar para a seguinte word 
    MOV     R6, COLUNA_INICIAL_SONDA
    MOV     [R2], R6                            ; reinicia a coluna da sonda, na tabela
    CMP     R1, 0                               ; verifica se já foi feito para todas as sondas
    JNZ     reset_posicao_sondas

retorna_reset_posicoes:
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

sonda_displays_sound:
    MOV    R6, 3   
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona o som número 3 (beep)
    MOV    [REPRODUZ_SOM_VIDEO], R6             ; inicia a reprodução do beep
energia_sonda:
    MOV     R7, -5                              ; argumento de entrada para energia
    CALL    energia                             ; decrementa 5 no display
    CALL    acabou_energia                      ; verifica se o valor que iamos por no display era menor ou igual a zero
    RET

; ******************************************************************************************************************************************************
; TECLADO - Processo que deteta quando se carrega numa tecla do teclado.
; ******************************************************************************************************************************************************
PROCESS SPinit_teclado                          ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
teclado:
    MOV     R2, TEC_LIN                         ; endereço do periférico das linhas
    MOV     R3, TEC_COL                         ; endereço do periférico das colunas

restart_linhas:
    MOV     R1, LINHA                           ; coloca 16 = 10000 em binário no registo 1
    WAIT

espera_tecla:                                   ; neste ciclo espera-se até uma tecla ser premida
    SHR     R1, 1                               ; passa para a linha seguinte
    CMP     R1, 0                               ; verifica se ja passamos pelas linhas todas
    JZ      restart_linhas                      ; voltamos ao inicio das linhas 
    MOVB    [R2], R1                            ; escrever no periférico de saída (linhas)
    MOVB    R0, [R3]                            ; ler do periférico de entrada (colunas)
    MOV     R4, MASCARA                         ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    AND     R0, R4                              ; elimina bits para além dos bits 0-3
    CMP     R0, 0                               ; há tecla premida?
    JZ      espera_tecla                        ; se nenhuma tecla for premida, repete
    SHL     R1, 4                               ; coloca linha no nibble high
    OR      R1, R0                              ; junta coluna (nibble low)
    MOV     [evento_tecla_carregada], R1        ; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada 
    
repeticao_tecla:
    YIELD
    MOV     R8, 0
    MOV     R7, MASCARA                            
    MOVB    R8, [R3]                            ; ler do periférico de entrada (colunas)
    AND     R8, R7                              ; elimina bits para além dos bits 0-3
    CMP     R8, 0                               ; há tecla premida?
    JNZ     repeticao_tecla                     ; se ainda houver uma tecla premida, espera até não haver
    JMP     restart_linhas

; ******************************************************************************************************************************************************
; BONECO - Processo que apaga e desenha um boneco numa nova posição, fazendo com que se mova
; ******************************************************************************************************************************************************

PROCESS SPinit_boneco	                        ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
boneco:					                        ; processo que implementa o comportamento do boneco
    MOV     R1, TAMANHO_PILHA                   ; tamanho de cada pilha (100H)
    MUL     R1, R11                             ; multiplica pelo numero do asteroide
    MOV     R3, R11                             ; guarda o nº do asteroide para ser usado para a escolha da coluna inicial
    SUB     SP, R1                              ; subtrai a pilha total (100H*5) ao numero do asteroide * 100 


escolhe_asteroide_tipo:
    MOV     R1, [valor_aleatorio]                   
    CMP     R1, 0
    JZ      escolhe_asteroide_bom               ; se valor aleatorio é 0 vem asteroide bom
    JMP     escolhe_asteroide_mau               ; se valor aleaotorio 1, 2, ou 3 vem asteroide mau
                                                ; assim a probabilidade de ser criado um mau é de 75% e um bom de 25%

escolhe_asteroide_bom:
    MOV     R9, tipo_asteroide                  ; guardamos na tabela o tipo de asteroide que foi criado
    MOV     R4, R3                              ; para preservar R3
    SHL     R4, 1
    ADD     R9, R4                              ; para aceder a posiçao correta da tabela
    MOV     R4, 0
    MOV     [R9], R4

	MOV	    R9, DEF_ASTEROIDE_BOM		        ; endereço da tabela que define o boneco
    JMP     escolhe_posicao

escolhe_asteroide_mau:
    MOV     R9, tipo_asteroide
    MOV     R4, R3
    SHL     R4, 1
    ADD     R9, R4
    MOV     R4, 1
    MOV     [R9], R4

	MOV	    R9, DEF_ASTEROIDE_MAU		        ; endereço da tabela que define o boneco

escolhe_posicao:
    MOV	    R11, [evento_init_boneco]	        ; lê o LOCK e bloqueia até a interrupção escrever nele

    MOV     R11, R3
    MOV     R6, R11                                 ; coloca o nº do boneco em R6
    SHL     R11, 2                                  ; multiplica por 4 pois a tabela vai de 4 em 4 (2 words por asteroide)
    MOV     R10,R11                                 ; guarda o numero do asteroide para usar pra posiçao
    MOV     R4, posicao_asteroides                  ; endereço da tabela que guarda a posiçao dos asteroides na memoria
    ADD     R4, R10                                 ; endereço da tabela de posicao + nº asteroide * 4
    MOV     R8, [R4]                                ; R8 guarda linha
    ADD     R4, 2                                   ; word seguinte, primeiro guardamos linha, na a seguir a coluna
    MOV     R10, [R4]                               ; R10 guarda coluna

    MOV     R4, sentido_movimento_coluna_asteroide  ; endereço da tabela de sentido dos asteroides
    SHL     R6, 1	                                ; multiplica por 2 pois estamos a tratar de WORDS
    MOV     R7, [R4 + R6]                           ; guarda o incremento por coluna
    MOV     R5, 1                                   ; incremento da linha

    
    MOV     R2, posicao_asteroides              ; guardamos o endereço da posicao do asteroide
    MOV     R0, R11
    ADD     R2, R0                              ; seleciona qual asteroide estamos a alterar a posição
    MOV     R6, R2                                      
    ADD     R6, 2

ciclo_boneco:
    MOV     R11, R3                             ; para preservar o R3
    ADD     R11, 2
    MOV     [SELECIONA_ECRÃ], R11               ; seleciona o ecrã
    MOV     R11, 0
	CALL	desenha_apaga_boneco		        ; apaga o boneco a partir da tabela	                        
    ADD	    R8, R5			                    ; para desenhar objeto na linha seguinte 
    ADD	    R10, R7			                    ; para desenhar objeto na coluna seguinte 
    MOV     R11, 1
	CALL	desenha_apaga_boneco		        ; desenha o boneco a partir da tabela
    MOV     [R2], R8                            ; guarda a linha atual do asteroide na memoria
    MOV     [R6], R10                           ; guarda a coluna atual do asteroide na memoria

    CALL    limites                             
    CMP     R11, 1                              
    JZ      reset_posicao
    CMP     R11, 2
    JZ      acaba_jogo
    JMP     escolhe_posicao

limites:
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R7
    PUSH    R8
    MOV     R1, asteroide_que_explodiu          ; tabela que tem 1 se o asteroide explodiu e 0 senão
    MOV     R4, R3                              ; para preservar R3
    SHL     R4, 1
    ADD     R1, R4
    MOV     R5, [R1]                            ; passa o endereço da tabela para R5
    MOV     R4, 0                       
    MOV     [R1], R4                            ; coloca 0 no valor na tabela, correspondente a este asteroide
    CMP     R5, 1                               ; verifica se o valor que estva na tabela, correspondente a este asteroide, é 1
    JZ      reset_posicao                       ; se for quer dizer que o asteroide passou dos limites então reinicia.se as posições iniciais desse asteroide
    MOV     R7, R2
    MOV     R8, 5
    CALL    verifica_limites                    ; verifica se o asteroide passou dos limites do ecrã, ou se chocou com a nave
    POP     R8
    POP     R7
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    RET

reset_posicao:
    CALL    rotina_posicao
    JMP     escolhe_asteroide_tipo              ; vê qual é o valor que foi colocado na memória na rotina de interrupção da sonda

rotina_posicao:
    PUSH    R2
    PUSH    R4
    PUSH    R5
    PUSH    R11
    MOV     R4, R3                              ; para preservar o numero do asteroide
    SHL     R4, 1
    MOV     R5, escolha_asteroide_posicao       ; tabela com os valores iniciais das colunas dos asteroides
    ADD     R5, R4
    MOV     R2, [R5]                            ; R2  agora tem a nova coluna inicial do asteroide
    MOV     R4, LINHA_ASTEROIDE
    MOV     [R6], R2                            ; coloca na tabela, que tem as posições no momento, o valor da coluna inicial   
    SUB     R6, 2
    MOV     [R6], R4                            ; coloca na tabela, que tem as posições no momento, o valor da linha inicial 
    MOV     R11, 0
    CALL    desenha_apaga_boneco
    POP     R11
    POP     R5
    POP     R4
    POP     R2
    RET

acaba_jogo:
    CALL    jogo_perdido 
    JMP     escolhe_posicao
    
; ******************************************************************************************************************************************************
; DISPLAY - Processo que vai decrementando em 3% a energia apresentada no display
; ******************************************************************************************************************************************************
PROCESS SPinit_display                          ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
energia_tempo:
    MOV     R0, [evento_init_display]           ; verificação lock
    MOV     R7, -3                              ; decrementa 3 a cada interrupção
    CALL    energia                             ; coloca o valor no display
    CALL    acabou_energia                      ; verifica se o display está a menos de 0
    JMP     energia_tempo

; ******************************************************************************************************************************************************
; PAINEL_NAVE - Processo que vai trocando os padrões no painel da nave
; ******************************************************************************************************************************************************

PROCESS SPinit_painelnave                       ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
painel_nave:
    MOV     R2, 0           
    JMP     restart_loop

painel_nave_loop:
    MOV     R0, [evento_init_nave]              ; LOCK da nave        
    MOV     [SELECIONA_ECRÃ], R2                
    MOV     R8, LINHA_ECRA_NAVE                 ; linha onde o ecrã é desenhado
    MOV     R10, COLUNA_ECRA_NAVE               ; coluna onde o ecrã é desenhado
    MOV     R11, 0                              ; 0 para apagar
    CALL    desenha_apaga_boneco
    MOV     R11, 1                              ; 1 para desenhar
    CALL    desenha_apaga_boneco
    MOV     R10, 32d                            ; para "saltar entre tabelas
    ADD     R9, R10                             
    SUB     R1, 1                               ; loop para quando chegar a 0 voltar à tabela inicial
    CMP     R1, 0
    JZ      restart_loop
    JMP     painel_nave_loop

restart_loop:
    MOV     R9, DEF_ECRA_NAVE_1
    MOV     R1, 7
    JMP     painel_nave_loop

; ******************************************************************************************************************************************************
; SONDA - Processo que faz a soda mudar de posição com o tempo.
;         É também neste processo que percebemos se houve uma colisão de alguma das sondas com algumdos asteroide  
; ******************************************************************************************************************************************************

PROCESS SPinit_sonda                            ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
incremento_sonda:
    MOV     R0, R10
    MOV     R5, R0
    MOV     R1, R0                              ; movemos para R1 para poder modificar o incremento
    ADD     R1, 1                               ; adicionar 1 para apontar para a "centena" correta da pilha
    MOV     R3, TAMANHO_PILHA
    MUL     R1, R3                              ; R1 passa a ter o enderço da pilha
    SUB     SP, R1                              ; a sonda com este incremento fica com a respetiva pilha

    ADD     R0, 1                                   ; como usamos o incremento da sonda precisamos de somar 1 para começar em 0
    SHL     R0, 2                                   ; multiplicar por 2 para aceder ao endreço correto
    MOV     R7, posicao_sondas                      ; guardamos o endereço da posicao da sonda
    ADD     R7, R0                                  ; seleciona qual sonda estamos a alterar a posição e o R7 fica para aceder a linha
    MOV     R6, R7                                  ; adicionar 2 e o R6 fica o endereço para a coluna   
    ADD     R6, 2                                   ; para aceder a linha
    MOV     R2, R0                                  ; pretendemos usar o R2 para o lock_sonda
    SHR     R2, 1                                   ; na tabela onde vai ser usado cada sonda ocupa 1 word (em vez de 2)

seleciona_posicao_tabela:
    MOV	    R3, [evento_init_sonda]	            ; lê o LOCK e bloqueia até a interrupção escrever nele

    MOV     R9, posicao_sondas                  ; endereço da tabela que guarda a posiçao das sondas
    ADD     R9, R0                              ; endereço da sonda que queremos mexer
    MOV     R8, [R9]                            ; guarda linha inicial da sonda em R8
    ADD     R9, 2                               
    MOV     R10, [R9]                           ; guarda coluna inicial da sonda em R10
    MOV     R9, DEF_SONDA                       ; guarda em R9  o endereço que define o desenho da sonda

lock_sonda:                                     ; "lock" para apenas deixar este processo correr quando queremos usar uma sonda
    YIELD
    MOV     R11, existe_sonda                   
    ADD     R11, R2                                 
    MOV     R1, [R11]                               
    CMP     R1, 0                               ; verificamos o valor guardado na memoria 
    JZ      lock_sonda  

move_sonda:                                     ; label encarregada de fazer o movimento da sonda 
    MOV     R4, 1
    MOV     [SELECIONA_ECRÃ], R4                ; seleciona o ecrã desejado para desenhar a sonda
    MOV     R11, 0
	CALL	desenha_apaga_boneco		        ; apaga o boneco a partir da tabela
    SUB	    R8, 1			                    ; para desenhar objeto na linha anterior 
    ADD	    R10, R5		                        ; para desenhar objeto na coluna seguinte 
    MOV     R11, 1
	CALL	desenha_apaga_boneco		        ; desenha o boneco a partir da tabela
    MOV     [R7], R8                            ; para guardar a linha da sonda na memoria 
    MOV     [R6], R10                           ; para guardar a coluna da sonda na memoria
    CALL    colisão
    CMP     R11, -1                             ; se não há, R11 terá -1, caso contrário iremos para há_colisao
    JNZ     há_colisao
    MOV     R3,R8                               ; linha onde se encontra a sonda        
    MOV     R8, 1                               ; R8 é um argumento de entrada para verifica_limites sonda
    CALL    verifica_limites_sonda              ; verifica se a sonda saiu do ecrã
    MOV     R8, R3                              
    CMP     R11, 0                              ; verificamos se a sonda saiu dos limites, se nao acontecer apenas voltamos ao inicio
    JZ      seleciona_posicao_tabela
    JNZ     ha_colisao_limite

colisão:
    PUSH    R0
    MOV     R0, R7                                  
    CALL    colisoes_asteroide                   ; verificamos se houve alguma colisao com esta sonda
    POP     R0
    RET

ha_colisao_limite:
    MOV     R11, 0                              ; caso haja qualquer tipo de colisao
    CALL    desenha_apaga_boneco
    MOV     R11, LINHA_INICIAL_SONDA            ; da reset à posiçao da sonda
    MOV     [R7], R11
    MOV     R11 , COLUNA_INICIAL_SONDA
    MOV     [R6], R11
    MOV     R11, existe_sonda                   ; permite ao utilizador criar outra sonda
    ADD     R11, R2
    MOV     R4, 0
    MOV     [R11], R4
    JMP     seleciona_posicao_tabela
há_colisao:                                 
    CALL    ativa_explosao                         
    SHL     R11, 1
    MOV     R3, asteroide_que_explodiu
    ADD     R11, R3                             
    CALL    memoria_explodiu
    MOV     R11, 0                              ; caso haja qualquer tipo de colisao
    CALL    desenha_apaga_boneco
    MOV     R11, LINHA_INICIAL_SONDA            ; da reset à posiçao da sonda
    MOV     [R7], R11
    MOV     R11 , COLUNA_INICIAL_SONDA
    MOV     [R6], R11
    MOV     R11, existe_sonda                   ; permite ao utilizador criar outra sonda
    ADD     R11, R2
    MOV     R4, 0
    MOV     [R11], R4
    JMP     seleciona_posicao_tabela
memoria_explodiu:
    PUSH    R5
    MOV     R5, 1
    MOV     [R11], R5                           ; guardamos em memoria qual asteroide é que explodiu
    POP     R5
    RET

ativa_explosao:                                 ; guarda que tipo de asteroide teve uma colisao
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R6
    PUSH    R7
    MOV     R1, R11
    MOV     R2, tipo_asteroide                  ; tabela que tem qual o tipo de ada um dos asteroides no ecrã
    SHL     R1, 1
    ADD     R2, R1
    MOV     R3, [R2]                            ; verificamos que tipo de asteroide explodiu 
    CALL    animacao_explosao
    CMP     R3, 0
    JZ      e_asteroide_bom                     ; se for bom queremos aumentar energia
    JMP     e_asteroide_mau

e_asteroide_bom:
    MOV     R7, 25                              ; incrementa 25
    CALL    energia                             ; chama a rotina energia, incrementa ou decrementa o valor em R7
    CALL    ganhou_jogo                         ; verifica se ganhamos o jogo
    MOV     R6, 7
    MOV     [SELECIONA_SOM_VIDEO], R6           ; seleciona o som que diz respeito ao jogo ter terminado(4)
    MOV     [REPRODUZ_SOM_VIDEO], R6            ; inicia a reprodução do som número 4

e_asteroide_mau:
    MOV     R6, 6   
    MOV     [SELECIONA_SOM_VIDEO], R6           ; seleciona o som que diz respeito ao jogo ter terminado(4)
    MOV     [REPRODUZ_SOM_VIDEO], R6            ; inicia a reprodução do som número 4
    POP     R7
    POP     R6
    POP     R3
    POP     R2
    POP     R1
    RET
    
animacao_explosao:
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11

    ;seleciona o asteroide que explodiu
    MOV R7, R11
    SHL R7, 2
    MOV R11, posicao_asteroides
    ADD R11, R7

    MOV R8, [R11]                   ;linha onde se deve desenhar o efeito
    MOV R10, [R11+2]                ;coluna onde se deve desenhar o efeito

    MOV R11, 1
    MOV [SELECIONA_ECRÃ], R11
    MOV R11, 1
    MOV R9, DEF_EFEITO_ASTEROIDE
    CALL desenha_apaga_boneco           ;desenha o efeito da explosao

    MOV R7, 0FFFFH
    atrasa:                             ;funçao de atraso para se ver o desenho do efeito
    SUB R7,1
    CMP R7,0
    JNZ atrasa

    MOV R11,0
    CALL desenha_apaga_boneco           ;apaga o efeito

    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    RET


; ******************************************************************************************************************************************************
; ROTINAS 
; ******************************************************************************************************************************************************


;*******************************************************************************************************************************************************
;JOGO_PERDIDO 
;*******************************************************************************************************************************************************
jogo_perdido:
    PUSH   R6
    MOV    R6, JOGO_NAO_INICIADO
    MOV    [jogo_estado], R6
    MOV    R6, 2
    MOV    [APAGA_CENARIO_FRONTAL], R6          ; apaga o cenário frontal número 2 (transparência)
    MOV    R6, 1                      
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 1
    MOV    R6, 0   
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o video número 0
    MOV    R6, 4   
    MOV    [SELECIONA_CENARIO_FUNDO], R6        ; seleciona o cenário de fundo número 1
    MOV    R6, 4   
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona o som que diz respeito ao jogo ter terminado(4)
    MOV    [REPRODUZ_SOM_VIDEO], R6             ; inicia a reprodução do som número 4
    MOV    [APAGA_ECRÃ], R6                     ; não interesssa o valor de R5, apaga todos os pixels, de todos os ecrãs
    CALL   reset_posicoes_objetos
    CALL   nao_existe_sondas
    POP    R6
    RET

;*******************************************************************************************************************************************************
; ENERGIA - rotina que incrementa/ decrementa o valor no display
; Argumentos:  R7 - valor a adicionar ao display
;*******************************************************************************************************************************************************
energia:
    PUSH    R7
    MOV     R6, [valor_display]                 ; colocamos em R6, o valor que está no display, mas em hexadecimal
    ADD     R6, R7                              ; adicionamos quantas unidades queremos alterar no display
    MOV     [valor_display], R6                 ; depois voltamos a colocar na memória o valor em hexadecimal, depois de termos feito a alteração no mesmo
    CALL    hex_para_dec                        ; transforma este número em hexadecimal no seu respetivo decimal e coloca na memória
    POP     R7
    RET

;*******************************************************************************************************************************************************
; ACABOU_ENERGIA - rotina que verifica se o valor que supostamenete devia estar no display é menor ou igual a zero
;*******************************************************************************************************************************************************
acabou_energia:
    CMP     R6, 0
    JGE     retorna_energia
    MOV     [APAGA_ECRÃ], R6                    ; não interesssa o valor de R5, apaga todos os pixels, de todos os ecrãs
    MOV     R6, 2
    MOV     [APAGA_CENARIO_FRONTAL], R6         ; apaga o cenário frontal número 2 (transparência)
    MOV     R6, 1                      
    MOV     [TERMINA_SOM_VIDEO], R6             ; termina o som número 1
    MOV     R6, 0   
    MOV     [TERMINA_SOM_VIDEO], R6             ; termina o video número 0
    MOV     R6, 3   
    MOV     [SELECIONA_CENARIO_FUNDO], R6       ; seleciona o cenário de fundo número 3
    MOV     R6, 5   
    MOV     [SELECIONA_SOM_VIDEO], R6           ; seleciona o som que diz respeito ao jogo ter terminado 5
    MOV     [REPRODUZ_SOM_VIDEO], R6            ; inicia a reprodução do som número 5
    MOV     R6, 0
    MOV     [jogo_estado], R6
retorna_energia:
    RET

;*******************************************************************************************************************************************************
; GANHOU_JOGO - rotina que verifica se o valor no display é maior ou igual a 200 
;*******************************************************************************************************************************************************

ganhou_jogo:
    PUSH    R0
    MOV     R6, [valor_display]                 ; ler o valor no display
    MOV     R0, 0C8H                            ; verficar se é menor do que 200
    CMP     R6, R0                              ; se for retorna, caso contrário executa fim_jogo
    JLT     retorna

fim_jogo:
    MOV     [APAGA_ECRÃ], R6                    ; não interesssa o valor de R5, apaga todos os pixels, de todos os ecrãs
    MOV     R6, 2
    MOV     [APAGA_CENARIO_FRONTAL], R6         ; apaga o cenário frontal número 2 (transparência)
    MOV     R6, 1                      
    MOV     [TERMINA_SOM_VIDEO], R6             ; termina o som número 1
    MOV     R6, 0   
    MOV     [TERMINA_SOM_VIDEO], R6             ; termina o video número 0
    MOV     R6, 5   
    MOV     [SELECIONA_CENARIO_FUNDO], R6       ; seleciona o cenário de fundo número 5
    MOV     R6, 8  
    MOV     [SELECIONA_SOM_VIDEO], R6           ; seleciona o som 8
    MOV     [REPRODUZ_SOM_VIDEO], R6            ; inicia a reprodução do som número 8
    MOV     R6, 0
    MOV     [jogo_estado], R6

retorna:
    POP     R0
    RET

; ******************************************************************************************************************************************************
; DESENHA_APAGA_BONECO - Rotina Desenha/Apaga um boneco na linha e coluna indicadas
;			             com a forma e cor definidas na tabela indicada.
; Argumentos:   R8 -  linha do boneco
;               R9 - endereço da tabela que define o boneco
;               R10 - coluna do boneco
;               R11 - 1(para desenhar), 0(para apagar)
;
; ******************************************************************************************************************************************************
desenha_apaga_boneco:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7

verifica_jogo_a_correr:                         ; serve para que nada seja desnhado quando o jogo não está a correr
    MOV     R0, [jogo_estado]
    MOV     R6, 1
    CMP     R0, R6
    JNZ     retorna_ciclo_desenho

posicão_desenho:
    MOV     R0, R8                              ; coloca no registo R0 o número da linha do primeiro pixel, do asteroide bom, a ser desenhado
    MOV     R1, R10                             ; coloca no registo R1 o número da coluna do primeiro pixel, do asteroide bom, a ser desenhado
    MOV     R6, 0
    ADD     R6, R0   
    SUB     R6, 1                               ; subtrai 1 à soma 

percorre_tabela:
    MOV     R2, R9                              ; endereço da tabela que define o asteroide bom
    MOV     R3, [R2]                            ; obtem a largura do asteroide bom
    MOV     R7, R3
    ADD     R2, 2                               ; obtem  o endereço da altura do asteroide bom
    MOV     R4, [R2]                            ; obtem a altura da asteroide bom
    ADD     R6, R4                              ; soma da altura do asteroide com a sua primeira linha
    ADD     R2, 2                               ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels:                                 ; desenha os pixels do boneco a partir da tabela
    MOV     R5, [R2]                            ; obtém a cor do próximo pixel do boneco
    MUL     R5, R11                             ; define se a função apaga ou desenha
    MOV     [DEFINE_LINHA], R0                  ; seleciona a linha
    MOV     [DEFINE_COLUNA], R1                 ; seleciona a coluna
    MOV     [DEFINE_PIXEL], R5                  ; altera a cor do pixel na linha e coluna selecionadas
    ADD     R2, 2                               ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD     R1, 1                               ; próxima coluna
    SUB     R3, 1                               ; menos uma coluna para tratar
    JNZ     desenha_pixels                      ; continua até percorrer toda a largura do objeto
    CMP     R0, R6                              ; verifica se chegou ao fim do desenho
    JZ      retorna_ciclo_desenho
    ADD     R0, 1                               ; passa para desenhar na proxima linha
    MOV     R1, R10                             ; volta a desenhar na primeira coluna
    MOV     R3, R7                              ; contador de colunas ao maximo
    JMP     desenha_pixels

retorna_ciclo_desenho:
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

; ******************************************************************************************************************************************************
; hex_para_dec- rotina que converte um número hexadecimal, no respetivo decimal
; ******************************************************************************************************************************************************
hex_para_dec:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R6

    MOV     R0, 100                             ; define R0 como 100, que é usado como uma constante na transformação
    MOV     R1, 10                              ; define R1 como 10, que é usado como uma constante na transformação
    MOV     R2, 0                               ; inicializa R2 como 0, que será usado para acumular os dígitos convertidos
    MOV     R4, R6                              ; move o valor de R6 para R4, para guardar o valor original de R6
transformação:
    MOV     R3, R4                              ; move o valor de R4 para R3 para preservar o valor original
    DIV     R3, R0                              ; divide o valor de R3 por R0 para obter o quociente da divisão
    MOD     R4, R0                              ; calcula o resto da divisão de R4 por R0
    DIV     R0, R1                              ; divide o valor de R0 por R1 para atualizar o valor de R0 para a próxima iteração
    SHL     R2, 4                               ; desloca o conteúdo de R2 em 4 bits para a esquerda, R2 é utilizado como mascara
    OR      R2, R3                              ; combina o conteúdo de R2 e R3, acumulando os dígitos convertidos
    CMP     R0, 0                               ; verifica se cada um dos digitos do número hexadecimal já foram convertidos
    JNZ     transformação

retorna_ciclo_transforma:
    MOV     R6, DISPLAYS
    CMP     R2, 0                               
    JLT     display_a_zero                      ; se o valor que supostamente iamos por no display for menor que 0, então colocamos o display a zero
    MOV     [R6], R2  
    JMP     retorna_transforma 

display_a_zero:
    MOV    R2, 0                                
    MOV    [R6], R2                             ; coloca o display a zeros

retorna_transforma:
    POP    R6
    POP    R4
    POP    R3
    POP    R2
    POP    R1
    POP    R0
    RET 

; ******************************************************************************************************************************************************
; VERIFICA_LIMITES - 
;			             
; Argumentos:   R8 - largura/altura (iguais)
;               R7 - endereço para a posiçao na memoria
; Saida:        R11- 1 se o objeto sair dos limites, 2 se a nave explodir  e 0 caso nao aconteça nada
;
; ******************************************************************************************************************************************************
verifica_limites:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    SUB     R8, 1
    MOV     R11, 0                              ;caso nao aconteça nada retorna 0
    MOV     R0, [R7]                            ;linha do objeto
    MOV     R1, [R7+2]                          ;coluna do objeto

verifica_nave:
    MOV     R2, 25                              ; coluna minima
    MOV     R3, 39                              ; coluna maxima
    MOV     R4, 27                              ; linha minimo
    
verifica_topo_nave:
    MOV     R5, R0
    ADD     R5, R8
    CMP     R5, R4                              ; compara a linha do asteroide com a da nave 
    JLE     continua_verificacoes               ; se o objeto e estive a cima do topo da nave então não ocorreu colisão

verifica_direita_nave:
    MOV     R5,R1
    CMP     R5,R3                               ; compara a coluna esquerda do objeto com a coluna direita da nave
    JGE     continua_verificacoes               ; se o objeto estiver à direita da coluna direita da nave então não ocorreu colisão

verifica_esquerda_nave:
    MOV     R5, R1
    ADD     R5, R8
    CMP     R5, R2
    JLE     continua_verificacoes
    MOV     R11, 2                              ; compara a coluna direita do objeto com a coluna esquerda da nave
    JMP     retorna_limites                     ; se o objeto estiver à esquerda da coluna esqurda da nave então não ocorreu colisão

continua_verificacoes:  
    MOV     R2, 0                               ; coluna e linha minima
    MOV     R3, 63                              ; coluna maxima
    MOV     R4, 31                              ; linha maxima


; verifica limites do ecrã
verifica_direita:
    CMP     R1, R3                              ; compra a coluna do asteroide com a coluna máxima 
    jz      ha_colisao                          ; se forem iguais houve uma colisão com os limites do ecrã

verifica_esquerda:
    MOV     R5, R1
    ADD     R5, R8
    CMP     R5, R2                              ; compara a coluna direita do objeto com a coluna direita do ecrã 
    JZ      ha_colisao                          ; se forem iguais houve uma colisão com os limites do ecrã

verifica_baixo:
    CMP     R0, R4                              ; compara a linha do objeto com a linha minima do ecrão
    jz      ha_colisao                          ; se forem iguais houve uma colisão com os limites do ecrã

verifica_topo:
    MOV     R5, R0
    ADD     R5, R8
    CMP     R5, R2                              ; compara a linha da parte de baixo do objeto com o topo do ecrã
    JZ      ha_colisao                          ; se forem iguais houve uma colisão com os limites do ecrã
    

retorna_limites:
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

ha_colisao:
    MOV     R11, 1                              
    JMP     retorna_limites

;*******************************************************************************************************************************************************
; VERIFICA_LIMITES_SONDA - 
;			             
; Argumentos:   R8 - largura/altura (iguais)
;               R7 - endereço para a posiçao na memoria
; 
; Saida:        R11- 1 se o objeto sair dos limites, 2 se a nave explodir  e 0 caso nao aconteça nada
;
; ******************************************************************************************************************************************************
verifica_limites_sonda:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R9
    SUB     R8, 1
    MOV     R11, 0                              ;caso nao aconteça nada retorna 0
    MOV     R0, [R7]                            ;linha do objeto
    MOV     R1, [R7+2]                          ;coluna do objeto


continua_verificacoes_sonda:  
    MOV     R9, 13                              ; coluna minima até onde vai a sonda 
    MOV     R3, 50                              ; coluna maxima até onde vai a sonda
    MOV     R4, 12                              ; linha maxima 

verifica_direita_sonda:
    CMP     R1, R3                              ; compara a coluna esquerda do objeto com a coluna máxima até onde vai a sonda
    jz      ha_colisao_sonda                    ; se der 0 é suposto voltar a sonda à sua posição inicial

verifica_esquerda_sonda:
    MOV     R5, R1
    ADD     R5, R8
    CMP     R5, R9                              ; compara a coluna da direita do objeto com a coluna minima até onde vai a sonda
    JZ      ha_colisao_sonda                    ; se der 0 é suposto voltar a sonda à sua posição inicial

verifica_baixo_sonda:
    CMP     R0, R4                              ; compara a linha de cima do objeto com a linha maxima do ecrã
    jz      ha_colisao_sonda                    ; se der 0 é suposto voltar a sonda à sua posição inicial

retorna_limites_sonda:
    POP     R9
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

ha_colisao_sonda:
    MOV     R11, 1
    JMP     retorna_limites_sonda



; ******************************************************************************************************************************************************
; colisoes_asteroide - rotina que verifica se a sonda colidiu com algum asteroide
;			             
; Argumentos:   R0- posiçao da sonda na memoria
;
; Saida:        R11- 1 se o asteroide explodir e 0 caso nao aconteça nada
;
; ******************************************************************************************************************************************************
colisoes_asteroide:

    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R9

    MOV     R11, -1                             ; se não houver uma colisão este valor não é alterado

    ;SONDA:
    ;R0-LINHA
    ;R1-COLUNA
    MOV     R1, [R0+2]                          ;indica a coluna da sonda
    MOV     R9, [R0]
    MOV     R0, R9                              ;indica a linha da sonda

    MOV     R2, N_ASTEROIDES                   
    MOV     R3,0                                ;contador para verificar todos os asteroides
    MOV     R9, 0

    ;ASTEROIDE:
    ;R5-LINHA TOPO
    ;R6-LINHA BAIXO
    ;R7-COLUNA ESQUERDA
    ;R8-COLUNA DIREITA
obtem_limites_asteroide:
    MOV     R4, posicao_asteroides
    MOV     R3, R9
    SHL     R3,2
    ADD     R4,R3                               ;seleciona o asteroide que iremos verificar
    MOV     R5, [R4]                            ;obtem linha topo do asteroide
    MOV     R6, R5
    ADD     R6, 4                               ;obtem linha de baixo do asteroide
    MOV     R7, [R4+2]                          ;obtem a coluna da esquerda do asteroide
    MOV     R8, R7
    ADD     R8, 4                               ;obtem a coluna da direita do asteroide
  
verifica_topo_asteroide:
    CMP     R0, R5
    JLT     continua_verificacoes_asteroide     ; se estiver a cima do topo do asteroide já sabemos que não colidiu

verifica_baixo_asteroide:
    CMP     R0,R6
    JGT     continua_verificacoes_asteroide     ; se estiver a cima da parte de baixo também já sabemos que não colidiu

verifica_esquerda_asteroide:
    CMP     R1,R7
    JLT     continua_verificacoes_asteroide     ; se estiver à esquerda do lado esquerdo do asteroide já sabemos que não colidiu

verifica_direita_asteroide:
    CMP     R1, R8
    JGT     continua_verificacoes_asteroide     ; se estiver à direita do lado direito do asteroide també já sabemos que não colidiu

MOV     R11, R9                                 ; se tiver colidido coloca R11 com o número do asteroide que explodiu
JMP     fim_colisoes

continua_verificacoes_asteroide:
    ADD     R9,1
    CMP     R9, R2
    JNZ     obtem_limites_asteroide

fim_colisoes:
    POP     R9
    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    RET


;*******************************************************************************************************************************************************
; ROTINAS DE INTERRUPÇÃO
;*******************************************************************************************************************************************************

; ******************************************************************************************************************************************************
; ROT_INT_BONECO - 	Rotina de atendimento da interrupção 0
;			        Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			        Como basta indicar que a interrupção ocorreu (não há mais
;			        informação a transmitir). Dependendo do estado do jogo,
;                   a interrupção irá ou não desbloquear o lock.
; ******************************************************************************************************************************************************
rot_int_boneco:
    PUSH    R3
    PUSH    R7
    MOV     R3, 1
    MOV     R7, [jogo_estado]  
	CMP     R7, R3
    JZ      boneco_unlock

retorna_int:
    POP     R7
    POP     R3
    RFE

boneco_unlock:
    MOV	    [evento_init_boneco], R0	        ; desbloqueia processo boneco (qualquer registo serve)
    JMP     retorna_int

; ******************************************************************************************************************************************************
; ROT_INT_DISPLAY - Rotina de atendimento da interrupção 2
;			        Faz simplesmente uma escrita no LOCK que o processo display lê.
;			        Como basta indicar que a interrupção ocorreu (não há mais
;			        informação a transmitir). Dependendo do estado do jogo,
;                   a interrupção irá ou não desbloquear o lock.
; ******************************************************************************************************************************************************
rot_int_display:
    PUSH    R3
    PUSH    R7
    MOV     R3, 1
    MOV     R7, [jogo_estado]  
	CMP     R7, R3
    JZ      display_unlock

retorna_int_display:
    POP     R7
    POP     R3
    RFE

display_unlock:
    MOV	    [evento_init_display], R0	        ; desbloqueia processo painel_nave (qualquer registo serve)
    JMP     retorna_int_display

; ******************************************************************************************************************************************************
; ROT_INT_PAINEL_NAVE - Rotina de atendimento da interrupção 3
;			            Faz simplesmente uma escrita no LOCK que o processo painel_nave lê.
;			            Como basta indicar que a interrupção ocorreu (não há mais
;			            informação a transmitir). Dependendo do estado do jogo,
;                       a interrupção irá ou não desbloquear o lock.
; ******************************************************************************************************************************************************
rot_int_painel_nave:
    PUSH    R3
    PUSH    R7
    MOV     R3, 1
    MOV     R7, [jogo_estado]  
	CMP     R7, R3
    JZ      nave_unlock

retorna_int_nave:
    POP     R7
    POP     R3
    RFE

nave_unlock:
    MOV	    [evento_init_nave], R0	            ; desbloqueia processo painel_nave (qualquer registo serve)
    JMP     retorna_int_nave

;*******************************************************************************************************************************************************
; ROT_INT_SONDA -  Rotina de atendimento da interrupção 4
;			       Faz simplesmente uma escrita no LOCK que o processo painel_nave lê.
;			       Dependendo do estado do jogo,
;                  a interrupção irá ou não desbloquear o lock.
;                  Coloca um valor aleatorio na memória para auxiliar na ecolha de que asteroide criar
;*******************************************************************************************************************************************************																																				 
rot_int_sonda:
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R7
    MOV     R3, 1
    MOV     R7, [jogo_estado]  
	CMP     R7, R3                              ; verifica se o jogo está a correr
    JNZ     fim_rot_int_sonda                   ; se o jogo não estiver a correr não dá unlock 
                                                ; nem gera valores aleatorios

continuar_int_sonda:                            ; o valor aleatório é um número no intervalo [0, 3] 
    MOV     R1, [valor_aleatorio]               ; vai buscar o valor aleatorio à memoria 
    CMP     R1, 0                               
    JZ      mete_1                              
    CMP     R1, 1                               
    JZ      mete_2
    CMP     R1, 2                               
    JZ      mete_3
    JMP     mete_0

mete_1:                                         ; se o valor que estava anteriormente na memória era 0
    MOV     R2, 1                               ; associado à criação dum asteroide mau
    MOV     [valor_aleatorio], R2               ; coloca o valor aleatorio na memoria
    JMP     sonda_unlock

mete_0:                                         ; se o valor que estava anteriormente na memória era 3
    MOV     R2, 0                               ; associado à criação dum asteroide bom
    MOV     [valor_aleatorio], R2               ; coloca o valor aleatorio na memoria
    JMP     sonda_unlock

mete_2:                                         ; se o valor que estava anteriormente na memória era 1
    MOV     R2, 2                               ; associado à criação dum asteroide mau
    MOV     [valor_aleatorio], R2               ; coloca o valor aleatorio na memoria
    JMP     sonda_unlock

mete_3:                                         ; se o valor que estava anteriormente na memória era 2
    MOV     R2, 3                               ; associado à criação dum asteroide mau
    MOV     [valor_aleatorio], R2               ; coloca o valor aleatorio na memoria
    JMP     sonda_unlock


sonda_unlock:
    MOV	    [evento_init_sonda], R0	            ; desbloqueia processo sonda (qualquer registo serve)

fim_rot_int_sonda:
    POP     R7
    POP     R3
    POP     R2
    POP     R1
    RFE

