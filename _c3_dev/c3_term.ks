@LAZYGLOBAL OFF.
//c3_term.ks
// 5 funcoes: 212 linhas
//recompila

//uses: BLAH
runoncepath("c3_init_vars").

// ====    FUNCOES PARA CONTROLE DO TERMINAL (KOS E TELNET) ========================================================================

	
function scr_TERM_STOP_CHILLLLLASDKF{
    if (1=0){
    //Doing this should force all the connected telnet XTERM windows to stop arguing with each other about what the size is, and get them synced up again.
    //	SET TERMINAL:WIDTH TO 50.

    //have created a strange unending cascade of terminal resizes when you have two
//Certain implementations of the xterm terminal emulation and the telnet client
//have created a strange unending cascade of terminal resizes when you have two
// different telnet clients connected to the same GUI terminal and one of them 
//is dragged to a new size. Because some implementations don’t wait until they’re 
//done resizing to report their new size through telnet and instead report their 
//intermediate sizes as they are being stretched, the attempt to keep them the 
//same size causes them to effectively “argue” back and forth with each other, 
//constantly changing each other’s size. If you experience this problem 
//(your terminal window will be flipping back and forth between two different
// sizes, resizing itself over and over again in a neverending loop), you can
// try to get out of it by issuing a hardcoded command to set the terminal size, such as:
    }.
	parameter Scr_Width is 0.
	parameter Scr_Hei is 0.//NÃO PRECISA MEXER 
    
    set hops to inc(hops).
    if ( (Scr_Width = 0) and (Scr_Hei = 0) ){
        set Scr_Width   to check_largura_min_terminal().
        set Scr_Hei     to check_altura_min_terminal().
    }.

	local NOME_DA_FUNC is "scr_TERM_STOP_CHILLLLLASDKF".
    //trace(NOME_DA_FUNC).///
	
    DEBUG(NOME_DA_FUNC, "STOP LOOP TELNET RESIZE!").
    
	SET TERMINAL:WIDTH TO Scr_Width.
	if (Scr_Hei <> 0){//Se nao for informado...
		SET TERMINAL:HEIGHT TO Scr_Hei.
	}.
    REDESENHA_TELA().
}.
	
// ====      FUNCOES BASE PARA SYSTEM ======================================================================================

FUNCTION TEST_TERMINAL{				//structure Terminal
    set hops to inc(hops).
	 //structure Terminal
    // Members¶ Suffix 	Type 	Get/Set 	Description
    // WIDTH 	Scalar 	get and set 	Terminal width in characters
    // HEIGHT 	Scalar 	get and set 	Terminal height in characters
    // REVERSE 	Boolean 	get and set 	Determines if the screen is displayed with foreground and background colors swapped.
    // VISUALBEEP 	Boolean 	get and set 	Turns beeps into silent visual screen flashes instead.
    // BRIGHTNESS 	Scalar 	get and set 	Adjusts brightness slider of the terminal between 0.0 (min) and 1.0 (max).
    // CHARWIDTH 	Scalar 	get and set 	Width of a character cell in pixels.
    // CHARHEIGHT 	Scalar 	get and set 	Height of a character cell in pixels.
    // INPUT 	TerminalInput 	get 	Used to read user’s input into the terminal.
	//
//WIDTH 	Scalar 	get and set 	Terminal width in characters
//
//HEIGHT 	Scalar 	get and set 	Terminal height in characters
//
//REVERSE 	Boolean 	get and set 	Determines if the screen is displayed with foreground and background colors swapped.
//VISUALBEEP 	Boolean 	get and set 	Turns beeps into silent visual screen flashes instead.
//BRIGHTNESS 	Scalar 	get and set 	Adjusts brightness slider of the terminal between 0.0 (min) and 1.0 (max).
//CHARWIDTH 	Scalar 	get and set 	Width of a character cell in pixels.
//CHARHEIGHT 	Scalar 	get and set 	Height of a character cell in pixels.
//INPUT 	TerminalInput 	get 	Used to read user’s input into the terminal.
//
//
//http://ksp-kos.github.io/KOS_DOC/structures/misc/terminal.html	
	}.
	
FUNCTION TEST_TERMIAL_INPUT{		// structure TerminalInput
    set hops to inc(hops).
// structure TerminalInput
    // Members¶ Suffix 	Type 	Get/Set 	Description
    // CLEAR 	None 	Method Call 	Call this method to throw away all waiting input characters, flushing the input queue.
    // DELETERIGHT 	String 	Get 	A string for testing if the character read is the delete (to the right) key.
    // ENTER 	String 	Get 	An alias for RETURN
    // LEFTCURSORONE 	String 	Get 	A string for testing if the character read is the left-arrow key.
    // RIGHTCURSORONE 	String 	Get 	A string for testing if the character read is the right-arrow key.
    // HOMECURSOR 	String 	Get 	A string for testing if the character read is the HOME key.
    // ENDCURSOR 	String 	Get 	A string for testing if the character read is the END key.
    // PAGEUPCURSOR 	String 	Get 	A string for testing if the character read is the PageUp key.
    // PAGEDOWNCURSOR 	String 	Get 	A string for testing if the character read is the Page
    

// structure TerminalInput
    // Members¶ Suffix 	Type 	Get/Set 	Description
    // GETCHAR 	String 	Get 	(Blocking) I/O to read the next character of terminal input.
    // HASCHAR 	Boolean 	Get 	True if there is at least 1 character of input waiting.
    // CLEAR 	None 	Method Call 	Call this method to throw away all waiting input characters, flushing the input queue.
    // BACKSPACE 	String 	Get 	A string for testing if the character read is a backspace.
    // DELETERIGHT 	String 	Get 	A string for testing if the character read is the delete (to the right) key.
    // RETURN 	String 	Get 	A string for testing if the character read is the return key.
    // ENTER 	String 	Get 	An alias for RETURN
    // UPCURSORONE 	String 	Get 	A string for testing if the character read is the up-arrow key.
    // DOWNCURSORONE 	String 	Get 	A string for testing if the character read is the down-arrow key.
    // LEFTCURSORONE 	String 	Get 	A string for testing if the character read is the left-arrow key.
    // RIGHTCURSORONE 	String 	Get 	A string for testing if the character read is the right-arrow key.
    // HOMECURSOR 	String 	Get 	A string for testing if the character read is the HOME key.
    // ENDCURSOR 	String 	Get 	A string for testing if the character read is the END key.
    // PAGEUPCURSOR 	String 	Get 	A string for testing if the character read is the PageUp key.
    // PAGEDOWNCURSOR 	String 	Get 	A string for testing if the character read is the PageDown key.

    
	}.

FUNCTION TEST_kOS_CONFIG{			// Configuration of kOS
    set hops to inc(hops).
// Configuration of kOS
// structure Config

    // Config is a special structure that allows your kerboscript 
	//programs to set or get the values stored in the kOS plugin’s config file.
    // The options here can also be set by using the user interface panel shown here.
//	This control panel is part of the App Control Panel

    // In either case, whether the setting is changed via the GUI panel, or via script 
	//code, these are settings that affect the kOS mod in all saved games as soon as
//	the change is made. It’s identical to editing the config file in the kOS installation
// directory, and in fact will actually change that file the next time the game saves its state.
    // Members (all Gettable and Settable)¶ Suffix 	Type 	Default 	Description
    // IPU 	scalar (integer) 	150 	Instructions per update
    // UCP 	boolean 	False 	Use compressed persistence
    // STAT 	boolean 	False 	Print statistics to screen
    // RT2 	boolean 	False 	Enable RemoteTech2 integration
    // ARCH 	boolean 	False 	Start on archive (instead of volume 1)
    // OBEYHIDEUI 	boolean 	True 	Obey the KSP Hide user interface key (usually mapped to F2).
    // SAFE 	boolean 	False 	Enable safe mode
    // AUDIOERR 	boolean 	False 	Enable sound effect on kOS error
    // VERBOSE 	boolean 	False 	Enable verbose exceptions
    // TELNET 	boolean 	False 	activate the telnet server
    // TPORT 	scalar (integer) 	5410 	set the port the telnet server will run on
    // LOOPBACK 	boolean 	True 	Force the telnet server to use loopback (127.0.0.1) address
    // DEBUGEACHOPCODE 	boolean 	false 	Unholy debug spam used by the kOS developers
    
    
    
    
    // Suffix 	Type 	Default 	Description
// IPU 	Scalar (integer) 	150 	Instructions per update
// UCP 	Boolean 	False 	Use compressed persistence
// STAT 	Boolean 	False 	Print statistics to screen
// RT 	Boolean 	False 	Enable RemoteTech2 integration
// ARCH 	Boolean 	False 	Start on archive (instead of volume 1)
// OBEYHIDEUI 	Boolean 	True 	Obey the KSP Hide user interface key (usually mapped to F2).
// SAFE 	Boolean 	False 	Enable safe mode
// AUDIOERR 	Boolean 	False 	Enable sound effect on kOS error
// VERBOSE 	Boolean 	False 	Enable verbose exceptions
// TELNET 	Boolean 	False 	activate the telnet server
// TPORT 	Scalar (integer) 	5410 	set the port the telnet server will run on
// IPADDRESS 	String 	“127.0.0.1” 	The IP address the telnet server will try to use.
// BRIGHTNESS 	Scalar 	0.7 (from range [0.0 .. 1.0]) 	Default brightness setting of new instances of the in-game terminal
// DEFAULTFONTSIZE 	Scalar 	12 (from range [6 .. 20], integers only) 	Default font size in pixel height for new instances of the in-game terminal
// DEBUGEACHOPCODE 	Boolean 	false 	Unholy debug spam used by the kOS developers
    
    
	}.


// ====      FUNCOES BASE PARA OUTRAS CONFIGURACOES ========================================================================

FUNCTION TEST_SYSTEMS{				//DO NOT CALL> ONLY EXAMPLES
    set hops to inc(hops).
	//http://ksp-kos.github.io/KOS_DOC/commands/terminalgui.html
		ON AG1 {
			PRINT "You pressed '1', causing action group 1 to toggle.".
			PRINT "Action group 1 is now " + AG1.
			PRESERVE.
			}.
			
			PRINT "O sistema ira realizar alguns testes: AGUARDE".
			wait 3.
			
	//	TOGGLE
	//Toggles a variable between TRUE or FALSE. If the variable in question starts out as a number, it will be converted to a boolean and then toggled.
	//	This is useful for setting action groups, which are activated whenever their values are inverted:
		TOGGLE AG1. // Fires action group 1.
		PRINT "TOGGLE AG1".
		wait 3.
		TOGGLE SAS. // Toggles SAS on or off.
		PRINT "TOGGLE SAS".
		wait 3.
	//This follows the same rules as SET, in that if the variable in question doesn’t already exist, it will end up creating it as a global variable.

	//ON
	//Sets a variable to TRUE. This is useful for the RCS and SAS bindings:
		RCS ON.  // Turns on the RCS
		PRINT "RCS ON".
		wait 3.
	//This follows the same rules as SET, in that if the variable in question doesn’t already exist, it will end up creating it as a global variable.
	//OFF
	//Sets a variable to FALSE. This is useful for the RCS and SAS bindings:
		RCS OFF.  // Turns off the RCS
		PRINT "RCS OFF".
		wait 3.
		PRINT "Testes finalizados.".
		wait 3.
	//This follows the same rules as SET, in that if the variable in question doesn’t already exist, it will end up creating it as a global variable.

	print (TERMINAL:WIDTH).
		wait 3.
	SET TERMINAL:WIDTH to terminal_width_inicial.
		wait 3.
    //Gets or sets the terminal’s width in characters. For more information see terminal struct.
	print (TERMINAL:HEIGHT).
		wait 3.
	SET TERMINAL:HEIGHT to terminal_height_inicial.
		wait 3.
	
	IF MAPVIEW {
		PRINT "You are looking at the map.".
	} ELSE {
		PRINT "You are looking at the flight view.".
	}.
		wait 3.

	// You can switch between map and flight views by setting this variable:
	SET MAPVIEW TO TRUE.  // to map view
		wait 3.
	SET MAPVIEW TO FALSE. // to flight view
		wait 3.

	REBOOT.
    // Stops the script here, and reboots the kOS module.
		wait 3.
	SHUTDOWN.
    // Stops the script here, and causes kOS module to turn the power off.
		wait 3.

	// HUDTEXT( string Message,
			 // integer delaySeconds,
			 // integer style,
			 // integer size,
			 // RGBA colour,
			 // boolean doEcho).
	
}.

	
    
    