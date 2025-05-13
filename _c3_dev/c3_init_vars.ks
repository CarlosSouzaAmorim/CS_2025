@LAZYGLOBAL OFF.
//c3_init_vars.ks
// 5 funcoes: 266 linhas
//recompila

//INICIALIZA_VARS_MAIN_PROG().

FUNCTION INICIALIZA_VARS_MAIN_PROG{
	//parameter debug_level_trace is False.       //Como a biblioteca c3_scr_msg ainda nao foi executada a funcao trace ainda nao esta disponivel
	parameter VERSAO_PROG is 0.
	
	local NOME_DA_FUNC is "INICIALIZA_VARS_MAIN_PROG".
	//if (debug_level_trace){print "trace: " + NOME_DA_FUNC.}.
	trace(NOME_DA_FUNC).	
	
    // init code:
    INIT_VARS_PRINT_STAT().

    INIT_VARS_GET_PARTS().          //FUNCTION TEST_PARTS_GET_MODULES
    INIT_VARS_SIZE_FILE().          //EM FUNCTION TEST_SIZE_FILE

    INIT_VARS_CONTROL_LOOP_PRINC().
    
	INIT_VARS_LINHA_DO_PROMPT().
	
	INIT_VARS_MENU().               //nao ta iniciando?
	INIT_OBJETIVOS().
    INIT_VARS_TITULOS_E_BORDAS_PADRAO().
    INIT_VARS_TELA().
    INIT_VARS_VALORES_DEFAULT().

}.//FIM INICIALIZA_VARS_MAIN_PROG

FUNCTION INIT_OBJETIVOS{
	//OBJETIVOS DE VOO:
	global OBJETIVOS_AP_MAX 		is 80000	.
	global OBJETIVOS_PE_MIN 		is 80000	.
	global OBJETIVOS_VE_MAX_ATM 	is 300		.
	global OBJETIVOS_VE_MAX 		is 1000		.//Quanto menor o ganho maior pode/deve ser a vel
	global OBJETIVOS_INC_GANHO 	    is 4		.//ORIG 10
	global OBJETIVOS_STAG_MAX_ASC 	is stage:number . //LIFTOFF e PRIM STAGE
	global OBJETIVOS_THRTL_MAX 		is 1.0		.
	global OBJETIVOS_HEAD_INCL 		is 90		.//INICIAL VER FAZER
	global OBJETIVOS_HEAD_LAT 		is 90.//355		.//FIXO //90 ORIG
	
	global CONFIG_DEF_IPU 			is 1000		.//#500 #2000MAX

	global OBJETIVOS_HOVER_ALT		is 10.
	global OBJETIVOS_QUEDA_HOV_ALT	is 10.//1000
	global OBJETIVOS_KILL_VSURF		is 10.0.//menos melhor//USADA NA FUNCAO HOVER TB

}.

FUNCTION INIT_VARS_DEBUG{           //NAO EH INIciada por INICIALIZA_VARS_MAIN_PROG e sim no C3.KS no comeco do prog
	//VARS DE DEBUG:
	global debug_controle_nave 	        is False	.//isso fica dentro de um trigger : como que faz dai: fica dentro de uma funcao tb
	global debug_level_trace_verbose    is False	.//PARA FUNCOES REPETITIVAS EM LOOPS
	global DEBUG_DELAY_CLEARSCR         is 5		.//tempo em seg para pausar antes de limpar a tela no modo debug
	global LISTA_DEBUG 			        to list()	.
	global LISTA_TRACE 			        to list()	.
    global debug_prog_AVISA_INICIO_SOM  is True     .//AVISA QUANDO O PROGRAMA TERMINOU DE COMPILAR E INICIAR
    GLOBAL SOM_INTRO_PROGRAMA           IS "toque_1".//toque_1, TOQUE_7_NATION_INTRO

    global debug_level_trace			is False     .//Usado para saber as funções executadas 098
	
	global 	LOG_DEBUG  			is True     		.
	global 	FILE_DEBUGLOG		is "0:/debug_"+ship:name+"_cpu_"+core:tag+".log"	.
	global 	FILE_MSG_LOG		is "0:/msg.log"		.
	global 	FILE_ALL_MSG_LOG	is "0:/all_msg.log"	.//isto é usado somente para encontrar problemas nas mensagens.
	global 	LOG_ALL_MSG 		is False     		.//isto é usado somente para encontrar problemas nas mensagens.
}.

FUNCTION INIT_VARS_LINHA_DO_PROMPT{
	//OPCOES DE COMANDOS PARA LINHA DO PROMPT:
	global NOME_CMD_IPU 	            is "IPU".
	global NOME_CMD_TELNET 	            is "TELNET".
	global NOME_CMD_TEL_PORT 	        is "TELPORT".
	global NOME_CMD_TEL_IP 	            is "TELIP".
    
    
	global NOME_CMD_LIFTOFF             is "LIFTOFF".
	global NOME_CMD_ABORT 	            is "ABORT".
	global NOME_CMD_SIMPLE_STAGING	 	is "SIMPLE_STAGING"	.
	global NOME_CMD_KILL	 	        is "KILL"	        .
	global NOME_CMD_HUP	 	            is "HUP"	        .
	global NOME_CMD_HOVER			    is "HOVER" 		    .
	global NOME_CMD_STAGE			    is "STAGE" 		    .
	global NOME_CMD_QUEDA				is "QUEDA"			.
    
	global NOME_CMD_HELP				is "HELP"			.//MENU
	global NOME_CMD_OBJETIVOS			is "OBJETIVOS"		.//MENU
	global NOME_CMD_CONFIG				is "CONFIG"			.//MENU
	global NOME_CMD_CONTROLE			is "CONTROLE"		.//MENU
	global NOME_CMD_TELA				is "TELA"			.//MENU
	global NOME_CMD_MENU_SET_TELA		is "SET_TELA"		.//MENU
	global NOME_CMD_MENU_VEC_CONF		is "VEC_CONF"		.//MENU
	global NOME_CMD_MENU_VEC_SHOW		is "VEC_SHOW"		.//MENU
	global NOME_CMD_MENU_VEC_TEST		is "VECT_TEST"		.//MENU

	global NOME_CMD_MENU_TELNET			is "TELNETM"		.//MENU
	global NOME_CMD_MENU_NAVE			is "NAVE"		    .//MENU
	global NOME_CMD_MENU_TEST_TELA 		is "TEST_TELA"		.//MENU
	global NOME_CMD_MENU_REBOOT			is "MENUREBOOT"		.//MENU
    //que
    
	global NOME_CMD_PARTS_NAVE			is "PARTSNAVE"		.//MENU
    
	global NOME_CMD_VOLTAR			    is "VOLTAR" 		.
    
	global NOME_CMD_SAIR			    is "SAIR" 		    .
    global NOME_CMD_REBOOT              is "REBOOT"         .
	global NOME_CMD_RECOVERY_BOOT		is "RECOVERY"		.
	global NOME_CMD_FAST_REBOOT			is "FASTREBOOT"		.//realizar_reboot_fast
	global NOME_CMD_BEEP				is "BEEP"			.
	global NOME_CMD_LIST				is "LIST"			.
	global NOME_CMD_LIST_DEF			is "FILES"			.
	global NOME_CMD_SEND_MSG			is "SENDVES"		.
	global NOME_CMD_SEND_MSG_CORE		is "SENDCORE"		.
	
	global NOME_CMD_KSP_INFO			is "KSP_INFO"		.
	global NOME_CMD_KOS_INFO			is "KOS_INFO"		.
	global NOME_CMD_SISTEMA				is "SISTEMA"		.

	global NOME_CMD_get_AP_MAX			is "AP"				.
	global NOME_CMD_get_HLAT			is "HLAT"			.
	global NOME_CMD_get_INCL			is "INCL"			.
	global NOME_CMD_get_INCG			is "INCG"			.
	global NOME_CMD_get_VMAX			is "VMAX"			.
	global NOME_CMD_get_VMATM			is "VMATM"			.
	global NOME_CMD_get_PE			    is "PE"			    .
	global NOME_CMD_get_THRM			is "THRM"			.
	global NOME_CMD_get_STGM			is "STGM"			.
	global NOME_CMD_get_HOVER			is "HOVER"			.
	global NOME_CMD_SEPARATION			is "SEP"			.

	global NOME_CMD_COL1_POS			is "COL1POS"		.
	global NOME_CMD_ESP_COLS			is "ESP_COLS"		.
	global NOME_CMD_REDES_TELA			is "REDES_TELA"		.
     
	global NOME_CMD_STOP_TELNET_LOOP	is "STOPTELNETLOOP" .
    
	global NOME_CMD_TESTE_1				is "TESTE_1" 		.
	global NOME_CMD_TESTE_2				is "TESTE_2" 		.
	global NOME_CMD_TESTE_3				is "TESTE_3" 		.
	global NOME_CMD_TESTE_4				is "TESTE_4" 		.
	global NOME_CMD_TESTE_5				is "TESTE_5" 		.
	global NOME_CMD_TESTE_6				is "TESTE_6" 		.
	global NOME_CMD_TESTE_7				is "TESTE_7" 		.
	global NOME_CMD_TESTE_8				is "TESTE_8" 		.
	global NOME_CMD_TESTE_9				is "TESTE_9" 		.
	global NOME_CMD_TESTE_10			is "TESTE_10"		.
	global NOME_CMD_TESTE_11			is "TESTE_11" 		.

	//OPCOES ATIVA / DESATIVA:
		global DEF_CMD_TRUE 	is "TRUE".
		global DEF_CMD_FALSE 	is "FALSE".
        
    //COMANDOS DA LINHA DE COMANDO:
    global Hist_Com to list().
}.

FUNCTION INIT_VARS_MENU{
	//tipos de de menu:
	global MENU_REEXIBIR		is -1.//esta variavel representa que um menu ainda nao foi selecionado
	global MENU_INICIAL 		is 0. //MENU_PRINCIPAL
    
    //verdadeiros menus
	global MENU_AJUDA   		is 1. //fazer MENU_INICIAL
	global MENU_OBJETIVOS		is 2.
	global MENU_CONFIG			is 3.
	global MENU_TELA			is 4.
        
    global MENU_CONTROLE        is 5.//nem sei pq coloquei 5
    global MENU_PRINCIPAL       is MENU_INICIAL.
    global MENU_TELNET          is 7.
    global MENU_NAVE            is 8.
    global MENU_NAVE_PARTS      is 9.
    global MENU_TEST_MENS       is 10.
    global MENU_TEST_TELA 	    is 11.
    
    global MENU_CTRL_ROVER      is 12.//fix
    global MENU_CTRL_ROVER_ALT  is 13.
    global MENU_CTRL_ROVER_HEAD is 14.
    global MENU_CTRL_ROVER_COMP is 15.
    global MENU_VEL_LOOP_ROVER 	is 16.
		
	global MENU_RESOURCES		is 17.
	global MENU_STATUS_NAVE		is 18.
	global MENU_SISTEMA			is 19.
	global MENU_REBOOT			is 20.

	global MENU_SET_TELA		is 21.
	global MENU_VEC_CONF		is 22.
	global MENU_VEC_SHOW		is 23.
	global MENU_VEC_TEST		is 24.

    //idicadores
	global MENU_ultimo_exibido                          is MENU_REEXIBIR.
	global MENU_esperando_valor_opcao_comando_de_exib   is "".
	global MENU_esperando_valor_opcao_num_de_MENU       is False.           //isto meio que desativa o modo menu temporariamente
    global MENU_anterior_a_este_atual                   is MENU_INICIAL.
	global CHAR_MENU_OPC_volta_menu_inic				is "-".

	//usadas no control por menu da funcao hovering:
	    //TEM QUE SER GLOBAL POR CONTA DOS MENUS:
    global Col_Init_CHA 		is 0.
    global Linha_Init_CHA 		is 0.

}.

FUNCTION INIT_VARS_TITULOS_E_BORDAS_PADRAO{
    global 	set_borders is "set_b"	.
    global 	def_borders is "def_b"	.

    //para PADROES_E_SETUP_SIZES
    global 	def_sizes 	            is "def_sz"	    .
    global 	def_pos_cols 	        is "def_pos_cls".
    global 	set_sizes 	            is "set_sz"	    .
    global 	set_sizes_LABELS_OFF 	is "set_sz_l0"  .
    global 	set_sizes_LABELS_ON 	is "set_sz_l1"  .
    global  set_sizes_TITLE_OFF		is "set_sz_t0"  .
    

    //esses label ficam em cima das msg:
    declare global log_label 	to "log do processo:"										.
    global 	log_label_scroll_up is "- - - - ^ - - - -"										.//FAZER FUNCAO PREPARA LINHA DE CHEIO (com ^ no meio)
    global 	label_titulo 		to "CONTROL TEST PROGRAM - CARLOS AMORIM - v" + VERSAO_PROG	.
    global 	label_prompt 		to "_"														.
    global 	label_passo 		to "PROXIMO:"												.
    global  label_menu	  		to "MENU:"													.
        
    //ESSES label é quando fica na frente da msg:
    global 	SETUP_LABEL_PROMPT 	to ""		        .//NAO DEF PADRAO AQUI: esta variavel vai ser alterada no redimendionamento
    global 	SETUP_LABEL_CMD 	to ""			    .//esta variavel vai ser alterada no redimendionamento
    global 	SETUP_LABEL_FILE 	to "FAZER log to file: "	.
    global 	SETUP_LABEL_INFO_LINE to ">:"			        .
                                  
    //CARACTERES PARA O DESENHO DAS BORDAS:
    global  caracter_borda_vert_e_dir is "|".
    global  caracter_borda_vert_e_esq is "|".
    global  caracter_borda_horz_e_sup is "-".
    global  caracter_borda_horz_e_inf is "-".

    global	caracter_borda_horz_i_ is "#".
    global	caracter_borda_vert_i_ is "\".
    global	caracter_borda_cent_i_ is "!".
                                      
    global 	caracter_borda_horz_i_cmd	is "-"	.
    global 	caracter_borda_horz_i_tim	is "."	.
    global 	caracter_borda_horz_i_pas	is "*"	.
    global 	caracter_borda_horz_i_stt	is "%"	.
    global 	caracter_borda_horz_i_men	is ":"	.
    global 	caracter_borda_vert_i_dir	is "|"	.
    global 	caracter_borda_vert_i_esq	is "/"	.// ? : ; ! % # \ fazer testar os caracteres especiais: usar funcao
    
}.

FUNCTION INIT_VARS_TELA{
    //usadas em function PADROES_E_SETUP_SIZES{
    global pos_col_rigth        to 0.
    global pos_col_left         to 0.
    
    global pos_col_central      to 0.
    global pos_col_central2     to 0.
    
    //fim function PADROES_E_SETUP_SIZES{
    
    //usadas em INICIALIZA_VARS_PRINT_STAT
    global col_timer        to 0.
	global lin_timer 	    to 0.

    global col_title        to 0.
    global lin_title        to 0.
	
	
	global col_passo 	to 0.
	global lin_passo 	to 0.
	
	global col_car 	    to 0.
	global lin_car 	    to 0.

	global col_CMD 	    to 0.
	global lin_CMD 	    to 0.
	
	global col_file 	to 0.
	global lin_file 	to 0.
	
	global col_status 	to 0.
	global lin_status 	to 0.
	
	global col_menu	    to 0.
	global lin_menu	    to 0.

	global col_lista    to 0.
	global lin_lista	to 0.
	global col_lista2    to 0.
	//global lin_lista2	to 0.

	global h_passo_max  to 0.
	global col_log 		to 0.
	global lin_log_init	to 0.
	
	global h_max_col_log   to 0.
	global h_max_col_list  to 0.
	//global h_max_col_list2  to 0.
    
    
    //fim INICIALIZA_VARS_PRINT_STAT
    
    //BATERIA FIXA:
    global Col_Mostra_Bat           is  0.
    global Lin_Mostra_Bat           is  0.
    

    global terminal_height_inicial              is terminal:height.
    global terminal_width_inicial               is terminal:width.
    global terminal_height_configurado          is terminal:height.     //INdica para qual tamanho de tela as posicoes foram desenhadas e configuradas
    global terminal_width_configurado           is terminal:width.
    global terminal_height_configurado_minimo   is terminal:height.
    global terminal_width_configurado_minimo    is terminal:width.

    global 	lista_msg 		TO LIST()		.	// Creates a new empty list in lista_msg variable
    global 	lista_log 		TO LIST()		.
    global 	lista_list 		TO LIST()		.
    global 	lista_list2		TO LIST()		.
    global 	lista_timer 	TO LIST()		.
    global 	lista_status 	TO LIST()		.
    global 	lista_passo 	TO LIST()		.
    global 	lista_title 	TO LIST()		.
    global 	lista_menu		to list()		.
    global 	lista_info_line	TO LIST()		.
    global 	lista_cmd   	TO LIST()		.

    global 	last_msd_added 				to ""			.
    global 	linha_digitada_no_prompt 	to ""		    .

    global largura_min_para_titulo			is 0.
    global largura_max_para_INFO_LINE 		is 0.

//ATENCAO NA FUNCAO QUE DEFINE OS VALORES PADRAO E QUE SETA OS VALORES DEFAULT (VALORES ABAIXO)!
		global larg_max_car 		is 0.
		global larg_min_car			is 0.
		global larg_max_msg_log 	is 0.
		global larg_min_msg_log		is 0.
		global h_titulo 	is 0.
		global h_timer		is 0.
		global h_passo		is 0.
		global h_menu		is 0.
		global h_car		is 0.
		global h_cmd		is 0.
		global h_file 		is 0.
		global h_status		is 0.
		global h_log		is 0.
		global h_lista		is 0.
		global term_border_er 	is 0. 
		global term_border_el 	is 0. 
		global term_border_es 	is 0.
		global term_border_ei	is 0.
		global term_border_ih 	is 0. 
		global term_border_iv 	is 0. 
		global term_border_c 	is 0. 

}.

FUNCTION INIT_VARS_VALORES_DEFAULT{
    		
//ATENCAO NA FUNCAO QUE DEFINE OS VALORES PADRAO SETAR ESTES VALORES DEFAULT!
		GLOBAL DEF_LARG_MAX_CAR 		IS 20.
		GLOBAL DEF_LARG_MIN_CAR			IS 5 .
		GLOBAL DEF_LARG_MAX_MSG_LOG 	IS 30.//olha
		GLOBAL DEF_LARG_MIN_MSG_LOG		IS 5 .
//DEFINIR AQUI ALTURAS MINIMAS:      >>> esta empilhando (de bx p cima): o status> menu> o q sobra fica pro passo
		GLOBAL DEF_H_TITULO 	IS 1.
		GLOBAL DEF_H_TIMER		IS 2.
		GLOBAL DEF_H_PASSO		IS 4.
		GLOBAL DEF_H_MENU		IS 15.//11 cabe 9
		GLOBAL DEF_H_CAR		IS 1.
		GLOBAL DEF_H_CMD		IS 1.
		GLOBAL DEF_H_FILE 		IS 1.
		GLOBAL DEF_H_STATUS		IS 10.//MUDEI AQUI VER > 7
		GLOBAL DEF_H_LOG		IS 3.
        global DEF_H_LISTA      IS 30.
//ATENCAO NA FUNCAO QUE DEFINE OS VALORES PADRAO E QUE ESTA OS VALORES DEFAULT!
		GLOBAL DEF_TERM_BORDER_ER 	IS 1. //BORDA EXT DIREITA.
		GLOBAL DEF_TERM_BORDER_EL 	IS 1. //BORDA EXT ESQUERDA.
		GLOBAL DEF_TERM_BORDER_ES 	IS 1.
		GLOBAL DEF_TERM_BORDER_EI	IS 1.
		GLOBAL DEF_TERM_BORDER_IH 	IS 1. //BORDA INTERNA HORIZONTAL.
		GLOBAL DEF_TERM_BORDER_IV 	IS 1. //BORDA INTERNA VERTICAL.
		GLOBAL DEF_TERM_BORDER_C 	IS 1. //BORDA INT CENTRAL. INUTIL
        
    global 	DEF_SETUP_LABEL_PROMPT 	to "PROMPT:"		        .
    global 	DEF_SETUP_LABEL_CMD 	to "CMD:"			        .

    global espaco_entre_colunas     to 30.//18
    global distancia_bat_da_dir     is 50.//em nome //era 20 NAO SEI PQ NAO ESTA MUDANDO//mudei novamente
        
    global 	VALOR_PADRAO_TEMPO_ERRO			is 10	.	//VALOR PADRAO PARA MSG DE ERR BIG:
    global	SETUP_LABELS_OFF				is False.
    global  CONFIG_DEF_SHOW_VERBOSE_NUM 	is True .
    
	global CONFIG_DEF_RESPECT_TELNET 			to False. //quando o telnet estiver ativo os redimensionamentos nao geram auto ajuste
													  //pelo contrario o sistema forca ficar na ultima configuracao valida    
    global ESTAVA_CONECTADO_AO_TELNET_ANTES 	to CONFIG:TELNET.//FAZER uma maneira de saber se estava conecado
}.

FUNCTION INIT_VARS_PRINT_STAT{
    global 	contador_log 	is 0	.
    global  contador_file   is 0    .
    global 	contador_timer 	is 0	.
    global 	contador_status is 0	.
    global 	contador_title 	is 0	.
    global 	contador_car 	is 0	.	
    global 	contador_CMD 	is 0	.	//FAZER
    global 	contador_passo 	is 0	.
    global  contador_menu	is 0	.
    global  contador_infoline   is 0.
    global  contador_list       is 0.
    global  contador_list2      is 0.
    
    global  tempo_antes             is 0.//usada na Mostra_Bat
	global 	carga_elet_antes		is 0.0.//usada na Mostra_Bat
	
    //global  slow_loop               is False.//isto bagunça o PID loop?

    global slow_loop_hover          is False.//isto bagunça o PID loop?
    global Mostra_Bat_hover         is False.//isto bagunça o PID loop?
    global display_block_hover      is False.//isto bagunça o PID loop?


    global  rolar_msgs_print_stat   is "limpa_tela_parcial".//"rolagem_dinamica".//"limpa_tela"//"limpa_tela_parcial"
    //contadores para mensagens de repeticoes:
    global contador_verbose_stage_simple    is 0.
    global test_verbose_menu                is 0.

    //opcoes para funcao print_stat:
    global 	tprintcar 	is "car"	.
    global 	tprintCMD 	is "CMD"	.
    //global 	tmsg 		is "msg"	.NAO USADA EM LUGAR NENHUM
    global 	tlog 		is "log"	.
    global 	tlogv 		is "logverbose"	.
    global 	ttimer 		is "timer"		.
    global 	tstatus 	is "status"		.
    global 	ttitle 		is "title"		.
    global 	tpasso 		is "passo"		.
    global  tmenu		is "menu_stat"		.
    global 	tfile 		is "file"			.
    global 	tinfoline	is "infolinestatus"	.
    global 	tlista	    is "listacolunadomeio"	.   //para mostrar informacoes na coluna central: muitos dados do hover, listagem de parts e modules 
    global 	tlista2	    is "listacolunadomeio2"	.
			
	//ORDEM DAS INFOS NO STATUS:
	global ID_POS_STT_AP			is 0.
	global ID_POS_STT_VS			is 1.
	global ID_POS_STT_PE			is 2.
	global ID_POS_STT_MTH			is 3.
	global ID_POS_STT_DIR			is 4.//OSERVAR O VALOR MIN DE LINHAS PARA STATUS >> onde é configurado isso ???
	global ID_POS_STT_inclinacao	is 5.//OSERVAR O VALOR MIN DE LINHAS PARA STATUS
	global ID_POS_STT_STG			is 6.
	global ID_POS_STT_STGS			is 7.
	
}.

FUNCTION INIT_VARS_GET_PARTS {      //FUNCTION TEST_PARTS_GET_MODULES
    //acoes e opcoes em parametros especificos de funcoes:
    global	ACAO_GET_PART_MODULES_INFOS_FREE is "free".
    global	ACAO_GET_PART_MODULES_INFOS_SIZE is "size".
    global  ACAO_GET_PART_MODULES_INFOS_NAME is "name".
    global	ACAO_GET_PART_MODULES_INFOS_ROOT is "root".
    global 	ACAO_GET_PART_MODULES_INFOS_CD_KOS is "cd_kos".
    global  ACAO_GET_PART_MODULES_INFOS_GET_NUM is "get_kos_DRIVE_num_name".//get_name_num_by_path
    //usar em TEST_PARTS_GET_MODULES
        global KOS_RAD is "kOSMachineRad".
        global KOS_KAL is "KAL9000".
        global KOS_KR2 is "KR-2042".
        //ou poderia fazer uma funcao que percorrese as partes em procura de um modulo chamado "kOSProcessor"
}.

FUNCTION INIT_VARS_CONTROL_LOOP_PRINC{
        //CONTROLES DE VOO E LOOP PRINCIPAL DO PROGRAMA:
    global 	sair_programa 				to false		.
    global 	sair_programa_agora 		to false		.
    global 	sair_programa_outro 		to false		.
    global  realizar_reboot             to False        .
	global 	realizar_reboot_RECOVERY	to false		.
	global 	realizar_reboot_fast		to false		.
	global 	TEMPO_reboot_RECOVERY		to 1.0			.
    global 	ready_for_takeoff 			is false		.
    global 	ready_for_HOVER 			is false		.
    global 	ready_for_QUEDA 			is false		.

	global 	STATUS_VOO					is "inicial_script".

    global 	ABORT_SEQUENCIA 			is False		.
	//VARIAVEL INICIAL
	global STAGE_MAX_ATINGIDO			is False		.
	global stage_COUNT                  is 0            .//FAZER RETIRAR ISSO E USAR O DO STAGE SE TIVER
			// stage_COUNT >> vai adicionando conforme o staging =>  launch_pad (stage_COUNT=), liftoff(stage_COUNT=)
			//o do stage: usa o stage atual:
				//testes:
				// nave com 1 motor + clamps
				//stack
				// 1motor
				//stack
				// paraquedas
    //global seekAlt                      is 0            .//ALTURA BUSCAR MODO HOVER
}.

FUNCTION INIT_VARS_SIZE_FILE{
    global ACAO_FILE_SIZE_GET           is "get_size"   .
    global ACAO_FILE_SIZE_TEST          is "test"       .    
}.






