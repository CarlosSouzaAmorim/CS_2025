@echo off
rem cp3_test.bat
rem ----------------------------------------------------------------------------------------------------------------
rem FAZER: PORQUE NÃO USAR O NOME DOS ARQUIVOS APENAS??? afinal eles estarão sempre no mesmo caminho

REM AS VEZES A UNICA MANEIRA DE SABER DE ONDE ESTE BAT ESTA RODANDO:
rem SET CAMINHO_ORIGEM=C:\_O_HDN2\OneDrive\_GAMES\KSP\_c3_dev\

rem usar aqui pois vai garantir o comportamento desde o comeco: colocar um if se desejar obdecer ao configs:
set DEBUG_ECHO="nodebug"
set DEBUG_PAUSE="nopause"
set TEMPO_CHOICE=5
set TEMPO_MENU_CHOICE=30

set CONST_MSG_AGUARDANDO_DIFERENCAS=Aguardando diferencas...  [m=menu] [y=sair] [n=checar novamente] [t/out=%TEMPO_CHOICE%s]
SET CONF_FILE=cp3_config2.bat
SET COPY_PROG=cp3_test.bat
if not exist "%COPY_PROG%" GOTO ERRO_CONFIG
if not exist "%CONF_FILE%" GOTO ERRO_CONFIG

set TIPO_CONFIG=FILE
rem aqui nao define muito pois o que valera eh o que for gravado em cp3_config3
set EXCLUSAO_AUTOMATICA=False

PROMPT=#
COLOR 08

rem -------------  PRIMEIRO OS TESTES DOS PARAMETROS: ------------------------
if [%1]==[COMPARA_COPIA] goto COMPARA_COPIA
set COPY_EXIT=False
if [%1]==[COPY_EXIT] set COPY_EXIT=True


rem -------------  DEPOIS AS CONFIGS DE PRIMEIRA EXECUCAO: ------------------------
rem definir um slot padrao so pra nao dar erro na primeira execucao:
set SLOT_PADRAO=1

set ATUALIZADOR_DATA_HORA=_TUTORIALS\_CMD\teste_for.bat
rem carrega configs gravadas automaticamente na ultima execucao
set CONFIG_FILE_3=cp3_config3.bat

:SETUP_CONF_3
if exist "%CONFIG_FILE_3%" CALL %CONFIG_FILE_3%
if not exist %CONFIG_FILE_3% (echo    Nao encontrou arquivo CONF3: %CONFIG_FILE_3%
GOTO ERRO_CONFIG)



goto SETUP_CONF
rem ----------------------------------------------------------------------------------------------------------------
:SETUP_CONF
set NOVAS_CONFIGS=False

echo Carregando configs on [%CONF_FILE%]....
if not exist "%CONF_FILE%" GOTO ERRO_CONFIG
call "%CONF_FILE%"

rem ----------------------------------------------------------------------------------------------------------------
:VERIFICA_VARS
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 1

IF %NOVAS_CONFIGS%==True ECHO Novas configs carregadas para:
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 2

ECHO:
ECHO CONTINUAR PROBLEMA DO SET AQUI:
set NOME_DA_VAR=CAMINHO_ORIGEM_%SLOT_PADRAO%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_ORIGEM=%%%NOME_DA_VAR%%%
if %DEBUG_PAUSE%=="pause" PAUSE
set NOME_DA_VAR=CAMINHO_DESTINO_%SLOT_PADRAO%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_DESTINO=%%%NOME_DA_VAR%%%
if %DEBUG_PAUSE%=="pause" PAUSE

REM echo __:  %NOME_MODULO% 
echo PASTA ORIGEM :%CAMINHO_ORIGEM%
echo PASTA DESTINO:%CAMINHO_DESTINO%
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 3
if %DEBUG_PAUSE%=="pause" PAUSE
REM pause > nul
set NOVAS_CONFIGS=False

rem PROGRAMA LOOP COPIA AUTO NOVO ARQ DE KOS
REM if "%NOME_MODULO%"=="" GOTO ERRO_VARS_CONF
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 4
if "%CAMINHO_ORIGEM%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_DESTINO%"=="" GOTO ERRO_VARS_CONF
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 5

echo:

rem testar se as pastas existem e se é possível gravar nelas:
call :TESTE_DAS_PASTAS
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 6
if %PASTAS_EXISTEM%==False goto ERRO_VARS_CONF
if %PASTA_ORIGEM_EXISTE%==False goto ERRO_VARS_CONF
if %PASTA_DESTINO_EXISTE%==False goto ERRO_VARS_CONF
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::VERIFICA_VARS PONTO 7

ECHO %CONST_MSG_AGUARDANDO_DIFERENCAS%

rem SOMENTE DEFINE O VALOR INICIAL DE OPCAO_LOOP
if %VERIFICA_E_SAI%==True set OPCAO_LOOP=Y
if %VERIFICA_E_SAI%==False set OPCAO_LOOP=N

set FOI_DIFERENTE=False
goto LOOP_ARQUIVOS

rem ----------------------------------------------------------------------------------------------------------------
:LOOP_ARQUIVOS
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3::LOOP_ARQUIVOS PONTO 1


REM DADOS HDN2 EM NOTE POS SEM TELA
REM PROCESSOR_ARCHITECTURE=AMD64
REM PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 23 Stepping 10, GenuineIntel
REM PROCESSOR_LEVEL=6
REM PROCESSOR_REVISION=170a

REM somente para atualizar as configs e carregar outros arquivos esporadicamente
IF %TIPO_CONFIG%==FILE call %CONF_FILE%
if %NOVAS_CONFIGS%==True GOTO VERIFICA_VARS

call %COPY_PROG% COMPARA_COPIA c3.ks
call %COPY_PROG% COMPARA_COPIA c3_scr_msg.ks
call %COPY_PROG% COMPARA_COPIA c3_scr_tela.ks
call %COPY_PROG% COMPARA_COPIA c3_sup_func.ks
call %COPY_PROG% COMPARA_COPIA c3_init_vars.ks
call %COPY_PROG% COMPARA_COPIA c3_menu.ks
call %COPY_PROG% COMPARA_COPIA c3_para_testes.ks
call %COPY_PROG% COMPARA_COPIA c3_pid_node.ks
call %COPY_PROG% COMPARA_COPIA c3_files.ks
call %COPY_PROG% COMPARA_COPIA c3_utils.ks
call %COPY_PROG% COMPARA_COPIA c3_ship.ks
call %COPY_PROG% COMPARA_COPIA c3_term.ks
call %COPY_PROG% COMPARA_COPIA c3_cmd.ks
call %COPY_PROG% COMPARA_COPIA c3_song.ks
call %COPY_PROG% COMPARA_COPIA c3_ship_cfg.ks

call %COPY_PROG% COMPARA_COPIA boot\c3_autorun2.ks

call %COPY_PROG% COMPARA_COPIA cp.ks

if %FOI_DIFERENTE%==True ECHO %CONST_MSG_AGUARDANDO_DIFERENCAS%
if %FOI_DIFERENTE%==True TIME /T
if %FOI_DIFERENTE%==True echo --------------------------------------------------------------
set FOI_DIFERENTE=False

if %COPY_EXIT%==True GOTO FIM
if %ESPERAR_PAUSE%==True GOTO TESTA_PACIENCIA
:LOOP_ARQUIVOS_1
if %VERIFICA_E_SAI%==True GOTO FIM_PAUSA

REM DEPOIS QUE PASSOU PELO MENU: testar se eh para excluir os arquivos antes de cada.
rem 		por padrao o script somente atualiza arquivos que foram modificados:
rem			dessa forma todos os arquivos terao de ser atualizados na marra!

IF %EXCLUSAO_AUTOMATICA%==True goto EXCLUIR_SEM_CONFIRMACAO
:VOLTA_DA_EXCLUSAO_AUTOMATICA
goto LOOP_ARQUIVOS
REM ----- RETORNO DO LOOP DOS ARQUIVOS PARA O COMECO -------^^^^^^^^^^^^^^--------------------------

ECHO TERMINOU.
PAUSE > NUL
GOTO FIM
:RETORNO_DE_MENU_CONFIG
ECHO %CONST_MSG_AGUARDANDO_DIFERENCAS%
:TESTA_PACIENCIA
:TESTE_DE_PARADA_LOOP_ARQUIVOS

rem acho que so precisa de um:
if %MOSTRA_CHOICE%==True goto TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO
if %MOSTRA_CHOICE%==False goto TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO_NAO_MOSTRA

:TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO
choice /c YNM /t %TEMPO_CHOICE% /d N /m "[Y]SAIR,[N]CONTINUA=%TEMPO_CHOICE%s,[M]MENU"
goto TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO_OPCOES

:TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO_NAO_MOSTRA
choice /c YNM /t %TEMPO_CHOICE% /d N /m "[Y]SAIR,[N]CONTINUA=%TEMPO_CHOICE%s,[M]MENU">nul
goto TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO_OPCOES

:TESTE_DE_PARADA_LOOP_ARQUIVOS_CHOICE_TEMPO_OPCOES
IF %ERRORLEVEL% EQU 1 SET VERIFICA_E_SAI=True
IF %ERRORLEVEL% EQU 2 SET VERIFICA_E_SAI=False
IF %ERRORLEVEL% EQU 3 GOTO MENU_PAUSE_COPIADOR
goto LOOP_ARQUIVOS_1

set /p OPCAO_LOOP=SAIR?(enter=%OPCAO_LOOP%)[s/n]:
IF [%OPCAO_LOOP%]==[y] set VERIFICA_E_SAI=True
IF [%OPCAO_LOOP%]==[Y] set VERIFICA_E_SAI=True
IF [%OPCAO_LOOP%]==[s] set VERIFICA_E_SAI=True
IF [%OPCAO_LOOP%]==[S] set VERIFICA_E_SAI=True
IF [%OPCAO_LOOP%]==[n] set VERIFICA_E_SAI=False
IF [%OPCAO_LOOP%]==[N] set VERIFICA_E_SAI=False

goto LOOP_ARQUIVOS_1
rem ----------------------------------------------------------------------------------------------------------------
:MENU_PAUSE_COPIADOR

SET DEF_OP_CHOICE=6
rem echo. imprime linha em branco

ECHO:
echo OPCOES DISPONIVEIS
ECHO:
echo  1. ABRIR ARQUIVOS PARA EDICAO
echo  2. EDITAR COPIADOR BAT
echo  3. EDITAR CONFIGS BAT
echo  4. EDITAR ARQUIVOS KS
echo  5. MENU_CONFIG_AVANCADO
echo ^>6. VOLTAR [t/out %TEMPO_MENU_CHOICE% seg]
echo  7. ABRIR PASTAS
echo  8. LIMPAR FONTES NO DESTINO [EXCLUI TUDO!]
echo  9. SAIR (pressione o 0 para testar)

echo:

choice /c 1234567890 /t %TEMPO_MENU_CHOICE% /d %DEF_OP_CHOICE% /m "Escolha uma opcao (nao precisa enter)"
SET OPCAO_ESCOLHIDA_CHOICE=%ERRORLEVEL%
ECHO OPCAO_ESCOLHIDA_CHOICE: %OPCAO_ESCOLHIDA_CHOICE% 
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 1 goto NAO_IMPLEMENTADO
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 2 goto ABRIR_TUDO_NO_EDITOR
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 3 goto ABRIR_TUDO_NO_EDITOR
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 4 goto NAO_IMPLEMENTADO
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 5 goto MENU_CONFIG_AVANCADO
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 6 goto RETORNO_DE_MENU_CONFIG
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 7 goto ABRIR_PASTAS
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 8 goto EXCLUI_TUDO_NO_DESTINO
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 9 goto FIM

rem para debug:
pause

GOTO LOOP_ARQUIVOS_1

:NAO_IMPLEMENTADO
ECHO:
ECHO NAO IMPLEMENTADO!
ECHO:
PAUSE
GOTO MENU_PAUSE_COPIADOR

:ABRIR_TUDO_NO_EDITOR
ECHO:
ECHO NAO IMPLEMENTADO!
ECHO:
PAUSE
GOTO MENU_PAUSE_COPIADOR

:ABRIR_PASTAS
ECHO:
ECHO NAO IMPLEMENTADO!
ECHO:
CD %CAMINHO_DESTINO%
EXPLORER %CAMINHO_DESTINO%
START .
CD %CAMINHO_ORIGEM%
START .
ECHO ABRIU PASTAS...
ECHO:
PAUSE
GOTO MENU_PAUSE_COPIADOR


:EXCLUI_TUDO_NO_DESTINO
ECHO:
ECHO -------    ATENCAO: ISTO IRA EXCLUIR TODOS OS .KS E OS .KSM --------------
echo LOCAL: [%CAMINHO_DESTINO%]
DIR /B "%CAMINHO_DESTINO%*.KS"
DIR /B "%CAMINHO_DESTINO%*.KSm"
DIR /B "%CAMINHO_DESTINO%*.cfg"
DIR /B "%CAMINHO_DESTINO%boot\*.KS"
DIR /B "%CAMINHO_DESTINO%boot\*.KSm"
DIR /B "%CAMINHO_DESTINO%boot\*.cfg"

ECHO -------    ATENCAO: ISTO IRA EXCLUIR TODOS OS .KS E OS .KSM --------------
REM PAUSE
choice /c SCM /t %TEMPO_CHOICE% /d C /m "[S]SIM EXCLUIR,[C]CANCELAR,[M]MENU"
IF %ERRORLEVEL% EQU 1 GOTO CONFIRMAR_EXCLUSAO
IF %ERRORLEVEL% EQU 2 GOTO MENU_PAUSE_COPIADOR
IF %ERRORLEVEL% EQU 3 GOTO MENU_PAUSE_COPIADOR

GOTO MENU_PAUSE_COPIADOR

:CONFIRMAR_EXCLUSAO
ECHO:
ECHO -----------------------------------------------------------------------------------
ECHO         ATENCAO VOCE ESCOLHEU EXCLUIR TODOS OS FONTES NA PASTA SCRIPS DO GAME!
ECHO                     CERTIFIQUE-SE DE TER FEITO BACKUP!!!
ECHO -----------------------------------------------------------------------------------
ECHO:

PAUSE
:EXCLUIR_SEM_CONFIRMACAO
REM DEL /Q QUIET
DEL "%CAMINHO_DESTINO%*.KS"
DEL "%CAMINHO_DESTINO%*.KSm"
DEL "%CAMINHO_DESTINO%*.cfg"
DEL "%CAMINHO_DESTINO%boot\*.KS"
DEL "%CAMINHO_DESTINO%boot\*.KSm"
DEL "%CAMINHO_DESTINO%boot\*.cfg"
ECHO ARQUIVOS EXCLUIDOS...
IF %EXCLUSAO_AUTOMATICA%==True GOTO VOLTA_DA_EXCLUSAO_AUTOMATICA
ECHO -----------------------------------------------------------------------------------
ECHO:
PAUSE


GOTO MENU_PAUSE_COPIADOR

rem ----------------------------------------------------------------------------------------------------------------
:COMPARA_COPIA

REM COMPARANDO E COPIANDO:
set NOME_MODULO=%2

if "%NOME_MODULO%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_ORIGEM%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_DESTINO%"=="" GOTO ERRO_VARS_CONF

rem ATENÇÃO!!!  ARQUIVO_PATH_ORIGEM JÁ VAI INCLUIR AS ASPAS!!!
set ARQUIVO_PATH_ORIGEM="%CAMINHO_ORIGEM%%NOME_MODULO%"
set ARQUIVO_PATH_DESTINO="%CAMINHO_DESTINO%%NOME_MODULO%"

if not exist %ARQUIVO_PATH_ORIGEM% GOTO ERRO_FILE_ORG
if not exist %ARQUIVO_PATH_DESTINO% GOTO COPIA_SOBRESCREVE

FC %ARQUIVO_PATH_DESTINO% %ARQUIVO_PATH_ORIGEM% > nul

if [%errorlevel%]==[0] GOTO FIM
if [%errorlevel%]==[1] GOTO COPIA_SOBRESCREVE
ECHO ERRORLEVEL: %ERRORLEVEL% : DESCONHECIDO
REM ERL=0 NAO HA DIFERENCA ENTRE OS ARQUIVOS
REM ERL=1 OS ARQUIVOS SAO DIFERENTES

pause
GOTO FIM

rem ----------------------------------------------------------------------------------------------------------------
:COPIA_SOBRESCREVE
set FOI_DIFERENTE=True
echo arquivo: %2 apresenta diferencas: copiando...
COPY /Y %ARQUIVO_PATH_ORIGEM% %ARQUIVO_PATH_DESTINO%
ECHO                 COPY: ERRORLEVEL: %ERRORLEVEL%

if not exist %ARQUIVO_PATH_DESTINO% GOTO ERRO_COPY_SOBRECRV

REM TESTAR DEPOIS PRA VER SE A COPIA FOI BEM SUCEDIDA:
FC %ARQUIVO_PATH_DESTINO% %ARQUIVO_PATH_ORIGEM% > nul

if [%errorlevel%]==[0] echo COPY OK
if [%errorlevel%]==[1] GOTO ERRO_COPY 

GOTO FIM


rem ----------------------------------------------------------------------------------------------------------------
:ERRO_COPY
echo ERRO: FALHA NA COPIA DE: %ARQUIVO_PATH_ORIGEM%
echo           o arquivo em: %ARQUIVO_PATH_DESTINO% continua diferente!
echo .
pause 
GOTO FIM
:ERRO_FILE_ORG
echo ERRO FILE_ORG: FALTA ARQUIVO ORIGINAL: [%ARQUIVO_PATH_ORIGEM%]
echo .
pause 
GOTO FIM
:ERRO_COPY_SOBRECRV
echo ERRO: FALTA ARQUIVO NO DESTINO: NAO FOI COPIADO: [%ARQUIVO_PATH_DESTINO%]
echo .
pause 
GOTO FIM
:ERRO_VARS_CONF
echo ERRO: VARIAVEIS: NAO FORAM DEFINIDAS:
echo NOME_MODULO__:  %NOME_MODULO% 
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO%
pause 
GOTO ERRO_CONFIG
GOTO SETUP_CONF
:ERRO_CONFIG
echo:
echo:
echo ............... CP3: ERRO: VARIAVEIS: NAO FOI ENCONTRADO: INFORME MANUALMENTE:
:INSERIR_NOVOS_CAMINHOS
echo:
echo 			estes sao os caminhos salvos atualmente:
echo 	SLOT_1: [%NOME_CONFIG_SLOT_1%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO%
echo:
echo 	SLOT_2: [%NOME_CONFIG_SLOT_2%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM_2%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO_2%
echo:
echo 	SLOT_3: [%NOME_CONFIG_SLOT_3%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM_3%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO_3%
echo:
echo 	SLOT_4: [%NOME_CONFIG_SLOT_4%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM_4%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO_4%
echo:
echo 	SLOT_5: [%NOME_CONFIG_SLOT_5%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM_5%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO_5%
echo:
echo 	SLOT_6: [%NOME_CONFIG_SLOT_6%]
echo CAMINHO_ORIGEM__:  %CAMINHO_ORIGEM_6%
echo CAMINHO_DESTINO__:  %CAMINHO_DESTINO_6%
echo:
ECHO SLOT PADRAO: %SLOT_PADRAO%
echo:
:INSERIR_NOVOS_CAMINHOS_2
choice /c 123456 /m "Especifique o slot que deseja alterar:"
REM era mais facil detectar um erro: 0 ou 255 e setar para o SLOT=%ERRORLEVEL%
REM CTRL+BREAK or CTRL+C=0 erro=255
SET SLOT_CAMINHOS=%ERRORLEVEL%

if %SLOT_CAMINHOS% EQU 0 GOTO INSERIR_NOVOS_CAMINHOS_2
if %SLOT_CAMINHOS% EQU 255 GOTO INSERIR_NOVOS_CAMINHOS_2
set NOME_VAR_CAMINHO_O=CAMINHO_ORIGEM_%SLOT_CAMINHOS%
set NOME_VAR_CAMINHO_D=CAMINHO_DESTINO_%SLOT_CAMINHOS%
set SLT=
echo:
echo:

set NOME_MODULO=c3.ks
echo digite ou cole o caminho da origem(sem barra final, parenteses da merda tb):
set /P CAMINHO_ORIGEM=
if not exist "%CAMINHO_ORIGEM%\%NOME_MODULO%" (
	echo ERRO: nao existe o arquivo [%NOME_MODULO%] no caminho especificado: tente novamente.
	goto ERRO_CONFIG
)
SET CAMINHO_ORIGEM=%CAMINHO_ORIGEM%\

:ERRO_CONFIG_CAMINHO_DESTINO
echo digite ou cole o caminho DO DESTINO(sem barra final, parenteses da merda tb):
echo .     este caminho deve apontar para a pasta [game]\Ships\Script
set /P CAMINHO_DESTINO=

REM ----------- TESTE EXISTENCIA DA PASTA DESTINO: ----------------------
call :TESTE_DAS_PASTAS
if %PASTA_DESTINO_EXISTE%==False (
	echo ERRO: nao foi possivel usar o caminho [%PASTA_DESTINO_EXISTE%]: tente novamente.
	goto ERRO_CONFIG_CAMINHO_DESTINO
)
if %PASTA_ORIGEM_EXISTE%==False goto ERRO_CONFIG
if %PASTAS_EXISTEM%==False goto ERRO_CONFIG

REM if not exist "%CAMINHO_DESTINO%\%NOME_MODULO%" goto ERRO_CONFIG
REM ----------- FIM TESTE EXISTENCIA DA PASTA DESTINO: -------------------

SET CAMINHO_DESTINO=%CAMINHO_DESTINO%\

REM ------------ DEFINE NOME PARA ESSE SLOT ----------------------
:CONFIG_DEFINIR_NOME_SLOT
set NOME_CONFIG_SLOT=PASTAS NO SLOT %SLOT_CAMINHOS%
set nome_da_var_slot=NOME_CONFIG_SLOT_%SLOT_CAMINHOS%
CALL SET nome_atual_slot_teste=%%%nome_da_var_slot%%%
echo NOME ATUAL DO SLOT %SLOT_CAMINHOS%: %nome_atual_slot_teste%
set /p NOME_CONFIG_SLOT=Digite um nome para esse slot%SLOT_CAMINHOS%:
if [%NOME_CONFIG_SLOT%]==[] goto CONFIG_DEFINIR_NOME_SLOT
ECHO nome do slot sera: %NOME_CONFIG_SLOT%
echo:
REM ------------ DEFINE NOME PARA ESSE SLOT ----------------------


REM ------------ DEFINE SLOIT PADRAO ----------------------
choice /c SN /m "Config SLOT: [S]Incluir como padrao, [N]Manter atual:[%SLOT_PADRAO%]"
set CONFIG_SLOT=%ERRORLEVEL%
IF %CONFIG_SLOT% EQU 1 SET SLOT_CAMINHOS=%SLOT_CAMINHOS%
IF %CONFIG_SLOT% EQU 2 SET SLOT_CAMINHOS=%SLOT_PADRAO%
echo ... SLOT PADRAO SERA: [%SLOT_CAMINHOS%]
REM ------------ DEFINE SLOIT PADRAO ----------------------

REM ------------ PEGA INFORMACAO PARA EXCLUSAO AUTO ----------------------
choice /c SN /t %TEMPO_CHOICE% /d N /m "Config: [S]EXCLUIR AUTO, [N]NAO EXCL AUTO"
IF %ERRORLEVEL% EQU 1 SET OPC_EXCLIR_AUT=True
IF %ERRORLEVEL% EQU 2 SET OPC_EXCLIR_AUT=False
echo ... EXCLUIR AUTO ANTES DE COPIAR ESTA: [%OPC_EXCLIR_AUT%]
REM ------------ FIM PEGA INFORMACAO PARA EXCLUSAO AUTO -------------------
SET /P OPCAO_SLOT_GRAVAR=.          Confirme novamente o numero do slot[%SLOT_CAMINHOS%]:

ECHO:
ECHO .       FAZER : INCLUIR AQUI RESUMO DAS CONFIGS ADICIONADAS.
ECHO:


REM instrui o configurador para adicionar as linhas no final do arquivo de config:
rem CALL "%CAMINHO_ORIGEM%cp3_config2.bat SALVAR"

echo DEBUG: CP3: PONTO 3
echo set %NOME_VAR_CAMINHO_D%=%CAMINHO_DESTINO%>> %CAMINHO_ORIGEM%cp3_config3.bat
echo set %NOME_VAR_CAMINHO_O%=%CAMINHO_ORIGEM%>> %CAMINHO_ORIGEM%cp3_config3.bat
echo set EXCLUSAO_AUTOMATICA=%OPC_EXCLIR_AUT%>> %CAMINHO_ORIGEM%cp3_config3.bat
ECHO set %nome_da_var_slot%=%NOME_CONFIG_SLOT%>> %CAMINHO_ORIGEM%cp3_config3.bat
echo DEBUG: CP3: PONTO 4
echo set "SLOT_PADRAO=%OPCAO_SLOT_GRAVAR%">> %CAMINHO_ORIGEM%cp3_config3.bat
echo DEBUG: CP3: PONTO 4.1
REM teste_for.bat atualiza variavel: DATA_E_HORA
call "%CAMINHO_ORIGEM%_TUTORIALS\_CMD\teste_for.bat" DATA_HORA
echo DEBUG: CP3: PONTO 5
echo REM ATUALIZADO EM %DATA_E_HORA%
echo REM ATUALIZADO EM %DATA_E_HORA%>> %CAMINHO_ORIGEM%cp3_config3.bat

set NOVAS_CONFIGS=True
set TIPO_CONFIG=PADRAO
PROMPT=#
COLOR 08
REM FIRST BACK SECOND FORE 0=BLK 8=GRN 4=RED 7=WT F=BWT D=PURPLE
ECHO:
echo ..    CONFIGURACAO CONCLUIDA E GRAVADA EM %CONFIG_FILE_3%      ..
ECHO:
pause
echo   ---  VAI RECARREGAR CONFIGS.... 
goto SETUP_CONF_3

GOTO VERIFICA_VARS

rem --------------------------------------------------------------------------------------------------
:TESTE_DAS_PASTAS
rem chamar como uma subrotina: call :TESTE_DAS_PASTAS parametros
rem TERMINA O PROGRAMA: VAI PARA EOF
set PASTAS_EXISTEM=False
set PASTA_ORIGEM_EXISTE=False
set PASTA_DESTINO_EXISTE=False
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 1

rem testar os VERDADEIROS PRIMEIRO:
IF exist "%CAMINHO_ORIGEM%cp3_test.bat" (set PASTAS_EXISTEM=True
set PASTA_ORIGEM_EXISTE=True
)
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 2

REM TESTE DO DESTINO: TESTAR GRAVAÇÃO
REM  ATENÇÃO : ARQUIVO_TESTE_C3BAT JÁ VAI INCLUIR AS ASPAS
set ARQUIVO_TESTE_C3BAT="%CAMINHO_DESTINO%teste_c3bat.teste"
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS : ver se existe: %ARQUIVO_TESTE_C3BAT%
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 3

if exist %ARQUIVO_TESTE_C3BAT% del %ARQUIVO_TESTE_C3BAT%
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 4
ECHO test > %ARQUIVO_TESTE_C3BAT%
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 5

if exist %ARQUIVO_TESTE_C3BAT% ( SET PASTAS_EXISTEM=True
set PASTA_DESTINO_EXISTE=True
)
echo:
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 6

REM --------- FIM : TESTE DO DESTINO: TESTAR GRAVAÇÃO

rem testar os falsos no final:
IF NOT exist "%CAMINHO_ORIGEM%cp3_test.bat" set PASTAS_EXISTEM=False
IF NOT exist "%CAMINHO_ORIGEM%cp3_test.bat" set PASTA_ORIGEM_EXISTE=False
IF NOT exist "%CAMINHO_ORIGEM%cp3_test.bat" echo Nao existe ORIGEM: %CAMINHO_ORIGEM%cp3_test.bat

if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 7

if NOT exist %ARQUIVO_TESTE_C3BAT% set PASTA_DESTINO_EXISTE=False

IF %PASTA_DESTINO_EXISTE%==False ( SET PASTAS_EXISTEM=False
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 8

echo Nao existe: %CAMINHO_DESTINO%
echo TESTE: Nao existe: %ARQUIVO_TESTE_C3BAT%
ECHO Verifique se eh possivel gravar no local
rem aqui ja ocorreu o erro...
) 

if exist %ARQUIVO_TESTE_C3BAT% del %ARQUIVO_TESTE_C3BAT%
if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO 9

if %DEBUG_ECHO%=="debug" echo DEBUG: CP3: :TESTE_DAS_PASTAS PONTO FINAL (GOTO EOF)
if %DEBUG_PAUSE%=="pause" pause

goto :eof
rem ----------------------------------------------------------------------------------------------------------------

rem ----------------------------------------------------------------------------------------------------------------

:MENU_CONFIG_AVANCADO

ECHO MENU_CONFIG_AVANCADO


SET DEF_OP_CHOICE=6
rem echo. imprime linha em branco

ECHO:
echo OPCOES DISPONIVEIS - [MENU_CONFIG_AVANCADO]
ECHO:
echo  1. Abrir menu locais salvos
echo  2. Configurar espera com choice para nul [TESTE ISSO]
echo  3. 
echo  4. 
echo  5. RECONFIGURAR MANUAL [CAMINHOS]
echo ^>6. VOLTAR [t/out 30 seg]
echo  7. ABRIR PASTAS
echo  8. 
echo  9. SAIR
echo  0. pausa

echo:
rem https://www.robvanderwoude.com/choice.php
choice /c 1234567890 /t %TEMPO_MENU_CHOICE% /d %DEF_OP_CHOICE% /m "Escolha uma opcao (nao precisa enter)"
SET OPCAO_ESCOLHIDA_CHOICE=%ERRORLEVEL%
ECHO OPCAO_ESCOLHIDA_CHOICE: %OPCAO_ESCOLHIDA_CHOICE% 
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 1 CALL ESCOLHA_CONFIG
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 2 goto teste_choice_para_nul
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 3 goto NAO_IMPLEMENTADO_av
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 4 goto NAO_IMPLEMENTADO_av
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 5 goto INSERIR_NOVOS_CAMINHOS
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 6 goto MENU_PAUSE_COPIADOR
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 7 goto ABRIR_PASTAS
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 8 goto NAO_IMPLEMENTADO_av
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 9 goto FIM

ECHO  para debug:
pause

goto MENU_CONFIG_AVANCADO
:NAO_IMPLEMENTADO_av
ECHO:
ECHO NAO IMPLEMENTADO!
ECHO:
PAUSE
GOTO MENU_CONFIG_AVANCADO
:teste_choice_para_nul
set SEGUNDOS_CHOICE_NUL=5
echo:
echo este eh um teste de choice para nul... espere %SEGUNDOS_CHOICE_NUL% segundos...
choice /c y /t %SEGUNDOS_CHOICE_NUL% /d y > nul
GOTO MENU_CONFIG_AVANCADO

rem ----------------------------------------------------------------------------------------------------------------

rem ----------------------------------------------------------------------------------------------------------------
:ATUALIZA_VARS_CALLCONF

echo DEBUG: CP3: PONTO 200

ECHO:
ECHO CONTINUAR PROBLEMA DO SET AQUI:
set NOME_DA_VAR=CAMINHO_ORIGEM_%SLOT_PADRAO%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_ORIGEM=%%%NOME_DA_VAR%%%
PAUSE
set NOME_DA_VAR=CAMINHO_DESTINO_%SLOT_PADRAO%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_DESTINO=%%%NOME_DA_VAR%%%
echo DEBUG: CP3: PONTO 201
PAUSE
GOTO :eof
rem ----------------------------------------------------------------------------------------------------------------


:FIM_PAUSA
ECHO:
echo .............................................
echo ..                                         ..
echo ..     SCRIPT FINALIZADO PELO USUARIO      ..
echo ..                                         ..
echo .............................................
ECHO:
PAUSE
:FIM
REM OU USE eof
