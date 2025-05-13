@LAZYGLOBAL OFF.
//c3_scr_tela.ks
// 22 funcoes: 848 linhas
//recompila

	//uses: BLAH
	//runoncepath("c3_init_vars").

   
	
// ====    FUNCOES PARA DESENHO DE LINHAS NA TELA ===========================================================================


function print_corner {// Print the string you pass in, in one of the 4 corners
	// of the terminal:
	//   mode = 1 for upper-left, 2 for upper-right, 3
	//          for lower-left, and 4 for lower-right:
	//
  parameter mode.
  parameter text.

    set hops to inc(hops).
  local row is 0.
  local col is 0.

  if mode = 2 or mode = 4 {
    set col to terminal:width - text:length.
  }.
  if mode = 3 or mode = 4 {
    set row to terminal:height - 1.
  }.

  print text at (col, row).
	// An example of calling it:
	//print_corner(4,"That's me in the corner").
}.
	
function DRAW_LINES_ALL{
		declare local parameter acao_draw_lp.
		declare local parameter b_es is 0.
		declare local parameter b_ei is 0.
		declare local parameter b_el is 0.
		declare local parameter b_er is 0.
		declare local parameter b_iv is 0.
		declare local parameter b_ih is 0.
		declare local parameter b_c is 0.
		
	local NOME_DA_FUNC is "DRAW_LINES_ALL".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
		
		debug(NOME_DA_FUNC, "Desenhando bordas e linhas ksdfjkj", False).
		//ATENCAO FAZER alterar a forma como e limitada a espessura da borda
			
		set b_es to (caracter_borda_horz_e_sup:length). 
		set b_ei to (caracter_borda_horz_e_inf:length). 
		set b_ih to (caracter_borda_horz_i_:length). 
		
		set b_el to (caracter_borda_vert_e_esq:length). 
		set b_er to (caracter_borda_vert_e_dir:length). 
		set b_iv to (caracter_borda_vert_i_:length). 
		
		set b_c to (caracter_borda_cent_i_:length). //ver
		//print "bordas:" + b_es + b_ei + b_ih + b_el + b_er + b_iv + b_c.
        //wait 4.
        
		debug(NOME_DA_FUNC, "Chamando padroes de bordas novamente: porque?", False).
		PADROES_E_SETUP_BORDERS( set_borders, 
								b_es,
								b_ei,
								b_el,
								b_er,
								b_iv,
								b_ih,
								b_c).
								
		if (b_ih > 0){//se a espessura da borda for 0 nao desenha nada
			debug(NOME_DA_FUNC, "Desenhando linhas genericas [b_ih > 0]:["+b_ih+"] ...", False).
			//LINHA EM CIMA
			//COLUNA
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_cmd, col_CMD, lin_CMD).

			//LINHA EM CIMA
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_tim, col_timer, lin_timer).
			draw_cols_LOG_dir().
			//draw_lines_title(es,ei,el,er,iv,ih,c).
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_stt, col_status, lin_status).
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_tim, col_CMD, lin_CMD).
            
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_tim, col_menu, lin_menu).
		
			draw_cols_esq().//sdf
			draw_lines_generic(larg_max_car, caracter_borda_horz_i_pas, col_passo, lin_passo).
            //ponto 2
		}
		else{
			debug(NOME_DA_FUNC, "NAO Desenhando linhas genericas [b_ih <= 0]:["+b_ih+"] ...", False).
		}
	
		DRAW_TELA_BORDAS(caracter_borda_vert_e_esq,caracter_borda_horz_e_sup,b_es, b_ei, b_el, b_er).
	}.

function draw_cols_esq{//IMPRIME A BORDA COLUNA DO caracter (tambes a externa se nao tiver encostada)
    set hops to inc(hops).
	local l_drawlog is 0.
	//DESENHA A COLUNA DE CIMA A BAIXO (DEPOIS DO PROMPT=LARG LOG ) (ALTURA E DO INICIO DO LOG ATE O COMPRIMENTO)
	set l_drawlog to 0.
	until (l_drawlog > h_max_col_log ){
		print caracter_borda_vert_i_esq at (larg_max_car + col_car, l_drawlog + lin_log_init).//+1 pois tem que passar do campo//tirei o col_car+1
		
		if ( ( col_car - 1 ) > 0 )//se a coluna nao estiver encostada na lateral esquerda
		{
			print caracter_borda_vert_i_DIR at (col_car - 1, l_drawlog + lin_log_init).
		}.
		
		set l_drawlog to l_drawlog + 1. 
        //wait 0.1.
	}.
}.
function draw_cols_LOG_dir{
    set hops to inc(hops).
	local ldrawlog to 0.
	until (ldrawlog > h_max_col_log ){
		print caracter_borda_vert_i_dir at (col_log - 1, ldrawlog + lin_log_init).
		set ldrawlog to ldrawlog + 1.
		}.
	}.

function draw_lines_generic{
	parameter larg_lin.
	parameter caracter_line.
	parameter num_col.
	parameter num_lin.
	
    set hops to inc(hops).
	local c_draw is 0.
	//DESENHA A LINHA EM CIMA
	until (c_draw > (larg_lin - 1) ){
		print caracter_line at (c_draw + num_col, num_lin - 1).
		set c_draw to c_draw + 1.
	}.	
}

// ====    FUNCOES PARA DETERMINACAO DO TAMANHO DA TELA =====================================================================

//AVALIAR ESTAS FUNCOES E FAZELAS CONTROLAR SEGUNDO O TIPO DE CONEXAO(TELNET)	
//PASSAR PARA c3_term
FUNCTION check_largura_min_terminal{            //largura minima para acomodar todas as colunas de informacoes

    set hops to inc(hops).
	//SETANDO ALTURA E LARGURAS MINIMAS PARA POSTERIOR VERIFICACAO:
	local largura_min_para_colunas to  (  (term_border_er + term_border_el) + larg_min_msg_log  + espaco_entre_colunas + larg_min_car + 1   ).//colé desse +1?? ver

        //ASSIM USA COLUNAS DE TAMANHO FIXO:
		//SET pos_col_left 	to ( (pos_col_rigth) - ( larg_max_car + term_border_iv + espaco_entre_colunas) ).//term_border_c ? // + 5 pq tava sobreposto fazer

	
	local largura_min_terminal	to largura_min_para_colunas.

	//FAZER ISSO NA VERIFICACAO DE REDIMENSIONAMENTO
	// if (largura_min_terminal > terminal:width) {
		// print "ATENCAO: CHECK L MIN:[largura_min_terminal]: [" + largura_min_terminal + " t:w[" + terminal:width + "]".
		// }.

	//print "CHECK L MIN: largura_min_para_colunas: " + largura_min_para_colunas.

	return largura_min_terminal.
	}.
FUNCTION check_largura_normal_terminal{            //largura NORMAL para acomodar todas as colunas de informacoes
    set hops to inc(hops).
	local largura_min_para_colunas to  (  (term_border_er + term_border_el) + larg_max_msg_log  + espaco_entre_colunas + larg_max_car + 1   ).//colé desse +1?? ver
	
	local largura_min_terminal	to largura_min_para_colunas.

	return largura_min_terminal.
	}.
FUNCTION check_altura_min_terminal{ //testa altura minima de exibicao do terminal para as alturas setadas nas config (NAO PADRAO)
    set hops to inc(hops).
	//altura minima do terminal para primeira coluna: //fazer era so verificar se (lin_status < (lin_passo + h_passo + term_border_ih))
	local altura_min_primeira_col	to (      term_border_es + h_titulo 
										+ term_border_ih + h_timer 
										+ term_border_ih + h_passo_max //h_passo
										+ term_border_ih + h_status 
										+ term_border_ih + h_file 
										+ term_border_ih + h_cmd 
										+ term_border_ih + h_car 
										+ term_border_ei).

	local altura_min_terminal 	to altura_min_primeira_col.//usar a de maior valor 
	//substituir:
	//(altura_min_terminal) = most_high(lin_status,lin_timer,lin_title,lin_passo).
	//FAZER ISSO NA VERIFICACAO DE REDIMENSIONAMENTO
	// if (altura_min_terminal > terminal:height) {
		// print "ATENCAO: CHECK H MIN:[altura_min_terminal]: [" + altura_min_terminal + " t:h[" + terminal:height + "]".
		// }.
		
	//print "CHECK L MIN: altura_min_primeira_col: " + altura_min_primeira_col.
	
	return altura_min_terminal.
	}.	

	
	//sei lah
function PADROES_E_SETUP_BORDERS{//define largura e altura max das bordas.
	//ATENCAO NAO E AQUI QUE SAO DEFINIDOS OS PADROES: NO COMECO DO ARQUIVO
	declare local parameter acao_borders.
	declare local parameter b_es    is DEF_TERM_BORDER_ES.
	declare local parameter b_ei    is DEF_TERM_BORDER_EI.//fazer
	declare local parameter b_el    is DEF_TERM_BORDER_EL.
	declare local parameter b_er    is DEF_TERM_BORDER_ER.//setar para DEF_TERM_BORDER_ER
	declare local parameter b_iv    is DEF_TERM_BORDER_IV.
	declare local parameter b_ih    is DEF_TERM_BORDER_IH.
	declare local parameter b_c     is DEF_TERM_BORDER_C.

	local NOME_DA_FUNC is "PADROES_E_SETUP_BORDERS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	DEBUG(NOME_DA_FUNC, "acao_borders["+acao_borders+"] b_es["+ b_es
						+"] b_ei["+b_ei+"] b_el["+b_el+"] b_er["+b_er
						+"] b_iv["+b_iv+"] b_ih["+b_ih+"] b_c["+b_c+"] ", False).

	if (acao_borders = def_borders){//CAN USE THE DEFAULT PARAMETERS
		debug(NOME_DA_FUNC, "Aplicando valores padrao conforme INIT_VARS_VALORES_DEFAULT", false).
		set term_border_er 	to DEF_TERM_BORDER_ER. //borda ext direita.
		set term_border_el 	to DEF_TERM_BORDER_EL. //borda ext esquerda.
		set term_border_es 	to DEF_TERM_BORDER_ES.
		set term_border_ei	to DEF_TERM_BORDER_EI.
		set term_border_ih 	to DEF_TERM_BORDER_IH. //borda interna horizontal.
		set term_border_iv 	to DEF_TERM_BORDER_IV. //borda interna vertical.
		set term_border_c 	to DEF_TERM_BORDER_C. //borda int central. INUTIL
	}.
	if (acao_borders = set_borders){
		debug(NOME_DA_FUNC, "Aplicando valores padrao conforme PARAMETROS", false).
		set term_border_er 	to b_er. //borda ext direita.
		set term_border_el 	to b_el. //borda ext esquerda.
		set term_border_es 	to b_es.
		set term_border_ei	to b_ei.
		set term_border_ih 	to b_ih. //borda interna horizontal.
		set term_border_iv 	to b_iv. //borda interna vertical.
		set term_border_c 	to b_c. //borda int central. INUTIL
	}.
	DEBUG(NOME_DA_FUNC, "Novos valores: term_border_es["+ term_border_es
						+"] term_border_ei["+term_border_ei+"] term_border_el["+term_border_el
						+"] term_border_er["+term_border_er+"] term_border_iv["+term_border_iv
						+"] term_border_ih["+term_border_ih+"] term_border_c["+term_border_c+"] ", False).
}.

function PADROES_E_SETUP_SIZES{//define largura e altura max das mensagens. [PRECISA DO BORDER ANTES]
	//ATENCAO NAO E AQUI QUE SAO DEFINIDOS OS PADROES: NO COMECO DO ARQUIVO
	parameter acao_sizes			 .
	declare parameter l_max_car is DEF_LARG_MAX_CAR.//FAZER declare parameter l_max_car is (DEF_LARG_MAX_CAR).
	declare parameter l_max_msg is DEF_LARG_MAX_MSG_LOG.
	declare parameter l_min_car is DEF_LARG_MIN_CAR .
	declare parameter l_min_msg is DEF_LARG_MIN_MSG_LOG .
	
	declare parameter h_tim 	is DEF_H_TIMER.
	declare parameter h_tit 	is DEF_H_TITULO.
	declare parameter h_pas 	is DEF_H_PASSO.
	declare parameter h_c 		is DEF_H_CAR.
	declare parameter h_cm	 	is DEF_H_CMD.
	declare parameter h_fle 	is DEF_H_FILE.
	declare parameter h_stt 	is DEF_H_STATUS.
	declare parameter h_lg 		is DEF_H_LOG.
	declare parameter h_mn		is DEF_H_MENU.
    declare parameter l_lst     is DEF_H_LISTA.

	//...fazer: outros

	local NOME_DA_FUNC is "PADROES_E_SETUP_SIZES".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	//+"] ["+
	//+"] ["+
	DEBUG(NOME_DA_FUNC, "acao_sizes["+acao_sizes+"] l_max_car["+ l_max_car
						+"] l_max_msg["+l_max_msg+"] l_min_car["+l_min_car
						+"] l_min_msg["+l_min_msg+"] h_tim["+h_tim
						+"] h_tit["	+h_tit	+"] h_pas["	+h_pas	+"] h_c["	+h_c
						+"] h_cm["	+h_cm	+"] h_fle["	+h_fle	+"] h_stt["	+h_stt
						+"] h_lg["	+h_lg	+"] h_mn["	+h_mn	+"] l_lst["	+l_lst
						+"]", False).

	if (acao_sizes = def_sizes){//VALORES DEFAULT PARA TAMANHO:
		//DEFINIR AQUI COMPRIMENTOS MIN/MAX:	
		debug(NOME_DA_FUNC, "Aplicando valores padrao conforme INIT_VARS_VALORES_DEFAULT", false).
		set larg_max_car 		to DEF_LARG_MAX_CAR.//fazer adaptar com o redimensionamento (USADO PARA A PRIMEIRA COLUNA DE INFOS)
		set larg_min_car		to DEF_LARG_MIN_CAR .//NAO USADO AINDA > valores minimos para largura da tela podem ser obtidos pelas mensagens de titulo tambem
		set larg_max_msg_log 	to DEF_LARG_MAX_MSG_LOG.//SE 	for reduzido a tela demais a posicao de impressao da coluna direita pode dar negativo
		set larg_min_msg_log	to DEF_LARG_MIN_MSG_LOG .//NAO USADO AINDA > usar para limitar o redimensionamento da tela do terminal [FAZER]

		//DEFINIR AQUI ALTURAS MINIMAS:
		set h_titulo 	to DEF_H_TITULO.//usado em cima do log
		set h_timer		to DEF_H_TIMER.//fazer[ok] atualmente so usa 2. (nao considera separador)
		set h_passo		to DEF_H_PASSO.//atualmente mostra o tit + 2 passos: ampliar e usar limitador de passos [FAZER]
		//enquanto nao houver outros campos a serem add, h_passo fica como limitador de tam
		set h_menu		to DEF_H_MENU.
		set h_car		to DEF_H_CAR.
		set h_cmd		to DEF_H_CMD.
		set h_file 		to DEF_H_FILE.
		set h_status	to DEF_H_STATUS.//label, altitude, velocidade ...
		set h_log		to DEF_H_LOG.//tamanho minimo
		set h_lista     to DEF_H_LISTA.//DEFINIR TAMANHO IDEAL
	}.
        
	if (acao_sizes = def_pos_cols){//VALORES DEFAULT PARA POSICOES: nem devia ser aqui
		debug(NOME_DA_FUNC, "Calculando: pos_col_rigth pos_col_left Col_Mostra_Bat pos_col_central", false).
	//["++"]
		//COLUNAS DE DADOS:
		set pos_col_rigth	to (terminal:width - 1) - (larg_max_msg_log + term_border_er).//sem o -1 pois trabalha com a pos [0..i] ??? WTF
		debug(NOME_DA_FUNC, " pos_col_rigth["+pos_col_rigth+"]: com base em: terminal:width["+terminal:width+"] larg_max_msg_log["+larg_max_msg_log+"] term_border_er["+term_border_er+"] ...", false).
		
		//SET pos_col_left 	to 30.//term_border_el.//com um valor fixo, a pos fica atrelada a borda esq
		//para atrelar a BORDA dir= (   (t:w - 1)  - ( larg_col_esq + borda_i(c) + larg_col_dir + borda_e ) )
		// sendo                        (pos_max)  - ( larg_msg     + larg_borda ... )
		//ou para deixar relativa a col dir=  ( pos_col_log ) - ( larg_msg_esq + borda_entre_colunas )
		
        //ASSIM USA COLUNAS DE TAMANHO FIXO:
		SET pos_col_left 	to ( (pos_col_rigth) - ( larg_max_car + term_border_iv + term_border_iv + espaco_entre_colunas) ).//term_border_c ? // + 5 pq tava sobreposto fazer
        
        set Col_Mostra_Bat  to  (terminal:width - distancia_bat_da_dir).//FAZER O TERMINAL VAI MUDAR O TAMANHO E VAI DAR PROBLEMA
		debug(NOME_DA_FUNC, " Col_Mostra_Bat["+Col_Mostra_Bat+"]: com base em: terminal:width["+terminal:width+"] distancia_bat_da_dir["+distancia_bat_da_dir+"]", false).
        // |                     /123456789012345678901234567|                    |
        //                      -/                           | 
  //       |---------------------/                           |                    |
  //       0123456789012345678901
        
		set pos_col_central	to ( (pos_col_rigth) - espaco_entre_colunas - term_border_iv).//
		debug(NOME_DA_FUNC, " pos_col_central["+pos_col_central+"]: com base em: pos_col_rigth["+pos_col_rigth+"] espaco_entre_colunas["+espaco_entre_colunas+"] term_border_iv["+term_border_iv+"]", false).
// |       |           /                 |           |
// 01234567890123456789012345678901234567890123456789>
// |       |           / terminal:width:51           |ok
// |       |           / col_log       :39           |ok
// |       |           / col_lista     :22           |ERR
// |       |           / pos_col_centra:22           |ERR
// |       |           / espc_entr_col :18           |ERR -1
// |       |           / pos_col_left  :9            |ERA PRA SER 10?
// |       |%%%%%%%%%%%/ pos_col_rigth :39           |
// |       |           / larg_max_car  :10           |
// |       |           / larg_mx_msg_lg:10           |
// |       |           /                 |           |

    
    }.    

	if (acao_sizes = set_sizes){
		debug(NOME_DA_FUNC, "Aplicando valores padrao conforme PARAMETROS", false).
		set larg_max_car 		to l_max_car	.
		set larg_min_car		to l_min_car	.
		set larg_max_msg_log 	to l_max_msg	.
		set larg_min_msg_log	to l_min_msg 	.

		set h_titulo 	to h_tit.
		set h_timer		to h_tim.
		set h_passo		to h_pas.
		//sempre vai ter um espaco no meio?
		set h_menu		to h_mn .
		set h_car		to h_c	.
		set h_cmd		to h_cm	.
		set h_file 		to h_fle.
		set h_status	to h_stt.
		set h_log		to h_lg	.
		}.
	if (acao_sizes = set_sizes_LABELS_OFF){//nos que o label fica em cima das mensagens:
		debug(NOME_DA_FUNC, "Retira uma unidade da altura dos itens: (h_passo-1) etc...", false).
		set SETUP_LABELS_OFF	to True	.
		set h_timer		to h_tim - 1.
		set h_passo		to h_pas - 1.
		set h_menu		to h_mn  - 1.
		set h_status	to h_stt - 1.
		set h_log		to h_lg  - 1.
		}.
	if (acao_sizes = set_sizes_LABELS_ON){//ATENCAO: usar -1 ou default??
		set SETUP_LABELS_OFF	to False.
		set h_timer		to h_tim.	
		set h_passo		to h_pas.
		set h_menu		to h_mn .
		set h_status	to h_stt.
		set h_log		to h_lg	.
		}.
	if (acao_sizes = set_sizes_TITLE_OFF){
		debug(NOME_DA_FUNC, "Retira uma unidade da altura do titulo: (h_tit-1) etc...", false).
		set h_titulo 	to h_tit - 1	.
		}.
	if ((acao_sizes <> set_sizes) and 
		(acao_sizes <> def_pos_cols) and 
		(acao_sizes <> def_sizes) and 
		(acao_sizes <> set_sizes_LABELS_ON) and 
		(acao_sizes <> set_sizes_LABELS_OFF) and 
		(acao_sizes <> set_sizes_TITLE_OFF)
		){
			PRINT_BIG_ERROR_NOCLS_TIMED("PADROES_E_SETUP_SIZES: no action defined: animal: [" + acao_sizes + "]").
		}.
		
	CHECK_OPTIONS(	acao_sizes,
						"PADROES_E_SETUP_SIZES",
						6,
						set_sizes,
                        def_pos_cols,
						def_sizes,
						set_sizes_LABELS_ON,
						set_sizes_LABELS_OFF,
						set_sizes_TITLE_OFF						
						).//cuidado se colocar uma a mais pode ativar o debug

	DEBUG(NOME_DA_FUNC, "Novos valores: larg_max_car["+ larg_max_car
						+"] larg_max_msg_log["+larg_max_msg_log+"] larg_min_car["+larg_min_car
						+"] larg_min_msg_log["+larg_min_msg_log+"] h_timer["+h_timer
						+"] h_titulo["	+h_titulo	+"] h_passo["	+h_passo	
						+"] h_car["	+h_car	+"] h_cmd["	+h_cmd	
						+"] h_file["	+h_file	+"] h_status["	+h_status
						+"] h_log["	+h_log	+"] h_menu["	+h_menu	
						+"] l_lst["	+l_lst
						+"]", False).
}.

function INICIALIZA_VARS_PRINT_STAT{//chamar toda vez que forem reconfigurados: largura de labels, tela, altura de itens etc...
	local NOME_DA_FUNC is "INIC_VARS_PRINT_STAT".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

    debug(NOME_DA_FUNC, "VERIFICAR O QUE ESTA FUNCAO FAZ. infos start t:h="+terminal:height+ " t:w="+terminal:width, False).
	if (1=0){//parameter opcao_de_tela_INIT_VARS_PRINT.
	//OBJETIVO:
	//	definir posicoes para as operacoes na tela
	//	base nas alturas max e bordas
	//  A ideia eh nao decidir nada aqui: apenas as funcoes matematicas que vao definir as posicoes
	//   com base em valores preestabelecidos.
	
	//DEFINICOES:
	//	usar h ou alt para altura > calculo a partir dos valores minimos necessarios [fazer: se nao couber tentar sem as bordas ext>int>nenhuma]
	//	usar w ou larg para largura
	//	usar lin e col para posicoes
	
	//DEFINIR AQUI POSICOES comp MAX
	}.
	//afeta a largura max: usar a metade do terminal para cada coluna se (1 + 20 + 1 + 20 + 1)>terminal:width
	//atencao quem vai checar se e muito pequeno eh outra funcao
	if  ( (term_border_er + larg_max_car + term_border_c + larg_max_msg_log + term_border_el) > terminal:width ) {
        debug(NOME_DA_FUNC, "os campos definidos nao caberao na tela: t:w=["+terminal:width+"] space need["+(term_border_er + larg_max_car + term_border_c + larg_max_msg_log + term_border_el)+"]").
		set larg_max_msg_log 	to ( ( ( terminal:width ) - ( term_border_er + term_border_c + term_border_el)  ) / 2 ).
        debug(NOME_DA_FUNC, ": term_border_er + larg_max_car + term_border_c + larg_max_msg_log + term_border_el   w=["+larg_max_msg_log+"]").
		set larg_max_msg_log 	to round(larg_max_msg_log, 0).
		set larg_max_car 		to larg_max_msg_log.
        debug(NOME_DA_FUNC, ": larg_max_car["+larg_max_car+"] round(larg_max_msg_log)["+larg_max_msg_log+"]").
		}.	
	
	//COLUNAS DE DADOS:
		//AGORA TA EM PADROES
	//BLOCO DE DADOS PRIMEIRA COLUNA: ---------------------------------------------------------------------------------------
	set col_title 	to pos_col_left.
	set lin_title 	to term_border_es.
	
	set col_timer 	to pos_col_left.
	set lin_timer 	to ( (lin_title) + h_titulo + (term_border_ih)).//index 3 (pos 4)
	
	set col_passo 	to pos_col_left.
	set lin_passo 	to ( (lin_timer) + (h_timer) + term_border_ih ).//index 7 (pos 8) = 1 + 1 + 1 + 3 + 1
	
	// ESSES VEM DE BAIXO PARA CIMA NA TELA:(DEIXAR O PASSO FLEXIVEL)
	//sempre usar : pos_index max(pos do posterior)   - ( latura da informacao + separadores entre info e posterior )
	// a posicao da linha vai sempre ser relativa ao campo anterior
	
	set col_car 	to pos_col_left.
	set lin_car 	to (  (terminal:height) - ( h_car + term_border_ei)  ).//penultima linha se term_border=1

	//local do prompt: linkado com a parte inferior da tela: tam_min_col = 2
	//tamanho total altura utilizado 1 + 2 + 1 = 4
	set col_CMD 	to pos_col_left.
	set lin_CMD 	to (  (lin_car)  - ( h_cmd 		+ term_border_ih )  ).//EM CIMA DO car
	
	set col_file 	to pos_col_left. //primeira coluna
	set lin_file 	to (  (lin_CMD)  - ( h_file 	+ term_border_ih )  ). //ultima linha da tela[NOP] FAZER
	
	set col_status 	to pos_col_left.
	set lin_status 	to (  (lin_file) - (  h_status 	+ term_border_ih )  ).
	
	set col_menu	to pos_col_left.
	set lin_menu	to (  (lin_status) - (  h_menu  + term_border_ih )  ).

	
	//ATENCAO: porque (t:h -1) se a unidade e o comprimento absoluto????
	set h_passo_max to  ( (terminal:height - 1) - (   term_border_es + h_titulo 
													+ term_border_ih + h_timer 
													+ term_border_ih  //aqui vai o h_passo (fica livre mas tem q ser >=)
													+ term_border_ih 
													+ h_menu		 + term_border_ih
													+ h_status       + term_border_ih 
													+ h_file         + term_border_ih 
													+ h_cmd          + term_border_ih 
													+ h_car          + term_border_ei)
						).
	//
	if (h_passo_max < h_passo) {
        debug(NOME_DA_FUNC, "ERRO: erro_tam_terminal_ALTUR: h_passo_max[" + h_passo_max + "] < h_passo["+h_passo+"] ", True).
		set h_passo_max to h_passo.//
		}.
	//fim BLOCO DE DADOS PRIMEIRA COLUNA: -----------------------------------------------------------------------------------
	
	
	//BLOCO DE DADOS SEGUNDA COLUNA: ----------------------------------------------------------------------------------------
	//a coluna do log vai de uma extremidade a outra da tela apartir do titulo(sem separador entre):
	//se a h_max_col_log < 3 (lin label + label up + info): nao mostrara nada de util
	//ATENCAO: porque (t:h -1) se a unidade e o comprimento absoluto????
	//coluna usada para mostrar os dados (eh a coluna atual)
	set col_log 		to pos_col_rigth.
	set lin_log_init	to term_border_es + h_titulo.//comecar abaixo do titulo
	
	set h_max_col_log to ((terminal:height - 1) - term_border_ei - term_border_es - h_titulo ).//altura da coluna (-1 titulo) 
	//eh o mesmo que:       pos_max_tela  - pos_de_init_log - term_border_ei
	
	if (h_max_col_log < h_log) {
		//isso nunca vai ser porque se essa ta menor que 3 entao a primeira coluna ja bugou toda!!!
        debug(NOME_DA_FUNC, "ERRO: erro_tam_terminal_ALTUR: h_max_col_log[" + h_max_col_log + "] < h_log["+h_log+"] ", True).
		}.
	
    //BLOCO PARA COLUNA CENTRAL: DEIXAR seu tamanho conforme o espaco_entre_colunas ou o espaco que sobrar ------------------
    set col_lista	to pos_col_central.
    set col_lista2	to pos_col_central + (espaco_entre_colunas/2).//isto é usado onde? (procure no hover aposto)
	set lin_lista	to term_border_es + h_titulo.//comecar abaixo do titulo
    set h_max_col_list to  ((terminal:height - 1) - term_border_ei - term_border_es - h_titulo).
    
    //BLOCO PARA TITULO E INFOLINE ------------------------------------------------------------------------------------------
	set largura_min_para_titulo to (term_border_el + label_titulo:length + term_border_er).
	//print "INFO: INIT VARS PRINT: largura_min_para_titulo: [" + (largura_min_para_titulo) + "]".
		
	set largura_max_para_INFO_LINE to ( (col_log) - ( col_file ) - term_border_iv).//(( terminal:width -1) - ( col_file )).
	
    //DEFINE O CONFIGURADO: -------------------------------------------------------------------------------------------------
	//wait 2.
	//return opcao_de_tela_INIT_VARS_PRINT.
    local vars_of_print_stat is list().
    
    vars_of_print_stat:add(check_altura_min_terminal()).
    vars_of_print_stat:add(check_largura_normal_terminal()).
  	    
    return vars_of_print_stat.
}.//FIM INICIALIZA_VARS_PRINT_STAT



// ====    FUNCOES PARA DESENHO NA TELA GERAL ===============================================================================
	
function DESENHA_TELA{              //CLS, seta PADROES, init VARS, LOCK de tam MIN, desenha LINES, TITULOS
	parameter posicoes_definidas_por_usuario is 0.
	parameter Redesenha is False.

	local NOME_DA_FUNC is "DESENHA_TELA".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
    if (1=0){//HELP E IDEIAS
        
	//OBJETIVOS:
	//	é acionada quando o programa inicia (PRIMEIRA)
	//  é acionada quando ocorre um redimensionamento de tela
	
	//ALGORITMO BASE:
	// nego tenta iniciar o terminal de qualquer tamanho
	// se a dimensao for suficiente mostra tudo com valores padrao
		// colunas bordas
		// labels
		// titulos
	
	// para largura:
	// se a dimensao nao for suficiente corta as bordas externas laterais (primeiro dir)
		// se a dimensao nao for suficiente corta as bordas internas
			// se a dimensao nao for suficiente corta as divisorias centrais
				// se a dimensao nao for suficiente diminui o padrao das larg_msg (do max ate o min) (usa sem labels)
					// se a dimensao nao for suficiente EXIBE ERRO GIGANTE LIMPA TELA - espera usuário redimensionar
						// usuario pode pressionar A e a tela vai para o MINIMO DO MINIMO auto

	// para altura:
	// se a dimensao nao for suficiente corta as bordas externas sup/inf (primeiro inf)
		// se a dimensao nao for suficiente corta as bordas internas hor
			// se a dimensao nao for suficiente corta as divisorias centrais
				// se a dimensao nao for suficiente nao exibe os LABEL (UM POR UM ate usa sem labels)
					// se a dimensao nao for suficiente EXIBE ERRO GIGANTE LIMPA TELA - espera usuário redimensionar
						// usuario pode pressionar A e a tela vai para o MINIMO DO MINIMO auto

//CONFIGURACOES ORIGINAIS DE TELA: KOS E KERBAL
//TERMINAL ORIGINAL:
//  COLUNAS: 50
//  LINHAS: 36
//  CAR L: 8px
//  CAR W: 8px
//  
//TAMANHOS MAXIMOS DE TERMINAL PARA RESULOCOES:
//  1024 x 768 (com UI reduzida : apps:79%, time:85%, alt:91%, stag:85%... etc)
//   110 x 52 > respeitando nav bal + icones
//   110 x 62 > tapando nav bal , respeitando icones
//   119 x 83 > respeitando somente as bordas do terminal
//  1280 x 1024 (com UI tudo 100%) 
//   141 x 74 > respeitando nav bal + icones
//   141 x 89 > tapando nav bal , respeitando icones
//   151 x 115 > respeitando somente as bordas do terminal (da +1 na largura se quiser)
//  1280 x 1024 (com UI tudo 100%)  ta contente agora hein?? hein???
//	?

    }.
		
    debug(NOME_DA_FUNC,"___ --------------------------------------------------------------- ______________________________",false).

	DEBUG(NOME_DA_FUNC, "Chamando padroes para bordas e tamanhos...", False).
	PADROES_E_SETUP_BORDERS(def_borders).   //usa TAMANHO DAS BORDAS DEFINIDAS
	PADROES_E_SETUP_SIZES(def_sizes).       //valores PADRAO: ignora modificacoes do USUARIO: usa SETUP_BORDERS
	PADROES_E_SETUP_SIZES(def_pos_cols).    //define valores para colunas com base nos valores atuais: usa SETUP_BORDERS
    
    
    //isso vai usar variaveis definidas em PADROES_E_SETUP_BORDERS
	local el is term_border_el.
	local er is term_border_er.
	local iv is term_border_iv.
	local ei is term_border_ei.
	local es is term_border_es.
	local ih is term_border_ih.
	local c  is term_border_c .
    
    local retorno_init_vars is list().
    local terminal_h_conf_min is 0.
    local terminal_w_conf_min is 0.
    
	//UMA VEZ AQUI E OUTRA NO FINAL:	
	set terminal_height_inicial to terminal:height.
	set terminal_width_inicial  to terminal:width.
	
    debug(NOME_DA_FUNC,"vai limpar a tela",debug_level_trace,DEBUG_DELAY_CLEARSCR).
	CLEARSCREEN.
	//set term_border to 1.//fazer eliminar
	
    //AQUI JA TEM QUE ESTAR DEFINIDO O TAMANHO DO TERMINAL:
	set retorno_init_vars to INICIALIZA_VARS_PRINT_STAT().
	
    // set terminal_height_configurado_minimo to retorno_init_vars[0].
  	// set terminal_width_configurado_minimo  to retorno_init_vars[1].
    
    set terminal_h_conf_min to retorno_init_vars[0].
  	set terminal_w_conf_min to retorno_init_vars[1].
        
	//init_scr(opc,es,ei,el,er,iv,ih,c).
	
        //PONTO TESTE 1
	
	set 	SETUP_LABEL_PROMPT 	to DEF_SETUP_LABEL_PROMPT.
	set 	SETUP_LABEL_CMD 	to DEF_SETUP_LABEL_CMD.
	
	//PARA TESTE AUTOMATICO: (primeiro bordas depois titulos etc)
	if (terminal_w_conf_min > terminal:width){//FAZENDO O TESTE DENTRO DA FUNCAO
        debug(NOME_DA_FUNC, "nem tudo cabe na largura: retira bordas e labels.").
		//elimina bordas na vertical.
		set el to 0.
		set er to 0.
		set iv to 0.
		
		//ESSES LABEL PODEM SER SUPRIMIDOS PARA MAIS ESPACO PARA OS PROMPTS:
		set 	SETUP_LABEL_PROMPT 	to ":".//USAR DEF_SETUP_LABEL_PROMPT para voltar ao orig
		set 	SETUP_LABEL_CMD 	to ":".
		
		PADROES_E_SETUP_BORDERS(set_borders,es,ei,el,er,iv,ih,c).

		
		INICIALIZA_VARS_PRINT_STAT().
		}.
		
	if (terminal_h_conf_min > terminal:height){//FAZENDO O TESTE DENTRO DA FUNCAO
        debug(NOME_DA_FUNC, "nem tudo cabe na altura: retira bordas e labels").
		//es,ei,ih to 0.//elimina bordas na horizontal.
		set es to 0.
		set ei to 0.
		set ih to 0.
		PADROES_E_SETUP_BORDERS(set_borders,es,ei,el,er,iv,ih,c).
		IF ((check_altura_min_terminal() > terminal:HEIGHT)){
				PADROES_E_SETUP_SIZES(set_sizes_LABELS_OFF).
				//como que vai implementar os lable off? if em todos os comandos de exibiçao?
				//vou usar uma var
				IF ((check_altura_min_terminal() > terminal:HEIGHT)){
					//eh nao deu a altura ainda.
					//SE O WHEN DA VERIFICACAO ESTIVER ATIVO JA VAI EXIBIR A MSG DE ERRO.
					}.
			}.
		INICIALIZA_VARS_PRINT_STAT().
		}.
	
	
	
	//FAZER : quanto ganha sem as bordas internas?	
	//IF (borders_int){
		DRAW_LINES_ALL("ALL",es,ei,el,er,iv,ih,c).
	//	}.
	//print terminal:width + " x " + terminal:height + " : pause 5." at( (terminal:width/2) -1, (terminal:height/2) -1).//REMOVER
	//WAIT 5.//REMOVER
	
	//FAZER : quanto ganha sem as bordas externas?	
	//IF (borders_ext){
	//	}.
		
		
	//FAZER : quanto ganha sem os titulos?	
	IF not(SETUP_LABELS_OFF){
		DESENHA_TITULOS(Redesenha).
	}
	else{
		PADROES_E_SETUP_SIZES(set_sizes_LABELS_OFF).
		//fazer atualizar as posicoes e tamanhos para exibir os itens em uma tela reduzida
		INICIALIZA_VARS_PRINT_STAT().
	}.
		
	debug(NOME_DA_FUNC, "Chamando INICIALIZA_VARS_PRINT_STAT mais uma vez para pegar terminal_TAMANHOS_configurado_minimo...", False).
	set retorno_init_vars to INICIALIZA_VARS_PRINT_STAT().
    
	debug(NOME_DA_FUNC, "Comparando MENU_ultimo_exibido["+MENU_ultimo_exibido
		+"] com MENU_REEXIBIR["+MENU_REEXIBIR+"]", False).
	if (MENU_ultimo_exibido <> MENU_REEXIBIR) {//um menu já havia sido exibido antes: recuperando valores
		debug(NOME_DA_FUNC, "Mostrando MENU: MENU_ultimo_exibido["+MENU_ultimo_exibido+"]", False).
		MOSTRA_MENU(MENU_ultimo_exibido, True).//true para refresh do menu
		}
	else {//nenhum menu havia sido exibido antes: MOSTRA MENU INCIAL
		debug(NOME_DA_FUNC, "Mostrando MENU: MENU_INICIAL["+MENU_INICIAL+"]", False).
		MOSTRA_MENU(MENU_INICIAL).
		}.
    
    set terminal_height_configurado_minimo to retorno_init_vars[0].
  	set terminal_width_configurado_minimo  to retorno_init_vars[1].
	debug(NOME_DA_FUNC, "Valores min calculados para terminal: alt["+terminal_height_configurado_minimo+"] larg["+terminal_width_configurado_minimo+"]...", False).
	//UMA VEZ AQUI E OUTRA NO INICIO:	
	set terminal_height_configurado to terminal:height.
	set terminal_width_configurado  to terminal:width.
	debug(NOME_DA_FUNC, "Valores terminal atual: alt["+terminal_height_configurado+"] larg["+terminal_width_configurado+"]...", False).
    debug(NOME_DA_FUNC,"___ --------------------------------------------------------------- ______________________________",false).
}.//fim DESENHA TELA

FUNCTION print_configs_tela{        //PARA INFORMACOES E DEBUG
    parameter mostra_confs is "all".
    
    set hops to inc(hops).
    if (mostra_confs="all"){
        print_stat(tlista, "terminal:width:"+terminal:width,    contador_list).
        print_stat(tlista, "col_log       :"+col_log,           contador_list).
        print_stat(tlista, "col_lista     :"+col_lista,         contador_list).
        print_stat(tlista, "pos_col_centra:"+pos_col_central,   contador_list).
        print_stat(tlista, "espc_entr_col :"+espaco_entre_colunas,   contador_list).
        
        
        print_stat(tlista, "pos_col_left  :"+pos_col_left,      contador_list).
        print_stat(tlista, "pos_col_rigth :"+pos_col_rigth,     contador_list).
        print_stat(tlista, "larg_max_car  :"+larg_max_car,      contador_list).
        print_stat(tlista, "larg_mx_msg_lg:"+larg_max_msg_log,  contador_list).
        print_stat(tlista, "lin_log_init  :"+lin_log_init,      contador_list).
        
    }.    
    if (mostra_confs="numeros"){//nao utilizado
        
        print CONCAT_STR_A("0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789",terminal:width) at (0,20).
    }.
    if (mostra_confs="counts"){
        print_stat(tlista, "contador_list :"+contador_list,     contador_list).
        print_stat(tlista, "contador_LOG  :"+contador_LOG,      contador_list).
    }.
    if (mostra_confs="filllog"){
        FROM    {local count_log to contador_log.}
        UNTIL   (count_log > (h_max_col_log - 6))
        STEP    {set count_log to count_log + 1.}
        DO 	    {
            print_stat(tlog, "log:"+count_log,     contador_log).
            
        }.
        
    }.
    if (mostra_confs = "addlog"){
        print_stat(tlog, "log:"+contador_log,     contador_log).        
    }.
}.

function DESENHA_TITULOS{
	parameter Redesenha_t is False.

	local NOME_DA_FUNC is "DESENHA_TITULOS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	debug(NOME_DA_FUNC, "Inicializa prompt...", False).
	process_one_char(label_prompt).//INICIALIZA PROMPT fazer retirar isso WTF

	debug(NOME_DA_FUNC, "Inicializa titulo...", False).
	PRINT_STAT(ttitle,label_titulo,contador_title).

	//COLUNA DO LOG: TERMINAL:WIDTH - 20 //20 E O TAMANHO MAX DA MSG
	if not(Redesenha_t){//somente adiciona uma linha de titulo novamente se NAO FOR REDESENHO
		debug(NOME_DA_FUNC, "Inicializa log_label...", False).
		print_stat(tlog,log_label,contador_log).
	}

	//COLUNA DO PASSO: TERMINAL:HEIGHT - (HEIGHT - 10) //10 E A POSICAO
	debug(NOME_DA_FUNC, "Inicializa label_passo...", False).
	print_stat(tpasso,label_passo,contador_passo).//CONTADOR ZERO SO MOSTRA O TITULO
	
	debug(NOME_DA_FUNC, "Inicializa label_menu...", False).
	print_stat(tmenu, label_menu, contador_menu).
	}.
	
function RECUPERA_VALORES_TELA{//lista_msg,lista_TIMER,lista_log,lista_status,lista_title,linha_digitada_no_prompt
	//listas:
	parameter lista_msg_R.//isto tudo é passado BY_REF: clear na lista modifica a referenciada
	parameter lista_TIMER_R.
	parameter lista_log_R.
	parameter lista_status_R.
	parameter lista_title_R.
    parameter lista_list_R.
	//variaveis:
	parameter linha_digitada_no_prompt_R.

	local NOME_D_FNC is "RECp_VALORES_TELA".
    set hops to inc(hops).
	
	local lista_rec_temp IS list().

	//primeiro o log:
	set contador_LOG to 0.
		if (1=1){
			debug(NOME_D_FNC, "lista_msg:").
			debug(NOME_D_FNC, lista_msg).
			debug(NOME_D_FNC, "lista_msg_rec:").
			debug(NOME_D_FNC, lista_msg_R).
		}

	if (lista_msg_R:length <> 0){
		debug(NOME_D_FNC, "Recuperando valores da lista: msg com ["+lista_msg_R:length+"] itens", False).

		//retem valores antigos temporariamente:
		FOR item_da_lista IN lista_msg_R {
			lista_rec_temp:add(item_da_lista).
		}

		//limpa lista velha:
		lista_msg_R:clear. //Print lista_msg_R.
		if (1=0){
			wait 0.//dd
			debug(NOME_D_FNC, " apos clear : lista_msg:").
			debug(NOME_D_FNC, lista_msg).
			debug(NOME_D_FNC, "lista_msg_rec:").
			debug(NOME_D_FNC, lista_msg_R).
		}

		FOR item_da_lista IN lista_rec_temp {
        	//print_stat(tipoMsg, msg, count_print, reprint, debug, num_verb).
			if item_da_lista <> log_label {//NAO DESENHA O TITULO SENAO vai ficar duplicado: quem desenha os titulos é DESENHA_TITULOS
				//AGORA O DESENHA_TITULOS SABE que é um redesenho e noa adiciona mais uma entrada na lista_msg_log
			}
			print_stat(tLOG, item_da_lista, contador_LOG, true).//porque fica repetindo um?

		}
		if (1=1){
			debug(NOME_D_FNC, "lista_rec_temp:").
			debug(NOME_D_FNC, lista_rec_temp).
			debug(NOME_D_FNC, "lista_msg:").
			debug(NOME_D_FNC, lista_msg).
		}

	}.
}.	
	
function DRAW_TELA_BORDAS{
	parameter caracter_borda_vert_dt.
	parameter caracter_borda_horz_dt.
	declare local parameter b_es is 0.
	declare local parameter b_ei is 0.
	declare local parameter b_el is 0.
	declare local parameter b_er is 0.
	//PARAMETER len_border.
	local NOME_DA_FUNC is "DRAW_TELA_BORDAS".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).
	//local caracter_borda_vert_dt.
	//local caracter_borda_horz_dt.

	debug(NOME_DA_FUNC, "Chamando outra funcao ...", False).
	DRAW_TELA_BORDAS_FAST(caracter_borda_vert_dt,caracter_borda_horz_dt,b_es,b_ei,b_el,b_er).
		
	}.
		
function DRAW_TELA_BORDAS_NONE {
	PARAMETER len_border.
    set hops to inc(hops).
	//nada
	}.
	
function DRAW_TELA_BORDAS_FAST {
	parameter caracter_borda_vert_fast.
	parameter caracter_borda_horz_fast.
	declare local parameter b_es is 0.
	declare local parameter b_ei is 0.
	declare local parameter b_el is 0.
	declare local parameter b_er is 0.
	
	local NOME_DA_FUNC is "DRAW_TELA_BORDAS_FAST".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	//FAZER reduzir os tamanhos das strings de borda se forem maiores que a espessura indicada
	debug(NOME_DA_FUNC, "Testando espessura da borda...", False).
	if (caracter_borda_vert_fast:length <> b_el){
		debug(NOME_DA_FUNC, "Esta usando teste <> e nao > (ver isso)...", False).
		SET caracter_borda_vert_fast TO CONCAT_STR_A(caracter_borda_vert_fast, b_el).
		}.
	//ATENCOA MESMO ASSIM O PROGRAMA NAO VAI 	CONSIDERAR A ESPESSURA NO DESENHO
	// fazer: a espessura e o numero de colunas e diferente
	// SEPARAR O b_el do length do caracter
	//OU O CONTRARIO:
	// linkar a espessura (len) ao valor que o calculos utilizam para calcular as posicoes PARA AS HOR
	//          PARA AS VERT nao tem problema mas o len vai ser um valor e b_es pode ser outro> mas
	//          ao ser desenhado para aparecer corretamente vai ter que considerar o len (na rotina de printagem)
	//			no numero de BORDAS vai usar o b_es
		
	
	local c_i to 0.
	local c_f to terminal:width - 1.//49
	local l_i to 0.
	local l_f to terminal:height - 1.//35

	//DESENHA AS COLUNAS
	debug(NOME_DA_FUNC, "Desenhando colunas...", False).
	from {local l to l_i + 1.} //percorre as colunas nas linhas inicial e final
		until l = (l_f)//quando passar do l_f nao executa (ainda vai imprimir a linha final)
		step {set l to l + 1.}
		do {
			
			from 		{local esp to 1.} //vai comecar com 1 sempre e se a borda for 0 nem vai desenhar
				until 	(esp > b_el) //tamanho especificado somente para a esquerda: FAZER
				step 	{ set esp to (esp + 1) .}
				do {
					//imprime coluna na lateral esquerda da tela
					print caracter_borda_vert_fast at(c_i + ( esp - 1 ),l).//"|"  ( esp - 1 ) torna a posicao absoluta [0..i]
					//imprime coluna na lateral direira da tela (manos o ultimo ponto)
					iF ( (l <> l_f - 1) ) { print caracter_borda_vert_fast at(c_f - ( esp - 1 ), l).}.//ver isso
				}
			}
			
	//DESENHA AS LINHAS
	debug(NOME_DA_FUNC, "Desenhando linhas...", False).
	from {local c to c_i + 1.} //percorre as colunas nas linhas inicial e final
		until c = (c_f)//quando passar do l_f nao executa (ainda vai imprimir a linha final)
		step {set c to c + 1.}
		do {
		
			from 		{local esp to 1.} //vai comecar com 1 sempre e se a borda for 0 nem vai desenhar
				until 	(esp > b_es) //tamanho especificado somente para a superior: FAZER
				step 	{ set esp to (esp + 1) .}
				do {
					print caracter_borda_horz_fast at(c,l_i + ( esp - 1 )).//"-"
					iF ( (c <> c_f - 1) ) { print caracter_borda_horz_fast at(c, l_f  - ( esp - 1 )).}.
				}			
			}	
	}.
	
function DRAW_TELA_BORDAS_SLOW {
	PARAMETER len_border.
	parameter caracter_borda_vert_slw.
	parameter caracter_borda_horz_slw.
    set hops to inc(hops).
	SET c_i to 0.
	set c_f to terminal:width - 1.//49
	SET l_i to 0.
	set l_f to terminal:height - 1.//35
	
	from {set l to l_i.} //percorre as colunas nas linhas inicial e final
		until l = (l_f + 1)//quando passar do l_f nao executa (ainda vai imprimir a linha final)
		step {set l to l + 1.}
		do {
			from {set c to c_i.} 
			until c = (c_f + 1)//quando passar do c_f nao executa (ainda vai imprimir a coluna final)
			step {set c to c + 1.} 
			do {
				if ((c=c_f)and(l=l_f)) {
					//center
					print "X" at( (terminal:width/2) -1, (terminal:height/2) -1).}
				else {
					
					//normal corners
						if (c=c_i)and(l=l_i) 	{print "+" at(c,l).}.
						if (c=c_i)and(l=l_f) 	{print "+" at(c,l).}.
						if (c=c_f)and(l=l_i) 	{print "+" at(c,l).}.
					//botton rigth corner
						if (c=c_f -1)and(l=l_f-1) {print "+" at(c,l).}.
						if (c=c_f)and(l=l_f-1) {print "+" at(c,l).}.
						if (c=c_f-1)and(l=l_f) {print "+" at(c,l).}.
					
					//top and botton lines
					IF ( ( c=c_f or c=c_i ) and (l<>l_i) and (l<>l_f) and ((l<>l_f-1) or (c=c_i)) ) { print caracter_borda_vert_slw at(c,l).}.
					
					//left and rigth colums
					IF ( (l=l_f or (l=l_i)) and (c<>c_i) and (c<>c_f) and ((c<>c_f-1) or (l=l_i)) ) { print caracter_borda_horz_slw at(c,l).}.
					
						
					//if (c=c_f)and(l=l_f) {print "#" at(c,l).}.//DONT PRINT HERE : BUGA TUDO! para 50x36 (49 e 35)
					}.
				}
			}
	}.
		
function TESTE_TELA {
	parameter caracter_borda_vert_test.
	parameter caracter_borda_horz_test.

    set hops to inc(hops).
	//moldura e teste de tela
	print "   TESTE_TELA: ".
	print "largura: " + terminal:width.
	print "altura: " + terminal:height.
	//wait 2.
	
	//USING POSITIONS INSTEAD OF LENGTHS:
	SET c_i to 0.
	set c_f to terminal:width - 1.//49
	SET l_i to 0.
	set l_f to terminal:height - 1.//35
	
	from {set l to l_i.} //percorre as colunas nas linhas inicial e final
		until l = (l_f + 1)//quando passar do l_f nao executa (ainda vai imprimir a linha final)
		step {set l to l + 1.}
		do {
			from {set c to c_i.} 
			until c = (c_f + 1)//quando passar do c_f nao executa (ainda vai imprimir a coluna final)
			step {set c to c + 1.} 
			do {
				if ((c=c_f)and(l=l_f)) {
					//center
					print "X" at( (terminal:width/2) -1, (terminal:height/2) -1).}
				else {
					//print "*" at( c, l ).
					
					//normal corners
						if (c=c_i)and(l=l_i) 	{print "+" at(c,l).}.
						if (c=c_i)and(l=l_f) 	{print "+" at(c,l).}.
						if (c=c_f)and(l=l_i) 	{print "+" at(c,l).}.
					//botton rigth corner
						if (c=c_f -1)and(l=l_f-1) {print "+" at(c,l).}.
						if (c=c_f)and(l=l_f-1) {print "+" at(c,l).}.
						if (c=c_f-1)and(l=l_f) {print "+" at(c,l).}.
					
					//top and botton lines
					IF ( ( c=c_f or c=c_i ) and (l<>l_i) and (l<>l_f) and ((l<>l_f-1) or (c=c_i)) ) { print caracter_borda_vert_test at(c,l).}.
					
					//left and rigth colums
					IF ( (l=l_f or (l=l_i)) and (c<>c_i) and (c<>c_f) and ((c<>c_f-1) or (l=l_i)) ) { print caracter_borda_horz_test at(c,l).}.
					
						
					//if (c=c_f)and(l=l_f) {print "#" at(c,l).}.//DONT PRINT HERE : BUGA TUDO! para 50x36 (49 e 35)
					}.
				}
	//		wait 0.1.
			}
	wait 15.

	//percorre as linhas nas colunas inicial e final
	from {set c to 0.} 
		until c = terminal:width
		step {set c to c + 1.} 
		do {
			from {set l to 0.} 
			until l = terminal:height
			step {set l to l + 1.}
			do {
				if ((c=49)and(l=35)) {
					print "" at( (terminal:width/2) -1, (terminal:height/2) -1).}
				else {
					//print "." at( c, l ).							
					if (c=0)and(l=0) {print "@" at(c,l).}.
					if (c=48)and(l=34) {print "$" at(c,l).}.
					//if (c=49)and(l=35) {print "#" at(c,l).}.
		//			wait 0.2.
					}.
				}
	//		wait 0.1.
			}
	}.	


