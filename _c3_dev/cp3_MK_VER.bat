@echo off

if [%1]==[] goto SET_P_VERSAO
SET VERSAO_SALVAR=%1
GOTO CRIA_PASTA_VERSAO

:VERSAO_JA_EXISTE
ECHO %VERSAO_SALVAR% JA EXISTE
pause
GOTO SET_P_VERSAO

:SET_P_VERSAO
REM LISTA DIRETORIOS COMECADOS EM V
DIR /A:D V*
ECHO:
echo     ... evite parenteses no nome
set /p VERSAO_SALVAR=__digite a versao atual:_
if [%VERSAO_SALVAR%]==[] goto SET_P_VERSAO


:CRIA_PASTA_VERSAO

IF EXIST %VERSAO_SALVAR% GOTO VERSAO_JA_EXISTE
IF NOT EXIST %VERSAO_SALVAR% mkdir %VERSAO_SALVAR%
IF NOT EXIST %VERSAO_SALVAR% GOTO ERRO_CRIA_SALVAR
IF EXIST %VERSAO_SALVAR% GOTO VERSAO_CRIADA

:ERRO_CRIA_SALVAR
ECHO ERRO: NAO FOI POSSIVEL CRIAR PASTA: %VERSAO_SALVAR%
pause > nul
GOTO SET_P_VERSAO

:VERSAO_CRIADA

COPY c3.ks %VERSAO_SALVAR%

COPY c3_scr_msg.ks %VERSAO_SALVAR%
COPY c3_scr_tela.ks %VERSAO_SALVAR%
COPY c3_sup_func.ks %VERSAO_SALVAR%
COPY c3_init_vars.ks %VERSAO_SALVAR%
COPY c3_menu.ks %VERSAO_SALVAR%

COPY c3_para_testes.ks %VERSAO_SALVAR%
COPY c3_pid_node.ks %VERSAO_SALVAR%

COPY c3_files.ks %VERSAO_SALVAR%
COPY c3_utils.ks %VERSAO_SALVAR%
COPY c3_ship.ks %VERSAO_SALVAR% 
COPY c3_term.ks %VERSAO_SALVAR%
COPY c3_cmd.ks %VERSAO_SALVAR%
COPY c3_song.ks %VERSAO_SALVAR%
COPY c3_ship_cfg.ks %VERSAO_SALVAR%
COPY cp.ks %VERSAO_SALVAR%
COPY boot\c3_autorun2.ks %VERSAO_SALVAR%

COPY _ARQUIVOS_DO_PROJETO.txt %VERSAO_SALVAR%
COPY _LEIAME.txt %VERSAO_SALVAR%
COPY _fazer.txt %VERSAO_SALVAR%
COPY _edicoes.txt %VERSAO_SALVAR%


COPY cp3_test.bat  %VERSAO_SALVAR%
COPY cp3_config2.bat %VERSAO_SALVAR%
COPY cp3_MK_VER.bat %VERSAO_SALVAR%
COPY cp3_config3.bat %VERSAO_SALVAR%

PAUSE

GOTO FIM

PAUSE
GOTO FIM
rem ----------------------------------------------------------------------------------------------------------------
SET CONF_FILE="C:\_O_HDN2\OneDrive\_GAMES\KSP\_c3_dev\cp3_config2.bat"
SET COPY_PROG="C:\_O_HDN2\OneDrive\_GAMES\KSP\_c3_dev\cp3_test.bat"

set TIPO_CONFIG=FILE

if [%1]==[COMPARA_COPIA] goto COMPARA_COPIA

goto SETUP_CONF
rem ----------------------------------------------------------------------------------------------------------------
:SETUP_CONF
echo Carregando configs on [%CONF_FILE%]....
if not exist %CONF_FILE% GOTO ERRO_CONFIG
call %CONF_FILE%

rem ----------------------------------------------------------------------------------------------------------------
:VERIFICA_VARS
IF %NOVAS_CONFIGS%==True ECHO Novas configs carregadas para:
REM echo __:  %NOME_MODULO% 
echo PASTA ORIGEM :%CAMINHO_ORIGEM%
echo PASTA DESTINO:%CAMINHO_DESTINO%
REM pause > nul
set NOVAS_CONFIGS=False

rem PROGRAMA LOOP COPIA AUTO NOVO ARQ DE KOS
REM if "%NOME_MODULO%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_ORIGEM%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_DESTINO%"=="" GOTO ERRO_VARS_CONF
echo .

ECHO Aguardando diferencas...
set FOI_DIFERENTE=False
goto LOOP_ARQUIVOS

rem ----------------------------------------------------------------------------------------------------------------
:LOOP_ARQUIVOS


REM somente para atualizar as configs e carregar outros arquivos esporadicamente
IF %TIPO_CONFIG%==FILE call %CONF_FILE%
if %NOVAS_CONFIGS%==True GOTO VERIFICA_VARS

call %COPY_PROG% COMPARA_COPIA c3.ks
call %COPY_PROG% COMPARA_COPIA c3_scr_msg.ks
call %COPY_PROG% COMPARA_COPIA c3_sup_func.ks
call %COPY_PROG% COMPARA_COPIA c3_init_vars.ks
call %COPY_PROG% COMPARA_COPIA c3_menu.ks
call %COPY_PROG% COMPARA_COPIA c3_files.ks
call %COPY_PROG% COMPARA_COPIA c3_utils.ks
call %COPY_PROG% COMPARA_COPIA c3_ship.ks
call %COPY_PROG% COMPARA_COPIA c3_term.ks
call %COPY_PROG% COMPARA_COPIA c3_cmd.ks
call %COPY_PROG% COMPARA_COPIA c3_song.ks
call %COPY_PROG% COMPARA_COPIA c3_ship_cfg.ks

call %COPY_PROG% COMPARA_COPIA cp.ks

if %FOI_DIFERENTE%==True ECHO Aguardando diferencas...
if %FOI_DIFERENTE%==True TIME /T
if %FOI_DIFERENTE%==True echo --------------------------------------------------------------
set FOI_DIFERENTE=False

if %ESPERAR_PAUSE%==True PAUSE

goto LOOP_ARQUIVOS


ECHO TERMINOU.
PAUSE > NUL
GOTO FIM


rem ----------------------------------------------------------------------------------------------------------------
:COMPARA_COPIA

REM COMPARANDO E COPIANDO:
set NOME_MODULO=%2

if "%NOME_MODULO%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_ORIGEM%"=="" GOTO ERRO_VARS_CONF
if "%CAMINHO_DESTINO%"=="" GOTO ERRO_VARS_CONF

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
echo ERRO: FALTA ARQUIVO ORIGINAL: [%ARQUIVO_PATH_ORIGEM%]
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
GOTO SETUP_CONF
:ERRO_CONFIG
echo ERRO: VARIAVEIS: NAO FOI ENCONTRADO: Carregando defaults:
set NOME_MODULO=c3.ks
set CAMINHO_ORIGEM=\\Note-sim-w10\gog games\
set CAMINHO_DESTINO=C:\KSP 1.2.0.1586\Ships\Script\
set NOVAS_CONFIGS=True
set TIPO_CONFIG=PADRAO
PROMPT=#
COLOR 08
REM FIRST BACK SECOND FORE 0=BLK 8=GRN 4=RED 7=WT F=BWT D=PURPLE
pause 
GOTO VERIFICA_VARS


rem ----------------------------------------------------------------------------------------------------------------


rem ----------------------------------------------------------------------------------------------------------------
:FIM
