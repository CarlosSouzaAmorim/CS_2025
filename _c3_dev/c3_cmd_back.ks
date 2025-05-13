@LAZYGLOBAL OFF.
//c3_cmd.ks
// 7 funcoes: 490 linhas
	//uses: BLAH
runoncepath("c3_init_vars").

// ====      FUNCOES BASE PARA ENTRADA DE COMANDOS =========================================================================

///* //para quando tiver num outro terminal ou TELNET: FAZER
// kOSProcessor, containing:
// LIST of 8 items:
// [2] = "(callable) open terminal, is KSPEvent"
// [4] = "(callable) open terminal, is KSPAction"
// [5] = "(callable) close terminal, is KSPAction"
// [6] = "(callable) toggle terminal, is KSPAction"
 //*/
 //
// /* /* /* PRINT CORE.  //PARA O CPU ATUAL:
// kOSProcessor, containing:
// LIST of 8 items:
// [0] = "(get-only) kos disk space, is Int32"
// [1] = "(get-only) kos average power, is Single"
// [2] = "(callable) open terminal, is KSPEvent"
// [3] = "(callable) toggle power, is KSPEvent"
// [4] = "(callable) open terminal, is KSPAction"
// [5] = "(callable) close terminal, is KSPAction"
// [6] = "(callable) toggle terminal, is KSPAction"
// [7] = "(callable) toggle power, is KSPAction"
 // */ */ */

FUNCTION PROCESS_KEYBOARD{		//DECIDE O QUE FAZER COM O "CARACTER_PEGADO" > process_commands() OU process_more_char().
	parameter CARACTER_PEGADO.
	local NOME_DA_FUNC is "PROCESS_KEYBD".
    trace(NOME_DA_FUNC).
			
	if (CARACTER_PEGADO = terminal:input:RETURN){	//para confirmacao de comandos com ENTER (atualiza menu)
			process_commands().
			MOSTRA_MENU(MENU_ultimo_exibido, True).//para atualizar o menu
			//fazer limpar a linha de comando somente aqui para diminuir o delay
		}
        
	else if  CARACTER_PEGADO = terminal:input:UPCURSORONE {	//para navegar acima no modo menu, anterior CMD armazenado no modo CMD_LINE
            if (Hist_Com:LENGTH > 1) {//somente se ja tiver algo no historico  > ver > and (Hist_Com[0] > -1)
                if (Hist_Com[0] = 0){
                    set linha_digitada_no_prompt to "".
                    set Hist_Com[0] to (Hist_Com:LENGTH - 1).//poe o ponteiro na posicao final novamente
                    DEBUG(NOME_DA_FUNC,"poe o ponteiro na posicao final novamente: ["+Hist_Com[0]+"]" ).
                }
                else {
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    set Hist_Com[0] to (Hist_Com[0] - 1).//poe o ponteiro na posicao anterior
                    DEBUG(NOME_DA_FUNC,"poe o ponteiro na posicao anterior: ["+Hist_Com[0]+"]" ).
                    //
                }.
            }
            else{   //nao ha nada no historico > "para cima" fara com que apague tudo
                set linha_digitada_no_prompt to "".
            }.
            print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
	}
        
	else if  CARACTER_PEGADO = terminal:input:DOWNCURSORONE{	//para navegar abaixo no modo menu, proximo CMD armazenado no modo CMD_LINE
			print "debug: proces_keyb: You typed the down-arrow key.".
            
            
            
            if (Hist_Com:LENGTH > 1) {//somente se ja tiver algo no historico  > ver > and (Hist_Com[0] > -1)
                if (Hist_Com[0] = (Hist_Com:LENGTH - 1)){//situacao padrao para o uso que deu enter
                //se o indice no historico for o indicador do ultimo comando:    
                    
                    set linha_digitada_no_prompt to "".
                    set Hist_Com[0] to (0).//poe o ponteiro na posicao final inicial (segundo item =1)
                    //set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    DEBUG(NOME_DA_FUNC,"poe o ponteiro na posicao inicial novamente: ["+Hist_Com[0]+"]" ).
                }
                else {//se ele nao eh o ultimo entao esta ciclando:(pode ter sido um pulo para cima)
                    set Hist_Com[0] to (Hist_Com[0] + 1).//poe o ponteiro na posicao para frente
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    DEBUG(NOME_DA_FUNC,"poe o ponteiro na posicao anterior: ["+Hist_Com[0]+"]" ).
                    //
                }.
            }
            else{   //nao ha nada no historico > "para cima" fara com que apague tudo
                set linha_digitada_no_prompt to "".
            }.
            
            
            
            print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
	}
        
	else if  CARACTER_PEGADO = terminal:input:BACKSPACE {		//para FAZER:VOLTAR UM NIVEL DE MENU, apagar um caracter no modo CMD_LINE
		    apaga_ultimo_caracter().
            if (Hist_Com:LENGTH > 0){
                set Hist_Com[0] to (Hist_Com:LENGTH - 1).//devolve o ponteiro para a ultima posicao
            }.
		}
    else{
        process_more_char(CARACTER_PEGADO). //para entrada de instrucoes 
        process_one_char(CARACTER_PEGADO). //para seleção de opcoes        
    }.

}.

FUNCTION apaga_ultimo_LOOPcaracter_NU{      //NÃO UTILIZADO
	//parameter linha_digitada_no_prompt.
	//fazer
	print "debug: Apaga caracter: FAZER.".
    
	local NOME_DA_FUNC is "apaga_ultimo_caracter".
    trace(NOME_DA_FUNC).
    
    local new_linha_dig_no_prompt   is ""   .
    
    from {local car_pos is 0.}
		until (car_pos = (linha_digitada_no_prompt:length - 1))
		step{set car_pos to inc(car_pos).}
		do{ 
            set new_linha_dig_no_prompt to new_linha_dig_no_prompt + linha_digitada_no_prompt[car_pos].        
        }.
		
    // FOR c IN pontinhos_c {//PORQUE ISSO NAO DEU CERTO?
		// set car_pos to inc(car_pos).
        // debug(NOME_DA_FUNC,c).
                
	// }  
    debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length).
    debug(NOME_DA_FUNC, new_linha_dig_no_prompt + new_linha_dig_no_prompt:length).
    
    SET s TO "Hello, Strings!".    
    SET t TO s:REPLACE("Hello", "Goodbye").    
    
    //REMOVE(index,count).
    
    set linha_digitada_no_prompt to new_linha_dig_no_prompt.
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
    return new_linha_dig_no_prompt.   
    //
}.
FUNCTION apaga_ultimo_caracter{	//Apaga caracter.
	parameter debug_apaga_chars is False.
    
	local NOME_DA_FUNC is "apaga_ultimo_caracter".
    trace(NOME_DA_FUNC).
   
    debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length,debug_apaga_chars).
    if (linha_digitada_no_prompt:length > 0){
        set linha_digitada_no_prompt to linha_digitada_no_prompt:REMOVE( (linha_digitada_no_prompt:length - 1),1). //ei nao funciona
    }.
    
    debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length,debug_apaga_chars).
    
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
}.

function process_commands{		//para confirmacao de comandos > EXTRAI_COMANDO > COMANDO_EXTRAIDO > NOME_CMD_IPU

	//parameter linha_de_comando is asdfadsfdsf_COMANDO_ARMAZENADO_NO_PROMPT. 
	parameter debug_process_cmd is true.
	local COMANDO_EXTRAIDO to "".
	
	local NOME_DA_FUNC is "PROCESS_CMD".
    trace(NOME_DA_FUNC).
	
	LOCAL comandinho_digitado_modafoca is linha_digitada_no_prompt.
	print_stat(tLOG,"ENTER MODAFOCAAAAA!",contador_LOG).
    print_stat(tinfoline, "command enter: " + comandinho_digitado_modafoca, contador_infoline).//exibe na linha de informacao

    if (linha_digitada_no_prompt:length > 0){//ATUALIZA HISTORICO DE COMANDOS
        if (Hist_Com:LENGTH > 0){
                    
            //if (Hist_Com[0] <> (Hist_Com:LENGTH - 1)){//era diferente: trocar de posicao: nao precisa adicionar igual na lista
            if (Hist_Com[0] <> (0)){//era diferente: trocar de posicao: nao precisa adicionar igual na lista
                Hist_Com:REMOVE(Hist_Com[0]).
                //
            }
            else{//era igual e uma digitacao do usuario (soh que pode ser igual tambem)
                //
            }.
            //Hist_Com[Hist_Com:LENGTH - 1].
            Hist_Com:add(linha_digitada_no_prompt).
            //set Hist_Com[0] to (Hist_Com:LENGTH - 1).//devolve o ponteiro para a ultima posicao
            set Hist_Com[0] to (0).//devolve o ponteiro para a ultima posicao
            
            
        }
        else{//caso nao tenha nenhum item
            Hist_Com:add(1).
            Hist_Com:add(linha_digitada_no_prompt).
        }.
        
        //Hist_Com:LENGTH
    }.
	SET linha_digitada_no_prompt to "".
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
	
	if (MENU_esperando_valor_opcao_comando_de_exib <> "")
		{
			if (debug_process_cmd)
			{
				DEBUG(NOME_DA_FUNC,"ESPERANDO VAL:[" + MENU_esperando_valor_opcao_comando_de_exib +"]:" + comandinho_digitado_modafoca).
			}.
			
        	if (MENU_esperando_valor_opcao_comando_de_exib = NOME_CMD_get_AP_MAX)
			{
				if (TESTA_SE_STR_EH_NUMERO(comandinho_digitado_modafoca))
				{
					set OBJETIVOS_AP_MAX to comandinho_digitado_modafoca.						
				}
				else
				{					
					print_stat(tinfoline, "Erro cmd: falta par: APMAX VAL NUMERO:" + comandinho_digitado_modafoca, contador_infoline).
					
					if (debug_process_cmd)
					{
						print "debug "+NOME_DA_FUNC+": ERRO: ESPERANDO VAL: NAO EH NUM: " + comandinho_digitado_modafoca.
					}.
					
					
				}.
				
			}.
			
				set MENU_esperando_valor_opcao_comando_de_exib to "".
		}.
	
	set COMANDO_EXTRAIDO to EXTRAI_COMANDO(comandinho_digitado_modafoca).
	if (debug_process_cmd){//itens na lista
			print "debug "+NOME_DA_FUNC+": itens na lista: " + COMANDO_EXTRAIDO:length.
			print COMANDO_EXTRAIDO.
		}
	
	if (COMANDO_EXTRAIDO:length > 0){
        //CONFIGURACOES DO TERMINAL E CPU
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_IPU) )//TESTAR SE A PRIMEIRA PARTE DO COMANDO E IPU=
				{
					if (COMANDO_EXTRAIDO:length > 1)
					{
						set CONFIG_DEF_IPU to COMANDO_EXTRAIDO[1].
					}
					else
					{
						print_stat(tinfoline, "Erro cmd: falta parametro: IPU VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
					}.
				}.
                
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TELNET) )
				{
					if (COMANDO_EXTRAIDO:length > 1)
					{
						if (COMANDO_EXTRAIDO[1] = DEF_CMD_TRUE)
						{
							set CONFIG:TELNET to True.
						}.
						if (COMANDO_EXTRAIDO[1] = DEF_CMD_FALSE)
						{
							set CONFIG:TELNET to False.
						}.				
					}
					else
					{
						print_stat(tinfoline, "Erro cmd: falta parametro: TELNET ON/OFF" + comandinho_digitado_modafoca, contador_infoline).
					}.
				}.
				
            
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_STOP_TELNET_LOOP) )
			{
				print "debug: "+NOME_DA_FUNC+": " + "PARA O LOOP LOUCO REDIMENSIONA TELNET".
				scr_TERM_STOP_CHILLLLLASDKF(50,0).
			}.
                
                
        //CONTROLE DE VOO
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_LIFTOFF) )
				{
					set ready_for_takeoff to True.
					set ABORT_SEQUENCIA to False.
					
					print_stat(tinfoline, "cmd: LIFTOFF: comando reconhecido:[" + comandinho_digitado_modafoca+"]", contador_infoline).
					//fazer poderia ser aqui o comando para iniciar a ascencao
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_ABORT) )
				{
					set ABORT_SEQUENCIA to True.
					//fazer poderia ser aqui o comando para PARAR QUALQUER LOOP DE CONTROLE DE VOO
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_HOVER) )
				{
					//set ABORT_SEQUENCIA to True.
                    //HOVER_1().
                    set ready_for_HOVER to True.

				}.
                
		
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_SIMPLE_STAGING) )
			{
				print "debug: "+NOME_DA_FUNC+": " + "A very simple auto-stager using :READY".
				bem_simples_STAGING().
			}.
		//MUDANCA DE OBJETIVOS DE VOO : -------------------------------------------------
		
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_AP_MAX) )
		{
			if (COMANDO_EXTRAIDO:length > 1)
			{
				if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   set OBJETIVOS_AP_MAX to COMANDO_EXTRAIDO[1].						
				}
				else
				{					
					print_stat(tinfoline, "Erro cmd: falta parametro: APMAX VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
				}.

			}
			else
			{
				//NA VERDADE O USUARIO PODERA DIGITAR DEPOIS
				set MENU_esperando_valor_opcao_comando_de_exib to NOME_CMD_get_AP_MAX.
			}.
			
		}.	
            
		//TESTES DE SCRIPTS : -----------------------------------------------------------
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_1) ) {TESTE_1().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_2) ) {TESTE_2().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_3) ) {TESTE_3().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_4) ) {TESTE_4().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_5) ) {TESTE_5().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_6) ) {TESTE_6().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_7) ) {TESTE_7().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_8) ) {TESTE_8().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_9) ) {TESTE_9().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_10) ) {TESTE_10().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TESTE_11) ) {TESTE_11().}.			
			
		//MUDANCA DE MENUS : ------------------------------------------------------------
		if ( COMANDO_EXTRAIDO[0] = (NOME_CMD_OBJETIVOS) )
			{
				MOSTRA_MENU(MENU_OBJETIVOS).
			}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_HELP) )
			{
				MOSTRA_MENU(MENU_AJUDA).
				if (debug_process_cmd){
							DEBUG(NOME_DA_FUNC,"COMANDOS RECONHECIVEIS:").
							DEBUG(NOME_DA_FUNC,"stoplooptelnetresize").
							DEBUG(NOME_DA_FUNC,"scr").
							DEBUG(NOME_DA_FUNC,"teste_11").
							DEBUG(NOME_DA_FUNC,"teste1 A teste11").
							DEBUG(NOME_DA_FUNC,"tst1 A tst11").
							DEBUG(NOME_DA_FUNC,"hover").
							DEBUG(NOME_DA_FUNC,NOME_CMD_HOVER).
							
							DEBUG(NOME_DA_FUNC,NOME_CMD_STOP_TELNET_LOOP).
				}.
			}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_CONFIG) ) { MOSTRA_MENU(MENU_CONFIG).	}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TELA) ) { MOSTRA_MENU(MENU_TELA).	}.
			
	}// FIM EXISTE ALGUM COMANDO -----------------------------------------------------------------------------
	else{
		if (debug_process_cmd)
			{
				print "Nenhum comando encontrado na linha de comando: [" + comandinho_digitado_modafoca + "]".								
			}
    	//print_stat(tinfoline, "Erro cmd: falta comando:" + linha_digitada_no_prompt, contador_infoline).//JA EXIBE NO COMECO DA FUNCAO
	}.

	
	
}.

function EXTRAI_COMANDO{		//PARA RECONHECIMENTO DE DIVERSAS STRINGS: abort, putz, morrediabo...
	parameter LINHA_COM_CMD.
	
	local extract_prim_str_cmd is "".
	local extract_sec_str_cmd is "".
	
	local resultados_extrai_cmd is list().
	local listinha_2_de_comandos is list().//aqui fica todos os diversos comandos MESMO IRRECONHECIDOS 
		
	set listinha_2_de_comandos to extract_COMANDOS_CMD(LINHA_COM_CMD).
	
	if (listinha_2_de_comandos:length > 0){
		// reconhecendo primeiro parametro: ----------------------------------------------------------------------
		set extract_prim_str_cmd to listinha_2_de_comandos[0].
		
		if (	((extract_prim_str_cmd) = "abort")			or
		((extract_prim_str_cmd) = "putz") 			or
		((extract_prim_str_cmd) = "morrediabo") 	or
		((extract_prim_str_cmd) = NOME_CMD_ABORT) 	or
		((extract_prim_str_cmd) = "abortar") 
		)
		{resultados_extrai_cmd:add(NOME_CMD_ABORT).}.
		
		//ASDFASDF. //CUIDAR OS "=" OU " " OU " IS "  OU " TO " 
		if 	(   ((extract_prim_str_cmd) = "help") or
		((extract_prim_str_cmd) = "ajuda") or
		((extract_prim_str_cmd) = "WTF") or
		((extract_prim_str_cmd) = NOME_CMD_HELP) or
		((extract_prim_str_cmd) = "omg")
		)
		{resultados_extrai_cmd:add(NOME_CMD_HELP).}.
		if 	(   ((extract_prim_str_cmd) = "config") or
		((extract_prim_str_cmd) = "setup") or
		((extract_prim_str_cmd) = "conf") or
		((extract_prim_str_cmd) = NOME_CMD_CONFIG) or
		((extract_prim_str_cmd) = "cfg")
		){resultados_extrai_cmd:add(NOME_CMD_CONFIG).}.
		
		if 	(   ((extract_prim_str_cmd) = "stoplooptelnetresize") or
		((extract_prim_str_cmd) = "scr") or
		((extract_prim_str_cmd) = NOME_CMD_STOP_TELNET_LOOP)
		){resultados_extrai_cmd:add(NOME_CMD_STOP_TELNET_LOOP).}.
		
		if 	(   ((extract_prim_str_cmd) = "teste_11") or
		((extract_prim_str_cmd) = "teste11") or
		((extract_prim_str_cmd) = NOME_CMD_TESTE_11)
		){resultados_extrai_cmd:add(NOME_CMD_TESTE_11).}.

if (((extract_prim_str_cmd)="tst1") or ((extract_prim_str_cmd) = "teste1") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_1)){resultados_extrai_cmd:add(NOME_CMD_TESTE_1).}.
if (((extract_prim_str_cmd)="tst2") or ((extract_prim_str_cmd) = "teste2") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_2)){resultados_extrai_cmd:add(NOME_CMD_TESTE_2).}.
if (((extract_prim_str_cmd)="tst3") or ((extract_prim_str_cmd) = "teste3") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_3)){resultados_extrai_cmd:add(NOME_CMD_TESTE_3).}.
if (((extract_prim_str_cmd)="tst4") or ((extract_prim_str_cmd) = "teste4") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_4)){resultados_extrai_cmd:add(NOME_CMD_TESTE_4).}.
if (((extract_prim_str_cmd)="tst5") or ((extract_prim_str_cmd) = "teste5") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_5)){resultados_extrai_cmd:add(NOME_CMD_TESTE_5).}.
if (((extract_prim_str_cmd)="tst6") or ((extract_prim_str_cmd) = "teste6") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_6)){resultados_extrai_cmd:add(NOME_CMD_TESTE_6).}.
if (((extract_prim_str_cmd)="tst7") or ((extract_prim_str_cmd) = "teste7") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_7)){resultados_extrai_cmd:add(NOME_CMD_TESTE_7).}.
if (((extract_prim_str_cmd)="tst8") or ((extract_prim_str_cmd) = "teste8") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_8)){resultados_extrai_cmd:add(NOME_CMD_TESTE_8).}.
if (((extract_prim_str_cmd)="tst9") or ((extract_prim_str_cmd) = "teste9") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_9)){resultados_extrai_cmd:add(NOME_CMD_TESTE_9).}.
if (((extract_prim_str_cmd)="tst10") or ((extract_prim_str_cmd) = "teste10") or ((extract_prim_str_cmd) = NOME_CMD_TESTE_10)){resultados_extrai_cmd:add(NOME_CMD_TESTE_10).}.
		
if (((extract_prim_str_cmd)="HOVER") or ((extract_prim_str_cmd) = "hover") or ((extract_prim_str_cmd) = NOME_CMD_HOVER)){resultados_extrai_cmd:add(NOME_CMD_HOVER).}.

		if (	((extract_prim_str_cmd) = "stagiando")		or
		((extract_prim_str_cmd) = "staging") 		or
		((extract_prim_str_cmd) = NOME_CMD_SIMPLE_STAGING) 		or
		((extract_prim_str_cmd) = "simple_stage") 	or
		((extract_prim_str_cmd) = "stg") 	or
		((extract_prim_str_cmd) = "simple_staging") 
		)
		{resultados_extrai_cmd:add(NOME_CMD_SIMPLE_STAGING).}.
		
		if  (   ( (MENU_ultimo_exibido = MENU_OBJETIVOS) and (extract_prim_str_cmd = "1") )//1 EH MENU_POS_OBJ_APM
		or (extract_prim_str_cmd = NOME_CMD_get_AP_MAX)
		or (extract_prim_str_cmd = "apoapsis")
	    )
		{resultados_extrai_cmd:add(NOME_CMD_get_AP_MAX).}.

		
		// testes para ver quantos comandos foram reconhecidos (e parametros?) ----------------------------------------
		if (resultados_extrai_cmd:length > 0){
			//EXISTE PELO MENOS uma palavra 
			print "debug comando reconhecido: " + resultados_extrai_cmd[0].
		}
		else{
			print_stat(tinfoline, "command_extr: comando NAO RECONHECIDO: " + LINHA_COM_CMD, contador_infoline).
			//isso vai dar um resultado gernerico: #FAZER :#VER : SEPARAR POR PARAMETRO DESCONHECIDO
			resultados_extrai_cmd:add(extract_prim_str_cmd).
		}.
		
		
		
		if (listinha_2_de_comandos:length > 1){//para os demais sem definicao ainda sao carregados na lista no final
			set extract_sec_str_cmd  to listinha_2_de_comandos[1].	
			
			// reconhecendo segundo parametro: ----------------------------------------------------------------------
			if (    ((extract_sec_str_cmd = "sim")) or
			((extract_sec_str_cmd = "yes")) or 
			((extract_sec_str_cmd = "active")) or 
			((extract_sec_str_cmd = DEF_CMD_TRUE)) or 
			((extract_sec_str_cmd = "ativo")) or 
			((extract_sec_str_cmd = "ativar")) or 
			((extract_sec_str_cmd = "1")) or 
			((extract_sec_str_cmd = "um")) or 
			((extract_sec_str_cmd = "one")) or 
			((extract_sec_str_cmd = "uno")) or 
			((extract_sec_str_cmd = "liga porra")) or 
			((extract_sec_str_cmd = "on")) or 
			((extract_sec_str_cmd = "ligar")) 
			)
			{
				set valor_q_importa_1 to DEF_CMD_TRUE.//fazer pra que isso?
				//DEF_CMD_FALSE fazer
				resultados_extrai_cmd:add(DEF_CMD_TRUE).
			}.		
			
			// testes para ver quantos parametros foram reconhecidos ----------------------------------------
			if (resultados_extrai_cmd:length > 1){//para os demais sem definicao ainda sao carregados na lista no final
				//EXISTE PELO MENOS duas palavras> um parametro entao
				print "debug parametro reconhecido: " + resultados_extrai_cmd[1].
			}
			else{
				print_stat(tinfoline, "command_extr: parametro NAO RECONHECIDO: " + LINHA_COM_CMD, contador_infoline).
				//isso vai ARMAZENAR um resultado gernerico: #FAZER :#VER
				resultados_extrai_cmd:add(extract_sec_str_cmd).
			}.
			
			// pegando restante dos parametros [3...] NAO RECONHECIDOS: ---------------------------------------------------
			IF (listinha_2_de_comandos:length > 2)
			{//FAZER para pegar mais parametros
				print "debug existem:[" + (listinha_2_de_comandos:length - 1) +"]parametros: reconhecidos[" + (resultados_extrai_cmd:length -1) + "]" .
				from {local item_comando is 2.} //3(len) - 1 = 2
				until (item_comando = listinha_2_de_comandos:length)
				step {set item_comando to item_comando + 1.}
				do {
					print "debug parametro reconhecido: " + listinha_2_de_comandos[item_comando].
					resultados_extrai_cmd:add(listinha_2_de_comandos[item_comando]).
				}.			
			}.
			
			
			
			
			
		}.
		
		
		
	}
	else{
		print_stat(tinfoline, "command_extr: nenhum comando: " + LINHA_COM_CMD, contador_infoline).
	}.


	
	
	return resultados_extrai_cmd.
}.

function extract_COMANDOS_CMD{	//processa toda a string enviada e separa as palavras
	parameter STRING_COMPLETA.
	parameter debug_extr_cmd_comands is True.
	local debug_extr_cmd_comands_agressive is False.
	//			 ( STRING_COMPLETA[count_s] <> "=" ) 
	local lista_de_comandos_encontrados is list().
	local ENCONTROU_algUMA_LETRA is false.
	local nova_str_CMD is "".
	local CARACTERES_PERMITIDOS_CMD is "abcdefghijklmnopqrstuvwxyz1234567890+-*/[]()#$%@:;.,?!<>_".
	local CARACTERES_DIVISORES_CMD is " =". //O ESPACO TBM
	local count_s is 0.

	from {set count_s to 0.}
	until(count_s = STRING_COMPLETA:length )
	step{set count_s to count_s + 1.}
	do
	{//nao usar ELSE pois existem caracteres que nao precisam/devem ser processados aqui

		if (debug_extr_cmd_comands_agressive)
		{
			print "DEBUG: EXTR_CMD:[" + STRING_COMPLETA[count_s] + "] on pos[" +count_s+"]".
			//print "DEBUG: EXTR_CMD: teste find:[" + "}" + "] on pos[" + CARACTERES_PERMITIDOS_CMD:find( "}" ) +"]".//da -1
		}.
		if ( CARACTERES_PERMITIDOS_CMD:find( STRING_COMPLETA[count_s] ) > (- 1) )//fazer testar isso
		{//se o caracter atual esta na lista de caracteres permitidos em um comando:
			set ENCONTROU_algUMA_LETRA to True.
			set nova_str_CMD to nova_str_CMD + STRING_COMPLETA[count_s].
   			set ENCONTROU_algUMA_LETRA to True.
			if (debug_extr_cmd_comands_agressive)
				{print "DEBUG: EXTR_CMD: caracter normal[" + STRING_COMPLETA[count_s] + "] on pos[" +count_s+"]".	}.
		}.
		
		//print STR_COMPOSTA_DE_NUMERO[count_s].
		if  (  (    (CARACTERES_DIVISORES_CMD:find( STRING_COMPLETA[count_s] ) > (- 1))
         		 or (count_s = (STRING_COMPLETA:length - 1))//nao pode ser else if pois o count_s = len-1 sera na mesma posicao do ultimo encontrado
			    )
		 		 and (ENCONTROU_algUMA_LETRA)
			)
			 {
				if ((debug_extr_cmd_comands_agressive)  and (count_s <> (STRING_COMPLETA:length - 1) ))
					{print "DEBUG: EXTR_CMD: caracter separador[" + STRING_COMPLETA[count_s] + "] on pos[" +count_s+"]".	}.
				lista_de_comandos_encontrados:add(nova_str_CMD).
				if (debug_extr_cmd_comands)
				{
					print "DEBUG: EXTR_CMD: add cmd:" + nova_str_CMD.
				}.
				set nova_str_CMD to "".
     			set ENCONTROU_algUMA_LETRA to False.
			 }.
		if (     ( CARACTERES_PERMITIDOS_CMD:find( STRING_COMPLETA[count_s] ) = (- 1) )
		      and ((CARACTERES_DIVISORES_CMD:find( STRING_COMPLETA[count_s] ) = (- 1)))
				
			)
			 {
				print "debug: extr_cmd: caracter nao reconhecido! :[" +STRING_COMPLETA[count_s]+ "]".
			 }.
		
	}
	
	if (debug_extr_cmd_comands_agressive)
		{ print "DEBUG: EXTR_CMD: encontrados:" .
		  print lista_de_comandos_encontrados.
		}.
	
	return lista_de_comandos_encontrados.
}.

function process_one_char{      //para seleção de opcoes
	parameter caracter.
	print_stat(tprintcar,caracter,contador_car).
}.
function process_more_char{     //para entrada de instrucoes 
	parameter caracter.
	set linha_digitada_no_prompt to linha_digitada_no_prompt + caracter.
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
}.

