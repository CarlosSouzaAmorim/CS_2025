@LAZYGLOBAL OFF.
//c3_ship_cfg.ks
// 9 funcoes: 331 linhas
//recompila

//uses: BLAHklhhkjjhkjh
runoncepath("c3_init_vars").

// ====      FUNCOES BASE PARA CONFIG SHIP =================================================================================

FUNCTION TEST_HIGLIGHT{
    set hops to inc(hops).
	list elements in elist.
	// now eList is a list of elements from the vessel.

	// Color the first element pink
	SET foo TO HIGHLIGHT( elist[0], HSV(350,0.25,1) ).

	// Turn the highlight off
	SET foo:ENABLED TO FALSE.


	// Turn the highlight back on
	SET foo:ENABLED TO TRUE.
	SET foo:COLOR TO HSV(350,0.25,1) .

			// Examples of Using the Name

			// Only if you expected to get
			// exactly 1 such part, no more, no less.
			SET myPart TO SHIP:PARTSDUBBED("my nametag here")[0].

			// OR

			// Only if you expected to get
			// exactly 1 such part, no more, no less.
			SET myPart TO SHIP:PARTSTAGGED("my nametag here")[0].

			// Handling the case of more than
			// one part with the same nametag,
			// or the case of zero parts with
			// the name:
			SET allSuchParts TO SHIP:PARTSDUBBED("my nametag here").

			// OR

			SET allSuchParts TO SHIP:PARTSTAGGED("my nametag here").

			// Followed by using the list returned:
			FOR onePart IN allSuchParts {
			  // do something with onePart here.
			}



	}.
FUNCTION TEST_STEERING{
    set hops to inc(hops).
// http://ksp-kos.github.io/KOS_DOC/commands/flight/cooked.html#cooked-tuning

//http://ksp-kos.github.io/KOS_DOC/structures/misc/steeringmanager.html#steeringmanager
// Display the ship facing, target facing, and world coordinates vectors.
SET STEERINGMANAGER:SHOWFACINGVECTORS TO TRUE.

// Change the torque calculation to multiply the available torque by 1.5.
SET STEERINGMANAGER:ROLLTORQUEFACTOR TO 1.5. 

 // structure SteeringManager
    // Suffix 	Type 	Description
    // PITCHPID 	PIDLoop 	The PIDLoop for the pitch rotational velocity PID.
    // YAWPID 	PIDLoop 	The PIDLoop for the yaw rotational velocity PID.
    // ROLLPID 	PIDLoop 	The PIDLoop for the roll rotational velocity PID.
    // ENABLED 	boolean 	Returns true if the SteeringManager is currently controlling the vessel
    // TARGET 	Direction 	The direction that the vessel is currently steering towards
    // RESETPIDS() 	none 	Called to call RESET on all steering PID loops.
    // SHOWFACINGVECTORS 	boolean 	Enable/disable display of ship facing, target, and world coordinates vectors.
    // SHOWANGULARVECTORS 	boolean 	Enable/disable display of angular rotation vectors
    // SHOWSTEERINGSTATS 	boolean 	Enable/disable printing of the steering information on the terminal
    // WRITECSVFILES 	boolean 	Enable/disable logging steering to csv files.
    // PITCHTS 	scalar (s) 	Settling time for the pitch torque calculation.
    // YAWTS 	scalar (s) 	Settling time for the yaw torque calculation.
    // ROLLTS 	scalar (s) 	Settling time for the roll torque calculation.
    // MAXSTOPPINGTIME 	scalar (s) 	The maximum amount of stopping time to limit angular turn rate.
    // ANGLEERROR 	scalar (deg) 	The angle between vessel:facing and target directions
    // PITCHERROR 	scalar (deg) 	The angular error in the pitch direction
    // YAWERROR 	scalar (deg) 	The angular error in the yaw direction
    // ROLLERROR 	scalar (deg) 	The angular error in the roll direction
    // PITCHTORQUEADJUST 	scalar (kN) 	Additive adjustment to pitch torque (calculated)
    // YAWTORQUEADJUST 	scalar (kN) 	Additive adjustment to yaw torque (calculated)
    // ROLLTORQUEADJUST 	scalar (kN) 	Additive adjustment to roll torque (calculated)
    // PITCHTORQUEFACTOR 	scalar 	Multiplicative adjustment to pitch torque (calculated)
    // YAWTORQUEFACTOR 	scalar 	Multiplicative adjustment to yaw torque (calculated)
    // ROLLTORQUEFACTOR 	scalar 	Multiplicative adjustment to roll torque (calculated)


	}.

FUNCTION TEST_PARTS_OF_SHIP{//PROBLEMAS BASE:
    set hops to inc(hops).

//PROBLEMAS BASE:
//qual é a garantia de que o modulo vai estar presente na parte?
//como especificar a parte que contem o modulo?
//QUAL PROCESSADOR EM SHIP ESTA RODANDO O PROGRAMA? core:part

//manda fechar todos os terminais
//manda abrir o terminal atual: como se ele nao sabe o modulo? CORE:PART
//verifica o processador com o terminal ativo

// print ship:parts.
// LIST of 4 items:
// [0] = "PART(HECS2.ProbeCore,uid=2387066880)"
// [1] = "PART(kOSMachineRad,uid=2950397952)"
// [2] = "PART(KAL9000,uid=1794981888)"
// [3] = "PART(KR-2042,uid=2358312960)"

//suffixmames of PART:
// [0] = "ALLMODULES"
// [6] = "GETMODULE"
// [7] = "GETMODULEBYINDEX"
// [8] = "HASMODULE"
// [9] = "HASPARENT"
// [16] = "MODULES"
}.

FUNCTION TEST_CORE{
    set hops to inc(hops).
	// Core
	
	// Core represents your ability to identify and interact directly with the running kOS processor.
	// You can use it to access the parent vessel, or to perform operations on the processor’s part.
	// You obtain a CORE structure by using the bound variable core.
	
	// structure CORE
    // Members¶ Suffix 	Type
    // All suffixes of kOSProcessor 	CORE objects are a type of kOSProcessor
    // VESSEL 	        Vessel
    // ELEMENT 	        Element
    // VERSION 	        Version
    // CURRENTVOLUME 	Volume
    // MESSAGES 	    MessageQueue
	
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
	
	// switch to CORE:volume.
	// print path().
	// 1:/
	
	// print core:part.
	// PART(KAL9000,uid=1794981888)
	
	// print path(CORE:VOLUME).
	// 1:/
}.

FUNCTION TEST_PARTS_GET_MODULES{ //acao_get_kos_space  // search for "kOSProcessor" in "kOSMachineRad"
		//DEPENDENCIAS: VARIAVEIS INICIAIS: ACOES GET_PART_MOD
		//				FUNCOES: CHECK_OPTIONS
		parameter acao_get_kos_space.
		parameter PARTE_LOCALIZAR.// is "kOSMachineRad".
		parameter MODULO_LOCALIZAR      is "kOSProcessor".//o processor vai sempre existir?
		parameter ESPERAR_PASSOS 	        is false.
		parameter debug_parts		    is False.
		
    set hops to inc(hops).
		local ENCONTROU_PARTE is false.
		local ENCONTROU_MODULO is false.
		
		local PATH_ANTES_DA_MANOBRA is "".
		local MOD is list().
		local STRING_DO_PATH is "".
		
		//VAI MUDAR DE PATH MAS VAI RETORNAR NO FINAL (ATENCAO SE ESTA FOR A INTENCAO).
		set PATH_ANTES_DA_MANOBRA to path().
	
		for P IN SHIP:PARTS {//loop pelas partes da NAVE: ------------------------------------------------------------------
			if (P:NAME = PARTE_LOCALIZAR){//ENCONTROU_PARTE
				set ENCONTROU_PARTE to True.
				//for M in P:MODULES {
				//print M:ALLFIELDS.

				if (debug_parts){//mostra modulos nesta parte
					print ("MODULES FOR PART NAMED " + P:NAME).
					print P:MODULES.
				}.
				
				for M IN P:MODULES{//loop pelos MODULOS da parte da NAVE: --------------------------------------------------
					if (debug_parts){//mostra modulo atual do loop:
						PRINT M.
					}.
					if (M = MODULO_LOCALIZAR){//ENCONTROU_MODULO
						set ENCONTROU_MODULO to True.
						SET MOD TO P:GETMODULE(MODULO_LOCALIZAR).
						if (debug_parts){//achou debug: //mostra infos do VOLUME no modulo econtrado:
							print "achou :" + MODULO_LOCALIZAR.
							PRINT MOD:VOLUME:CAPACITY.
							PRINT MOD:VOLUME:freespace.
							PRINT MOD:VOLUME:NAME.
							PRINT MOD:VOLUME:ROOT.
						}
						
						if (MOD:hassuffix("volume")){//PARA OPERACOES COM VOLUMES:free, size, name, root, cd, 
							//se os parametros de PART e MODULE forem encontrados mas a instrucao for para pegar volume infos
							// E este module nao possuir vai dar erro
							
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_FREE){ RETURN MOD:VOLUME:freespace. }.
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_SIZE){ RETURN MOD:VOLUME:CAPACITY.  }.
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_NAME){ RETURN MOD:VOLUME:NAME.      }.
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_ROOT){ RETURN MOD:VOLUME:ROOT.      }.
							
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_CD_KOS){//muda para o VOLUME do modulo kOS: return -1
								switch to MOD:VOLUME.//tudo isso e para o KOS ERA SO FAZER: CORE:VOLUME
							RETURN -1.} //SE NAO SAIR AQUI O FINAL DA FUNCAO VAI BAGUNCAR}.
							
							if (acao_get_kos_space = ACAO_GET_PART_MODULES_INFOS_GET_NUM){ //get_kos_DRIVE_num_name
							
								//FAZER SALVAR A PASTA QUE ESTAVA ANTES, MUDAR PARA O VOLUME ENCONTRADO no modulo 
								//e extrair somente a parte antes dos dois pontos ":"
								//depois voltar para a pasta que estava para nao inteferir
								//PORQUE nao da para usar volume:name? porque ocorre que alguns retornam "" no nome dos drives 1, 2 (porque nao tem nome msm)
								
								
								//switch to MOD:VOLUME.//fazer nao precisa disso: 
								//set STRING_DO_PATH to path():tostring.
								set STRING_DO_PATH to path(MOD:VOLUME):tostring.
								//cd(PATH_ANTES_DA_MANOBRA).//restaura localizacao anterior antes de sair.
								
								return retira_numero_ou_nome_de_volume_path(STRING_DO_PATH).
								}.
						}
						else{
							print "ERRO: PART_GET_MOD: O modulo nao possui o suffixo VOLUME.".
						}
					}.
				}.

				if (debug_parts){//mostra opcoes do modulo:
					print ("GETFIELD AND SETFIELD ON:").
					print MOD:ALLFIELDS.
					print ("DOEVENT ON:").
					print MOD:ALLEVENTS.
					print ("USE DOACTION ON:").
					print MOD:ALLACTIONS.
				}.
			}.
			if (ESPERAR_PASSOS){wait 0.5.}.
		}.
		
		//conferencia da existencia dos modulos e partes: ------------------------------------------------------------------
		if not (ENCONTROU_MODULO){
			print "ERRO: GET_KOS_SPACE: O modulo:[" + MODULO_LOCALIZAR + "] nao foi encontrado na nave:[" + SHIP:NAME + "]".
			}.
		if not(ENCONTROU_PARTE){
			print "ERRO: GET_KOS_SPACE: A parte:[" + PARTE_LOCALIZAR + "] nao foi encontrado na nave:[" + SHIP:NAME + "]".
			}.
			
		//VOLTA AO ANTERIOR > FAZER : pode ser somente nas funcoes que muda de pasta ---------------------------------------
		cd(PATH_ANTES_DA_MANOBRA).
		if (debug_parts){
			print "Atual: " + path().
		}.

		CHECK_OPTIONS(	acao_get_kos_space,"PARTS_GET_MODULES",6,
					ACAO_GET_PART_MODULES_INFOS_FREE,
					ACAO_GET_PART_MODULES_INFOS_SIZE,
					ACAO_GET_PART_MODULES_INFOS_NAME,
					ACAO_GET_PART_MODULES_INFOS_ROOT,
					ACAO_GET_PART_MODULES_INFOS_CD_KOS,
					ACAO_GET_PART_MODULES_INFOS_GET_NUM
					).
	}.
	
// A library of functions to calculate navball-based directions:

// This file is distributed under the terms of the MIT license, (c) the KSLib team

//@lazyglobal off.

function east_for {
  parameter ves.
    set hops to inc(hops).

  return vcrs(ves:up:vector, ves:north:vector).
}

function compass_for {
  parameter ves.

    set hops to inc(hops).
  local pointing is ves:facing:forevector.
  local east is east_for(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 { 
    return 360 + result.
  } else {
    return result.
  }
}

function pitch_for {
  parameter ves.
    set hops to inc(hops).

  return 90 - vang(ves:up:vector, ves:facing:forevector).
}

function roll_for {
  parameter ves.
     set hops to inc(hops).
 
  if vang(ship:facing:vector,ship:up:vector) < 0.2 { //this is the dead zone for roll when the ship is vertical
    return 0.
  } else {
    local raw is vang(vxcl(ship:facing:vector,ship:up:vector), ves:facing:starvector).
    if vang(ves:up:vector, ves:facing:topvector) > 90 {
      if raw > 90 {
        return 270 - raw.
      } else {
        return -90 - raw.
      }
    } else {
      return raw - 90.
    }
  } 
}.




