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

; ######################################################################################################################################################
; * ZONA DE DADOS 
; ######################################################################################################################################################
PLACE  1000H
STACK  100H                                     ; espaço reservado para a pilha 200H bytes, 100H words
	SP_init:	
    				
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			                    ; rotina de atendimento da interrupção 0

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
