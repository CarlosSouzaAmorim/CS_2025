@LAZYGLOBAL OFF.
//c3_ship.ks
// 15 funcoes: 516 linhas
//recompila

//uses: BLAH25555
//runoncepath("c3_init_vars").

// ====    FUNCOES PARA CONTROLE DA NAVE ============================================================================

// FUNCOES PARA MANOBRAS NA NAVE ====================================================================================


function show_STAGE_INFO{		//mostra propriedades do STAGE atual: RESOURCES: selecionada
	parameter nome_res_mostrar 	is "all".
	parameter propriedade		is "all".//all, AMOUNT, DENSITY, CAPACITY, TOGGLEABLE, ENABLED
	parameter mostrar_no_log	is True.
	parameter local_da_res		is "STAGE".//STAGE, SHIP
	
	local NOME_DA_FUNC to "show_STAGE_INFO".
	
	local LISTA_DE_RESOURCES to list().
    set hops to inc(hops).
				//EU ADD
		if (nome_res_mostrar = "all"){
			if (mostrar_no_log){
				PRINT "debug: STAGE_INFO: lista de RESOURCES: on [" + local_da_res + "]".
				if (local_da_res = "STAGE"){
					PRINT STAGE:RESOURCES.
					print "Combust.Liq.Total:" + STAGE:LIQUIDFUEL.
				}
				if (local_da_res = "SHIP"){
					PRINT ship:RESOURCES.
					print "Combust.Liq.Total:" + ship:LIQUIDFUEL.					
				}
			}.
			return -1.
		}.
		
		if (local_da_res = "SHIP"){
			set LISTA_DE_RESOURCES to SHIP:RESOURCES.
			
		}
		else if (local_da_res = "STAGE"){
			set LISTA_DE_RESOURCES to STAGE:RESOURCES.
			
		}
		else{
			debug(NOME_DA_FUNC, "ERRO: LOCAL DAS RESOURCES NAO ESPECIFICADO... PADRAO:"+ local_da_res).

		}
		
		//debug(NOME_DA_FUNC, "RES NO "+local_da_res+" =================================================================").
		//debug(NOME_DA_FUNC, LISTA_DE_RESOURCES).
		
		FOR res_disp IN LISTA_DE_RESOURCES
		//FOR res_disp IN STAGE:RESOURCES
		{
				if (nome_res_mostrar = res_disp:NAME)
				{
					if (mostrar_no_log){
						if (propriedade = "all"){
							PRINT "RES:name:   " + res_disp:NAME.
							PRINT "RES:amount: " + res_disp:AMOUNT.				
							//
							return res_disp:AMOUNT.
						}.
					}.
					if (propriedade = "CAPACITY")		{return res_disp:CAPACITY.}
					else if (propriedade = "DENSITY")	{return res_disp:DENSITY.}
					else if (propriedade = "TOGGLEABLE"){return res_disp:TOGGLEABLE.}//BOOLEAN
					else if (propriedade = "ENABLED")	{return res_disp:ENABLED.}//BOOLEAN
					else 	{return res_disp:AMOUNT.}.//propriedade = "AMOUNT"
					
				}.
		}
		
		DEBUG(NOME_DA_FUNC, "ERRO: nao encontrou propriedades da RES: [" + nome_res_mostrar + "]").
		return -1.
				//FIM EU ADD

		if (1=0){//help resources
			
		// Oxidizer
// LiquidFuel
// SolidFuel
// MonoPropellant
// XenonGas
// ElectricCharge
// IntakeAir
// EVA Propellant
// Ore
// Ablator

		// NAME 	string 	Resource name
// AMOUNT 	scalar 	Amount of this resource left
// DENSITY 	scalar 	Density of this resource
// CAPACITY 	scalar 	Maximum amount of this resource
// TOGGLEABLE 	Boolean 	Can this tank be removed from the fuel flow
// ENABLED 	Boolean 	Is this tank currently in the fuel flow					

		}
				
				
}.
	
FUNCTION bem_simples_STAGING{	//ESPERA ENGINE:FLAMEOUT: A very simple auto-stager using :READY
	//Staging Example
    //ATENCAO SOH VALE DEPOIS QUE JA FOI DADO UM STAGE: DAI ESPERA ALGUM MOTOR FLAMEOUT
	//vai tentar STAGE enquanto tiver algum motor!
	//PRECISA DE UM LOOP FORA DISSO
	//CRIAR UM TRIGGER
	
	local NOME_DA_FUNC is "bem_simples_STAGING".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	
	local mysterrrr is HEADING(90,90)..
	local elist to list().
	LOCK STEERING TO mysterrrr.//R(0,0,-90) + HEADING(90,90).//up
	
    LIST ENGINES IN elist.
	if (debug_controle_nave){	
		debug(NOME_DA_FUNC,"ENGINES LIST:").
		print elist. //engineLargeSkipper , solidBooster1-1
		}.

	stage.

    show_STAGE_INFO().
				show_STAGE_INFO("LiquidFuel").
				show_STAGE_INFO("SolidFuel").
				//show_STAGE_INFO("ElectricCharge").
	if (debug_controle_nave){	debug(NOME_DA_FUNC,"precisa estar com algum motor acionado.").}.

	
    UNTIL false 
	{
        //PRINT "debug: SIMPLE_STAGE: Stage: " + STAGE:NUMBER.// AT (0,0).
		set contador_verbose_stage_simple to contador_verbose_stage_simple + 1.
        
        //print_stat(tLOGv, msg,                        count_print,    reprint, debug, num_verb).
   		print_stat(tLOGv,"simple Stage: " + STAGE:NUMBER , contador_LOG, False, False, contador_verbose_stage_simple).
		
		set mysterrrr to HEADING(90,90).
        FOR e IN elist 
		{
            IF e:FLAMEOUT 
			{
				print "debug: SIMPLE_STAGE: engine: " + e:NAME + " flameout!".
				if (debug_controle_nave){	debug(NOME_DA_FUNC,"debugar.").}.
                STAGE.
                PRINT "debug: SIMPLE_STAGE: STAGING!".// AT (0,0).
				if (debug_controle_nave){	debug(NOME_DA_FUNC,"debugar.").}.
				
                UNTIL STAGE:READY 
				{
                    WAIT 0.
                }
				show_STAGE_INFO("LiquidFuel").
				show_STAGE_INFO("SolidFuel").
				//show_STAGE_INFO("ElectricCharge").
				

                LIST ENGINES IN elist.
				print elist.
				show_STAGE_INFO.
				print "Debug: SIMPLE_STAGE: Esperando novo motor FLAMEOUT...".
				if (debug_controle_nave){	debug(NOME_DA_FUNC,"debugar.").}.
                //CLEARSCREEN.
                BREAK.
            }
        }
    }
	
	// Debug: SIMPLE_STAGE: ENGINES LIST:                                     |                     /   |simple Stage: 3[9]   |
	// LIST of 5 items:                                                       |                     /   |simple Stage: 3[10]  |
	// [0] = "PART(engineLargeSkipper,uid=1768210432)"                        |                     /   |simple Stage: 3[11]  |
	// [1] = "PART(solidBooster1-1,uid=416038912)"                            |                     /   |simple Stage: 3[12]  |
	// [2] = "PART(solidBooster1-1,uid=3785654272)"                           |                     /   |simple Stage: 3[13]  |
	// [3] = "PART(solidBooster1-1,uid=176701440)"                            |                     /   |simple Stage: 3[14]  |
	// [4] = "PART(solidBooster1-1,uid=3334635520)"                           |                     /   |simple Stage: 3[15]  |
	// debug: STAGE_INFO: lista de RESOURCES:                                 |                     /   |simple Stage: 3[16]  |
	// LIST of 10 items:                                                      |                     /   |simple Stage: 3[17]  |
	// [0] = "ACTIVERESOURCE(LiquidFuel,2880,2880)"                           |                     /   |simple Stage: 3[18]  |
	// [1] = "ACTIVERESOURCE(Oxidizer,3520,3520)"                             |                     /   |simple Stage: 3[19]  |
	// [2] = "ACTIVERESOURCE(SolidFuel,3280,3280)"                            |                     /   |simple Stage: 3[20]  |
	// [3] = "ACTIVERESOURCE(MonoPropellant,0,0)"                             |                     /   |simple Stage: 3[21]  |
	// [4] = "ACTIVERESOURCE(XenonGas,0,0)"                                   |                     /   |simple Stage: 3[22]  |
	// [5] = "ACTIVERESOURCE(ElectricCharge,21.6211017033088,210.2)"          |...................../   |simple Stage: 3[23]  |
	// [6] = "ACTIVERESOURCE(IntakeAir,0,0)"                                  |COMANDOS BASICOS:    /   |simple Stage: 3[24]  |
	// [7] = "ACTIVERESOURCE(EVA Propellant,0,0)"                             |1 . IPU              /   |simple Stage: 3[25]  |
	// [8] = "ACTIVERESOURCE(Ore,0,0)"                                        |2 . TELNET           /   |simple Stage: 3[26]  |
	// [9] = "ACTIVERESOURCE(Ablator,0,0)"                                    |3 . LIFTOFF          /   |simple Stage: 3[27]  |
	// Debug: SIMPLE_STAGE: precisa estar com algum motor acionado.           |4 . ABORT            /   |simple Stage: 3[28]  |
	// Program aborted.                                                       |5 . TRUE             /   |simple Stage: 3[29]  |	
}.

FUNCTION check_SHIP{			//Testa: Os estagions máximos. >> esta sendo chamada apenas em MOSTRA_MENU(MENU_OBJETIVOS)
	// > 
	
	local NOME_DA_FUNC is "check_SHIP".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	
	if (debug_controle_nave)//global ok
	{
		debug(NOME_DA_FUNC, "DEBuG: check_SHIP: test.", debug_controle_nave).
		debug(NOME_DA_FUNC, "DEBuG: check_SHIP: stage_COUNT:" + stage_COUNT, debug_controle_nave).
		debug(NOME_DA_FUNC, "DEBuG: check_SHIP: stage:number:" + STAGE:NUMBER, debug_controle_nave).
		debug(NOME_DA_FUNC, "DEBuG: check_SHIP: OBJETIVOS_STAG_MAX_ASC:" + OBJETIVOS_STAG_MAX_ASC, debug_controle_nave).
		//debug(NOME_DA_FUNC, , debug_controle_nave).
	}.
	
	if ( stage:number > OBJETIVOS_STAG_MAX_ASC){
		set STAGE_MAX_ATINGIDO to True.
		print_stat(tlog,"Stage warning!",contador_log).
		print_stat(tlog,":["+OBJETIVOS_STAG_MAX_ASC+"]de[" +stage:number+"]",contador_log).	
		return false.
	}
	else{ return true.}.	
}.

FUNCTION STAGE_BY_FLAMEOUT{     //ESPERA ENGINE:FLAMEOUT
	parameter debug_level_trace_flameout is False.
	parameter debug_flameout is False.
    local Flameout_detectado is False.
	
	local NOME_DA_FUNC is "STAGE_BY_FLAMEOUT".
	if (debug_level_trace_flameout){print "trace: " + NOME_DA_FUNC.	}.
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
	local elist to list().
    LIST ENGINES IN elist.
	if (debug_flameout){	
		debug(NOME_DA_FUNC,"ENGINES LIST:").
		print elist. //engineLargeSkipper , solidBooster1-1
	}.

	 FOR e IN elist 
		{
            IF e:FLAMEOUT 
			{
                WAIT 1.
				//if (debug_flameout){	debug(NOME_DA_FUNC,"engine: " + e:NAME + " flameout!").}.
				debug(NOME_DA_FUNC,"engine: " + e:NAME + " flameout!", debug_flameout).
				
                STAGE.
              
				//if (debug_flameout){	debug(NOME_DA_FUNC,"STAGING!").}.
				debug(NOME_DA_FUNC,"STAGING!", debug_flameout).				
				
                UNTIL STAGE:READY 
				{
                    WAIT 0.
                }.

                LIST ENGINES IN elist.
				if (debug_flameout){
					debug(NOME_DA_FUNC,"NEW ENGINES LIST:").
					print elist.
					debug(NOME_DA_FUNC,"Esperando novo motor FLAMEOUT...").}.

				set Flameout_detectado to True.
                BREAK.
            }.
        }.
	return Flameout_detectado.
}.

FUNCTION STAGE_BY_MAXTHRUST{		//Testa : WHEN MAXTHRUST = 0 //LOCK TEST > trigger
	local NOME_DA_FUNC is "STAGE_BY_MAXTHRUST".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	//This is a trigger that constantly checks to see if our thrust is zero.
	//If it is, it will attempt to stage and then return to where the script
	//left off. The PRESERVE keyword keeps the trigger active even after it
	//has been triggered.
	
	//ISSO VAI ACIONAR REPETIDAMENTE ENQUANTO O MAXTHRUST FOR 0 ZERO:	
	WHEN MAXTHRUST = 0 THEN 
	{
        WAIT 0.01.

		set stage_COUNT to stage_COUNT + 1.//fazer usar o count do STAGE MESMO
		if (debug_controle_nave)//global ok
		{
			PRINT "DEBuG: controle nave: STAGIANDO HAHAHUE.".
			print "DEBuG: controle nave: stage_COUNT:" + stage_COUNT.
			//print SHIP:STAGE.
			print "DEBuG: controle nave: stage:number:" + STAGE:NUMBER.
		}.
		//inc(stage_COUNT).
		if (stage_COUNT > OBJETIVOS_STAG_MAX_ASC)//both crescentes
		{
			print_stat(tlog,"Staging LIMIT! :["+stage_COUNT+"]",contador_log).
			RETURN False.
		}
		else 
		{
			print_stat(tlog,"MTHRST=0: Staging:["+stage_COUNT+"]",contador_log).
			STAGE.
			PRESERVE. //será que o PRESERVE E O RETURN true tem o mesmo efeito TESTAR
		}.
	}.	
}.

FUNCTION STAGE_BY_ADVANCED_STAGING_NU{//CHECK FOR LaunchClamp
    //http://ksp-kos.github.io/KOS_DOC/structures/vessels/stage.html
    parameter check_clamp is false.
    parameter continue_staging_til_none is false.
    
    //STAGE.
    if (check_clamp){
        IF stage:nextDecoupler:isType("LaunchClamp"){
            STAGE.
            return true.
        }
    }

    if (continue_staging_til_none){
        IF stage:nextDecoupler <> "None" {
            WHEN availableThrust = 0 or (
                stage:resourcesLex["LiquidFuel"]:amount = 0 and
                stage:resourcesLex["SolidFuel"]:amount = 0)
            THEN {
                STAGE.
                return stage:nextDecoupler <> "None".
            }
        }
    }
}

FUNCTION STATUS_NAVE{			//Mostra os status da nave na janela de status
    set hops to inc(hops).
	PRINT_STAT(tstatus,"AP  : "+ ROUND(SHIP:APOAPSIS,0)             + " m"		, ID_POS_STT_AP).//0
	PRINT_STAT(tstatus,"VEL : "+ ROUND(SHIP:VELOCITY:SURFACE:MAG,0) + " m/s"	, ID_POS_STT_VS).
	PRINT_STAT(tstatus,"PE  : "+ ROUND(SHIP:PERIAPSIS,0)            + " m"		, ID_POS_STT_PE).
	PRINT_STAT(tstatus,"MTH : "+ ROUND(MAXTHRUST,1)                 + "kN?   "	, ID_POS_STT_MTH).
	PRINT_STAT(tstatus,"DIR : "+ ROUND(compass_for(ship),1)         + "???"		, ID_POS_STT_DIR).//4
	//PRINT_STAT(tstatus,"INC : "+ " "         + "???"		, ID_POS_STT_inclinacao).//5
	PRINT_STAT(tstatus,"STGC : "+ stage_COUNT         + " "						, ID_POS_STT_STG).//6
	PRINT_STAT(tstatus,"STGS : "+ STAGE:NUMBER        + " "						, ID_POS_STT_STGS).//7  DD
	
	}.

FUNCTION STATUS_QUEDA_ATM{
    parameter v_sqr.
    parameter f_PESO.
    parameter DS_calc.
    parameter velocidade_nave.

    parameter altitude_nave_sea     .//SHIP:altitude
    parameter altitude_nave_radar   .//ALT:radar
    parameter maxthrust_nave        .//MAXTHRUST
    parameter avaliable_thrust_nave .//ship:availablethrust
    parameter massa_nave            .//SHIP:MASS

    parameter fast_stat is False.
    parameter limpa_stat is False.
    parameter inicializa_stat is False.

    local def_msg_para_tamanho is "SETP: ".
    local def_mgs_para_tamanho_dado is "0000.0".//larg_max_stat do PRINT_STAT
    local VEL_calc is "0.0".

    set hops to inc(hops).

    if (v_sqr < 0){//resulta em número imaginário:
        //set VEL_calc to "imagin".
        set VEL_calc to ROUND(sqrt(-v_sqr),1) + "i".
    }
    else{
        set VEL_calc to ROUND(sqrt(v_sqr),1).
    }

    if (fast_stat){
        PRINT_STAT(tstatus, ROUND(altitude_nave_sea,0),     0, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(altitude_nave_radar,0),   1, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(velocidade_nave,1),       2, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(maxthrust_nave,1),        3, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(avaliable_thrust_nave,1), 4, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(f_PESO,0),                5, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(massa_nave,0),            6, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(DS_calc,0),               7, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(v_sqr,1),                 8, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, VEL_calc,                       9, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
    }
    else if (limpa_stat){
        PRINT_STAT(tstatus," "		, 0).
        PRINT_STAT(tstatus," "		, 1).
        PRINT_STAT(tstatus," "		, 2).
        PRINT_STAT(tstatus," "		, 3).
        PRINT_STAT(tstatus," "		, 4).
        PRINT_STAT(tstatus," "		, 5).
        PRINT_STAT(tstatus," "		, 6).
        PRINT_STAT(tstatus," "		, 7).
        PRINT_STAT(tstatus," "		, 8).
        PRINT_STAT(tstatus," "		, 9).
    }
    else if (inicializa_stat){
        PRINT_STAT(tstatus,"ALT : " + "0000.0" + " m"		, 0).
        PRINT_STAT(tstatus,"RDAR: " + "0000.0" + " m"		, 1).
        PRINT_STAT(tstatus,"VEL : " + "0000.0" + " m/s"	    , 2).

        PRINT_STAT(tstatus,"MTH : " + "0000.0" + " kN"	    , 3).
        PRINT_STAT(tstatus,"avTH: " + "0000.0" + " kN"	    , 4).
        PRINT_STAT(tstatus,"Fg  : " + "0000.0" + " kN"	    , 5).
        PRINT_STAT(tstatus,"MASS: " + "0000.0" + " t"		, 6).
        PRINT_STAT(tstatus,"DS_c: " + "0000.0" + " m"		, 7).
        PRINT_STAT(tstatus,"Vc_2: " + "0000.0" + " m2/s2"	, 8).
        PRINT_STAT(tstatus,"V_c : " + "0000.0" + " m/s"	    , 9).
    }
    else{
        PRINT_STAT(tstatus,"ALT : " + ROUND(altitude_nave_sea,0)    + " m"		, 0).
        PRINT_STAT(tstatus,"RDAR: " + ROUND(altitude_nave_radar,0)  + " m"		, 1).
        PRINT_STAT(tstatus,"VEL : " + ROUND(velocidade_nave,1)      + " m/s"	, 2).

        PRINT_STAT(tstatus,"MTH : " + ROUND(maxthrust_nave,1)       + " kN"	    , 3).
        PRINT_STAT(tstatus,"avTH: " + ROUND(avaliable_thrust_nave,1)+ " kN"	    , 4).
        PRINT_STAT(tstatus,"Fg  : " + ROUND(f_PESO,0)               + " kN"	    , 5).
        PRINT_STAT(tstatus,"MASS: " + ROUND(massa_nave,0)           + " t"		, 6).
        PRINT_STAT(tstatus,"DS_c: " + ROUND(DS_calc,0)              + " m"		, 7).
        PRINT_STAT(tstatus,"Vc_2: " + ROUND(v_sqr,1)                + " m2/s2"	, 8).
        PRINT_STAT(tstatus,"V_c : " + VEL_calc                      + " m/s"	, 9).
    }
}

FUNCTION STATUS_HOVER_1{
declare parameter  seekAlt2, alt_radar2, vertical_vel_2, ship_vel_mag_2,
                    ship_vel_x_2, ship_vel_y_2, ship_vel_z_2.
parameter fast_stat is False.
parameter limpa_stat is False.
parameter inicializa_stat is False.
       
    set hops to inc(hops).
    
    local def_msg_para_tamanho is "SETP: ".
    local def_mgs_para_tamanho_dado is "0000.0".//larg_max_stat do PRINT_STAT
    
    if (fast_stat){
        PRINT_STAT(tstatus, ROUND(seekAlt2,0),          0, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(alt_radar2,0),        1, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(vertical_vel_2,1),    2, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(ship_vel_x_2,1),      3, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(ship_vel_y_2,1),      4, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(ship_vel_z_2,1),      5, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(ship_vel_mag_2,1),    6, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
    }
    else if (limpa_stat){
        PRINT_STAT(tstatus," "		, 0).
        PRINT_STAT(tstatus," "		, 1).
        PRINT_STAT(tstatus," "		, 2).
        PRINT_STAT(tstatus," "		, 3).
        PRINT_STAT(tstatus," "		, 4).
        PRINT_STAT(tstatus," "		, 5).
        PRINT_STAT(tstatus," "		, 6).
    }
    else if (inicializa_stat){
        PRINT_STAT(tstatus,"SETP: " + "0000.0" + " m"		, 0).
        PRINT_STAT(tstatus,"RDAR: " + "0000.0" + " m"		, 1).
        PRINT_STAT(tstatus,"VEL : " + "0000.0" + " m/s"	    , 2).

        PRINT_STAT(tstatus,"VX  : " + "0000.0" + " m/s"	    , 3).
        PRINT_STAT(tstatus,"VY  : " + "0000.0" + " m/s"	    , 4).
        PRINT_STAT(tstatus,"VZ  : " + "0000.0" + " m/s"		, 5).
        PRINT_STAT(tstatus,"Vmag: " + "0000.0" + " m/s"		, 6).
    }
    else{
        PRINT_STAT(tstatus,"SETP: "+ ROUND(seekAlt2,0)             + " m"		, 0).
        PRINT_STAT(tstatus,"RDAR: "+ ROUND(alt_radar2,0)           + " m"		, 1).
        PRINT_STAT(tstatus,"VEL : "+ ROUND(vertical_vel_2,1)       + " m/s"	    , 2).

        PRINT_STAT(tstatus,"VX  : "+ ROUND(ship_vel_x_2,1)            + " m/s"	    , 3).
        PRINT_STAT(tstatus,"VY  : "+ ROUND(ship_vel_y_2,1)            + " m/s"	    , 4).
        PRINT_STAT(tstatus,"VZ  : "+ ROUND(ship_vel_z_2,1)            + " m/s"		, 5).
        PRINT_STAT(tstatus,"Vmag: "+ ROUND(ship_vel_mag_2,1)          + " m/s"		, 6).
    }
}
FUNCTION STATUS_KILL_VEL_SURF{
    parameter velocidade_nave       .
    parameter angulo_desvio_nave    .//ship:facing:vector
    parameter vel_ang_nave          .//SHIP:angularvel:mag

    parameter fast_stat is False.
    parameter limpa_stat is False.
    parameter inicializa_stat is False.

    local def_msg_para_tamanho      is "SETP: ".
    local def_mgs_para_tamanho_dado is "0000.0".//larg_max_stat do PRINT_STAT

    set hops to inc(hops).

    if (fast_stat){
        PRINT_STAT(tstatus, ROUND(velocidade_nave,1),       2, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(vel_ang_nave,3),          3, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(angulo_desvio_nave,1),    4, False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
    }
    else if (limpa_stat){
        PRINT_STAT(tstatus," "		, 0).
        PRINT_STAT(tstatus," "		, 1).
        PRINT_STAT(tstatus," "		, 2).
        PRINT_STAT(tstatus," "		, 3).
        PRINT_STAT(tstatus," "		, 4).
        PRINT_STAT(tstatus," "		, 5).
        PRINT_STAT(tstatus," "		, 6).
        PRINT_STAT(tstatus," "		, 7).
        PRINT_STAT(tstatus," "		, 8).
        PRINT_STAT(tstatus," "		, 9).
    }
    else if (inicializa_stat){
        PRINT_STAT(tstatus,"VEL : " + "0000.0" + " m/s"	    , 2).
        PRINT_STAT(tstatus,"aVEL: " + "00.000" + " rad/s"   , 3).
        PRINT_STAT(tstatus,"vang: " + "0000.0" + " deg"     , 4).
    }
    else{
        PRINT_STAT(tstatus,"VEL : " + ROUND(velocidade_nave,1)      + " m/s"    	, 2).
        PRINT_STAT(tstatus,"aVEL: " + ROUND(vel_ang_nave,3)         + " rad/s"	    , 3).
        PRINT_STAT(tstatus,"vang: " + ROUND(angulo_desvio_nave,1)+ " deg"	    , 4).
    }
}

FUNCTION QUEDA_CONTROLADA{
    parameter altitude_parada.
    set hops to inc(hops).

    local suicide_burn_iniciado is false.

    local vel_ship      is 0.
    LOCAL f_PESO_ship   is 0.
    local v_c_sqr       is 0.
    local DS_calc_n     is 0.
    local distancia_seguranca   is 30.0.//full crazy
    local velocidade_seguranca  is 4.0.
    local fator_seguranca       is 1.
    local throt_seguranca       is 0.4.//TOO
    local queda_t       is 0.
    local queda_dir     is 0.
    local f_MOTORES     is 0.
    local f_PESO_ship_MIN   is 0.
    local f_PESO_ship_MAX   is 0.

    //lock queda_dir  to ship:retrograde.
    lock    queda_dir  to (-1) * SHIP:VELOCITY:SURFACE.

    lock steering   to queda_dir.//this is gona be loud
    lock throttle   to queda_t.


//    when (ABS(DS_calc_n) + 10000 > alt:radar) then {
//    }

    print_stat(tlog, ": SCB: STOP AT   : " + altitude_parada,        contador_log).
    print_stat(tlog, ": SCB: SAFE DIST : " + distancia_seguranca,    contador_log).
    print_stat(tlog, ": SCB: SAFE VEL  : " + velocidade_seguranca,   contador_log).
    print_stat(tlog, ": SCB: SAFE FACT : " + fator_seguranca,        contador_log).

    STATUS_QUEDA_ATM(0,0,0,0,0,0,0,0,0, False,False,True).//inicializa
    beep("step_fl").
    until false{

        //set vel_ship TO ship:airspeed.
        LOCK vel_ship    to ship:VERTICALSPEED.
        //set f_MOTORES   to ship:MAXTHUST.
        set f_MOTORES   to ship:availableThrust. //ACCOUNT FOR LIMITERS
        set f_PESO_ship_MIN to ship:mass * body:mu /((ship:altitude + body:radius)^2).
        set f_PESO_ship_MAX to ship:mass * body:mu /(((ship:altitude - alt:radar) + body:radius)^2).
        set f_PESO_ship     to f_PESO_ship_MAX.
        //set f_PESO_ship TO ship:mass * body:mu /((ship:altitude + body:radius)^2).

        set v_c_sqr TO (2*alt:radar*(f_MOTORES-f_PESO_ship)/ship:mass).
        set DS_calc_n TO ( (vel_ship^2)*(SHIP:MASS))/(2*(f_MOTORES-f_PESO_ship)).
        //set dist_sb to ( (ship:VERTICALSPEED^2)*(SHIP:MASS))/(2*(ship:availableThrust-(ship:mass * body:mu /(((ship:altitude - alt:radar) + body:radius)^2))))).
        //lock queda_dir to UP.

        STATUS_QUEDA_ATM(v_c_sqr,f_PESO_ship,DS_calc_n,vel_ship,
                        SHIP:altitude, ALT:radar, MAXTHRUST, ship:availablethrust, SHIP:MASS,
                        True).
        lock steering to queda_dir.//this is gona be loud2

        print "VEL:Z   : " + ROUND(SHIP:velocity:SURFACE:Z,1) at(15,40).
        print "VEL:y   : " + ROUND(SHIP:velocity:SURFACE:y,1) at(15,41).
        print "VEL:x   : " + ROUND(SHIP:velocity:SURFACE:x,1) at(15,42).

        print "VEL:air : " + ROUND(SHIP:airspeed,1) at(15,44).
        print "VEL:vert: " + ROUND(SHIP:verticalspeed,1) at(15,45).

        if ( ABS(DS_calc_n * fator_seguranca) + distancia_seguranca > alt:radar ) and not(suicide_burn_iniciado){
            beep("step_fl").
            SET suicide_burn_iniciado to true.
            print "DS_CALC maior que RADAR" at(15,49).
            //print "LIMITE PARA SUICIDE BURN".
                set queda_t to 1.0.
                print "vel maior que: " + velocidade_seguranca at(15,50).
        }

        if (suicide_burn_iniciado and (abs(vel_ship) < velocidade_seguranca)){
                beep("step_fl").
                set queda_t to 0.0.
                print "vel menor que: " + velocidade_seguranca at(15,50).
                set queda_dir to UP.
            print_stat(tlog, ": VEL STOP: "         + ROUND(vel_ship,2) + "m/s"  , contador_log).
            print_stat(tlog, ": SCB: HEAD: UP"                          , contador_log).
            print_stat(tlog, ": ALT STOP: HOVER: "  + ROUND(alt:radar,1) + "m"   , contador_log).
            //HOVER_1(alt:radar).
            set OBJETIVOS_HOVER_ALT to alt:radar.
			set ready_for_HOVER to True.
            UNLOCK STEERING.
            UNLOCK THROTTLE.
             wait 0.001.
            return true.

        }else if (suicide_burn_iniciado and (abs(vel_ship) < (velocidade_seguranca*2))){
            if queda_t > throt_seguranca{
                beep("step_fl").
                set queda_t to throt_seguranca.           
                print_stat(tlog, ": throt: "         + queda_t*100 + "%"  , contador_log).
            }
        }
        else{
                //set queda_dir to ship:retrograde.
        }

        if (altitude_parada > alt:radar){
            beep("step_fl").
            print_stat(tlog, "SCB COMPLETE: ALT:"+alt:radar, contador_log).
            //HOVER_1(alt:radar).
            set OBJETIVOS_HOVER_ALT to alt:radar.
			set ready_for_HOVER to True.
            UNLOCK STEERING.
            UNLOCK THROTTLE.
            beep("mission_compl").
             wait 0.001.
            return true.
        }
        wait 0.001.
    }
    beep("mission_compl").
}

FUNCTION KILL_VEL_SURF{//ISTO É NOVO
    parameter VEL_parada    is 0.0.
    parameter kill_agora    is False.

    set hops to inc(hops).

    local throt_seguranca           is 0.1.//ok
    local angulo_minimo             is 0.1.
    local angulo_minimo_start       is 1.1.
    local vel_angular_minima        is 0.001.
    local def_msg_para_tamanho      is "SETP: ".
    local def_mgs_para_tamanho_dado is "0000.0".//larg_max_stat do PRINT_STAT

    local   STEER_KILL  is (-1) * SHIP:VELOCITY:SURFACE. 
    lock    STEER_KILL  to (-1) * SHIP:VELOCITY:SURFACE.
    LOCK    STEERING    TO STEER_KILL.

    local angulo_desvio_nave        is 0.
    lock angulo_desvio_nave to vang(ship:facing:vector, (STEER_KILL)).

    print_stat(tlog, "KILL AT FULL THROT", contador_log).
    print_stat(tlog, ": V_stop:" + VEL_parada, contador_log).
    print_stat(tlog, ": LOCK STEER TO KILL", contador_log).

    STATUS_KILL_VEL_SURF(0,0,0,False,True,False).
    STATUS_KILL_VEL_SURF(0,0,0,False,False,True).
    wait 0.1.
    beep("step_fl").

    if not(kill_agora){//looop para esperar a nave ficar na pos certa
        print_stat(tlog, ": WAIT FOR HEADING...", contador_log).
        until ( angulo_desvio_nave<angulo_minimo_start){
            //STATUS_KILL_VEL_SURF(1,2,3,4,fast,limpa,init).
            STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).
        }
    }

    local kill_t is 1.0.
    beep("step_fl").
    print_stat(tlog, ": LOCK THROT TO: "+kill_t, contador_log).
    LOCK throttle TO kill_t.

    print_stat(tlog, ": WAIT FOR VMIN:"+VEL_parada+"...", contador_log).
    UNTIL (SHIP:VELOCITY:SURFACE:mag< VEL_parada){ //ship:VERTICALSPEED 
        STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).

        if ( (SHIP:VELOCITY:SURFACE:mag < (VEL_parada*10))){//hey
            if kill_t > throt_seguranca{
                beep("step_fl").
                set kill_t to throt_seguranca.           
                print_stat(tlog, ": throt: "         + kill_t*100 + "%"  , contador_log).
                //lock steering to ship:facing.
                //UNLOCK STEERING.
            }
        }
        if (kill_t = throt_seguranca){
            until (  (angulo_desvio_nave>angulo_minimo)
                    ){
                set kill_t to 0.
                print_stat(tlog, ": throt: "         + kill_t*100 + "%"  , contador_log).
            STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).
            }

        }
        else if (kill_t < throt_seguranca){
            until (  (angulo_desvio_nave>angulo_minimo)
                    ){
            STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).
            }
            set kill_t to throt_seguranca.
            print_stat(tlog, ": throt: "         + kill_t*100 + "%"  , contador_log).
        }

    }
    wait 0.1.
    set kill_t to 0.0.
    print_stat(tlog, ": throt: "         + kill_t*100 + "%"  , contador_log).
    beep("step_fl").
    wait 0.1.

    print_stat(tlog, ": WAIT VANGMIN:"+vel_angular_minima+"...", contador_log).
    until (ship:angularvel:mag<vel_angular_minima){
            STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).
    }
    beep("step_fl").
    print_stat(tlog, ": rot kill: "         + ROUND(SHIP:angularvel:mag,3) + "rad/s"  , contador_log).
    print_stat(tlog, ": WAIT ANG_MIN:"+angulo_minimo+"...", contador_log).
    until (  (angulo_desvio_nave<angulo_minimo)
            and
             (ship:angularvel:mag<vel_angular_minima)
            ){
            STATUS_KILL_VEL_SURF(SHIP:velocity:SURFACE:mag, angulo_desvio_nave, SHIP:angularvel:mag, true).
    }
    beep("step_fl").
    print_stat(tlog, ": rot kill: "         + ROUND(angulo_desvio_nave,1) + "deg"  , contador_log).
    wait 0.1.

    print_stat(tlog, "KILL COMPLETE", contador_log).

    wait 0.1.
    UNLOCK STEERING.
    UNLOCK THROTTLE.
    wait 0.1.
    beep("mission_compl").
}
FUNCTION POINT_UP{
    parameter DIRECAO_KILL.//direction > VECTOR

    //print "parametro DIRECAO_KILL:".
    //print DIRECAO_KILL.
    
    local angulo_minimo             is 0.1.
    local vel_angular_minima        is 0.001.

    local def_msg_para_tamanho      is "SETP: ".
    local def_mgs_para_tamanho_dado is "0000.0".//larg_max_stat do PRINT_STAT

    PRINT_STAT(tstatus,"aVEL: " + "0000.0" + " rad/s"   , 3).
    PRINT_STAT(tstatus,"vang: " + "0000.0" + " deg"     , 4).

    beep("step_fl").

    print_stat(tlog, ": LOCK STEER TO DIR", contador_log).
    local papo_de_doido is v(1,1,1).
    set papo_de_doido to DIRECAO_KILL:vector.
    //print "papo_de_doido: ".
    //print papo_de_doido.//hehe

    LOCK    STEERING    TO papo_de_doido.

    print_stat(tlog, ": WAIT ANG_MIN:"+angulo_minimo+"...", contador_log).
    print_stat(tlog, ": WAIT VANGMIN:"+vel_angular_minima+"...", contador_log).
    print_stat(tlog, ": WAIT FOR HEADING...", contador_log).

    until (  (vang(ship:facing:vector, papo_de_doido)<angulo_minimo)
            and
             (ship:angularvel:mag<vel_angular_minima)
            ){
        PRINT_STAT(tstatus, ROUND(SHIP:angularvel:mag,3),           3,
                    False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
        PRINT_STAT(tstatus, ROUND(vang(ship:facing:vector, (papo_de_doido)),1), 4,
                    False, False, 0, def_mgs_para_tamanho_dado:length, def_msg_para_tamanho:length).
    }
    print_stat(tlog, "STEER COMPLETE", contador_log).

    beep("mission_compl").
}
 	
FUNCTION MOSTRA_OBJETIVOS{		//Mostra os objetivos de voo NO DEBUG:
	local NOME_DA_FUNC is "MOSTRA_OBJETIVOS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	
	debug(NOME_DA_FUNC, "FAZER: ativar o menu de objetivos apos o liftoff").
	debug(NOME_DA_FUNC, NOME_CMD_get_AP_MAX + " "+OBJETIVOS_AP_MAX).
	debug(NOME_DA_FUNC, NOME_CMD_get_HLAT 	+ " "+OBJETIVOS_HEAD_LAT).
	debug(NOME_DA_FUNC, NOME_CMD_get_INCL 	+ " "+OBJETIVOS_HEAD_INCL).
	debug(NOME_DA_FUNC, NOME_CMD_get_INCG 	+ " "+OBJETIVOS_INC_GANHO).
	debug(NOME_DA_FUNC, NOME_CMD_get_VMAX 	+ " "+OBJETIVOS_VE_MAX).
	debug(NOME_DA_FUNC, NOME_CMD_get_VMATM 	+ " "+OBJETIVOS_VE_MAX_ATM).
	debug(NOME_DA_FUNC, NOME_CMD_get_PE 	+ " "+ OBJETIVOS_PE_MIN).
	debug(NOME_DA_FUNC, NOME_CMD_get_THRM 	+ " "+OBJETIVOS_THRTL_MAX).
	debug(NOME_DA_FUNC, NOME_CMD_get_STGM 	+ " "+OBJETIVOS_STAG_MAX_ASC).
	debug(NOME_DA_FUNC, NOME_CMD_IPU 		+ " "+CONFIG_DEF_IPU).
	debug(NOME_DA_FUNC, "IPU ATUAL " + CONFIG:IPU).
	debug(NOME_DA_FUNC, "stage atual no comeco: " + STAGE:NUMBER).
}.	
	
FUNCTION COUNTDOWN_T{			//This is our countdown loop, which cycles from t_inicial to 0
	parameter t_inicial is 10.
	
	local NOME_DA_FUNC is "COUNTDOWN_T".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    
	local V0            TO GETVOICE(0). // Gets a reference to the zero-th voice in the chip.
    local pontinhos_c   TO "            T-".//10 pontos + 2 esp (MUDEI DO IS PRO TO)
	
	print_stat(tlog,"START COUNTDOWN T-"+t_inicial+"s",contador_log).
	print_stat(ttimer,"Counting down:",0). //contador_timer = 0 ?? no começo sim mas quando quiser 
											//reiniciar tem que fazer isso pois e uma maneira de zerar o contador_timer
    //
    local new_pontinhos_c   is "".//PREPARA LINHA COM PONTINHOS conforme o T
    from {local car_pos is 0.}
		until (car_pos = pontinhos_c:length)
		step{set car_pos to inc(car_pos).}
		do{           
            if (car_pos < t_inicial){
                set new_pontinhos_c to new_pontinhos_c + ".".
            }
            else{
                set new_pontinhos_c to new_pontinhos_c + pontinhos_c[car_pos].
            }.
        }.
    // FOR c IN pontinhos_c {//PORQUE ISSO NAO DEU CERTO?
		// set car_pos to inc(car_pos).
        // debug(NOME_DA_FUNC,c).
	// }    
    set pontinhos_c to new_pontinhos_c.
    
	print_stat(ttimer,pontinhos_c,contador_timer). 

	//fazer qualquer contagem <> 10 se adaptar 
	FROM {local countdown is t_inicial.} UNTIL countdown = -1 STEP {SET countdown to countdown - 1.}
	DO  {
			//print_stat(ttimer,".......... T-",contador_timer). //para manter a impressão ? se count > 1
			//= < > <= >= <>
			V0:PLAY( NOTE(1000, 0.5) ).  // Starts a note at 400 Hz for 0.5 seconds.
                            // The note will play while the program continues.
			WAIT 1. // pauses the script here for 1 second.
			IF COUNTDOWN >= 10 { //como contador = 2 ira para essa logica
				PRINT_STAT(tTIMER,"" + COUNTDOWN + "",contador_timer).
			} ELSE {
				PRINT_STAT(tTIMER," " + COUNTDOWN + "",contador_timer).}.
		}.
	}.
	
FUNCTION CONTROLE_NAVE{			//CONTROLA DIRECAO PROP A VEL, MOSTRA STATUS, LIBERA CONTROLE
	//=============================================================================================================================
    parameter STATUS_VOO_nave.
	local NOME_DA_FUNC is "CONTROLE_NAVE".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	if (debug_controle_nave)//global ok
	{}.

	local MYSTEER_control               to 0.
	local MTHROTL_control               to OBJETIVOS_THRTL_MAX.
    local contador_verbose_controle_nave to 0.
	
    if (STATUS_VOO_nave = "launchpad"){
        //
    	ATIVA_REGISTRO_VOO("liftoff", shipName).
        LOCK THROTTLE TO MTHROTL_control.   // 1.0 is the max, 0.0 is idle.
        print_stat(tlog,"LOCK THROTTLE:" + ROUND(( MTHROTL_control * 100),0) + "%",contador_log).
        
        debug(NOME_DA_FUNC, "STAGE_BY_MAXTHRUST() no inicio: verificar").

        STAGE_BY_MAXTHRUST().//LOCK	TEST
        //STAGE_BY_FLAMEOUT().
        set STATUS_VOO_nave TO "ascencao".
       	ATIVA_REGISTRO_VOO(STATUS_VOO_nave, shipName).
    }


	//This will be our main control loop for the ascent. It will
	//cycle through continuously until our apoapsis is greater
	//than 100km. Each cycle, it will check each of the IF
	//statements inside and perform them if their conditions
	//are met
	
    if (STATUS_VOO_nave = "ascencao"){
        LOCK THROTTLE TO MTHROTL_control. 
        //set MYSTEER_control TO HEADING(OBJETIVOS_HEAD_LAT, OBJETIVOS_HEAD_INCL).
        //PARA QUANDO RETOMAR O VOO NO MEIO: (no lancamento da na mesma)
        debug(NOME_DA_FUNC, "lock STERING para TESTE_DE_ASCENCAO_2()").
        set MYSTEER_control to TESTE_DE_ASCENCAO_2(OBJETIVOS_VE_MAX_ATM,OBJETIVOS_INC_GANHO).//inclina conforme VELOCIDADE

        LOCK STEERING TO MYSTEER_control. // from now on we'll be able to change steering by just assigning a new value to MYSTEER
        print_stat(tlog,"Stering to UP ("+ROUND(OBJETIVOS_HEAD_INCL,0)+")",contador_log).

        print_stat(tLOG,"TESTING VELOCITY",contador_LOG).
        print_stat(tLOG,"TESTING APOAPSIS",contador_LOG).
        
        debug(NOME_DA_FUNC, "lock THROTTLE para CALC_THROTTLE()").
        debug(NOME_DA_FUNC, "STAGE_BY_FLAMEOUT() no loop: verificar").
    }

    if (STATUS_VOO_nave = "ascencao_meio"){
        set MTHROTL_control to 0.
        LOCK THROTTLE TO MTHROTL_control. 

        set MYSTEER_control to TESTE_DE_ASCENCAO_2(OBJETIVOS_VE_MAX_ATM,OBJETIVOS_INC_GANHO).//inclina conforme VELOCIDADE
        LOCK STEERING TO MYSTEER_control. // from now on we'll be able to change steering by just assigning a new value to MYSTEER

        //
    }
    set STATUS_VOO_nave to "ascencao_meio".
   	ATIVA_REGISTRO_VOO(STATUS_VOO_nave, shipName).
    
    //// UM LOOP:
	UNTIL SHIP:APOAPSIS > OBJETIVOS_AP_MAX { //Remember, all altitudes will be in meters, not kilometers
		if ABORTAR_SEQUENCIA() {//detecta comando de abortar:
        	ATIVA_REGISTRO_VOO("iniciada sequencia para abortar", shipName).
			BREAK. 
		}.
		STATUS_NAVE().
        Mostra_Bat(TIME:SECONDS).//vai mostrar o hops

		set contador_PASSO to 1.
		print_stat(tpasso,"UNTIL AP = "+ OBJETIVOS_AP_MAX +"m",contador_PASSO). //PODERIA USAR O CONTADOR PARA SEGURAR OS NIVEIS DE ESPERA
		//TESTE_DE_ASCENCAO_1().
		set contador_PASSO to 2. //NIVEL ONDE MOSTRARA A velocidade de ascencao.


            //	global OBJETIVOS_VE_MAX 		is 800		.
            //	global OBJETIVOS_INC_GANHO 	is 10		.
		if (ship:altitude > 20000){//fazer: ligar isso a uma pressao ATM
			//			pode acelerar mais.
			set MYSTEER_control to TESTE_DE_ASCENCAO_2(OBJETIVOS_VE_MAX,OBJETIVOS_INC_GANHO).
		}
		else{
			set MYSTEER_control to TESTE_DE_ASCENCAO_2(OBJETIVOS_VE_MAX_ATM,OBJETIVOS_INC_GANHO).
		}.
        
        //Detecta se enta caindo e avisa:
		IF (SHIP:VERTICALSPEED < 0 ){
            set contador_verbose_controle_nave to contador_verbose_controle_nave + 1.
            
            //print_stat(tLOGv, msg,        count_print, reprint, debug, num_verb).
            print_stat(tLOGv,"ESTA CAINDO", contador_LOG, False, False, contador_verbose_controle_nave).
            
			HUDTEXT("ESTA CAINDO", 5, 2, 15, red, false).
		}.
        
        //Limita THROTTLE para controlar velocidade max:
		
		
		//set MTHROTL_control to CALC_THROTTLE(SHIP:VELOCITY:SURFACE:MAG,OBJETIVOS_VE_MAX,MTHROTL_control).
		if (ship:VELOCITY:SURFACE:z > 0){
			//
			set MTHROTL_control to CALC_THROTTLE(SHIP:VELOCITY:SURFACE:MAG,OBJETIVOS_VE_MAX,MTHROTL_control).
			
		}
		else{//pode acelerar mais.
			set MTHROTL_control to CALC_THROTTLE((SHIP:VELOCITY:SURFACE:MAG)*(-1),OBJETIVOS_VE_MAX,MTHROTL_control).

			//asdf
		}.
        
        //STAGE conforme os motores forem desligando: CONFIGURACAO ASPARGAAKSDJF PARA LIBERAR MASSA:
		if (STAGE_MAX_ATINGIDO) {
			//faz algo?
        	ATIVA_REGISTRO_VOO("stage max atingido", shipName).
		}
		else {
            //http://ksp-kos.github.io/KOS_DOC/structures/vessels/stage.html
			if(STAGE_BY_FLAMEOUT(debug_level_trace_verbose,False)) {
            	ATIVA_REGISTRO_VOO("stage:number > " + stage:number, shipName).
				debug(NOME_DA_FUNC,"STAGE conforme os motores forem desligando: CONFIGURACAO ASPARG PARA LIBERAR MASSA").
				//STAGE_BY_FLAMEOUT
				print_stat(tLOG,"FLAMEOUT detect",contador_LOG).
				print_stat(tLOG,"STAGE:number: "+stage:number, contador_LOG).
				print_stat(tLOG,"rest ou atual?", contador_LOG).
				//print_stat(tLOG,"TESTING APOAPSIS",contador_LOG).
			}
		}.
		
		//You can simulate non-blocking I/O like so:
		// Read a char if it exists, else just keep going:
        //		if terminal:input:haschar {
        //		  process_one_char(terminal:input:getchar()).
        //		}
		SET contador_PASSO TO 1.//velocidade max alcancada> volta pro nivel do APOAPSIS

	}.
  	ATIVA_REGISTRO_VOO("apoapsis alcançado", shipName).
	print_stat(tLOG, OBJETIVOS_AP_MAX + "m apoapsis reached",contador_LOG).
	//chegar na altitude antes da vel = 800m/s vai dar merda [OK]
	print_stat(tpasso,"AP = " + OBJETIVOS_AP_MAX + "M [OK]",contador_PASSO). //PODERIA USAR O CONTADOR PARA SEGURAR OS NIVEIS DE ESPERA [OK]
	set contador_PASSO to 0.//fazer poderia usar a posicao do passo aqui pois se 

	//At this point, our apoapsis is above 100km and our main loop has ended. Next
	//we'll make sure our throttle is zero and that we're pointed prograde
	CUT_THROTTLE_STOP().
	
	
	print_stat(tLOG,"ACOES CONCLUIDAS",contador_LOG).
   	ATIVA_REGISTRO_VOO("ações concluídas", shipName, "conclui").
	//================================================================================================================
	}.// fim CONTROLE_NAVE
	
function CALC_THROTTLE{             //CALCULA NOVO THROTTLE com base na velocidade max
	PARAMETER vel_shoip is 0.0.
	parameter setpoint_vel is 0.0.
	parameter tttrl_atual is 0.0.
	
    set hops to inc(hops).
    local ganho_prop_acho is 0.05.
    
	local NEW_TROT is 0.0.
	local dif_thrott is 0.0.
	
	set dif_thrott to (ganho_prop_acho * (setpoint_vel - vel_shoip)).
	
	set NEW_TROT to MIN(1,MAX(0,tttrl_atual + dif_thrott)).
	
	RETURN NEW_TROT.
}.

FUNCTION CUT_THROTTLE_STOP{		    //CUTT AND ZERO THROTTLE
    set hops to inc(hops).
	LOCK THROTTLE TO 0.
	print_stat(tLOG,"CONTROLE LIBERADO!",contador_LOG).
   	ATIVA_REGISTRO_VOO("controle liberado", shipName).

	//This sets the user's throttle setting to zero to prevent the throttle
	//from returning to the position it was at before the script was run.
	SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

	UNLOCK THROTTLE.
    UNLOCK steering.
}.	

FUNCTION TESTE_DO_CHAO_NU{         //NÃO UTILIZADA
    set hops to inc(hops).
	IF (SHIP:VELOCITY:SURFACE){}.
	IF (SHIP:ALTITUDE:SURFACE){}.
}.

FUNCTION TESTE_DE_ASCENCAO_2{		//vai inclinando a nave conforme a velocidade continuamente
	parameter VEL_MAX_ASC    .
	parameter GANHO_DE_INCL  .

	local NOME_DA_FUNC is "TESTE_DE_ASCENCAO_2".
    trace(NOME_DA_FUNC).
	
    set hops to inc(hops).
	local INCLINATION_MY to 0.
	local MYSTEER_teste2 to SHIP:HEADING.
	
	if ( VEL_MAX_ASC > SHIP:VELOCITY:SURFACE:MAG) 
	{
		set GANHO_DE_INCL  to ( GANHO_DE_INCL / 100).
		//substituir 90 (para cima) por OBJETIVOS_HEAD_INCL
		set INCLINATION_MY to (OBJETIVOS_HEAD_INCL - (GANHO_DE_INCL * (SHIP:VELOCITY:SURFACE:MAG))).
		
		SET MYSTEER_teste2 TO HEADING(OBJETIVOS_HEAD_LAT, INCLINATION_MY).
		print_stat(tpasso,"V SURF   = "+ VEL_MAX_ASC +"m/s",contador_PASSO).
		PRINT_STAT(tstatus,"INC : "+ ROUND(INCLINATION_MY,1) + "º["+ROUND(pitch_for(ship),1)+"]  ",ID_POS_STT_inclinacao).
	}
	else
	{
			print_stat(tpasso,"V SURF  "+ VEL_MAX_ASC +"m/s[OK]",contador_PASSO).
			SET contador_PASSO TO 1.//velocidade max alcancada  SO TIREI FORA DO IF
			//debug(NOME_DA_FUNC, "aqui chegou.").
			SET MYSTEER_teste2 TO SHIP:FACING.//PARA NAO ALTERAR A ORIENTAÇÃO
			
			//PRINT SHIP:HEADING:istype.
      
			//PRINT SHIP:HEADING:typename.
			//Scalar

			//outros que testar>
			//BEARING	scalar (deg)	relative heading to this vessel
			//HEADING	scalar (deg)	Absolute heading to this vessel
			//FACING	Direction	The way the vessel is pointed
			

			
			
			//debug(NOME_DA_FUNC, "aqui NAO chegou.").
	}.	
	return MYSTEER_teste2.
}.
	
function TESTE_DE_ASCENCAO_1{		//vai inclinando a nave conforme VELOCIDADES FIXAS
    set hops to inc(hops).

		//For the initial ascent, we want our steering to be straight
		//up and rolled due east
		IF SHIP:VELOCITY:SURFACE:MAG < 100 {
			//This sets our steering 90 degrees up and yawed to the compass
			//heading of 90 degrees (east)
			print_stat(tpasso,"V SURF   = 100m/s",contador_PASSO).
			SET MYSTEER TO HEADING(90,90).

		//Once we pass 100m/s, we want to pitch down ten degrees
		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {
			SET MYSTEER TO HEADING(90,80).
			print_stat(tpasso,	"V SURF   = 200m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 80 degrees",contador_LOG).

		//Each successive IF statement checks to see if our velocity
		//is within a 100m/s block and adjusts our heading down another
		//ten degrees if so
		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 200 AND SHIP:VELOCITY:SURFACE:MAG < 300 {
			SET MYSTEER TO HEADING(90,70).
			print_stat(tpasso,"V SURF   = 300m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 70 degrees",contador_LOG).

		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 300 AND SHIP:VELOCITY:SURFACE:MAG < 400 {
			SET MYSTEER TO HEADING(90,60).
			print_stat(tpasso,"V SURF   = 400m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 60 degrees",contador_LOG).

		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 400 AND SHIP:VELOCITY:SURFACE:MAG < 500 {
			SET MYSTEER TO HEADING(90,50).
			print_stat(tpasso,"V SURF   = 500m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 50 degrees",contador_LOG).

		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 500 AND SHIP:VELOCITY:SURFACE:MAG < 600 {
			SET MYSTEER TO HEADING(90,40).
			print_stat(tpasso,"V SURF   = 600m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 40 degrees",contador_LOG).

		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 600 AND SHIP:VELOCITY:SURFACE:MAG < 700 {
			SET MYSTEER TO HEADING(90,30).
			print_stat(tpasso,"V SURF   = 700m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 30 degrees",contador_LOG).

		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 {
			SET MYSTEER TO HEADING(90,11).
			print_stat(tpasso,"V SURF   = 800m/s",contador_PASSO).
			print_stat(tLOGv,"Pitching to 20 degrees",contador_LOG).

		//Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait
		//for the main loop to recognize that our apoapsis is above 100km
		} ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 800 {
			SET MYSTEER TO HEADING(90,10).
			print_stat(tpasso,"V SURF   = 800m/s[OK]",contador_PASSO).
			//SET contador_PASSO TO 1.//velocidade max alcancada  SO TIREI FORA DO IF
			print_stat(tLOGv,"Pitching to 10 degrees",contador_LOG).
		}.

}.


FUNCTION DEFINE_STEERING_MAN_NU{    //NÃO UTILIZADA
    set hops to inc(hops).
    
// LOCK STEERING TO expression.

    // This sets the direction kOS should point the ship where expression is a Vector or a Direction created from a Rotation or Heading:

        // A Rotation expressed as R(pitch,yaw,roll). Note that pitch, yaw and roll are not based on the horizon, but based on an internal coordinate system used by KSP that is hard to use. Thankfully, you can force the rotation into a sensible frame of reference by adding a rotation to a known direction first.

        // To select a direction that is 20 degrees off from straight up:

        LOCK STEERING TO Up + R(20,0,0).

        // To select a direction that is due east, aimed at the horizon:

        LOCK STEERING TO North + R(0,90,0).

        // UP and NORTH are the only two predefined rotations.

    // Heading

        // A heading expressed as HEADING(compass, pitch). This will aim 30 degrees above the horizon, due south:

        LOCK STEERING TO HEADING(180, 30).

    // Vector

        // Any vector can also be used to lock steering:

        LOCK STEERING TO V(100,50,10).

        // Note that the internal coordinate system for (X,Y,Z) is quite complex to explain. 
        
        // To aim in the opposite of the surface velocity direction:

        LOCK STEERING TO (-1) * SHIP:VELOCITY:SURFACE.

        // The following aims at a vector which is the cross product of velocity and direction down to the SOI planet 
        //- in other words, it aims at the “normal” direction to the orbit:

        LOCK STEERING TO VCRS(SHIP:VELOCITY:ORBIT, BODY:POSITION).

    // "kill" string

        // Steering may also be locked to the special string value of "kill" which tells the steering manager to attempt to stop any vessel rotation, much like the stock SAS’s stability assist mode.
        LOCK STEERING TO "kill".

// Like all LOCK expressions, the steering and throttle continually update on their own when using this style of control. If you lock your steering to velocity, then as your velocity changes, your steering will change to match it. Unlike with other LOCK expressions, the steering and throttle are special in that the lock expression gets executed automatically all the time in the background, while other LOCK expressions only get executed when you try to read the value of the variable. The reason is that the kOS computer is constantly querying the lock expression multiple times per second as it adjusts the steering and throttle in the background.
}.  

FUNCTION MUDA_STERING_NU{           //NÃO UTILIZADA
    parameter dir_1, dir_2, dir_3.
    set hops to inc(hops).
   

}.
  
FUNCTION SEPARAR_OS_LANDERS{
    parameter debug_separar_landers is True.

	local NF is "SEPARAR_OS_LANDERS".
    trace(NF).
	
    set hops to inc(hops).

	HUDTEXT("SEPARAR_OS_LANDERS", 5, 2, 15, red, false).

    //decidir se vai iniciar o script de hover antes ou apos a separacao
    //      melhor pegar a confirmacao antes da separacao
    //          caso exista algum problema com a rotina de rover é melhor saber antes

    local lista_de_cpus_com_hover is list("cpu1", "cpu2", "cpu3").
    print "SEP: ENVIADO PREPARE SIGNAL FOR ALL...".
    for cpu_sondada in lista_de_cpus_com_hover {
        local mensagem_confirmacao_cpu_hover is "".
        HANDLE_CONNECTION_CORES(cpu_sondada, core:tag+":voce_se_prepare_para_hover").//ENVIA_MENSAGEM_CORE
        print "SEP: Espera resposta de ["+cpu_sondada+"]...".
        until (mensagem_confirmacao_cpu_hover = "hover_probe_esta_pronto"){
            //esperando resposta rover_probe_cpu1
            set mensagem_confirmacao_cpu_hover to SHOW_CORE_MESSAGE_QUEUE(CORE:MESSAGES, False, "esperando_msg", cpu_sondada).

        }
    }
    print "SEP: todas as cpus com capacidades de hover estao prontas em STBY".

    print "SEP: stage...".
    stage.//SEPARACAO DOS HOVERS VAI DEPENDER DE CADA TIPO DE NAVE
    //A SEPARACAO DOS LANDERS/HOVERS PODE DEPENDER DE NAVEGAPARTS
    WAIT 0.

    for cpu_sondada in lista_de_cpus_com_hover {
        local vessels_in_range is list().
        list TARGETS in vessels_in_range.
        for vessel_in_range in vessels_in_range {
            IF vessel_in_range:distance < 100{//coisas longe não foi da nave que saiu
                //print "SEP: nave em alcance: "+vessel_in_range:name.

                //SET ves TO SHIP. // or Target or Vessel("ship name").
                // PLIST TO vessel_in_range:PARTSNAMED("nomedoKAL9000").//nao depender de nome de parte
                //SET PLIST TO  vessel_in_range:parts.
                //local module_list to vessel_in_range:MODULESNAMED("kOSProcessor").//Vessel:MODULESNAMED(name)

                local lista_de_partes_com_tag to vessel_in_range:PARTSTAGGED(cpu_sondada).

                for parte_testada in lista_de_partes_com_tag {
                    if (parte_testada:tag = cpu_sondada){
                        HANDLE_CONNECTION_VESSELS(vessel_in_range, core:tag+":go_hover_probe_gooo").
                        //HANDLE_CONNECTION_CORES(cpu_sondada, core:tag+":go_hover_probe_gooo").//ENVIA_MENSAGEM_CORE
                    }.
                }
            }
        }
    }
    print "SEP: ENVIADO GO SIGNAL FOR ALL...".

    for cpu_sondada in lista_de_cpus_com_hover {
        local mensagem_confirmacao_cpu_hover is "".
        print "SEP: Espera resposta de ["+cpu_sondada+"]...".
        until (mensagem_confirmacao_cpu_hover = "hover_probe_HOVERING"){
            //esperando resposta rover_probe_cpu1
            //set mensagem_confirmacao_cpu_hover to SHOW_CORE_MESSAGE_QUEUE(CORE:MESSAGES, False, "esperando_msg", cpu_sondada).
            set mensagem_confirmacao_cpu_hover to SHOW_VESSEL_MESSAGE_QUEUE(SHIP:MESSAGES, False, "esperando_msg", cpu_sondada).
        }
    }
    print "HOVERS LAUNCH CONFIRMED!".

    local mensagem_confirmacao_cpu_hover is "AHHHHH".
    
    if mensagem_confirmacao_cpu_hover = "hover_probe_esta_pronto"{
        print "hover_probe_1 pronto: " + mensagem_confirmacao_cpu_hover.
    }
    else{
        print "alguma coisa de errada nao esta certa: " + mensagem_confirmacao_cpu_hover.
    }
    
}



FUNCTION HOVER_1{                   //rover at (alt:radar + 10.0).:           HOVER_1().
    // ATENCAO ATENCAO FOI RESOLVIDO UM BAITA PROBLEMA LIGANDO O LOCK DO THROTTLE A UMA VARIAVEL GLOBAL
    //ESTA FUNCAO VAI NO C3_SHIP.KS
    parameter ALTURA_BUSCAR_INICIAL is (alt:radar).//OBJETIVOS_HOVER_ALT + alt:radar
    parameter hover_fast_start      is tRUE.//ahhh
    parameter hover_debug           is True.
    parameter special_condition     is "".

    set OBJETIVOS_HOVER_ALT to ALTURA_BUSCAR_INICIAL.
    //set seekAlt to OBJETIVOS_HOVER_ALT.
	local NOME_DA_FUNC is "HOVER_1".//hey o nome existe
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    local Col_Init is 68.
    local Linha_Init is 5.
 
    //TEM QUE SER GLOBAL POR CONTA DOS MENUS:
    SET Col_Init_CHA TO Col_Init.
    SET Linha_Init_CHA TO Linha_Init.

    local display_block_hover_exibido is false.

    if special_condition = "STAND_BY" {
        local cpu_sondada is "cpu0".
        local mensagem_confirmacao_cpu_hover is "".
        HANDLE_CONNECTION_CORES(cpu_sondada, core:tag+":hover_probe_esta_pronto").//ENVIA_MENSAGEM_CORE
        print "HOVER_1: STAND_BY: esperando go hover probe...".
        //aqui a nave vai se separar das probes...
        until (mensagem_confirmacao_cpu_hover = "go_hover_probe_gooo"){
            //esperando resposta hover_cpu0
            //set mensagem_confirmacao_cpu_hover to SHOW_CORE_MESSAGE_QUEUE(CORE:MESSAGES, False, "esperando_msg", cpu_sondada).
            set mensagem_confirmacao_cpu_hover to SHOW_VESSEL_MESSAGE_QUEUE(SHIP:MESSAGES, False, "esperando_msg", cpu_sondada).
        }
        if mensagem_confirmacao_cpu_hover = "go_hover_probe_gooo"{
            print "hover_cpu0 deu um ok: " + mensagem_confirmacao_cpu_hover.
        }
        else{
            print "HOVER_1 : alguma coisa de errada nao esta certa: " + mensagem_confirmacao_cpu_hover.
        }

        print "HOVER_1: enviando confirmacao de inicio hover probe...".
        //HANDLE_CONNECTION_CORES(cpu_sondada, core:tag+":hover_probe_HOVERING").//ENVIA_MENSAGEM_CORE
        //HANDLE_CONNECTION_VESSELS(cpu_sondada, core:tag+":hover_probe_HOVERING").//ENVIA_MENSAGEM_CORE

        local vessels_in_range is list().
        list TARGETS in vessels_in_range.
        for vessel_in_range in vessels_in_range {
            IF vessel_in_range:distance < 100{//coisas longe não foi da nave que saiu
                print "hover_1: nave em alcance: "+vessel_in_range:name.
                local lista_de_partes_com_tag to vessel_in_range:PARTSTAGGED(cpu_sondada).

                for parte_testada in lista_de_partes_com_tag {
                    if (parte_testada:tag = cpu_sondada){
                        HANDLE_CONNECTION_VESSELS(vessel_in_range, core:tag+":hover_probe_HOVERING").
                    }.
                }
            }
        }
    }//fim status de STAND_BY

	MOSTRA_MENU(MENU_CTRL_ROVER).

    HUDTEXT("hover em " + round(OBJETIVOS_HOVER_ALT,2) + "m AGL(radar).", 5, 2, 15, red, false).

    print_stat(tlog, "hover em " + round(OBJETIVOS_HOVER_ALT,2) + "m AGL(radar).", contador_log).
     
    if (hover_fast_start){
        //debug nao mostra lista de nomes lenta do krlh
        debug(NOME_DA_FUNC, "Nao mostra lista de nomes grandezas unidades e ajuda", hover_debug).
    }
    else{
        MOSTRA_HELP_HOVER().
        set display_block_hover_exibido to display_block_NAMESS2D(Linha_Init).   
        debug(NOME_DA_FUNC, "mostra lista de nomes lenta do krlh", hover_debug).
    }

    beep("step_fl").
    
    if (1=0){
        print "hover script at " + round(OBJETIVOS_HOVER_ALT,2) + "m AGL(radar).".
        print " set to UP for safety on AG9".
        print " ".
        print "     AG7 : MUDA P/ HEADING to kill or inverte direcao vel".
        print "     AG8 : MUDA P/ HEADING BY (compass, pitch)".
        print "     AG9 : MUDA P/ HEADING (default)".
        print "     AG10: MUDA P/ ALTITUDE".
        print "     B   : FREIOS to exit HOVER".
        print "     back: ABORTA to head UP".
        //print "  TESTAR OQUE OCORRE QUANDO FICA SEM TRUSTAVALIABLE=0 ".
        //PRINT "    INFINITE OK TESTAR SE SAI SOZINHO DA FUNCAO".
        PRINT "PODE NAO SER UMA BOA IDEIA POIS ABANDONA O CONTROLE DE HEADING TB".
        
        print "testes:".
    
        //The easiest way of accessing the processor’s kOSProcessor structure (as long as your CPUs have their name tags set) is to use the following function:
        //PROCESSOR(volumeOrNameTag)
        //Parameters:	volumeOrNameTag – (Volume | String) can be either an instance of Volume or a string
        //Depending on the type of the parameter value will either return the processor associated with the given Volume or the processor with the given name tag.
        
        //A list of all processors can be obtained using the List command:
        print "A list of all processors can be obtained using the List command:".
        LOCAL ALL_PROCESSORS is 0.//cosiii
        LIST PROCESSORS IN ALL_PROCESSORS.
        
        //SERVIU PARA VERIFICAR QUE ISTO SOMENTE PEGA OS PROCESSADORES NA NAVE ATUAL
        PRINT ALL_PROCESSORS[0]:NAME.
        //PRINT ALL_PROCESSORS.

        //Finally, processors can be accessed directly, like other parts and modules:
        print "Finally, processors can be accessed directly, like other parts and modules:".
        PRINT SHIP:MODULESNAMED("kOSProcessor")[0]:VOLUME:NAME.

  		FOR modulos_que_pode_ser IN SHIP:MODULESNAMED("kOSProcessor")
		{
            print "modulo: " + modulos_que_pode_ser:VOLUME:NAME.
            
			if (modulos_que_pode_ser:VOLUME:NAME = "PID_HOVER_MSG")
			{
				PRINT "achou :  PID_HOVER_MSG " .
			}.
        }.
        

        // Sending and receiving messages

        // Then we can use kOSProcessor:CONNECTION to get the connection to that processor. This is how sender’s code could look like:

        // SET MESSAGE TO "undock". // can be any serializable value or a primitive
        // SET P TO PROCESSOR("probe").
        // IF P:CONNECTION:SENDMESSAGE(MESSAGE) {
        // PRINT "Message sent!".
        // }

    }.

    global dir_1 is 0.0.
    global dir_2 is 0.0.
    global dir_3 is 270.0.
    global compass_dir_1    is 270.0  . //NORT > 0  SUL >180 > ILHA 120    270=?
    global pitch_dir_2      is 90.0 . //UP
    
    global HOVER_CONTROL_HEADING_by_oposite_V_MIN   is OBJETIVOS_KILL_VSURF.//10.5
    global HOVER_CONTROL_ALTITUDE                   is "altitude".
    global HOVER_CONTROL_HEADING                    is "direcao".
    global HOVER_CONTROL_HEADING_by_compass         is "compass".
    global HOVER_CONTROL_HEADING_by_oposite         is "oposite".
    global hover_control                            is "naosei".

    on ag1 { 
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "dec1").
        preserve.     }.
    on ag2 { 
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "add1").
        preserve.     }.
    on ag3 { 
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "dec2").
        preserve.     }.
    on ag4 { 
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "add2").
        preserve.     }.
    on ag5 { 
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "dec3").
        preserve.     }.
    on ag6 {
        CONTROL_HOVER_ALT(hover_control, Col_Init, Linha_Init, "add3").
        preserve.     }.

    
    //agora controla direcao:
    on ag7 {        //HOVER_CONTROL_HEADING_by_oposite
        // To aim in the opposite of the surface velocity direction:
        CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING_by_oposite, Col_Init, Linha_Init, "set").
        preserve. 
    }.
    on ag8 {        //HOVER_CONTROL_HEADING_by_compass
        CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING_by_compass, Col_Init, Linha_Init, "set", 30).
        preserve. 
    }.
    
    on ag9 {        //HOVER_CONTROL_HEADING
        CONTROL_HOVER_ALT(HOVER_CONTROL_HEADING, Col_Init, Linha_Init, "set", 30, dir_1, dir_2, dir_3).
        preserve. 
    }.
    on ag10 {       //HOVER_CONTROL_ALTITUDE
        CONTROL_HOVER_ALT(HOVER_CONTROL_ALTITUDE, Col_Init, Linha_Init, "set", 30).
        preserve.
    }.

    on ABORT {      //reseta inclinacao e poe nave para cima
        CONTROL_HOVER_ALT("SET_UP", Col_Init, Linha_Init).
    }.
    
    //importante para quando liberar para o piloto
    set ship:control:pilotmainthrottle to 0.

    // hit "stage" until there's an active engine:
    local contador_stage_hover is 0.//ISTO NAO ESTA FUNCIONANDO
    until ship:availablethrust > 0 {
      wait 0.5.
      if ( KUniverse:ACTIVEVESSEL = ship){
          stage.
          //
      }
      else{
          //FORCE ACTIVE???
          //set KUniverse:ACTIVEVESSEL to SHIP. //NAO MUDA ENQUANTO EM aceleracao/atmosfera
          //ou forca: KUniverse:FORCESETACTIVEVESSEL(SHIP). //pode destruir a outra
          print "ERRO: HOVER: stage: NAVE NAO ATIVA!".
      }
        set contador_stage_hover to print_stat(tlogv, "HOVER_1: stage", contador_log, false, false, contador_stage_hover).
        //print_stat(tLOGv, msg,                        count_print,    reprint, debug, num_verb).

      if ABORTAR_SEQUENCIA("nocut"){BREAK.}.
    }.
    
    //STATUS_NAVE().
    //wait 0.1.
    
    // hover against gravity:
    lock    Fg          to ship:mass * body:mu /((ship:altitude + body:radius)^2).
    lock    am          to vang(up:vector, ship:facing:vector).
    lock    alt_radar   to alt:radar.
    global  T_star      is 0.0.
    lock    THROTTLE    to (T_star / MAX(0.01,ship:availablethrust)).

    // calculate initial hover PID gains
    local wn    is 1.0                          .
    local zeta  is 1.0                          .
    local Kp    is wn^2 * ship:mass             .
    local Kd    is 2 * ship:mass * zeta * wn    .
    local Ki    is 0.0                          .

    local hoverPID is pid_init( Kp, Ki, Kd, -Fg, Fg ). // Kp, Ki, Kd vals.

    gear on.  gear off. // on then off because of the weird KSP 'have to hit g twice' bug.
    print_stat(tlog, "HOVER:pid_init", contador_log).

    if (slow_loop_hover) {print_stat(tlog, "HOVER:slow loop ON", contador_log).} else {print_stat(tlog, "HOVER:slow loop OFF", contador_log).}
    if (Mostra_Bat_hover) {print_stat(tlog, "HOVER:show_bat ON", contador_log).} else {print_stat(tlog, "HOVER:show_bat OFF", contador_log).}
    if (display_block_hover) {print_stat(tlog, "HOVER:display ON", contador_log).} else {print_stat(tlog, "HOVER:display OFF", contador_log).}

    print_stat(tlog, "HOVER:pid_init", contador_log).
    STATUS_HOVER_1(0,0,0,0,0,0,0,False,True).//inicializa stat limpa tudo
    //STATUS_HOVER_1(0.0,0.0,0.0,0.0,0.0,0.0,0.0,False,False).//inicializa stat com unidades
    STATUS_HOVER_1(0,0,0,0,0,0,0,False,False,True).//inicializa stat com unidades e espaços

    TOGGLE AG9.//HOVER_CONTROL_HEADING

    until BRAKES {

        if ABORTAR_SEQUENCIA("nocut"){BREAK.}  .
        if (ship:availablethrust = 0){
            //print "SEM THRUST: ship:availablethrust = 0".//////////
            print_stat(tlog, "SEM THRUST: s:avThrust=0", contador_log).
            wait 1.5.//para esperar o possível STAGE

            break.
        }.
        if (hover_control = HOVER_CONTROL_HEADING_by_oposite) and (SHIP:VELOCITY:SURFACE:MAG < HOVER_CONTROL_HEADING_by_oposite_V_MIN){
            set hover_control to HOVER_CONTROL_HEADING.
            unlock steering.
            // Heading
            wait 0.01.
            set dir_1 to 0.0.
            set dir_2 to 0.0.
            set dir_3 to 0.0.
            LOCK STEERING TO Up + R(dir_1, dir_2, dir_3).
            HUDTEXT(hover_control + " : oposto : SHIP:VELOCITY:SURFACE : MAG=" + SHIP:VELOCITY:SURFACE:MAG + " v:MAG < " + HOVER_CONTROL_HEADING_by_oposite_V_MIN, 5, 2, 15, red, false).
            HUDTEXT("LOCK STEERING TO Up : " + hover_control, 5, 2, 15, red, false).
            display_block_MENU_HEADING(Col_Init,Linha_Init + 30).
            //print "controle obtido: SHIP:VELOCITY:SURFACE:MAG < 1.5 : ativando HOVER_CONTROL_HEADING".
            print_stat(tlog, "control obtido:S:V:S:M<"+HOVER_CONTROL_HEADING_by_oposite_V_MIN, contador_log).
            print_stat(tlog, ": HOVER_CTRL_HEAD", contador_log).
            
        }.
        // update hover pid and thrust
        set Kp to wn^2 * ship:mass.
        set Kd to 2 * ship:mass * zeta * wn.
        set hoverPID to PID_update(hoverPID, Kp, Ki, Kd, -Fg, Fg ).
        set T_star to (pid_seek_carlos( hoverPID, OBJETIVOS_HOVER_ALT, alt_radar ) + Fg)/ cos(am).
        //set THROTTLE to (T_star / ship:availablethrust).
        
		if (display_block_hover){
            if not(display_block_hover_exibido) { 
                set display_block_hover_exibido to display_block_NAMESS2D(Linha_Init).
            }
			display_block(Col_Init + 20,Linha_Init,OBJETIVOS_HOVER_ALT, alt_radar, Kp, Kd, Ki, Fg, am, THROTTLE, T_star,ship:availablethrust,
							dir_1, dir_2, dir_3,compass_dir_1, pitch_dir_2,
							SHIP:VERTICALSPEED,SHIP:VELOCITY:SURFACE:MAG,
							SHIP:VELOCITY:SURFACE:x,SHIP:VELOCITY:SURFACE:y,SHIP:VELOCITY:SURFACE:z,
							SHIP:MASS,Fg).
		}
        if (slow_loop_hover){
            
            //enviar velocity para PID_HOVER
            //HANDLE_CONNECTION_CORES("PID_HOVER_MSG", SHIP:VERTICALSPEED).
            local NOME_NAVE_ENVIAR_DADOS is "PID3_C3_MSG".
            if (CHECK_SE_NAVE_EXISTE(NOME_NAVE_ENVIAR_DADOS)){
                HANDLE_CONNECTION_VESSELS(VESSEL(NOME_NAVE_ENVIAR_DADOS), SHIP:VERTICALSPEED).
            }
            //TEST_DESENHA_VETORES(ship:velocity:surface).
            
            //ISSO NAO EH AQUI: SOMENTE TESTE:
            SHOW_CORE_MESSAGE_QUEUE(CORE:MESSAGES).//ver hhhhh eita poha NAO SERA ATUALIZADO DURANTE OS LOOPS DO PROGRAMA
            SHOW_VESSEL_MESSAGE_QUEUE(SHIP:MESSAGES).
        }.
		if (Mostra_Bat_hover){
			Mostra_Bat(TIME:SECONDS).
		}
        if (1=1){//display_stat_hover
            STATUS_HOVER_1(OBJETIVOS_HOVER_ALT, alt_radar, SHIP:VERTICALSPEED, SHIP:VELOCITY:SURFACE:MAG,
							SHIP:VELOCITY:SURFACE:x,SHIP:VELOCITY:SURFACE:y,SHIP:VELOCITY:SURFACE:z,
                             True).//true faz fast stat
        }

        wait 0.001.
    }.

    unlock throttle.
    set ship:control:pilotmainthrottle to THROTTLE.
    unlock throttle.
    
    print_stat(tlog, "HOVER:TERMINOU!", contador_log).
    debug(NOME_DA_FUNC, "------------------------------", hover_debug).
    debug(NOME_DA_FUNC, "LIBERANDO CONTROLES.", hover_debug).
    print_stat(tlog, "HOVER TERMINOU!", contador_log).
    debug(NOME_DA_FUNC, "------------------------------", hover_debug).
    beep("mission_compl").

}.

FUNCTION MOSTRA_HELP_HOVER{
    //parameter Col_Init, Linha_Init.  parameter mostra_labels_display_block is false.
        print_stat(tlog, "set to UP for safety on AG9", contador_log).
        print_stat(tlog, "", contador_log).
        print_stat(tlog, "AG7: HEAD to kill or inverte direcao vel", contador_log).
        print_stat(tlog, "AG8: HEAD BY (compass, pitch)", contador_log).
        print_stat(tlog, "AG9: HEAD (default)", contador_log).
        print_stat(tlog, "AG10: ALTITUDE", contador_log).
        print_stat(tlog, "B   : FREIOS to exit HOVER", contador_log).
        print_stat(tlog, "back: ABORTA to head UP", contador_log).
        print_stat(tlog, "", contador_log).
}

function CONTROL_HOVER_ALT{
    parameter CONFIG_HOVER_CTRL.
    parameter Col_Init, Linha_Init.
    parameter ACAHO_CTRL_HOVER is "config".
    //parameter tipo_de_operacao.
    parameter linha_ALT_INCIAL is 30.
    parameter dir_1y is 0.
    parameter dir_2x is 0.
    parameter dir_3z is 0.
    
    if      (ACAHO_CTRL_HOVER = "set"){
        if (CONFIG_HOVER_CTRL = HOVER_CONTROL_ALTITUDE){
            HUDTEXT(CONFIG_HOVER_CTRL, 5, 2, 15, red, false).
            set hover_control to CONFIG_HOVER_CTRL.
            display_block_MENU_ALTITUDE(Col_Init,Linha_Init + linha_ALT_INCIAL).        
        }
        else if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING ){
            set hover_control to CONFIG_HOVER_CTRL.
            unlock steering.
            // Heading
            wait 0.01.
            //set steering  
            LOCK STEERING TO Up + R(dir_1y, dir_2x, dir_3z).
            display_block_MENU_HEADING(Col_Init,Linha_Init + linha_ALT_INCIAL).
            HUDTEXT(CONFIG_HOVER_CTRL, 5, 2, 15, red, false).
        }
        else if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING_by_compass){
            set hover_control to CONFIG_HOVER_CTRL.
            unlock steering.
            wait 0.01.
            // A heading expressed as HEADING(compass, pitch). This will aim 30 degrees above the horizon, due south:(180,30)
            LOCK STEERING TO HEADING(compass_dir_1, pitch_dir_2).
            display_block_MENU_HEADING_by_compass(Col_Init,Linha_Init + linha_ALT_INCIAL).
            HUDTEXT(CONFIG_HOVER_CTRL, 5, 2, 15, red, false).
        }
        else if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING_by_oposite){
            set hover_control to CONFIG_HOVER_CTRL.
            unlock steering.
            wait 0.01.
            LOCK STEERING TO (-1) * SHIP:VELOCITY:SURFACE.
            print_stat(tlog, "AG7 : aim in the opposite of the surface velocity direction", contador_log).
            HUDTEXT(CONFIG_HOVER_CTRL + " : tenta oposto : SHIP:VELOCITY:SURFACE : MAG=" + SHIP:VELOCITY:SURFACE:MAG + " ate que v:MAG < " + HOVER_CONTROL_HEADING_by_oposite_V_MIN, 5, 2, 15, red, false).
        }
    }
    else if (ACAHO_CTRL_HOVER <> "set"){
        if (ACAHO_CTRL_HOVER = "add3"){
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT + 100. 
                    HUDTEXT("ALTITUDE + 100 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING){
                set dir_3 to dir_3 + 1.     
                HUDTEXT(CONFIG_HOVER_CTRL + " + 1 : " + dir_3, 5, 2, 15, red, false).}.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING_by_compass){
                set compass_dir_1 to compass_dir_1 + 90.     
                HUDTEXT(CONFIG_HOVER_CTRL + " + 90 : " + compass_dir_1, 5, 2, 15, red, false).
                }.
        }
        else if (ACAHO_CTRL_HOVER = "dec3"){
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT - 100. 
                    HUDTEXT("ALTITUDE - 100 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING){
                set dir_3 to dir_3 - 1.     
                HUDTEXT(CONFIG_HOVER_CTRL + " - 1 : " + dir_3, 5, 2, 15, red, false).
                }.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING_by_compass){
                set compass_dir_1 to compass_dir_1 - 90.     
                HUDTEXT(CONFIG_HOVER_CTRL + " - 90 : " + compass_dir_1, 5, 2, 15, red, false).
                }.
        }
        else if (ACAHO_CTRL_HOVER = "dec1"){
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT - 1. 
                    HUDTEXT("ALTITUDE - 1 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING){
                set dir_1 to dir_1 - 1.     
                HUDTEXT(CONFIG_HOVER_CTRL + " - 1 : " + dir_1, 5, 2, 15, red, false).                
                }.
            if (CONFIG_HOVER_CTRL = HOVER_CONTROL_HEADING_by_compass){
                set compass_dir_1 to compass_dir_1 - 1.
                HUDTEXT(CONFIG_HOVER_CTRL + " - 1 : " + compass_dir_1, 5, 2, 15, red, false).     
                }.
        }
        else if (ACAHO_CTRL_HOVER = "add2"){
            if (hover_control = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT + 10.
                    HUDTEXT("ALTITUDE + 10 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (hover_control = HOVER_CONTROL_HEADING){
                set dir_2 to dir_2 + 1.     
                HUDTEXT(hover_control + " + 1 : " + dir_2, 5, 2, 15, red, false).}.
            if (hover_control = HOVER_CONTROL_HEADING_by_compass){
                set pitch_dir_2 to pitch_dir_2 + 1.     
                HUDTEXT(hover_control + " + 1 : " + pitch_dir_2, 5, 2, 15, red, false).}.
        }
        else if (ACAHO_CTRL_HOVER = "add1"){
            if (hover_control = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT + 1. 
                    HUDTEXT("ALTITUDE + 1 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (hover_control = HOVER_CONTROL_HEADING){
                set dir_1 to dir_1 + 1.     
                HUDTEXT(hover_control + " + 1 : " + dir_1, 5, 2, 15, red, false).}.
            if (hover_control = HOVER_CONTROL_HEADING_by_compass){
                set compass_dir_1 to compass_dir_1 + 1.     
                HUDTEXT(hover_control + " + 1 : " + compass_dir_1, 5, 2, 15, red, false).}.
        }
        else if (ACAHO_CTRL_HOVER = "dec2"){
            if (hover_control = HOVER_CONTROL_ALTITUDE){
                    set OBJETIVOS_HOVER_ALT to OBJETIVOS_HOVER_ALT - 10. 
                    HUDTEXT("ALTITUDE - 10 : " + round(OBJETIVOS_HOVER_ALT,2), 5, 2, 15, red, false).
                }.
            if (hover_control = HOVER_CONTROL_HEADING){
                set dir_2 to dir_2 - 1.     
                HUDTEXT(hover_control + " - 1 : " + dir_2, 5, 2, 15, red, false).}.
            if (hover_control = HOVER_CONTROL_HEADING_by_compass){
                set pitch_dir_2 to pitch_dir_2 - 1.     
                HUDTEXT(hover_control + " - 1 : " + pitch_dir_2, 5, 2, 15, red, false).}.
        }
    }
    else if (CONFIG_HOVER_CTRL = "SET_UP"){
                //
        set dir_1 to 0.0.
        set dir_2 to 0.0.
        set dir_3 to 0.0.
        set compass_dir_1    to 0.0  . //NORT > 0  SUL >180
        set pitch_dir_2      to 90.0 . //UP
    }.

}
    // Call to update the display of numbers:
declare function display_block {            //mostra no tlista2
      declare parameter  startCol, startRow, seekAlt2, alt_radar2,Kp2, Kd2, Ki2, Fg2, am2, throttle2, T_star2,shipavthrst,
      dir_1_2,dir_2_2,dir_3_2,compass_dir_1_2, pitch_dir_2_2,
	  vertical_vel_2,ship_vel_mag_2,ship_vel_x_2,ship_vel_y_2,ship_vel_z_2,
	  shipmass, shippeso. // define where the block of text should be positioned
       
    set hops to inc(hops).
	
	local TWR_CALC to (shipavthrst / shippeso).//shippeso
	
        set contador_list2 to 0.
        set startRow to 0.
        local lmax to 9.
        print_stat(tlista2, round(seekAlt2,    2)       + "m",  startRow + 1,False,False,0,lmax).
        print_stat(tlista2, round(alt_radar2,    2)     + "m",  startRow + 2,False,False,0,lmax).
        print_stat(tlista2, round(Kp2,    2)            + "",    startRow + 3,False,False,0,lmax).
        print_stat(tlista2, round(Kd2,    2)            + "",    startRow + 4,False,False,0,lmax).
        print_stat(tlista2, round(Ki2,    2)            + "",    startRow + 5,False,False,0,lmax).
        print_stat(tlista2, round(Fg2,    2)            + "",    startRow + 6,False,False,0,lmax).
        print_stat(tlista2, round(am2,    2)            + "",    startRow + 7,False,False,0,lmax).
        print_stat(tlista2, round(throttle2,     2)     + "",    startRow + 8,False,False,0,lmax).
        print_stat(tlista2, round(T_star2,       2)     + "kN",  startRow + 9,False,False,0,lmax).
        print_stat(tlista2, round(shipavthrst,   2)     + "kN",  startRow + 10,False,False,0,lmax).
        print_stat(tlista2, dir_1_2                     + "",    startRow + 11,False,False,0,lmax).
        print_stat(tlista2, dir_2_2                     + "",    startRow + 12,False,False,0,lmax).
        print_stat(tlista2, dir_3_2                     + "",    startRow + 13,False,False,0,lmax).
        print_stat(tlista2, compass_dir_1_2             + "",    startRow + 14,False,False,0,lmax).
        print_stat(tlista2, pitch_dir_2_2               + "",    startRow + 15,False,False,0,lmax).
        print_stat(tlista2, round(vertical_vel_2,    2) + "m/s", startRow + 16,False,False,0,lmax).
        print_stat(tlista2, round(ship_vel_mag_2,    2) + "m/s", startRow + 17,False,False,0,lmax).
        print_stat(tlista2, round(ship_vel_x_2,      2) + "m/s", startRow + 18,False,False,0,lmax).
        print_stat(tlista2, round(ship_vel_y_2,      2) + "m/s", startRow + 19,False,False,0,lmax).
        print_stat(tlista2, round(ship_vel_z_2,      2) + "m/s", startRow + 20,False,False,0,lmax).
        print_stat(tlista2, round((TWR_CALC),      2) + "ratio", startRow + 21,False,False,0,lmax).
        if (slow_loop_hover){
        
            STATUS_NAVE().
            print_stat(tpasso, "SP aRAD:"+round(seekAlt2,    2)       + "m",  startRow + 5,False,False,0,lmax).
            print_stat(tpasso, "alt RAD:"+round(alt_radar2,    2)     + "m",  startRow + 6,False,False,0,lmax).
        }.
    }.
declare function display_block_NAMES_NU {//OBSOLETO = NAO_UTILIZADO
      declare parameter  startCol, startRow.

    set hops to inc(hops).
        print "Seek ALT_RADAR = " at (startCol,startRow).
        print "Cur ALT_RADAR  = " at (startCol,startRow+1).
        print "             Kp  " at (startCol,startRow+2).
        print "             Kd  " at (startCol,startRow+3).
        print "             Ki  " at (startCol,startRow+4).
        print "             Fg  " at (startCol,startRow+5).
        print "             am  " at (startCol,startRow+6).
        print "       throttle  " at (startCol,startRow+7).
        print "         T_star  " at (startCol,startRow+8).
        print " ship:av_thrust  " at (startCol,startRow+9).
        print "          dir_1  " at (startCol,startRow+10).
        print "          dir_2  " at (startCol,startRow+11).
        print "          dir_3  " at (startCol,startRow+12).        
        print "        compass  " at (startCol,startRow+13).
        print "          pitch  " at (startCol,startRow+14).        
        
        print "       vel:vert  " at (startCol,startRow+15).
        print "   surf:Vel:mag  "  at (startCol,startRow+16).
        print "     surf:Vel:x  "  at (startCol,startRow+17).
        print "     surf:Vel:y  "  at (startCol,startRow+18).
        print "     surf:Vel:z  "  at (startCol,startRow+19).
        print "            TWR  "  at (startCol,startRow+20).        
    }.
FUNCTION display_block_NAMESS2D{            //mostra no tlista
      declare parameter  startRow.//startCol, 

    set hops to inc(hops).
        set contador_list to 0.
        set startRow to 0.
        local lmax to 90.
        print_stat(tlista, "busc ALT_RADAR",   startRow + 1,False,False,0,lmax).
        print_stat(tlista, "Cur ALT_RADAR",    startRow + 2,False,False,0,lmax).
        print_stat(tlista, "Kp",               startRow + 3,False,False,0,lmax).
        print_stat(tlista, "Kd",               startRow + 4,False,False,0,lmax).
        print_stat(tlista, "Ki",    startRow + 5,False,False,0,lmax).
        print_stat(tlista, "Fg",    startRow + 6,False,False,0,lmax).
        print_stat(tlista, "am",    startRow + 7,False,False,0,lmax).
        print_stat(tlista, "throttle",         startRow + 8,False,False,0,lmax).
        print_stat(tlista, "T_star",           startRow + 9,False,False,0,lmax).
        print_stat(tlista, "ship:av_thrust",   startRow + 10,False,False,0,lmax).
        print_stat(tlista, "dir_1",  startRow + 11,False,False,0,lmax).
        print_stat(tlista, "dir_2",  startRow + 12,False,False,0,lmax).
        print_stat(tlista, "dir_3",  startRow + 13,False,False,0,lmax).
        print_stat(tlista, "compass",       startRow + 14,False,False,0,lmax).
        print_stat(tlista, "pitch",         startRow + 15,False,False,0,lmax).
        print_stat(tlista, "vel:vert",      startRow + 16,False,False,0,lmax).
        print_stat(tlista, "surf:Vel:mag",  startRow + 17,False,False,0,lmax).
        print_stat(tlista, "surf:Vel:x",  	startRow + 18,False,False,0,lmax).
        print_stat(tlista, "surf:Vel:y",  	startRow + 19,False,False,0,lmax).
        print_stat(tlista, "surf:Vel:z",  	startRow + 20,False,False,0,lmax).
        print_stat(tlista, "TWR",  			startRow + 21,False,False,0,lmax).		
    return True.
}.

declare function display_block_MENU_HEADING {//verificar se ja foi passado para menu:
      declare parameter  startCol, startRow.
    set hops to inc(hops).

        set contador_list to 0.
        set startRow to 0.
        print_stat(tlista, "AG1 : dir_1 -1 ao 0 (N)(+vy)", startRow+24).
        print_stat(tlista, "AG2 : dir_1 +1 ao 180(S)(-vy)", startRow+25).
        print_stat(tlista, "AG3 : dir_2 -1 ao 90()(-vx)", startRow+26).
        print_stat(tlista, "AG4 : dir_2 +1 ao 270()(+vx)", startRow+27).
        print_stat(tlista, "AG5 : dir_3 +1 hor    ", startRow+28).
        print_stat(tlista, "AG6 : dir_3 -1 antihor", startRow+29).
}.
    
declare function display_block_MENU_HEADING_by_compass {
      declare parameter  startCol, startRow.
    set hops to inc(hops).

        set contador_list to 0.
        set startRow to 0.
        print_stat(tlista, "AG1 : compass -1 ao COMPASS          ", startRow+24).
        print_stat(tlista, "AG2 : compass +1 ao                  ", startRow+25).
        print_stat(tlista, "AG3 : pitch -1 ao PITCH INCLINACAO   ", startRow+26).
        print_stat(tlista, "AG4 : pitch +1 ao                    ", startRow+27).
        print_stat(tlista, "AG5 :                                ", startRow+28).
        print_stat(tlista, "AG6 :                                ", startRow+29).        
    }.
declare function display_block_MENU_ALTITUDE {
    
      declare parameter  startCol, startRow.
    set hops to inc(hops).

        set contador_list to 0.
        set startRow to 0.
        print_stat(tlista, "AG1 : alt -1", startRow+24).
        print_stat(tlista, "AG2 : alt +1", startRow+25).
        print_stat(tlista, "AG3 : alt -10", startRow+26).
        print_stat(tlista, "AG4 : alt +10", startRow+27).
        print_stat(tlista, "AG5 : alt -100", startRow+28).
        print_stat(tlista, "AG6 : alt +100", startRow+29).
        
    }.

FUNCTION ABORTAR_SEQUENCIA{
    parameter cortar_trot is "cut".
    
		if (ABORT_SEQUENCIA) {//detecta comando de abortar:
            if (cortar_trot="nocut"){}.
            if (cortar_trot="cut"){CUT_THROTTLE_STOP().}.
			DEBUG("ABORTAR_SEQUENCIA", "SEQUENCIA DE CORTE!").
			print_stat(tlog,"ABORTANDO CONTROLE",contador_log).
			//BREAK. 
            //return True.
        }.
        
    return ABORT_SEQUENCIA.
}.

function ATIVA_REGISTRO_VOO{
    //parameter INDICADOR_ESTADO.
    parameter VALOR_ESTADO.
    parameter ARQUIVO_NAVE.// is "1:/nave_.status".
    parameter MODO is "normal".

    LOCAL INDICADOR_ESTADO is "STATUS_VOO".

    set ARQUIVO_NAVE to "1:/" + ARQUIVO_NAVE + ".status".

        if (MODO = "normal"){
            log INDICADOR_ESTADO + "=" + VALOR_ESTADO to ARQUIVO_NAVE.
        }

        if (MODO = "exclui"){
            if exists(ARQUIVO_NAVE){
                deletepath(ARQUIVO_NAVE).
            }
            else{
                return false.
            }
        }

    return true.
}

function ATIVA_REGISTRO_cfg_fly{
    parameter INDICADOR is "telnet ativado".
    parameter ARQUIVO is "1:/telnet_.cfg".

	local NOME_DA_FUNC is "ATIVA_REGISTRO_cfg_fly".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    DEBUG(NOME_DA_FUNC,"Gravando arquivo ["+ARQUIVO+"] conteudo add["+INDICADOR+"]",False).

        log INDICADOR to ARQUIVO.

    return true.
}
	
