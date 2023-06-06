
verifica_teclaC:
    MOV    R1, [evento_tecla_carregada]         ; bloqueia aqui o processo caso nao haja tecla carregada   
    MOV    R4, TECLA_C    
    CMP    R1, R4                               ; a tecla premida é a c?
    JNZ    verifica_teclaD
    MOV    R4, [jogo_estado] 
    MOV    R1, JOGO_A_CORRER
    CMP    R4, R1
    JZ     verifica_teclaD
    MOV    R6, 0100H
    MOV    R0, DISPLAYS
    MOV    [R0], R6
    MOV    R0, 0064H
    MOV    [valor_display], R0
    MOV    R3, JOGO_A_CORRER
    MOV    [jogo_estado], R3
    MOV    R11, 1                               ; para indicar que é para desenhar
    MOV    R8, LINHA_NAVE
    MOV    R10, COLUNA_NAVE
    MOV    R9, DEF_NAVE
    CALL   desenha_apaga_boneco
    MOV    R3, JOGO_NAO_INICIADO
    CMP    R3, R4
    JZ     inicia_jogo
    JMP    verifica_teclaC

verifica_teclaD:
    MOV    R4, TECLA_D
    CMP   R1, R4
    JNZ   verifica_teclaE
    MOV    R4, [jogo_estado]
    MOV    R1, JOGO_NAO_INICIADO
    CMP    R4, R1
    JZ     verifica_teclaE
    MOV    R1, JOGO_PAUSADO
    CMP    R4, R1
    JZ     continua_jogo
    MOV    R1, JOGO_A_CORRER
    CMP    R4, R1
    JZ     suspende_jogo
    JMP verifica_teclaC

verifica_teclaE:
    MOV    R4, TECLA_E
    CMP   R1, R4
    JNZ   verifica_tecla0
    MOV    R4, [jogo_estado]
    MOV    R1, JOGO_NAO_INICIADO
    CMP    R4, R1
    JNZ    termina_jogo
    JMP verifica_teclaC





inicia_jogo:
    MOV    R6, 5                                ; som número 4
    MOV    [TERMINA_SOM_VIDEO], R6              ; este ciclo inicia/ reinicia o jogo
    MOV    R6, 2   
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 2
    MOV    R6, 4                                ; som número 4
    MOV    [TERMINA_SOM_VIDEO], R6              ; termina o som número 4
    MOV    R6, 0                                  
    MOV    [SELECIONA_SOM_VIDEO], R6           ; seleciona um video para cenário de fundo
    MOV    [REPRODUZ_SOM_VIDEO_CICLO], R6           ; inicia a reprodução do video de fundo do jogo
    MOV    R6, 1   
    MOV    [SELECIONA_SOM_VIDEO], R6            ; seleciona o som de fundo do jogo
    MOV    [REPRODUZ_SOM_VIDEO_CICLO], R6       ; inicia a reprodução do som de fundo
    JMP    verifica_teclaC

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
    JMP    verifica_teclaC