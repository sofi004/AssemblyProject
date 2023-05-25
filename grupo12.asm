; ******************************************************************************
; * Projeto IAC 2022/23 - Versão Intermédia
; * Alunos: Filippo Bortoli(106103), João Gomes(106204), Sofia Piteira(106194)
; ******************************************************************************

; ******************************************************************************
; * DESCRIÇÃO
; * TECLA 4 -  move o asteroide bom uma linha e coluna para baixo
; * TECLA 5 -  move a sonda uma linha para cima
; * TECLA 8 -  aumenta em uma unidade o valor nos displays
; * TECLA 9 -  diminui em uma unidade o valor nos displays
; * TECLA C -  inicia/reinicia o jogo
; * TECLA D -  pausa/ continua o jogo 
; * TECLA E -  termina o jogo 
; ******************************************************************************

; ******************************************************************************
; * Constantes
; ******************************************************************************
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
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H    ; endereço do comando para colocar uma imagem para sobrepor o resto
APAGA_CENARIO_FRONTAL EQU COMANDOS + 44H        ; endereço do comando para apagar apagar o cenarios frontal
APAGA_ECRÃ  EQU COMANDOS + 02H                  ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_ECRÃ EQU COMANDOS + 04H               ; seleciona um ecrã especifico
MOSTRA_ECRÃ EQU COMANDOS + 06H                  ; mostra o ecrã especificado
ESCONDE_ECRÃ EQU COMANDOS + 08H                 ; esconde o ecrã especificado
MUTE EQU COMANDOS + 4CH                         ; corta o volume de todos os sons ou videos a reproduzir
DESMUTE EQU COMANDOS + 52Ħ                      ; retoma o volume de todos os sons ou videos a reproduzir 

; ******************************************************************************
; * Paleta
; ******************************************************************************
COR_PIXEL_VERDE  EQU 0F0F0H                     ; cor do pixel: verde em ARGB
COR_PIXEL_ROXO  EQU 0F85FH                      ; cor do pixel: roxo em ARGB
COR_PIXEL_VERMELHO  EQU 0FF00H                  ; cor do pixel: vermelho em ARGB
COR_PIXEL_TRANSPARENTE EQU 0FCCCH               ;cor do pixel; cinzento transparente
COR_PIXEL_CINZENTO EQU 0F777H                   ;cor do pixel; cinzento transparente
COR_PIXEL_AMARELO   EQU 0FFF0H                  ;cor do pixel: amarelo em ARGB
COR_PIXEL_AZUL_CLARO  EQU 0F0FFH                ;cor do pixel: azul em ARGB

; ******************************************************************************
; * Definição dos desenhos
; ******************************************************************************
LINHA_ASTEROIDE_BOM EQU 0                       ; linha onde vai ser desenhado o primeiro pixel do asteroide bom
COLUNA_ASTEROIDE_BOM EQU 0                      ; coluna onde vai ser desenhado o primeiro pixel do asteroide bom
LARGURA_ASTEROIDE  EQU 5                        ; largura do asteroide
ALTURA_ASTEROIDE  EQU 5                         ; altura do asteroide
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

; ##############################################################################
; * ZONA DE DADOS 
; ##############################################################################
PLACE  1000H
STACK  100H                                     ; espaço reservado para a pilha 200H bytes, 100H words
	SP_init:
	
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

; ******************************************************************************
; * Código
; ******************************************************************************
PLACE  0                                        ; o código tem que começar em 0000H
inicio:
    MOV  [APAGA_AVISO], R1                      ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1                       ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0                                  ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1          ; seleciona o cenário de fundo
    MOV  R9, 2                                  ; som número 2
    MOV  [SELECIONA_SOM_VIDEO], R9              ; seleciona um som para a intro do jogo
    MOV  [REPRODUZ_SOM_VIDEO], R9               ; inicia a reprodução do som da intro

; ******************************************************************************
; inicializações
; ******************************************************************************
    MOV  SP, SP_init
    MOV  R0, 0                                  ; inicializa R0 a 0 para simbolizar que o jogo ainda não está a correr
    MOV  R2, TEC_LIN                            ; endereço do periférico das linhas
    MOV  R3, TEC_COL                            ; endereço do periférico das colunas
    MOV  R4, DISPLAYS                           ; endereço do periférico dos displays
    MOV  R5, 0100H                              ; inicializa o valor de R5 a 100H para colocar no display
    MOV  [R4], R5                               ; inicializa o display a 100
    MOV  R5, 0064H                              ; 64 em hexadecimal é 100 é decimal
    MOV  R6, 0                                  ; inicializa o contador da tecla 4 para mover o asteroide 
    MOV  R7, 0                                  ; inicializa o contador da tecla 5 para mover a sonda

; ******************************************************************************
; corpo principal do programa
; ******************************************************************************
ciclo: 
    CALL  teclado                               ; verifica se alguma tecla foi carregada
    CALL escolhe_rotina                         ;escolhe a rotina a usar tendo em conta a tecla premida
    CALL ha_tecla                               ; esperamos que nenhuma tecla esteja a ser premida
    CMP  R0, 1                                  ; o jogo está a correr?
    JZ   desenhar                               ; se o jogo está a correr desenhamos a nave, os asteroides e a sonda   
    CMP R0, 4                                   ; a tecla 4 foi premida?
    JZ move_asteroide                           ; move-se o asteroide uma linha e coluna para baixo
    CMP R0, 5                                   ; a tecla 5 foi premida?
    JZ move_sonda                               ; move-se a sonda uma linha para cima 
    MOV R9, 8                                   ; mete-se 8 num registo, porque cmp só dá para usar diretamente com números até 7
    CMP R0, R9                                  ; a tecla 8 foi premida?
    JZ energia_mais_escolha                     ; aumenta-se o número no display uma unidade
    MOV R9, 9                                   ; mete-se 9 num registo, porque cmp só dá para usar diretamente com números até 7
    CMP R0, R9                                  ; a tecla 9 foi premida?
    JZ energia_menos_escolha                    ; diminui-se o número no display uma unidade
    JMP  ciclo                                  

desenhar:
    MOV R9, 1
    MOV [SELECIONA_ECRÃ], R9                    ; seleciona o ecrã número 1
    CALL asteroide_bom                          ; desenha o asteroide bom
    MOV R9, 0                                   
    MOV [SELECIONA_ECRÃ], R9                    ; seleciona o ecrã número 0
    CALL nave                                   ; desenha a nave
    CALL ecra_nave		                        ; desenha o ecrã da nave
    MOV R9, 2                                   
    MOV [SELECIONA_ECRÃ], R9                    ; seleciona o ecrã número 2
    CALL sonda                                  ; desenha a sonda
    JMP  ciclo

move_asteroide:
    MOV  R9, 0021H                              
    CMP  R1, R9                                 ; a tecla 4 está realmente a ser premida?
    JNZ ciclo                                   ; se a tecla 4 não estiver a ser premida estão volta-se a ciclo
    MOV  R9, 3                                 
    MOV  [SELECIONA_SOM_VIDEO], R9              ; seleciona o som número 3 (beep)
    MOV  [REPRODUZ_SOM_VIDEO], R9               ; inicia a reprodução do beep
    MOV R9, 1
    MOV [SELECIONA_ECRÃ], R9                    ; seleciona o ecrã número 1
    CALL mover_asteroide_bom                    ; move-se o asteroide uma linha e coluna para baixo
    JMP  ciclo
move_sonda:
    MOV  R9, 0022H
    CMP  R1, R9                                 ; a tecla 5 está realmente a ser premida?
    JNZ ciclo                                   ; se a tecla 5 não estiver a ser premida estão volta-se a ciclo
    MOV  R9, 3   
    MOV  [SELECIONA_SOM_VIDEO], R9              ; seleciona o som número 3 (beep)
    MOV  [REPRODUZ_SOM_VIDEO], R9               ; inicia a reprodução do beep
    MOV R9, 2
    MOV [SELECIONA_ECRÃ], R9                    ; seleciona o ecrã número 2
    CALL mover_sonda                            ; move-se a sonda uma linha para cima 
    JMP  ciclo

energia_mais_escolha:
    MOV  R9, 0041H
    CMP  R1, R9                                 ; a tecla 8 está realmente a ser premida?
    JNZ ciclo                                   ; se a tecla 8 não estiver a ser premida estão volta-se a ciclo
    JMP mais_energia                            ; aumenta o número no display uma unidade
    JMP  ciclo

energia_menos_escolha:
    MOV  R9, 0042H                              
    CMP  R1, R9                                 ; a tecla 9 está realmente a ser premida?
    JNZ ciclo                                   ; se a tecla 9 não estiver a ser premida estão volta-se a ciclo
    JMP menos_energia                           ; diminui o número no display uma unidade
    JMP  ciclo

; ******************************************************************************
; teclado - Processo que detecta quando se carrega numa tecla do teclado.
; ******************************************************************************
teclado:
    PUSH R0
    PUSH R2
    PUSH R4

restart_linhas:
    MOV  R1, LINHA                              ; coloca 16 = 10000 em binário no registo 1

espera_tecla:                                   ; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1                                  ; passa para a linha seguinte
    CMP  R1, 0                                  ; verifica se ja passamos pelas linhas todas
    JZ   restart_linhas                         ; voltamos ao inicio das linhas 
    MOVB [R2], R1                               ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]                               ; ler do periférico de entrada (colunas)
    MOV  R4, MASCARA                            ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    AND  R0, R4                                 ; elimina bits para além dos bits 0-3
    CMP  R0, 0                                  ; há tecla premida?
    JZ   espera_tecla                           ; se nenhuma tecla for premida, repete
    SHL  R1, 4                                  ; coloca linha no nibble high
    OR   R1, R0                                 ; junta coluna (nibble low)

    POP  R4
    POP  R2
    POP  R0
    RET

ha_tecla:                                       ; neste ciclo espera-se até NENHUMA tecla estar premida
    PUSH R8
    PUSH R7
repeticao_tecla:
    MOV  R7, MASCARA                            
    MOVB R8, [R3]                               ; ler do periférico de entrada (colunas)
    AND  R8, R7                                 ; elimina bits para além dos bits 0-3
    CMP  R8, 0                                  ; há tecla premida?
    JNZ  repeticao_tecla                        ; se ainda houver uma tecla premida, espera até não haver
    POP  R7
    POP  R8
    RET
; ******************************************************************************
; escolhe_rotina - Processo que executa a instrução associada à tecla premida
; ******************************************************************************
escolhe_rotina:
    PUSH  R4
    PUSH  R5

    MOV  R4, 0081H       
    CMP  R1, R4                                 ; verifica se a tecla premida é a c
    JZ   inicia_jogo_verificação                ; se a tecla premida for c, executa inicia_jogo
    CMP  R0, 0                                  ; o jogo ainda não está a correr?
    JNZ  fases_jogo                             ; se o jogo já começou
    JMP  retorna_ciclo                          ; se a tecla premida não está associada a nenhuma função volta ao ciclo

inicia_jogo_verificação:
    CMP  R0, 0                                  ; o jogo está a correr?
    JZ  inicia_jogo                             ; se o jogo não está a correr vamos pô-lo a correr 
    JMP  retorna_ciclo                          ; senão vamos esperar pela tecla c para o por a correr
inicia_jogo:                                    ; este ciclo inicia/ reinicia o jogo
    MOV  R5, 2   
    MOV  [TERMINA_SOM_VIDEO], R5                ; termina o som número 2
    MOV  R5, 4                                  ; som número 4
    MOV  [TERMINA_SOM_VIDEO], R5                ; termina o som número 4
    MOV  R0, 1                                  ; coloca 1 no registo para sabermos se o jogo está a correr ou não
    MOV  R5, 0                                  
    MOV  [SELECIONA_SOM_VIDEO], R5              ; seleciona um video para cenário de fundo
    MOV  [REPRODUZ_SOM_VIDEO], R5               ; inicia a reprodução do video de fundo do jogo
    MOV  R5, 1   
    MOV  [SELECIONA_SOM_VIDEO], R5              ; seleciona o som de fundo do jogo
    MOV  [REPRODUZ_SOM_VIDEO], R5               ; inicia a reprodução do som de fundo
    MOV  R6, 0                                  ; inicializa o contador da tecla 4 para mover o asteroide 
    MOV  R7, 0                                  ; inicializa o contador da tecla 5 para mover a sonda
    JMP  retorna_ciclo                          ; depois de iniciar o jogo volta a restart linhas 
    
 fases_jogo:
    MOV  R4, 0082H       
    CMP  R1, R4                                 ; verifica se a tecla premida é a d
    JZ   suspende_jogo                          ; se a tecla premida for d, executa suspende_jogo
    
    MOV  R4, 0084H      
    CMP  R1, R4                                 ; verifica se a tecla premida é a e
    JZ   termina_jogo                           ; se a tecla premida for e, executa termina_jogo
    
    MOV  R4, 0021H
    CMP  R1, R4                                 ; verifica se a tecla premida é a 4
    JZ   mover_asteroide_bom_fase               ; se a tecla premida for 4, mover_asteroide_bom_fase
    
    MOV  R4, 0022H
    CMP  R1, R4                                 ; verifica se a tecla premida é a 5
    JZ   mover_sonda_fase                       ; se a tecla premida for 5, executa mover_sonda_fase
    
    MOV R4, 0041H
    CMP R1, R4                                  ; verifica se a tecla premida é  8
    JZ energia_mais_fase                        ; se a tecla premida for a 8, executa energia_mais_fase 
    
    MOV R4, 0042H
    CMP R1, R4                                  ; verifica se a tecla premida é a 9
    JZ energia_menos_fase                       ; se a tecla premida for a 9, executa energia_menos_fase

    JMP  retorna_ciclo                          ; se não for nenhuma destas volta a ciclo, porque a tecla não tem nenhuma função associada
suspende_jogo:
    CMP  R0, 2                                  ; o jogo já começou e está parado?
    JZ   continua_jogo                          ; prosseguir com o jogo
    MOV  R5, 1
    MOV  [SUSPENDE_SOM_VIDEO], R5               ; pausa o video de fundo do jogo(1)
    MOV  R5, 0
    MOV  [SUSPENDE_SOM_VIDEO], R5               ; pausa o som de fundo do jogo(0)
    MOV  R5, 2
    MOV  [SELECIONA_CENARIO_FRONTAL], R5        ; coloca cenario frontal de pausa do jogo(2)
    MOV  R0, 2                                  ; coloca o valor 2 no R0, simbolizando o facto de o jogo já ter começado, mas estar parado
    JMP  retorna_ciclo

continua_jogo:
    MOV  R5, 2                                 
    MOV  [APAGA_CENARIO_FRONTAL], R5            ; quando o jogo está parado e o terminamos, apagamos o cenário frontal(2)
    MOV  R5, 0
    MOV  [CONTINUA_SOM_VIDEO], R5               ; continua o video de fundo do jogo(0)
    MOV  R5, 1
    MOV  [CONTINUA_SOM_VIDEO], R5               ; continua o som de fundo do jogo(1)
    MOV  R0, 1                                  ; coloca novamente R0 a 1 uma vez que depois deste ciclo o jogo volta a correr
    JMP  retorna_ciclo

termina_jogo:
    MOV [APAGA_ECRÃ], R5
    MOV  R5, 2
    MOV  [APAGA_CENARIO_FRONTAL], R5
    MOV  R5, 1   ; som número 1
    MOV  [TERMINA_SOM_VIDEO], R5   ; termina o som número 1
    MOV  R5, 0   ; video número 0
    MOV  [TERMINA_SOM_VIDEO], R5   ; termina o video número 0
    MOV  R5, 1   ; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R5 ; seleciona o cenário de fundo
    MOV  R5, 4   ; som número 4
    MOV  [SELECIONA_SOM_VIDEO], R5   ; seleciona o som que diz respeito ao jogo ter terminado
    MOV  [REPRODUZ_SOM_VIDEO], R5   ; inicia a reprodução do som que diz respeito ao jogo ter terminado
    MOV  R0, 0   ; no caso em que o jogo foi terminado coloca-se R0 a 0, porque o jogo não está a correr
    JMP  retorna_ciclo

mover_sonda_fase:
    MOV R0, 5
    JMP  retorna_ciclo

mover_asteroide_bom_fase:
    MOV R0, 4
    JMP  retorna_ciclo

energia_mais_fase:
    MOV R0, 8
    JMP  retorna_ciclo

energia_menos_fase:
    MOV R0, 9
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
    ADD R6, ALTURA_ASTEROIDE   ; soma da altura do asteroide com a linha do asteroide bom
    SUB R6, 1   ; subtrai 1 à soma da altura do asteroide com a linha do asteroide bom

desenha_asteroide_bom:
    MOV R2, DEF_ASTEROIDE_BOM   ; endereço da tabela que define o asteroide bom
    MOV R3, [R2]   ; obtem a largura do asteroide bom
    ADD R2, 2   ; obtem  o endereço da altura do asteroide bom
    MOV R4, [R2]   ; obtem a altura da asteroide bom
    ADD R2, 2   ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels_asteroide_bom:   ; desenha os pixels do boneco a partir da tabela
    MOV R5, [R2]   ; obtém a cor do próximo pixel do boneco
    MOV [DEFINE_LINHA], R0   ; seleciona a linha
    MOV [DEFINE_COLUNA], R1   ; seleciona a coluna
    MOV [DEFINE_PIXEL], R5   ; altera a cor do pixel na linha e coluna selecionadas
    ADD R2, 2   ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R1, 1   ; próxima coluna
    SUB R3, 1   ; menos uma coluna para tratar
    JNZ desenha_pixels_asteroide_bom ; continua até percorrer toda a largura do objeto

CMP R0, R6  ; verifica se chegou ao fim do desenho
JZ retorna_ciclo_asteroide_bom
ADD R0, 1   ; passa para desenhar na proxima linha
MOV R1, COLUNA_ASTEROIDE_BOM   ; volta a desenhar na primeira coluna
MOV R3, LARGURA_ASTEROIDE   ; contador de colunas ao maximo
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
MOV R3, LARGURA_NAVE   ;contador de colunas ao maximo
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
; ecra_nave - Processo que desenha o ecra da nave
; ******************************************************************************
ecra_nave:
    PUSH  R0
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6

posicão_ecra_nave:
    MOV R0, LINHA_ECRA_NAVE
    MOV R1, COLUNA_ECRA_NAVE
    ADD R6, R0
    ADD R6, ALTURA_ECRA_NAVE
    SUB R6, 1

desenha_ecra_nave:
    MOV R2, DEF_ECRA_NAVE_2   ; endereço da tabela que define o asteroide bom
    MOV R3, [R2]   ; obtem a largura do asteroide bom
    ADD R2, 2   ; obtem  o endereço da altura do asteroide bom
    MOV R4, [R2]   ; obtem a altura da asteroide bom
    ADD R2, 2   ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_pixels_ecra_nave:
    MOV R5, [R2]
    MOV [DEFINE_LINHA], R0
    MOV [DEFINE_COLUNA], R1
    MOV [DEFINE_PIXEL], R5
    ADD R2, 2
    ADD R1, 1
    SUB R3, 1
    JNZ desenha_pixels_ecra_nave

CMP R0, R6
JZ retorna_ciclo_nave_ecra
ADD R0, 1
MOV R1, COLUNA_ECRA_NAVE
MOV R3, LARGURA_ECRA_NAVE   ;contador de colunas ao maximo
JMP desenha_pixels_ecra_nave

retorna_ciclo_nave_ecra:
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

; ******************************************************************************
; apaga_nave - Processo que apaga a nave
; ******************************************************************************
apaga_nave:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5 
    PUSH R6
    PUSH R7

posição_inicio_apagar_nave:
    MOV  R1, LINHA_NAVE 
    MOV  R2, COLUNA_NAVE
    ADD R7, R1
    ADD R7, ALTURA_NAVE

desenha_apaga_nave:
	MOV	R4, DEF_NAVE		; endereço da tabela que define o boneco
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2			 
    MOV R6, [R4]            ; obtem a altura do boneco
    
apaga_pixeis_nave:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0			; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1               ; próxima coluna
    SUB  R5, 1			; menos uma coluna para tratar
    JNZ  apaga_pixeis_nave      ; continua até percorrer toda a largura do objeto

    
    CMP R1, R7      ;verifica se chegou ao fim do desenho
    JZ retorna_ciclo_apaga_nave

    ADD R1, 1            ;passa para apagar na proxima linha
    MOV R2, COLUNA_NAVE    ;volta a apagar na primeira coluna
    MOV R5, LARGURA_NAVE             ;contador de colunas ao maximo
    JMP apaga_pixeis_nave

retorna_ciclo_apaga_nave:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; ******************************************************************************
; apaga_asteroide - Processo que apaga o asteroide
; ******************************************************************************
apaga_asteroide_bom:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5 
    PUSH R6
    PUSH R7

posição_inicio_apagar_asteroide_bom:
    MOV  R1, LINHA_ASTEROIDE_BOM
    MOV  R2, COLUNA_ASTEROIDE_BOM
    ADD R7, R1
    ADD R7, ALTURA_ASTEROIDE

desenha_apaga_asteroide_bom:
	MOV	R4, DEF_ASTEROIDE_BOM		; endereço da tabela que define o boneco
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2			 
    MOV R6, [R4]            ; obtem a altura do boneco
    
apaga_pixeis_asteroide_bom:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0			; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1               ; próxima coluna
    SUB  R5, 1			; menos uma coluna para tratar
    JNZ  apaga_pixeis_asteroide_bom      ; continua até percorrer toda a largura do objeto

    
    CMP R1, R7      ;verifica se chegou ao fim do desenho
    JZ retorna_ciclo_apaga_asteroide_bom

    ADD R1, 1            ;passa para apagar na proxima linha
    MOV R2, COLUNA_ASTEROIDE_BOM    ;volta a apagar na primeira coluna
    MOV R5, LARGURA_ASTEROIDE             ;contador de colunas ao maximo
    JMP apaga_pixeis_asteroide_bom

retorna_ciclo_apaga_asteroide_bom:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; ******************************************************************************
; apaga_sonda - Processo que apaga a sonda
; ******************************************************************************
apaga_sonda:
    PUSH R1
    PUSH R2
    PUSH R3

posição_inicio_apagar_sonda:
    MOV  R1, LINHA_SONDA
    MOV  R2, COLUNA_SONDA
    MOV  R3, 0
    
apaga_pixeis_sonda: 
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas

retorna_ciclo_apaga_sonda:
    POP R3
    POP R2
    POP R1
    RET

; ******************************************************************************
; mover_asteroide_bom - Processo que move o asteroide bom
; ******************************************************************************
mover_asteroide_bom:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R7 
    PUSH R8 

contador_tecla_4:
    ADD R6, 1
    MOV R5, R6
    SUB R5, 1

; apaga o asteroide da ultima posição
posição_move_inicio_apagar_asteroide_bom:
    MOV  R1, LINHA_ASTEROIDE_BOM
    ADD  R1, R5
    MOV  R2, COLUNA_ASTEROIDE_BOM
    ADD R2,R5
    ADD R7, R1
    ADD R7, ALTURA_ASTEROIDE

desenha_move_apaga_asteroide_bom:
	MOV	R4, DEF_ASTEROIDE_BOM		; endereço da tabela que define o boneco
	MOV	R8, [R4]			; obtém a largura do boneco
	ADD	R4, 2			 
    MOV R0, [R4]            ; obtem a altura do boneco
    
apaga_move_pixeis_asteroide_bom:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0			; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1               ; próxima coluna
    SUB  R8, 1			; menos uma coluna para tratar
    JNZ  apaga_move_pixeis_asteroide_bom      ; continua até percorrer toda a largura do objeto

    
    CMP R1, R7      ;verifica se chegou ao fim do desenho
    JZ posicão_move_asteroide_bom

    ADD R1, 1            ;passa para apagar na proxima linha
    MOV R2, COLUNA_ASTEROIDE_BOM    ;volta a apagar na primeira coluna
    ADD R2, R5
    MOV R8, LARGURA_ASTEROIDE             ;contador de colunas ao maximo
    JMP apaga_move_pixeis_asteroide_bom

; desenha o asteroide no novo local
posicão_move_asteroide_bom:
    MOV R0, LINHA_ASTEROIDE_BOM
    ADD R0, R6
    MOV R1, COLUNA_ASTEROIDE_BOM
    ADD R1, R6
    MOV R7, 0
    ADD R7, R0   
    ADD R7, ALTURA_ASTEROIDE   ; soma da altura do asteroide com a linha do asteroide bom
    SUB R7, 1   ; subtrai 1 à soma da altura do asteroide com a linha do asteroide bom

desenha_move_asteroide_bom:
    MOV R2, DEF_ASTEROIDE_BOM   ; endereço da tabela que define o asteroide bom
    MOV R3, [R2]   ; obtem a largura do asteroide bom
    ADD R2, 2   ; obtem  o endereço da altura do asteroide bom
    MOV R4, [R2]   ; obtem a altura da asteroide bom
    ADD R2, 2   ; obtem o endereço da cor do primeiro pixel do asteroide bom (2 porque a largura é uma word)

desenha_move_pixels_asteroide_bom:   ; desenha os pixels do boneco a partir da tabela
    MOV R8, [R2]   ; obtém a cor do próximo pixel do boneco
    MOV [DEFINE_LINHA], R0   ; seleciona a linha
    MOV [DEFINE_COLUNA], R1   ; seleciona a coluna
    MOV [DEFINE_PIXEL], R8   ; altera a cor do pixel na linha e coluna selecionadas
    ADD R2, 2   ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R1, 1   ; próxima coluna
    SUB R3, 1   ; menos uma coluna para tratar
    JNZ desenha_move_pixels_asteroide_bom ; continua até percorrer toda a largura do objeto

CMP R0, R7  ; verifica se chegou ao fim do desenho
JZ retorna_ciclo_move_asteroide_bom
ADD R0, 1   ; passa para desenhar na proxima linha
MOV R1, COLUNA_ASTEROIDE_BOM   ; volta a desenhar na primeira coluna
ADD R1, R6
MOV R3, LARGURA_ASTEROIDE   ; contador de colunas ao maximo
JMP desenha_move_pixels_asteroide_bom

retorna_ciclo_move_asteroide_bom:
    POP R8
    POP R7
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

; ******************************************************************************
; mover_sonda - Processo que move a sonda
; ******************************************************************************

mover_sonda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

contador_tecla_5:
    ADD R7, 1
    MOV R5, R7
    SUB R5, 1

posição_apagar_desenhar_sonda:
    MOV  R1, LINHA_SONDA
    SUB  R1, R5
    MOV  R2, COLUNA_SONDA
    MOV  R3, 0
    MOV  R4, COR_PIXEL_ROXO
    MOV  R6, LINHA_SONDA
    SUB  R6, R7
    
apaga_desenha_pixeis_sonda: 
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
    MOV  [DEFINE_LINHA], R6	; seleciona a linha
    MOV  [DEFINE_PIXEL], R4

    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


; ******************************************************************************
; display_energia- processo que altera o valor no display de energia
; ******************************************************************************
mais_energia:
    MOV  R4, DISPLAYS
    ADD R5, 01H
    MOV R6, R5
    CALL hex_para_dec
    MOV [R4], R6
    JMP  ciclo

menos_energia:
    MOV  R4, DISPLAYS
    SUB R5, 01H
    MOV R6, R5
    CALL hex_para_dec
    MOV [R4], R6
    JMP  ciclo

hex_para_dec:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R0, 100
    MOV R1, 10
    MOV R2, 0
MOV R4, R6
transformação:
    MOV R3, R4
    DIV R3, R0
    MOD R4, R0
    DIV R0, R1
    SHL R2, 4
    OR  R2, R3
    CMP R0, 0
    JNZ transformação

retorna_ciclo_transforma:
    MOV R6, R2
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET 