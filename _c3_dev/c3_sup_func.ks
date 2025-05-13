@LAZYGLOBAL OFF.
//c3_sup_func.ks
// 1 funcoes: 80 linhas
//recompila

//	uses:
//PRINT_BIG_ERROR_NOCLS_TIMED
//compladkfaldsfj

runoncepath("c3_scr_msg").


// ==== SUPORTE PARA OUTRAS FUNCOES ========================================================================================
	
function CHECK_OPTIONS{		//CHEC IF AT LEAST ONE OPTION WAS GIVEN AS PARAMETER TO THE FUNCTION	
	//if not entao foi um erro de programacao

	parameter OPCAO_GERAL. //parametro passado para a funcao fazer algo.
	parameter NOME_DA_FUNC_REPASSADA.
	parameter NUMERO_DE_OPCOES.
	parameter OPCAO_1       .//pelo menos um parametro tem que ser verificado.
	parameter OPCAO_2  is "".
	parameter OPCAO_3  is "".
	parameter OPCAO_4  is "".
	parameter OPCAO_5  is "".
	parameter OPCAO_6  is "".
	parameter OPCAO_7  is "".
	parameter OPCAO_8  is "".
	parameter OPCAO_9  is "".
	parameter OPCAO_10 is "".
	parameter OPCAO_11 is "".//enviar uma mensagem opcional no ultimo parametro para o debug
	parameter OPCAO_12 is "".

	local NOME_DA_FUNC is "CHECK_OPTIONS".
    //trace(NOME_DA_FUNC).
    set hops to inc(hops).

	local debug_check_opt 				is False. //esse vai ser definido pelo numero de parametros
	local pelo_menos_uma_opcao_existe 	is False.
	local lista_de_opcoes 	is LIST().
	local CONT_OPC			is 0.
	
	if (NUMERO_DE_OPCOES > 12){print "ERRO: CHECK_OPTIONS: EXECSSOASDFKJKAJSDK DE PARAMETROS".}.
	
	lista_de_opcoes:add(OPCAO_1).//comecao no 0
	lista_de_opcoes:add(OPCAO_2).
	lista_de_opcoes:add(OPCAO_3).
	lista_de_opcoes:add(OPCAO_4).
	lista_de_opcoes:add(OPCAO_5).
	lista_de_opcoes:add(OPCAO_6).
	lista_de_opcoes:add(OPCAO_7).
	lista_de_opcoes:add(OPCAO_8).
	lista_de_opcoes:add(OPCAO_9).
	lista_de_opcoes:add(OPCAO_10).
	lista_de_opcoes:add(OPCAO_11).
	lista_de_opcoes:add(OPCAO_12).

	if (lista_de_opcoes[(NUMERO_DE_OPCOES + 1) - 1] <> ""){
		set debug_check_opt to true.
	}

	from {set CONT_OPC to 0.}
	until (CONT_OPC > (NUMERO_DE_OPCOES - 1 ))//-1 pois comeca no zero list(0)
	step {set CONT_OPC to CONT_OPC + 1.}
	do {
			if ( OPCAO_GERAL = lista_de_opcoes[CONT_OPC] )
				{
					set pelo_menos_uma_opcao_existe to True.
				}.
		}
	
	if not( pelo_menos_uma_opcao_existe )
	{
		print "ERRO: " + NOME_DA_FUNC_REPASSADA + ": Nenhuma acao valida passada a funcao! :[" + OPCAO_GERAL +"]".
		PRINT_BIG_ERROR_NOCLS_TIMED("ERRO: " + NOME_DA_FUNC_REPASSADA + ": Nenhuma acao valida passada a funcao! :[" + OPCAO_GERAL +"]").
		if (debug_check_opt)
		{
			print "ERRO: DEBUG_CHECK: msg opc: [" + lista_de_opcoes[CONT_OPC + 1] + "]".
				//ATENCAO: enviar mensagem no parametro seguinte
		}.
	}.
	
	RETURN 	pelo_menos_uma_opcao_existe.	
}	.

FUNCTION DETECT_TYPE{
    set hops to inc(hops).
    // This is true even of primitive value types such as 1.0 or false or 42 or "abc". For example, you can do:

// print Mun:typename().
// Body   // <--- system prints this

// print ("hello"):typename().
// String // <--- system prints this

// print (12345.678):typename().
// Scalar // <--- system prints this


// Structure:TYPENAME
    // Type:	String
    // Access:	Get only

    // Gives the name of the type of the object, in kOS terminology.

    // Type names correspond to the types mentioned throughout these documentation pages, at the tops of the tables that list suffixes.

    // Examples:

    // set x to 1.
    // print x:typename
    // Scalar

    // set x to 1.1.
    // print x:typename
    // Scalar

    // set x to ship:parts[2].
    // print x:typename
    // Part

    // set x to Mun.
    // print x:typename
    // Body

    // The kOS types described in these documentaion pages correspond one-to-one with underlying types in the C# code the implements them. However they don’t have the same name as the underlying C# names. This returns an abstraction of the C# name. There are a few places in the C# code where an error message will mention the C# type name instead of the kOS type name. This is an issue that might be resolved in a later release.

// Structure:ISTYPE
    // Parameter name:	string name of the type being checked for
    // Type:	Boolean
    // Access:	Get only

    // This is True if the value is of the type mentioned in the name, or if it is a type that is derived from the type mentioned in the name. Otherwise it is False.

    // Example:

    // set x to SHIP.
    // print x:istype("Vessel").
    // True
    // print x:istype("Orbitable").
    // True
    // print x:istype("Structure").
    // True.
    // print x:istype("Body").
    // False
    // print x:istype("Vector").
    // False
    // print x:istype("Some bogus type name that doesn't exist").
    // False


}.
