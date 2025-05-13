@LAZYGLOBAL OFF.
//c3_files.ks
// 5 funcoes: 202 linhas
//recompila

//uses: vars:
//ACAO_FILE_SIZE_GET
//ACAO_FILE_SIZE_TEST
runoncepath("c3_init_vars").
global		file_KSM_ext		is "ksm".		//sem o ponto mesmo


// ====      FUNCOES BASE PARA ARQUIVOS E KOS ==============================================================================

FUNCTION TEST_VOLUMES{
 // structure Volume
    // Suffix 	Type 	Description
    // FREESPACE 	Scalar 	Free space left on the volume
    // CAPACITY 	Scalar 	Total space on the volume
    // NAME 	String 	Get or set volume name
    // RENAMEABLE 	Scalar 	True if the name can be changed
    // ROOT 	VolumeDirectory 	Volume’s root directory
    // FILES 	Lexicon 	Lexicon of all files and directories on the volume
    // POWERREQUIREMENT 	Scalar 	Amount of power consumed when this volume is set as the current volume
    // EXISTS(path) 	Boolean 	Returns true if the given file or directory exists
    // CREATE(path) 	VolumeFile 	Creates a file
    // CREATEDIR(path) 	VolumeDirectory 	Creates a directory
    // OPEN(path) 	VolumeItem or Boolean 	Opens a file or directory
    // DELETE(path) 	Boolean 	Deletes a file or directory
	}.	
FUNCTION kOS_pROCESSOR_TEST{
// kOSProcessor

// The type of structures returned by kOS when querying a module that contains a kOS processor.

// structure kOSProcessor
    // Suffix 	Type 	Description
    // All suffixes of PartModule 	  	kOSProcessor objects are a type of PartModule
    // MODE 	:ref:`string <string>` 	OFF, READY or STARVED
    // ACTIVATE 	None 	Activates this processor
    // DEACTIVATE 	None 	Deactivates this processor
    // TAG 	:ref:`string <string>` 	This processor’s name tag
    // VOLUME 	Volume 	This processor’s hard disk
    // BOOTFILENAME 	:ref:`string <string>` 	The filename for the boot file on this processor
    // CONNECTION 	:struct:`Connection 	Returns your connection to this processor
}	.
	
function VOLUME_INFOS{//mostra configs do drive: par VOLUME_ANALIZADO
	parameter VOLUME_ANALIZADO.

	print "Exibindo volume :   " + VOLUME_ANALIZADO.
	print "volume:freespace:   " + path(VOLUME_ANALIZADO):VOLUME:freespace.
	print "VOLUME:CAPACITY :   " + path(VOLUME_ANALIZADO):VOLUME:CAPACITY.
	print "VOLUME:NAME     :   " + path(VOLUME_ANALIZADO):VOLUME:NAME.
	}.	

FUNCTION TEST_SIZE_FILE{//ACAO_FILE_SIZE_GET, path("0:/boot/d"):TOSTR
	parameter operacao_file							.
	parameter file_path								.				//o file_path com extensao eh aconselhavel
	parameter debug_files 	is False				.
	parameter file_ext		is "ks"					.//SEM PONTO	//vai usar esse padrao apenas se nao for enviada uma path com extensao
	
	local file_name	 		is path(file_path):name	.
	
	local PATH_ANTES_DA_MANOBRA is ""		.
	local file_root_path		is ""		.
	local file_name_search 		is ""		.
	local file_parent_path		is ""		.
	local filelist				is list()	.
	
	//VAI MUDAR DE PATH MAS VAI RETORNAR NO FINAL.
	set PATH_ANTES_DA_MANOBRA to path().
	if (path(file_path):extension <> "")
		{
			set  file_name_search to file_name.
		}
	else
		{
			set  file_name_search to file_name + "." + file_ext.
		}.
	if (debug_files){
		print "Atual            : " + PATH_ANTES_DA_MANOBRA.
		print "file_path        : " + file_path.
		print "ROOT             : " + path(file_path):root. //obtem 0:/
		print "PARENT           : " + path(file_path):parent. //obtem 0:/boot (para o path("0:/boot/init.ks")) 
		print "name by path     : " + path(file_path):name.
		print "ext by path      : " + path(file_path):extension.// OBS a resposta eh sem o ponto ks
		print "name parameter   : " + file_name.
		print "ext parameter    : " + file_ext.
		print "usado na pesquisa: " + file_name_search.		
	}.
	
	set file_root_path to path(file_path):root.
	set file_parent_path to path(file_path):parent.
	cd(file_parent_path).
	if (debug_files){//mostra atual
		print "Atual: " + path().
	}.
	
	if (operacao_file = ACAO_FILE_SIZE_GET)
	{
		//assuming the file is in the current
		list files in filelist.
		for file_moth in fileList
		{
			if (debug_files)
			{
				print "nome do arq: " + file_moth:name.
			}.
			if (file_moth:name = (file_name_search))//encontrou o arquivo que queria e : parent + "/" + name = NAO SEII
			{
				if (file_moth:isFile) //extension, name, size, isFile
				{//e se for uma pasta o que queremos?
					if (debug_files)
					{
						print "file: " + file_moth:name + " tem " + file_moth:size.
					}.
					return file_moth:size.
					//
				}.
			}.
		}
	}.
	
	if (operacao_file = ACAO_FILE_SIZE_TEST){
		LIST.  // Prints the list of files (and subdirectories) on current volume.
		LIST FILES.  // Does the same exact thing, but more explicitly.
		LIST VOLUMES. // which volumes can be seen by this CPU?
		LIST FILES IN fileList. // fileList is now a LIST() containing :struct:`VolumeItem` structures.	
	}.
	
	//VOLTA AO ANTERIOR
	cd(PATH_ANTES_DA_MANOBRA).
	if (debug_files){//mostra atual
		print "Atual: " + path().
	}.

	if (     (operacao_file <> ACAO_FILE_SIZE_GET)
		 and (operacao_file <> ACAO_FILE_SIZE_TEST) )
	{
		print "ERRO: FILE_SIZE_GET: Nenhuma acao valida passada a funcao!".
	}.
	// print path("0:/boot/d"):suffixnames.
// LIST of 19 items:
// [0] = "CHANGEEXTENSION"
// [1] = "CHANGENAME"
// [2] = "COMBINE"
// [3] = "EXTENSION"
// [4] = "HASEXTENSION"
// [5] = "HASSUFFIX"
// [6] = "INHERITANCE"
// [7] = "ISPARENT"
// [8] = "ISSERIALIZABLE"
// [9] = "ISTYPE"
// [10] = "LENGTH"
// [11] = "NAME"
// [12] = "PARENT"
// [13] = "ROOT"
// [14] = "SEGMENTS"
// [15] = "SUFFIXNAMES"
// [16] = "TOSTRING"
// [17] = "TYPENAME"
// [18] = "VOLUME"
}.


// ====      FUNCOES BASE PARA COPIA E COMPILACAO ==========================================================================
	
function BOB{//copia o arquivo de copia para o disco 1 ORIGINAL
set prog to "c3".
set copiador to "c".

if path() <> "0:/" and path() <> "Archive:/" {
	print "Nao esta no Archive, alterando...".
	SWITCH TO 0.
	}.

//SWITCH TO 0.
//SET VOLUME(1):NAME TO AwesomeDisk.  // Name volume 1 as AwesomeDisk.
//SWITCH TO AwesomeDisk.              // Switch to volume 1.
//PRINT VOLUME:NAME.                  // Prints "AwesomeDisk".
//PRINT PATH().

print "Copiando c3 from Archive...".
copypath("0:/" + prog,"1:/" + prog).
//copia o arquivo padrao para o disco 1

print "Copiando c from Archive...".
copypath("0:/" + copiador,"1:/" + copiador).
//copia o arquivo de copia para o disco 1

print "Mudando from Archive...".
sWITCH TO 1.
cd("1:/").
//altera o disco atual para o da nave
PRINT "LISTANDO ARQUIVOS em : " + path().
list.

print "Executando " + prog + "...".
runpath(prog).
//executa o script
}.	
	





	