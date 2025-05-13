@LAZYGLOBAL OFF.
//cp.ks
// 4 funcoes: 686 linhas
// 7 funcoes: 856 linhas em 8/12/2020
//recompila

parameter parametro_para_c3 is ""   .
parameter parametro_para_comp is "" .//permite ativar compilação forçada dos arquivos em caso de crash
parameter parametro_para_comp_debug is false .//nao usado
parameter parametro_para_comp_pausa is false .//nao usado
parameter parametro_para_comp_wait 	is 0.2 .

print "CP: parametros:" + " [" +parametro_para_c3+ "]" + " [" +parametro_para_comp+ "]" 
						+ " [" +parametro_para_comp_debug+ "]" + " [" +parametro_para_comp_pausa+ "]" + " [" +parametro_para_comp_wait+ "]".

///quando inicia no 1:/ e chama as dependencias ele nao as encontra: mermo chamando com runpath("0:/cp").
local drive_origem	        is 0    .//PRECISA SER UM SCALAR
switch to drive_origem.

//runoncepath("1:/c3_init_vars.ksm").
//runoncepath("1:/c3_files.ksm").//isso ta gerando uns erro maroto: PQ se eu carrego aqui ele nao devia carregar novamente no c3
//mesmo assim esta dizendo que o label test_volume(do files) ja existe?
//suspeito que eh porque o compilador diferencia entre .ks e .ksm e nesse(cp) ele chama um .ks (que eh bom pq eu posso editar)
//pode ser mais chato ainda e tem a ver com os path() dos arquivos: ai fudeo

//uses:
//vars:
//ACAO_FILE_SIZE_GET
//functions:
//TEST_SIZE_FILE
//compile_MOTHAFOCA

global FILE_DEBUGLOG_cp 	is "0:/debugcp.log"		.//se o log vai ser geral no 0:/ então especificar a nave
// -----------  POR CAUSA DA POTARIA ----------------------------------
global ACAO_FILE_SIZE_GET	is "get_size"			.
global ACAO_FILE_SIZE_TEST	is "test"				.//boa sorte explicando isso

global	file_KSM_ext		is "ksm"				.//sem o ponto mesmo
// -----------  POR CAUSA DA POTARIA ----------------------------------

local delay_tmp     		is 0.001				.//verificar onde eh usado
local delay_inicio  		is 0.02					.//usado apos as msgs inicio e antes de rodar o c3
local delay_run_c3			is 0.001				.//usado antes de rodar o c3

//definição da config de esperar por wait antes de rodar o c3 compilado:
	//print "parametro_para_comp_wait: ["+parametro_para_comp_wait+"]".
	//print "parametro_para_comp_wait:typename "+parametro_para_comp_wait:typename.
	if parametro_para_comp_wait:istype("String"){
		//print "parametro_para_comp_wait eh uma string ".
		if (parametro_para_comp_wait >0){
			set delay_run_c3 to parametro_para_comp_wait:tonumber(0.0) * 1.01.
			//wait CONVERTE_STR_TO_NUM(parametro_para_comp_wait).
		}
	}.
	if parametro_para_comp_wait:istype("Scalar"){
		//print "parametro_para_comp_wait eh um scalar ".
		set delay_run_c3 to parametro_para_comp_wait * 1.01.
	}.

local config_path 			is "0:/fonts.cfg"		.
local config_back 			is "0:/fonts_back.cfg"	.
local drive_destino			is 1					.//PRECISA SER UM SCALAR2
local MODULO_FINAL_EXECUTAR	is "c3.ks"				.//c3.ks".

global MODO_COMPILE_ATIVO	is False.//aqui nao é onde se define o padrão: fica no if adiante
global MODO_COMPILE_FORCE	is False.//aqui nao é onde se define o padrão: fica no if adiante
//definição da config de COMPILAR antes de rodar o c3:
if (parametro_para_c3 = "modo_compile_off") {set MODO_COMPILE_ATIVO	to False.}
else {set MODO_COMPILE_ATIVO	to True			.}
if (parametro_para_comp = "modo_compile_force_on") {set MODO_COMPILE_FORCE	to True.}
else {set MODO_COMPILE_FORCE	to False		.}

local path_root_origem		is drive_origem 	+ ":/"	.
local path_root_destino		is drive_destino 	+ ":/"	.
local ERRO_FALTAM_MODULOS	is False			.

local modulos_c3 			is list()			.
local PATH_PARA_COPIAR		is ""				.
local NOME_PARA_COPIAR		is ""				.

local PATH_TESTAR_SE_EXISTE_NO_DESTINO 			is "".
local PATH_TESTAR_SE_COMPILADO_EXISTE_NA_ORIGEM is "".

global TAM_TOT_ARQS is 0.

	local path_to_module 		is ""	.
	local nome_do_module 		is ""	.
	local size_do_module 		is 0	.
	local size_do_module_STR 	is ""	.
	local nome_do_antes			is ""	.
	local size_do_antes			is ""	.
	local nome_module_ksm		is ""	.
	local size_do_COMPILADO		IS 0	.
	local separador_info		is " "	.//ATENCAO SEPARADOR Eh ESPACO AGORA
	local existe_diferenca_de_arquivos 			is False.
	local encontrou_registro_anterior			is false.
	local arquivo_nao_presente_em_drive_dest 	is false.
	local arquivo_COPLILADO_nao_EXISTE_ORIGEM	is False.
	
	//esses sao arquivos:
	local configs_antes 		is ""	.
	LOCAL configs_back			is ""	.
	
	local my_config				is ""	.
	
//definição da config de mostar mensagens de DEBUG:
if (parametro_para_comp_debug){
	//se ativado então os padroes serao definidos antes da definição dos parametros

	//ESTUDAR O PROCESSO DE DEBUG NOS PRINCIPAIS: autorun2, cp, c3
	//		o uso de arquivo de log em 0:/ vai resultar em erro se não houver conexão
	//pode-se alterar para fazer um processo gradual onde um nível maior de DEBUG ativa mais mensagens
	//	debug = 0; //somente mensagens normais
	//	debug = 1; //mensagens de informação sobre os passos principais: inicio do script e funcoes
	//	debug = 2; //mensagens de informação sobre os passos nas funcoes
	//	debug = 3; //mensagens de informação sobre os passos por comando

}
local 	debug_compile_copy 		is False.//novo
global 	debug_msg_compilacao 	is False.
	
modulos_c3:add("c3.ks").
modulos_c3:add("c3_menu.ks").
modulos_c3:add("c3_para_testes.ks").
modulos_c3:add("c3_pid_node.ks").//NOVO
modulos_c3:add("c3_utils.ks").
modulos_c3:add("c3_init_vars.ks").
modulos_c3:add("c3_sup_func.ks").
modulos_c3:add("c3_scr_msg.ks").
modulos_c3:add("c3_scr_tela.ks").
modulos_c3:add("c3_files.ks").
modulos_c3:add("c3_ship.ks").
modulos_c3:add("c3_term.ks").
modulos_c3:add("c3_cmd.ks").
modulos_c3:add("c3_song.ks").
modulos_c3:add("c3_ship_cfg.ks").

modulos_c3:add("cp.ks").

local autor_ks 	is "0:/boot/c3_autorun2.ks"	.
local autor_ksm is "0:/boot/c3_autorun2.ksm".//ei saidai nao compilou porque


print "CP: drive_origem:[" + drive_origem + "] config_path:[" + config_path + "] : PERGUNTA: E SE ESTIVER FORA DE COMUNICACAO?".
		debugc("", False, True).//mostra linha
PRINT "FAZER: compilando autor_ks to autor_ksm: [" + autor_ks +"] para ["+autor_ksm + "]: PERGUNTA: E SE ESTIVER FORA DE COMUNICACAO?".
compile autor_ks to autor_ksm.
copypath(autor_ks,  path_root_destino + "boot").
copypath(autor_ksm, path_root_destino + "boot").
		debugc("", False, True).//mostra linha

PRINT "PELO VISTO O CP PRECISA TER O DRIVE 0 EM ALCANCE!".
print "   FAZER: EXPLICAR ACOES DO CP: EXECUTAR AO TERMINAR:" + MODULO_FINAL_EXECUTAR + " [" +parametro_para_c3+ "]" .

if (MODO_COMPILE_ATIVO){	//avisa sobre o MODO_COMPILE_ATIVO
	print "MODO_COMPILE_ATIVO esta ativado: não será possível ver as linha em caso de erro".
}
else{
	print "MODO_COMPILE_ATIVO esta desativado: isso vai consumir espaço".
}.

print "CP: Delay de: " +delay_inicio+ " segundos...".
wait delay_inicio.

// - recupera os valores salvos anteriormente: ---------------------------------------------------
debugc("CP: Preparando registro dos arquivos...").
if (exists(config_path)){//ler o arquivo fonts.cfg e armazena em outro. ---------------------------
		debugc("     CP: Registro dos arquivos encontrado: " + config_path).
		
		//reserva informações para configurações anteriores
		SET configs_antes 	TO open(config_path):READALL.
		
		// para gravar novas informacoes ----------------------------------------------------------
		SET my_config TO OPEN(config_path).
		my_config:clear.
	
	// SET CONTENTS TO OPEN("filename"):READALL.
	// SET NEWFILE TO CREATE("newfile").
	// NEWFILE:WRITE(CONTENTS).
		
		if (exists(config_back)){
			set configs_back to open(config_back).
			configs_back:clear.
		}
		else{SET configs_back 	TO CREATE(config_back).}.
		//guarda infos anteriores em novo arquivo
		configs_back:WRITE(configs_antes).		
	}
	else{
		SET my_config TO CREATE(config_path).
		debugc("     CP: Registro dos arquivos nao encontrado: CRIANDO:" + config_path).
	}.


	print "pausa pro c a f e".
		wait delay_run_c3.

		if (parametro_para_comp_pausa){
			print "cp info: pressione uma tecla!".
			beep("bip_wait", False, delay_inicio).
			terminal:input:getchar().
		}


from {local file_mod is 0.}
until (file_mod = modulos_c3:length)
step {set file_mod to file_mod + 1.}
do//inicio do loop pelos registros indicados no COMECO DO COPIADOR: ------------------------------------------------------------
	{	
		debugc("", False, True).//mostra linha
		
		set path_to_module to (path_root_origem + modulos_c3[file_mod]).
		set nome_do_module to modulos_c3[file_mod].
		set size_do_module to (TEST_SIZE_FILE_CP(ACAO_FILE_SIZE_GET, path_to_module)).
		set size_do_module_STR to size_do_module:tostring.
		set nome_module_ksm to (path( path(nome_do_module):changeextension(file_KSM_ext) ):name).
		
		if (MODO_COMPILE_ATIVO){
			set PATH_TESTAR_SE_EXISTE_NO_DESTINO 			to ( path_root_destino + nome_module_ksm ).
			set PATH_TESTAR_SE_COMPILADO_EXISTE_NA_ORIGEM 	to ( path_root_origem  + nome_module_ksm ).
			if not(exists(PATH_TESTAR_SE_COMPILADO_EXISTE_NA_ORIGEM)){//arquivo compilado NAO existe na origem
				set arquivo_COPLILADO_nao_EXISTE_ORIGEM to True.
			}
			else{//arquivo compilado existe na origem
				set arquivo_COPLILADO_nao_EXISTE_ORIGEM to False.	
			}.
			debugc("arquivo COMPILADO existe na ORIGEM: " + not(arquivo_COPLILADO_nao_EXISTE_ORIGEM) + " : [" +(PATH_TESTAR_SE_COMPILADO_EXISTE_NA_ORIGEM )+ "]").
		}
		else{//excluir arquivo ksm no destino se não é para compilar: isso é para economizar espaço?
			//isto eh para evitar de rodar os ksm no drive 1:
				//e se der erro na nova compilação?
					//somente excluir e copiar o novo ksm se a compilação for bem sucedida: FAZER
						//TRANSFERIR TUDO ISSO PARA APÓS A COMPILAÇÃO
				//e se não tiver conexão com o 0:/?
				//o módulo ficará sem arquivos para rodar novamente
			set PATH_TESTAR_SE_EXISTE_NO_DESTINO to ( path_root_destino +  nome_do_module ) .
			if not (exists(path_to_module)){//testa se ao menos o arquivo fonte que será usado existe na origem:
				print "ERRO: O ARQUIVO NAO EXISTE NA ORIGEM: [" +path_to_module +"]: não vai deletar o ksm em destino".
				set ERRO_FALTAM_MODULOS to True.
			}
			else{
				debugc("arquivo excluido: : [" + ( path_root_destino + nome_module_ksm ) + "]").
				deletePath(path_root_destino + nome_module_ksm).
			}
		}.
		
		if not(exists(PATH_TESTAR_SE_EXISTE_NO_DESTINO )){//indica que vai copiar mesmo que nao houver diferenca no registro:
		//				 POR ISSO que o registro nao fica 
		//			no DESTINO pois ao ser excluido iria compilar quando so precisa COPIAR
		//   QUE??? FUMOU BOLINHA?? como vai saber o estado dos arquivos:
		//		então: no arquivo (config_path is "0:/fonts.cfg") fica registrado o tamanho do módulo
		//				que foi compilado com sucesso (certeza?) por último
		//			não necessariamente o módulo que está na nave atual
		//				para isto é necessário testar o tamanho dos módulos atuais na nave
		//					simples, não há necessidade de um novo registro
		//						pode-se testar tanto o tamhanho dos compilados quanto os fontes
		//			este teste verifica se vai ser necessário recompilar ou não o novo módulo em 0:/
		//				se ele encontra diferenças entre o tamanho do ks atual e o registrado significa que a fonte mudou
			set arquivo_nao_presente_em_drive_dest to True.	
		}
		else{
			set arquivo_nao_presente_em_drive_dest to False.
		}.	
		debugc("arquivo existe no destino: " + not(arquivo_nao_presente_em_drive_dest) + " : [" +(PATH_TESTAR_SE_EXISTE_NO_DESTINO )+ "]").
		
		if not (exists(path_to_module)) or (ERRO_FALTAM_MODULOS) {
			print "ERRO: O ARQUIVO NAO EXISTE NA ORIGEM: [" +path_to_module +"]".
			set ERRO_FALTAM_MODULOS to True.
			//BREAK.//quebra todo o loop : FAZER PROCURAR UM QUE PULA SOMENTE ESTE PASSO
		}
		else//O ARQUIVO existe: pode continuar
		{
			debugc("O arquivo existe: " + path_to_module).
			
			//print "config atual to add: ----------------------------------------------------------".
			print "linha do atual: [" + path_to_module + "] [" + size_do_module_STR + "]".
			
			set existe_diferenca_de_arquivos to False.
			set encontrou_registro_anterior to false.
		
			debugc("Procurando registro de arquivos atuais: " + config_back).
			//este teste verifica se vai ser necessário recompilar ou não o novo módulo em 0:/
			if (exists(config_back)){
				//print "config antes found: ------------------".
				for linha_do_antes in configs_antes{
					//print "linha do antes: " + linha_do_antes.
						
					set nome_do_antes to linha_do_antes:substring(0, linha_do_antes:find(separador_info) ).
					//print "nome_do_antes [" + nome_do_antes + "]".
					
					//print "pos do size: [" + (linha_do_antes:find(separador_info)+1) + "]".
					set size_do_antes to linha_do_antes:substring((linha_do_antes:find(separador_info) + 1), (linha_do_antes:length - 1) - ((linha_do_antes:find(separador_info))) ).
					//print "size_do_antes [" + size_do_antes + "]".
					
					if (nome_do_antes = path_to_module)	{
						set encontrou_registro_anterior to True.
						//print "linha do antes: [" + nome_do_antes + "] [" + size_do_antes + "]".
						if (size_do_antes = size_do_module_STR){
								set existe_diferenca_de_arquivos to False.
								beep("ja_existe", False, 0.005).

								debugc("nao existe diferenca: [" + size_do_antes + "]").
							}
							else{
								debugc("compile modafoca >antes[" + size_do_antes + "] atual[" + size_do_module_STR + "]").
								set existe_diferenca_de_arquivos to True.
							}.
					}.
				}.
				
				//0:/c3.ks 102578		
				//0123456789012345		
				
			}//fim existe config BACK --------------------------
			else{
				debugc("Arquivo de registro de arquivos atuais NAO EXISTE : " + config_back).
			}
		
			IF (encontrou_registro_anterior){
				//PRINT "O arquivo possuia um registro anterior.".
				debugc("O arquivo possuia um registro anterior").
			}ELSE{//sem registro: MOSTRAR MESMO QUE O DEBUG ESTEJA DESATIVADO!
				debugc("O arquivo NAO possui um registro anterior.", True).
			}.
		
		
			// agora pode compilar OS DIFERENTES --------------------------------------------------------------
			if ((existe_diferenca_de_arquivos) or (arquivo_nao_presente_em_drive_dest) or (MODO_COMPILE_FORCE)){
				beep("copiar").
				//     cp.ks
				set NOME_PARA_COPIAR to nome_do_module.
				
				
				if (MODO_COMPILE_ATIVO){
				
					//AQUI vai compilar se EXISTE DIFERENCA
					if ((existe_diferenca_de_arquivos) OR (arquivo_COPLILADO_nao_EXISTE_ORIGEM) or (MODO_COMPILE_FORCE)){
						// VAI VIM: 0:/cp.ksm  > com path() e extensao alterada
						set PATH_PARA_COPIAR 	to compile_MOTHAFOCA(path_to_module).
						debugc("  resultado da compilacao: " + PATH_PARA_COPIAR).
						set size_do_COMPILADO 	to (TEST_SIZE_FILE_CP(ACAO_FILE_SIZE_GET, PATH_PARA_COPIAR)).
						debugc("  size_do_COMPILADO      : [" + size_do_COMPILADO + "]:relacao sizes COMP/MOD de ["+ round((size_do_COMPILADO/size_do_module)*100, 0) +"]%" ).
					}.

					//AQUI VAI MUDAR O NOME mesmo se nao existe diferencao MAS se o modo compile for ativo entao
					// vai usar para caso OS ARQUIVOS NAO EXISTAM NO DESTINO
					//se o modo compile esta ativo isto significa que os arquivos a serem copiados sao KSM
					//     cp.ksm
					set NOME_PARA_COPIAR to path(nome_do_module):changeextension(file_KSM_ext).
					set NOME_PARA_COPIAR to (path(NOME_PARA_COPIAR):name).
					//converte cp.ks direto para cp.ksm: set nome_novo_ksm to (path(path(nome__module_ks):changeextension(file_KSM_ext)):name).
					//PODERIA USAR TAMBEM: PATH_PARA_COPIAR:name ? nao sei
					//show new names
					debugc("nome_do_module         : " + nome_do_module, debug_compile_copy).
					debugc("NOME_PARA_COPIAR       : " + NOME_PARA_COPIAR, debug_compile_copy).
				}
				else{//     cp.ks
					set NOME_PARA_COPIAR to nome_do_module.//mas ele ja faz no comeco da condicao VER
				}.
					
					
				if (arquivo_nao_presente_em_drive_dest) {
					
				}.
				//if (nome_do_module = MODULO_FINAL_EXECUTAR){//nao usar isso aqui vai dar muito problema
					//     cp.ks / cp.ksm      1              0         exec  msgs  debg		
				//	RECOPIA(NOME_PARA_COPIAR, drive_destino, drive_origem,False,False,False).//botei false pra nao exec mesmo> SE EXEC AQUI E NEM TODOS OS MODULOS FORAM COMPILADOS?
				//}
				//else{//     cp.ks / cp.ksm      1              0         NOexec  msgs  debg
				//	RECOPIA(NOME_PARA_COPIAR, drive_destino, drive_origem,False,False,False).}
				
				//     cp.ks / cp.ksm      1              0         NOexec  msgs  debg
				RECOPIA(NOME_PARA_COPIAR, drive_destino, drive_origem,False,False,False).
			}.

			// outra possibilidade: o arquivo existe no destino, o registro compilado é atual (not(existe_diferenca_de_arquivos)) e
			// e não há imposição de complilação: mas o tamanho do compilado (ou fonte) no destino difere dos atuais em 0:/
			//			então copia uma nova cópia no DESTINO
			if ( 
					not(existe_diferenca_de_arquivos)
				and
					not(arquivo_nao_presente_em_drive_dest)
				and
					not(MODO_COMPILE_FORCE)
				){
					//ha
					set NOME_PARA_COPIAR to nome_do_module.
					
					if (MODO_COMPILE_ATIVO){
						set NOME_PARA_COPIAR to nome_module_ksm.
					}
					else{
						set NOME_PARA_COPIAR to nome_do_module.
					}

					local PATH_COPIA_DIFERENTE_DESTINO 		to ( path_root_destino + NOME_PARA_COPIAR ).
					local PATH_COPIA_DIFERENTE_ORIGEM 		to ( path_root_origem  + NOME_PARA_COPIAR ).
						local size_do_COPIA_DIFERENTE_na_origem 	to (TEST_SIZE_FILE_CP(ACAO_FILE_SIZE_GET, PATH_COPIA_DIFERENTE_ORIGEM)).
						local size_do_COPIA_DIFERENTE_no_destino 	to (TEST_SIZE_FILE_CP(ACAO_FILE_SIZE_GET, PATH_COPIA_DIFERENTE_DESTINO)).
							debugc("size_do_COPIA_DIFERENTE_na_origem  : [" + size_do_COPIA_DIFERENTE_na_origem + "]") .
							debugc("size_do_COPIA_DIFERENTE_no_destino  : [" + size_do_COPIA_DIFERENTE_no_destino + "]") .

						if (size_do_COPIA_DIFERENTE_na_origem <> size_do_COPIA_DIFERENTE_no_destino){
							debugc("tamanhos diferem  : copiando novo [" + NOME_PARA_COPIAR + "]").
							debugc("NOME_PARA_COPIAR       : " + NOME_PARA_COPIAR, debug_compile_copy).
							RECOPIA(NOME_PARA_COPIAR, drive_destino, drive_origem,False,False,False).
						}
				}

			debugc("     CP: Registrando modulo em :[" +config_path+"]").
			my_config:writeln( path_to_module + separador_info + size_do_module_STR).
		}.


	}.//FIM do loop pelos registros indicados no COMECO DO COPIADOR: ------------------------------------------------------------

	
if (ERRO_FALTAM_MODULOS) {
	print "FORAM ENCONTRADOS ERROS DURANTE A COMPILACAO: ERRO_FALTAM_MODULOS.".
	}
else{// EXECUTA O C3 AQUI

	debugc("CP: Nenhum erro encontrado: continuando para copia dos arquivos...").

	if (MODO_COMPILE_ATIVO) and (MODULO_FINAL_EXECUTAR <> "")	{//exists pois tem ser válido o nome: vai testar no path() ATUAL: SE ESTIVER NO 1:/ E ?
		//exists()
		debugc("modo_compile:["+ MODO_COMPILE_ATIVO +"] executar:["+MODULO_FINAL_EXECUTAR+"]...").
		set MODULO_FINAL_EXECUTAR to (path(MODULO_FINAL_EXECUTAR):changeextension(file_KSM_ext)).//muda extensao: pois SEMPRE vai ser indicado o nome: prog.ks
		set MODULO_FINAL_EXECUTAR to ((path( MODULO_FINAL_EXECUTAR ):name)).//retira somente o nome com ext do path().
		if (exists(MODULO_FINAL_EXECUTAR)){//se existir um prog.ksm no DRIVE atual
			switch to drive_destino.
		}
	}
	else{
		debugc("MODULO_FINAL_EXECUTAR:["+ MODULO_FINAL_EXECUTAR +"] deve ser nulo OU MODO_COMPILE_ATIVO:["+MODO_COMPILE_ATIVO+"] deve ser false > TESTANDO ...").
		if (MODO_COMPILE_ATIVO){
			debugc("MODO_COMPILE_ATIVO:["+ MODO_COMPILE_ATIVO +"] mudando para drive_destino...").
			switch to drive_destino.
		}
		else{
			if (1=0){//atenção VER ISSO: VERISSO: ATENCAO
				//desativado pois não sei porque tem que mudar para a origem se o MODO_COMPILE estiver desativado
				debugc("MODO_COMPILE_ATIVO:["+ MODO_COMPILE_ATIVO +"] mudando para drive_origem...").
				switch to drive_origem.//porque isso? 
			}
			ELSE {//VAI FICAR ASSIM POR ENQUANTO:
				debugc("MODO_COMPILE_ATIVO:["+ MODO_COMPILE_ATIVO +"] mudando para drive_destino...").
				switch to drive_destino.

			}
		}
	}
	
	if (exists(MODULO_FINAL_EXECUTAR) and (MODULO_FINAL_EXECUTAR <> "") ){
		debugc("EXISTE:["+ MODULO_FINAL_EXECUTAR +"]...").
		EXIBE_FILES_VOLUME_INFO().
		print "CP: processo concluido com sucesso: executando :[" + MODULO_FINAL_EXECUTAR + "] ["+parametro_para_c3+"] em[" + path()+ "]".//QUE

		wait delay_tmp.
		wait delay_run_c3.//usar um double: do parametro direto nao vai

		if (parametro_para_comp_pausa){
			print "cp info: pressione uma tecla!".
			beep("bip_wait", False, delay_inicio).
			terminal:input:getchar().
		}

		runpath(MODULO_FINAL_EXECUTAR, parametro_para_c3).//testar
		DEBUGC("C3 finalizado: FIM do programa MESMO!...").

	}
	else{
		debugc("NAO EXISTE:["+ MODULO_FINAL_EXECUTAR +"] : exists(MODULO_FINAL_EXECUTAR) return:["+exists(MODULO_FINAL_EXECUTAR) +"].").
	}
	DEBUGC("RUN C3 finalizado: FIM MODULOS ESTAVAM OK!...").
}.

DEBUGC("CP finalizado: FIM do programa MESMO!...").


FUNCTION HELPS_CP{
		
			//compilar somente os arquivos que foram alterados:
			
			//c3_init_vars.
			//c3_menu.ks.
			
		//LIST files in FileList.
		//filelist:getfile().???
		
	//pegar os tamanhos de todos os FONTES atuais	0:/
	//armazenar em um arquivo novo fonts.cfg		0:/fonts.cfg
	//compilar os FONTES							0:/  compile.
	//copiar os COMPILADOS							0:/c3.ksm to 1:/c3.ksm
	//RODAR os COMPILADOS							runpath("1:/c3.ksm").
	//
	// bugs BUGS bugs BUGS
	//
	//copiar (win) os novos arquivos editados		cp3_test.bat
	//ler o arquivo FONTS.CFG						
	//	comparar as linhas com os novos tamanhos
	//
	//compilar somente os arquivos que foram modificados
	//copiar os arquivos recompilados
	//RODAR os COMPILADOS
	//
	
	
//http://ksp-kos.github.io/KOS_DOC/general/compiling.html#compiling	
//Then you can put just the compiled KSM versions of them on your vessel and run it this way:

// SWITCH TO ARCHIVE.

// COMPILE myprog1.ks to myprog1.ksm.
// COPY myprog1.ksm to 1.

// COMPILE myprog2. // If you leave the arguments off, it assumes you are going from .ks to .ksm
// COPY myprog2.ksm to 1.

// COMPILE myprog3. // If you leave the arguments off, it assumes you are going from .ks to .ksm
// COPY myprog2.ksm to 1.

// SWITCH TO 1.
// RUNPATH(myprog1, 1, 2, "hello").


	
	
// VolumeFile
//http://ksp-kos.github.io/KOS_DOC/structures/volumes_and_files/volumefile.html?highlight=read#VOLUMEFILE:READALL
// File name and size information. You can obtain a list of values 
//of type VolumeFile using the LIST FILES command.

// structure VolumeFile
    // Members¶ Suffix 	Type 	Description
    // All suffixes of VolumeItem 	  	VolumeFile objects are a type of VolumeItem
    // READALL 	FileContent 	Reads file contents
    // WRITE(String|FileContent) 	Boolean 	Writes the given string to the file
    // WRITELN(string) 	Boolean 	Writes the given string and a newline to the file
    // CLEAR 	None 	Clears this file
	
	
	
	// FileContent
//http://ksp-kos.github.io/KOS_DOC/structures/volumes_and_files/filecontent.html#structure:FILECONTENT
// Represents the contents of a file. You can obtain an instance of this class using VolumeFile:READALL.

// Internally this class stores raw data (a byte array). It can be passed around as is, for example this will copy a file:

// SET CONTENTS TO OPEN("filename"):READALL.
// SET NEWFILE TO CREATE("newfile").
// NEWFILE:WRITE(CONTENTS).

// You can parse the contents to read them as a string:

// SET CONTENTS_AS_STRING TO OPEN("filename"):READALL:STRING.
//do something with a string:
// PRINT CONTENTS_AS_STRING:CONTAINS("test").

// Instances of this class can be iterated over. In each iteration step a single line of the file will be read.

// structure FileContent
    // Members¶ Suffix 	Type 	Description
    // LENGTH 	scalar 	File length (in bytes)
    // EMPTY 	boolean 	True if the file is empty
    // TYPE 	String 	Type of the content
    // STRING 	String 	Contents of the file decoded using UTF-8 encoding
    // ITERATOR 	Iterator 	Iterates over the lines of a file
}.	

FUNCTION DEBUGC{
	//parameter NOME_DA_FUNC.
	parameter MSG_DE_DEBUG.
	parameter MOSTRAR_DEBUGC is debug_msg_compilacao.
	parameter MOSTRA_LINHA_DIVISOR is False.
	parameter LOG_DEBUG_TO_FILE is True.
	
	//	print "debug " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG.	
	IF (MOSTRAR_DEBUGC) {print "debug : " + MSG_DE_DEBUG.	}
	else if MOSTRA_LINHA_DIVISOR {print ".------------------------------------------------------.".}
	else {
		//print ".".
		}
	//	lista_DEBUG:add(MSG_DE_DEBUG).
	
    //if (LOG_DEBUG){
	//LOG "debugc " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG to FILE_DEBUGLOG.
	if (LOG_DEBUG_TO_FILE){
		LOG "debugcp " + ": " + MSG_DE_DEBUG to FILE_DEBUGLOG_cp.
	}
}.
	
	
FUNCTION TEST_SIZE_FILE_CP{//ACAO_FILE_SIZE_GET, path("0:/boot/d"):TOSTR
	parameter operacao_file							.
	parameter file_path								.				//o file_path com extensao eh aconselhavel
	parameter debug_files 	is False				.
	parameter file_ext		is "ks"					.//SEM PONTO	//vai usar esse padrao apenas se nao for enviada uma path com extensao
	
	local file_name	 		is path(file_path):name	.
	
	local PATH_ANTES_DA_MANOBRA is ""		.
	local file_root_path		is ""		.
	local file_name_search 		is ""		.
	local file_parent_path		is ""		.
	local filelist				is list()	.
	
	//VAI MUDAR DE PATH MAS VAI RETORNAR NO FINAL.
	set PATH_ANTES_DA_MANOBRA to path().
	if (path(file_path):extension <> "")
		{
			set  file_name_search to file_name.
		}
	else
		{
			set  file_name_search to file_name + "." + file_ext.
		}.
	if (debug_files){
		print "Atual            : " + PATH_ANTES_DA_MANOBRA.
		print "file_path        : " + file_path.
		print "ROOT             : " + path(file_path):root. //obtem 0:/
		print "PARENT           : " + path(file_path):parent. //obtem 0:/boot (para o path("0:/boot/init.ks")) 
		print "name by path     : " + path(file_path):name.
		print "ext by path      : " + path(file_path):extension.// OBS a resposta eh sem o ponto ks
		print "name parameter   : " + file_name.
		print "ext parameter    : " + file_ext.
		print "usado na pesquisa: " + file_name_search.		
	}.
	
	set file_root_path to path(file_path):root.
	set file_parent_path to path(file_path):parent.
	cd(file_parent_path).
	if (debug_files){//mostra atual
		print "Atual: " + path().
	}.
	
	if (operacao_file = ACAO_FILE_SIZE_GET)
	{
		//assuming the file is in the current
		list files in filelist.
		for file_moth in fileList
		{
			if (debug_files)
			{
				print "nome do arq: " + file_moth:name.
			}.
			if (file_moth:name = (file_name_search))//encontrou o arquivo que queria e : parent + "/" + name = NAO SEII
			{
				if (file_moth:isFile) //extension, name, size, isFile
				{//e se for uma pasta o que queremos?
					if (debug_files)
					{
						print "file: " + file_moth:name + " tem " + file_moth:size.
					}.
					return file_moth:size.
					//
				}.
			}.
		}
	}.
	
	if (operacao_file = ACAO_FILE_SIZE_TEST){
		LIST.  // Prints the list of files (and subdirectories) on current volume.
		LIST FILES.  // Does the same exact thing, but more explicitly.
		LIST VOLUMES. // which volumes can be seen by this CPU?
		LIST FILES IN fileList. // fileList is now a LIST() containing :struct:`VolumeItem` structures.	
	}.
	
	//VOLTA AO ANTERIOR
	cd(PATH_ANTES_DA_MANOBRA).
	if (debug_files){//mostra atual
		print "Atual: " + path().
	}.

	if (     (operacao_file <> ACAO_FILE_SIZE_GET)
		 and (operacao_file <> ACAO_FILE_SIZE_TEST) )
	{
		print "ERRO: FILE_SIZE_GET: Nenhuma acao valida passada a funcao!".
	}.
	// print path("0:/boot/d"):suffixnames.
// LIST of 19 items:
// [0] = "CHANGEEXTENSION"
// [1] = "CHANGENAME"
// [2] = "COMBINE"
// [3] = "EXTENSION"
// [4] = "HASEXTENSION"
// [5] = "HASSUFFIX"
// [6] = "INHERITANCE"
// [7] = "ISPARENT"
// [8] = "ISSERIALIZABLE"
// [9] = "ISTYPE"
// [10] = "LENGTH"
// [11] = "NAME"
// [12] = "PARENT"
// [13] = "ROOT"
// [14] = "SEGMENTS"
// [15] = "SUFFIXNAMES"
// [16] = "TOSTRING"
// [17] = "TYPENAME"
// [18] = "VOLUME"
}.


function compile_MOTHAFOCA{	//compila e retorna o mesmo path mas com a extensao alterada para .ksm
		parameter NOME_DO_MODULO_PARA_COMPILAR.
		local PATH_PROG_COMPILADO_orig 	is "" .
	
		//set NOME_DO_MODULO_PARA_COMPILAR 	to "0:/prog.ks".//ou seja na origem ainda Archive
		//compila e transforma os nomes em .ksm
			print "-------------------------------------------------".
			print "Compilando: ["+NOME_DO_MODULO_PARA_COMPILAR+"]...".
			print "-------------------------------------------------".
			wait (2*delay_tmp).
			
			compile NOME_DO_MODULO_PARA_COMPILAR.
			//set NOME_DO_MODULO_PARA_COMPILAR to DRIVE_ORIGEM + ":/" + NOME_PROG.   NOME_PROG="c3.ks"
			
			//now the print path(my_prot):extension  = ks
			//print path(my_prot):hasextension. = False WTF?? THAT'S BECAUSE:
			// set MY_PROT to "0:/c3".
			// print path(my_prot):hasextension.
			// True
			
			//DRIVE_ORIGEM + ":/" + NOME_PROG.
			//MAKE "0:/c3.ks"
			//     "0:/c3.ksm"
			// just do  path(my_prot):changeextension("puto").     =  "0:/c3.puto"
			set PATH_PROG_COMPILADO_orig to path(NOME_DO_MODULO_PARA_COMPILAR):changeextension(file_KSM_ext).

			//faz com que os .ksm agora sejam enviados como parametros no lugar para a copia:
			return PATH_PROG_COMPILADO_orig.
		
	}.
	
function RECOPIA{
		//uses: FUNCTIONS:
		//		TEST_SIZE_FILE
		//		VOLUME_INFOS
	parameter NOME_PROG.			//VAI USAR o drive do kos por padrao para o destino se nao for especificado \/
	parameter DRIVE_DEST			is TEST_PARTS_GET_MODULES(ACAO_GET_PART_MODULES_INFOS_GET_NUM, core:part:NAME). //1 ou 2 ou nome sem os pontos FAZER
	//parmeter  DRIVE_DEST			is ( extract_the_num_name(path(CORE:VOLUME):tostring) ).
	parameter DRIVE_ORIGEM			is 0	.//ROOT DRIVE
	parameter execute_module 		is True	.
	parameter show_msgs_ver 		is False.
	parameter debug_recopia 		is False	.
	
	local PATH_PROG_DEST 			is ""	.
	local PATH_PROG_ORIG 			is ""	.
	local PATH_DEST 				is ""	.
	local PATH_ORIG 				is ""	.
	
	local TAMANHO_DO_ARQUIVO_PROG	is 0.
	
	local PATH_PROG_INICIAL is path().
	//local PATH_KOS_CPU_DRIVE is TEST_PARTS_GET_MODULES(ACAO_GET_PART_MODULES_INFOS_GET_NUM, core:part:NAME) + ":/".
	local PATH_KOS_CPU_DRIVE is path(CORE:VOLUME):tostring.
	
	set PATH_PROG_DEST to DRIVE_DEST 	+ ":/" + NOME_PROG.
	set PATH_PROG_ORIG to DRIVE_ORIGEM 	+ ":/" + NOME_PROG.
	set PATH_DEST	   to DRIVE_DEST 	+ ":/".
	set PATH_ORIG	   to DRIVE_ORIGEM 	+ ":/".
	
	if (show_msgs_ver){//EXIBE VARIAVEIS associadas
		print "-------------------------------------------------".
		print "path(): inicial: ATUAL   : " + PATH_PROG_INICIAL.
		print "-------------------------------------------------".
		VOLUME_INFOS(path()).
		print "-------------------------------------------------".
		print "NOME_PROG                : "	+ NOME_PROG.
		print "DRIVE_DEST               : "	+ DRIVE_DEST.
		print "DRIVE_ORIGEM             : "	+ DRIVE_ORIGEM.
		print "-------------------------------------------------".
		print "PATH_KOS_CPU_DRIVE       : "	+ PATH_KOS_CPU_DRIVE.
		//print "kOSProcessor: VOLUME size: " + TEST_PARTS_GET_MODULES(ACAO_GET_PART_MODULES_INFOS_SIZE, core:part:NAME).
		print "kOSProcessor: VOLUME size: " + core:VOLUME:CAPACITY. //pelo menos para o que esta executando
		print "-------------------------------------------------".
		print "PATH_PROG_ORIG           : "	+ PATH_PROG_ORIG.
		print "PATH_PROG_DEST           : "	+ PATH_PROG_DEST.
		print "PATH_ORIG                : "	+ PATH_ORIG.
		print "PATH_DEST                : "	+ PATH_DEST.
		print "-------------------------------------------------".
		print "Alterando drive atual    : " + "switch to MODULEkOS:VOLUME.".		
	}.
	
	//TEST_PARTS_GET_MODULES(ACAO_GET_PART_MODULES_INFOS_CD_KOS, core:part:NAME). //switch to MODULEkOS:VOLUME.
	switch to CORE:volume.
	//agora o path eh o kos drive da cpu!
	
	//quando ele inicia normalmente vai para:
		// path() = Archive:/
		// quando da o comando abaixo vai para:
		// switch to core:volume = 1:/           //sera que eh SEMPRE o volume atual ou o volume do processor? [parece que sim]
	
	if (PATH_DEST <> PATH_KOS_CPU_DRIVE){//volume de destino diferente do kOSProcessor
		print "Atencao: RECOPIA: o volume de destino[" + PATH_DEST
    	      + "] eh diferente do kOSProcessor["  + PATH_KOS_CPU_DRIVE + "]".
		}.
		
	if ( ( PATH_PROG_INICIAL <> PATH_DEST ) and (show_msgs_ver)) {//NAO Esta no DESTINO > mostra o destino entao
		print "NAO Esta no DESTINO".
		print "-------------------------------------------------".
		VOLUME_INFOS(path(PATH_PROG_DEST)).
		print "-------------------------------------------------".
		}
		
	//TESTAR ISSO [ok]:
		//  path("0:/"):VOLUME:NAME = Archive     (mesmo estando no 1:/).
		//  path("1:/"):VOLUME:NAME =      (mesmo estando no 1:/).

	if (( PATH_PROG_INICIAL <> PATH_ORIG ) and (show_msgs_ver)) {//NAO Esta na ORIGEM > mostrA a origem entao.
		if ( path(PATH_PROG_INICIAL):volume:name <> path(PATH_ORIG):volume:name ){	
		     	print "NAO Esta na ORIGEM".
				print "Mostra infos do LOCAL DE ORIGEM". 
				print "-------------------------------------------------".
				VOLUME_INFOS(path(PATH_PROG_ORIG)).
				print "-------------------------------------------------".
			}.
		}.

	if (show_msgs_ver){print "Alterando para ORIGEM...[" + DRIVE_ORIGEM + "]".}.
		
	switch TO DRIVE_ORIGEM.//deixar no ORIGEM para se o programa falhar a copia, os comandos serao no do arquivo
	if (show_msgs_ver){PRINT "LISTANDO ARQUIVOS em :[" + DRIVE_ORIGEM + "] path:[" + path() + "]".}.
		
	if (show_msgs_ver){list.}.
	
	//print TEST_SIZE_FILE(ACAO_FILE_SIZE_GET,"0:/c3").
	set TAMANHO_DO_ARQUIVO_PROG to TEST_SIZE_FILE_CP(ACAO_FILE_SIZE_GET, PATH_PROG_ORIG).
	set TAM_TOT_ARQS to (TAM_TOT_ARQS + TAMANHO_DO_ARQUIVO_PROG).
	
	if (show_msgs_ver){//exibe tamanhos e espaco livre
		print "tamanho do arquivo em : [" + PATH_PROG_ORIG + "] : [" + TAMANHO_DO_ARQUIVO_PROG + "] bytes".
		print "espaco livre em : [" + PATH_DEST + "] : [" + path(PATH_DEST):VOLUME:freespace + "] bytes".
	}.
	if (TAMANHO_DO_ARQUIVO_PROG < path(PATH_DEST):VOLUME:freespace){// VER SE : ACAO_GET_PART_MODULES_INFOS_FREE retorna o mesmo valor
		if (show_msgs_ver){
			print "-------------------------------------------------".
			print "Copia PATH_PROG_ORIG to PATH_DEST:".}.
		copypath(PATH_PROG_ORIG, PATH_DEST).//independente do local copia o c3 do 0:/
		if (show_msgs_ver){print "-------------------------------------------------".}.
			
		if (path() <> (PATH_DEST) )
			{
				switch to DRIVE_DEST.
				if (show_msgs_ver){
					PRINT "LISTANDO ARQUIVOS em : " + path().
					list.}.
					
				if (exists(PATH_PROG_DEST)){
					if (show_msgs_ver){
						PRINT "RECOPIA: Copiado com sucesso.".}.
					if (execute_module){
							print "Executando " + PATH_PROG_DEST + "...".
							
							EXIBE_FILES_VOLUME_INFO().
							wait (2*delay_tmp).
							
							runpath(PATH_PROG_DEST, parametro_para_c3).//runpath(PATH_PROG_DEST, MODO_EXEC_NORMAL).//run_normal
							//, DRIVE_DEST). //o segundo parametro era para especificar o local que devia rodar/copiar para
						}.
					}
				ELSE{
						PRINT "ERRO: RECOPIA: Nao foi encontrado: [" +PATH_PROG_DEST+ "]".
					}.
			}.
	}
	else {	print "ERRO: RECOPIA: Nao ha espaco suficiente no disco do processador.".
			PRINT "Espaco restante: [" + path(PATH_DEST):VOLUME:freespace + "]".
			BEEP("erro").
			wait delay_inicio.
	}.
	
}.

FUNCTION BEEP{		//IDENTICA A c3_scr_msg.ks
	parameter opcao_beep 	is "padrao".
	parameter esperar		is false.
	parameter tempo_beep 	is -1.
	
	
	local tempo_espera_beep to 0.00001.
	if (esperar=false){set tempo_espera_beep 	to 0.00001.}
	else {
		if tempo_beep>0{}.
		
	}.

	if (opcao_beep = "padrao"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0). // Gets a reference to the zero-th voice in the chip.
		V0:PLAY( NOTE(400, 2.5) ).  // Starts a note at 400 Hz for 2.5 seconds.
	}
	else if (opcao_beep = "erro"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0). // Gets a reference to the zero-th voice in the chip.
		V0:PLAY( NOTE(450, 2.0) ).  // Starts a note at 400 Hz for 2.5 seconds.
	}
	else if (opcao_beep = "ja_existe"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep>0{}
		else{
			set tempo_beep to (delay_inicio-(delay_inicio/2)).}
		V0:PLAY( NOTE(350, tempo_beep) ).
	}
	else if (opcao_beep = "copiar"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep>0{}
		else{
			set tempo_beep to (2*delay_inicio).}
		V0:PLAY( NOTE(750, tempo_beep) ).//alto
	}
	else if (opcao_beep = "bipinho"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		V0:PLAY( NOTE(650, 0.5) ).
	}
	else if (opcao_beep = "bip_wait"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		V0:PLAY( NOTE(700, tempo_beep) ).
	}.
	
	if tempo_beep<0{set tempo_beep to 0.0001.}.
	if (esperar){wait tempo_beep.}
	
}.

FUNCTION EXIBE_FILES_VOLUME_INFO{
									//imprime informacoes de espaço:
		print "".
		print "tamanho total dos arquivos: " + TAM_TOT_ARQS + "]".
		print "Path volume: 	[" + path_root_destino + "]".
		// structure Volume
		PRINT "Espaco total:    [" + path(path_root_destino):VOLUME:CAPACITY + "]".
		PRINT "Espaco restante: [" + path(path_root_destino):VOLUME:freespace + "]".
		PRINT "NAME: 			[" + path(path_root_destino):VOLUME:NAME + "]".
		PRINT "RENAMEABLE: 		[" + path(path_root_destino):VOLUME:RENAMEABLE + "]".
		PRINT "ROOT: 			[" + path(path_root_destino):VOLUME:ROOT + "]".
		PRINT "POWERREQUIREMENT:[" + path(path_root_destino):VOLUME:POWERREQUIREMENT + "]".
		print "".
		
		BEEP("bipinho").
		wait delay_inicio.
}.

