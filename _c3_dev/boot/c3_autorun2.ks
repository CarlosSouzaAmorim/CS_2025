@LAZYGLOBAL OFF.
//c3_autorun.ks
// 4 funcoes: 288 linhas
//recompila
// -----------------------------------------------------------------------------------
// --                                                                               --
// --  ESTE ARQUIVO DECIDE O QUE FAZER NO BOOT DO MODULO                            --
// --                                                                               --
// --       edit 23042020: idicadores de estado e função:                           --
// --              arquivos de config e estado em 1:                                --
// --              nome da nave                                                     --
// --              nome do KOS module (NAME TAG especificado)                       --
// --                                                                               --
// --       prepara para uma possivel conexao telnet                                --
// --       se recupera de um reboot manual                                         --
// --       se recupera de uma desconexao acidental (mudanca de nave etc)           --
// --       boot para diferentes naves com o mesmo script c3                        --
// --           estacao espacial                                                    --
// --           nave no launchpad                                                   --
// --           nave em lancamanto                                                  --
// --                na atmosfera                                                   --
// --                estaging restante em relacao ao programado (fligth prog)       --
// --                                                                               --
// --           nave antes do apoapsis                                              --
// --                nave sem periapsis (pE < 0)                                    --
// --           nave em hover                                                       --
// --           nave em docking                                                     --
// --   ver_autorun	is "1.5":                                                       --
// --        arquivo indicador de telnet: opc n                                     --
// --           evitando redimensionar
// --           evitando abrir o console
// --   ver_autorun	is "1.6":                                                       --
// --        nao redimensiona mais para tela inteira                                --
// --           adicionada variavel global: mudar_aparencia_terminal                --
// --   ver_autorun	is "1.7a": (05/11/2020)                                         --
// --        registro de telnet                                                     --
// ver 1.7b alterado para menu com variaveis para teclas de opcoes
// ver 1.8a alterado parametros para cp
// --   ver is 1.8b 8/12/2020                                                       --
// --        opcao pause/wait to run c3                                             --
// -----------------------------------------------------------------------------------

//---- INICIALIZA VARIAVEIS: ---------------------------------------------------------
local term_open     is "no" .
local delay_tmp     is 0.01.//SDFG      //usado para esperar o sistema atualizar: copia de arquivos, update de tela (very fast=1 tick)
local delay_reboot  is 0.01.//3s : é passado nos parametros agora
global wait_para_cp is 10.
global	parametro_cp_3	to False.//debug
global	parametro_cp_4	to False.//pausa
global	parametro_cp_5	to 0.0.//wait

//global 	ver_autorun	is "1.4". //até 23/04/2020
global 	ver_autorun	is "1.8b". //1.5 em 23/04/2020 1.6 em 24/04 1.7 em 29/04
global  mudar_aparencia_terminal is true.

//o tamanho do terminal padrao (ksp1.7.1 kos??) é 50x36 8px ???
//PARA RESOLUÇÃO DE 1920X1080: = 237x64//bom para telnet em fullscr
//local LARG_TERM to 237.//bom para telnet em fullscr
local ALTU_TERM to 64.
local LARG_TERM to 130.//bom pra aparecer a nave em 1080
// local ALTU_TERM to 55.
local FONT_TERM to 10.
local CH_H_TERM to 10.

if (mudar_aparencia_terminal) {
    //altura e largura configurados depois de checar se é telnet
    set CONFIG:DEFAULTFONTSIZE to FONT_TERM.
    //set TERMINAL:CHARWIDTH to 6. //obsolete
    set TERMINAL:CHARHEIGHT to CH_H_TERM.//in pixels
    //set CONFIG:IPU to CONFIG_DEF_IPU.
    //set TERMINAL:REVERSE to true.
}

local larg_antes is TERMINAL:WIDTH.
local altu_antes is TERMINAL:HEIGHT.

global tecla_pause      is " p".//pausa e espera usuário após término da compilação
global tecla_wait       is " w".//wait por 10s após termino da compilação
global tecla_term       is " t".//deixa o terminal fechado/aberto deixa 
global tecla_comp       is " c".
global tecla_new_cp     is " x".//usa o cp.ks no 0:/
global tecla_autrn      is " a".
global tecla_tnet       is " n".
global tecla_help       is " h".
global tecla_esplh      is " e".
global tecla_redim      is " u".
global tecla_source     is " s".
global tecla_tamanho    is " z".
global tecla_debug      is " d".

global modf_ativa       is ">".
global modf_desativa    is " ".



HUDTEXT("BOOTFILENAME V"+ver_autorun+" : "  + core:bootfilename, 60, 2, 15, yellow, false).
//set TERMINAL:VISIBLE to True.

parameter parametro_indicado_na_inicializacao 	is ""   .
parameter parametro_antigo_core_bootfilename 	is ""   .
parameter parametro_autor_ks 					is "0:/boot/c3_autorun2.ks".
parameter parametro_autor_ksm 					is "0:/boot/c3_autorun2.ksm".
parameter parametro_path_root_destino			is "1:/boot".
parameter parametro_delay_reinicio	    		is delay_reboot.

// -------- CHECA PARAMETROS EM CASO DE CHAMADA POR OUTRA VERSAO ---------------------
if (parametro_indicado_na_inicializacao = "nova_versao") {
    print "parametro_indicado_na_inicializacao : ["+parametro_indicado_na_inicializacao+"] : delay_reboot ["+parametro_delay_reinicio+"]".
    wait parametro_delay_reinicio.
	CLEARSCREEN.
	PRINT "ATUAL: core:bootfilename: [" + core:bootfilename + "] ????".
	PRINT "ANTIGO: core:bootfilename: [" + parametro_antigo_core_bootfilename + "] ????".
	
	//set core:bootfilename to parametro_antigo_core_bootfilename.
	
	compile parametro_autor_ks to parametro_autor_ksm.
	
	copypath(parametro_autor_ks,  parametro_path_root_destino).
	copypath(parametro_autor_ksm, parametro_path_root_destino).// + "boot"
	wait delay_tmp.
		print "".
		print "   VAI REINICIAR PARA LIMPAR VARIÁVEIS... tout="+parametro_delay_reinicio+"s".
		print "".
		wait parametro_delay_reinicio.
	
	reboot.
}

//FAZER: ESCREVER AQUI QUEM CRIA ISSO:
//"e" e "n" > FUNCTION PREPARA_REBOOT{ //c3.ks >> comando reboot
//		> "t" tb mas esta comentado
//

// -------- DETECTA CONFIGURACOES EM CASO DE REBOOT MANUAL ---------------------------
local arquivo_para_indicar_que_o_cpu0_compilou is "0:/"+ship:name+".cfg.fly".

if ( exists("1:/reboot_wait.cfg")){
    //log "reboot_wait "+TEMPO_reboot_RECOVERY to "1:/reboot_wait.cfg".
    deletepath("1:/reboot_wait.cfg").
    set delay_tmp to 1.05.
}
if ( exists(arquivo_para_indicar_que_o_cpu0_compilou) ){
    deletepath(arquivo_para_indicar_que_o_cpu0_compilou).
}

if exists("1:/reboot_n.cfg"){//t n e u ou nada
    set     term_open       to "n".
    deletepath("1:/reboot_n.cfg").
}
else if ( exists("1:/reboot_t.cfg")){ set     term_open       to "t". deletepath("1:/reboot_t.cfg").}
else if ( exists("1:/reboot_e.cfg")){ set     term_open       to "e". deletepath("1:/reboot_e.cfg").}
else if ( exists("1:/reboot_u.cfg")){ set     term_open       to "u". deletepath("1:/reboot_u.cfg").}
else if ( exists("1:/reboot.cfg"  )){   set     term_open       to "" . deletepath("1:/reboot.cfg").  }
else if (  (ship:name = "land_1_3"))// and (core:tag = "cpu0")) ) //exists(arquivo_para_indicar_que_o_cpu0_compilou) or
    {        
    //deletepath(arquivo_para_indicar_que_o_cpu0_compilou).
    print "isto nao foi testado. t=10s".
    print "larg 150 if cpu1,2,3".
    print "alt 45".
    //wait 10.

    //evitar delays
    //direcionar direto para opcao já programada: configfile ou hardcoded

    if core:tag = "cpu0"{
        //set_term2("z").//z = tamanho ok (verificar o tamanho minimo mesmo)
        //set_term2("d").//debug
        set_term2("t").//fica term aberto
       
        //set tecla_comp to modf_ativa + tecla_comp[1]. //set_term2("c").//compila na marra
    }
    //set_term2("c").//recompila cp
    //set_term2("blah").

        //hardcode for some ships
        if (core:tag = "cpu1") or (core:tag = "cpu2") or (core:tag = "cpu3"){
            print ".. hardcoded actions for: core:tag[" + core:tag+"]".
            wait 0.1.//esperar o cpu0 iniciar primeiro e excluir o cfg.fly
                    set TERMINAL:WIDTH to 145.
                    set TERMINAL:HEIGHT to 95.
            if ((core:tag = "cpu1")) {
                set tecla_term to modf_ativa + tecla_term[1].
            }        
            if ((core:tag = "cpu2") or (core:tag = "cpu3")) {
                set tecla_term to modf_desativa + tecla_term[1].
                //set_term2(tecla_term[1]).
            }
            //esperando o 
            print "  ... esperando criacao de arquivo: arquivo_para_indicar_que_o_cpu0_compilou:" + arquivo_para_indicar_que_o_cpu0_compilou.

            until (exists(arquivo_para_indicar_que_o_cpu0_compilou)){
                //
            }
        }

    set volume(1):name to core:tag.
    set     term_open       to "fly". 

    //ATIVA_REGISTRO_TELNET("fly", "0:/"+ship:name+".cfg.fly").
    //set_term("vai_goku").
    }

else
    {//SEM INDICAÇÃO DE REBOOT:
        if exists("1:/telnet_.cfg"){//t n e u ou nada
            //telnet_.cfg indica que existe uma conexão telnet configurada e não é pra abrir o console no game
            //se abrir corre risco de bugar no resize
            deletepath("1:/telnet_.cfg").
        }
        else {
            core:DOACTION("open terminal",True).
        }
        wait delay_tmp.

        //Each CPU thinks of its OWN volume as number ‘1’.
        //Therefore using the SET command on the volumes is useful when dealing with multiple CX-4181’s on the same vessel, so they all will refer to the volumes using the same names:
        //SET VOLUME("0"):NAME TO "newname".
        //If a kOS processor has a name tag set, then that processor’s volume will have its name initially set to the value of the name tag.
        set volume(1):name to core:tag.

        TESTES_DEBUG_AUTORUN().
            
        //BOASVINDAS_MSG().//
        
        //Execução da rotina: set_term: as mensagens de escolha dependerm dela...

        //hardcode for some ships
        if (core:tag = "cpu1") or (core:tag = "cpu2") or (core:tag = "cpu3"){
                    set TERMINAL:WIDTH to 145.
                    set TERMINAL:HEIGHT to 95.
        }
        if ((core:tag = "cpu2") or (core:tag = "cpu3")) {
            set tecla_term to modf_desativa + tecla_term[1].
            //set_term2(tecla_term[1]).
        }
        if ((core:tag = "cpu1")) {
            set tecla_term to modf_ativa + tecla_term[1].
        }        
        if core:tag = "cpu0"{
            //set_term2("z").//z = tamanho ok (verificar o tamanho minimo mesmo)
            //set_term2("d").//debug
            //set_term2("t").//fica term aberto
            set tecla_comp to modf_ativa + tecla_comp[1].
            //set_term2("c").//compila na marra
        }

        local continua_autorun is False.
        local opcao_digitada is "".
        until (continua_autorun){
            BOASVINDAS_MSG().

            set opcao_digitada to terminal:input:getchar().
            //set_term2(opcao_digitada).
            set continua_autorun to set_term2(opcao_digitada).
        }
        set term_open to opcao_digitada.
        wait delay_tmp.
        clearScreen.
    }.

// ============== CONFIGURA COMO IRA EXECUTAR O C3 ou CP3: ===========================
global	parametro_2_c3	to "".
local   parametro_c3    to set_term(term_open)          .

if (parametro_c3 = "sair_do_autorun") {print "Sair do autorun...".}
else{EXECUTA_COMPILA_CP(parametro_c3,parametro_2_c3, parametro_cp_3, parametro_cp_4, parametro_cp_5 ).}

//=========  fim DO CODIGO AUTORUN ===================================================

FUNCTION BOASVINDAS_MSG{
    //print "blob" at (0,16).
    print "-------------------------------------------------|"                                                  at (0,16).
    print "Pressione:              autorun v" + ver_autorun + "            |"                                   at (0,17).
    PRINT "  qualquer tecla para continuar e fechar terminal|"                                                  at (0,18).

    PRINT " "+tecla_term +" fica ABERTO      "+tecla_help   +" ajuda    "+tecla_autrn+" NEWautorun   |"         at (0,19).
    PRINT " "+tecla_comp +" RECOMPILA CP.KS  "+tecla_source +" compOFF  "+tecla_wait +" wait "+wait_para_cp+"      |"   at (0,20).
    PRINT " "+tecla_tnet +" set TELNET       "+tecla_tamanho+" size     "+tecla_pause+" pausa        |"         at (0,21).
    PRINT " "+tecla_esplh+" set TELNET esp   "+tecla_new_cp +" new cp   "+tecla_debug+" debug        |"         at (0,22).
    print " "+tecla_redim+" para indicar telnet e recp dimensoes [mantem]|"                                     at (0,23).

    PRINT "          (ou FAZER esperar conectar com telnet) |"                                                  at (0,24).
    PRINT "_________________________________________________|"                                                  at (0,25).
	
    //print "ATENCAO EXISTE UM PROBLEMA COM O CP: NAO ATUALIZA OS EDITADOS"                                       at (0,26).
    //print "em maquinas que rodam em segundo POIS PEGA COMO REFERENCIA 0:/fonts.cfg"                             at (0,27).
    //print "vai ter que editar e salvar para cada maquina: salva > roda em A; edita > salva>roda em B"           at (0,28).
	//print "Não atualiza os editados tb na opção COMPILACAO_OFF."                                                at (0,29).
    
	print "tempo real PC: " + KUniverse:REALTIME                                                                at (0,30).
}.

FUNCTION TESTES_DEBUG_AUTORUN{
    print " --  Primeiro script a executar nas CPUS  --".
        print "testes: V" + ver_autorun.

        print "SHIP:NAME     : "  + SHIP:NAME.
        print "BOOTFILENAME  : "  + core:bootfilename.
        print "core:tag      : "  + CORE:TAG.
        print "core:part:NAME: "  + core:part:NAME.
        print "FAZER: testar mais com TEST_PARTS_GET_MODULES()".
        
        print "CONFIG:TELNET    :"  + CONFIG:TELNET.
        print "CONFIG:TPORT     :"  + CONFIG:TPORT.
        print "CONFIG:IPADDRESS :"  + CONFIG:IPADDRESS.
        // TELNET 	Boolean 	False 	activate the telnet server
    // TPORT 	Scalar (integer) 	5410 	set the port the telnet server will run on
    // IPADDRESS 	String 	“127.0.0.1” 	The IP address the telnet server will try to use.
    print "volume(1):name: "  + volume(1):name.
    //    print "core:name: " + CORE:NAME.
    //SET CORE:NAME TO CORE:TAG.
    //    print "core:tag: " + CORE:TAG.
    //    print "core:name: " + CORE:NAME.
	// PRINT CORE.
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
}.
FUNCTION set_term2{//somente ativa e desativa opcoes e reconhece ENTER
    parameter OPC_TERM2.
//    print "   set_term2: pega caracter:" + OPC_TERM2 at (0,32).
    print_MSG_SET_TERM2("   set_term2: pega caracter:" + OPC_TERM2, 32).
	
	if (OPC_TERM2 = tecla_pause[1]){        //ATIVA UMA PAUSA ANTES DO BOOT C3
        if (tecla_pause[0] = modf_desativa){
            print_MSG_SET_TERM2("ativa uma pausa antes do boot C3...").
            set tecla_pause  to modf_ativa + tecla_pause[1].
            //set wait_para_cp to -1.//ideia para usar somente um parametro para as duas coisas pause/wait
        }
        else {
            print_MSG_SET_TERM2("desativa uma pausa antes do boot C3...").
            set tecla_pause  to modf_desativa + tecla_pause[1].
        }
	}
	else if (OPC_TERM2 = tecla_wait[1]){        //ATIVA uma espera antes do boot c3
        if (tecla_wait[0] = modf_desativa){
            print_MSG_SET_TERM2("ativa uma espera de "+wait_para_cp+"s antes do boot C3...").
            set tecla_wait  to modf_ativa + tecla_wait[1].
        }
        else {
            print_MSG_SET_TERM2("desativa uma espera de "+wait_para_cp+"s antes do boot C3..." ).
            set tecla_wait  to modf_desativa+ tecla_wait[1].
        }
	}
	else if (OPC_TERM2 = tecla_term[1]){        //ATIVA TERMINAL NA TELA KSP
        if (tecla_term[0] = modf_desativa){
            print_MSG_SET_TERM2("ativa terminal na tela do KSP...").
                core:DOACTION("open terminal",True).                
            set tecla_term  to modf_ativa + tecla_term[1].
        }
        else {
            print_MSG_SET_TERM2("desativa terminal na tela do KSP..." ).
                core:DOACTION("close terminal",True).
            set tecla_term  to modf_desativa+ tecla_term[1].
        }
	}
	else if (OPC_TERM2 = tecla_tnet[1]){        //ATIVA indicaro de TELNET
        if (tecla_tnet[0] = modf_desativa){
            print_MSG_SET_TERM2("TELNET DESATIVADO: ativa terminal na tela do KSP...").
                core:DOACTION("open terminal",True).                
            set tecla_tnet  to modf_ativa + tecla_tnet[1].
        }
        else {
            print_MSG_SET_TERM2("TELNET ATIVADO: desativa terminal na tela do KSP..." ).
                core:DOACTION("close terminal",True).
            set tecla_tnet  to modf_desativa+ tecla_tnet[1].
        }
	}
	else if (OPC_TERM2 = tecla_autrn[1]){        //executa autorun no 0:/
        if (tecla_autrn[0] = modf_desativa){
            print_MSG_SET_TERM2("executa autorun no 0:/..." ).
            set tecla_autrn  to modf_ativa + tecla_autrn[1].
            return true.
        }
        else {
            print_MSG_SET_TERM2("nao executa autorun no 0:/...").
            set tecla_autrn  to modf_desativa + tecla_autrn[1].
        }
	}
	else if (OPC_TERM2 = tecla_new_cp[1]){        //executa cp no 0:/ (atualiza somente o cp.ks)
        if (tecla_new_cp[0] = modf_desativa){
            print_MSG_SET_TERM2("executa cp.ks no 0:/...").
            set tecla_new_cp  to modf_ativa + tecla_new_cp[1].
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO: executa cp.ks no 0:/").
            set tecla_new_cp  to modf_desativa + tecla_new_cp[1].
        }
	}
	else if (OPC_TERM2 = tecla_comp[1]){        //executa cp no 0:/ e recompila tudo
        if (tecla_comp[0] = modf_desativa){
            print_MSG_SET_TERM2("executa cp no 0:/ e recompila tudo...").
            set tecla_comp  to modf_ativa + tecla_comp[1].
            //return true.
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO: executa cp no 0:/ e recompila tudo").
            set tecla_comp  to modf_desativa + tecla_comp[1].
        }
	}
	else if (OPC_TERM2 = tecla_source[1]){        //executa cp.ks no 0:/ e nao compila
        if (tecla_source[0] = modf_desativa){
            print_MSG_SET_TERM2("executa cp.ks no 0:/ e nao compila...").
            set tecla_source  to modf_ativa + tecla_source[1].
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO: executa cp.ks no 0:/ e nao compila").
            set tecla_source  to modf_desativa + tecla_source[1].
        }
	}
	else if (OPC_TERM2 = tecla_redim[1]){        //redimensiona para ANTERIOR...
        if (tecla_redim[0] = modf_desativa){
            print_MSG_SET_TERM2("redimensiona para ANTERIOR...").
            set tecla_redim  to modf_ativa + tecla_redim[1].
                set TERMINAL:WIDTH to larg_antes.
                set TERMINAL:HEIGHT to altu_antes.
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO: redimensiona para ANTERIOR...").
            set tecla_redim  to modf_desativa + tecla_redim[1].
        }
	}
	else if (OPC_TERM2 = tecla_tamanho[1]){        //redimensiona para padrao...
        if (tecla_tamanho[0] = modf_desativa){
            print_MSG_SET_TERM2("redimensiona para padrao..." + LARG_TERM + " X " + ALTU_TERM).
            set tecla_tamanho  to modf_ativa + tecla_tamanho[1].
            	set TERMINAL:WIDTH to LARG_TERM.
	            set TERMINAL:HEIGHT to ALTU_TERM.
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO: redimensiona para padrao...voltar para: "  + larg_antes + " X " + altu_antes).
            set tecla_tamanho  to modf_desativa + tecla_tamanho[1].
                set TERMINAL:WIDTH to larg_antes.
                set TERMINAL:HEIGHT to altu_antes.
        }
	}
	else if (OPC_TERM2 = tecla_debug[1]){        //debug...
        if (tecla_debug[0] = modf_desativa){
            print_MSG_SET_TERM2("ativado debug").
            set tecla_debug  to modf_ativa + tecla_debug[1].
        }
        else {
            print_MSG_SET_TERM2("DESATIVADO debug").
            set tecla_debug  to modf_desativa + tecla_debug[1].
        }
	}

	else if (OPC_TERM2 = terminal:input:RETURN){   //RECONHECE ENTER
        return true.
	}
    else {
        print_MSG_SET_TERM2("set_term2: caracter nao reconhecido").
        }.   
    return false.
}.
FUNCTION print_MSG_SET_TERM2{
    parameter msg_set_term2_str is "".
    parameter linha_msg_set_term2 is 33.

    print "                                                                       " at (0,linha_msg_set_term2).
	print msg_set_term2_str at (0,linha_msg_set_term2).
}
FUNCTION print_MSG_ar{
    parameter msg_ar is "".

	print "AR: "+ msg_ar.
}

FUNCTION set_term{
    parameter OPC_TERM.
	
    print_MSG_ar("set_term:OPC_TERM: ["+OPC_TERM+"]").
    print_MSG_ar("   Executando com delay de ["+ delay_tmp + "] segundos entre os passos.").
	
	//Evitar o glitch de redimensionamento do terminal no telnet
	//set TERMINAL:WIDTH to LARG_TERM.
	//set TERMINAL:HEIGHT to ALTU_TERM.
	//set CONFIG:DEFAULTFONTSIZE to FONT_TERM.
	//set TERMINAL:CHARHEIGHT to CH_H_TERM.//in pixels
	
    print "   FAZER: Definir melhor IPU : ALTO PARA COMPILACAO BAIXO PARA RODAR".
    print_MSG_ar("   CONFIG:IPU is [" + CONFIG:IPU + "]").
    set CONFIG:IPU to 2000.
    print_MSG_ar("   CONFIG:IPU set to [" + CONFIG:IPU + "]").
	print "   ".
    local GET_PAR_C3 is "".
	if (OPC_TERM = "a"){        //ATUALIZA BOOT: inicia o autorum no 0:/boot/c3_autorun2.ks
        print "inicia o autorum no 0:/boot/c3_autorun2.ks ...".
		
		
		print "executa comando: runpath(0:/boot/c3_autorun2.ks,nova_versao,core:bootfilename,0:/boot/c3_autorun2.ks,0:/boot/c3_autorun2.ksm,1:/boot".
		print "".
		print "   VAI LIMPAR A TELA... tout=3s".
		print "".
		wait delay_reboot.
		runpath("0:/boot/c3_autorun2.ks","nova_versao",core:bootfilename,"0:/boot/c3_autorun2.ks","0:/boot/c3_autorun2.ksm","1:/boot").
		set GET_PAR_C3 to "sair_do_autorun".
	}
	else if (OPC_TERM = "c"){   //RECOMPILA TUDO FORÇADO
		//opcao para indicar que o modo compile deve ficar ATIVADO
        set GET_PAR_C3 to "modo_compile_on".
		set parametro_2_c3 to "modo_compile_force_on".
		 print "Fechando terminal...".
		 wait delay_tmp.		
         core:DOACTION("close terminal",True).

        //print "Nao fechando terminal...".    
	}
    else if (OPC_TERM = "e"){   //INDICA TELNET E MANTEM TERM
        set GET_PAR_C3 to "telnet_and_keep".
		ATIVA_REGISTRO_TELNET(GET_PAR_C3).
        print "Nao fechando terminal...".    
    } 
    else if (OPC_TERM = "n"){   //MODO NORMAL
        if (mudar_aparencia_terminal) {
            set TERMINAL:WIDTH to LARG_TERM.
            set TERMINAL:HEIGHT to ALTU_TERM.
        }
		print "Nao fechando terminal...".
	}
	else if (OPC_TERM = "s"){   //MODO COMPILE OFF: RODA OS .KS
		//opcao para indicar que o modo compile deve ficar DESATIVADO
		//parametro_para_c3="modo_compile_off"
        set GET_PAR_C3 to "modo_compile_off".
		 print "Fechando terminal...".
		 wait delay_tmp.		
         core:DOACTION("close terminal",True).

        //print "Nao fechando terminal...".    
	}
    else if (OPC_TERM = "t"){   //INDICA TELNET E FECHA TERM
        set GET_PAR_C3 to "telnet_and_close".
        print "autorun: Indicando:" + GET_PAR_C3.
		ATIVA_REGISTRO_TELNET(GET_PAR_C3).
		 print "Fechando terminal...".
		 wait delay_tmp.		
         core:DOACTION("close terminal",True).
    } 
    else if (OPC_TERM = "u"){   //TELNET RESTAURA DIMENSOES TERMINAL
        //larg_antes
        set TERMINAL:WIDTH to larg_antes.
        set TERMINAL:HEIGHT to altu_antes.
        set GET_PAR_C3 to "telnet_and_keep".
		ATIVA_REGISTRO_TELNET(GET_PAR_C3).
        print "Nao fechando terminal...".    
    }
    else {                  //INICIA NORMAL (se foi ENTER POR EXEMPLO)

            if (tecla_term[0] = modf_ativa){
                print " vai mostrar terminal na tela do KSP...".
                print "Abrindo terminal...".
                wait delay_tmp.
                core:DOACTION("open terminal",True).                
            }
            else {
                print " nao vai mostrar terminal na tela do KSP...".
                print "Fechando terminal...".
                wait delay_tmp.
                core:DOACTION("close terminal",True).
            }

            if (tecla_new_cp[0] = modf_ativa){
                print " compila 0:/cp.ks...".
                set term_open to "c".
            }
            if (tecla_comp[0] = modf_ativa){
                print " compila cp...".
                set GET_PAR_C3 to "modo_compile_on".
                set parametro_2_c3 to "modo_compile_force_on".
                set term_open to "c".
            }
            if (tecla_source[0] = modf_ativa){
                print " usa fontes .ks...".
                set GET_PAR_C3 to "modo_compile_off".
                set term_open to "s".
            }
            if (tecla_pause[0] = modf_ativa){
                print " vai usar uma pausa e esperar user apos compilar...".
                set parametro_cp_4 to True.
            }
            if (tecla_wait[0] = modf_ativa){
                print " vai usar um wait "+wait_para_cp+" apos compilar...".
                set parametro_cp_5 to wait_para_cp.
            }
            if (tecla_redim[0] = modf_ativa){
                set TERMINAL:WIDTH to larg_antes.
                set TERMINAL:HEIGHT to altu_antes.
                //set GET_PAR_C3 to "telnet_and_keep".
                ATIVA_REGISTRO_TELNET("telnet_and_keep").
                print "Nao fechando terminal...".
            }
            if (tecla_tamanho[0] = modf_ativa){
            	set TERMINAL:WIDTH to LARG_TERM.
	            set TERMINAL:HEIGHT to ALTU_TERM.
                print "redimensionando terminal: " + LARG_TERM + " X " + ALTU_TERM.
            }
            if (tecla_debug[0] = modf_ativa){
                set parametro_cp_3 to True.
                print "iniciando com debug ativado".
            }
            if (tecla_tnet[0] = modf_ativa){//VER FAZER VERISSO
                set GET_PAR_C3 to "telnet_and_close".//COMO ISTO CONFLITA COM DEBUG/COMPILA/RECOMPILAC3 ???
                print "autorun: Indicando:" + GET_PAR_C3.
                ATIVA_REGISTRO_TELNET(GET_PAR_C3).
                print "Fechando terminal...".
                wait delay_tmp.		
                core:DOACTION("close terminal",True).
            }

        local TESTE_OPC_TERM is "ei".
        if (tecla_term[0]=modf_ativa){
                //ahhhhhh
        }
        else if (tecla_term[0] = modf_ativa){  //ATIVA TERMINAL NA TELA KSP
        }
        else{
            //ahhjdjfk
        }
        //precisava de uma maneira mais rápida de testar os scripts
        //      necessário recompilar toda vez?
        //      preciso ver o que ocorre após a compilação:
        //          ativar um timer após a compilação
        //              usar autorum para indicar a pausa
        //                  menu do autorun está saturado
        //                      incluir mais opcoes com ativação dinâmica de opcoes no menu com printAT
        //                          opção de pausa




        }.
	    print_MSG_ar("   autorun: Indicando:" + GET_PAR_C3).

    //print "set_term:GET_PAR_C3 ["+GET_PAR_C3+"]".    wait 1.
    
    return GET_PAR_C3.
}.

FUNCTION EXECUTA_COMPILA_CP{
    parameter PAR_C3.
	parameter PAR2_C3 is "".
    parameter PAR_CP3 is False.//ativa debug
    parameter PAR_CP4 is False.//pausa
    parameter PAR_CP5 is 0.0.//tempo antes do c3
    //por padrao vai iniciar no 1:/
    //executara como 1:/boot/c3_autorun2.ks
    //nao vai achar cp

	if not ( exists("1:/cp.ks") or exists("1:/cp.ksm") ) {
        print ".   NAO EXISTE CP EM 1:\ TENTANDO EM 0:\ > [switch to 0]".
        switch to 0.
	}.

    wait delay_tmp.
    //runpath("cp.ks"+PAR_C3).

    //FAZER: RODAR O CP MAIS NOVO: Quando da erro no cp velho nao da pra atualizar o novo cp
    //          se os dois forem da mesma idade (mesmo tamanho ta bom) entao rodar o ksm no 1

    local CP_ARQUIVO_EXECUTAR is "0:/cp.ks".

    if ((term_open = "c") or (term_open = "s")) {
        //PRINT "INICIANDO CP.KS EM 0:/ RECOMPILANDO CP...".
        //wait delay_tmp.
        //runpath("0:/cp.ks", PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
        set CP_ARQUIVO_EXECUTAR to "0:/cp.ks".
    }
    else if exists("1:/cp.ksm") {
        //PRINT "INICIANDO CP.KSM ["+PAR_C3+"] EM 1:/ ...".
        //wait delay_tmp.
        //runpath("1:/cp.ksm", PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
        set CP_ARQUIVO_EXECUTAR to "1:/cp.ksm".
    }
    else if exists("1:/cp.ks") {
        //PRINT "INICIANDO CP.KS ["+PAR_C3+"] EM 1:/ ...".
        //wait delay_tmp.
        //runpath("1:/cp.ks", PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
        set CP_ARQUIVO_EXECUTAR to "1:/cp.ks".
    }
    else if exists("0:/cp.ksm") {//eh melhor rodar ksm ou ks no 0
        //PRINT "INICIANDO CP.KSM ["+PAR_C3+"] EM 0:/ ...".
        //wait delay_tmp.
        //runpath("0:/cp.ksm", PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
        set CP_ARQUIVO_EXECUTAR to "0:/cp.ksm".
    }
    else if exists("0:/cp.ks") {
        //PRINT "INICIANDO CP.KS ["+PAR_C3+"] EM 0:/ ...".
        //wait delay_tmp.
        //runpath("0:/cp.ks", PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
        set CP_ARQUIVO_EXECUTAR to "0:/cp.ks".
    }.  

    print_MSG_ar("INICIANDO CP ["+PAR_C3+" "+PAR2_C3+" "+PAR_CP3+" "+PAR_CP4+" "+PAR_CP5+" "+"] EM "+CP_ARQUIVO_EXECUTAR).
    if exists(CP_ARQUIVO_EXECUTAR) {
        wait delay_tmp.
        runpath(CP_ARQUIVO_EXECUTAR, PAR_C3, PAR2_C3, PAR_CP3, PAR_CP4, PAR_CP5).
    }
    else{
        print_MSG_ar("erro: arquivo nao encontrado").
    }


}.

function ATIVA_REGISTRO_TELNET{
    parameter INDICADOR is "telnet ativado".
    parameter ARQUIVO is "1:/telnet_.cfg".

        log INDICADOR to ARQUIVO.

    return true.
}

//FIM DO ARQUIVO
