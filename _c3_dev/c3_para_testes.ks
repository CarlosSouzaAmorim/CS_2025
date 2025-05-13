@LAZYGLOBAL OFF.
//c3_para_testes.ks
// 12 funcoes: 543 linhas
//recompila

//uses: BLAH25555 jfgdfhgjhhj
//runoncepath("c3_init_vars").

// ====    FUNCOES PARA TESTE RAPIDO POIS COMPILA SOMENTE ESTA ============================================================================
//global QUEUE_CORE_SHIP_MESG is CORE:MESSAGES.

//------- CIRCULAR PELOS COMANDO JÁ DIGITADOS  -----------------------------------------------------------------------------------
FUNCTION CICLA_CMD_P_CIMA{
    parameter debug_P_CIMA is False.
	local NOME_DA_FUNC is "CICLA_CMD_P_CIMA".
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).
    //
    //DESENHA_VETORES().
    //
    //TEST_VEC_STARTUPDATER().
    
            if (Hist_Com:LENGTH > 1) {//somente se ja tiver algo no historico  > ver > and (Hist_Com[0] > -1)     
                DEBUG(NOME_DA_FUNC,"UP: poe o ponteiro na posicao anterior: ["+Hist_Com[0]+"] len["+Hist_Com:LENGTH+"]----------------------------------", debug_P_CIMA).
                
                if (Hist_Com[0] > 1){
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] > 1 : ["+Hist_Com[0]+"]", debug_P_CIMA).
                    //inicialmente vai estar no pos_final + 1
                    set Hist_Com[0] to (Hist_Com[0] - 1).//poe o ponteiro na posicao anterior
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] > 1 : ["+Hist_Com[0]+"]: com:[" +Hist_Com[Hist_Com[0]]+"]", debug_P_CIMA).
                }
                
                //mas quando chegar no 0?
                else if (Hist_Com[0] = 1){
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] = 1 : ["+Hist_Com[0]+"]", debug_P_CIMA).
                    set Hist_Com[0] to 0.//poe o ponteiro na posicao anterior
                    set linha_digitada_no_prompt to "".
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] = 1 : ["+Hist_Com[0]+"]", debug_P_CIMA).
                }
                
                else if (Hist_Com[0] = 0){
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] = 0 : ["+Hist_Com[0]+"]", debug_P_CIMA).
                    set Hist_Com[0] to (Hist_Com:LENGTH).
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0] -1].                    //hiha
                    DEBUG(NOME_DA_FUNC,"UP: Hist_Com[0] = 0 : ["+Hist_Com[0]+"]" ).
                }.
                DEBUG(NOME_DA_FUNC,"UP: poe o ponteiro na posicao anterior: ["+Hist_Com[0]+"]", debug_P_CIMA).
            }
            else{   //nao ha nada no historico > "para cima" fara com que apague tudo
                set linha_digitada_no_prompt to "".
            }.
            print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
}.
FUNCTION CICLA_CMD_P_BAIXO{
    parameter debug_P_BAIXO is False.
	local NOME_DA_FUNC is "CICLA_CMD_P_BAIXO".
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).
    //
            if (Hist_Com:LENGTH > 1) {//somente se ja tiver algo no historico  > ver > and (Hist_Com[0] > -1)
                DEBUG(NOME_DA_FUNC,"DN: poe o ponteiro na posicao posterior: ["+Hist_Com[0]+"]", debug_P_BAIXO).
               
                //INICIALMENTE VAI ESTAR em pos_final + 1 : chegar no 0?
                if (Hist_Com[0] = (Hist_Com:LENGTH) ){
                    set Hist_Com[0] to (0).//poe o ponteiro na posicao anterior
                    set linha_digitada_no_prompt to "".
                    DEBUG(NOME_DA_FUNC,"DN: Hist_Com[0] = LENGTH : ["+Hist_Com[0]+"]", debug_P_BAIXO).
                }
                
                else if (Hist_Com[0] = 0){
                    set Hist_Com[0] to (Hist_Com[0] + 1).
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    DEBUG(NOME_DA_FUNC,"DN: Hist_Com[0] = 0 : ["+Hist_Com[0]+"]", debug_P_BAIXO).
                }
                else if (  Hist_Com[0] < (Hist_Com:LENGTH - 1)  ){
                    set Hist_Com[0] to (Hist_Com[0] + 1).
                    set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    DEBUG(NOME_DA_FUNC,"DN: Hist_Com[0] < LENGTH-1 : ["+Hist_Com[0]+"]", debug_P_BAIXO).
                }
                else if (Hist_Com[0] = (Hist_Com:LENGTH - 1)){
                    set Hist_Com[0] to (Hist_Com[0] + 1). //aqui vai pos_final + 1
                    //set linha_digitada_no_prompt to Hist_Com[Hist_Com[0]].
                    set linha_digitada_no_prompt to "".
                    DEBUG(NOME_DA_FUNC,"DN: Hist_Com[0] = LENGTH-1 : ["+Hist_Com[0]+"]", debug_P_BAIXO).
                }.
                DEBUG(NOME_DA_FUNC,"DN: poe o ponteiro na posicao posterior: ["+Hist_Com[0]+"]", debug_P_BAIXO).
            }
            else{   //nao ha nada no historico > "para cima" fara com que apague tudo
                set linha_digitada_no_prompt to "".
            }.
            print_stat(tprintCMD,CONCAT_STR_A(linha_digitada_no_prompt,larg_max_car),contador_CMD).//isso esta apagando tudo toda vez: diminuir o delay FAZER
}.
//------- FIM CIRCULAR PELOS COMANDO JÁ DIGITADOS  -------------------------------------------------------------------------------
    
//------- PARTS E MODULES  -------------------------------------------------------------------------------------------------------

FUNCTION PARTS_DA_NAVE_mina{            //loop pelas partes da NAVE: -----------------------------------------------------------------
    //
  	local NOME_DA_FUNC is "PARTS_DA_NAVE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
// Accessing the parts list as a tree
// Starting from the root part, Vessel:ROOTPART (SHIP:ROOTPART, TARGET:ROOTPART, or Vessel(“some ship name”):ROOTPART).
// You can get all its children parts with the Part:CHILDREN suffix. 
// Given any Part, you can access its Parent part with Part:PARENT, and detect if it doesn’t have a parent with Part:HASPARENT. 
// By walking this tree you can see how the parts are connected together.
// The diagram here shows an example of a small vessel and how it might get represented as a tree of parts in KSP.

    print_stat(tlogv, "LOOP parts NAVE", contador_log).

	print_stat(tfile, "====================   LOG INICIADO PELA FUNÇÃO : "+NOME_DA_FUNC+" : loop pelas partes da NAVE ================", contador_list).

    print_stat(tfile, "partes total:["+SHIP:PARTS:LENGTH+"]", contador_list).
	
    print_stat(tfile, "SHIP:ROOTPART:" + SHIP:ROOTPART, contador_list).
    //print "SHIP:ROOTPART:hasparent:".
    //print SHIP:ROOTPART:hasparent.
    
    print_stat(tfile, "SHIP:ROOTPART:children:[" +SHIP:ROOTPART:children:LENGTH+"]", contador_list).
    //print SHIP:ROOTPART:children.
    
    //local i is 0.
    
    //This gets the primary root part of a vessel (the command core that you placed FIRST when building the ship in the VAB or SPH):
    local PARTE_ATUAL to SHIP:ROOTPART.
    
    //set PARTE_ATUAL to PARTE_ATUAL:CHILDREN[i].
    
    
    PRINT_FILHOS(PARTE_ATUAL,0,True,False).

	print NOME_DA_FUNC + "INFORMACOES ENVIADAS PARA ARQUIVO LOG!".
	print_stat(tfile, "====================   LOG TERMINADO PELA FUNÇÃO : "+NOME_DA_FUNC+" : loop pelas partes da NAVE ================", contador_list).
    print_stat(tlogv, "NAVEparts to FILE", contador_log).

}.

FUNCTION PRINT_FILHOS{
    parameter PARTE_VER_FILHOS.
    parameter LEVEL_DEEP.
    parameter RECURSIVE             is True.
    parameter debug_PRINT_FILHOS    is True.
    
  	local NOME_DA_FUNC is "PRINT_FILHOS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
  	local CARACTERES_PERMITIDOS_filhos is "0123456789abcdefghijklmnopqrstuvwxyz".
    local count_filhos is 0.
    set LEVEL_DEEP to LEVEL_DEEP + 1.
    
    if (PARTE_VER_FILHOS:children:LENGTH > 0){
        print_stat(tlista, "-------------------" ,contador_list).
        for P IN PARTE_VER_FILHOS:children {
            
            //haschildren ?
            if RECURSIVE {
				print_stat(tfile, "[" + LEVEL_DEEP + "] ["+CARACTERES_PERMITIDOS_filhos[count_filhos]+"]" + enche_de_espacos(LEVEL_DEEP) + P:NAME + " [" + P:children:LENGTH + "] filhos", contador_list).
				
                wait 0.2.
                PRINT_FILHOS(P, LEVEL_DEEP).
            }
            else{
                print_stat(tlista, "["+count_filhos+"]" + P:NAME + " [" + P:children:LENGTH + "]f",contador_list).
            }.
            set count_filhos to inc(count_filhos).
        }.
    }
    else{
        if not(RECURSIVE) {
            debug(NOME_DA_FUNC, "nao tem filhos", debug_PRINT_FILHOS).
            print_stat(tlog, "nao tem filhos" ,contador_log).
        }.
    }.
    //
}.

FUNCTION PRINT_MODULES{                 //mostra em tlista e 
    parameter PARTE_VER_MODULES.
    
  	local NOME_DA_FUNC is "PRINT_MODULES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    local count_modules is 0.
    //(PARTE_ATUAL,0,False).
    //        print "MODULOS: " + PARTE_VER_MODULES:MODULES.//vai imprimir uma lista
            
    if (PARTE_VER_MODULES:MODULES:LENGTH > 0){
        print_stat(tlista, "----- modules ------" ,contador_list).
        for M1 IN PARTE_VER_MODULES:MODULES {//eita
            //local M_ATUAL to PARTE_VER_MODULES:GETMODULE(M1).            
            print_stat(tlista, "["+count_modules+"]" + M1,contador_list).
            //PRINT M1.
            // print_stat(tlista, "["+count_modules+"]" + M1:NAME + " ["   + M1:ALLFIELDNAMES:LENGTH + "]f"
                                                                        // + M1:ALLEVENTNAMES:LENGTH + "]e"
                                                                        // + M1:ALLACTIONNAMES:LENGTH + "]a",
                                                                        // contador_list).
            set count_modules to inc(count_modules).
        }.  
    }
    else{
        print_stat(tlista, "sem modulos", contador_list).
    }.
    print_stat(tlista, " [0..a..kl]=mod", contador_list).
}.
 
FUNCTION PRINT_MODULES_CAPABILITIES{    //mostra em tlista e tlogv FIELDS EVENTS OU ACTIONS de um modulo
    parameter MODULE_VER_CAPS.
    parameter caps_pegar.
    
  	local NOME_DA_FUNC is "PRINT_MODULES_CAPABILITIES".
    trace(NOME_DA_FUNC).
     set hops to inc(hops).
   
    local count_caps is 0.
    local caps is list().
    //local M_ATUAL to PARTE_VER_MODULES:GETMODULE(MODULES_VER_CAPS).            
            
    if (caps_pegar = "FIELD"){
        set caps to MODULE_VER_CAPS:ALLFIELDNAMES.
    }
    else if (caps_pegar = "EVENT"){
        set caps to MODULE_VER_CAPS:ALLEVENTNAMES.
    }
    else if (caps_pegar = "ACTION"){
        set caps to MODULE_VER_CAPS:ALLACTIONNAMES.
    }
    else if (caps_pegar = "capabilities"){
        set caps to MODULE_VER_CAPS:ALLFIELDNAMES + MODULE_VER_CAPS:ALLEVENTNAMES + MODULE_VER_CAPS:ALLACTIONNAMES.
    }
    else{ return 0. }.
    print_stat(tlista, "---- "+caps_pegar+" -----" ,contador_list).
    print_stat(tlogv, "("+ caps_pegar[0] +")"+ MODULE_VER_CAPS:NAME + caps_pegar+"s",contador_log).
    //print "caps:length "+caps:length.
    if (caps:LENGTH > 0){
        for cap IN caps {//eita
            print_stat(tlista, "["+count_caps+"]" + cap,contador_list).
            //PRINT M1.
            
            //print "MODULO SELECIONADO: "+MODULO_ATUAL.//imprime o resumo de fields, events e actions
            // print_stat(tlista, "["+count_modules+"]" + M1:NAME + " ["   + M1:ALLFIELDNAMES:LENGTH + "]f"
                                                                        // + M1:ALLEVENTNAMES:LENGTH + "]e"
                                                                        // + M1:ALLACTIONNAMES:LENGTH + "]a",
                                                                        // contador_list).
            set count_caps to inc(count_caps).
        }.
    }
    else{
        //debug(NOME_DA_FUNC, caps).
        print_stat(tlista, "sem "+caps_pegar+"s", contador_list).
    }.
}.
            
FUNCTION ESCOLHE_FILHOS{                //INTERROMPE O LOOP do programa:navega INTERATIVAMENTE pelas partes, modulos e acoes
  	local NOME_DA_FUNC is "ESCOLHE_FILHOS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
    local opc_term      is "".
    local i             is 0.
    
    local INFO_PEGAR    is 0.
    
    local PEGAR_PARTE   is 1.
    local PEGAR_MODULO  is 2.
    local PEGAR_EVENT   is 3.
    local PEGAR_FIELD   is 4.
    local PEGAR_ACTION  is 5.
    
    local partLEVEL_DEEP    is -1.
   
    local MODULO_ATUAL  is 0.
	//local CARACTERES_PERMITIDOS_parts is "abcde1234567890".//+-<>".//lista de caracteres permitidos em um comando:
  	local CARACTERES_PERMITIDOS_parts is "0123456789abcdefghijkl".//+-<>".//lista de caracteres permitidos em um comando:
    
    set MENU_esperando_valor_opcao_num_de_MENU to True.//DESativa menu    
    
    local PARTE_ATUAL to SHIP:ROOTPART.
    //print "s=sair o=filhos m=modules p=pai [0..9a..l]=muda parte x=fields y=event z=action".
    
	
    print_stat(tlogv, "(s) ou ("+CHAR_MENU_OPC_volta_menu_inic +") para sair", contador_log).
    print_stat(tlogv, "(p)"+PARTE_ATUAL:name +":f:[" +PARTE_ATUAL:children:LENGTH+"]", contador_log).
    until (opc_term="s") or (opc_term=CHAR_MENU_OPC_volta_menu_inic){//FAZER MUDAR O SIMBOLO - PARA VOLTAR NA ARVORE
    
        //print ": ------- : PARTE ATUAL: " + PARTE_ATUAL:name +":children:[" +PARTE_ATUAL:children:LENGTH+"]  x=fil y=eve z=act ".
        set opc_term to terminal:input:getchar().
        
        if      (opc_term = "o") {//usar elsif nisso tudo
            PRINT_FILHOS(PARTE_ATUAL,partLEVEL_DEEP,False).
            set INFO_PEGAR to PEGAR_PARTE.
        }
        else if (opc_term = "p") {
            if PARTE_ATUAL:HASPARENT {
                //print "MUDANDO PARA PAI: "+ PARTE_ATUAL:PARENT:NAME.
                print_stat(tinfoline, "MUDANDO PARA PAI: "+ PARTE_ATUAL:PARENT:NAME, contador_infoline).
                
                set PARTE_ATUAL to PARTE_ATUAL:PARENT.            
                print_stat(tlogv, "(p)"+PARTE_ATUAL:name +":f:[" +PARTE_ATUAL:children:LENGTH+"]", contador_log).
                set partLEVEL_DEEP to partLEVEL_DEEP - 1.
            }
            else{ 
                //print "nao tem pai".   
                print_stat(tinfoline, "nao tem pai", contador_infoline).
                }.
            set INFO_PEGAR to PEGAR_PARTE.
        }
        else if (opc_term = "m") {
            PRINT_MODULES(PARTE_ATUAL).
            //print "MODULOS: " + PARTE_ATUAL:MODULES.//vai imprimir uma lista
            set INFO_PEGAR to PEGAR_MODULO.
        }
        //else if (MODULO_ATUAL <> 0){ //testa por x,z, z no MODULO_ATUAL
            else if      (opc_term = "x") and (MODULO_ATUAL <> 0) {
                //print "FIELD NAMES:" + MODULO_ATUAL:ALLFIELDNAMES.
                PRINT_MODULES_CAPABILITIES(MODULO_ATUAL, "FIELD").
                set INFO_PEGAR to PEGAR_FIELD.
            }
            else if      (opc_term = "y") and (MODULO_ATUAL <> 0){
                //print "EVENT NAMES:" + MODULO_ATUAL:ALLEVENTNAMES.
                PRINT_MODULES_CAPABILITIES(MODULO_ATUAL, "EVENT").
                set INFO_PEGAR to PEGAR_EVENT.
            }
            else if      (opc_term = "z") and (MODULO_ATUAL <> 0){
                //print "ACTION NAMES:" + MODULO_ATUAL:ALLACTIONNAMES.
                PRINT_MODULES_CAPABILITIES(MODULO_ATUAL, "ACTION").
                set INFO_PEGAR to PEGAR_ACTION.
            }
        
        else if (( CARACTERES_PERMITIDOS_parts:find( opc_term ) > (- 1)) ){//if (TESTA_SE_STR_EH_NUMERO(opc_term) or ( CARACTERES_PERMITIDOS_parts:find( opc_term ) > (- 1)) ){//sel filho part
                set i to CARACTERES_PERMITIDOS_parts:find( opc_term ).// + 10.//vai comecar depois do 9 (0+10=10)
                //print CARACTERES_PERMITIDOS_parts:find( opc_term ).//que coisa continua imprimindo
            //debug(NOME_DA_FUNC, "posicao escolhida:" + i).
            if      (INFO_PEGAR = PEGAR_PARTE){
                if (i < PARTE_ATUAL:children:LENGTH){
                        set PARTE_ATUAL to PARTE_ATUAL:CHILDREN[i].
                        print_stat(tlogv, "(p)" + PARTE_ATUAL:name +":f:[" +PARTE_ATUAL:children:LENGTH+"]", contador_log).
                        set partLEVEL_DEEP to partLEVEL_DEEP + 1.
                } else {print_stat(tinfoline, "fora da lista partes!", contador_infoline).}.
            }
            else if (INFO_PEGAR = PEGAR_MODULO){
                if (i < PARTE_ATUAL:MODULES:LENGTH){
                    //print PARTE_ATUAL:MODULES[i].//print "NAME: "+MODULO_ATUAL:NAME. //retorna o mesmo
                    set MODULO_ATUAL to PARTE_ATUAL:GETMODULE(PARTE_ATUAL:MODULES[i]).            
                    print_stat(tlogv, "(m)"+MODULO_ATUAL:name, contador_log).
                        set contador_list to (contador_list -1).
                    print_stat(tlista, "x=fie y=eve z=act [0.kl]=mod", contador_list).
                    
                    //print "MODULO SELECIONADO: "+MODULO_ATUAL.//imprime o resumo de fields, events e actions
                    //PRINT_MODULES_CAPABILITIES(MODULO_ATUAL, "capabilities")."allfields"
                    
                     // print "USE GETFIELD AND SETFIELD: "+ MODULO_ATUAL:ALLFIELDS.
                     // print "USE DOEVENT: "+ MODULO_ATUAL:ALLEVENTS.
                     // print "USE DOACTION: "+ MODULO_ATUAL:ALLACTIONS.
                    
                }
                else {print_stat(tinfoline, "fora da lista modulos!", contador_infoline). }.
            }
            else if (INFO_PEGAR = PEGAR_EVENT){
                if (i < MODULO_ATUAL:ALLEVENTNAMES:LENGTH){                    
                    print_stat(tlog, "(e)trigger event:" + MODULO_ATUAL:ALLEVENTNAMES[i], contador_log).
                    MODULO_ATUAL:DOEVENT( MODULO_ATUAL:ALLEVENTNAMES[i] ).
                } else {print_stat(tinfoline, "fora da lista!", contador_infoline).}.
            }
            else if (INFO_PEGAR = PEGAR_FIELD){
                if (i < MODULO_ATUAL:ALLFIELDNAMES:LENGTH){
                    print_stat(tlog, "(f)get/set field:" + MODULO_ATUAL:ALLFIELDNAMES[i], contador_log).
                    //print "get/set field  : " + MODULO_ATUAL:ALLFIELDNAMES[i].
                    local FIELD_Q_NAO_SE_SABE_O_TIPO is MODULO_ATUAL:GETFIELD( MODULO_ATUAL:ALLFIELDNAMES[i] ).
                    print_stat(tlista, "tipo do field: " + FIELD_Q_NAO_SE_SABE_O_TIPO:typename, contador_list).
                    print_stat(tlista, "valor atual  : " + FIELD_Q_NAO_SE_SABE_O_TIPO, contador_list).
                    
                    if ( (DETERMINA_CAPACIDADES_MODULES(MODULO_ATUAL:ALLFIELDS[i]) = "settable") ){//(get-only) (settable)
                        print_stat(tinfoline, "DIGITE NOVO VALOR (ou BACKSPACE para cancelar):", contador_infoline).
                        local  valor_field to get_terminal_str_e_enter(FIELD_Q_NAO_SE_SABE_O_TIPO:typename).
                        print_stat(tlista, "valor informado:" + valor_field, contador_list).
                        if ( valor_field <> "CANCELADA_GET_STR") {
                            if ((valor_field:typename = FIELD_Q_NAO_SE_SABE_O_TIPO:typename)){
                                MODULO_ATUAL:SETFIELD(MODULO_ATUAL:ALLFIELDNAMES[i],valor_field).
                            }
                            else{ print_stat(tinfoline, "tipo incompativel! :" + valor_field:typename, contador_infoline). }.
                        }
                        else{ print_stat(tinfoline, "CANCELADO!", contador_infoline).   }.
                    }
                    else{ print_stat(tinfoline, "somente leitura.", contador_infoline). }.
                } else { print_stat(tinfoline, "fora da lista!", contador_infoline).    }.
                
            }
            else if (INFO_PEGAR = PEGAR_ACTION){
                if (i < MODULO_ATUAL:ALLACTIONNAMES:LENGTH){                    
                    print_stat(tlog, "(a)DOACTION (on/off):" + MODULO_ATUAL:ALLACTIONNAMES[i], contador_log).
                    
                    //print MODULO_ATUAL:DOACTION( MODULO_ATUAL:ALLACTIONNAMES[i], True ).
                    // DOACTION(name,bool) 	Activate action by name with True or False
                    
                    print_stat(tinfoline, "DIGITE NOVO VALOR ON/OFF(ou BACKSPACE para cancelar):", contador_infoline).
                    local  valor_DOACTION to get_terminal_str_e_enter("Boolean").
                    print_stat(tlista, "valor informado:" + valor_DOACTION, contador_list).

                    if ( valor_DOACTION <> "CANCELADA_GET_STR") {
                        if ((valor_DOACTION:typename = "Boolean")){
                            MODULO_ATUAL:DOACTION(MODULO_ATUAL:ALLACTIONNAMES[i],valor_DOACTION).    
                        }
                        else{ print_stat(tinfoline, "tipo incompativel! :"+valor_DOACTION:typename, contador_infoline). }.
                    }
                    else{ print_stat(tinfoline, "CANCELADO!", contador_infoline).   }.
                    
                } else {print_stat(tinfoline, "fora da lista!", contador_infoline).}.
            }.
            
        }
        else {print_stat(tinfoline, "opcao invalida!", contador_infoline). }.
    }.
        
    set MENU_esperando_valor_opcao_num_de_MENU to False.//ativa menu
    MOSTRA_MENU(MENU_NAVE).
    debug(NOME_DA_FUNC, "saiu de :" + NOME_DA_FUNC).
    print_stat(tinfoline, "saiu de :" + NOME_DA_FUNC, contador_infoline).
}.

// |                    |....................-------------------                                         |
// |                    |                    [1] [0]asasmodule1-2 [1]f     log do processo:              |
// |                    |                    [1] [1]batteryBankLarge [1]f  (p)probeStackLarge:f:[2]      |
// |                    |********************/                            |                              |
// |                    |PROXIMO:            /                            |                              |

// |                 |                    /                              |log do processo:               |
// |                 |                    /                              |log do processo:               |
// |                 |********************/                              |(p)probeStackLarge:f:[2]       |
// |                 |PROcommMSGSShip:0                                  |log do processo:               |
// |

FUNCTION EI_haschildren_TEST{
    //
    //https://ksp-kos.github.io/KOS/commands/parts.html?highlight=children
    //Querying a vessel’s parts
    set hops to inc(hops).

    SET MyPartList to SHIP:PARTSDUBBED("something").

    //These are other ways to get parts that are more specific about what exact nomenclature system is being used:

    SET MyPartList to SHIP:PARTSTAGGED("something"). // only gets parts with Part:TAG = "something".
    SET MyPartList to SHIP:PARTSTITLED("something"). // only gets parts with Part:TITLE = "something".
    SET MyPartList to SHIP:PARTSNAMED("something"). // only gets parts with Part:NAME = "something".

    //This gets all the PartModules on a ship that have the same module name:

    SET MyModList to SHIP:MODULESNAMED("something").

    //This gets all the parts that have been defined to have some sort of activity occur from a particular action group:

    SET MyPartList to SHIP:PARTSINGROUP( AG1 ). // all the parts in action group 1.

    //This gets all the modules that have been defined to have some sort of activity occur from a particular action group:

    SET MyModList to SHIP:MODULESINGROUP( AG1 ). // all the parts in action group 1.

//    You could keep walking down the tree this way, or go upward with PARENT and HASPARENT:

//    TODO - NEED TO MAKE A GOOD EXAMPLE OF WALKING THE PARTS TREE HERE WITH RECURSION ONCE THE SYNTAX IS NAILED DOWN FOR THAT.

    IF thisPart:HASPARENT {
		print "This part's parent part is "+ thisPart:PARENT:NAME.
		print_stat(tfile, "This part's parent part is "+ thisPart:PARENT:NAME, contador_list).
	  
    }.
}.

FUNCTION PARTS_DA_NAVE_ACTIONS{         //loop pelas partes da NAVE EM ACTION GROUPS: ---------------------------------------------
    //
  	local NOME_DA_FUNC is "PARTS_DA_NAVE_ACTIONS".
    trace(NOME_DA_FUNC).
     set hops to inc(hops).
   
    local LIST_AG is List().
    
    //local PLIST_AG1 is .

	//ERRO: mistake in documentation for vessel suffixes PARTSINGROUP and MODULESINGROUP #2289
	//https://github.com/KSP-KOS/KOS/issues/2289	
	
	//novo teste
    //list SHIP:MODULESINGROUP( AG1 ) in PLIST_AG1.

	
	LOCAL contador_MO is -1.
	print_stat(tfile, "====================   LOG INICIADO PELA FUNÇÃO : "+NOME_DA_FUNC+" : modulos e parts em AG[1..10] ================", contador_MO).
	

    set LIST_AG to SHIP:MODULESINGROUP("AG1").
    //print "-------------modulos em AG1: " + LIST_AG.
	print_stat(tfile, "-------------modulos em AG1: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
		
	}	
    set LIST_AG to SHIP:PARTSINGROUP("AG1").
    //print "-------------partes em AG1: " + LIST_AG.
	print_stat(tfile, "-------------partes em AG1: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
	}	
	
    set LIST_AG to SHIP:MODULESINGROUP("AG2").
    //print "-------------modulos em AG2: " + LIST_AG.
	print_stat(tfile, "-------------modulos em AG2: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
	}	
    set LIST_AG to SHIP:PARTSINGROUP("AG2").
    //print "-------------partes em AG2: " + LIST_AG.
	print_stat(tfile, "-------------partes em AG2: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
	}	
	
    set LIST_AG to SHIP:MODULESINGROUP("AG3").
    //print "-------------modulos em AG3: " + LIST_AG.
	print_stat(tfile, "-------------modulos em AG3: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
	}	
    set LIST_AG to SHIP:PARTSINGROUP("AG3").
    //print "-------------partes em AG3: " + LIST_AG.
	print_stat(tfile, "-------------partes em AG3: " + LIST_AG, contador_MO).
	FOR AG_MOD IN LIST_AG {
		//PRINT AG_MOD:NAME.
		print_stat(tfile, AG_MOD:NAME, contador_MO).
	}	
	
	print NOME_DA_FUNC + "INFORMACOES ENVIADAS PARA ARQUIVO LOG!".
	print_stat(tfile, "====================   LOG TERMINADO PELA FUNÇÃO : "+NOME_DA_FUNC+" : modulos e parts em AG[1..10] ================", contador_MO).

    
}.

FUNCTION PEGAtodosacoesfieldsevents{
    set hops to inc(hops).
    //
    if (1=0){
// What a PartModule means to a kOS script

// There are 3 ways that a kOS script may interface with a PartModule.
// A KSPField is a single variable that a PartModule attaches to a part. Some of the KSPFields are also displayed in the RMB context menu of a part. It has a current value, and if the field has had a “tweakable” GUI interface attached to it, then it’s also a settable field by the user manipulating the field in the context menu. In kOS, you can only access those KSPFields that are currently visible on the RMB context menu. We, the developers of kOS, instituted this rule out of respect for the developers of other mods and the stock KSP game. If they didn’t allow the user to see or manipulate the variable directly in the GUI, then we shouldn’t allow it to be manipulated or seen by a kOS script either.

// KSPFields are read or manipulated by the following suffixes of PartModule

    // :GETFIELD(“name of field”).
    // :SETFIELD(“name of field”, new_value_for_field).

// Note, that these are suffixes of the partmodule and NOT suffixes of the Part itself. This is because two different PartModule’s on the same Part might have used the same field name as each other, and it’s important to keep them separate.
// KSPEvents

// A KSPEvent, just like a KSPField, is a thing that a PartModule can put on the RMB context menu for a part. The difference is that a KSPEvent does not actually HAVE a value. It’s not a variable. Rather it’s just a button with a label next to it. When you press the button, it causes some sort of software inside the PartModule to run. An example of this is the “undock node” button you see on many of the docking ports.

// Difference between a KSPEvent and a boolean KSPField: If you see a label next to a button in the RMB context menu, it might be a KSPEvent, OR it might be a boolean KSPField variable which is editable with a tweakable GUI. They look exactly the same in the user interface. To tell the difference, you need to look at what happens when you click the button. If clicking the button causes the button to depress inward and stay pressed in until you click it again, then this is a boolean value KSPField. If clicking the button pops the button in and then it pops out again right away, then this is a KSPEvent instead.

// KSPEvents are manipulated by the following suffix of PartModule

    // :DOEVENT(“name of event”).

// This causes the event to execute once.
// KSPActions:

// A KSPAction is a bit different from a KSPField or KSPEvent. A KSPAction is like a KSPEvent in that it causes some software inside the PartModule to be run. But it doesn’t work via the RMB context menu for the part. Instead KSPAction’s are those things you see being made avaiable to you as options you can assign into an Action Group in the VAB or SPH. When you have the action group editor tab enabled in the VAB or SPH, and then click on a part, that part asks all of its PartModules if they have any KSPActions they’d like to provide access to, and gathers all those answers and lists them in the user interface for you to select from and assign to the action group.

// kOS now allows you to access any of those actions without necessarily having had to assign them to any action groups if you didn’t want to.

// KSPActions are manipulated by the following suffix of PartModule

    // :DOACTION(“name of action”, new_boolan_value).

// The name of the action is the name you see in the action group editor interface, and the new boolean value is either True or False. Unlike KSPEvents, a KSPAction has two states, true and false. When you toggle the brakes, for example, they go from on to off, or from off to on. When you call :DOACTION, you are specifying if the KSPAction should behave as if you have just toggled the group on, or just toggled the group off. But instead of actually toggling an action group - you are just telling the single PartModule on a single Part to perform the same behavior it would have performed had that action been assigned to an action group. You don’t actually have to assign the action to an action group for this to work.
// Exploring what’s there to find Field/Event/Action Names:

// Okay, so you understand all that, but you’re still thinking “but how do I KNOW what the names of part modules are, or what the names of the fields on them are? I didn’t write all that C# source code for all the modules.”

// There are some additional suffixes that are designed to help you explore what’s available so you can learn the answers to these questions. Also, some of the questions can be answered by other means:
// What PartModules are there on a part?

// To answer this question you can do one of two things:

// A: Use the part.cfg file All parts in KSP come with a part.cfg file defining them, both for modded parts and stock parts. If you look at this file, it will contain sections looking something like this:

// Example snippet from a Part.cfg file:
// MODULE
// {
    // name = ModuleCommand

// That would tell you that this part has a PartModule on it called ModuleCommand. there can be multiple such modules per part. But it doesn’t let you know about PartModules that get added afterward during runtime, by such things as the ModuleManager mod.

// B: Use the :MODULES suffix of Part: If you have a handle on any part in kOS, you can print out the value of :MODULES and it will tell you the string names of all the modules on the part. For example:
// Do that, and the file MODLIST should now contain a verbose dump of all the module names of all the parts on your ship. You can get any of the modules now by using Part:GETMODULE(“module name”).

    }.

	local MODLIST is "0:/todosmodulos.log".
	local NAMELIST is "0:/todosacoesfieldsevents.log".

	FOR P IN SHIP:PARTS {
		LOG (" -------------------------- PART: [ "+P:NAME+" ] --------------------------------------------- ") TO MODLIST.
		LOG (" -------------------------- PART: [ "+P:NAME+" ] --------------------------------------------- ") TO NAMELIST.
		LOG ("MODULES FOR PART NAMED " + P:NAME) TO MODLIST.
		LOG P:MODULES TO MODLIST.
  
		for MOD in P:MODULES{
			// What are the names of the stuff that a PartModule can do?

			// These three suffixes tell you everything a part module can do:

			local M TO P:GETMODULE(MOD).
			
			//print MOD:suffixnames.
			//print M:typename.// MOD DA TUDO STRING > M DA TUDO PARTMODULE
			//print MOD:typename.
			LOG (" -------------------------- MODULE: [ "+M:NAME+" ] --------------------------------------------- ") TO MODLIST.
			LOG (" -------------------------- MODULE: [ "+M:NAME+" ] --------------------------------------------- ") TO NAMELIST.
			print MOD.
              
			if MOD:istype("name"){
				print "istype(name)".
			}.
			if MOD:hassuffix("name"){
				print "hassuffix(name)".
			}.
			if M:hassuffix("NAME"){
				//
				//print "hassuffix(NAME)".
				LOG ("These are all the things that I can currently USE GETFIELD AND SETFIELD ON IN " + M:NAME + ":") TO NAMELIST.
				LOG M:ALLFIELDS TO NAMELIST.
				LOG ("These are all the things that I can currently USE DOEVENT ON IN " +  M:NAME + ":") TO NAMELIST.
				LOG M:ALLEVENTS TO NAMELIST.
				LOG ("These are all the things that I can currently USE DOACTION ON IN " +  M:NAME + ":") TO NAMELIST.
				LOG M:ALLACTIONS TO NAMELIST.
			}.

			// After that, the file NAMELIST would contain a dump of all the fields on this part module that you can use.
			WAIT 0.2.
		}.
  
	}.

	// BE WARNED! Names are able to dynamically change!

	// Some PartModules are written to change the name of a field when something happens in the game. For example, you might find that after you’ve done this:

	// SomeModule:DOEVENT("Activate").

	// That this doesn’t work anymore after that, and the “Activate” event now causes an error.

	// And the reason is that the PartModule chose to change the label on the event. It changed to the word “Deactivate” now. kOS can no longer trigger an event called “Activate” because that’s no longer its name.

	// Be on the lookout for cases like this. Experiment with how the context menu is being manipulated and keep in mind that the list of strings you got the last time you exectued :ALLFIELDS a few minutes ago might not be the same list you’d get if you ran it now, because the PartModule has changed what is being shown on the menu.

}.

FUNCTION PRINT_MODULE_FIELDS{
    set hops to inc(hops).
    //https://ksp-kos.github.io/KOS/structures/vessels/partmodule.html
   // structure PartModule
    // Members¶ Suffix 	Type 	Description
    // NAME 	string 	Name of this part module
    // PART 	Part 	Part attached to
    
    // ALLFIELDS 	    List of strings 	Accessible fields
    // ALLFIELDNAMES 	List of strings 	Accessible fields (name only)
    // ALLEVENTS 	    List of strings 	Triggerable events
    // ALLEVENTNAMES 	List of strings 	Triggerable event names
    // ALLACTIONS 	    List of strings 	Triggerable actions
    // ALLACTIONNAMES 	List of strings 	Triggerable event names
    
    // GETFIELD(name) 	  	Get value of a field by name
    // SETFIELD(name,value) Set value of a field by name
    // DOEVENT(name) 	  	Trigger an event button
    // DOACTION(name,bool) 	Activate action by name with True or False
    
    // HASFIELD(name) 	Boolean 	Check if field exists
    // HASEVENT(name) 	Boolean 	Check if event exists
    // HASACTION(name) 	Boolean 	Check if action exists  
}.

FUNCTION DETERMINA_CAPACIDADES_MODULES{
    parameter STR_CAPACIDADE_MODULO.
    set hops to inc(hops).
    local CAPACIDADE_MODULO is "".
    //
    if (STR_CAPACIDADE_MODULO:find("get-only") > (- 1)) {
        set CAPACIDADE_MODULO to "get-only".
    }.
    if (STR_CAPACIDADE_MODULO:find("settable") > (- 1)) {
        set CAPACIDADE_MODULO to "settable".
    }.
    if (STR_CAPACIDADE_MODULO:find("get-only") > (- 1)) {
        set CAPACIDADE_MODULO to "callable".
    }.
    
    
    return CAPACIDADE_MODULO.
    
    // [0] = "(get-only) fluxo de combustível, is Single"                                                                              |                     /                           |                    |
// [1] = "(get-only) empuxo, is Single"                                                                                            |                     /                           |                    |
// [2] = "(get-only) impulso específico, is Single"                                                                                |                     /                           |                    |
// [3] = "(get-only) estado, is String"                                                                                            |                     /                           |                    |
// [4] = "(settable) limitador de aceleração, is Single"                                                                           |                     /                           |                    |
// [5] = "(callable) ativar motor, is KSPEvent"                                                                                    |                     /                           |                    |
// [6] = "(callable) alternar motor, is KSPAction"                                                                                 |                     /                           |                    |
// [7] = "(callable) desligar motor, is KSPAction"                                                                                 |                     /                           |                    |
// [8] = "(callable) ativar motor, is KSPAction"     
}.
//------- FIM PARTS E MODULES  ---------------------------------------------------------------------------------------------------

//eu nem sei mais onde termina


