@LAZYGLOBAL OFF.
//c3_song.ks
// 5 funcoes: 315 linhas
//recompila

//uses: BLAH
runoncepath("c3_init_vars").

// ====    FUNCOES PARA TOCAR SONS ============================================================================

	
//Note()
//
//When asking one of SKID’s voices to play a note, you have to specify which note you meant, 
//and you do so by constructing a Note object using the Note() built-in function, or the SlideNote() built-in function:
//
// N1 is a note (also at 440 Hz because that's what "A4" means)
// that lasts 1 second overall, but only 0.8 seconds of it
// are "key down" time (i.e. the A,D,S part of the ADSR Envelope).
//SET N1 to NOTE("A4", 0.8, 1).
//
// N2 is a note that slides from the A note in one octave to the A note
// in the next octave up, over a time span of 0.3 seconds.
// (The last 0.05 seconds of which are "release" time you won't hear
// if you have the voice's RELEASE value set to zero.):
//SET N2 to SLIDENOTE("A4", "A5", 0.25, 0.3).
//
//Once a note has been constructed, it’s components are not changable. The only way to change the note is to make a new note and use it to overwrite the previous note.
//
//For that reason, it’s typical not to bother storing the result of a Note() or SlideNote() constructor in a variable as shown above, and instead just pass it right into the Play() method, or to make it part of a List of notes for making a song.

function TOCA_INTRO{
    parameter SOM_TOCAR IS "toque_1".
    set hops to inc(hops).
    
    if (SOM_TOCAR = "toque_1"){
        TOQUE_1().
    }.
    if (SOM_TOCAR = "TOQUE_7_NATION_INTRO"){
        TOQUE_7_NATION_INTRO().
    }.

}.

FUNCTION TOQUE_1{//Usado na inicialização do programa
    set hops to inc(hops).
	local V0 TO GetVoice(0).
	V0:PLAY( NOTE( 440, 1) ).  // Play one note at 440 Hz for 1 second.

	// Play a 'song' consisting of note, note, rest, sliding note, rest:
	V0:PLAY(
		LIST(
			NOTE("A#4", 0.2,  0.25), // quarter note, of which the last 0.05s is 'release'.
			NOTE("A4",  0.2,  0.25), // quarter note, of which the last 0.05s is 'release'.
			NOTE("R",   0.2,  0.25), // rest
			SLIDENOTE("C5", "F5", 0.45, 0.5), // half note that slides from C5 to F5 as it goes.
			NOTE("R",   0.2,  0.25)  // rest.
		)
	).
}.

FUNCTION TOQUE_2{//toca "Mary had a little lamb"
    set hops to inc(hops).
		brakes on.
	local song to list().
	song:add(note("b4", 0.25, 0.20)). // Ma-
	song:add(note("a4", 0.25, 0.20)). // -ry
	song:add(note("g4", 0.25, 0.20)). // had
	song:add(note("a4", 0.25, 0.20)). // a
	song:add(note("b4", 0.25, 0.20)). // lit-
	song:add(note("b4", 0.25, 0.20)). // -tle
	song:add(note("b4", 0.5 , 0.45)). // lamb,
	song:add(note("a4", 0.25, 0.20)). // lit-
	song:add(note("a4", 0.25, 0.20)). // -tle
	song:add(note("a4", 0.5 , 0.45)). // lamb
	song:add(note("b4", 0.25, 0.20)). // lit-
	song:add(note("b4", 0.25, 0.20)). // -tle
	song:add(note("b4", 0.5 , 0.45)). // lamb

	song:add(note("b4", 0.25, 0.20)). // Ma-
	song:add(note("a4", 0.25, 0.20)). // -ry
	song:add(note("g4", 0.25, 0.20)). // had
	song:add(note("a4", 0.25, 0.20)). // a
	song:add(note("b4", 0.25, 0.20)). // lit-
	song:add(note("b4", 0.25, 0.20)). // -tle
	song:add(note("b4", 0.25, 0.20)). // lamb,
	song:add(note("b4", 0.25, 0.20)). // Its
	song:add(note("a4", 0.25, 0.20)). // fleece
	song:add(note("a4", 0.25, 0.20)). // was
	song:add(note("b4", 0.25, 0.20)). // white
	song:add(note("a4", 0.25, 0.20)). // as
	song:add(note("g4", 1   , 0.95)). // snow

	LOCAL v0 to getvoice(0).

	set v0:attack to 0.0333. // take 1/30 th of a second to max volume.
	set v0:decay to 0.02.  // take 1/50th second to drop back down to sustain.
	set v0:sustain to 0.80. // sustain at 80% of max vol.
	set v0:release to 0.05. // takes 1/20th of a second to fall to zero volume at the end.

	for wavename in LIST("square", "triangle", "sawtooth", "sine", "noise") { // Let's not do "noise" - it sounds dumb for music
	  set v0:wave to wavename.
	  v0:play(song).
	  print "Playing song in waveform : " + wavename.
	  wait until not v0:isplaying.
	  wait 1.
	}
}.

FUNCTION TOQUE_7_NATION{//Toca 7 Nation Army
    set hops to inc(hops).
	brakes on.

	//MI MI SOL MI RE DO si. MI MI SOL MI RE DO RE DO si sol sol sol sol sol ( x2 ) la la la la la ( x2 ) MI MI SOL MI RE DO si	
	// http://www.ciframelodica.com.br/musicas/the-white-stripes-seven-nation-army-2258/
	// Seven Nation Army - The White Stripes
	//
	// E5 E5 G5 E5 D5 C5 B4
	// E5 E5 G5 E5 D5 C5 D5 C5 B4
	// G4 G4 G4 G4 G4 ( x2 )
	// A4 A4 A4 A4 A4 ( x2 )
	//
	// E5 E5 G5 E5 D5 C5 B4
	// E5 E5 G5 E5 D5 C5 D5 C5 B4
	// G4 G4 G4 G4 G4 ( x2 )
	// A4 A4 A4 A4 A4 ( x2 )
	//
	// E5 E5 G5 E5 D5 C5 B4
	// E5 E5 G5 E5 D5 C5 D5 C5 B4
	// G4 G4 G4 G4 G4 ( x2 )
	// A4 A4 A4 A4 A4 ( x2 )
	//
	// -------------------------------------------------|
	// B|-------------------------------------------------|
	// G|-------------------------------------------------|
	// D|---------5---------------------------------------|
	// A|----7--7---7--5--3-2-----------------------------|
	// E|-------------------------------------------------|

	local song to list().
	local song2 to list().
	song:add(note("e3", 0.750, 0.750)). // 
	song:add(note("e3", 0.250, 0.250)). //
	song:add(note("g3", 0.375, 0.375)). // 
	song:add(note("e3", 0.375, 0.375)). // 
	song:add(note("d3", 0.250, 0.250)). // 
	song:add(note("c3", 1.000, 1.000)). // 
	song:add(note("b2", 1.000, 1.000)). // 

	song:add(note("e3", 0.750, 0.750)). // 
	song:add(note("e3", 0.250, 0.250)). //
	song:add(note("g3", 0.375, 0.375)). // 
	song:add(note("e3", 0.375, 0.375)). // 
	song:add(note("d3", 0.250, 0.250)). // 
	song:add(note("c3", 0.375, 0.375)). // 
	song:add(note("d3", 0.375, 0.375)). // 
	song:add(note("c3", 0.250, 0.250)). // 
	song:add(note("b2", 1.000, 1.000)). // 

	//aqui o som era pra esperar (MAS NÃO ESPERA)
	song2:add(note("e3", 0.750, 0.750)). // 
	song2:add(note("e3", 0.125, 0.250)). //
	song2:add(note("g3", 0.125, 0.375)). // 
	song2:add(note("e3", 0.125, 0.375)). // 
	song2:add(note("d3", 0.250, 0.250)). // 
	song2:add(note("c3", 1.000, 1.000)). // 
	song2:add(note("b2", 1.000, 1.000)). // 

	song2:add(note("e3", 0.750, 0.750)). // 
	song2:add(note("e3", 0.125, 0.250)). //
	song2:add(note("g3", 0.125, 0.375)). // 
	song2:add(note("e3", 0.125, 0.375)). // 
	song2:add(note("d3", 0.250, 0.250)). // 
	song2:add(note("c3", 0.375, 0.375)). // 
	song2:add(note("d3", 0.375, 0.375)). // 
	song2:add(note("c3", 0.250, 0.250)). // 
	song2:add(note("b2", 1.000, 1.000)). // 


	LOCAL v0 to getvoice(0).

	set v0:attack to 0.0333. // take 1/30 th of a second to max volume.
	set v0:decay to 0.02.  // take 1/50th second to drop back down to sustain.
	set v0:sustain to 0.80. // sustain at 80% of max vol.
	set v0:release to 0.0. // takes 1/20th of a second to fall to zero volume at the end.

	for wavename in LIST("square", "triangle", "noise", "sawtooth", "sine") { //  "noise" - it sounds dumb for music
	  set v0:wave to wavename.
	  v0:play(song).
	  print "Playing song in waveform : " + wavename.
	  wait until not v0:isplaying.
	  wait 1.
	  
	  v0:play(song2).
	  print "Playing song2 in waveform : " + wavename.
	  wait until not v0:isplaying.
	  wait 1.
	}
	// https://www.youtube.com/watch?time_continue=95&v=0J2QdDbelmY


// Intro - E E G E D C B x4
//
//
// [Verse 1]
//
// B         E             G E D C B
// I'm gonna fight 'em off
               // E             G   E  D C B
// A seven nation army couldn't hold me back
                        // E E G E D C B
// They're gonna rip it off
               // E             G   E  D C B
// Taking their time right behind my back
        // E          G     E  D   C
// And I'm talkin' to myself at night
           // B          E E G E D C B
// Because I can't forget
// E              G     E  D   C
// Back and forth through my mind
         // B         E E G E D C B
// Behind a cigarette
//
// [Pre/Post - Chorus]
//
         // G                     A                          
// And the message comin' from my eyes says leave it alone...
//
// Repeat intro
//
//
// [Verse 2]
//
// B         E             G E D C B
// Don't wanna hear about it
               // E             G   E  D C B
// Every single one's got a story to tell
          // E             G E D C B
// Everyone knows about it
                   // E             G      E  D C B
// From the Queen of England to the hounds of hell
        // E                 G   E  D   C
// And if I catch you comin' back my way
           // B          E E G E D C B
// I'm gonna serve it to you
     // E              G     E  D   C
// And that ain't what you want to hear
           // B         E E G E D C B
// But that's what I'll do
//
//
// [Pre/Post - Chorus]
//
         // G                     A                          
// And the feeling coming from my bones says find a home...
//
// Repeat intro
//
//
// [Verse 3]
//
// B            E      G E D C B
// I'm going to Wichita
               // E        G E D C B
// Far from this opera for evermore
          // E             G E D C B
// I'm gonna work the saw
             // E          G   E  D C B
// Make a sweat drip out of every pore
//
        // E          G     E  D   C
// And I'm bleeding, and I'm bleeding, and I'm bleeding
           // B          E E G E D C B
// Right before the lord
         // E              G     E  D   C
// All the words are gonna bleed from me
           // B         E E G E D C B
// And I will think no more
//
//
// [Pre/Post-Chorus]
//
         // G                     A                          
// And the stains comin' from my blood tell me "Go back home"...

}.


FUNCTION TOQUE_7_NATION_INTRO{//Toca 7 Nation Army INTRO

	local NOME_DA_FUNC is "TOQUE_7_NATION_INTRO".
    trace(NOME_DA_FUNC).
    set hops to inc(hops).

	local song to list().
	song:add(note("e3", 0.750, 0.750)). // 
	song:add(note("e3", 0.250, 0.250)). //
	song:add(note("g3", 0.375, 0.375)). // 
	song:add(note("e3", 0.375, 0.375)). // 
	song:add(note("d3", 0.250, 0.250)). // 
	song:add(note("c3", 1.000, 1.000)). // 
	song:add(note("b2", 1.000, 1.000)). // 

	LOCAL v0 to getvoice(0).

	set v0:attack to 0.0333. // take 1/30 th of a second to max volume.
	set v0:decay to 0.02.  // take 1/50th second to drop back down to sustain.
	set v0:sustain to 0.80. // sustain at 80% of max vol.
	set v0:release to 0.0. // takes 1/20th of a second to fall to zero volume at the end.

	{
	  local wavename to "sine".
	  set v0:wave to wavename.
	  v0:play(song).
	  debug(NOME_DA_FUNC, "Playing song in waveform : " + wavename).
	  //wait until not v0:isplaying.
	  //wait 1.
	}

}.














