@LAZYGLOBAL OFF.
//c3_cmd.ks
// 7 funcoes: 490 linhas
//recompila

	//uses: BLAH
runoncepath("c3_init_vars").

// ====      FUNCOES BASE PARA ENTRADA DE COMANDOS =========================================================================
if (1=0){
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
}.
FUNCTION PROCESS_KEYBOARD{		//DECIDE O QUE FAZER COM O "CARACTER_PEGADO" > process_commands() OU process_more_char().
	parameter CARACTER_PEGADO.
	local NOME_DA_FUNC is "PROCESS_KEYBD".
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).

    beep("key").

	if (CARACTER_PEGADO = terminal:input:RETURN){	//para confirmacao de comandos com ENTER (atualiza menu)
			process_commands().
			MOSTRA_MENU(MENU_ultimo_exibido, True).//para atualizar o menu
			//fazer limpar a linha de comando somente aqui para diminuir o delay
		}
        
	else if  CARACTER_PEGADO = terminal:input:UPCURSORONE {	//para navegar acima no modo menu, anterior CMD armazenado no modo CMD_LINE
        CICLA_CMD_P_CIMA().
	}
        
	else if  CARACTER_PEGADO = terminal:input:DOWNCURSORONE{	//para navegar abaixo no modo menu, proximo CMD armazenado no modo CMD_LINE
        CICLA_CMD_P_BAIXO().
	}
        
	else if  CARACTER_PEGADO = terminal:input:BACKSPACE {		//para FAZER:VOLTAR UM NIVEL DE MENU, apagar um caracter no modo CMD_LINE
		    apaga_ultimo_caracter().
            if (Hist_Com:LENGTH > 0){
                set Hist_Com[0] to (Hist_Com:LENGTH - 1).//devolve o ponteiro para a ultima posicao
            }.
		}
    else{
        
        if (not( process_one_char(CARACTER_PEGADO) //para seleção de opcoes        
           )){//se o process_one_char NAO FEZ NADA
                process_more_char(CARACTER_PEGADO). //para entrada de instrucoes 
                //
            }
            else{
                //
            }.
    }.

}.

FUNCTION apaga_ultimo_LOOPcaracter_NU{      //NÃO UTILIZADO
	//parameter linha_digitada_no_prompt.
	//fazer
	print "debug: Apaga caracter: FAZER.".
    
	local NOME_DA_FUNC is "apaga_ultimo_caracter".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
   
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
    set hops to inc(hops).
  
    debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length,debug_apaga_chars).
    if (linha_digitada_no_prompt:length > 0){
        set linha_digitada_no_prompt to linha_digitada_no_prompt:REMOVE( (linha_digitada_no_prompt:length - 1),1). //ei nao funciona
    }.
    
    debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length,debug_apaga_chars).
    
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
}.

function process_commands{		//para confirmacao de comandos > EXTRAI_COMANDO > COMANDO_EXTRAIDO > NOME_CMD_IPU

	//parameter linha_de_comando is asdfadsfdsf_COMANDO_ARMAZENADO_NO_PROMPT. 
	parameter debug_process_cmd is false.
	local COMANDO_EXTRAIDO to "".
	
	local NOME_DA_FUNC is "PROCESS_CMD".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	
	LOCAL comandinho_digitado_modafoca is linha_digitada_no_prompt.
	print_stat(tLOG,"ENTER MODAFOCAAAAA!",contador_LOG).
    print_stat(tinfoline, "command enter: " + comandinho_digitado_modafoca, contador_infoline).//exibe na linha de informacao
    beep("cmd").

    if (linha_digitada_no_prompt:length > 0){//ATUALIZA HISTORICO DE COMANDOS
        if (Hist_Com:LENGTH > 0){
                    
            //if (Hist_Com[0] <> (Hist_Com:LENGTH - 1)){//era diferente: trocar de posicao: nao precisa adicionar igual na lista
            if (Hist_Com[0] <> (Hist_Com:LENGTH)){//era diferente: trocar de posicao: nao precisa adicionar igual na lista
                Hist_Com:REMOVE(Hist_Com[0]).
                debug(NOME_DA_FUNC,"troca de posicao", debug_process_cmd).
            }
            else{//era igual e uma digitacao do usuario (soh que pode ser igual tambem)
                //
            }.
            //Hist_Com[Hist_Com:LENGTH - 1].
            debug(NOME_DA_FUNC,"add com:"+linha_digitada_no_prompt, debug_process_cmd).
            Hist_Com:add(linha_digitada_no_prompt).
            //set Hist_Com[0] to (Hist_Com:LENGTH - 1).//devolve o ponteiro para a ultima posicao
            set Hist_Com[0] to (Hist_Com:LENGTH).//devolve o ponteiro para a ultima posicao
        }
        else{//caso nao tenha nenhum item
            debug(NOME_DA_FUNC,"add primeiro:"+linha_digitada_no_prompt, debug_process_cmd).
            Hist_Com:add(2).//somente marca o prim
            Hist_Com:add(linha_digitada_no_prompt).
            set Hist_Com[0] to (Hist_Com:LENGTH).//devolve o ponteiro para a ultima posicao
        }.
        
        //Hist_Com:LENGTH
    }.
	SET linha_digitada_no_prompt to "".
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
	
	if (MENU_esperando_valor_opcao_comando_de_exib <> ""){
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
	
    if (MENU_esperando_valor_opcao_num_de_MENU){
        set MENU_esperando_valor_opcao_num_de_MENU to False.        //estava esperando valores e tinha desativado o menu> ativa novamente
    }.
	set COMANDO_EXTRAIDO to EXTRAI_COMANDO(comandinho_digitado_modafoca).
	if (debug_process_cmd){//itens na lista
			print "debug "+NOME_DA_FUNC+": itens na lista: " + COMANDO_EXTRAIDO:length.
			print COMANDO_EXTRAIDO.
		}
	
	if (COMANDO_EXTRAIDO:length > 0){
        //CONFIGURACOES DO TERMINAL E CPU
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_IPU) ){			//has help
		//TESTAR SE A PRIMEIRA PARTE DO COMANDO E IPU=
					if (COMANDO_EXTRAIDO:length > 1)
					{
						if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
						{
						    print_stat(tlog, "CONFIG:IPU IPU antes: " + CONFIG:IPU, contador_log).
						    print_stat(tlog, "CONFIG_DEF_IPU antes: " + CONFIG_DEF_IPU, contador_log).
						    //print_stat(tlog, "tipo CONFIG_DEF_IPU: " + CONFIG_DEF_IPU:typename, contador_log).
							
						   //set OBJETIVOS_AP_MAX to COMANDO_EXTRAIDO[1]:tonumber(0).
							set CONFIG_DEF_IPU to COMANDO_EXTRAIDO[1]:tonumber(0).
						   
						    print_stat(tlog, "CONFIG_DEF_IPU get: " + CONFIG_DEF_IPU, contador_log).
							set CONFIG:IPU to CONFIG_DEF_IPU.
						}//CONVERTE_STR_TO_NUM()
						else
						{					
							print_stat(tinfoline, "Erro cmd: falta parametro: APMAX VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
						}.
					}
					else
					{
						print_stat(tinfoline, "Erro cmd: falta parametro: ["+NOME_CMD_IPU+"] VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
					}.
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_COL1_POS) ){	//has help
					if (COMANDO_EXTRAIDO:length > 1)
					{   set pos_col_left to COMANDO_EXTRAIDO[1].
                        REDESENHA_TELA().}
					else
					{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_COL1_POS+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
				}.
                
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_REDES_TELA) ){ REDESENHA_TELA().}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_ESP_COLS) ){
					if (COMANDO_EXTRAIDO:length > 1)
					{   set espaco_entre_colunas to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
                        REDESENHA_TELA().}
					else
					{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_ESP_COLS+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_SEND_MSG) ){
				if (COMANDO_EXTRAIDO:length > 1)
				{
					if (COMANDO_EXTRAIDO:length > 2){
						//SENDMSG(DESTINO, MENSAGEM, debug, hud).
			            HANDLE_CONNECTION_VESSELS(COMANDO_EXTRAIDO[1], COMANDO_EXTRAIDO[2], True).
					}
					else { print_stat(tinfoline, "Erro cmd: falta parametro: MENSAGEM" + comandinho_digitado_modafoca, contador_infoline). }.
				}
				else { print_stat(tinfoline, "Erro cmd: falta parametro: DESTINO" + comandinho_digitado_modafoca, contador_infoline). }.
			}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_SEND_MSG_CORE) ){
				if (COMANDO_EXTRAIDO:length > 1)
				{
					if (COMANDO_EXTRAIDO:length > 2){
						//SENDMSG(DESTINO, MENSAGEM, debug, hud).
			            HANDLE_CONNECTION_CORES(COMANDO_EXTRAIDO[1], COMANDO_EXTRAIDO[2], True).
					}
					else { print_stat(tinfoline, "Erro cmd: falta parametro: MENSAGEM" + comandinho_digitado_modafoca, contador_infoline). }.
				}
				else { print_stat(tinfoline, "Erro cmd: falta parametro: DESTINO" + comandinho_digitado_modafoca, contador_infoline). }.
			}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_TELNET) ){
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
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_STOP_TELNET_LOOP) ){
				print "debug: "+NOME_DA_FUNC+": " + "PARA O LOOP LOUCO REDIMENSIONA TELNET".
				scr_TERM_STOP_CHILLLLLASDKF().
			}.
        //CONTROLE DE VOO
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_LIFTOFF) 	){
					set ready_for_takeoff to True.
					set ABORT_SEQUENCIA to False.
					
					print_stat(tinfoline, "cmd: LIFTOFF: comando reconhecido:[" + comandinho_digitado_modafoca+"]", contador_infoline).
					//fazer poderia ser aqui o comando para iniciar a ascencao
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_ABORT) 		){
					set ABORT_SEQUENCIA to True.
					//fazer poderia ser aqui o comando para PARAR QUALQUER LOOP DE CONTROLE DE VOO
				}.
		if ((COMANDO_EXTRAIDO[0] = NOME_CMD_HOVER ) or (COMANDO_EXTRAIDO[0] = NOME_CMD_get_HOVER)){//has help
					if (COMANDO_EXTRAIDO:length > 1)
					{
						local str_temp_hover to COMANDO_EXTRAIDO[1].
						local str_sinal_hover to "".
								//print "debug: " + str_temp_hover.
								//print "debug: " + str_sinal_hover.

						if (str_temp_hover[0] = "-") or (str_temp_hover[0] = "+"){
								set str_sinal_hover to str_temp_hover[0].
								//remove o sinal do segundo parametro
								SET str_temp_hover TO str_temp_hover:SUBSTRING(1,( str_temp_hover:LENGTH-1)).
								//print "debug[str_temp_hover]: " + str_temp_hover.
								//print "debug[str_sinal_hover]: " + str_sinal_hover.
								//String:SUBSTRING(start,count)  	 Returns:	    String
								//   Parameters:	start – Scalar (integer) starting index (from zero)
								//				    count – Scalar (integer) resulting length of returned String
								//    Returns a new string with the given count of characters from this string starting from the given start position.					
						}
						//print "debug[str_temp_hover]: " + str_temp_hover.
						//print "debug[str_sinal_hover]: " + str_sinal_hover.

						if (TESTA_SE_STR_EH_NUMERO(str_temp_hover))
						{
							local int_alt_hover to CONVERTE_STR_TO_NUM(str_temp_hover).
							if (str_sinal_hover = "+"){
								set OBJETIVOS_HOVER_ALT to alt:radar + int_alt_hover.
								//print "debug: " + str_sinal_hover.
							}
							else if (str_sinal_hover = "-"){
								set OBJETIVOS_HOVER_ALT to alt:radar - int_alt_hover.
							}
							else{
								set OBJETIVOS_HOVER_ALT to int_alt_hover.
							}
								//OBJETIVOS_HOVER_ALT + alt:radar//NOME_CMD_get_HOVER
						}
						else
						{ print_stat(tinfoline, "Erro cmd: nao numero: param invalid: "+NOME_CMD_HOVER+" VAL NUMERO [" + comandinho_digitado_modafoca+"]", contador_infoline).
							debug(NOME_DA_FUNC, "Erro cmd: nao numero: param invalid: "+NOME_CMD_HOVER+" VAL NUMERO [" + comandinho_digitado_modafoca+"]").
							set OBJETIVOS_HOVER_ALT to alt:radar.
						}.
					}
					else
					{ print_stat(tinfoline, "Info cmd: alt nao especf: "+NOME_CMD_HOVER+" VAL NUMERO [" + comandinho_digitado_modafoca+"]", contador_infoline).
						debug(NOME_DA_FUNC, "Info cmd: alt nao especf: "+NOME_CMD_HOVER+" VAL NUMERO[" + comandinho_digitado_modafoca+"]").
						set OBJETIVOS_HOVER_ALT to alt:radar.
					}.					
					print_stat(tlog,"HOVER AT RADAR"+ round((OBJETIVOS_HOVER_ALT),1) +"!",contador_log).
                    //HOVER_1().
                    set ready_for_HOVER to True.
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_QUEDA) 		){
						if (COMANDO_EXTRAIDO:length > 1){
							if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
							{
								set OBJETIVOS_HOVER_ALT to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
							}
							else
							{ print_stat(tinfoline, "Erro cmd: nao numero: param invalid: "+NOME_CMD_QUEDA+" VAL NUMERO [" + comandinho_digitado_modafoca+"]", contador_infoline).
								debug(NOME_DA_FUNC, "Erro cmd: nao numero: param invalid: "+NOME_CMD_QUEDA+" VAL NUMERO [" + comandinho_digitado_modafoca+"]").
								set OBJETIVOS_HOVER_ALT to OBJETIVOS_QUEDA_HOV_ALT.
							}.
						}
						else
						{ print_stat(tinfoline, "Info cmd: alt nao especf: "+NOME_CMD_QUEDA+" VAL NUMERO [" + comandinho_digitado_modafoca+"]", contador_infoline).
							debug(NOME_DA_FUNC, "Info cmd: alt nao especf: "+NOME_CMD_QUEDA+" VAL NUMERO[" + comandinho_digitado_modafoca+"]").
							set OBJETIVOS_HOVER_ALT to OBJETIVOS_QUEDA_HOV_ALT.
						}.
						set ready_for_QUEDA to True.
	                    //QUEDA_CONTROLADA(OBJETIVOS_HOVER_ALT).
						print_stat(tlog,"CNTRL QUEDA: "+ round((OBJETIVOS_HOVER_ALT),1) +"!",contador_log).
						//MOSTRA_MENU(MENU_CTRL_QUEDA).
				}.

		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_STAGE) 		){		//has help
                    stage.
				}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_SEPARATION) ){
					SEPARAR_OS_LANDERS().
				}.
				
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_REBOOT) 	){//comandos digitados tem prioridade sobre o loop principal
                    //PREPARA_REBOOT(modo_de_exec_do_prog).
                    PREPARA_REBOOT(parameter_modo_exec, NOME_CMD_REBOOT).
				}.              
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_RECOVERY_BOOT) 	){//comandos digitados tem prioridade sobre o loop principal
                    //PREPARA_REBOOT(modo_de_exec_do_prog).
                    PREPARA_REBOOT(parameter_modo_exec, NOME_CMD_RECOVERY_BOOT).
				}.              
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_BEEP) 		){
			if (COMANDO_EXTRAIDO:length > 2)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
					if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[2]))
					{
						BEEP("especificado",False, (CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]))/1000, CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[2])).//NOME_CMD_BEEP
					}
                	else
					{ print_stat(tinfoline, "Erro cmd: falta parametro NUM: "+NOME_CMD_BEEP+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro NUM: "+NOME_CMD_BEEP+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_BEEP+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.  }.              
		
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_SIMPLE_STAGING) ){
				print "debug: "+NOME_DA_FUNC+": " + "A very simple auto-stager using :READY".
				bem_simples_STAGING().
			}.
		//MUDANCA DE OBJETIVOS DE VOO : -------------------------------------------------
		
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_AP_MAX) ){
			if (COMANDO_EXTRAIDO:length > 1){
				if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
                    print "ap max antes: " + OBJETIVOS_AP_MAX.
                    print "tipo: " + OBJETIVOS_AP_MAX:typename.
				   set OBJETIVOS_AP_MAX to COMANDO_EXTRAIDO[1]:tonumber(0).
                    print "ap max get: " + OBJETIVOS_AP_MAX.
                    print "tipo: " + OBJETIVOS_AP_MAX:typename.
				}//CONVERTE_STR_TO_NUM()
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

		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_HLAT)  	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_HEAD_LAT to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_HLAT+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_HLAT+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_INCL)  	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_HEAD_INCL to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_INCL+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_INCL+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_INCG)  	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_THRTL_MAX to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: nao numero: falta parametro: "+NOME_CMD_get_INCG+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
					debug(NOME_DA_FUNC, "Erro cmd: nao numero: falta parametro: "+NOME_CMD_get_INCG+" VAL NUMERO" + comandinho_digitado_modafoca).
				}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_INCG+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).
				debug(NOME_DA_FUNC, "Erro cmd: falta parametro: "+NOME_CMD_get_INCG+" VAL NUMERO[" + comandinho_digitado_modafoca+"]").
			}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_VMAX)  	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_VE_MAX to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd:  nao numero: falta parametro: "+NOME_CMD_get_VMAX+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_VMAX+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_VMATM) 	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_VE_MAX_ATM to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_VMATM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_VMATM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_PE)    	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_PE_MIN to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_PE+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_PE+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.       
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_THRM) 	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_THRTL_MAX to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_THRM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_THRM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_HLAT) 	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_HEAD_LAT to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_HLAT+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_HLAT+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
		}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_get_STGM) 	){
			if (COMANDO_EXTRAIDO:length > 1)
			{
                if (TESTA_SE_STR_EH_NUMERO(COMANDO_EXTRAIDO[1]))
				{
				   	set OBJETIVOS_STAG_MAX_ASC to CONVERTE_STR_TO_NUM(COMANDO_EXTRAIDO[1]).
				}
                else
				{ print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_STGM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
            }
            else
            { print_stat(tinfoline, "Erro cmd: falta parametro: "+NOME_CMD_get_STGM+" VAL NUMERO" + comandinho_digitado_modafoca, contador_infoline).}.
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
		if ( COMANDO_EXTRAIDO[0] = (NOME_CMD_OBJETIVOS) ){
				MOSTRA_MENU(MENU_OBJETIVOS).
			}.
		if (COMANDO_EXTRAIDO[0] = (NOME_CMD_HELP) ){
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
							DEBUG(NOME_DA_FUNC,NOME_CMD_STAGE).
                            
							
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
	local NOME_DA_FUNC is "EXTRAI_COMANDO".
    
    trace(NOME_DA_FUNC).
	
    set hops to inc(hops).
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
if (((extract_prim_str_cmd)="STAGE") or ((extract_prim_str_cmd) = "stage") or ((extract_prim_str_cmd) = NOME_CMD_STAGE)){resultados_extrai_cmd:add(NOME_CMD_STAGE).}.
if (((extract_prim_str_cmd)="COL1_POS") or ((extract_prim_str_cmd) = "col1_pos") or ((extract_prim_str_cmd) = NOME_CMD_COL1_POS)){resultados_extrai_cmd:add(NOME_CMD_COL1_POS).}.
if (((extract_prim_str_cmd)="ESP_COLS") or ((extract_prim_str_cmd) = "esp_cols") or ((extract_prim_str_cmd) = NOME_CMD_ESP_COLS)){resultados_extrai_cmd:add(NOME_CMD_ESP_COLS).}.
if (((extract_prim_str_cmd)="REDES_TELA") or ((extract_prim_str_cmd) = "redes_tela") or ((extract_prim_str_cmd) = NOME_CMD_REDES_TELA)){resultados_extrai_cmd:add(NOME_CMD_REDES_TELA).}.

        if (((extract_prim_str_cmd)="STGMAX") or ((extract_prim_str_cmd) = "stgmax") or ((extract_prim_str_cmd) = NOME_CMD_get_STGM)){resultados_extrai_cmd:add(NOME_CMD_get_STGM).}.
        //if (((extract_prim_str_cmd:toupper)="REBOOT") or ((extract_prim_str_cmd:tolower) = "reboot") or ((extract_prim_str_cmd) = NOME_CMD_REBOOT)){resultados_extrai_cmd:add(NOME_CMD_REBOOT).}.
        if (((extract_prim_str_cmd:tolower) = "reboot") or ((extract_prim_str_cmd) = NOME_CMD_REBOOT)){resultados_extrai_cmd:add(NOME_CMD_REBOOT).}.

        if (((extract_prim_str_cmd:tolower) = "hlat") or ((extract_prim_str_cmd) = NOME_CMD_get_HLAT)){resultados_extrai_cmd:add(NOME_CMD_get_HLAT).}.
        if (((extract_prim_str_cmd:tolower) = "incl") or ((extract_prim_str_cmd) = NOME_CMD_get_INCL)){resultados_extrai_cmd:add(NOME_CMD_get_INCL).}.
        if (((extract_prim_str_cmd:tolower) = "incg") or ((extract_prim_str_cmd) = NOME_CMD_get_INCG)){resultados_extrai_cmd:add(NOME_CMD_get_INCG).}.
        if (((extract_prim_str_cmd:tolower) = "vmax") or ((extract_prim_str_cmd) = NOME_CMD_get_VMAX)){resultados_extrai_cmd:add(NOME_CMD_get_VMAX).}.
        if (((extract_prim_str_cmd:tolower) = "vmatm") or ((extract_prim_str_cmd) = NOME_CMD_get_VMATM)){resultados_extrai_cmd:add(NOME_CMD_get_VMATM).}.
        if (((extract_prim_str_cmd:tolower) = "pe") or ((extract_prim_str_cmd) = NOME_CMD_get_PE)){resultados_extrai_cmd:add(NOME_CMD_get_PE).}.
        if (((extract_prim_str_cmd:tolower) = "thrm") or ((extract_prim_str_cmd) = NOME_CMD_get_THRM)){resultados_extrai_cmd:add(NOME_CMD_get_THRM).}.

        if (((extract_prim_str_cmd:tolower) = "beep") or ((extract_prim_str_cmd) = NOME_CMD_BEEP)){resultados_extrai_cmd:add(NOME_CMD_BEEP).}.

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
			DEBUG(NOME_DA_FUNC, "debug comando reconhecido: " + resultados_extrai_cmd[0],false).
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
			//((extract_sec_str_cmd = "1")) or //O 1 ENTRA EM CONFLITO COM NUMEROS
			((extract_sec_str_cmd = "um")) or 
			((extract_sec_str_cmd = "one")) or 
			((extract_sec_str_cmd = "uno")) or 
			((extract_sec_str_cmd = "liga porra")) or 
			((extract_sec_str_cmd = "on")) or 
			((extract_sec_str_cmd = "ligar")) 
			)
			{
				//set valor_q_importa_1 to DEF_CMD_TRUE.//fazer pra que isso?
				//DEF_CMD_FALSE fazer
				resultados_extrai_cmd:add(DEF_CMD_TRUE).
			}.
			if (    (TESTA_SE_STR_EH_NUMERO(extract_sec_str_cmd)) ){
				resultados_extrai_cmd:add(extract_sec_str_cmd).//MANDA COMO STRING AINDA
			}.
			
			// testes para ver quantos parametros foram reconhecidos ----------------------------------------
			if (resultados_extrai_cmd:length > 1){//para os demais sem definicao ainda sao carregados na lista no final
				//EXISTE PELO MENOS duas palavras> um parametro entao
				print "debug parametro reconhecido: " + resultados_extrai_cmd[1].
			}
			else{
				print_stat(tinfoline, "cmd_extr: 2parametro DESCONHECIDO: " + LINHA_COM_CMD, contador_infoline).
				DEBUG(NOME_DA_FUNC, "cmd_extr: 2parametro DESCONHECIDO: " + LINHA_COM_CMD,TRUE).
				//isso vai ARMAZENAR um resultado gernerico: #FAZER :#VER
				resultados_extrai_cmd:add(extract_sec_str_cmd).
			}.
			
			// pegando restante dos parametros [3...] NAO RECONHECIDOS: ---------------------------------------------------
			IF (listinha_2_de_comandos:length > 2)
			{//FAZER para pegar mais parametros
				
				DEBUG(NOME_DA_FUNC, "existem:[" + (listinha_2_de_comandos:length - 1) +"]parametros: reconhecidos[" + (resultados_extrai_cmd:length -1) + "]",TRUE).
				from {local item_comando is 2.} //3(len) - 1 = 2
				until (item_comando = listinha_2_de_comandos:length)
				step {set item_comando to item_comando + 1.}
				do {
					DEBUG(NOME_DA_FUNC, "parametro reconhecido: " + listinha_2_de_comandos[item_comando],TRUE).
					resultados_extrai_cmd:add(listinha_2_de_comandos[item_comando]).
				}.			
			}.
			
			
			
			
			
		}.
		
		
		
	}
	else{
		print_stat(tinfoline, "cmd_extr: nenhum comando: " + LINHA_COM_CMD, contador_infoline).
	}.


	
	
	return resultados_extrai_cmd.
}.

function extract_COMANDOS_CMD{	//processa toda a string enviada e separa as palavras
	parameter STRING_COMPLETA.
	parameter debug_extr_cmd_comands is False.

    set hops to inc(hops).
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

function process_one_char{      //para seleção de opcoes: SE RETORNAR FALSO O PROCESS_MORE_CHARS EXECUTA
	parameter caracter.
	print_stat(tprintcar,caracter,contador_car).

	local NOME_DA_FUNC is "process_one_char".
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    if (linha_digitada_no_prompt:length = 0){//se soh tiver um caracter no promptcmd
        //
        set MENU_esperando_valor_opcao_num_de_MENU to False.//ativa menu
        if (caracter = CHAR_MENU_OPC_volta_menu_inic){//se for o simbolo para voltar AO INICIAL
            MOSTRA_MENU(MENU_PRINCIPAL).
            return True.
        }.
    }
    else{
        set MENU_esperando_valor_opcao_num_de_MENU to True.//DESativa menu

    }.
    
    if (linha_digitada_no_prompt:length = 0){
    }.
    
    //mostrar o menu correspondente ou preencher o cmd_line com o comeco do programa para o usuario digitar o valor:
    if (TESTA_SE_STR_EH_NUMERO(caracter) and not(MENU_esperando_valor_opcao_num_de_MENU) ){
        //DEBUG(NOME_DA_FUNC, "Eh numero!").
        return ONE_CHAR_PARA_MENU(caracter).
    }
    else{
        //DEBUG(NOME_DA_FUNC, "NAO Eh numero!").
        return False.
        //
    }.
}.
function process_more_char{     //para entrada de instrucoes 
	parameter caracter.
    set hops to inc(hops).
	set linha_digitada_no_prompt to linha_digitada_no_prompt + caracter.
	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
    
    //print_stat(tlista, CONCAT_STR_A(linha_digitada_no_prompt,espaco_entre_colunas),contador_list).
}.

FUNCTION ATUALIZA_VAR_PROMPT_CMD{//para menu esperando opcao num
    parameter NOVO_PROMPT_CMD.
	parameter HELP_VAR_PROMPT_CMD is "".

    set hops to inc(hops).
    //debug(NOME_DA_FUNC, linha_digitada_no_prompt + linha_digitada_no_prompt:length,debug_apaga_chars).
    set linha_digitada_no_prompt to NOVO_PROMPT_CMD.
    
	beep("attention", True, 0.2).
	wait 0.1.
	beep("attention", True, 0.2).

	print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
	print_stat(tinfoline, "Complete o cmd com parametros: "+HELP_VAR_PROMPT_CMD, contador_infoline).	
    set MENU_esperando_valor_opcao_num_de_MENU to True.
}.


FUNCTION get_terminal_str_e_enter{          //funcao como a SET /P DO CMD
    parameter Tipo_do_valor_retornar is "String".
    
    set hops to inc(hops).
    local entrou_enter      is False.
    local str_pegada        is "".
    local CARACTER_entrado  is "".
    // Read a char if it exists, else just keep going:
    until (entrou_enter){
        if terminal:input:haschar {
            set CARACTER_entrado to terminal:input:getchar().
            
            if (CARACTER_entrado = terminal:input:RETURN){
                return converte_str(str_pegada, Tipo_do_valor_retornar).
            }
            else if (CARACTER_entrado = terminal:input:BACKSPACE){
                print "get_terminal_str_e_enter: CANCELADA_GET_STR".
                return "CANCELADA_GET_STR".
            }
            else{
                set str_pegada to str_pegada + CARACTER_entrado.
                //print str_pegada + "                  " at (20, 0).
                print_stat(tprintCMD, str_pegada, contador_CMD).
                print_stat(tprintcar, str_pegada, contador_car).
                //usar tprintcar para nao criar varis linhas quando tiver
            }.
        }.
    }
}.

				   //set OBJETIVOS_AP_MAX to COMANDO_EXTRAIDO[1]:tonumber(0).
FUNCTION converte_str{                      //CONVERTE str para tipo desejado
    parameter STRING_CONVERTER.
    parameter Tipo_do_valor_retornar.
    set hops to inc(hops).
    
    if (Tipo_do_valor_retornar = "String"){
        return STRING_CONVERTER.
    }
    else if (Tipo_do_valor_retornar = "Scalar"){
        if (TESTA_SE_STR_EH_NUMERO(STRING_CONVERTER)){
            return CONVERTE_STR_TO_NUM(STRING_CONVERTER).
        }
        else{
            return 0.
        }.
    }
    else if (Tipo_do_valor_retornar = "Boolean"){//denovo
        if ( STRING_CONVERTER = "True") or (STRING_CONVERTER = "verdadeiro")  or (STRING_CONVERTER = "1")
            or (STRING_CONVERTER = "on") or (STRING_CONVERTER = "ON") 
            { return True. }
        else if (
            (STRING_CONVERTER = "False") or (STRING_CONVERTER = "falso")  or (STRING_CONVERTER = "0")
            or (STRING_CONVERTER = "off") or (STRING_CONVERTER = "OFF")
        )
        { return False. }
        else{
            print "ERRO: converte_str: valor INFORMADO nao reconhecido! : [" +STRING_CONVERTER+"]".
            return 0.            
        }.
    }
    else{
        print "ERRO: converte_str: NENHUM TIPO DEFINIDO INFORMADO! : [" +Tipo_do_valor_retornar+"]".
        return 0.
    }.
    //tolower
    //toupper
    //string:tonumber(def_em_caso_de_erro)
}.


