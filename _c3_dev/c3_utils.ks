@LAZYGLOBAL OFF.
//c3_utils.ks
// 8 funcoes: 240 linhas
//recompila


// ====      FUNCOES BASE PARA OUTRAS FUNCOES ==============================================================================

function inc{                   //incrementa variável by value:                         set VAR to inc(VAR,*STEP_TO_INCREMENT).
				//inc nao funciona : inc(var). pois os parametros sao passado by value
						// set VAR to inc(VAR). FUNCIONA
						// set VAR to inc(VAR,2). FUNCIONA
	parameter VAR_TO_INCREMENT.
	parameter STEP_TO_INCREMENT is 1.
    set hops to hops +1.
	//set VAR_TO_INCREMENT to VAR_TO_INCREMENT + STEP_TO_INCREMENT.
	return (VAR_TO_INCREMENT + STEP_TO_INCREMENT).
}.
FUNCTION CONCAT_STR_A{          //reduz a string a len_max e adiciona ">" no final.     CONCAT_STR_A(string_inteira3,larg_max_car3).
	parameter string_inteira.
	parameter len_max.
    parameter CONCAT_STR_debug is False.
	
	local NOME_DA_FUNC is "CONCAT_STR_A".
    trace(NOME_DA_FUNC, CONCAT_STR_debug).
    set hops to inc(hops).

	local nova_string_truncada is "".
	debug(NOME_DA_FUNC, "type do string_inteira:" + string_inteira:typename(),CONCAT_STR_debug).//testa isso
    
	if string_inteira:length > len_max {
		//indicar que foi truncada a msg[OK] : + ">"
		 
		//print "len_max:" + len_max 				at (25,25).
		//print "pos init remov[index 0..i]:" + (len_max - 1) at (25,26).
		//print "length:" + string_inteira:length at (25,27).
		//print "(string_inteira:length - (len_max - 1)):" + (string_inteira:length - (len_max - 1))		at (25,28).
		set nova_string_truncada to string_inteira:REMOVE(len_max - 1,(string_inteira:length - (len_max - 1))) + ">". //-1 para por o > no final.
		//print "nova_string:" + nova_string_truncada at (25,29).
		}
	else { set nova_string_truncada to string_inteira. }.

	RETURN nova_string_truncada.//RETURN sai da funcao antecipadamente. Código após não é executado!
	
	//	String:REMOVE(index,count)
	//  Parameters:	
	//    index – Scalar (integer) position of the string from which characters will be removed from the resulting string
    //    count – Scalar (integer) number of characters that will be removing from the resulting string
	//
	//  Return type:	
	//  String : Returns a new string out of this string with the given count of characters removed starting at the given index.
}.
FUNCTION CONCAT_STR_C_NU{       //NÃO UTILIZADA: teste de FOR em string                 CONCAT_STR_C(*string_percorrer).
	parameter str is "abcde".
    set hops to inc(hops).
	//fazer
    local NOME_DA_FUNC is "CONCAT_STR_C".    

	FOR c IN str {
		//PRINT c.
        debug(NOME_DA_FUNC,c).
	}
}.
	
function enche_de_espacos{      //completar uma string com espacos                      enche_de_espacos( len_e,*STRING_INICIAL,*OUTRO_SIMBOLO_SPC).
	parameter numero_de_espacos.
	parameter new_spc_put 		is "" . //STRING_INICIAL: sera possivel completar uma string com espacos
	parameter OUTRO_SIMBOLO_SPC is " ". //o padrao é espaços mas pode ser especificado outro.
    set hops to inc(hops).

		from {local put is 0.}
		until (put = numero_de_espacos)
		step{set put to inc(put).}
		do{ set new_spc_put to new_spc_put + OUTRO_SIMBOLO_SPC.}.
		
	return new_spc_put.
}.
function completa_de_espacos{      //completar uma string com espacos  ATE LEN_MAX                    enche_de_espacos( len_e,*STRING_INICIAL,*OUTRO_SIMBOLO_SPC).
	parameter comp_max.
	parameter new_spc_put 		is "" . //STRING_INICIAL: sera possivel completar uma string com espacos
	parameter OUTRO_SIMBOLO_SPC is " ". //o padrao é espaços mas pode ser especificado outro.
    set hops to inc(hops).

    if (new_spc_put:length < comp_max){
        
		from {local put is new_spc_put:length.}
		until (put = comp_max)
		step{set put to inc(put).}
		do{ set new_spc_put to new_spc_put + OUTRO_SIMBOLO_SPC.}.
		
    }.
	return new_spc_put.
}.
FUNCTION formata_p_print_stat{//SUBSTITUI CONCAT_STR_A E enche_de_espacos
	parameter comp_max.
	parameter new_spc_put 		is "" . //STRING_INICIAL
	parameter OUTRO_SIMBOLO_SPC is " ". //o padrao é espaços mas pode ser especificado outro.
    parameter formata_p_print_debug is False.
    
	local NOME_DA_FUNC is "formata_p_print_stat".
    trace(NOME_DA_FUNC, formata_p_print_debug).
     set hops to inc(hops).
   
	//debug(NOME_DA_FUNC, "type do new_spc_put:" + new_spc_put:typename(),formata_p_print_debug).//testa isso
    
    debug(NOME_DA_FUNC, "new_spc_put:["+new_spc_put+"] comp_max["+comp_max+"] preenche_com["+OUTRO_SIMBOLO_SPC+"]", formata_p_print_debug).

	if new_spc_put:length > comp_max {//TRUNCA : cuidado: ATENCAO: VERISSO: esta expressão dá erro quando o msg é um escalar
	    debug(NOME_DA_FUNC, "msg_len["+new_spc_put:length+"] > comp_max["+comp_max+"] REMOVE["+(new_spc_put:length - (comp_max - 1))+"]", formata_p_print_debug).
		set new_spc_put to new_spc_put:REMOVE(comp_max - 1,(new_spc_put:length - (comp_max - 1))) + ">".
	    debug(NOME_DA_FUNC, "new_spc_put["+new_spc_put+"]", formata_p_print_debug).
	}
	else if (new_spc_put:length < comp_max){
	    debug(NOME_DA_FUNC, "LOOP from["+new_spc_put:length+"] until["+comp_max+"] add+["+OUTRO_SIMBOLO_SPC+"]", formata_p_print_debug).
		from {local put is new_spc_put:length.}
		until (put = comp_max)
		step{set put to inc(put).}
		do{ set new_spc_put to new_spc_put + OUTRO_SIMBOLO_SPC.}.
	    debug(NOME_DA_FUNC, "LOOP done ["+new_spc_put+"] new_len["+new_spc_put:length+"]", formata_p_print_debug).
    }
    else{

    }.

    debug(NOME_DA_FUNC, "return:["+new_spc_put+"]", formata_p_print_debug).
	RETURN new_spc_put.
}.

FUNCTION TEST_CONVERT_CHARS_NU{ //NÃO UTILIZADA: teste de char(): numero unicode do char em string          TEST_CONVERT_CHARS_NU(*n_car_INIC,*n_car_max).
		parameter n_car_test is 0.
		parameter n_car_max is 1000.
     set hops to inc(hops).
       
		FROM {set n_car_test to 0.}
		UNTIL (n_car_test > 1000)
		STEP {set n_car_test to n_car_test + 1. }
		DO
			{
				char(n_car_test).
			}
			
		//CHAR(a).
		//	Parameters:	      a – (number)
		//Returns:   (string) single-character string containing the unicode character specified
		//PRINT CHAR(34) + "Apples" + CHAR(34). // prints "Apples"

		//UNCHAR(a)
		//Parameters:	       a – (string)
		//Returns:	   (number) unicode number representing the character specified
		//PRINT UNCHAR("A"). // prints 65
	}.

FUNCTION TESTA_SE_STR_EH_NUMERO{//nao usar isso, usar STRING:TONUMBER //testa se string e composta SOMENTE de numeros (sem ponto nem virgula)     TESTA_SE_STR_EH_NUMERO(STR_COMPOSTA_DE_NUMERO).
	parameter STR_COMPOSTA_DE_NUMERO    to ""   .
    //FAZER:
	parameter STR_SEPARADOR_DEC         to ","  .	//FAZER	PARA REAL
	parameter STR_SEPARADOR_MILHAR      to "."  .	//FAZER
	parameter debug_str_num			    is False.
    set hops to inc(hops).
	
	local encontrou_nao_numero is False.
	local count_s is 0.
	
		if (debug_str_num)
		{
								print STR_COMPOSTA_DE_NUMERO:typename.
								print STR_COMPOSTA_DE_NUMERO:istype("Scalar").	
								print STR_COMPOSTA_DE_NUMERO:tostring.	
								print STR_COMPOSTA_DE_NUMERO:length.	
								//PRINT STR_COMPOSTA_DE_NUMERO:suffixnames.
								set STR_COMPOSTA_DE_NUMERO to STR_COMPOSTA_DE_NUMERO:tostring.
								print "fim test str to int.".
		}.

	if (STR_COMPOSTA_DE_NUMERO = "")
	{
		RETURN False.
	}
	else
	{
		set ENCONTROU_NAO_NUMERO to False.
		
			from {set count_s to 0.}
			until(count_s = STR_COMPOSTA_DE_NUMERO:length )
			step{set count_s to count_s + 1.}
			do
			{
				//print STR_COMPOSTA_DE_NUMERO[count_s].
											if ( ( STR_COMPOSTA_DE_NUMERO[count_s] <> "0" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "1" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "2" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "3" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "4" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "5" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "6" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "7" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "8" ) and 
												 ( STR_COMPOSTA_DE_NUMERO[count_s] <> "9" ) )
												 {
													set ENCONTROU_NAO_NUMERO to True.
												 }.
			}
		RETURN not(ENCONTROU_NAO_NUMERO).								
		
		if (ENCONTROU_NAO_NUMERO){ RETURN False.}
		else{RETURN True.}.

	}.
}.							
FUNCTION CONVERTE_STR_TO_NUM{   //nao usar isso, usar STRING:TONUMBER //provisorio para NUMEROS INTEIROS SEM SINAL, SEM VIRGULA OU PONTOS
	parameter STR_COMPOSTA_DE_NUMERO.
    parameter debug_STR_to_NUM                is False.
    set hops to inc(hops).
    
	local count_s is 0.
	local valor_do_num_dec is 0.
	local prim_alg is 0.
		
	if (TESTA_SE_STR_EH_NUMERO(STR_COMPOSTA_DE_NUMERO))
	{
	
			//provisorio para NUMEROS INTEIROS SEM SINAL, SEM VIRGULA OU PONTOS
			
			from {set count_s to (STR_COMPOSTA_DE_NUMERO:length - 1).}
			until( count_s < 0 )
			step{set count_s to count_s - 1.} //pega a string invertida a string
			do
			{
				debug("STR_TO_INT", STR_COMPOSTA_DE_NUMERO[count_s], debug_STR_to_NUM).
                //PRINT STR_COMPOSTA_DE_NUMERO[count_s].
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "0" ) { set prim_alg to 0.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "1" ) { set prim_alg to 1.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "2" ) { set prim_alg to 2.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "3" ) { set prim_alg to 3.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "4" ) { set prim_alg to 4.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "5" ) { set prim_alg to 5.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "6" ) { set prim_alg to 6.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "7" ) { set prim_alg to 7.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "8" ) { set prim_alg to 8.}.
				if ( STR_COMPOSTA_DE_NUMERO[count_s] = "9" ) { set prim_alg to 9.}.
				set valor_do_num_dec to ( ( (prim_alg) * 10^( ( (STR_COMPOSTA_DE_NUMERO:length - 1) - count_s  ) ) ) + valor_do_num_dec).
			}
	
			RETURN valor_do_num_dec.
	}
	else
	{
		print "ERRO: STR_TO_INT: A string nao pode ser convertida pois nao contem um numero inteiro.".
	}.
}.	

function retira_numero_ou_nome_de_volume_path {//se for numerico o volume ele converte para SCALAR
		parameter path_com_dois_pontos_e_barra.
    set hops to inc(hops).
		
		local nome_ou_numero_do_drive 	is "".
		local str_test1					is "".
	
								if ( debug_parts ){//testes com funcoes de STRING:
									print "extrair o numero/nome de " + path_com_dois_pontos_e_barra.
									print "  POSICAO DO ["        + ":/" + "] : [" + path_com_dois_pontos_e_barra:find(":/") + "]  uso do str:find(:/)".
									print "  DIVISAO DA STR em [" + ":/" + "] : [" + path_com_dois_pontos_e_barra:split(":/") + "]  uso do SPLIT(separator)".
									print "  EXTRACAO APOS ["     + ":/" + "] : [" + path_com_dois_pontos_e_barra:substring(0, (path_com_dois_pontos_e_barra:find(":/")) ) + "]  uso do SUBSTRING(start, count)".
									print "                      na forma :  SUBSTRING( 0 , path_com_dois_pontos_e_barra:find(:/) ) ".
									print "                      se START WITH: 0:/   OR LENGTH = 1  ??? FAZER".
									PRINT "                      PRA QUE TUDO ISSO SE era soh pegar a primeira letra?".
									print "						 porque o nome do volume pode ser mudado e o 0 pode estar com Archive:\ no path()".
									print " NOW WAIT 30s" .
									SET str_test1 TO path_com_dois_pontos_e_barra.
									//exemplo com contagem:
									FOR c_count_1 IN str_test1 
									{PRINT c_count_1.}
									//acoes em strings:
									//CONTAINS(string) boolean
									// FIND(string) 	Scalar 	Returns the index of the first occurrence of the given string in this string (starting from 0)
									// FINDAT(string, startAt) 	Scalar 	Returns the index of the first occurrence of the given string in this string (starting from startAt)
									// FINDLAST(string) 	Scalar 	Returns the index of the last occurrence of the given string in this string (starting from 0)
									// FINDLASTAT(string, startAt) 	Scalar 	Returns the index of the last occurrence of the given string in this string (starting from startAt)
									// INDEXOF(string) 	Scalar 	Alias for FIND(string)		
									// PADRIGHT(width) 	String 	Returns a new left-aligned version of this string padded to the given width by spaces
									// REMOVE(index,count) 	String 	Returns a new string out of this string with the given count of characters removed starting at the given index
									// REPLACE(oldString, newString) 	String 	Returns a new string out of this string with any occurrences of oldString replaced with newString
									// SPLIT(separator) 	String 	Breaks this string up into a list of smaller strings on each occurrence of the given separator
									// STARTSWITH(string) 	boolean 	True if this string starts with the given string
									// SUBSTRING(start, count) 	String 	Returns a new string with the given count of characters from this string starting from the given start position
									// TOLOWER								
									//http://ksp-kos.github.io/KOS_DOC/structures/misc/string.html?highlight=remove
								}.
								
								set nome_ou_numero_do_drive to path_com_dois_pontos_e_barra:substring(0, (path_com_dois_pontos_e_barra:find(":/")) ).
								
								if ( TESTA_SE_STR_EH_NUMERO(nome_ou_numero_do_drive) ){//para ter certeza que nao tem algo que nao seja numero
									//FAZER: ATENCAO : se o nome do volume extraido NAO conter somente num: por ex MeuDrive
									RETURN CONVERTE_STR_TO_NUM(nome_ou_numero_do_drive).
								}.
								//precisa converter para numero(Scalar) se o drive nao tem um nome pois se for usar no switch 
								//vai dar problema o "0" ou "1" como string
								RETURN nome_ou_numero_do_drive.


	}.
	
FUNCTION LISTAR_ITENS{
	parameter tipo_de_lista is NOME_CMD_LIST_DEF.

	local lista_de_itens is list().

	if (tipo_de_lista = "FILES"){
		LIST FILES IN lista_de_itens.
		print_stat(tlog, "ATUAL: "+ PATH(), contador_log).
		print_stat(tlog, "listando arquivos:", contador_log).

		for coisa_listada in lista_de_itens {
			print_stat(tlog, coisa_listada, contador_log).
		}
	}

}     

	