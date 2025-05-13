@LAZYGLOBAL OFF.
//c3_menu.ks
// 2 funcoes: 186 linhas
//recompila

runoncepath("c3_init_vars").
runoncepath("c3_scr_msg").
runoncepath("c3_sup_func").

//CHECK_OPTIONS
//print_stat     > tmenu

//MENU_ultimo_exibido
//MENU_REEXIBIR
//MENU_INICIAL
//MENU_OBJETIVOS
//MENU_AJUDA
//MENU_CONFIG
//h_menu
//CONFIG_DEF_IPU

FUNCTION MOSTRA_MENU_OPCOES{ //OBJETIVO REDUZIR CODIGO
	parameter mn_title.				parameter mn_ttl_indic.
	parameter mn_opc_1_t is "" .	parameter mn_opc_1_v is "" .
	parameter mn_opc_2_t is "" .	parameter mn_opc_2_v is "" .
	parameter mn_opc_3_t is "" .	parameter mn_opc_3_v is "" .
	parameter mn_opc_4_t is "" .	parameter mn_opc_4_v is "" .
	parameter mn_opc_5_t is "" .	parameter mn_opc_5_v is "" .
	parameter mn_opc_6_t is "" .	parameter mn_opc_6_v is "" .
	parameter mn_opc_7_t is "" .	parameter mn_opc_7_v is "" .
	parameter mn_opc_8_t is "" .	parameter mn_opc_8_v is "" .
	parameter mn_opc_9_t is "" .	parameter mn_opc_9_v is "" .
	parameter mn_opc_10_t is "" .	parameter mn_opc_10_v is "" .
	parameter mn_opc_11_t is "" .	parameter mn_opc_11_v is "" .
	parameter mn_opc_12_t is "" .	parameter mn_opc_12_v is "" .
	
	local opcoes_mostradas 	is 0     .
	local MENU_OSPCS 		is list().
	local ultima_linha_men is (h_menu - 1).
	local texto_linha_help is "Dig:ajuda 0:vlt "+CHAR_MENU_OPC_volta_menu_inic+":hom".//ultima_linha_men

	local NOME_DA_FUNC is "MOSTRA_MENU_OPCOES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
	//limpador > O TITULO TBM
	// FROM {local count_men is 0.} UNTIL (count_men = h_menu) STEP {SET count_men to count_men + 1.} DO{
		// print_stat(tmenu, "", count_men).
	// }.
	
	print_stat(tmenu, mn_title + ":" + mn_ttl_indic , 0).

	if (mn_opc_1_t <> "") {MENU_OSPCS:ADD("1." + mn_opc_1_t + " " + mn_opc_1_v).}
	if (mn_opc_2_t <> "") {MENU_OSPCS:ADD("2." + mn_opc_2_t + " " + mn_opc_2_v).}
	if (mn_opc_3_t <> "") {MENU_OSPCS:ADD("3." + mn_opc_3_t + " " + mn_opc_3_v).}
	if (mn_opc_4_t <> "") {MENU_OSPCS:ADD("4." + mn_opc_4_t + " " + mn_opc_4_v).}
	if (mn_opc_5_t <> "") {MENU_OSPCS:ADD("5." + mn_opc_5_t + " " + mn_opc_5_v).}
	if (mn_opc_6_t <> "") {MENU_OSPCS:ADD("6." + mn_opc_6_t + " " + mn_opc_6_v).}
	if (mn_opc_7_t <> "") {MENU_OSPCS:ADD("7." + mn_opc_7_t + " " + mn_opc_7_v).}
	if (mn_opc_8_t <> "") {MENU_OSPCS:ADD("8." + mn_opc_8_t + " " + mn_opc_8_v).}
	if (mn_opc_9_t <> "") {MENU_OSPCS:ADD("9." + mn_opc_9_t + " " + mn_opc_9_v).}
	if (mn_opc_10_t <> "") {MENU_OSPCS:ADD("10." + mn_opc_10_t + " " + mn_opc_10_v).}
	if (mn_opc_11_t <> "") {MENU_OSPCS:ADD("11." + mn_opc_11_t + " " + mn_opc_11_v).}
	if (mn_opc_12_t <> "") {MENU_OSPCS:ADD("12." + mn_opc_12_t + " " + mn_opc_12_v).}
	
	set opcoes_mostradas to (MENU_OSPCS:length + 1). //+1 e o titulo
	
	from {local MENU_OPC_MNUM is 0.}
	until ( (MENU_OPC_MNUM )= ( opcoes_mostradas - 1) )
	step {set MENU_OPC_MNUM to (MENU_OPC_MNUM + 1).}
	do {
		print_stat(tmenu, MENU_OSPCS[MENU_OPC_MNUM], (MENU_OPC_MNUM + 1)).
	}.
	
	print_stat(tmenu, texto_linha_help, ultima_linha_men ).
	
	//limpador de restos: opcoes_mostradas > CONTA COM O TITULO
	FROM {local count_men is opcoes_mostradas.} UNTIL (count_men = ultima_linha_men) STEP {SET count_men to count_men + 1.} DO{
		print_stat(tmenu, "", count_men).
	}.

	return  opcoes_mostradas.
}.


FUNCTION MOSTRA_MENU{
	parameter menu_exibido.// is MENU_INICIAL. //fazer MENU_INICIAL
	parameter menu_refresh is False.

	local NOME_DA_FUNC is "MOSTRA_MENU".
    trace(NOME_DA_FUNC).//que
    set hops to inc(hops).
	
	local ultima_linha_men is (h_menu - 1).//FAZER REMOVER
	
	if (menu_exibido = MENU_REEXIBIR) {set menu_exibido to MENU_INICIAL.}.
	
	//print_stat(tLOGv,"",contador_LOG).
	
	//para impedir que fique atualizando sem precisar
	if ((menu_exibido = MENU_ultimo_exibido) and not(menu_refresh)){return.}
	else {
            set MENU_anterior_a_este_atual  to MENU_ultimo_exibido  .
            set MENU_ultimo_exibido         to menu_exibido         .}.
	
	//contador_menu ja vai vir com o valor do titulo impresso: (ou nao FAZER)
	
	if (menu_exibido = MENU_OBJETIVOS)  {//fazer usar definido
			
		print_stat(tmenu, "OBJETIVOS DE VOO:",                            0).
		print_stat(tmenu, "1 . AP    " + OBJETIVOS_AP_MAX       + "m",    1).
		print_stat(tmenu, "2 . HLAT  " + OBJETIVOS_HEAD_LAT     + "º",    2).
		print_stat(tmenu, "3 . INCL  " + OBJETIVOS_HEAD_INCL    + "º",    3).
		print_stat(tmenu, "4 . INCG  " + OBJETIVOS_INC_GANHO            , 4).
		print_stat(tmenu, "5 . VMAX  " + OBJETIVOS_VE_MAX       + "m/s" , 5).
		print_stat(tmenu, "6 . VMATM " + OBJETIVOS_VE_MAX_ATM   + "m/s" , 6).
		print_stat(tmenu, "7 . PE    " + OBJETIVOS_PE_MIN       + "m"   , 7).
		print_stat(tmenu, "8 . THRM  " + OBJETIVOS_THRTL_MAX    + ""    , 8).
		print_stat(tmenu, "9 . STGM  " + OBJETIVOS_STAG_MAX_ASC + "pas" , 9).
		print_stat(tmenu, "Digite: ajuda."                              , ultima_linha_men ).
		
		check_SHIP().//fazer e se isso nao estiver no menu inicial? como vai avisar auto?
	}
	
	else if (menu_exibido = MENU_AJUDA)      {
		// print_stat(tmenu, "COMANDOS BASICOS:",         0).
		// print_stat(tmenu, "1 . " + NOME_CMD_CONFIG,    1).
		// print_stat(tmenu, "2 . " + NOME_CMD_TELNET,    2).
		// print_stat(tmenu, "3 . " + NOME_CMD_LIFTOFF,   3).
		// print_stat(tmenu, "4 . " + NOME_CMD_ABORT,     4).
		// print_stat(tmenu, "5 . " + DEF_CMD_TRUE,       5).
		// print_stat(tmenu, "6 . " + DEF_CMD_FALSE,      6).
		// print_stat(tmenu, "7 . " + NOME_CMD_SIMPLE_STAGING, 7).
		// print_stat(tmenu, "8 . " + NOME_CMD_OBJETIVOS,      8).
		// print_stat(tmenu, "Digite: ajuda.", ultima_linha_men ).
		
		MOSTRA_MENU_OPCOES( "COMANDOS BASICOS2",     "",
							NOME_CMD_CONFIG,         "",
							NOME_CMD_TELNET,         "",
							NOME_CMD_LIFTOFF,        "",
							NOME_CMD_ABORT,          "",
							DEF_CMD_TRUE,            "for TRUE",
							DEF_CMD_FALSE,           "for FALSE",
							NOME_CMD_SIMPLE_STAGING, "",
							NOME_CMD_OBJETIVOS,      "",
							NOME_CMD_STAGE,          "").
                            
		
	}
	
	else if (menu_exibido = MENU_CONFIG)     {
		// print_stat(tmenu, "COMANDOS CONFIG:",         0).
		// print_stat(tmenu, "1 . " + NOME_CMD_IPU,       1).
		// print_stat(tmenu, "Digite: ajuda.", ultima_linha_men ).
		
		MOSTRA_MENU_OPCOES( "CONFIGURACOES",            ""              ,
							NOME_CMD_IPU,		        CONFIG:IPU      , //CONFIG_DEF_IPU  ,
							NOME_CMD_TELA,              ">"             ,
							NOME_CMD_TELNET,	        CONFIG:TELNET   ,
							NOME_CMD_STOP_TELNET_LOOP,	""      ,
							NOME_CMD_MENU_TELNET,	    ">"
                            ). //ha
		
	}
	else if (menu_exibido = MENU_PRINCIPAL)  {		
		MOSTRA_MENU_OPCOES( "MENU",                 "",
							NOME_CMD_OBJETIVOS,	    ">",
							NOME_CMD_CONFIG,   	    ">",
							NOME_CMD_CONTROLE,      ">",
							NOME_CMD_HELP,   	    ">",
							NOME_CMD_MENU_NAVE,	    ">",
							NOME_CMD_SAIR,   	    "",
							NOME_CMD_MENU_REBOOT,   ">",
							NOME_CMD_BEEP,   	    "",
                            NOME_CMD_SISTEMA,       ">").
		
	}
	else if (menu_exibido = MENU_SISTEMA)     {		
		MOSTRA_MENU_OPCOES( "SISTEMA",              "",
							NOME_CMD_LIST,	        NOME_CMD_LIST_DEF,
							NOME_CMD_SEND_MSG,      "",
							NOME_CMD_SEND_MSG_CORE, "",
	                        NOME_CMD_KSP_INFO,      "blah2",
							NOME_CMD_KOS_INFO,      "BLAH"    ). 
		
	}
	else if (menu_exibido = MENU_REBOOT)     {		
		MOSTRA_MENU_OPCOES( "REBOOT",               "",
							NOME_CMD_REBOOT,	    "",
							NOME_CMD_RECOVERY_BOOT, TEMPO_reboot_RECOVERY+"s",
                            NOME_CMD_FAST_REBOOT,   "",
                            "reboot force",         "",
							"FAZR ATIV COMPILA",      "BLAH").
	}
	else if (menu_exibido = MENU_TELNET)     {		
		MOSTRA_MENU_OPCOES( "TELNET",             "",
							NOME_CMD_TELNET,	CONFIG:TELNET,
							NOME_CMD_TEL_IP,   	CONFIG:IPADDRESS,
							NOME_CMD_TEL_PORT,  CONFIG:TPORT    ). 
		
	}

	else if (menu_exibido = MENU_CONTROLE)   {		//0-3
		MOSTRA_MENU_OPCOES( "CONTROLE",                 "",
							NOME_CMD_STAGE,	            "",
							NOME_CMD_LIFTOFF,	        "",
							NOME_CMD_SIMPLE_STAGING,   	"",
							NOME_CMD_HOVER,             "AT alt:radar",//round((OBJETIVOS_HOVER_ALT),1)
							NOME_CMD_ABORT,   	        "",
							NOME_CMD_KILL,   	        OBJETIVOS_KILL_VSURF,
							NOME_CMD_HUP,   	        "",
							NOME_CMD_HOVER,             "AT..(m)",
                            NOME_CMD_QUEDA,             OBJETIVOS_QUEDA_HOV_ALT
                            ).
	}
	else if (menu_exibido = MENU_TELA)       {
		MOSTRA_MENU_OPCOES( "TELA",                 "",
                            NOME_CMD_COL1_POS,	    pos_col_left,
                            NOME_CMD_ESP_COLS,      espaco_entre_colunas ,
                            NOME_CMD_REDES_TELA,    "",
                            "outra coisa",           "fazer",
                            NOME_CMD_MENU_VEC_CONF, ">",
                            "MENU_TEST_MENS",       "",
                            NOME_CMD_MENU_TEST_TELA,">",
                            NOME_CMD_MENU_SET_TELA, ">",
                            "Help tela",            ""
                            ).
	}
	else if (menu_exibido = MENU_VEC_SHOW)       {
		MOSTRA_MENU_OPCOES( NOME_CMD_MENU_VEC_SHOW, "",
                            "VEC_MOSTRA thst",	    Seta_Que_Mostra_Vetor_THRUST:SHOW,
                            "VEC_MOSTRA vel",       Seta_Que_Mostra_Vetor_Velocidade:SHOW,
                            "VEC_MOSTRA grav",      "",//aqui ja vai dar erro
                            "VEC_MOSTRA PESO",      "",//aqui ja vai dar erro
                            "VEC_MOSTRA AC",        "",//aqui ja vai dar erro
                            "VEC HELP",             "h",//6
                            "Help help",            ""
                            ).
	}
	else if (menu_exibido = MENU_VEC_CONF)       {
		MOSTRA_MENU_OPCOES( NOME_CMD_MENU_VEC_CONF, "",
                            NOME_CMD_MENU_VEC_SHOW,	">",
                            "VEC_MOSTRA ALL",       Seta_Que_Mostra_Vetor_THRUST:SHOW,
                            "VEC_OUTRA CONF",	    "fazer",
                            NOME_CMD_MENU_VEC_TEST, "feito",
                            "VEC_OUTRA CONF",	    "",
                            "VEC HELP",             "",//6
                            "VEC teste1",             "",//7
                            "CLEARVECDRAWS",        ""
                            ).
	}
	else if (menu_exibido = MENU_VEC_TEST)       {
		MOSTRA_MENU_OPCOES( NOME_CMD_MENU_VEC_TEST, "",
                            "vect x,y,z",	        "",
                            "vect rvel target",     "",
                            "vect test help",       "no"
                            ).
	}
	else if (menu_exibido = MENU_SET_TELA)       {
		MOSTRA_MENU_OPCOES( "SET TELA",             "",
                            "DEFINIR ALTURAS",	    "",//1
                            "DEFINIR LARGURAS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "DEFINIR ESPACOS",	    "",
                            "Help SET tela",        ""
                            ).
	}
	else if (menu_exibido = MENU_TEST_MENS)  {
        MOSTRA_MENU_OPCOES( "MENU_TEST_MENS",   "",
                            "TESTA LOG",	    "",
                            "TESTA VLOG",	    "",
                            "TESTA TITULO",     "",
                            "TESTA TIMER",      "",
                            "TESTA PASSO",      "",//5
                            "TESTA MENU",       "",
                            "TESTA STATUS",     "",
                            "TESTA LOG FILE",   "",
                            "TESTA INFO LINE",  "",
                            "TESTA CAR",        "",
                            "TESTA CMD",        "",
                            "TESTA OUTRO",     ""
                            ).
	}
	else if (menu_exibido = MENU_TEST_TELA)  {
        MOSTRA_MENU_OPCOES( "MENU_TEST_TELA", "",
                            "add log",          "",
                            "valores pos tam",  "",
                            "enche log",        "",
                            "valores counts",   ""
                            ).
	}
   
	else if (menu_exibido = MENU_NAVE)       {
		MOSTRA_MENU_OPCOES( "NAVE",                 "",
                            NOME_CMD_PARTS_NAVE,    "",
                            "AG PARTS","",
                            "MOD ACTIONS","",
                            "NAVEGA PARTS","",
							"RESOURCES","",
                            "CHECA_NAVE","",
                            "def STATUS","",
                            "ORBITAL DT"            ,"",
                            "ATM DATA"              ,""
                            ).
		
	}
	else if (menu_exibido = MENU_NAVE_PARTS) {
		MOSTRA_MENU_OPCOES( "PARTS",                 "s=sair",
                            "o=filhos",	"",
                            "m=modules","",
                            "p=pai","",
                            "x=fields","",
                            "y=events","",
                            "z=action","",
                            "[0.9a.kl]=parte muda","",
                            "[0.9a.kl]=modulo muda","",
                            "[0.9a.kl]=funcao escolhe",""
                            ).		
	}
	else if (menu_exibido = MENU_RESOURCES)  {
		MOSTRA_MENU_OPCOES( "RESOURCES",                 "",
                            "ELECTRIC",	"",//NOME_CMD_RES_ELECTRIC_NAVE
                            "FUEL","",
                            "OX","",
                            "ORE","",
							"XEON","",//�LIQUIDFUEL�, �ELECTRICCHARGE�, �MONOPROP�.,SolidFuel
							"MONOPROP","",
							"SolidFuel","",
							"all SHIP","",
							"all STAGE",""
							
                            ).
		
	}
    else if (menu_exibido = MENU_STATUS_NAVE) {
        MOSTRA_MENU_OPCOES(
            "DEF STATUS_VOO"    , "",
            "launchpad"         , "",
            "ascending"         , "",
            "ascencao_meio"     , "",
            "reentrada"         , "",
            "landing"           , "",
            "splash"            , "",
            "landed"            , "",
            "docking"           , ""
        ).
    }
    
	else if (menu_exibido = MENU_CTRL_ROVER) {
		MOSTRA_MENU_OPCOES( "CONTROLE HOVER", ">",
                            "ALTITUDE",	        ">",
                            "HEADING xyz",      ">",
                            "HEADING compass",  ">",
                            "oposto",           "v:MAG<" + OBJETIVOS_KILL_VSURF,
                            "abort","",
                            "break","",
							"VEL LOOP",		    ">",
							NOME_CMD_STAGE,	    "",
							"help",             ""//"FAST PID",		not(slow_loop_hover or Mostra_Bat_hover or display_block_hover)
                            ).		
	}
	else if (menu_exibido = MENU_CTRL_ROVER_ALT) {//fix
		MOSTRA_MENU_OPCOES( "HOVER ALT", "",
                            "ALT-1",    "",
                            "ALT+1",    "",
                            "ALT-10",   "",
                            "ALT+10",   "",
                            "ALT-100",  "",
                            "ALT+100",  "",
                            "VOLTA",    "HOVER"
                            ).		
	}
	else if (menu_exibido = MENU_CTRL_ROVER_HEAD) {
		MOSTRA_MENU_OPCOES( "HOVER HEAD",       "",
                            "H1-1 0   (N) +vY", "",
                            "H1+1 180 (S) -vY", "",
                            "H2-1 90  () -vX",  "",
                            "H2+1 270 () +vX",  "",
                            "H3+1 hor",         "",
                            "H3-1 ahor",        "",
                            "VOLTA",            "HOVER"
                            ).		
	}
	else if (menu_exibido = MENU_CTRL_ROVER_COMP) {
		MOSTRA_MENU_OPCOES( "HOVER COMPASS",        "",
                            "compass -1 hor",       "",
                            "compass +1 ahor",      "",
                            "pitch -1",             "",
                            "pitch +1",             "",
                            "comp -90 hor",         "",
                            "comp +90 ahor",        "",
                            "VOLTA",            "HOVER"
                            ).		
	}
	else if (menu_exibido = MENU_VEL_LOOP_ROVER) {
		MOSTRA_MENU_OPCOES( "VEL_LOOP_ROVER", 	"",
                            "slow_loop",        slow_loop_hover,
                            "Mostra_Bat",		Mostra_Bat_hover,
                            "display_block",	display_block_hover,
                            "FAST LOOP NOW:",   not(slow_loop_hover or Mostra_Bat_hover or display_block_hover),
                            "",                 "",
                            "",                 "",
                            "VOLTA",            "HOVER"
                            ).		
	}
    else {
        set MENU_ultimo_exibido to MENU_REEXIBIR.//vai fazer exibir o menu padrao
    }.
  
    if (1=0){ if NOT( CHECK_OPTIONS(
			menu_exibido,
			NOME_DA_FUNC,
			11,//NUMERO_DE_OPCOES 7 OPCOES
			MENU_OBJETIVOS,
			MENU_AJUDA,
			MENU_CONFIG,
			MENU_TELA,
			MENU_CONTROLE,
			MENU_TELNET,
            MENU_PRINCIPAL,
            MENU_NAVE,
            MENU_NAVE_PARTS,
            MENU_TEST_MENS,
            MENU_TEST_TELA//aiai
			)
		)
		{
			set MENU_ultimo_exibido to MENU_REEXIBIR.//vai fazer exibir o menu padrao
		}.
            // global MENU_INICIAL 		is 0. 
            // global MENU_AJUDA   		is 1. //fazer MENU_INICIAL
            // global MENU_OBJETIVOS		is MENU_INICIAL.
            // global MENU_CONFIG			is 3.
            
            //
            // global OBJETIVOS_AP_MAX 		is 100000	.
            // global OBJETIVOS_PE_MIN 		is 80000	.
            // global OBJETIVOS_VE_MAX_ATM 	is 500		.
            // global OBJETIVOS_VE_MAX 		is 1500		.//Quanto menor o ganho maior pode/deve ser a vel
            // global OBJETIVOS_INC_GANHO 	is 5		.//ORIG 10
            // global CONFIG_DEF_IPU 		is 300		.
            // global OBJETIVOS_STAG_MAX_ASC is 2		. //LIFTOFF e PRIM STAGE
            
            // global OBJETIVOS_THRTL_MAX 	is 1.0.
            // global OBJETIVOS_HEAD_INCL 	is 90.//INICIAL VER FAZER
            // global OBJETIVOS_HEAD_LAT 	is 1.//FIXO //90 ORIG
        }.
    beep("menu").
}.

FUNCTION ONE_CHAR_PARA_MENU{                            //controle do menu ao precionar teclas de 0 a 9 e -  DEVE RETORNAR VERDADEIRO PARA NAO PROCESSAR MORE_CHARS
    parameter CHARACT.
    
	local NOME_DA_FUNC is "ONE_CHAR_PARA_MENU".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    local Encontrou_menu_para_char is False.

    beep("menu").
    
    if     (MENU_ultimo_exibido = MENU_PRINCIPAL){//TA TUDO ERRADO: COLOCAR ELSE IF PARA RETURN CORRETO: ok
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ MOSTRA_MENU(MENU_OBJETIVOS).     }
        else if (CHARACT = 2){ MOSTRA_MENU(MENU_CONFIG).        }
        else if (CHARACT = 3){ MOSTRA_MENU(MENU_CONTROLE).      }
        else if (CHARACT = 4){ MOSTRA_MENU(MENU_AJUDA).         }        
        else if (CHARACT = 5){ MOSTRA_MENU(MENU_NAVE).          }        
        else if (CHARACT = 6){ set sair_programa_agora  to True.}
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_REBOOT).          }//menureboot
        else if (CHARACT = 8){ //BEEP(5,900).                     
            ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_BEEP + " 5 900", "dur(ms) freq(hz)").
        }
        else if (CHARACT = 9){ MOSTRA_MENU(MENU_SISTEMA).       }

        else{ set Encontrou_menu_para_char to False.            }.
    }
    else if(MENU_ultimo_exibido = MENU_OBJETIVOS){

        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_AP_MAX  + " "). }
        else if (CHARACT = 2){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_HLAT    + " "). }
        else if (CHARACT = 3){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_INCL    + " "). }
        else if (CHARACT = 4){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_INCG    + " "). }
        else if (CHARACT = 5){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_VMAX    + " "). }
        else if (CHARACT = 6){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_VMATM   + " "). }
        else if (CHARACT = 7){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_PE      + " "). }
        else if (CHARACT = 8){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_THRM    + " "). }
        else if (CHARACT = 9){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_STGM    + " "). }
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{ set Encontrou_menu_para_char to False. }.
    }    
    else if(MENU_ultimo_exibido = MENU_REBOOT){

        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){  set realizar_reboot          to True.    }//comandos de MENU NÃO tem prioridade sobre o loop principal
        else if (CHARACT = 2){  set realizar_reboot_RECOVERY to True.    }//comandos de MENU NÃO tem prioridade sobre o loop principal
        else if (CHARACT = 3){  set realizar_reboot_fast     to True.    }//comandos de MENU NÃO tem prioridade sobre o loop principal
        else if (CHARACT = 4){  PREPARA_REBOOT(parameter_modo_exec, NOME_CMD_FAST_REBOOT).    }//mesmo do comando (ignora qualquer loop que estiver)
        
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{ set Encontrou_menu_para_char to False. }.
    } 
    else if(MENU_ultimo_exibido = MENU_SISTEMA){

        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ LISTAR_ITENS(NOME_CMD_LIST_DEF).  }
        else if (CHARACT = 2){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_SEND_MSG        + " "). }
        else if (CHARACT = 3){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_SEND_MSG_CORE   + " "). }
        else if (CHARACT = 4){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_KOS_INFO        + " "). }
        else if (CHARACT = 5){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_KOS_INFO        + " "). }
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{ set Encontrou_menu_para_char to False. }.
    } 
    else if(MENU_ultimo_exibido = MENU_CONTROLE){

        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ stage.                       print_stat(tlog, "MANUAL STAGE", contador_log).}//0-3-1
        else if (CHARACT = 2){ set ready_for_takeoff to True.                       }
        else if (CHARACT = 3){ bem_simples_STAGING().                               }
        else if (CHARACT = 4){ set OBJETIVOS_HOVER_ALT to alt:radar. set ready_for_HOVER to True.}
        else if (CHARACT = 5){ set ABORT_SEQUENCIA to True.                         }
        else if (CHARACT = 6){            KILL_VEL_SURF(OBJETIVOS_KILL_VSURF).      }
        else if (CHARACT = 7){            POINT_UP(UP).                      }
        else if (CHARACT = 8){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_get_HOVER  + " ").  }
        else if (CHARACT = 9){ set OBJETIVOS_HOVER_ALT to OBJETIVOS_QUEDA_HOV_ALT. set ready_for_QUEDA to True. }//nao sei mais QUEDA_CONTROLADA(2000).
               
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_CONFIG){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_IPU + " ").     }
        else if (CHARACT = 2){ MOSTRA_MENU(MENU_TELA).                          }
        else if (CHARACT = 3){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_TELNET + " ").  }//prepara comando para usuario preencher e ENTER
        else if (CHARACT = 4){ scr_TERM_STOP_CHILLLLLASDKF().                   }        
        else if (CHARACT = 5){ MOSTRA_MENU(MENU_TELNET).                        }
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_VEC_CONF){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ MOSTRA_MENU(MENU_VEC_SHOW). }
        else if (CHARACT = 2){  TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_THRUST, not(Seta_Que_Mostra_Vetor_THRUST:SHOW), "all" ).
                                MOSTRA_MENU(MENU_VEC_CONF, True).  }
        else if (CHARACT = 3){  PRINT "NO". }
        else if (CHARACT = 4){  MOSTRA_MENU(MENU_VEC_TEST). }
        else if (CHARACT = 6){  MOSTRA_HELP_MENU(MENU_VEC_CONF). }
        else if (CHARACT = 7){  global vorg1 is v(-7,5,0). global escala is 1.0. global largura_vec is 0.1. global multpl_vec is 10.
                                global Seta_Que_Mostra_Vetor_TESTE TO VECDRAW(
                                    vorg1,//(center of the ship is the origin)V(0,0,0) means the ship Center of Mass.
                                    multpl_vec * V(1,0,0),//V(a,b,c),                  //vec to show
                                    RGB(1,1,1),                           //color
                                    "TESTE",                              //label
                                    escala,                               //scale
                                    TRUE,                                 //show
                                    largura_vec,                          //width
                                    True,                                 //pointy
                                    True                                  //wiping
                                ).		//RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA, PURPLE(Alias of MAGENTA), WHITE, BLACK
                                global Seta_Que_Mostra_Vetor_teste_y to vecDraw(vorg1, multpl_vec * v(0,1,0), blue, "teste_y", escala, true, largura_vec).
                                global Seta_Que_Mostra_Vetor_teste_z to vecDraw(vorg1, multpl_vec * v(0,0,1), red, "teste_z", escala, true, largura_vec).
                             }
        else if (CHARACT = 8){ CLEARVECDRAWS(). }
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).}        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_VEC_TEST){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){  //mostra vetor com x,y,z
                                local vorig_test is v(-7,5,0). local escala_test is 1.0. local largura_vec_test is 0.1. local multpl_vec_test is 10.

                                local Seta_Vetor_teste_x to vecDraw(vorig_test, multpl_vec_test * v(0,1,0), blue, "teste_y", escala_test, true, largura_vec_test).
                                local Seta_Vetor_teste_y to vecDraw(vorig_test, multpl_vec_test * v(0,1,0), blue, "teste_y", escala_test, true, largura_vec_test).
                                local Seta_Vetor_teste_z to vecDraw(vorig_test, multpl_vec_test * v(0,0,1), red,  "teste_z", escala_test, true, largura_vec_test).
                             }
        else if (CHARACT = 2){  //teste de diferencas de velocidade entre ship e target
                                    //if not(defined(vec_vel_dif_test)){ global vec_vel_dif_test to v(0,0,0). }
                                    local vorig_test is v(-7,5,0). local escala_test is 1.0. local largura_vec_test is 0.1. local multpl_vec_test is 1.

                                    local vec_vel_dif_test to v(0,0,0).
                                    lock vec_vel_dif_test to {//heeeep
                                        if (hastarget){
                                            return ship:velocity:orbit - target:velocity:orbit.
                                        }
                                        else {return v(0,0,0).}
                                    }.

                                //que erro marotot: nao pode ter * dentro de delegate?
                                //local Seta_Vetor_dif_vel to vecDraw(vorig_test, {return multpl_vec_test * vec_vel_dif_test.}, red,  "velocidade relativa", escala_test, true, largura_vec_test).
                                local Seta_Vetor_dif_vel to vecDraw(vorig_test, {if (hasTarget) {return multpl_vec_test * (ship:velocity:orbit - target:velocity:orbit).} else{ return v(0,0,0).} }, red,  "velocidade relativa", escala_test, true, largura_vec_test).
                            }
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }

    else if(MENU_ultimo_exibido = MENU_VEC_SHOW){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){  TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_THRUST, not(Seta_Que_Mostra_Vetor_THRUST:SHOW) ).
                                MOSTRA_MENU(MENU_VEC_SHOW, True). }
        else if (CHARACT = 2){  TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_Velocidade, not(Seta_Que_Mostra_Vetor_Velocidade:SHOW) ).
                                MOSTRA_MENU(MENU_VEC_SHOW, True). }//ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_VEC_CONF + " ").           
        else if (CHARACT = 3){  if defined(Seta_Que_Mostra_Vetor_GRAVIDADE){ TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_GRAVIDADE, not(Seta_Que_Mostra_Vetor_GRAVIDADE:SHOW) ). }
                                else{ print "vetor nao existe: Seta_Que_Mostra_Vetor_GRAVIDADE". }
                                MOSTRA_MENU(MENU_VEC_SHOW, True). }
        else if (CHARACT = 4){  if defined(Seta_Que_Mostra_Vetor_PESO){ TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_PESO, not(Seta_Que_Mostra_Vetor_PESO:SHOW) ). }
                                else{ print "vetor nao existe: Seta_Que_Mostra_Vetor_PESO". }
                                MOSTRA_MENU(MENU_VEC_SHOW, True). }
        else if (CHARACT = 5){  if defined(Seta_Que_Mostra_Vetor_ACELERACAO){ TEST_VEC_MOSTRA( Seta_Que_Mostra_Vetor_ACELERACAO, not(Seta_Que_Mostra_Vetor_ACELERACAO:SHOW) ). }
                                else{ print "vetor nao existe: Seta_Que_Mostra_Vetor_ACELERACAO". }
                                MOSTRA_MENU(MENU_VEC_SHOW, True). }
        else if (CHARACT = 6){  MOSTRA_HELP_MENU(MENU_VEC_SHOW). }
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).}        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_TELA){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_COL1_POS + " ").            }
        else if (CHARACT = 2){ ATUALIZA_VAR_PROMPT_CMD(NOME_CMD_ESP_COLS + " ").            }
        else if (CHARACT = 3){ REDESENHA_TELA().                                            }
        else if (CHARACT = 4){ print "fazertela4".              }
        else if (CHARACT = 5){  MOSTRA_MENU(MENU_VEC_CONF).     }
        else if (CHARACT = 6){ MOSTRA_MENU(MENU_TEST_MENS).     }
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_TEST_TELA).     }
        else if (CHARACT = 8){ MOSTRA_MENU(MENU_SET_TELA).      }
        else if (CHARACT = 9){ print "descobrir a ordem de calculo para os diferentes numeros das posicoes.".     }//help tela
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).}        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_SET_TELA){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ PRINT "nao sei ainda".            }
        else if (CHARACT = 2){ PRINT "nao sei ainda".}
        else if (CHARACT = 3){ PRINT "nao sei ainda".                                       }
        else if (CHARACT = 4){ PRINT "nao sei ainda". }
        else if (CHARACT = 5){ print "fazer".                   }
        else if (CHARACT = 6){ PRINT "nao sei ainda".     }
        else if (CHARACT = 7){ PRINT "nao sei ainda".     }
        else if (CHARACT = 8){ PRINT "nao sei ainda".      }
        else if (CHARACT = 9){ print "descobrir a ordem de calculo para os diferentes numeros das posicoes.".     }//help tela
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).}        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_NAVE){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ PARTS_DA_NAVE_mina().     }//isso da erro porque?
        else if (CHARACT = 2){ PARTS_DA_NAVE_ACTIONS().  		}
        else if (CHARACT = 3){ PEGAtodosacoesfieldsevents().   	}
        else if (CHARACT = 4){ 
                                MOSTRA_MENU(MENU_NAVE_PARTS).
                                ESCOLHE_FILHOS().   			}
        else if (CHARACT = 5){ //estou colocando agora ver se deu
								//pega resources
                                MOSTRA_MENU(MENU_RESOURCES).	}
        else if (CHARACT = 6){ verificar_nave(true).   	}//verifica todas as naves independente do nome
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_STATUS_NAVE).   }
        else if (CHARACT = 8){ STATUS_NAVE().   }
        else if (CHARACT = 9){ STATUS_QUEDA_ATM( 0, //v_c_sqr
                                                (SHIP:MASS*BODY:MU)/((ship:altitude + body:radius)^2),//peso
            //calculo da distancia que deve percorrer para parar considerando a velocidade atual, os motores disp e a gravidade
            //gravidade (const alt [val minimo]) : usar alt:radar para valor extremo
            ( (ship:VERTICALSPEED^2)*(SHIP:MASS))/(2*(ship:availableThrust-(ship:mass * body:mu /(((ship:altitude - alt:radar) + body:radius)^2)))),
                                                ship:VERTICALSPEED, //velociade
                                                ship:altitude,
                                                alt:radar,
                                                maxThrust,
                                                ship:availablethrust,
                                                SHIP:MASS).
                            }
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }
    else if(MENU_ultimo_exibido = MENU_STATUS_NAVE){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){  ATIVA_REGISTRO_VOO("launchpad", shipName).  }
        else if (CHARACT = 2){  ATIVA_REGISTRO_VOO("ascending", shipName).  }
        else if (CHARACT = 3){  ATIVA_REGISTRO_VOO("ascencao_meio", shipName).  }
        else if (CHARACT = 4){  ATIVA_REGISTRO_VOO("reentrada", shipName).  }
        else if (CHARACT = 5){  ATIVA_REGISTRO_VOO("landing", shipName).  }
        else if (CHARACT = 6){  ATIVA_REGISTRO_VOO("splash", shipName).  }
        else if (CHARACT = 7){  ATIVA_REGISTRO_VOO("landed", shipName).  }
        else if (CHARACT = 8){  ATIVA_REGISTRO_VOO("docking", shipName).  }

        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }
    else if(MENU_ultimo_exibido = MENU_RESOURCES){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ print_stat( tlog ,show_STAGE_INFO("ELECTRICCHARGE", "CAPACITY", False, "SHIP"), contador_log).     }
        else if (CHARACT = 2){ show_STAGE_INFO("LIQUIDFUEL"	, "CAPACITY", True, "SHIP").		}//LiquidFuel
        else if (CHARACT = 3){ show_STAGE_INFO("Oxidizer"	, "CAPACITY", True, "SHIP").		}//Oxidizer
        else if (CHARACT = 4){ show_STAGE_INFO("Ore"		, "CAPACITY", True, "SHIP").		}//Ore
        else if (CHARACT = 5){ show_STAGE_INFO("XenonGas"	, "CAPACITY", True, "SHIP").		}//XenonGas
        else if (CHARACT = 6){ show_STAGE_INFO("MONOPROP"	, "CAPACITY", True, "SHIP").		}//MonoPropellant
        else if (CHARACT = 7){ show_STAGE_INFO("SolidFuel"	, "CAPACITY", True, "SHIP").		}//SolidFuel
        else if (CHARACT = 8){ show_STAGE_INFO("all"		, "all"		, True, "SHIP").		}//all resources
        else if (CHARACT = 9){ show_STAGE_INFO("all"		, "all"		, True, "STAGE").		}//all resources
		
// Oxidizer
// LiquidFuel
// SolidFuel
// MonoPropellant
// XenonGas
// ElectricCharge
// Ore

// IntakeAir
// EVA Propellant
// Ablator
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }
    else if(MENU_ultimo_exibido = MENU_TEST_MENS){
        set Encontrou_menu_para_char to True.
        //print_stat(tLOGv, msg, count_print, reprint, debug, num_verb).
        if      (CHARACT = 1){ //log coluna direita
                                print_stat(tlog,"TESTE DE LOG!:"+contador_log,contador_log). 
                             }
        else if (CHARACT = 2){  //log coluna direita
                                set test_verbose_menu to print_stat(tLOGv, "verbose test",0, False, False, test_verbose_menu). 
                             }
        else if (CHARACT = 3){ //titulo : ID?IA POR A BATERIA AQUI
                                print_stat(ttitle, "novo titulo", 0, False, False, 0). //contador_title+1
                             }
        else if (CHARACT = 4){ //timer
                                PRINT_STAT(tTIMER,"" + contador_timer + "",contador_timer).//contador timer estrapola 
                             }
        else if (CHARACT = 5){ //passo
                                PRINT_STAT(tpasso,"PASSO" + contador_PASSO + "",contador_PASSO).//contador_PASSO nao atualiza
                                set contador_PASSO to inc(contador_PASSO).
                             }
        else if (CHARACT = 6){ //menu
                                print_stat(tmenu, "menu opc 2", (2 + 1)).
                             }
        else if (CHARACT = 7){ //status
                                //PRINT_STAT(tstatus,"GRAV : "+ ROUND(SHIP:SENSORS:GRAV:mag,1) + "m/s2   ", ID_POS_STT_MTH).
                                PRINT_STAT(tstatus,"012345678901234567890-", ID_POS_STT_MTH).
                             }
        else if (CHARACT = 8){ //LOG FILE
                                PRINT_STAT(tfile,"FILE : "+ ROUND(SHIP:SENSORS:GRAV:mag,1) + "m/s2 numero" + contador_file, 0).
                             }
        else if (CHARACT = 9){ //INFO LINE
                                PRINT_STAT(tinfoline,"INFO : "+ ROUND(SHIP:SENSORS:GRAV:mag,1) + "m/s2   ", contador_infoline).
                      			print lista_info_line.
                             }
        else if (CHARACT = 10){ //car
                                PRINT_STAT(tprintcar,"INFO : "+ ROUND(SHIP:SENSORS:GRAV:mag,1) + "m/s2   ", contador_infoline).
                             }
        else if (CHARACT = 11){ //CMD
                                PRINT_STAT(tprintCMD,"INFO : "+ ROUND(SHIP:SENSORS:GRAV:mag,1) + "m/s2   ", contador_infoline).
                             }
        	
   
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }
    else if(MENU_ultimo_exibido = MENU_TEST_TELA){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ print_configs_tela("addlog").            }//novo teste
        else if (CHARACT = 2){ print_configs_tela("all").               }
        else if (CHARACT = 3){ print_configs_tela("filllog").           }
        else if (CHARACT = 4){ print_configs_tela("counts").            }
        	
   
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{ set Encontrou_menu_para_char to False. }.
    }
    else if(MENU_ultimo_exibido = MENU_CTRL_ROVER){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ CONTROL_HOVER_ALT(HOVER_CONTROL_ALTITUDE, Col_Init_CHA, Linha_Init_CHA, "set", 30).
                                MOSTRA_MENU(MENU_CTRL_ROVER_ALT).}//0-3-1
        else if (CHARACT = 2){ CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING, Col_Init_CHA, Linha_Init_CHA, "set", 30, dir_1, dir_2, dir_3).
                                MOSTRA_MENU(MENU_CTRL_ROVER_HEAD).}
        else if (CHARACT = 3){ CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING_by_compass, Col_Init_CHA, Linha_Init_CHA, "set", 30).          
                                MOSTRA_MENU(MENU_CTRL_ROVER_COMP).}
        else if (CHARACT = 4){ CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING_by_oposite, Col_Init_CHA, Linha_Init_CHA, "set").              }        
        else if (CHARACT = 5){ CONTROL_HOVER_ALT("SET_UP", Col_Init_CHA, Linha_Init_CHA).   }//AG  ABORT
        else if (CHARACT = 6){ set ABORT_SEQUENCIA to True.   }//AG BREAKS
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_VEL_LOOP_ROVER).}
        else if (CHARACT = 8){ stage.                       print_stat(tlog, "MANUAL STAGE", contador_log).}
        else if (CHARACT = 9){ MOSTRA_HELP_HOVER(). }
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_CTRL_ROVER_ALT){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec1").}
        else if (CHARACT = 2){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add1").}
        else if (CHARACT = 3){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec2").}
        else if (CHARACT = 4){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add2").}        
        else if (CHARACT = 5){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec3").}
        else if (CHARACT = 6){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add3").}
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_CTRL_ROVER).}
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_CTRL_ROVER_HEAD){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec1").}
        else if (CHARACT = 2){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add1").}
        else if (CHARACT = 3){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec2").}
        else if (CHARACT = 4){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add2").}        
        else if (CHARACT = 5){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec3").}
        else if (CHARACT = 6){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add3").}
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_CTRL_ROVER).}
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_CTRL_ROVER_COMP){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec1").}
        else if (CHARACT = 2){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add1").}
        else if (CHARACT = 3){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec2").}
        else if (CHARACT = 4){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add2").}        
        else if (CHARACT = 5){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "dec3").}
        else if (CHARACT = 6){ CONTROL_HOVER_ALT(hover_control, Col_Init_CHA, Linha_Init_CHA, "add3").}
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_CTRL_ROVER).}
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_VEL_LOOP_ROVER){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ set slow_loop_hover to not(slow_loop_hover). MOSTRA_MENU(MENU_VEL_LOOP_ROVER, True).}
        else if (CHARACT = 2){ set Mostra_Bat_hover to not(Mostra_Bat_hover). MOSTRA_MENU(MENU_VEL_LOOP_ROVER, True).}
        else if (CHARACT = 3){ set display_block_hover to not(display_block_hover). MOSTRA_MENU(MENU_VEL_LOOP_ROVER, True).}
        else if (CHARACT = 4){ set slow_loop_hover to false.
								set Mostra_Bat_hover to false.
								set display_block_hover to false.		
								MOSTRA_MENU(MENU_CTRL_ROVER).}
        else if (CHARACT = 7){ MOSTRA_MENU(MENU_CTRL_ROVER).}
        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_CTRL_ROVER).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    else if(MENU_ultimo_exibido = MENU_TELNET){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){ 	print "nada a fazer: " + NOME_CMD_TELNET + ": [" + CONFIG:TELNET + "]".
								PRINT_STAT(tinfoline,": "+ NOME_CMD_TELNET + ": [" + CONFIG:TELNET + "]", contador_infoline).}
        else if (CHARACT = 2){ 	print "nada a fazer: " + NOME_CMD_TEL_IP + ": [" + CONFIG:IPADDRESS + "]".
								PRINT_STAT(tinfoline,": "+ NOME_CMD_TEL_IP + ": [" + CONFIG:IPADDRESS + "]", contador_infoline).}
        else if (CHARACT = 3){ 	print "nada a fazer: " + NOME_CMD_TEL_PORT + ": [" + CONFIG:TPORT + "]".
								PRINT_STAT(tinfoline,": "+ NOME_CMD_TEL_PORT + ": [" + CONFIG:TPORT + "]", contador_infoline).}

        else if (CHARACT = 0){
            MOSTRA_MENU(MENU_anterior_a_este_atual).
        }        
        else{
            set Encontrou_menu_para_char to False.            
        }.
    }
    
    else if(MENU_ultimo_exibido = MENU_AJUDA){
        set Encontrou_menu_para_char to True.
        if      (CHARACT = 1){      }
        else if (CHARACT = 2){      }
        
        else if (CHARACT = 0){ MOSTRA_MENU(MENU_anterior_a_este_atual).         }        
        else{
            set Encontrou_menu_para_char to False.            
        }.

    }.
    
    return Encontrou_menu_para_char.
}.
	
	
FUNCTION MOSTRA_HELP_MENU{
    parameter MENU_QUE_ESTA_SENDO_HELPADO.

    if (MENU_QUE_ESTA_SENDO_HELPADO = MENU_VEC_SHOW){
        print "fazer5".        
                
        PRINT "vetor do thrust ".
        print " THRUST = ((ship:MAXTHRUST * THROTTLE)/Div_Factor_kN) * ship:facing:vector".

        print "vetor da velocidade".
        print "VELOCITY = ship:velocity:surface".

        print "vetor da aceleracao".
        print "ACCEL = SHIP:SENSORS:ACC".

        print "vetor peso".
        print "PESO = (SHIP:SENSORS:GRAV * SHIP:MASS) / Div_Factor_kN".

        print "vetor gravidade".
        print "SHIP:SENSORS:GRAV".
    }        
}.
	
	
	
	
	
	
	
	