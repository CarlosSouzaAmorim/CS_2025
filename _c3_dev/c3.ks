@LAZYGLOBAL OFF.//reativar
//hellolaunch v1.01
// 1 funcoes: 202 linhas
//recompila

//chame o programa com : run c3.  no terminal quando no Arqchive ou run "0:/c3".
// quando no disco atual
// FAZER QUANDO NAO ESTIVER NO DISCO 0 verificar qual disco esta sendo chamado e aterar para este
//		senao ele vai assumir sempre o 1
//
//fazer setar IPU no comeco para valor alto e apos a compilação reduzir para 100 (note-pos)
//apos terminar os testes e desenho das bordas voltar ao valor alto/normal (200) 
//compula

parameter 	modo_de_execucao	is "run_normal".	//"copiador".
global 		parameter_modo_exec to modo_de_execucao.   
global 		hops                is 0.				//Usada para exibir velocidade de processamento atual//Mostra_Bat reseta hops

//parameter 	CPU_DRIVE			is 1.//o segundo parametro era para especificar o local que devia rodar/copiar para

runoncepath("c3_init_vars").
runoncepath("c3_cmd").
runoncepath("c3_files").
runoncepath("c3_menu").
runoncepath("c3_para_testes").
runoncepath("c3_pid_node").
runoncepath("c3_scr_msg").
runoncepath("c3_scr_tela").
runoncepath("c3_ship"). //nao esta chamando> lembrar dos () depois das funcoes fora do arquivo!
runoncepath("c3_ship_cfg").
runoncepath("c3_song").
runoncepath("c3_sup_func").
runoncepath("c3_term").
runoncepath("c3_utils").

//global 	VERSAO_PROG			is "0.98".//19/04/2018
//global 	VERSAO_PROG			is "1.00".//xx/xx/2018
//global 	VERSAO_PROG			is "1.01".//30/08/2019
//global	VERSAO_PROG			is "1.02".//30/08/2019 16:14
//global 		VERSAO_PROG		is "1.04".//01/09/2019 20:09
//global 		VERSAO_PROG			is "1.05".//05/09/2019 05:11
//global 		VERSAO_PROG			is "1.06".//22/04/2020 14:43 KOS: kOS-v1.1.9.0 KSP1.7.3
//24/04/2020 22:26 KOS: kOS-v1.1.9.0 KSP1.7.3
//global 	VERSAO_PROG			is "1.07".//05/11/2020 11:20 KOS: kOS-v1.2.1.0 KSP1.9.1.2788 w7
//global 	VERSAO_PROG			is "1.07".//ver criada em 06/11/2020 11:39 KOS: kOS-v1.2.1.0 KSP1.10.1.2939 XUB
//global 	VERSAO_PROG			is "1.08".//06/11/2020 11:41 KOS: kOS-v1.2.1.0 KSP1.10.1.2939 XUB
// 													alteração da QUEDA: até velocidade min então HOVER
//										6dez		alteração cp.ks switch to drive_destino no not(MODO_COMPILE)
//										6dez		alteração STATUS_HOVER_1 para fast_stat loop e 10 linhas info
//										7dez		alteração STATUS_QUEDA_ATM para fast_stat loop e 7 linhas info
//													modificado autorun para menu v1.8a
//													modificado cp para parametros de pausa, debug wait
//													modificado cp3_test.bat para usar variável de tempo no choice
//global 	VERSAO_PROG			is "1.09".//11/12/2020 23:48 KOS: kOS-v1.2.1.0 KSP1.10.1.2939 XUB
					//								comunicacao com hovers que se separam e ficam com altitude constante
					//								autorun auto para outros cores cpu1,cpu2, cpu3
//													ahhhhhh
global 		VERSAO_PROG			is "1.09".

//para alterar a versão crie um backup: cmd cp3_MK_VER.bat v1.02

local 		MEU_PROG 			is "c3.ks".		//defina aqui o nome do arquivo.
global 		MODO_EXEC_NORMAL	is "run_normal".
global 		MODO_EXEC_COPIA 	is "copiador".
local NOME_DA_FUNC_main is "MEU_PROG " + MEU_PROG + " v" + VERSAO_PROG.
INIT_VARS_DEBUG().
debug(NOME_DA_FUNC_main, "tempo real PC: " + KUniverse:REALTIME + " --- "+ ship:NAME +" -------------- IPU "+ CONFIG:IPU+" ------------------------------------_______________.", False).
debug(NOME_DA_FUNC_main, "Iniciado variaveis de debug.", False).//tem que ser depois do vars_debug init

//VARIAVEIS DE DEBUG:
        trace(NOME_DA_FUNC_main).//tem que ser depois do vars_debug init

debug(NOME_DA_FUNC_main, "Iniciando variaveis gerais do c3...", False).
INICIALIZA_VARS_MAIN_PROG(VERSAO_PROG).//eu preciso disso para TODAS as funcoes.
	
debug(NOME_DA_FUNC_main, "Parametros enviados: ["+modo_de_execucao+"]", False).
debug(NOME_DA_FUNC_main, "Testando por modos de execucao: MODO_EXEC_NORMAL["+MODO_EXEC_NORMAL+"] MODO_EXEC_COPIA["+MODO_EXEC_COPIA+"]", False).
if (modo_de_execucao = MODO_EXEC_COPIA){//.
	debug(NOME_DA_FUNC_main, "Verifique esta funcao.", False).

	RECOPIA(MEU_PROG).	//, CPU_DRIVE).
						//fazer usar def cpu drive pois eh possivel detectar o drive em uso pela cpu na funcao
	//return. NAO PODE
	//break. NAO PODE
	}
else {//( modo_de_execucao = MODO_EXEC_NORMAL)
		debug(NOME_DA_FUNC_main, "Iniciando funcao de loop principal: ["+MEU_PROG+"]  ["+modo_de_execucao+"] hops[" +hops+"]", False).
		LOOP_PROG_PRINCIPAL(MEU_PROG, modo_de_execucao).//,True,True).
	}.

DEBUG(NOME_DA_FUNC_main,"ESCOPO principal finalizado: FIM do programa MESMO!...",False).
///AQUI O PROGRAMA TERMINA
		
// === FUNCAO LOOP PRINCIPAL DO PROGRAMA ============================================================================================
function LOOP_PROG_PRINCIPAL{
	//LOOP_PROG_PRINCIPAL(MEU_PROG, modo_de_execucao).
	parameter nome_do_programa.
	parameter modo_de_exec_do_prog.
	parameter debug_tela            is False.
	parameter Pdebug_prog           is False.
	
	local NOME_DA_FUNC is "LOOP_PROG_PRINCIPAL".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	debug(NOME_DA_FUNC, "Loop principal iniciado: ["+nome_do_programa+"]  modo["+modo_de_exec_do_prog+"]"
								+" debug tela["+debug_tela+"]  debug prog["+Pdebug_prog+"]", Pdebug_prog).

    CARREGA_CONFIGS(modo_de_exec_do_prog, Pdebug_prog).
    
	DESENHA_TELA().
	
	if (Pdebug_prog){	//MANEIRA DE CHAMAR ATENCAO QUANDO O PROGRAMA INICIAR.
		//set TERMINAL:VISIBLE to true.//fazer retirar isso eh soh pra teste debug
		//set TERMINAL:VISIBLE to True.
		//core:DOACTION("open terminal",True).
		//STAGE.
        DEBUG(NOME_DA_FUNC,"ativando AG[" + modo_de_exec_do_prog + "]",Pdebug_prog).
        
		if (modo_de_exec_do_prog = "1"){ag1 on.}.
		if (modo_de_exec_do_prog = "2"){ag2 on.}.
		if (modo_de_exec_do_prog = "3"){ag3 on.}.
		if (modo_de_exec_do_prog = "4"){ag4 on.}.
		if (modo_de_exec_do_prog = "5"){ag5 on.}.
		if (modo_de_exec_do_prog = "6"){ag6 on.}.
		if (modo_de_exec_do_prog = "7"){ag7 on.}.
		if (modo_de_exec_do_prog = "8"){ag8 on.}.
		if (modo_de_exec_do_prog = "9"){ag9 on.}.
		if (modo_de_exec_do_prog = "0"){ag10 on.}.
		//if (debug_prog_AVISA_INICIO_SOM) {TOQUE_7_NATION_INTRO().}.//
		if (debug_prog_AVISA_INICIO_SOM) {TOCA_INTRO(SOM_INTRO_PROGRAMA).}.
		
		//MAPVIEW.
	}.

	// -- Leitura do teclado ------------------------------------------------------------------------------------------------------------
    DEBUG(NOME_DA_FUNC,"Iniciando trigger da leitura do teclado...",Pdebug_prog).
    WHEN (terminal:input:haschar)
    THEN { // GETCHAR 	String 	Get 	(Blocking) I/O to read the next character of terminal input.
        PROCESS_KEYBOARD(terminal:input:getchar()).
        PRESERVE. }.
    // -- rotina de redimensionamento da tela -------------------------------------------------------------------------------------------
    DEBUG(NOME_DA_FUNC,"Iniciando trigger da deteccao de redimencionamento...",Pdebug_prog).
    WHEN ( (terminal:height <> terminal_height_configurado) or (terminal:width <> terminal_width_configurado) )
    THEN {
            //armazenar as mensagens para posterior rolagem
            //FAZER TRANSFERIR PARA O LLOP PRINC[OK]
            if not(ESTAVA_CONECTADO_AO_TELNET_ANTES)//vai executar somente se o telnet nao estava ativo antes
            {
                if (CONFIG:TELNET and (not(CONFIG_DEF_RESPECT_TELNET)) )
                {	set TERMINAL:HEIGHT to terminal_height_configurado.
                    set TERMINAL:width to terminal_width_configurado.	 }
                else {  }.
            }.
            if (terminal:height <> terminal_height_configurado) or (terminal:width <> terminal_width_configurado)
            {
				//if ( CONFIG:TELNET ){ resize(terminal)}.//se mudar o terminal no kerbal (resize) vai mudar no telnet?
				//SET CONFIG:TELNET TO TRUE.
				// preciso saber quando o telnet conecta com um cliente pois ele redimensiona para a pequena janela do cliente sempre
				//terminal resized
				//set CONFIG:IPU to CONFIG_DEF_IPU. //usar se nao for fast_draw_IPU
				REDESENHA_TELA(debug_tela, True, 2000, CONFIG_DEF_IPU).//(DEBUG,FAST,IPUDRAW,IPUBACK)
			}.
            PRESERVE.
        }.
    // -- FIM rotina de redimensionamento da tela ---------------------------------------------------------------------------------------

    //RETIREI DO PONTO TESTE 1
	//para quando nao tiver solucao auto e for necessario redimensionar manual(na tela com mouse)
	//USAR PARA QUANDO OS VALORES MINIMOS FOREM INSUFICIENTES:
	//fazer USAR ISSO QUANDO TENTOU TIRAR TODAS AS BOBAGENS???
    DEBUG(NOME_DA_FUNC,"Iniciando trigger da deteccao de redimencionamento [tamanho minimo configurado] FAZER REMOVER ISSO...",Pdebug_prog).
	WHEN ((terminal_width_configurado_minimo > terminal:width) or (terminal_height_configurado_minimo > terminal:height))
	THEN {
		if (terminal_width_configurado_minimo > terminal:width){
			PRINT_BIG_ERROR_CLS_TIMED("largura insuficiente: [" + terminal:width + "] min[" + terminal_width_configurado_minimo + "").
			}.
		if (terminal_height_configurado_minimo > terminal:height){
			PRINT_BIG_ERROR_CLS_TIMED("altura insuficiente [" + terminal:height + "] min[" + terminal_height_configurado_minimo + "").
			}.
		PRESERVE.
		}.   
    
    DEBUG(NOME_DA_FUNC,"Iniciando o desenho dos vetores: tem trigger la tb...",Pdebug_prog).
    TEST_DESENHA_VETORES(ship:velocity:surface).//chamar uma vez soh
    //TEST_CHECK_SENSORES("BLAH", True).imprime os valores dos sensores presentes
	

	//fazer carregar isso:
	set STATUS_VOO to "launchpad".
    DEBUG(NOME_DA_FUNC,"Definindo status de voo para: ["+STATUS_VOO+"]",Pdebug_prog).
	LER_ARQUIVO_STATUS_NAVE(shipName).
	LER_ARQUIVO_CONFIG_NAVE(shipName).
	ATIVA_REGISTRO_cfg_fly("fly", "0:/"+ship:name+".cfg.fly").//somente um sinalizador para que pode iniciar os outros modulos na mesma nave
    verificar_nave().

	//PRINT "NAVE ATUAL (COLOCAR NO STATUS BAR) :" + SHIP:NAME.
	//PRINT "CPU ATUAL (COLOCAR NO STATUS BAR) :" + CORE:TAG.
	//PRINT "NAVE DA NAVE DO CORE(COLOCAR NO STATUS BAR) :" + CORE:VESSEL:NAME.

    DEBUG(NOME_DA_FUNC,"Iniciando o LOOP do programa... hops[" +hops+"]",Pdebug_prog).
	
	until (sair_programa){

		if (STATUS_VOO = "launchpad"){
			//
		}
		if (STATUS_VOO = "ascending"){
			print_stat(tlog,"RECUPERANDO: ascencao",contador_log).
			
			CONTROLE_NAVE(STATUS_VOO).
		}
		if (STATUS_VOO = "ascencao_meio"){
			print_stat(tlog,"RECUPERANDO: ascencao",contador_log).
			
			CONTROLE_NAVE(STATUS_VOO).
		}
		
		if (STATUS_VOO = "reentrada"){
			//
		}
		if (STATUS_VOO = "landing"){
			//
		}
		if (STATUS_VOO = "splash"){
			//
		}
		if (STATUS_VOO = "landed"){
			//
		}
		if (STATUS_VOO = "docking"){
			//
		}

		
		if (ready_for_takeoff){ //controle nave
			STATUS_NAVE().		//MOSTRA ANTES DO COUNTDOWN
			MOSTRA_OBJETIVOS().
            set ABORT_SEQUENCIA to False.
			if ( (SHIP:VELOCITY:SURFACE:MAG) < 1 ) {
				ATIVA_REGISTRO_VOO("iniciado countdown", shipName).
				COUNTDOWN_T(3).	//se a nave ja estiver voando não fazer
				print_stat(tlog,"LIFTOFF",contador_log).
			}.
			CONTROLE_NAVE(STATUS_VOO).	//pode ser chamado durante o voo
			STATUS_NAVE().		//nao adianta aqui pois fica preso no CONTROLE_NAVE.
			set ready_for_takeoff to False.
			ATIVA_REGISTRO_VOO("ESTADO_APOS_lancamento", shipName).
		}.
		if (ready_for_HOVER){
			ATIVA_REGISTRO_VOO("hover", shipName).
            set ABORT_SEQUENCIA to False.
            HOVER_1(OBJETIVOS_HOVER_ALT).
			set ready_for_HOVER to False.
			ATIVA_REGISTRO_VOO("ESTADO_APOS_HOVER", shipName).
		}.
		if (ready_for_QUEDA){
			ATIVA_REGISTRO_VOO("iniciado controle queda", shipName).
            set ABORT_SEQUENCIA to False.
            QUEDA_CONTROLADA(OBJETIVOS_HOVER_ALT).
			set ready_for_QUEDA to False.
			ATIVA_REGISTRO_VOO("ESTADO_APOS_queda_ctrl", shipName).

		}.
        
		//preciso do ENTER PARA ENTRAR COMANDOS PARA SAIR
		if (sair_programa_agora){
			debug(NOME_DA_FUNC, "VAI SAIR DA FUNCAO PRINCIPAL COM RETURN E FINALIZAR O PROGRAMA", Pdebug_prog).
			RETURN.//VAI SAIR DA FUNCAO PRINCIPAL E FINALIZAR O PROGRAMA
		}.
		if (sair_programa_outro){
			BREAK.//TESTAR : ACHO QUE SAI DO loop mas fica na funcao, que normalmente vai concluir
		}.
        if (realizar_reboot){
            PREPARA_REBOOT(modo_de_exec_do_prog).
        }.
        if (realizar_reboot_RECOVERY){
            PREPARA_REBOOT(modo_de_exec_do_prog, NOME_CMD_RECOVERY_BOOT).
        }.
		if (realizar_reboot_fast){
            PREPARA_REBOOT(modo_de_exec_do_prog, NOME_CMD_FAST_REBOOT).
		}.

        Mostra_Bat(TIME:SECONDS).
        
        //SHOW_CORE_MESSAGE_QUEUE(5,30,CORE:MESSAGES).//ver hhhhh eita poha NAO SERA ATUALIZADO DURANTE OS LOOPS DO PROGRAMA
        SHOW_CORE_MESSAGE_QUEUE().
        SHOW_VESSEL_MESSAGE_QUEUE().
        wait 0.001.//este wait é importante para esperar o physics tick
	}.//FIM LOOP PRINCIPAL DO PROGRAMA
    DEBUG(NOME_DA_FUNC,"LOOP principal finalizado: FIM do programa...",Pdebug_prog).

    //print isto sera executado se voce sair do loop com BREAK
    //print INSTO NAO SERA EXECUTADO SE VOCE SAIR COM RETURN
}.//FIM FUNCAO LOOP PRINCIPAL DO PROGRAMA
// FIM FUNCAO LOOP PRINCIPAL DO PROGRAMA ============================================================================================


FUNCTION Mostra_Bat{            //rotina mostra status bateria, DELAY DO SCRIPT
    //parameter Col_Mostra_Bat.   parameter Lin_Mostra_Bat.
    parameter tempo is 0.0.

	local NOME_DA_FUNC is "MOSTRA_BAT".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	
    local d_hops 				to 0.
	local taxa_consumo_bat 		to 0.
	local tempo_bat_restante	to 0.
	local linha_EC				to "EC:" + round(SHIP:ELECTRICCHARGE,2).
	set linha_EC to completa_de_espacos(12, linha_EC).
	local linha_STATUS 			to "".
	local linha_bat 			to " " + linha_EC + " ".
	local banda_morta_consumo_bat to 0.001.
	local banda_morta_dt_bat	to 0.01.//APLICAR
	local consumo_bat			to 0.0.
	local carga_atual			to 0.0.
	local capacidade_max_bat	to 0.0.
    
	set carga_atual to (SHIP:ELECTRICCHARGE * 1.0).
	set capacidade_max_bat to (show_STAGE_INFO("ELECTRICCHARGE", "CAPACITY", False, "SHIP")) * 1.0.

    if (tempo > 0) and (tempo_antes > 0){
        local dt_bat to tempo - tempo_antes.

		local linha_dt to " dt " + completa_de_espacos(4, round((dt_bat),2):TOSTRING) + "s ".
		//set linha_dt to completa_de_espacos(9, linha_dt).
        print linha_dt at( Col_Mostra_Bat - 15, Lin_Mostra_Bat).
		//ei recompila : FAZER: PREENCHER OS ESPACOS!!! e limitar o tamanho

		local linha_hops to "".
		if (dt_bat > banda_morta_dt_bat) {
			//UM dt_bat MUITO PEQUENO VAI DAR INFINITO!!!
			set d_hops to hops / dt_bat.
			if (d_hops > 0) {
				set linha_hops to " hops " + completa_de_espacos(4, round((d_hops),0):tostring) + "/s ".
			}.
			
			set hops to 0.
		}
		else{
    		set linha_hops to " hops high!!!".
		}.
		//set linha_hops to completa_de_espacos(11, linha_hops).//hops
		print linha_hops at( Col_Mostra_Bat - 35, Lin_Mostra_Bat).

		//verfifica se esta descarregando:

		if (carga_elet_antes > 0) and (carga_atual > 0){
			
			set consumo_bat to carga_atual - carga_elet_antes.
			//FAZER: PREENCHER OS ESPACOS E REMOVER STRING COMPRIDA!!!
		
				set taxa_consumo_bat to consumo_bat/dt_bat.
				//print taxa_consumo_bat.

				local linha_consumoB to "B("+ round((taxa_consumo_bat),2) +")".

				if (consumo_bat > 0) {
					set linha_STATUS to "CARR".
				}
				else if (consumo_bat < 0) {
					set linha_STATUS to "DESC".
				}
				else{
					set linha_STATUS to "EQUL".
				}.

			//banda_morta_consumo_bat
			if (abs(consumo_bat) > banda_morta_consumo_bat) {
				if (consumo_bat > 0) {
					//calcula o tempo para carga total: ler o max de baterias.
					//se está carregando:
					set tempo_bat_restante to ( capacidade_max_bat - carga_atual) / taxa_consumo_bat.
				}
				else if (consumo_bat < 0) {
					//calcula o tempo para DESCARGA total:
					//se está descarregando:
					set tempo_bat_restante to ( carga_atual) / taxa_consumo_bat.
				}
				else{//ATENÇÃO: nessa situação isso nunca vai ocorrer!!!
				}.
			}
			else{
				//esta sem ser utilizado (só pode) > ou o consumo e a carga estao equilibrados!
				set linha_consumoB to "B(zero)".
				set tempo_bat_restante to -1.
			}.
			set linha_consumoB to completa_de_espacos(12, linha_consumoB).
			set linha_bat to linha_bat + linha_consumoB + " " .

			if (tempo_bat_restante <> -1) {set tempo_bat_restante to abs(tempo_bat_restante).}
			local linha_restT to "".

			if (tempo_bat_restante > 60){//transforma para minutos
				set linha_restT to "T("+ round((tempo_bat_restante/60),0) +")m".
			}
			else if (tempo_bat_restante > 3600){//transforma para horas
				set linha_restT to "T("+ round((tempo_bat_restante/3600),0) +")h".
			}
			else if (tempo_bat_restante > (3600*24)){//transforma para dias
				set linha_restT to "T("+ round((tempo_bat_restante/(3600*24)),0) +")D".
			}
			else if (tempo_bat_restante > (3600*24*30)){//transforma para meses
				set linha_restT to "T("+ round((tempo_bat_restante/(3600*24*30)),0) +")M".
			}
			else if (tempo_bat_restante > (3600*24*365)){//transforma para anos
				set linha_restT to "T("+ round((tempo_bat_restante/(3600*24*365)),0) +")A".
			}
			else{
				set linha_restT to "T("+ round((tempo_bat_restante),0) +")s".
			}
			set linha_restT to completa_de_espacos(12, linha_restT).
			set linha_bat to linha_bat + linha_restT + " ".

			set linha_STATUS to completa_de_espacos(4, linha_STATUS).
			set linha_bat to linha_bat + linha_STATUS + " ".

		}.
    }.
    set tempo_antes to tempo.
    set carga_elet_antes to carga_atual.
	
    //print "  EC:" + round(SHIP:ELECTRICCHARGE,2) + "  " at( Col_Mostra_Bat, Lin_Mostra_Bat).
	//debug_wait(0.5).
    print linha_bat at( Col_Mostra_Bat, Lin_Mostra_Bat).
    if (SHIP:ELECTRICCHARGE < 0.1){
        PRINT_BIG_ERROR_CLS("SEM BATERIA").
    }.        
    // TimeSpan:SECONDS
    //Access:	Get only
    //Type:	Scalar (float)
}.


FUNCTION REDESENHA_TELA{
    parameter debug_redestela 			is false.
    parameter fast_redestela 			is false.
	parameter fast_draw_redesenha_IPU 	is CONFIG_DEF_IPU.
	parameter fast_draw_BACK_IPU 		is CONFIG_DEF_IPU.
    
	local NOME_DA_FUNC is "REDESENHA_TELA".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	if (fast_redestela){
		//Config:IPU   //Access:	Get/Set 	//Type:	scalar integer. range = [50,2000]
		set CONFIG:ipu to fast_draw_redesenha_IPU.
	}

	//limpa a tela e desenha bordas
	DEBUG(NOME_DA_FUNC,"Limpa a tela e desenha bordas.",debug_redestela).
	DESENHA_TELA(True).// (redesenha=true)
	
	//fazer recupera valores anteriores
	DEBUG(NOME_DA_FUNC,"Recuperando valores apos redesenho de tela.",debug_redestela).
	RECUPERA_VALORES_TELA(lista_msg, lista_TIMER, lista_log, lista_status, lista_title, linha_digitada_no_prompt,lista_list).							
							
	if (fast_redestela){
		set CONFIG:ipu to fast_draw_BACK_IPU.
	}
}.
	
FUNCTION PREPARA_REBOOT{    // REBOOT> armazena dados, salva variaveis
    parameter modo_de_exec_do_reboot.
	parameter TIPO_DE_RECOVERY is NOME_CMD_REBOOT.//MENU_CMD_REBOOT_RECOVERY

    set hops to inc(hops).
			if (TIPO_DE_RECOVERY = NOME_CMD_RECOVERY_BOOT){//vai ignorar as configs previas do sistema (telnet, terminal, etc)
				print "C3: Iniciando um novo 0:/boot/c3_autorun2.ks".
           		runpath("0:/boot/c3_autorun2.ks",
				   			"nova_versao",
							core:bootfilename,
							"0:/boot/c3_autorun2.ks",
							"0:/boot/c3_autorun2.ksm",
							"1:/boot",
							TEMPO_reboot_RECOVERY).
	            //reboot. ISTO NAO PRECISA REBOOT POIS O NOVO AUTORUN VAI RENTRAR DEPOIS DO VELHO AUTORUN RESETAR
			}

            //set modo_de_exec_do_reboot to "bu".//opcao para autorum executar no modo prompt novamente
            if (modo_de_exec_do_reboot = "telnet_and_close"){
                log "vai reboot" to "1:/reboot_n.cfg".
            }
            else if (modo_de_exec_do_reboot = "telnet_and_keep"){
                log "vai reboot" to "1:/reboot_e.cfg".
            }
            else if (modo_de_exec_do_reboot = "run_normal"){
                //log "vai reboot" to "1:/reboot_t.cfg".
            }
            else{
                //log "vai reboot" to "1:/reboot.cfg".
            }.
			if (TIPO_DE_RECOVERY = NOME_CMD_FAST_REBOOT){
				PRINT "fast reboot!".
	            reboot.
			}

			if (TIPO_DE_RECOVERY = NOME_CMD_REBOOT){//AHHH
				if (TEMPO_reboot_RECOVERY > 0.9){
	                log "reboot_wait "+TEMPO_reboot_RECOVERY to "1:/reboot_wait.cfg".
					wait 0.
				}
	            reboot.
			}
}.

FUNCTION CARREGA_CONFIGS{
    
    parameter MODO_DE_EXECUCAO_C3.
    parameter P_debug_config is False.
    //c3_term.ks
	local NOME_DA_FUNC is "CARREGA_CONFS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	debug(NOME_DA_FUNC, "Verifique esta funcao.", P_debug_config).

	//TESTE_TELA ().
	set CONFIG_DEF_RESPECT_TELNET 			to False. //quando o telnet estiver ativo os redimensionamentos nao geram auto ajuste
													  //pelo contrario o sistema forca ficar na ultima configuracao valida
	set ESTAVA_CONECTADO_AO_TELNET_ANTES 	to CONFIG:TELNET.//FAZER uma maneira de saber se estava conecado
    
	debug(NOME_DA_FUNC, "testa estado do telnet informado: FAZER.", P_debug_config).
    if ((MODO_DE_EXECUCAO_C3) = "telnet_and_close"){
        //PODE EXTENDER O TERMINAL PARA OBEDECER OS LIMITES DE TELA
        debug(NOME_DA_FUNC, MODO_DE_EXECUCAO_C3).
    }.
    if ((MODO_DE_EXECUCAO_C3) = "telnet_and_keep"){
        //EXTENDER O TERMINAL MAS OBEDECER OS tamanho DE TELA NO JOGO
        debug(NOME_DA_FUNC, MODO_DE_EXECUCAO_C3).
        //
    }.
	
	set CONFIG:DEFAULTFONTSIZE to 8.
	debug(NOME_DA_FUNC, "CONFIG:DEFAULTFONTSIZE: ["+CONFIG:DEFAULTFONTSIZE+"]", P_debug_config).

    DEBUG(NOME_DA_FUNC,"orig CONFIG:IPU is [" + CONFIG:IPU + "]",P_debug_config).        
	set CONFIG:IPU to CONFIG_DEF_IPU.
    //set TERMINAL:CHARWIDTH to 6.
    //set TERMINAL:CHARHEIGHT to 8.//in pixels
    //set TERMINAL:REVERSE to true.
//    Config:DEFAULTFONTSIZE
    // Access:	Get/Set
    // Type:	Scalar integer-only. range = [6,20]

    // Configures the TerminalFontDefaultSize setting.

    // This is the default starting font height (in pixels. not “points”) for all newly created kOS in-game terminals. This is just the default for new terminals. 
    // Individual terminals can have different settings, either by setting the value Terminal:CHARHEIGHT in a script, 
    // or by manually clicking the font adjustment buttons on that terminal.
    // The value here must be at least 6 (nearly impossible to read) and no greater than 30 (very big).

    //ISTO ANTES DO DESENHA_TELA:
    DEBUG(NOME_DA_FUNC,"set CONFIG:IPU to [" + CONFIG_DEF_IPU + "]",P_debug_config).

}.
	
function LER_ARQUIVO_CONFIG_CPU_MOD{
	//
		return false.
}	
function LER_ARQUIVO_STATUS_CPU_MOD{
	//
		return false.
}	
function LER_ARQUIVO_CONFIG_NAVE{
	parameter ARQUIVO_CONG_NAVE.

	local NOME_DA_FUNC is "LER_ARQUIVO_CONFIG_NAVE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    DEBUG(NOME_DA_FUNC,"Somente uns harcoded configs",False).

	if (ARQUIVO_CONG_NAVE = "rov1"){
		print "hard code: core:tag to rov_cpu_1".
		set core:tag to "rov_cpu_1".
	}

	//
		return false.
}
function LER_ARQUIVO_STATUS_NAVE{
    parameter ARQUIVO_NAVE.// is "1:/nave_sts.status".
	parameter debug_LER_ARQUIVO_STATUS_NAVE is false.

    set ARQUIVO_NAVE to "1:/" + ARQUIVO_NAVE + ".status".

	//

	local	NOME_DA_FUNC 		is "LER_STATUS_NAVE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	local 	separador_sts_nave	is "=".
	local 	nome_cfg_avaliada	is "".
	local 	valor_cfg_avaliada	is "".

	local	CONFS_NO_ARQ		is "".							//ponteiro de arquivo

	debug(NOME_DA_FUNC, "Procurando arquivo de status da nave:", debug_LER_ARQUIVO_STATUS_NAVE).
	debug(NOME_DA_FUNC, ARQUIVO_NAVE, debug_LER_ARQUIVO_STATUS_NAVE).
	if (exists(ARQUIVO_NAVE)){
		SET 	CONFS_NO_ARQ		TO open(ARQUIVO_NAVE):READALL.
		for linha_sts_nave in CONFS_NO_ARQ{
				
			set nome_cfg_avaliada to linha_sts_nave:substring(0, linha_sts_nave:find(separador_sts_nave) ).
			
			//print "pos do valor_cfg_avaliada: [" + (linha_sts_nave:find(separador_sts_nave)+1) + "]".
			set valor_cfg_avaliada to linha_sts_nave:substring((linha_sts_nave:find(separador_sts_nave) + 1),
															 (linha_sts_nave:length - 1) - ((linha_sts_nave:find(separador_sts_nave))) ).
			
			TESTA_CONFIG_NO_ARQ_CFG(nome_cfg_avaliada, valor_cfg_avaliada).
			return true.
		}.
	}
	else{
		debug(NOME_DA_FUNC, "Arquivo de status da nave NAO EXISTE : " + ARQUIVO_NAVE, debug_LER_ARQUIVO_STATUS_NAVE).
		return false.
	}
}

function LER_ARQUIVO_CONFIG_C3{

	local	NOME_DA_FUNC 		is "LER_CFG_C3".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	local 	separador_cfg_c3	is "=".
	local 	nome_cfg_avaliada	is "".
	local 	valor_cfg_avaliada	is "".

	local 	CFG_FILE_C3 		is "0:/c3_cgf.cfg".				//caminho

	local	CONFS_NO_ARQ		is "".							//ponteiro de arquivo
	SET 	CONFS_NO_ARQ		TO open(CFG_FILE_C3):READALL.

	debug(NOME_DA_FUNC, "Procurando arquivo de config do C3: " + CFG_FILE_C3).
	if (exists(CFG_FILE_C3)){
		for linha_cfg_c3 in CONFS_NO_ARQ{
				
			set nome_cfg_avaliada to linha_cfg_c3:substring(0, linha_cfg_c3:find(separador_cfg_c3) ).
			
			//print "pos do valor_cfg_avaliada: [" + (linha_cfg_c3:find(separador_cfg_c3)+1) + "]".
			set valor_cfg_avaliada to linha_cfg_c3:substring((linha_cfg_c3:find(separador_cfg_c3) + 1), (linha_cfg_c3:length - 1) - ((linha_cfg_c3:find(separador_cfg_c3))) ).
			TESTA_CONFIG_NO_ARQ_CFG(nome_cfg_avaliada, valor_cfg_avaliada).
		}.
		return true.
	}
	else{
		debug(NOME_DA_FUNC, "Arquivo de config do C3 NAO EXISTE : " + CFG_FILE_C3).
		return false.
	}
}

function TESTA_CONFIG_NO_ARQ_CFG{
	parameter 	nome_cfg_test.
	parameter 	valor_cfg_test.
	//
			if (nome_cfg_test = NOME_CMD_get_AP_MAX) { SET OBJETIVOS_AP_MAX to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_get_HLAT) 	{ SET OBJETIVOS_HEAD_LAT to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_get_HOVER) { SET OBJETIVOS_HOVER_ALT to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_get_INCG) 	{ SET OBJETIVOS_INC_GANHO to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_get_PE) 	{ SET OBJETIVOS_PE_MIN to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_IPU) 		{ SET CONFIG_DEF_IPU 			to valor_cfg_test. }.
			if (nome_cfg_test = NOME_CMD_get_STGM) 	{ SET OBJETIVOS_STAG_MAX_ASC 	to valor_cfg_test. }.
			if (nome_cfg_test = "STATUS_VOO") 		{ SET STATUS_VOO 				to valor_cfg_test. }.

}















