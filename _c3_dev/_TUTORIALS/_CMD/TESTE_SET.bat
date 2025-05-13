@ECHO OFF


SET CAMINHO_ORIGEM_1=caminho 1
SET CAMINHO_ORIGEM_2=caminho 2
SET CAMINHO_ORIGEM_3=caminho 13
SET CAMINHO_ORIGEM_4=caminho 4
SET CAMINHO_ORIGEM_5=caminho 5
SET CAMINHO_ORIGEM_6=caminho 6
SET CAMINHO_ORIGEM_7=caminho 7

ECHO DEFININDO NOME DA VAR:
ECHO:
SET /P SLOT=DEFINA O NUMERO DO SLOT
ECHO:
set NOME_DA_VAR=CAMINHO_ORIGEM_%SLOT%
echo preparando o nome da var:%NOME_DA_VAR%
CALL SET RESULTADO=%%%NOME_DA_VAR%%%
ECHO:
echo pegando o valor desse slot:
echo SLOT:%SLOT% : %RESULTADO%
ECHO:
ECHO:
ECHO:



PAUSE 

GOTO EOF
REM ss64.com/nt/call.html
@Echo off
 SETLOCAL
 set _server=frodo
 set _var=_server
 CALL SET _result=%%%_var%%%
 echo %_result%


set CAMINHO_ORIGEM=%%CAMINHO_ORIGEM_%%SLOT%%

