; ******************************************************************************
; * Projeto IAC 2022/23 - Versão Intermédia
; * Alunos: Filippo Bortoli(106103), João Gomes(106204), Sofia Piteira(106194)
; ******************************************************************************

; ******************************************************************************
; * Constantes
; ******************************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 16      ; linha a testar (4ª linha, 1000b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter
DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo

; ##############################################################################
; * ZONA DE DADOS 
; ##############################################################################

; ******************************************************************************
; * Código
; ******************************************************************************
PLACE 0
inicio:
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo


;###############################################################################

; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R6, 0100H
    MOV [R4], R6   ; inicializa o display a 100

; corpo principal do programa

; teclado

;ciclo:
;    MOV  R1, 0 
;    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays

restart_linhas:
    MOV R1, LINHA

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1
    CMP  R1, 0         ; verifica se ja passamos pelas linhas todas
    JZ   restart_linhas; a linha que estamos a ver volta ao inicio
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JZ   espera_tecla  ; se nenhuma tecla premida, repete
                       ; vai mostrar a linha e a coluna da tecla
    SHL  R1, 4         ; coloca linha no nibble high
    OR   R1, R0        ; junta coluna (nibble low)
    JMP restart_linhas ;
;    MOVB [R4], R1      ; escreve linha e coluna nos displays
    
;ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premid
;    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
;    AND  R0, R5        ; elimina bits para além dos bits 0-3
;    CMP  R0, 0         ; há tecla premida?
;    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
;    JMP  ciclo         ; repete ciclo
