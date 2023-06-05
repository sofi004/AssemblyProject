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
JOGO_NAO_INICIADO EQU 0
JOGO_A_CORRER EQU 1
JOGO_PAUSADO EQU 2
TECLA_C EQU 0081H
TECLA_D EQU 0082H
TECLA_E EQU 0084H
TECLA_0 EQU 0011H
TECLA_1 EQU 0012H
TECLA_2 EQU 0014H

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
LINHA_ASTEROIDE EQU 0                       ; linha onde vai ser desenhado o primeiro pixel do asteroide bom
COLUNA_ASTEROIDE0 EQU 0                      ; coluna onde vai ser desenhado o primeiro pixel do asteroide bom
COLUNA_ASTEROIDE1 EQU 25
COLUNA_ASTEROIDE2 EQU 30
COLUNA_ASTEROIDE3 EQU 35
COLUNA_ASTEROIDE4 EQU 60

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
TAMANHO_PILHA		EQU  100H      ; tamanho de cada pilha, em words
N_BONECOS			EQU  5		; número de bonecos (até 4)


; ######################################################################################################################################################
; * ZONA DE DADOS 
; ######################################################################################################################################################
PLACE  1000H
STACK TAMANHO_PILHA			                            ; espaço reservado para a pilha do processo "programa principal"
    SPinit_principal:		                    ; este é o endereço com que o SP deste processo deve ser inicializado
STACK  TAMANHO_PILHA                                     ; espaço reservado para a pilha 200H bytes, 100H words
	SPinit_teclado:	
STACK  TAMANHO_PILHA * N_BONECOS                           ; espaço reservado para a pilha do processo "boneco"
    SPinit_boneco:
STACK TAMANHO_PILHA
        SPinit_painelnave:

evento_init_boneco:                             ; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
    LOCK 0 
evento_tecla_carregada:                         ; LOCK para o teclado comunicar aos restantes processos que tecla detetou
    LOCK 0
evento_init_nave:
    LOCK 0
    				
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_boneco			                ; rotina de atendimento da interrupção 0
    WORD 0
    WORD 0
    WORD rot_int_painel_nave

jogo_estado: WORD 0
posicao_asteroides:
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE0
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE1
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE2   
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE3
    WORD LINHA_ASTEROIDE, COLUNA_ASTEROIDE4 
    


sentido_movimento_coluna_asteroide:
    WORD 1
    WORD -1
    WORD 0
    WORD 1
    WORD -1

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
    WORD        COR_PIXEL_VERDE, COR_PIXEL_CINZENTO, COR_PIXEL_VERMELHO, COR_PIXEL_VERDE,COR_PIXEL_VERMELHO,COR_PIXEL_VERDE,COR_PIXEL_AZUL_CLARO
    
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
    EI3
    EI
    CALL    painel_nave
    CALL    teclado                              
    MOV     R11, N_BONECOS

    loop_asteroide:
        SUB R11, 1
        CALL   boneco  
        CMP R11, 0
        JNZ loop_asteroide                             

MOV R6, 0100H
MOV R0, DISPLAYS
MOVB [R0], R6
MOV R6, 0064H 
verifica_teclaC:
    MOV    R1, [evento_tecla_carregada]         ; bloqueia aqui o processo caso nao haja tecla carregada   
    MOV    R4, TECLA_C    
    CMP    R1, R4                               ; a tecla premida é a c?
    JNZ    verifica_teclaD
    MOV    R3, 1
    MOV    [jogo_estado], R3
    SUB    R6, 1
    CALL   hex_para_dec
    MOV    R11, 1                               ; para indicar que é para desenhar
    
    MOV    R8, LINHA_NAVE
    MOV    R10, COLUNA_NAVE
    MOV    R9, DEF_NAVE
    CALL   desenha_apaga_boneco
    
    JMP    verifica_teclaC

verifica_teclaD:
    MOV    R4, TECLA_D
    CMP   R1, R4
    JNZ   verifica_teclaE
    SUB R6, 1
    CALL hex_para_dec
    JMP verifica_teclaC

verifica_teclaE:
    MOV    R4, TECLA_E
    CMP   R1, R4
    JNZ   verifica_tecla0
    SUB R6, 1
    CALL hex_para_dec
    JMP verifica_teclaC

verifica_tecla0:
    MOV    R4, TECLA_0
    CMP  R1, R4
    JNZ  verifica_tecla1
    SUB R6, 1
    CALL hex_para_dec
    JMP verifica_teclaC

verifica_tecla1:
    MOV    R4, TECLA_1
    CMP  R1, R4
    JNZ  verifica_tecla2
    SUB R6, 1
    CALL hex_para_dec
    JMP verifica_teclaC

verifica_tecla2:
    MOV    R4, TECLA_2
    CMP  R1, R4
    JNZ  verifica_teclaC
    SUB R6, 1
    CALL hex_para_dec
    JMP verifica_teclaC

; ******************************************************************************************************************************************************
; hex_para_dec- rotina que converte um número hexadecimal, no respetivo decimal
; ******************************************************************************************************************************************************
hex_para_dec:
    PUSH   R0
    PUSH   R1
    PUSH   R2
    PUSH   R3
    PUSH   R4

    MOV    R0, 100                              ; define R0 como 100, que é usado como uma constante na transformação
    MOV    R1, 10                               ; define R1 como 10, que é usado como uma constante na transformação
    MOV    R2, 0                                ; inicializa R2 como 0, que será usado para acumular os dígitos convertidos
    MOV    R4, R6                               ; move o valor de R6 para R4, para guardar o valor original de R6
transformação:
    MOV    R3, R4                               ; move o valor de R4 para R3 para preservar o valor original
    DIV    R3, R0                               ; divide o valor de R3 por R0 para obter o quociente da divisão
    MOD    R4, R0                               ; calcula o resto da divisão de R4 por R0
    DIV    R0, R1                               ; divide o valor de R0 por R1 para atualizar o valor de R0 para a próxima iteração
    SHL    R2, 4                                ; desloca o conteúdo de R2 em 4 bits para a esquerda, R2 é utilizado como mascara
    OR     R2, R3                               ; combina o conteúdo de R2 e R3, acumulando os dígitos convertidos
    CMP    R0, 0                                ; verifica se cada um dos digitos do número hexadecimal já foram convertidos
    JNZ    transformação

retorna_ciclo_transforma:
    MOV    R6, DISPLAYS
    MOV    [R6], R2  
    POP    R4
    POP    R3
    POP    R2
    POP    R1
    POP    R0
    RET 

   
; **********************************************************************
; ROT_INT_BONECO - 	Rotina de atendimento da interrupção 0
;			        Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			        Como basta indicar que a interrupção ocorreu (não há mais
;			        informação a transmitir). Dependendo do estado do jogo,
;                   a interrupção irá ou não desbloquear o lock.
; **********************************************************************
rot_int_boneco:
    PUSH R3
    PUSH R7
    MOV   R3, 1
    MOV   R7, [jogo_estado]  
	CMP  R7, R3
    JZ   boneco_unlock
    retorna_int:
    POP R7
    POP R3
    RFE
    boneco_unlock:
    MOV	[evento_init_boneco], R0	; desbloqueia processo boneco (qualquer registo serve)
    JMP retorna_int

rot_int_painel_nave:
    PUSH R3
    PUSH R7
    MOV   R3, 1
    MOV   R7, [jogo_estado]  
	CMP  R7, R3
    JZ   nave_unlock
    retorna_int_nave:
    POP R7
    POP R3
    RFE
    nave_unlock:
    MOV	[evento_init_nave], R0	; desbloqueia processo painel_nave (qualquer registo serve)
    JMP retorna_int_nave

; ******************************************************************************************************************************************************
; TECLADO - Processo que deteta quando se carrega numa tecla do teclado.
; ******************************************************************************************************************************************************
PROCESS SPinit_teclado                          ; indicação de que a rotina que se segue é um processo,
						                        ; com indicação do valor para inicializar o SP
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
    MOV    [evento_tecla_carregada], R1         ; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada 
    

repeticao_tecla:
    YIELD
    MOV    R8, 0
    MOV    R7, MASCARA                            
    MOVB   R8, [R3]                             ; ler do periférico de entrada (colunas)
    AND    R8, R7                               ; elimina bits para além dos bits 0-3
    CMP    R8, 0                                ; há tecla premida?
    JNZ    repeticao_tecla                      ; se ainda houver uma tecla premida, espera até não haver
    RET


; **********************************************************************
; BONECO - Processo que desenha um boneco e o move horizontalmente, com
;		   temporização marcada pela interrupção 0
; **********************************************************************

PROCESS SPinit_boneco	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP
boneco:					; processo que implementa o comportamento do boneco

    MOV R1, TAMANHO_PILHA
    MUL R1, R11
    SUB SP, R1

    MOV R4, R11         ;registo para usar na seleçao do ecra

    MOV R10, R11
    SHL R10, 2

    MOV R9, posicao_asteroides
    ADD R9, R10                     ; endereço da tabela de posicao + nº asteroide * 4
    MOV R8, [R9]                    ; R8 guarda linha
    ADD R9, 2
    MOV R10, [R9]                   ; R10 guarda coluna

    MOV R9, sentido_movimento_coluna_asteroide      ; endereço da tabela de sentido dos asteroides
    MOV R6, R11                     ; coloca o nº do boneco em R6
    SHL R6, 1	                    ; multiplica por 2 pois estamos a tratar de WORDS
    MOV R7, [R9 + R6]               ; guarda o incremento por coluna
    MOV R5, 1                       ; incremento da linha
	
	; cena aleatoria escolher entre asteroide bom e mau

	MOV	 R9, DEF_ASTEROIDE_BOM		            ; endereço da tabela que define o boneco

ciclo_boneco:
    MOV	R3, [evento_init_boneco]	            ; lê o LOCK e bloqueia até a interrupção escrever nele

    CMP R4, 2
    JZ seleciona_ecra0
    CMP R4, 4
    JZ seleciona_ecra1
    CMP R4, 1
    JZ seleciona_ecra1
    CMP R4, 3
    JZ seleciona_ecra2
    CMP R4, 0
    JZ seleciona_ecra2
    seleciona_ecra0:
        MOV R2, 0
        MOV [SELECIONA_ECRÃ], R2
        JMP ecra_selecionado
    seleciona_ecra1:
        MOV R2, 1
        MOV [SELECIONA_ECRÃ], R2
        JMP ecra_selecionado
    seleciona_ecra2:
        MOV R2, 2
        MOV [SELECIONA_ECRÃ], R2
        JMP ecra_selecionado

    ecra_selecionado:
    
    MOV R11, 0
	CALL	desenha_apaga_boneco		        ; apaga o boneco a partir da tabela

	
						                        ; Quando bloqueia, passa o controlo para outro processo
						                        ; Como não há valor a transmitir, o registo pode ser um qualquer
    ADD	R8, R5			                        ; para desenhar objeto na linha seguinte 
    ADD	R10, R7			                        ; para desenhar objeto na coluna seguinte 

    MOV R11, 1
	CALL	desenha_apaga_boneco		        ; desenha o boneco a partir da tabela
    JMP ciclo_boneco
						                        ; Se se quisesse terminar o processo, era deixar o processo chegar a um RET

; ******************************************************************************************************************************************************
; DESENHA_APAGA_BONECO - Rotina Desenha/Apaga um boneco na linha e coluna indicadas
;			             com a forma e cor definidas na tabela indicada.
; Argumentos:   R8 - linha inicial
;               R10 - coluna inicial
;               R9 - tabela que define o boneco
;               R11 - 1(para desenhar), 0(para apagar)
;
; ******************************************************************************************************************************************************
desenha_apaga_boneco:
    PUSH   R0
    PUSH   R1
    PUSH   R2
    PUSH   R3
    PUSH   R4
    PUSH   R5
    PUSH   R6
    PUSH   R7

posicão_desenho:
    MOV    R0, R8                               ; coloca no registo R0 o número da linha do primeiro pixel, do asteroide bom, a ser desenhado
    MOV    R1, R10                              ; coloca no registo R1 o número da coluna do primeiro pixel, do asteroide bom, a ser desenhado
    MOV    R6, 0
    ADD    R6, R0   
    SUB    R6, 1                                ; subtrai 1 à soma 

percorre_tabela:
    MOV    R2, R9                               ; endereço da tabela que define o asteroide bom
    MOV    R3, [R2]                             ; obtem a largura do asteroide bom
    MOV    R7, R3
    ADD    R2, 2                                ; obtem  o endereço da altura do asteroide bom
    MOV    R4, [R2]                             ; obtem a altura da asteroide bom
    ADD    R6, R4                               ; soma da altura do asteroide com a sua primeira linha
    ADD    R2, 2                                ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels:                                 ; desenha os pixels do boneco a partir da tabela
    MOV    R5, [R2]                             ; obtém a cor do próximo pixel do boneco
    MUL    R5, R11                              ; define se a função apaga ou desenha
    MOV    [DEFINE_LINHA], R0                   ; seleciona a linha
    MOV    [DEFINE_COLUNA], R1                  ; seleciona a coluna
    MOV    [DEFINE_PIXEL], R5                   ; altera a cor do pixel na linha e coluna selecionadas
    ADD    R2, 2                                ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD    R1, 1                                ; próxima coluna
    SUB    R3, 1                                ; menos uma coluna para tratar
    JNZ    desenha_pixels                       ; continua até percorrer toda a largura do objeto
    CMP    R0, R6                               ; verifica se chegou ao fim do desenho
    JZ     retorna_ciclo_desenho
    ADD    R0, 1                                ; passa para desenhar na proxima linha
    MOV    R1, R10                              ; volta a desenhar na primeira coluna
    MOV    R3, R7                               ; contador de colunas ao maximo
    JMP    desenha_pixels

retorna_ciclo_desenho:
    POP    R7
    POP    R6
    POP    R5
    POP    R4
    POP    R3
    POP    R2
    POP    R1
    POP    R0
    RET


; ******************************************************************************************************************************************************
; PAINEL_INSTRUMENTOS_NAVE - Processo que deteta quando se carrega numa tecla do teclado.
; ******************************************************************************************************************************************************

PROCESS SPinit_painelnave

painel_nave:
    MOV R2,0
    JMP restart_loop
painel_nave_loop:
    MOV R0, [evento_init_nave]          ; verificação lock
    MOV [SELECIONA_ECRÃ], R2
    MOV R8, LINHA_ECRA_NAVE
    MOV R10, COLUNA_ECRA_NAVE
    MOV R11, 0
    CALL desenha_apaga_boneco
    MOV R11, 1
    CALL desenha_apaga_boneco
    MOV R10, 32d
    ADD R9, R10
    SUB R1, 1
    CMP R1, 0
    JZ restart_loop
    JMP painel_nave_loop


restart_loop:
    MOV R9, DEF_ECRA_NAVE_1
    MOV R1, 7
    JMP painel_nave_loop