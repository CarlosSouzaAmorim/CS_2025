@LAZYGLOBAL OFF.
//c3_scr_msg.ks
//recompila

//uses: debug_level_trace in vars
runoncepath("c3_init_vars").
// 23 funcoes: 948 linhas



// ====    FUNCOES PARA EXIBIR MENSAGENS NA TELA ============================================================================

//       print_stat(tLOGv, msg, count_print, reprint, debug, num_verb).
FUNCTION PRINT_STAT{                    //exibe as mensagens do log(dir) e dos status(esc)
		//=====================================================================================================================================
		parameter tipo_msg.
		parameter msg.
		parameter count_print. //isso e para o contador mas não precisa (p tlog) pois esta usando var globais
                                //USADO NO ttimer
		//optional parameter:
		parameter reprint_stats     is False.
		parameter debug_print_stat  is False.
		parameter num_verbose_msg   is 0    .//somente info para ser exibido na frente da mensagem(pode indicar atividade porque vai ficar mudando)
		parameter larg_max_stat     is 1000 .//usado no tlista: valor bem alto para quando for setado menor que o l_max do stat ele prevalecer
        parameter comecar_em_somente_valores        is 0.

        parameter debug_print_stat_dont_log_file is False.


	    local NM_D_FNC is "PRINT_STAT".
        trace(NM_D_FNC).

        set hops to inc(hops).
		//exibir o log e adicionar mais uma linha   //

   		debug(NM_D_FNC, "tipo_msg:["+tipo_msg+"]", debug_print_stat).//debug_print_stat_dont_log_file

		if ( tipo_msg = tlog ) or ( tipo_msg = tLOGv){ //usar PRINT_STAT(tLOG,msg,contador_LOG).
			IF  not ((tipo_msg = tLOGv) and (msg = last_msd_added)) //eh falso que: [tMSG=tLOGv e MSG=ultima]:
			//operacao de teste por repetidas para varias iguais que nao trazem nada de informativo relevante: -------------------
				{//adicionar uma unica vez e as repetidas nao adicionar			
            		debug(NM_D_FNC, "tlog:["+msg+"]", debug_print_stat).
                    //print "lista msg antes:". print lista_msg.
					if not(reprint_stats) {//ADD NA LIST, SALVA LAST
                		debug(NM_D_FNC, "add msg lista_msg:["+msg+"]", debug_print_stat).
						//operacao de armazenagem: -------------------------------------------------------------
						//adicionar a msg na lista: (antes de truncar)
						lista_msg:add(msg).
						set last_msd_added to lista_msg[lista_msg:length - 1].
						//FOO:INSERT(0,"skipper 1"). // Inserts the string "skipper 1" to the start of the list, pushing the rest of the contents right.
						//SET FOO#0 to 4.          // Replace the 5 at position 0 with a 4.
						//FOO:REMOVE( 1).              // Removes the element at index 1 from the list, moving everything else back one.
						//FOO:REMOVE(FOO:LENGTH - 1).  // Removes whatever element happens to be at the end of the list, at position length-1.
						//PRINT FOO[0]. // Prints A.
						//http://ksp-kos.github.io/KOS_DOC/structures/collections/list.html#structure:LIST
						}.

					//operacao de truncagem: -------------------------------------------------------------------------------
					//set msg to CONCAT_STR_A(msg, larg_max_msg_log).//se necessaria (na func).
					
					//operacao de impressao da msg ATUAL: -------------------------------------------------------------------
					//print msg at(col_log, lin_log_init + contador_log).
              		debug(NM_D_FNC, "call print_2stat: count["+contador_log+"] l_mx_lg["+larg_max_msg_log+"] c_lg["+col_log+"] l_lg["+lin_log_init+"] h_mx_c_lg["+h_max_col_log+"]", debug_print_stat).
					set contador_log to PRINT_2STAT_COMUM("["+contador_log+"]"+msg, larg_max_msg_log, col_log, lin_log_init, contador_log, h_max_col_log, lista_msg).
					//PRINT_2STAT_COMUM(parameter msg, len_max_msg, pos_col, pos_lin, count_print_atual, count_print_max).
					//Next, we'll lock our throttle to 100%.
						//LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.
                    //print "lista msg depois:". print lista_msg.
				}
			ELSE{ //NAO eh falso que: [tMSG=tLOGv e MSG=ultima]:  
				//IGNORANDO REPETIDAS NO MODO VERB.
				//FAZER poderia resaltar que esta sendo enviada com uma mudanca de cor ou capitalizacao
				if (CONFIG_DEF_SHOW_VERBOSE_NUM)
					{//imprimir mas na mesma linha anterior e com nova msg (que pode vir com um num de identificacao ou capitalizacao)
						//NAO INCREMENTA contador_log (já vai ter incrementado da primeira vez)
						//PRINT "DEBUG: PRINT_STAT: esta no verbose.".
                   		debug(NM_D_FNC, "atualizando verbose num:["+num_verbose_msg+"]", debug_print_stat).//debug_print_stat_dont_log_file
						PRINT_2STAT_COMUM( ("["+contador_log+"]" + msg + "["+num_verbose_msg+"]"),
                                                        larg_max_msg_log,
                                                        col_log, 
                                                        lin_log_init, 
                                                        contador_log -1, 
                                                        h_max_col_log, //count_print_max
                                                        lista_msg).
						//PRINT_2STAT_COMUM(parameter msg, len_max_msg, pos_col, pos_lin, count_print_atual, count_print_max).
					}.
				}.		
			//FIM operacao de teste por repetidas para varias iguais que nao trazem nada de informativo relevante: ---------------
			}
		
		
		else if tipo_msg = ttitle    {//inserir bateria e conexoes
			set contador_title to contador_title + 1.//nao esta sendo utilizada: pode informar quantas alteracoes teve
			//linha de titulo (show warnings and status):
			//PRINT "CONTROL TEST PROGRAM - CARLOS AMORIM - v0.1" at(0,0).
			if (h_titulo > 0){
				PRINT CONCAT_STR_A(msg, largura_min_para_titulo) AT (col_title,lin_title).
			}.
		}
	
		else if tipo_msg = ttimer    {//pensar no titulo e no display
			//print_stat(ttimer,"Counting down:",0). //maneira de zerar o contador_timer e inserir o titulo
			//PRINT titulo AT(0,2).
			if (count_print = 0) {//imprime o titulo
				PRINT msg AT (col_timer,lin_timer).
			}
			else {//imprime a contagem pontos e num
				if count_print < 2 {//=1
					PRINT msg AT (col_timer,lin_timer+1).	//somente uma linha abaixo
				}
				else{ //da 2a em diante
					//imprime espaco para apagar o ponto
					PRINT " " AT ((col_timer + count_print - 2 ),lin_timer+1).//para 10 posicoes comeca no c=0
					print msg at ((col_timer + 14),lin_timer+1). //imprime o numero: fazer deslocamento dinamico: 14?
				}.
			}.
			set contador_timer to contador_timer + 1.
            //mudar isso fazer o return atualizar o contador_timer pelo count_print
		}
	
		else if tipo_msg = tpasso    {//
			//set contador_passo to contador_passo + 1. //CONTADOR PASSO NAO SOMA //SO MOSTRA A POSICAO NIVEL PASSO(LINHA)
			PRINT_2STAT_COMUM(msg, larg_max_car, col_passo, lin_passo, count_print, h_passo_max, lista_passo).		
			//fazer limpar todos os passos de nivel inferior (cancelados ou ultrapassados) OU BOTAR OK
		}
		
		//no meio eh livre (fica mais espaco pro passo)
	
		else if tipo_msg = tmenu     {
			PRINT_2STAT_COMUM(msg, larg_max_car, col_menu, lin_menu, count_print - 1, h_menu, lista_menu ).
			if (debug_print_stat)
				{print "debug print_stat: l_max_car: " + larg_max_car.}.
		}
		
		else if tipo_msg = tstatus   {
			//Coluna a esquerda com posicao dos dados especificas:
			// AP: primeira = lin_status		(+count_print(0))
			// VEL: segunda = lin_status + 1	(+count_print(1))
			// PE: terceira = lin_status + 2	(+count_print(2))
			//set contador_status to contador_status + 1.
            if (comecar_em_somente_valores>0){//somente_valores esta sendo usado para o ponto de partida
            // e para o tamanho reservado usando larg_max_stat : (para nao limpar apos tb)
                //onlyvalues
                local msg_string_status to msg:tostring.
                
			    set contador_status to PRINT_2STAT_COMUM(msg_string_status, 
                                        min(larg_max_car, larg_max_stat), (col_status + comecar_em_somente_valores), lin_status, count_print, h_status, lista_status ).
                
            }
            else{
			    set contador_status to PRINT_2STAT_COMUM(msg, (larg_max_car), col_status, lin_status, count_print, h_status, lista_status ).
            }
			//PRINT msg AT ( col_status, lin_status + count_print).
		}		
			
		else if tipo_msg = tfile     {
			set contador_file to contador_file + 1.
			//FAZER armazena em um arquivo:
			//LOG "Hello" to mylog.txt.    // logs to "mylog.txt".
			//LOG 4+1 to "mylog" .         // logs to "mylog.ks" because .ks is the default extension.
			//LOG "4 times 8 is: " + (4*8) to mylog.   // logs to mylog.ks because .ks is the default extension.
			LOG msg to FILE_MSG_LOG.
			IF (count_print > -1){
				PRINT SETUP_LABEL_FILE + msg AT (col_file,lin_file).
			}
			
		}
		
		else if tipo_msg = tinfoline {
			//set contador_infoline to contador_infoline + 1.
			//EXIBE UMA LINHA DE INFORMAÇÃO SOBRE COMANDOS E STATUS GERAL:
			lista_info_line:add(msg).
	
			SET msg to (SETUP_LABEL_INFO_LINE + "[" + count_print + "]:" + msg).
			set contador_infoline to PRINT_2STAT_COMUM(msg,
                                        (largura_max_para_INFO_LINE),
                                        col_file,
                                        lin_file,
                                        0,
                                        h_file,//count_print_max
                                        lista_info_line).// usar count_print para imprimir mais de uma linha (tipo umas 3)FAZER
		}
		//recompiule
		//ISSO AQUI EH SOH PRA EXIBIR OS LABEL JUNTO: fazer deixar os label ja fixo
		else if tipo_msg = tprintcar {//para entrada de OPCOES
			set contador_car to contador_car + 1.
			//local do prompt
			//			PRINT_2STAT_COMUM(msg, (largura_max_para_INFO_LINE), col_file, lin_file, count_print, count_print ).
			PRINT SETUP_LABEL_PROMPT + msg AT (col_car,lin_car).
		}
			
		else if tipo_msg = tprintCMD {//para entrada de instrucoes 
			set contador_CMD to contador_CMD + 1.
			set msg to (SETUP_LABEL_CMD + msg).
			PRINT_2STAT_COMUM(msg, (largura_max_para_INFO_LINE), col_CMD, lin_CMD, -1, h_cmd, lista_cmd ).
		}
        
		else if tipo_msg = tlista {//para mostrar informacoes na coluna central: muitos dados do hover, listagem de parts e modules 
			
			//set msg to (SETUP_LABEL_CMD + msg).
			lista_list:add(msg).
            
			set contador_list to PRINT_2STAT_COMUM(msg, min((espaco_entre_colunas),larg_max_stat), col_lista, lin_lista, count_print, h_max_col_list, lista_list ).
		}
		else if tipo_msg = tlista2 {
			//set contador_list2 to contador_list2 + 1.
			set contador_list2 to PRINT_2STAT_COMUM(msg,
                                                 min((espaco_entre_colunas/2),
                                                 larg_max_stat),
                                                 col_lista2,
                                                 lin_lista,
                                                 count_print,//count_print_max
                                                 h_max_col_list, lista_list2 ).
		}
        
        else{
      		print "ERRO: " + NOME_DA_FUNC + ": Nenhuma acao valida passada a funcao! :[" + tipo_msg +"]".
            PRINT_BIG_ERROR_NOCLS_TIMED("ERRO: " + NOME_DA_FUNC_REPASSADA + ": Nenhuma acao valida passada a funcao! :[" + tipo_msg +"]").
        }.
		
        if (1=1){ //sem o check agora
            // CHECK_OPTIONS(	tipo_msg,
						// "PRINT_STAT",
						// 12,
						////tmsg,
						// tlog,
						// tlogv,
						// tstatus,						
						// ttimer,
						// ttitle,
						// tpasso,
						// tmenu,
						// tfile,
						// tprintcar,
						// tprintCMD,
						// tinfoline,
                        // tlista,
						// msg		//para o debug> ou seja aqui o debug esta ativo
						// ).
        }.
        
		if (LOG_ALL_MSG){//isto é usado somente para encontrar problemas nas mensagens.
			LOG msg to FILE_ALL_MSG_LOG.
		}

        return inc(num_verbose_msg).//se nao for verbose a funcao sempre retorna 1.
        
		//=====================================================================================================================================
	}.// FIM PRINT_STAT

function PRINT_2STAT_COMUM{             //acoes comuns no print stat (para economizar codigo): print na pos relativa a lin_x, limpa campo antes.
	parameter msg.
	parameter len_max_msg.
	parameter pos_col.
	parameter pos_lin.
	parameter count_print_atual.
	parameter count_print_max.
    parameter lista_de_msg.//      is lista_msg.
    parameter debug_p_2st_com is false.
	
	local NM_D_FNC is "PRNT_2STAT_COM".  
    trace(NM_D_FNC).
    set hops to inc(hops).
    //set count_print_max to count_print_max -6.

    local lin to 0.
    set count_print_atual to count_print_atual + 1.
	if (count_print_atual > count_print_max){//ERRO: FAZER:  A ROLAGEM DE MENSAGENS:
      		debug(NM_D_FNC, "count_print_atual["+count_print_atual+"] > count_print_max["+count_print_max+"]", debug_p_2st_com).
			//debug(NOME_DA_FUNC, "Erro: PRINT_2STAT_COMUM: h max da col atingida:[" + count_print_max + "]").
			//print "      mensagem: :[" + msg + "]".
            //print lista_de_msg.
            if (rolar_msgs_print_stat = "rolagem_dinamica"){
   								FROM    {set count_print_atual to ( (lista_de_msg:length - 1)- count_print_max).}
								UNTIL   (count_print_atual > (lista_de_msg:length -1))
								STEP    {set count_print_atual to count_print_atual + 1.}//VER SE JA NAO ADD 1 ANTES DE EXEC [NOP]
								DO 	    {
                                    set lin to      pos_lin + (count_print_atual - ( lista_de_msg:length - count_print_max)) + 1.
                                    //linha_atual_imp to lin_log_init + (count_print_atual - ( lista_de_msg:length - count_print_max)).
									print formata_p_print_stat(len_max_msg, (lista_de_msg[( count_print_atual )]))      AT (pos_col,  lin ).
									//item_da_lista >  2 + 1 = (3)       posicao de print > 2 + 2 = 4
									//item_da_lista >  4 + 1 = (5)       posicao de print > 2 + 4 = 6
									//FAZER RESPEITAR O TAMANHO DA LISTA . se tentar obter mais itens que o existente?
                                    //wait 0.2.
															
								}.
            }
            else if ( rolar_msgs_print_stat = "limpa_tela" ){//fazer limpa imprime novo
                from    {local linha_limpa to pos_lin.}
                until   (linha_limpa >  (pos_lin + count_print_max) )
                step    {set linha_limpa to linha_limpa + 1.}
                do      {
                        set count_print_atual to 1.
                        print formata_p_print_stat(len_max_msg)      AT (pos_col,  linha_limpa ).//isto é uma linha de limpeza
                }.
                set lin to (pos_lin + count_print_atual).
                print formata_p_print_stat(len_max_msg, msg) at (pos_col, lin).//ojk
            }
            else if ( rolar_msgs_print_stat = "limpa_tela_parcial" ){//FAZER IR LIMPANDO SOMENTE UMA POR VEZ DEIXANDO DUAS DE ESPACO
                //set count_print_atual to 1.
                //print "count_print_atual:"+count_print_atual.
                //print "count_print_max:"+count_print_max.
                //PRINT "mod: "+ MOD(count_print_atual,count_print_max). // prints 3
                set lin to (pos_lin + MOD(count_print_atual,count_print_max)).
                print formata_p_print_stat(len_max_msg, msg) at (pos_col, lin).
                print formata_p_print_stat(len_max_msg)      AT (pos_col,  lin+1 ).//isto é uma linha de limpeza
            }
            else{//NADA IMPRIME
                print "print2statcomum: erro: sem opcao valida de rolagem!".
            }.
		}
        else{
      		debug(NM_D_FNC, "count_print_atual["+count_print_atual+"] <= count_print_max["+count_print_max+"]", debug_p_2st_com).
            set lin to (pos_lin + count_print_atual).
            print formata_p_print_stat(len_max_msg, msg) at (pos_col, lin).//ojk
        }.
	//print enche_de_espacos(len_max_msg) at (pos_col, lin).
	//print CONCAT_STR_A(completa_de_espacos(len_max_msg,msg), len_max_msg) at (pos_col, lin).

    debug(NM_D_FNC, "count_print_atual:return["+count_print_atual+"]", debug_p_2st_com).
    return count_print_atual.
}.
FUNCTION eliminar_isso{	
    set hops to inc(hops).
    					//operacao de scroll: ----------------------------------------------------------------------------------
					//aqui se compara as alturas relativas e verifica se ja chegou na borda inferior:
					//ATENCAO: apartir daqui o contador_log se mantera inalterado ja que ele esta sendo usado para indicar a posicao na lista exibida
					if ( contador_log + 1) > ( h_max_col_log ){//como o cont+1 > -1
						//esse teste eh feito antes de somar 1 contador_log, entao devese considerar que ele esta menor
						//entao no terminal para simplificar e retirado 1 
							set contador_log to 1.//1 para manter o titulo (entao sera adicionada na pos 2)
							//imprimir "- - - - ^ - - - -" na primeira linha do log (apos o label)
							print CONCAT_STR_A(log_label_scroll_up, larg_max_msg_log) at(col_log, lin_log_init + contador_log).
							
							if (1=2) {//descobrir o que aconteceu aqui: FAZER
								FROM {set contador_log to 2.}
								UNTIL (contador_log > (h_max_col_log - 2))//para preservar duas linhas
								STEP {set contador_log to contador_log + 1.}//VER SE JA NAO ADD 1 ANTES DE EXEC [NOP]
								DO 	{ //imprima os itens ate o ultimo adicionado (len -1) e deixe um campo para a prox msg
									print (lista_msg[( contador_log ) + 1]) AT (col_log, lin_log_init + contador_log).
									//item_da_lista >  2 + 1 = (3)       posicao de print > 2 + 2 = 4
									//item_da_lista >  4 + 1 = (5)       posicao de print > 2 + 4 = 6
									//FAZER RESPEITAR O TAMANHO DA LISTA . se tentar obter mais itens que o existente?
															
									}
							}.
						}
					else{
						set contador_log to contador_log + 1.
						}.
					//operacao de scroll fim: -------------------------------------------------------------------------------
}.

function PRINT_BIG_ERROR_NOCLS_TIMED{
	parameter error_msg_big_scr.
	declare local parameter time_err_b_scr is VALOR_PADRAO_TEMPO_ERRO.
    set hops to inc(hops).
	
	LOCAL pos_vert 	is (terminal:height / 2).
	LOCAL pos_horz 	is ((terminal:width - error_msg_big_scr:length) / 2 ).
	local len_e		is ( 1 + error_msg_big_scr:LENGTH + 1 ).//1 é as bordas FAZER usar PADROES DE BORDA
	local car_b		is "-".//FAZER usar PADROES DE BORDA
	//fazer: draw some lines
	print enche_de_espacos( len_e,"",car_b) at (pos_horz - 1, pos_vert - 1).
	PRINT error_msg_big_scr at (pos_horz, pos_vert).
	print enche_de_espacos( len_e,"",car_b) at (pos_horz - 1, pos_vert + 1).
	WAIT time_err_b_scr.
	}.
function PRINT_BIG_ERROR_CLS_TIMED{
	parameter error_msg_big_scr.
	parameter time_err_b_scr is VALOR_PADRAO_TEMPO_ERRO.//tempo do bip se pausa
    parameter pause_err is false.
    parameter clearScreen_onerr is true.

	local NOME_DA_FUNC is "PRINT_BIG_ERROR_CLS_TIMED".  
    trace(NOME_DA_FUNC).
    debug(NOME_DA_FUNC,"vai limpar a tela",debug_level_trace,DEBUG_DELAY_CLEARSCR).
    set hops to inc(hops).
    if clearScreen_onerr CLEARSCREEN.
	//fazer: draw some lines
	PRINT error_msg_big_scr at (((terminal:width - error_msg_big_scr:length) / 2 ),(terminal:height / 2)).

		if (pause_err){
        	PRINT "BIG_ERROR: pressione uma tecla!" at (((terminal:width - error_msg_big_scr:length) / 2 ),(terminal:height / 2)+1).
			beep("bip_wait", False, time_err_b_scr).
			terminal:input:getchar().
		}
        else{
        	WAIT time_err_b_scr.
        }

	}.
function PRINT_BIG_ERROR_CLS{
	parameter error_msg_big_scr.
	local NOME_DA_FUNC is "PRINT_BIG_ERROR_CLS".
    
    trace(NOME_DA_FUNC).
    debug(NOME_DA_FUNC,"vai limpar a tela",debug_level_trace,DEBUG_DELAY_CLEARSCR).
    set hops to inc(hops).

	CLEARSCREEN.
	//fazer: draw some lines
	PRINT error_msg_big_scr at (((terminal:width - error_msg_big_scr:length) / 2 ),(terminal:height / 2)).
	WAIT 0.1.
	}.

										//Função DEBUG faz um print por cima da tela 
FUNCTION DEBUG{                         //DEBUG com nome da funcao: debug(NOME_DA_FUNC,"debugar.",Respeitar_Conforme_Funcao).
	parameter NOME_DA_FUNC.
	parameter MSG_DE_DEBUG.
    parameter SHOW_DEBUG_D          is True .
    parameter DEBUG_ESPERA_CLEARSCR is 0    .
    parameter no_LOG_file_DEBUG 			is False .//desativa o flood no log_file em uma mensagem repetitiva

    //ATUALIZAR ESTA FUNÇÃO PARA USAR O SISTEMA DE NÍVEL
    
    set hops to inc(hops).
    local msg_debug_delay is "".

    if (LOG_DEBUG) and (not(no_LOG_file_DEBUG)) {
		LOG "debug " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG to FILE_DEBUGLOG.
    }.    

    if (SHOW_DEBUG_D){
        if (DEBUG_ESPERA_CLEARSCR > 0){
            set msg_debug_delay to "[wait "+DEBUG_ESPERA_CLEARSCR+"...]".
        }.
        
        print "debug " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG + msg_debug_delay.	
        lista_DEBUG:add(MSG_DE_DEBUG).        
        
        if (DEBUG_ESPERA_CLEARSCR > 0){
            wait DEBUG_DELAY_CLEARSCR.
        }.
    }.    
}.

FUNCTION DEBUG_WAIT{                         //DEBUG somente para função wait
	parameter DEBUG_DELAY.
	parameter MSG_DE_DEBUG is "debug wait".
	parameter NOME_DA_FUNC is "NÃO ESPECIFICADA".
    
    set hops to inc(hops).

    if (LOG_DEBUG){
		LOG "debug " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG to FILE_DEBUGLOG.
    }.    

    print "   " + NOME_DA_FUNC + ": " + MSG_DE_DEBUG + DEBUG_DELAY at(0, 0).
    wait DEBUG_DELAY.
}.

FUNCTION TRACE{                         //TRACE com nome da funcao: trace(NOME_DA_FUNC). //OBS so funciona apos a c3_scr_msg e INIT_VARS
	parameter NOME_DA_FUNC.
    parameter Permite_trace_debug is True.
    set hops to inc(hops).
	if (debug_level_trace){
        if (Permite_trace_debug){
            lista_TRACE:add(NOME_DA_FUNC).
            print "trace["+lista_TRACE:LENGTH()+"]: " + NOME_DA_FUNC.
        }
	}
}.

// ========  TRANSMISSOES ======================================================================================================
    // The current vessel’s message queue can be accessed using Vessel:MESSAGES:

    // SET QUEUE TO SHIP:MESSAGES.

function SHOW_VESSEL_MESSAGE_QUEUE{
    parameter QUEUE_SHIP_MESG is SHIP:MESSAGES.

    parameter ESPERA_COMANDO    is False.
    parameter FUNCAO_ESPERADA   is "MENSAGEM".//"comando"/"mensagem"/"esperando_msg"
    parameter SENDER_ESPERADO   is "ninguem_cpu".

    parameter startCol is 3.
    parameter startRow is 20. 

    parameter debug__SHOW_vessel_MESSAGE_QUEUE is True.

	local NOME_DA_FUNC is "SHOW_Ship_Msg_QUEUE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    print_stat(tpasso, "commMSGSShip:" + QUEUE_SHIP_MESG:LENGTH, 4).//, contador_LOG, False, False, contador_verbose_stage_simple).
    if (QUEUE_SHIP_MESG:LENGTH > 0){
        debug(NOME_DA_FUNC, "FUNCAO_ESPERADA:" + FUNCAO_ESPERADA, debug__SHOW_vessel_MESSAGE_QUEUE).
        debug(NOME_DA_FUNC, "SENDER_ESPERADO:" + SENDER_ESPERADO, debug__SHOW_vessel_MESSAGE_QUEUE).
        local MENSAGENS_POPADAS is QUEUE_SHIP_MESG:POP.

            if (FUNCAO_ESPERADA = "esperando_msg"){
                local SEPARADOR is ":".
                local str_MENSAGEM_POPADA_TEMP is MENSAGENS_POPADAS:CONTENT.
                local NOME_DA_SENDER_PROCURADO is str_MENSAGEM_POPADA_TEMP:SUBSTRING(0,( SENDER_ESPERADO:LENGTH)).
                local MSG_DA_SENDER_PROCURADO is str_MENSAGEM_POPADA_TEMP:SUBSTRING(
                                                        (SENDER_ESPERADO:LENGTH + SEPARADOR:length),
                                                        ( str_MENSAGEM_POPADA_TEMP:LENGTH - SENDER_ESPERADO:LENGTH) - 1).

                print "str sender recortada: [" + NOME_DA_SENDER_PROCURADO +"] str msg recortada: [" + MSG_DA_SENDER_PROCURADO +"]".

                if(SENDER_ESPERADO = NOME_DA_SENDER_PROCURADO ){
                    //MENSAGENS_POPADAS:sender:name >> esta retornando o valor do VESSEL E NAO DO CORE
                    return MSG_DA_SENDER_PROCURADO.
                }
            }
            ELSE {
                PRINT "SHOW_VESSEL_MESSAGE_QUEUE: recebeu uma mensagem".
                MESSAGE_CORE_HANDLER_1(SHIP:MESSAGES:POP, startCol, startRow + 1, true).
            }
    }.
}.

function SHOW_CORE_MESSAGE_QUEUE{       //isto esta invertido primeiro: MESSAGE_CORE_HANDLER_1 depois SHOW_CORE_MESSAGE_QUEUE
    //parameter startCol.  parameter startRow.
    parameter QUEUE_CORE_MESG   is CORE:MESSAGES.
    parameter ESPERA_COMANDO    is False.
    parameter FUNCAO_ESPERADA   is "MENSAGEM".//"comando"/"mensagem"
    parameter SENDER_ESPERADO   is "ninguem_cpu".
    parameter INFO_ESPERADA     is "Nada_util_cpu".
    parameter QUEM_CHAMOU       is "nao informado".
    parameter startCol is 3.
    parameter startRow is 5. 

    parameter debug__SHOW_CORE_MESSAGE_QUEUE is True.

	local NOME_DA_FUNC is "SHOW_CORE_Msg_QUEUE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
        
    //PRINT "Number of messages on the CORE queue: " + QUEUE_CORE_MESG:LENGTH at (startCol,startRow). 
    print_stat(tpasso, "commMSGScore:" + QUEUE_CORE_MESG:LENGTH, 3).//, contador_LOG, False, False, contador_verbose_stage_simple).
    //print "debug: SHOW_CORE_MESSAGE_QUEUE: requisitado".
    if (QUEUE_CORE_MESG:LENGTH > 0){

        debug(NOME_DA_FUNC, "FUNCAO_ESPERADA:" + FUNCAO_ESPERADA, debug__SHOW_CORE_MESSAGE_QUEUE).
        debug(NOME_DA_FUNC, "SENDER_ESPERADO:" + SENDER_ESPERADO, debug__SHOW_CORE_MESSAGE_QUEUE).
        //debug(NOME_DA_FUNC, "INFO_ESPERADA:" + INFO_ESPERADA, debug__SHOW_CORE_MESSAGE_QUEUE).
        //debug(NOME_DA_FUNC, "QUEM_CHAMOU:" + QUEM_CHAMOU, debug__SHOW_CORE_MESSAGE_QUEUE).

        //local MENSAGENS_POPADAS is CORE:MESSAGES:POP.
        local MENSAGENS_POPADAS is QUEUE_CORE_MESG:POP.
        
        if ESPERA_COMANDO {
            //processa o comando de sistema recebido
            //enviar para rotina de reconhecimento de comandos kahsdfjhasdflkjdshdfsjhdjfkhskladjhf omg
            //finalmente vai ser útil
            if (MENSAGENS_POPADAS:CONTENT = "estou_pronto_para_hover"){
                //estou pronto para hover recebido
            }
        }
        else{
            if (FUNCAO_ESPERADA = "esperando_msg"){
                local SEPARADOR is ":".
                local str_MENSAGEM_POPADA_TEMP is MENSAGENS_POPADAS:CONTENT.
                local NOME_DA_SENDER_PROCURADO is str_MENSAGEM_POPADA_TEMP:SUBSTRING(0,( SENDER_ESPERADO:LENGTH)).
                local MSG_DA_SENDER_PROCURADO is str_MENSAGEM_POPADA_TEMP:SUBSTRING(
                                                        (SENDER_ESPERADO:LENGTH + SEPARADOR:length),
                                                        ( str_MENSAGEM_POPADA_TEMP:LENGTH - SENDER_ESPERADO:LENGTH) - 1).

                print "str sender recortada: [" + NOME_DA_SENDER_PROCURADO +"] str msg recortada: [" + MSG_DA_SENDER_PROCURADO +"]".

                if(SENDER_ESPERADO = NOME_DA_SENDER_PROCURADO ){
                    //MENSAGENS_POPADAS:sender:name >> esta retornando o valor do VESSEL E NAO DO CORE
                    if (INFO_ESPERADA = "qual"){
                        //INFO_ESPERADA
                    }
                    //melho deixar quem chamou decidir:
                    //return MENSAGENS_POPADAS:CONTENT.
                    return MSG_DA_SENDER_PROCURADO.
                }
            }
            //caso venha um comando inesperado:
            if (MENSAGENS_POPADAS:CONTENT:CONTAINS("voce_se_prepare_para_hover")){
                //https://ksp-kos.github.io/KOS_DOC/structures/misc/string.html?highlight=string
                // CONTAINS(string) 	Boolean 	True if the given string is contained within this string
                // ENDSWITH(string) 	Boolean 	True if this string ends with the given string
                // FIND(string) 	Scalar 	Returns the index of the first occurrence of the given strin


                //voce_se_prepare_para_hover COMANDO recebido
                HOVER_1(alt:radar, true, true, "STAND_BY").
                //E O QUE ESTAVA FAZENDO ANTES DISSO? NAO VAI DAR PROBLEMA?
                //USAR UM BREAK OU EXIT
                return "EU NAO SEI O QUE ENVIAR AQUI ENTAO VOU ENVIAR UMA MUSICA LAH LAH LA...".
            }

            //mostra mensagem inutil
            debug(NOME_DA_FUNC, "tem mensagens", debug__SHOW_CORE_MESSAGE_QUEUE).
            MESSAGE_CORE_HANDLER_1(MENSAGENS_POPADAS, startCol,startRow + 1, true).
        }
    }
    ELSE{
        RETURN "".
    }
    // The receiving CPU will use CORE:MESSAGES to access its message queue:

// WAIT UNTIL NOT CORE:MESSAGES:EMPTY. // make sure we've received something
// SET RECEIVED TO CORE:MESSAGES:POP.
// IF RECEIVED:CONTENT = "undock" {
  // PRINT "Undocking!!!".
  // UNDOCK().
// } ELSE {
  // PRINT "Unexpected message: " + RECEIVED:CONTENT.
// }

    // structure MessageQueue
        // Suffix 	Type 	Description
        // EMPTY 	Boolean 	true if there are messages in the queue
        // LENGTH 	Scalar 	number of messages in the queue
        // POP() 	Message 	returns the oldest element in the queue and removes it
        // PEEK() 	Message 	returns the oldest element in the queue without removing it
        // CLEAR() 	None 	remove all messages
        // PUSH(message) 	None 	explicitly append a message  
}.



function MESSAGE_CORE_HANDLER_1{        // boiu CHAMAR COM : SHIP:MESSAGES:POP ou CORE:MESSAGES:POP
    parameter RECEIVED.
    parameter  startCol, startRow.
    parameter MOSTRA_RESUMO is true.
    parameter debug_MESSAGE_CORE_HANDLER_1 is false.

    set hops to inc(hops).
    // if there is a message in the ship's message queue
    // we can forward it to a different CPU

    // cpu1
    //SET CPU2 TO PROCESSOR("cpu2").
    //CPU2:CONNECTION:SENDMESSAGE(SHIP:MESSAGES:POP).
    if (MOSTRA_RESUMO){
        print "MESSAGE_CORE_HANDLER_1: resumo Original message:".
        PRINT " SENTAT:     " + RECEIVED:SENTAT.// at (startCol,startRow).
        PRINT " RECEIVEDAT  " + RECEIVED:RECEIVEDAT.// at (startCol,startRow + 1).
        PRINT " SENDER:     " + RECEIVED:SENDER.// at (startCol,startRow + 2).
        PRINT " HASSENDER:  " + RECEIVED:HASSENDER.// at (startCol,startRow + 3).
        PRINT " CONTENT:    " + RECEIVED:CONTENT.// at (startCol,startRow + 4).
        if (debug_MESSAGE_CORE_HANDLER_1){
            print "FAZER: infos de QUEM recebeu a mensagem:".// at (startCol,startRow + 5).
            print "CORE:VESSEL                  " + CORE:VESSEL.// at (startCol,startRow + 6).
            print "CORE:TAG                     " + CORE:TAG.// at (startCol,startRow + 7).
        }
    }

    return RECEIVED.

    //VESSEL

    // structure kOSProcessor
        // Suffix 	        Type 	                Description
        // All suffixes of PartModule 	  	        kOSProcessor objects are a type of PartModule
        // MODE 	        :ref:`string <string>` 	OFF, READY or STARVED
        // ACTIVATE 	    None 	                Activates this processor
        // DEACTIVATE 	    None 	                Deactivates this processor
        // TAG 	            :ref:`string <string>` 	This processor’s name tag
        // VOLUME 	        Volume 	                This processor’s hard disk
        // BOOTFILENAME 	:ref:`string <string>` 	The filename for the boot file on this processor
        // CONNECTION 	:struct:`Connection 	    Returns your connection to this processor

    // structure Message
        // Suffix 	    Type 	                Description
        // SENTAT 	    TimeSpan 	        date this message was sent at
        // RECEIVEDAT 	TimeSpan 	        date this message was received at
        // SENDER 	    Vessel or Boolean 	vessel which has sent this message, or Boolean false if sender vessel is now gone
        // HASSENDER 	Boolean 	        Tests whether or not the sender vessel still exists.
        // CONTENT 	    Structure 	        message content
        
    // Message:SENDER   // Type:	Vessel or Boolean
        // Vessel which has sent this message, or a boolean false value if the sender vessel no longer exists.
        // If the sender of the message doesn’t exist anymore (see the explanation for HASSENDER), this suffix will return a different type altogether. It will be a Boolean (which is false).
        // You can check for this condition either by using the HASSENDER suffix, or by checking the :ISTYPE suffix of the sender to detect if it’s really a vessel or not.
        
    
}.

function HANDLE_CONNECTION_CORES{       //nao teve maneira de achar ooutro PROCESSOR na outra nave
    parameter Nome_do_CPU_ENVIAR, Mensagem_Para_Core.
    parameter debug__CONNECTION_CORES is True.
    parameter debug_2_CONNECTION_CORES is false.

	local NOME_DA_FUNC is "HANDLE_CON_CORES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    local CPU_mostra_vel is CORE.
    //
//SET CPU2 TO PROCESSOR("cpu2").
//CPU2:CONNECTION:SENDMESSAGE(SHIP:MESSAGES:POP).

    //A list of all processors can be obtained using the List command:
    //https://ksp-kos.github.io/KOS_DOC/commands/communication.html?highlight=processor#PROCESSOR
    local todos_processadores is 0.
    local cpu_existe is false.
    LIST PROCESSORS IN todos_processadores.
    debug(NOME_DA_FUNC, "FOR cpu IN todos_processadores (abaixo) total:" + todos_processadores:length, debug_2_CONNECTION_CORES).
    FOR processador in todos_processadores {
        debug(NOME_DA_FUNC, "processador:tag [" + processador:tag + "] processador:name [" + processador:name + "]", debug_2_CONNECTION_CORES).
        if processador:tag = Nome_do_CPU_ENVIAR {
            set cpu_existe to True.
        }
    }

    if (debug_2_CONNECTION_CORES){
        debug(NOME_DA_FUNC, "looking for:" + Nome_do_CPU_ENVIAR, debug__CONNECTION_CORES).
        print "....".
        print "todos_processadores[0]:NAME (abaixo)".
        print "....".
        PRINT todos_processadores[0]:NAME.
        print "....".
        print "outro metodo: PRINT SHIP:MODULESNAMED(_kOSProcessor_)[0]:VOLUME:NAME. (abaixo)".
        PRINT SHIP:MODULESNAMED("kOSProcessor")[0]:VOLUME:NAME.
        print "....".
        print "outro metodo: PRINT SHIP:MODULESNAMED(_kOSProcessor_). (abaixo)".
        PRINT "quantidade de modulos chamados _kOSProcessor: " + SHIP:MODULESNAMED("kOSProcessor"):length.
        print "....".
        print ".... fim dos testes".
    }

    if (cpu_existe){
        //
        SET CPU_mostra_vel TO PROCESSOR(Nome_do_CPU_ENVIAR).
        //SET myPart TO SHIP:PARTSTAGGED("my nametag here")[0].
        //debug(NOME_DA_FUNC, Nome_do_CPU_ENVIAR + ": existe!",debug__CONNECTION_CORES).
        
        IF (CPU_mostra_vel:tag=CORE:tag){
            //Nome_do_CPU_ENVIAR
            //PRINT "HANDLE_CONNECTION_CORES: mesma cpu envia recebe? : " + Nome_do_CPU_ENVIAR.
            debug(NOME_DA_FUNC, "mesmo CORE envia recebe? : " + Nome_do_CPU_ENVIAR, debug__CONNECTION_CORES).
        }
        ELSE{
        }.
        //print "CPU_mostra_vel:".
        //print CPU_mostra_vel.
        
        if (CPU_mostra_vel:CONNECTION:ISCONNECTED){
            debug(NOME_DA_FUNC, "ENVIANDO: [" + Mensagem_Para_Core + "] PARA [" +Nome_do_CPU_ENVIAR+ "]",debug__CONNECTION_CORES).
            IF CPU_mostra_vel:CONNECTION:SENDMESSAGE(Mensagem_Para_Core) {
                debug(NOME_DA_FUNC, "ENVIOU.", debug_2_CONNECTION_CORES).
                } 
            ELSE {
                debug(NOME_DA_FUNC, "ERRO: SND_MSG_CORE: nao enviado!", debug__CONNECTION_CORES).
                print "ERRO: SND_MSG_CORE: nao enviado!".
                }
            
        }
        else{
            print "ERRO: CON_CORE: nao ha conexao!".
            debug(NOME_DA_FUNC, "ERRO: CON_CORE: nao ha conexao com: " + Nome_do_CPU_ENVIAR, debug__CONNECTION_CORES).
        }.

    }
    else{
        //
        print "ERRO: CON_CORE: cpu nao existe na nave!".
        debug(NOME_DA_FUNC, "ERRO: CON_CORE: cpu nao existe na nave: " + Nome_do_CPU_ENVIAR, debug__CONNECTION_CORES).
    }
    // SET MY_PROCESSOR TO PROCESSOR("second").
    // SET MY_CONNECTION TO MY_PROCESSOR:CONNECTION.

    // The second type are connections to other vessels. Assuming you have a rover on duna named ‘dunarover’ you could obtain a connection to it like this:

    // SET MY_VESSEL TO VESSEL("dunarover").
    // SET MY_CONNECTION TO MY_VESSEL:CONNECTION.

    // structure Connection
        // Suffix 	                Type 	    Description
        // ISCONNECTED 	            Boolean 	true if this connection is currently opened
        // DELAY 	                Scalar 	    delay in seconds
        // DESTINATION 	            Vessel or kOSProcessor 	destination of this connection
        // SENDMESSAGE(message) 	Boolean 	Sends a message using this connection
}.


FUNCTION CHECK_SE_NAVE_EXISTE{
    parameter NAVE_A_VERIFICAR.
    parameter debug_check_nave is false.
    
	local NOME_DA_FUNC is "CHECK_SE_NAVE_EXISTE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    local List_De_targets is list().    
    LIST TARGETS IN List_De_targets.
    
    for alvos_naves IN List_De_targets{
        //print 
        //IF (alvos_naves:hassuffix(name)){
        if (alvos_naves:istype("Vessel")){
            if not(alvos_naves:ISDEAD){
                
                debug(NOME_DA_FUNC, alvos_naves:name, debug_check_nave).
                if (alvos_naves:name = NAVE_A_VERIFICAR){
                    return True.
                }   
            }
            else{
                debug(NOME_DA_FUNC, "is dead").

            }.
        }
        else
        {
            debug(NOME_DA_FUNC, "nao eh Vessel").
        }.

    }.
    
    return false.
    //
    // the LIST command can get you the lists of vessels and bodies that you can sue as targets

// try something like this go get the lists

// LIST TARGETS IN targetList.// targetList will be a list of all vessels
// LIST BODIES IN bodyList.// bodyList will be a list of all bodies in the gam
    //https://www.reddit.com/r/Kos/comments/8748gc/is_there_a_way_to_check_if_a_vessel_exists/
    
}.

function HANDLE_CONNECTION_VESSELS{     //nao teve maneira de achar ooutro PROCESSOR na outra nave
    parameter VESSEL_ENVIAR. //Nome_da_VESSEL_ENVIAR.
    parameter Mensagem_Para_VESSEL.
    parameter debug__CONNECTION_VESSELS is True.
    parameter debug_2_CONNECTION_VESSELS is True.

	local NOME_DA_FUNC is "HANDLE_CON_VESSELS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    local VESSEL_PARA_ENVIAR_MSG is 0.
    
    //AQUI SE A NAVE NAO EXISTE DA ERRO:
    if (CHECK_SE_NAVE_EXISTE(VESSEL_ENVIAR:name)){
        //CHECK_SE_NAVE_EXISTE
        debug(NOME_DA_FUNC, VESSEL_ENVIAR:name + ": existe!",debug_2_CONNECTION_VESSELS).
    }
    else{
        debug(NOME_DA_FUNC, VESSEL_ENVIAR:name + ": nao existe!",debug_2_CONNECTION_VESSELS).
        return false.
    }.

    set VESSEL_PARA_ENVIAR_MSG TO VESSEL_ENVIAR.//VESSEL(Nome_da_VESSEL_ENVIAR).
    local CONEXAO_PARA_ENV_MSG TO VESSEL_PARA_ENVIAR_MSG:CONNECTION.

    //local CPU_mostra_vel TO PROCESSOR(Nome_do_CPU_ENVIAR).
    //SET myPart TO SHIP:PARTSTAGGED("my nametag here")[0].
    
    //IF (Nome_da_VESSEL_ENVIAR=SHIP:NAME){
    IF (VESSEL_ENVIAR = SHIP){
        debug(NOME_DA_FUNC, "mesma NAVE envia recebe? : " + VESSEL_ENVIAR:name, debug__CONNECTION_VESSELS).
    }
    ELSE{
        if (CONEXAO_PARA_ENV_MSG:ISCONNECTED){
            debug(NOME_DA_FUNC, "ENVIANDO: [" + Mensagem_Para_VESSEL + "] PARA [" +VESSEL_ENVIAR:name+ "]",debug__CONNECTION_VESSELS).
            IF CONEXAO_PARA_ENV_MSG:SENDMESSAGE(Mensagem_Para_VESSEL) {
                PRINT NOME_DA_FUNC + " ENVIOU".
                }
            ELSE{
                PRINT NOME_DA_FUNC + " NAO ENVIOU".
                }
        }
        else{
            print "ERRO: CON_VESSEL: nao ha conexao!".
            debug(NOME_DA_FUNC, "ERRO: CON_VESSEL: nao ha conexao com: "+VESSEL_ENVIAR:name, debug__CONNECTION_VESSELS).
        }.
    }.
    // SET MY_PROCESSOR TO PROCESSOR("second").
    // SET MY_CONNECTION TO MY_PROCESSOR:CONNECTION.

    // The second type are connections to other vessels. Assuming you have a rover on duna named ‘dunarover’ you could obtain a connection to it like this:

    // SET MY_VESSEL TO VESSEL("dunarover").
    // SET MY_CONNECTION TO MY_VESSEL:CONNECTION.

    // structure Connection
        // Suffix 	                Type 	    Description
        // ISCONNECTED 	            Boolean 	true if this connection is currently opened
        // DELAY 	                Scalar 	    delay in seconds
        // DESTINATION 	            Vessel or kOSProcessor 	destination of this connection
        // SENDMESSAGE(message) 	Boolean 	Sends a message using this connection
}.


function HANDLE_VESSEL_INFO_1{
    set hops to inc(hops).
    //All vessels share a structure. To get a variable referring to any vessel you can do this:

    // Get a vessel by it's name.
    // The name is Case Sensitive.
    local MY_VESS TO VESSEL("Some Ship Name").

    // Save the current vessel in a variable,
    // in case the current vessel changes.
    local MY_VESS TO SHIP.

    // Save the target vessel in a variable,
    // in case the target vessel changes.
    local MY_VESS TO TARGET.

// Note

// New in version 0.13: A vessel is now a type of Orbitable. Much of what a Vessel can do can now by done by any orbitable object. The documentation for those abilities has been moved to the orbitable page.

// structure Vessel

}.


FUNCTION TESTE_MENSAGEM_HUD{
    set hops to inc(hops).
// Message
    // The message to show to the user on screen
// delaySeconds
    // How long to make the message remain onscreen before it goes away. If another message is drawn
	//while an old message is still displaying, both messages remain, the new message scrolls up the old message.
// style
    // Where to show the message on the screen: - 1 = upper left - 2 = upper center - 3 = lower right
	//- 4 = lower center Note that all these locations have their own defined slightly different fonts
	//and default sizes, enforced by the stock KSP game.
// size
    // A number describing the font point size: NOTE that the actual size varies depending on which of
	//the above styles you’re using. Some of the locations have a magnifying factor attached to their fonts.
// colour
    // The colour to show the text in, using one of the built-in colour names or the RGB constructor to make one up
// doEcho
    // If true, then the message is also echoed to the terminal as “HUD: message”.

// Examples:
	//HUDTEXT(Message, delaySeconds, style, size, red, doEchoTerminal).
	HUDTEXT("Warning: Vertical Speed too High", 5, 2, 15, red, false).
		wait 3.
	HUDTEXT("docking mode begun", 8, 1, 12, rgb(1,1,0.5), false).
		wait 3.
}.	

//------------------------------------  VETORES  ----------------------------------------------------------------------------

FUNCTION TEST_DESENHA_VETORES{          //chamar uma vez soh: PRECISA DE SENSORES ESPECIFICOS
    parameter Vetor_par.
    parameter a is 20.0.
    parameter b is 20.0.
    parameter c is 20.0.
    
	local NOME_DA_FUNC is "TEST_DESENHA_VETORES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    global Div_Factor_kN is 250.0.
    
    //VECDRAW(start, vec, color, label, scale, show, width)
    //VECDRAWARGS(start, vec, color, label, scale, show, width)

    //Both these two function names do the same thing. 
    // They create a new vecdraw object that you can then manipulate to show things on the screen:
    
    DEBUG(NOME_DA_FUNC,"Definindo vetores de Velocidade, Gravidade, Peso, Aceleracao e Thrust ...",False).
    global Seta_Que_Mostra_Vetor_Velocidade TO VECDRAW(
          V(-5,5,0),//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
          Vetor_par,//V(a,b,c),
          RGB(1,0,0),
          "VELOCIDADE",
          1.0,
          TRUE,
          0.2
        ).
		
    if (TEST_CHECK_SENSORES("sensorGravimeter")){
        //
		global Seta_Que_Mostra_Vetor_GRAVIDADE TO VECDRAW(
			  V(-7,5,0),//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
			  SHIP:SENSORS:GRAV,//V(a,b,c),         //vec to show
			  RGB(1,1,0),                           //color
			  "GRAVIDADE",                          //label
			  1.0,                                  //scale
			  TRUE,                                 //show
			  0.2,                                  //width
              True,                                 //pointy
              True                                  //wiping
			).		//RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA, PURPLE(Alias of MAGENTA), WHITE, BLACK
		global Seta_Que_Mostra_Vetor_PESO TO VECDRAW(
			  V(-5,-5,0),//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
			  (SHIP:SENSORS:GRAV * SHIP:MASS) / Div_Factor_kN,//V(a,b,c),
			  RGB(0,1,0),
			  "PESO",
			  1.0,
			  TRUE,
			  0.2
			).

        DEBUG(NOME_DA_FUNC,"Gravidade: eh mentira que usa trigger: isto eh uma funcao que faz update auto ...",False).
		set Seta_Que_Mostra_Vetor_GRAVIDADE:vecupdater to {
		   return SHIP:SENSORS:GRAV. }.
        DEBUG(NOME_DA_FUNC,"Peso: eh mentira que usa trigger: isto eh uma funcao que faz update auto ...",False).
		set Seta_Que_Mostra_Vetor_PESO:vecupdater to {
		   return (SHIP:SENSORS:GRAV * SHIP:MASS) / Div_Factor_kN. }.
		//
    }
	else{
		print_stat(tlog,"FALTA sensorGrav!",contador_log).
	}.
		
    if (TEST_CHECK_SENSORES("sensorAccelerometer")){
        //
		global Seta_Que_Mostra_Vetor_ACELERACAO TO VECDRAW(
			  V(5,-5,0),//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
			  SHIP:SENSORS:ACC,//V(a,b,c),
			  RGB(0,0,1),
			  "ACELERACAO",
			  1.0,
			  TRUE,
			  0.2
			).
        DEBUG(NOME_DA_FUNC,"Aceleracao: eh mentira que usa trigger: isto eh uma funcao que faz update auto ...",False).
		set Seta_Que_Mostra_Vetor_ACELERACAO:vecupdater to {
		   return SHIP:SENSORS:ACC. }.
		//
    }
	else{
		print_stat(tlog,"FALTA sensorAccel!",contador_log).
	}.

    global Seta_Que_Mostra_Vetor_THRUST TO VECDRAW(
          V(-5,-5,0),//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
          ((ship:MAXTHRUST * THROTTLE)/Div_Factor_kN) * ship:facing:vector,//V(a,b,c),
          RGB(0,1,1),
          "THRUST",
          1.0,
          TRUE,
          0.2
        ).
    
    DEBUG(NOME_DA_FUNC,"Velocidade: eh mentira que usa trigger: isto eh uma funcao que faz update auto ...",False).
    set Seta_Que_Mostra_Vetor_Velocidade:vecupdater to {
       return ship:velocity:surface. }.
       
    DEBUG(NOME_DA_FUNC,"Thrust: eh mentira que usa trigger: isto eh uma funcao que faz update auto ...",False).
    set Seta_Que_Mostra_Vetor_THRUST:vecupdater to {
       return ((ship:MAXTHRUST * THROTTLE)/Div_Factor_kN) * ship:facing:vector. 
    //ship:availablethrust
    //ship:maxthrust
    //t_STAR//GLOBA MAS SO EH DECLARADA EM HOVER
       //ship:up:vector 
       //ship:north:vector
       //SHIP:FACE
       //vang(up:vector, ship:facing:vector).
       //vang(ves:up:vector, ves:facing:forevector).
       //ves:facing:starvector   , ves:facing:topvector
       
        //MAXTHRUST 	scalar 	Sum of active maximum thrusts
        //MAXTHRUSTAT(pressure) 	scalar 	Sum of active maximum thrusts at the given atmospheric pressure
        //AVAILABLETHRUST 	scalar 	Sum of active limited maximum
       }.
}.

FUNCTION TEST_VEC_STARTUPDATER{ // This example will bounce the arrow 
    set hops to inc(hops).
    //
    // This example will bounce the arrow up and down over time for a few seconds,
    // moving the location of the vector's start according to a sine wave over time:
    local vd to vecdraw(v(5,5,5), ship:north:vector*5, green, "bouncing arrow", 1.0, true, 0.2).//
    print "Moving the arrow up and down for a few seconds.".
    set vd:startupdater to { return ship:up:vector*3*sin(time:seconds*180). }.
    wait 5.
    print "Stopping the arrow movement.".
    set vd:startupdater to DONOTHING.
    wait 3.
    print "Removing the arrow.".
    set vd to 0.
}.
    
FUNCTION TEST_VEC_VECUPDATER{// This example will spin the arrow
    set hops to inc(hops).
// VecDraw:VECUPDATER
    // Access:	Get/Set
    // Type:	KosDelegate with no parameters, returning a Vector
    // This allows you to tell the VecDraw that you’d like it to update the VEC suffix of the vector regularly every update, according to your own scripted code.
    // You create a KosDelegate that takes no parameters, and returns a vector, which the system will automatically assign to the VEC suffix every update. Be aware that this system does eat into the instructions available per update, so if you make this delegate do too much work, it will slow down your script’s performance.
    // To make the system stop calling your delegate, set this suffix to the magic keyword DONOTHING.

    // This example will spin the arrow around in a circle by leaving the start
    // where it is but moving the tip by trig functions:
    local vd to vecdraw(v(0,0,0), v(5,0,0), green, "spinning arrow", 1.0, true, 0.2).
    print "Moving the arrow in a circle for a few seconds.".
    set vd:vecupdater to {
       return ship:up:vector*5*sin(time:seconds*180) + ship:north:vector*5*cos(time:seconds*180). }.
    wait 5.
    print "Stopping the arrow movement.".
    set vd:vecupdater to DONOTHING.
    wait 3.
    print "Removing the arrow.".
    set vd to 0.
}.

FUNCTION TEST_VEC_COLORUPDATER{// This example will change how opaque
    set hops to inc(hops).

//VecDraw:COLORUPDATER
    //Access:	Get/Set
    //Type:	KosDelegate with no parameters, returning a Color
//    This allows you to tell the VecDraw that you’d like it to update the COLOR/COLOUR suffix of the vector regularly every update, according to your own scripted code.
  //  You create a KosDelegate that takes no parameters, and returns a Color, which the system will automatically assign to the COLOR suffix every update. Be aware that this system does eat into the instructions available per update, so if you make this delegate do too much work, it will slow down your script’s performance.
//    To make the system stop calling your delegate, set this suffix to the magic keyword DONOTHING.

    // This example will change how opaque the arrow is over time by changing
    // the 'alpha' of its color:
    local vd to vecdraw(v(0,0,0), ship:north:vector*5, green, "fading arrow", 1.0, true, 0.2).
    print "Fading the arrow in and out for a few seconds.".
    set vd:colorupdater to { return RGBA(0,1,0,sin(time:seconds*180)). }.
    wait 5.
    print "Stopping the color change.".
    set vd:colorupdater to DONOTHING.
    wait 3.
    print "Removing the arrow.".
    set vd to 0.
    
}.

FUNCTION TEST_VEC_MOSTRA{//TESTA SE OS SENSORES PARA VETORES EXISTES E ATIVA OS VEC
    parameter Seta_Vetor_Configurar is VECDRAW(
			  V(2,2,0),     //(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
			  V(2,2,2),     //V(a,b,c),         //vec to show
			  RGB(1,1,1),                           //color //RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA, PURPLE(Alias of MAGENTA), WHITE, BLACK
			  "VETOR",                              //label
			  1.0,                                  //scale
			  TRUE,                                 //show
			  0.2,                                  //width
              True,                                 //pointy
              True                                  //wiping
			).		

    parameter Mostra_vetores is True.
    parameter Configuracao is "no".//"all"=seta para todos //"label", "color", etc
   
    set hops to inc(hops).

    //testa se os vetores existem:
    local vetor_accell_existe is false.
    local vetor_peso_existe is false.
    local vetor_gravid_existe is false.
    //local vetor_accell_existe is false.
    //local vetor_accell_existe is false.

    if (TEST_CHECK_SENSORES("sensorGravimeter")){
        set vetor_peso_existe to True.
        set vetor_gravid_existe to True.
    }
    else{
        debug(NOME_DA_FUNC, "VEC: erro: Sensor nao presente: sensorGravimeter", True).
    }.

    if (TEST_CHECK_SENSORES("sensorAccelerometer")){
        set vetor_accell_existe to True.
    }
    else{
        debug(NOME_DA_FUNC, "VEC: erro: Sensor nao presente: sensorAccelerometer", True).
    }.

    if (Configuracao = "all"){//liga/desliga todos os vetores: como saber de todos?            
        set Seta_Que_Mostra_Vetor_THRUST:SHOW       to Mostra_vetores.        
        set Seta_Que_Mostra_Vetor_Velocidade:SHOW   to Mostra_vetores.
        if (vetor_accell_existe){ set Seta_Que_Mostra_Vetor_ACELERACAO:SHOW to Mostra_vetores.  }
        if (vetor_gravid_existe){ set Seta_Que_Mostra_Vetor_GRAVIDADE:SHOW  to Mostra_vetores.  }
        if (vetor_peso_existe)  { set Seta_Que_Mostra_Vetor_PESO:SHOW       to Mostra_vetores.  }
    }

    if (vetor_peso_existe){
        if (Seta_Vetor_Configurar = Seta_Que_Mostra_Vetor_PESO) {
            set Seta_Que_Mostra_Vetor_PESO:show to Mostra_vetores.
        }
    }
    if (vetor_accell_existe){
        if (Seta_Vetor_Configurar = Seta_Que_Mostra_Vetor_ACELERACAO) {
            set Seta_Que_Mostra_Vetor_ACELERACAO:show to Mostra_vetores.
        }
    }
    if (vetor_gravid_existe){
        if (Seta_Vetor_Configurar = Seta_Que_Mostra_Vetor_GRAVIDADE) {
            set Seta_Que_Mostra_Vetor_GRAVIDADE:show to Mostra_vetores.
        }
    }
    //OS VALORES DE AGREGATES SAÕ PASSADOS COMO se fossem by_reference e não precisa disso:
    // ao mudar o valor do parametro vai mudar o vetor original! (testar)
    if (Seta_Vetor_Configurar = Seta_Que_Mostra_Vetor_THRUST) {
        set Seta_Que_Mostra_Vetor_THRUST:show to Mostra_vetores.
    }
    if (Seta_Vetor_Configurar = Seta_Que_Mostra_Vetor_Velocidade) {
        set Seta_Que_Mostra_Vetor_Velocidade:show to Mostra_vetores.
    }

    //isto é muito útil neste caso, mas não vai funcionar aqui pois eu quero o vetor no parametro então a verificação tem que ser antes de chamar a função
    if defined(Seta_Que_Mostra_Vetor_GRAVIDADE){

    }

    //Finalmente o que eu quero fazer é isto:
    //receber o vetor e fazer coisas com ele: ATIVA/DESATIVA, MUDA LABEL, OPACO/TRANSPARENTE
    //A checgem por sensores deve ser feita na criação do vetor ou ao mudar seu vecupdater: NÃO AQUI


}
//------------------------------------  FIM VETORES  ----------------------------------------------------------------------------


//------------------------------------  SENSORES     ----------------------------------------------------------------------------
FUNCTION TEST_CHECK_SENSORES{		//procura por sensor indicado no pri par e retorna se encontrou
    parameter check_sens    .
    parameter show_valores  is False.
    parameter dump_sens     is False.
    parameter turn_all_on   is False.
    parameter debug_CHECK_SENSORES is False.
    //
	local NOME_DA_FUNC is "TEST_CHECK_SENSORES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    local SENSELIST is list().
    debug(NOME_DA_FUNC, "Full Sensor Dump:", debug_CHECK_SENSORES).
    debug(NOME_DA_FUNC, "FAZER: LIMPAR ESSA FUNCAO DE PRINTS!!!", debug_CHECK_SENSORES).
    
    LIST SENSORS IN SENSELIST.

    debug(NOME_DA_FUNC,"quantidade:" + SENSELIST:length, debug_CHECK_SENSORES).
    // TURN EVERY SINGLE SENSOR ON
    FOR S IN SENSELIST {
      //print S:suffixnames. 
      if (show_valores){
		  PRINT_STAT(tlog,"sensor valors to debg!",contador_LOG).//
          if      (S:TYPE = "GRAV"){
              PRINT "GRAVIDADE      :"+ SHIP:SENSORS:GRAV.
			  debug(NOME_DA_FUNC, "GRAVIDADE      :"+ SHIP:SENSORS:GRAV, True).//true vai forcar debug
          }
          else if (S:TYPE = "ACC"){
              PRINT "ACELERAÇÃO     :"+ SHIP:SENSORS:ACC.
			  debug(NOME_DA_FUNC, "ACELERAÇÃO     :"+ SHIP:SENSORS:ACC, True).//true vai forcar debug
          }
          else if (S:TYPE = "TEMP"){ 
              PRINT "TEMPERATURA    :"+ SHIP:SENSORS:TEMP.
			  debug(NOME_DA_FUNC, "TEMPERATURA    :"+ SHIP:SENSORS:TEMP, True).//true vai forcar debug
          }
          else if (S:TYPE = "PRES"){ 
              PRINT "PRESÃO         :"+ SHIP:SENSORS:PRES.
			  debug(NOME_DA_FUNC, "PRESÃO         :"+ SHIP:SENSORS:PRES, True).//true vai forcar debug
          }
          else if (S:TYPE = "LIGHT"){ 
              PRINT "INCIDENCIA LUZ :"+ SHIP:SENSORS:LIGHT.
			  debug(NOME_DA_FUNC, "INCIDENCIA LUZ :"+ SHIP:SENSORS:LIGHT, True).//true vai forcar debug
          }
          else {
              print "SENSOR DESCONHECIDO: [" + S:TYPE + "]".
			  debug(NOME_DA_FUNC, "SENSOR DESCONHECIDO: [" + S:TYPE + "]", True).//true vai forcar debug
          }.
      }
      
      if (dump_sens){
		  PRINT_STAT(tlog,"sensor dump to debug!",contador_LOG).
		  debug(NOME_DA_FUNC, "NAME            :  " + S:NAME, True).//true vai forcar debug
		  debug(NOME_DA_FUNC, "SENSOR TYPE     :  " + S:TYPE, True).//true vai forcar debug
		  debug(NOME_DA_FUNC, "DISPLAY         :  " + S:DISPLAY, True).//true vai forcar debug
		  debug(NOME_DA_FUNC, "POWERCONSUMPTION:  " + S:POWERCONSUMPTION, True).//true vai forcar debug
		  debug(NOME_DA_FUNC, "SENSOR INFO     :  " + S, True).//true vai forcar debug
          
          local MODULO_SENSOR to S:GETMODULE("ModuleEnviroSensor").
          //ATENÇÃO!!! vai mudar conforme a linguagem do jogo:
		  debug(NOME_DA_FUNC, "FIELD:display (em ingles) :   atencao que nessa parte vai dar erro se estiver na ling errada:", True).
		  debug(NOME_DA_FUNC, "FIELD:display (em ingles) :   FAZER: CONFORME A LINGUAGEM:", True).
		  debug(NOME_DA_FUNC, "FIELD:display (em ingles) :  " + MODULO_SENSOR:GETFIELD( "display" ), True).//ingles
		  //debug(NOME_DA_FUNC, "FIELD:exibição (em portug) :  " + MODULO_SENSOR:GETFIELD( "exibição" ), True).//portug
          //PRINT "FIELD:exibição  :  " + MODULO_SENSOR:GETFIELD( "exibição" ).	//portug
          //PRINT "MODULO_SENSOR:suffixnames  :  " + MODULO_SENSOR:suffixnames.
          
		  //posso usar isso para descobrir o tipo de dado:
			//PRINT "MODULO_SENSOR:allfields  	:  " + MODULO_SENSOR:allfields.
		  //isso pega o nome propriamente
			//PRINT "MODULO_SENSOR:allfieldnames:  " + MODULO_SENSOR:allfieldnames.
          
          //wait 3.
      }.
      
      if (turn_all_on){
          IF S:ACTIVE {
            debug(NOME_DA_FUNC,  "     SENSOR IS ALREADY ON.").
          } ELSE {
            debug(NOME_DA_FUNC,  "     SENSOR WAS OFF.  TURNING IT ON.").
            S:TOGGLE().
              wait 0.2.
              debug(NOME_DA_FUNC,  "VALUE           :  " + S:DISPLAY).          
          }
      }.
      
      if (check_sens = S:NAME){
          return True.
      }.
    
    }.
    
	if (check_sens = ""){return FALSE.}
	else{
		debug(NOME_DA_FUNC, "sensor nao encontrado na nave: " + check_sens, debug_CHECK_SENSORES).//true vai forcar debug
	}.
    return FALSE.
    // structure Sensor
        // Suffix 	Type 	Description
        // All suffixes of Part 	  	Sensor objects are a type of Part
        // ACTIVE 	Boolean 	Check if this sensor is active
        // TYPE 	  	 
        // DISPLAY 	string 	Value of the readout
        // POWERCONSUMPTION 	scalar 	Rate of required electric charge
        // TOGGLE() 	  	Call to activate/deactivate
        
 // structure VesselSensors
    // Members¶ Suffix 	Type 	Description
    // ACC 	Vector 	Acceleration experienced by the Vessel
    // PRES 	scalar 	Atmospheric Pressure outside this Vessel
    // TEMP 	scalar 	Temperature outside this Vessel
    // GRAV 	Vector (g’s) 	Gravitational acceleration
    // LIGHT 	scalar 	Sun exposure on the solar panels of this Vessel        
}.

FUNCTION verificar_nave{		//Fará os testes para saber se os componentes necessários estão presentes
    parameter checar_todas_naves is false.
    parameter debug_verificar_nave is false.
    //parameter check_sens is false.
//    parameter show_valores  is False.

	local NOME_DA_FUNC is "VERIFICA_NAVE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    debug(NOME_DA_FUNC, "Mais hardcoded configs....", debug_verificar_nave).
	
    if (SHIP:name = "Kerbal X kos2") and (not(checar_todas_naves)){
   		print_stat(tlog,("NAVE OK:" + SHIP:name),contador_log).

        return true.
    }
    ELSE if (SHIP:name = "GDLV3_KOS_1") and (not(checar_todas_naves)){//isso ta feio
   		print_stat(tlog,("NAVE OK:" + SHIP:name),contador_log).

        return true.
    }
    else{
        if (debug_verificar_nave){
            //
            debug(NOME_DA_FUNC, "FAZER: LIMPAR ESSA FUNCAO DE PRINTS!!!", debug_verificar_nave).

            print "funcao : " +NOME_DA_FUNC + " ".
            print "NAVE DESCONHECIDA:" + SHIP:name.
            print " ".
            print "estagios da nave".
            print "nave tem motores".
            print "hover tem legs".
            print "nave tem fontes de energia alem de baterias".					//
            //print "quanto tempo de bateria restante".								//ESPERAR UM TEMPO
            print "motores conseguem levantar nave".								//TWR
            print "recomendar sensores: para vetores:". //para mostrar vetores
            print "sensorBarometer, sensorAccelerometer e sensorGravimeter".
            print " ".

            Print "MAXTHRUST        " + SHIP:MAXTHRUST.
        }
            
            if (TEST_CHECK_SENSORES("sensorBarometer") ){
                if (debug_verificar_nave){
                    Print "MAXTHRUSTAT(press:"+ SHIP:SENSORS:PRES +") [" + SHIP:MAXTHRUSTAT(SHIP:SENSORS:PRES) + "]".
                    Print "AVAILABLETHRUSTAT(press:"+ SHIP:SENSORS:PRES +") [" + SHIP:AVAILABLETHRUSTAT(SHIP:SENSORS:PRES) + "]".
                }
            }
            ELSE {
                if (debug_verificar_nave){
                    Print "MAXTHRUSTAT(press)".
                    Print "AVAILABLETHRUSTAT(press)".
                }
        		print_stat(tlog,"FALTA sensorBarm!",contador_log).
            }.
            
        if (debug_verificar_nave){
            Print "AVAILABLETHRUST  " + SHIP:AVAILABLETHRUST.
            print "  ciclar entre os motores do estagio e encontrar o thrust".
            pRINT "".
            
            Print "MASS             " + SHIP:MASS.
            Print "WETMASS          " + SHIP:WETMASS.
            Print "DRYMASS          " + SHIP:DRYMASS.
            print " ".
        }
        // MAXTHRUST	scalar	Sum of active maximum thrusts
        // MAXTHRUSTAT(pressure)	scalar	Sum of active maximum thrusts at the given atmospheric pressure
        // AVAILABLETHRUST	scalar	Sum of active limited maximum thrusts
        // AVAILABLETHRUSTAT(pressure)	scalar	Sum of active limited maximum thrusts at the given atmospheric pressure
        // MASS	scalar (metric tons)	Mass of the ship
        // WETMASS	scalar (metric tons)	Mass of the ship fully fuelled
        // DRYMASS	scalar (metric tons)	Mass of the ship with no resources

        if (debug_verificar_nave){
                BEEP("bipinho").
                //wait 5.    
                //TEST_CHECK_SENSORES("", True).//imprime os valores dos sensores presentes
                BEEP("bipinho").
                //wait 5.    //mais isso
        }



        return false.
    }
}.
//------------------------------------  FIM SENSORES  ----------------------------------------------------------------------------
FUNCTION BEEP{		//IDENTICA A cp.ks
	parameter opcao_beep 	is "padrao".
	parameter esperar		is false.
	parameter tempo_beep 	is -1.
    parameter freq_beep     is 400.
    parameter DEBUG_BEEP    is True.
	
	local NOME_FUNC is "BEEP".

	local tempo_espera_beep to 0.00001.
	if (esperar=false){set tempo_espera_beep 	to 0.00001.}
	else {
		if tempo_beep>0{}.
		
	}.

	if (opcao_beep = "padrao"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0). // Gets a reference to the zero-th voice in the chip.
        set tempo_beep to 2.5.
		V0:PLAY( NOTE(freq_beep, tempo_beep) ).  // Starts a note at 400 Hz for 2.5 seconds.
	}

	if (opcao_beep = "especificado"){
        DEBUG(NOME_FUNC, "beep especificado: " +tempo_beep+"s at "+freq_beep+"Hz", DEBUG_BEEP).
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep<0{set tempo_beep to (0.1).}
		V0:PLAY( NOTE(freq_beep, tempo_beep) ).
	}

	if (opcao_beep = "attention"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep<0{set tempo_beep to (0.1).}
		V0:PLAY( NOTE(freq_beep, tempo_beep) ).
	}
	if (opcao_beep = "menu"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
        set tempo_beep to 0.1.
		V0:PLAY( NOTE(900, tempo_beep) ).
	}
	if (opcao_beep = "cmd"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
        set tempo_beep to 0.05.
		V0:PLAY( NOTE(800, tempo_beep) ).
	}
	if (opcao_beep = "key"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
        set tempo_beep to 0.01.
		V0:PLAY( NOTE(1800, tempo_beep) ).
	}
	if (opcao_beep = "mission_compl"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
        set tempo_beep to 0.9.
		V0:PLAY( NOTE(1050, tempo_beep) ).
	}
	if (opcao_beep = "step_fl"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
        set tempo_beep to 0.05.
		V0:PLAY( NOTE(750, tempo_beep) ).
	}
	else if (opcao_beep = "erro"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0). // Gets a reference to the zero-th voice in the chip.
		V0:PLAY( NOTE(450, 2.0) ).  // Starts a note at 400 Hz for 2.5 seconds.
	}
	else if (opcao_beep = "cmd"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep<0{set tempo_beep to (0.5).}
		else{}
		V0:PLAY( NOTE(freq_beep, tempo_beep) ).
	}
	else if (opcao_beep = "ja_existe"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep>0{}
		else{
			set tempo_beep to (0.5).}
		V0:PLAY( NOTE(350, tempo_beep) ).
	}
	else if (opcao_beep = "copiar"){
		LOCAL V0 IS 0.
		SET V0 TO GETVOICE(0).
		if tempo_beep>0{}
		else{
			set tempo_beep to (2*0.5).}
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
	
