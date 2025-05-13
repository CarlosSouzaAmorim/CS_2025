REM @echo off
rem cp3_config2.bat
rem NAO ESQUECA DA \ DEPOIS DA PASTA

rem help: https://ss64.com/nt/echo.html

if %DEBUG_ECHO%=="debug" echo DEBUG: config 2 iniciado
rem set OLD_A=%NOME_ARQUIVO%
set OLD_O=%CAMINHO_ORIGEM%
set OLD_D=%CAMINHO_DESTINO%

REM SET HDN2 EM NOTE POS SEM TELA W10
REM PROCESSOR_ARCHITECTURE=AMD64
REM PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 23 Stepping 10, GenuineIntel
REM PROCESSOR_LEVEL=6
REM PROCESSOR_REVISION=170a

REM SET HDNBIG EM NOTE BIG W7
REM PROCESSOR_ARCHITECTURE=AMD64
REM PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 42 Stepping 7, GenuineIntel
REM PROCESSOR_LEVEL=6
REM PROCESSOR_REVISION=2a07

REM padrao
SET ESPERAR_PAUSE=False
SET VERIFICA_E_SAI=False

rem LOGONSERVER=\\NOTE-POS-HDN2
rem if "%PROCESSOR_IDENTIFIER%"=="Intel64 Family 6 Model 23 Stepping 10, GenuineIntel" set ESPERAR_PAUSE=True
rem if "%PROCESSOR_IDENTIFIER%"=="Intel64 Family 6 Model 23 Stepping 10, GenuineIntel" set VERIFICA_E_SAI=True
if [%LOGONSERVER%]==[\\NOTE-POS-HDN2] (
	set ESPERAR_PAUSE=True
	set VERIFICA_E_SAI=True
	set MOSTRA_CHOICE=False
)

REM porque o loop eh agressivo demais e desliga note pos

if [%1]==[ATUALIZAR] goto MENU_ATUALIZA_CONFIG
if [%1]==[SALVAR] goto SALVAR_CONFIGS
if [%1]==[ESCOLHA_CONFIG] goto ESCOLHA_ENTRE_AS_CONFIGS

rem AQUI SELECIONA QUAL CONFIGURAÇÃO VALE:
REM GOTO C3
rem GOTO C3_W10
rem GOTO C3_EDIT_HDN1_PLAY_HDN2
REM //GOTO C3_EDIT_HDN2_PLAY_HDNbig_kos
REM GOTO C3_EDIT_HDN2_PLAY_HDNbig_RO
rem GOTO C3_EDIT_HDN2_PLAY_HDNbig_MH comentado em 30 ago 2019
REM goto C3_EDIT_HDN2novo_PLAY_HDNlil_171
REM goto C3_EDIT_HDN2novo_PLAY_HDN3_120_LINUX
rem goto C3_W10_NET
rem goto W10_TO_UB16
rem GOTO PART
rem GOTO FILES
GOTO FIM_CONFIG



REM --------------------------------------------------------------------------------------
:MENU_ATUALIZA_CONFIG
CALL "%CONFIG_NOVO_FONTE%\cp3_config3.bat"
echo:
echo configs atuais:
echo PASTA ORIGEM :%CAMINHO_ORIGEM%
echo PASTA DESTINO:%CAMINHO_DESTINO%
echo:
if NOT exist %CONF_FILE% ECHO NAO EXISTE ARQUIVO DE CONFIGURAÇÃO: %CONF_FILE%
if NOT exist %CONF_FILE% GOTO ATUALIZA_CONFIG

REM GOTO FIM_CONFIG
REM Nõa ha necessidade de abortar aqui: pode-se indicar o local correto
:ESCOLHA_ENTRE_AS_CONFIGS
SET OPCOA_PADRAO_CHOICE=e
rem echo. imprime linha em branco

echo OPCOES DISPONIVEIS  -  [ESCOLHA_ENTRE_AS_CONFIGS]
ECHO.
echo  1. %NOME_CONFIG_SLOT_1%
echo  2. %NOME_CONFIG_SLOT_2%
echo  3. %NOME_CONFIG_SLOT_3%
echo  4. %NOME_CONFIG_SLOT_4%
echo  5. %NOME_CONFIG_SLOT_5%
echo  6. %NOME_CONFIG_SLOT_6%
echo  7. %NOME_CONFIG_SLOT_7%
echo  8. %NOME_CONFIG_SLOT_8%
echo  9. %NOME_CONFIG_SLOT_9%
echo  a. %NOME_CONFIG_SLOT_a%
echo  b. 
echo  c. 
echo  d. 
echo ^>e. MANTER ATUAIS [t/out 30seg]=%OPCOA_PADRAO_CHOICE%
echo  f. INSERIR NOVOS LOCAIS
echo.

choice /c 123456789abcdef /t 30 /d %OPCOA_PADRAO_CHOICE% /m Escolha uma opcao (nao precisa enter)
SET OPCAO_ESCOLHIDA_CHOICE=%ERRORLEVEL%
ECHO OPCAO_ESCOLHIDA_CHOICE: %OPCAO_ESCOLHIDA_CHOICE% 
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 1 set SLOT_PADRAO=1
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 2 set SLOT_PADRAO=2
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 14 goto FIM_CONFIG
IF %OPCAO_ESCOLHIDA_CHOICE% EQU 15 goto ATUALIZA_CONFIG


ECHO:
ECHO CONTINUAR PROBLEMA DO SET AQUI:
set NOME_DA_VAR=CAMINHO_ORIGEM_%SLOT_padrao%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_ORIGEM=%%%NOME_DA_VAR%%%
PAUSE
set NOME_DA_VAR=CAMINHO_DESTINO_%SLOT_padrao%
echo    DEBUG: NOME DA VAR: %NOME_DA_VAR%
CALL SET CAMINHO_DESTINO=%%%NOME_DA_VAR%%%

ECHO:
echo PASTA ORIGEM :%CAMINHO_ORIGEM%
echo PASTA DESTINO:%CAMINHO_DESTINO%
ECHO:

echo FAZER: CONFIGURACAO NAO VERIFICADA...
ECHO:
PAUSE

goto FIM_CONFIG

echo FAZER: CONFIGURACAO NAO ESPECIFICADA...

:ATUALIZA_CONFIG
:ATUALIZA_CONFIG_FONTE
echo.
SET CONFIG_NOVO_FONTE=NADA
echo _DIGITE LOCAL FONTE_(sem barra no final, parenteses da merda tb):
SET /P CONFIG_NOVO_FONTE=
IF [%CONFIG_NOVO_FONTE%]==[NADA] GOTO ATUALIZA_CONFIG_FONTE
IF [%CONFIG_NOVO_FONTE%]==[] GOTO ATUALIZA_CONFIG_FONTE
IF exist %CONFIG_NOVO_FONTE%\cp3_test.bat goto ATUALIZA_CONFIG_DESTINO
echo Nao existe: %CONFIG_NOVO_FONTE%\cp3_test.bat goto ATUALIZA_CONFIG_FONTE
rem aqui ja ocorreu o erro...gotoATUALIZA_CONFIG_FONTE
goto ATUALIZA_CONFIG_FONTE

:ATUALIZA_CONFIG_DESTINO

SET CONFIG_NOVO_DESTINO=NADA
echo _DIGITE LOCAL DESTINO_(sem barra no final, parenteses da merda tb):
SET /P CONFIG_NOVO_DESTINO=
IF [%CONFIG_NOVO_DESTINO%]==[NADA] GOTO ATUALIZA_CONFIG_DESTINO
IF [%CONFIG_NOVO_DESTINO%]==[] GOTO ATUALIZA_CONFIG_FONTE

set ARQUIVO_TESTE_C3BAT=%CONFIG_NOVO_DESTINO%\teste_c3bat.teste
if exist %ARQUIVO_TESTE_C3BAT% del %ARQUIVO_TESTE_C3BAT%
ECHO test > %ARQUIVO_TESTE_C3BAT%

if exist %ARQUIVO_TESTE_C3BAT% goto CONFIG_INSERIDAS_COM_SUCESSO
echo Nao existe: %CONFIG_NOVO_DESTINO%
echo TESTE: Nao existe: %ARQUIVO_TESTE_C3BAT%
ECHO Verifique se eh possivel gravar no local
echo.
rem aqui ja ocorreu o erro...gotoATUALIZA_CONFIG_FONTE
goto ATUALIZA_CONFIG_DESTINO

:CONFIG_INSERIDAS_COM_SUCESSO
if exist %ARQUIVO_TESTE_C3BAT% del %ARQUIVO_TESTE_C3BAT%

:SALVAR_CONFIGS
echo set CAMINHO_DESTINO=%CONFIG_NOVO_DESTINO%\>> %CONFIG_NOVO_FONTE%\cp3_config3.bat
echo set CAMINHO_ORIGEM=%CONFIG_NOVO_FONTE%\>> %CONFIG_NOVO_FONTE%\cp3_config3.bat
call "%CONFIG_NOVO_FONTE%\_TUTORIALS\_CMD\teste_for.bat" DATA_HORA
echo REM ATUALIZADO EM %DATA_E_HORA%
echo REM ATUALIZADO EM %DATA_E_HORA%>> %CONFIG_NOVO_FONTE%\cp3_config3.bat

CALL "%CONFIG_NOVO_FONTE%\cp3_config3.bat"

REM %CONF_FILE%




GOTO FIM_CONFIG
REM --------------------------------------------------------------------------------------


REM --------------------------------------------------------------------------------------
:ESCOLHA_OPCAO
rem executa outro comando se o primeiro falhar: ||
Set /P _dept=ESCOLHA UMA OPCAO || Set _dept=NAO_DIGITOU_NADA
If "%_dept%"=="NAO_DIGITOU_NADA" goto ESCOLHA_OPCAO
If /i "%_dept%"=="finance" goto sub_finance
If /i "%_dept%"=="hr" goto sub_hr

REM EOF VAI PARA O FIM DO ARQUIVO
goto:eof

:sub_finance
echo You chose the finance dept
goto:eof

:sub_hr
echo You chose the hr dept
goto:eof

:sub_error
echo Nothing was chosen
REM The Prompt string can be empty. If the user does not enter anything (just presses return)
REM  then the variable will be unchanged and an errorlevel will be set to 1.
REM --------------------------------------------------------------------------------------

:W10_TO_UB16

REM  \\192.168.2.2\KSP12
REM Z:\Ships\Script
REM DESTE COMPUTADOR
set CAMINHO_ORIGEM=C:\GOG Games\_c3_dev\
REM PARA SAM NA REDE:
set CAMINHO_DESTINO=Z:\Ships\Script\

GOTO FIM_CONFIG



:C3
rem PROGRAMA LOOP COPIA AUTO NOVO ARQ C3
rem set NOME_ARQUIVO=c3.ks
set CAMINHO_ORIGEM=\\Note-sim-w10\gog games\
set CAMINHO_DESTINO=C:\KSP 1.2.0.1586\Ships\Script\
GOTO FIM_CONFIG

:C3_EDIT_HDN1_PLAY_HDN2
rem NAO ESQUECA DA \ DEPOIS DA PASTA
set CAMINHO_ORIGEM=\\NOTE-SIM-W10\GOG Games\_c3_dev\
set CAMINHO_DESTINO=\\NOTE-SIM-W10\GOG Games\KSP 1.2.2\Ships\Script\
GOTO FIM_CONFIG

:C3_EDIT_HDN2_PLAY_HDNbig
set CAMINHO_ORIGEM=D:\GOG Games\_c3_dev\
set CAMINHO_DESTINO=\\USER-PC\Users\User\Desktop\KSP 1.2.2\Ships\Script\
GOTO FIM_CONFIG

:C3_EDIT_HDN2_PLAY_HDNbig_MH
set CAMINHO_ORIGEM=D:\GOG Games\_c3_dev\
set CAMINHO_DESTINO=\\USER-PC\_n_w7_2_big\Kerbal Space Program Making History\Ships\Script\
GOTO FIM_CONFIG

:C3_EDIT_HDN2novo_PLAY_HDNlil_171
rem NAO ESQUECA DA \ DEPOIS DA PASTA
set CAMINHO_ORIGEM=C:\_O_HDN2\OneDrive\_GAMES\KSP\_c3_dev\
set CAMINHO_DESTINO=\\HDNLIL-W10-PC\ksp\Ships\Script\

GOTO FIM_CONFIG

:C3_EDIT_HDN2novo_PLAY_HDNlil_142
rem NAO ESQUECA DA \ DEPOIS DA PASTA
set CAMINHO_ORIGEM=C:\_O_HDN2\OneDrive\_GAMES\KSP\_c3_dev\
set CAMINHO_DESTINO=\\Hdnlil-w10-pc\hdnlil\Users\Carlos Amorim\Desktop\Kerbal Space Program Making History 1.4.2.2110\Ships\Script\

GOTO FIM_CONFIG




:C3_W10
rem PROGRAMA LOOP COPIA AUTO NOVO ARQ C3 TESTE NA HDN2 W10
rem set NOME_ARQUIVO=c3.ks
rem set CAMINHO_ORIGEM=\\Note-sim-w10\gog games\
set CAMINHO_ORIGEM=C:\GOG Games\_c3_dev\
REM camenho_hdn3 eh o destino:
set CAMINHO_DESTINO=C:\GOG Games\KSP 1.2.0.1586\Ships\Script\
GOTO FIM_CONFIG

rem PARA RODAR NO NOTE COM W10
rem SET CONF_FILE="C:\GOG Games\_c3_dev\cp3_config.bat"
rem PARA RODAR NO NOTE COM XP
rem "\\Note-sim-w10\gog games\_c3_dev\cp3_config.bat"

:C3_W10_NET
REM DESTE COMPUTADOR
set CAMINHO_ORIGEM=C:\GOG Games\_c3_dev\
REM PARA SAM NA REDE:
set CAMINHO_DESTINO=\\PC-SAM-W10\GOG Games\1.2\Ships\Script\

GOTO FIM_CONFIG



:FILES
rem PARA O FILES test:
set NOME_ARQUIVO=files_1.ks
set CAMINHO_ORIGEM=\\Note-sim-w10\gog games\_c3_dev\
set CAMINHO_DESTINO=C:\KSP 1.2.0.1586\Ships\Script\
GOTO FIM_CONFIG

:PART
rem PARA O part test:
set NOME_ARQUIVO=part.ks
set CAMINHO_ORIGEM=\\Note-sim-w10\gog games\_c3_dev\
set CAMINHO_DESTINO=C:\KSP 1.2.0.1586\Ships\Script\
GOTO FIM_CONFIG


:FIM_CONFIG
if %DEBUG_ECHO%=="debug" echo DEBUG: FIM config 2
PROMPT=#
COLOR 08
REM FIRST BACK SECOND FORE 0=BLK 8=GRN 4=RED 7=WT F=BWT D=PURPLE

REM if not "%NOME_ARQUIVO%"=="%OLD_A%" set NOVAS_CONFIGS=True
if not "%CAMINHO_ORIGEM%"=="%OLD_O%" set NOVAS_CONFIGS=True
if not "%CAMINHO_DESTINO%"=="%OLD_D%" set NOVAS_CONFIGS=True
