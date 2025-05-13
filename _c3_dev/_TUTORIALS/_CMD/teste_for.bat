@ECHO OFF
rem _TUTORIALS\_CMD\teste_for.bat DATA_HORA
REM TESTE COMANDO FOR

IF [%1]==[DATA_HORA] GOTO RETORNA_VARIAVEL_COM_DATA_E_HORA 


SET ARQUIVO_TESTE=arquivo_teste.txt
echo:
echo  ira testar o arquivo: %ARQUIVO_TESTE%
echo:
echo ................ incluindo linha com a data:
date /t >%ARQUIVO_TESTE%


echo:
echo ................ lendo numero de linhas no arquivo:
SET count=0
FOR /f "delims=" %%G in (%ARQUIVO_TESTE%) DO (
call :sub_rotina_contadora "%%G")

echo:
echo ................ %count% linhas lidas do arquivo

echo:
echo ................. imprimindo somente a ultima linha lida:
set /a linhas_pular_ler=count-1
rem da problema quando tem uma linha so: por causa do zero sera??

IF %linhas_pular_ler% GEQ 1 (
ECHO numero de linhas maior ou igual a 1:[%linhas_pular_ler%]
FOR /f "skip=%linhas_pular_ler% delims=" %%G in (%ARQUIVO_TESTE%) DO (echo %%G
SET DATA_PEGADA=%%G)
) ELSE (
ECHO numero de linhas menor que 1:[%linhas_pular_ler%]
FOR /f "delims=" %%G in (%ARQUIVO_TESTE%) DO (echo %%G
SET DATA_PEGADA=%%G)
)

echo:
echo ................. imprimindo a hora:
time /t >%ARQUIVO_TESTE%
FOR /f "delims=" %%G in (%ARQUIVO_TESTE%) DO (echo %%G
SET HORA_PEGADA=%%G)



echo:
echo .................. imprimindo a data com informacao pegada
echo DATA PEGADA: %DATA_PEGADA% HORA PEGADA: %HORA_PEGADA%
pause

goto :eof


SET count=1
FOR /f "tokens=*" %%G IN ('dir /b') DO (call :subroutine "%%G")
GOTO :eof


 Create a set of 26 folders, one for each letter of the alphabet:

FOR %%G IN (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z) DO (md C:\demo\%%G)


:sub_rotina_contadora
 set /a count+=1
 echo %count%:%1
 GOTO :eof

:RETORNA_VARIAVEL_COM_DATA_E_HORA
SET ARQUIVO_TESTE=arquivo_teste.txt
date /t >%ARQUIVO_TESTE%
FOR /f "delims=" %%G in (%ARQUIVO_TESTE%) DO (
SET DATA_PEGADA=%%G)
time /t >%ARQUIVO_TESTE%
FOR /f "delims=" %%G in (%ARQUIVO_TESTE%) DO (
SET HORA_PEGADA=%%G)
SET DATA_E_HORA=%DATA_PEGADA% %HORA_PEGADA%
IF EXIST arquivo_teste.txt DEL arquivo_teste.txt
GOTO FIM




:fim

