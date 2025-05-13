@LAZYGLOBAL off.
//c3_pid_node.ks
// 15 funcoes: 602 linhas
//recompila

// This file is distributed under the terms of the MIT license, (c) the KSLib team

//uses: BLAH25555
//runoncepath("c3_init_vars").

// ====    FUNCOES PARA CONTROLE PID E NODES DA NAVE ============================================================================

//--------------  INICIO FUNCOES PARA HOVER ---------------------------------------------------------

function PID_init {
  parameter
    Kp,      // gain of position
    Ki,      // gain of integral
    Kd,      // gain of derivative
    cMin,  // the bottom limit of the control range (to protect against integral windup)
    cMax.  // the the upper limit of the control range (to protect against integral windup)
    set hops to inc(hops).

  local SeekP is 0. // desired value for P (will get set later).
  local fP is 0.     // phenomenon P being affected.
  local I is 0.     // crude approximation of Integral of P.
  local D is 0.     // crude approximation of Derivative of P.
  local oldT is -1. // (old time) start value flags the fact that it hasn't been calculated
  local oldInput is 0. // previous return value of PID controller.

  // Because we don't have proper user structures in kOS (yet?)
  // I'll store the PID tracking values in a list like so:
  //
  local PID_array is list(Kp, Ki, Kd, cMin, cMax, SeekP, fP, I, D, oldT, oldInput).

  return PID_array.
}.

function pid_seek_carlos {
  parameter
    PID_array, // array built with PID_init.
    seekVal,   // value we want.
    curVal.    // value we currently have.
    set hops to inc(hops).

  // Using LIST() as a poor-man's struct.

  local Kp   is PID_array[0].
  local Ki   is PID_array[1].
  local Kd   is PID_array[2].
  local cMin is PID_array[3].
  local cMax is PID_array[4].
  local oldS   is PID_array[5].
  local oldP   is PID_array[6].
  local oldI   is PID_array[7].
  local oldD   is PID_array[8].
  local oldT   is PID_array[9]. // Old Time
  local oldInput is PID_array[10]. // prev return value, just in case we have to do nothing and return it again.

  local meuP is seekVal - curVal.
  local D is oldD. // default if we do no work this time.
  local I is oldI. // default if we do no work this time.
  local newInput is oldInput. // default if we do no work this time.

  local t is time:seconds.
  local dT is t - oldT.

  if oldT < 0 {
    // I have never been called yet - so don't trust any
    // of the settings yet.
  } else {
    if dT > 0 { // Do nothing if no physics tick has passed from prev call to now.
     set D to (meuP - oldP)/dT. // crude fake derivative of P
     local onlyPD is Kp*meuP + Kd*D.
     if (oldI > 0 or onlyPD > cMin) and (oldI < 0 or onlyPD < cMax) { // only do the I turm when within the control range
      set I to oldI + meuP*dT. // crude fake integral of P
     }.
     set newInput to onlyPD + Ki*I.
    }.
  }.

  set newInput to max(cMin,min(cMax,newInput)).

  // remember old values for next time.
  set PID_array[5] to seekVal.
  set PID_array[6] to meuP.
  set PID_array[7] to I.
  set PID_array[8] to D.
  set PID_array[9] to t.
  set PID_array[10] to newInput.

  return newInput.
}.

function PID_update {
  parameter
    PID_array,
	Kp,      // gain of position
    Ki,      // gain of integral
    Kd,      // gain of derivative
	cMin,  // the bottom limit of the control range (to protect against integral windup)
    cMax.  // the the upper limit of the control range (to protect against integral windup)
    set hops to inc(hops).
	
	set PID_array[0] to Kp.
	set PID_array[1] to Ki.
	set PID_array[2] to Kd.
	set PID_array[3] to cMin.
	set PID_array[4] to cMax.
	return PID_array.
}.

//--------------  FIM FUNCOES PARA HOVER ------------------------------------------------------------



//from forum KOS

FUNCTION testE_1{//this dont work!!! 
	//print "debug: "+NOME_DA_FUNC+": " + "PARA O TESTE_11".
	debug("TESTE_1","INICIOU TESTE 1").
	debug("TESTE_1","isto nao e para funcionar mesmo").
	debug("TESTE_1","e vai dar um erro estranho dizendo que o g nao esta declarado").

	global accvec to 0.
	global gforce to 0.
	global dthrott to 0.
	global g to 0.
	
	local thrott TO 1.
	
	LOCK THROTTLE TO thrott.
	LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
	STAGE.
	WHEN SHIP:ALTITUDE > 1000 THEN {
		SET g TO KERBIN:MU / KERBIN:RADIUS^2				.
		LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV	.
		LOCK gforce TO accvec:MAG / g						.
		LOCK dthrott TO 0.05 * (1.2 - gforce)				.

		UNTIL SHIP:ALTITUDE > 40000 {
			WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
				STAGE.
				PRESERVE.
				}
			SET thrott to thrott + dthrott.
			WAIT 0.1.
			}
		}
	debug("TESTE_1","TERMINOU TESTE 1").
	}.

function testE_2{
	debug("TESTE_2","INICIOU TESTE 2").
	debug("TESTE_2","e vai dar um erro estranho dizendo que o g nao esta declarado").

	local accvec is 0.
	local gforce is 0.
	local dthrott is 0.
	local g is 0.
	
	local thrott is 1.

	WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
		STAGE.
		PRESERVE.
		}
	//SET thrott TO 1.
	SET dthrott TO 0.
	LOCK THROTTLE TO thrott.
	LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
	STAGE.
	UNTIL SHIP:ALTITUDE > 40000 {
	
	if (SHIP:ALTITUDE > 1000) {
		SET dthrott TO aux_teste2().
		SET thrott to thrott + dthrott.
		HUDTEXT("dthrott: " + dthrott, 5, 2, 15, red, false).

		WAIT 0.1.
	}
	}
	debug("TESTE_2","TERMINOU TESTE 2").	
}.
function aux_teste2{
	local dthrott_aux is 0.
	local g_aux is 0.
	local accvec_aux is 0.
	local gforce_aux is 0.
		SET g_aux TO KERBIN:MU / KERBIN:RADIUS^2.
		set accvec_aux TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
		set gforce_aux TO accvec_aux:MAG / g_aux.
		set dthrott_aux TO 0.05 * (1.2 - gforce_aux).
	return dthrott_aux.
}.

FUNCTION TESTE_3{
	debug("TESTE_3","INICIOU TESTE 3").
	debug("TESTE_3","e vai dar um erro estranho dizendo que o g nao esta declarado").

	local accvec is 0.
	local gforce is 0.
	local dthrott is 0.
	local g is 0.
	local my_sterr is R(0,0,-90) + HEADING(90,90).
	
	local thrott is 1.
	WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}


SET thrott TO 1.
SET dthrott TO 0.
LOCK THROTTLE TO thrott.
LOCK STEERING TO my_sterr.
STAGE.
WHEN SHIP:ALTITUDE > 1000 THEN {
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
    LOCK gforce TO accvec:MAG / g.
    LOCK dthrott TO 0.05 * (1.2 - gforce).

    WHEN SHIP:ALTITUDE > 10000 THEN {
        LOCK dthrott TO 0.05 * (2.0 - gforce).

        WHEN SHIP:ALTITUDE > 20000 THEN {
            LOCK dthrott TO 0.05 * (4.0 - gforce).

            WHEN SHIP:ALTITUDE > 30000 THEN {
                LOCK dthrott TO 0.05 * (5.0 - gforce).
            }
        }
    }
}
UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott to thrott + dthrott.
	HUDTEXT("dthrott: " + dthrott, 5, 2, 15, red, false).
	set my_sterr to R(0,0,-90) + HEADING(90,90).
    WAIT 0.1.
}
	debug("TESTE_2","TERMINOU TESTE 3").	
}.

FUNCTION TESTE_4{//Proportional Feedback Loop (P-loop)
	// staging, throttle, steering, go
WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}
LOCK THROTTLE TO 1.
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
STAGE.
WAIT UNTIL SHIP:ALTITUDE > 1000.

// P-loop setup
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.
LOCK dthrott TO 0.05 * (1.2 - gforce).

SET thrott TO 1.
LOCK THROTTLE to thrott.

UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott to thrott + dthrott.
    WAIT 0.1.
}
	
}.

FUNCTION TESTE_5{//Proportional-Integral Feedback Loop (PI-loop)
//Adding the integral term requires us to keep track of time. This is done by introducing a variable (t0) to store the time of the last iteration. Now, the throttle is changed only on iterations where some time has elapsed so the WAIT time in the UNTIL can be brought to 0.001. The offset of the gforce has been set to the variable P, and the integral gain to Ki.

// PI-loop
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.2.

LOCK P TO gforce_setpoint - gforce.
SET I TO 0.

SET Kp TO 0.01.
SET Ki TO 0.006.

LOCK dthrott TO Kp * P + Ki * I.

SET thrott TO 1.
LOCK THROTTLE to thrott.

SET t0 TO TIME:SECONDS.
UNTIL SHIP:ALTITUDE > 40000 {
    SET dt TO TIME:SECONDS - t0.
    IF dt > 0 {
        SET I TO I + P * dt.
        SET thrott to thrott + dthrott.
        SET t0 TO TIME:SECONDS.
    }
    WAIT 0.001.
}

//Adding the integral term has the general effect of stabilizing the feedback loop, making it less prone to oscillating due to rapid changes in the process variable (gforce, in this case). This is usually at the expense of a longer settling time.

}.

FUNCTION TESTE_6{//Proportional-Integral-Derivative Feedback Loop (PID-loop)
//Incorporating the derivative term (D) and derivative gain (Kd) requires an additional variable (P0) to keep track of the previous value of the proportional term (P).

// PID-loop
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.2.

LOCK P TO gforce_setpoint - gforce.
SET I TO 0.
SET D TO 0.
SET P0 TO P.

SET Kp TO 0.01.
SET Ki TO 0.006.
SET Kd TO 0.006.

LOCK dthrott TO Kp * P + Ki * I + Kd * D.

SET thrott TO 1.
LOCK THROTTLE to thrott.

SET t0 TO TIME:SECONDS.
UNTIL SHIP:ALTITUDE > 40000 {
    SET dt TO TIME:SECONDS - t0.
    IF dt > 0 {
        SET I TO I + P * dt.
        SET D TO (P - P0) / dt.
        SET thrott to thrott + dthrott.
        SET P0 TO P.
        SET t0 TO TIME:SECONDS.
    }
    WAIT 0.001.
}

//When tuned properly, the derivative term will cause the PID-loop to act quickly without causing problematic oscillations. Later in this tutorial, we will cover a way to tune a PID-loop using only the proportional term called the Zieger-Nichols method.
 }.
 
FUNCTION TESTE_7{//Using pidloop
 //As mentioned earlier, kOS 0.18.1 introduced a new structure called pidloop that can take the place of much of the previous code. Here is the previous script, converted to use pidloop.

// pidloop
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET Kp TO 0.01.
SET Ki TO 0.006.
SET Kd TO 0.006.
SET PID TO PIDLOOP(Kp, Kp, Kd).
SET PID:SETPOINT TO 1.2.

SET thrott TO 1.
LOCK THROTTLE TO thrott.

UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott TO thrott + PID:UPDATE(TIME:SECONDS, gforce).
    // pid:update() is given the input time and input and returns the output. gforce is the input.
    WAIT 0.001.
}

//The primary advantage to using pidloop is the reduction in the number of instructions per update (see Config:IPU). For example, this pidloop script requires approximately one-third the number of instructions needed by the script shown in the previous section. Since the number of instructions executed has a direct bearing on electrical drain as of 0.19.0, this can be a great help with power conservation.

//Note that pidloop offers a great deal more options than were presented here, but nevertheless, this should provide a decent introduction to using pidloop.
 }.

FUNCTION TESTE_8{//There are a few modifications that can make PID loops very robust. The following code example adds three range limits:

//Final Touches
//
//1    bounds on the Integral term which addresses possible integral windup
//2    bounds on the throttle since it must stay in the range 0 to 1
//3    a deadband to avoid changing the throttle due to small fluctuations
//
//Of course, KSP is a simulator and small fluctuations are not observed in this particular loop. Indeed, the P-loop is sufficient in this example, but all these features are included here for illustration purposes and they could become useful for unstable aircraft or untested scenarios.
//
// PID-loop
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.2.

LOCK P TO gforce_setpoint - gforce.
SET I TO 0.
SET D TO 0.
SET P0 TO P.

LOCK in_deadband TO ABS(P) < 0.01.

SET Kp TO 0.01.
SET Ki TO 0.006.
SET Kd TO 0.006.

LOCK dthrott TO Kp * P + Ki * I + Kd * D.

SET thrott TO 1.
LOCK THROTTLE to thrott.

SET t0 TO TIME:SECONDS.
UNTIL SHIP:ALTITUDE > 40000 {
    SET dt TO TIME:SECONDS - t0.
    IF dt > 0 {
        IF NOT in_deadband {
            SET I TO I + P * dt.
            SET D TO (P - P0) / dt.

            // If Ki is non-zero, then limit Ki*I to [-1,1]
            IF Ki > 0 {
                SET I TO MIN(1.0/Ki, MAX(-1.0/Ki, I)).
            }

            // set throttle but keep in range [0,1]
            SET thrott to MIN(1, MAX(0, thrott + dthrott)).

            SET P0 TO P.
            SET t0 TO TIME:SECONDS.
        }
    }
    WAIT 0.001.
}


}.

FUNCTION TESTE_9{//Tuning a PID-loop

//We are going to start with the same rocket design we have been using so far and actually tune the PID-loop using the Ziegler-Nichols method. This is where we turn off the integral and derivative terms in the loop and bring the proportional gain (Kp) up from zero to the point where the loop causes a steady oscillation with a measured period (Tu). At this point, the proportional gain is called the “ultimate gain” (Ku) and the actual gains (Kp, Ki and Kd) are set according to this table taken from wikipedia:
//Control Type 	Kp 	Ki 	Kd
//P 	0.5 Ku 	  	 
//PI 	0.45 Ku 	1.2 Kp / Tu 	 
//PD 	0.8 Ku 	  	Kp Tu / 8
//classic PID 	0.6 Ku 	2 Kp / Tu 	Kp Tu / 8
//Pessen Integral Rule 	0.7 Ku 	0.4 Kp / Tu 	0.15 Kp Tu
//some overshoot 	0.33 Ku 	2 Kp / Tu 	Kp Tu / 3
//no overshoot 	0.2 Ku 	2 Kp / Tu 	Kp Tu / 3

//An immediate problem to overcome with this method is that it assumes a steady state can be achieved. With rockets, there is never a steady state: fuel is being consumed, altitude and therefore gravity and atmosphere is changing, staging can cause major upsets in the feedback loop. So, this tuning method will be some approximation which should come as no surprise since it will come from experimental observation. All we need is enough of a steady state that we can measure the oscillations - both the change in amplitude and the period.

//The script we’ll use to tune the highly overpowered rocket shown will launch the rocket straight up (using SAS) and will log data to an output file until it reaches 30km at which point the log file will be copied to the archive and the program will terminate. Also, this time the feedback loop will be based on the more realistic “atmospheric efficiency.” The log file will contain three columns: time since launch, offset of atmospheric efficiency from the ideal (in this case, 1.0) and the ship’s maximum thrust. The maximum thrust will increase monotonically with time (this rocket has only one stage) and we’ll use both as the x-axis when plotting the offset on the y-axis.

DECLARE PARAMETER Kp.

LOCK g TO SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:ALTITUDE)^2.
LOCK maxtwr TO SHIP:MAXTHRUST / (g * SHIP:MASS).

// feedback based on atmospheric efficiency
LOCK surfspeed TO SHIP:VELOCITY:SURFACE:MAG.
LOCK atmoeff TO surfspeed / SHIP:TERMVELOCITY.
LOCK P TO 1.0 - atmoeff.

SET t0 TO TIME:SECONDS.
LOCK dthrott TO Kp*P.
SET start_time TO t0.

LOG "# Throttle PID Tuning" TO throttle_log.
LOG "# Kp: " + Kp TO throttle_log.
LOG "# t P maxtwr" TO throttle_log.

LOCK logline TO (TIME:SECONDS - start_time)
        + " " + P
        + " " + maxtwr.

SET thrott TO 1.
LOCK THROTTLE TO thrott.
SAS ON.
STAGE.
WAIT 3.

UNTIL SHIP:ALTITUDE > 30000 {
    SET dt TO TIME:SECONDS - t0.
    IF dt > 0 {
        SET thrott TO MIN(1,MAX(0,thrott + dthrott)).
        SET t0 TO TIME:SECONDS.
        LOG logline TO throttle_log.
    }
    WAIT 0.001.
}
COPY throttle_log TO 0.

//Give this script a short name, something like “tune.txt” so that running is simple:

//copy tune from 0.
//run tune(0.5).

//After every launch completes, you’ll have to go into the archive directory and rename the output logfile. Something like “throttle_log.txt” –> “throttle.01.log” will help if you increment the index number each time. To analyze the data, plot the offset (P) as a function of time (t). Here, we show the results for three values of Kp: 0.002, 0.016 and 0.160, including the maximum TWR when Kp = 0.002 as the top x-axis. The maximum TWR dependence on time is different for the three values of Kp, but not by a lot.
}.

FUNCTION TESTE_10{//Execute Node Script
//Let’s try to automate one of the most common tasks in orbital maneuvering - execution of the maneuver node. In this tutorial I’ll try to show you how to write a script for somewhat precise maneuver node execution.

//So to start our script we need to get the next available maneuver node:

set nd to nextnode().

//Our next step is to calculate how much time our vessel needs to burn at full throttle to execute the node:

//print out node's basic parameters - ETA and deltaV
print "Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag).

//calculate ship's max acceleration
set max_acc to ship:maxthrust/ship:mass.

// Now we just need to divide deltav:mag by our ship's max acceleration
// to get the estimated time of the burn.
//
// Please note, this is not exactly correct.  The real calculation
// needs to take into account the fact that the mass will decrease
// as you lose fuel during the burn.  In fact throwing the fuel out
// the back of the engine very fast is the entire reason you're able
// to thrust at all in space.  The proper calculation for this
// can be found easily enough online by searching for the phrase
//   "Tsiolkovsky rocket equation".
// This example here will keep it simple for demonstration purposes,
// but if you're going to build a serious node execution script, you
// need to look into the Tsiolkovsky rocket equation to account for
// the change in mass over time as you burn.
//
set burn_duration to nd:deltav:mag/max_acc.
print "Crude Estimated burn duration: " + round(burn_duration) + "s".

//So now we have our node’s deltav vector, ETA to the node and we calculated our burn duration. All that is left for us to do is wait until we are close to node’s ETA less half of our burn duration. But we want to write a universal script, and some of our current and/or future ships can be quite slow to turn, so let’s give us some time, 60 seconds, to prepare for the maneuver burn:

wait until node:eta <= (burn_duration/2 + 60).

//This wait can be tedious and you’ll most likely end up warping some time, but we’ll leave kOS automation of warping for a given period of time to our readers.

//The wait has finished, and now we need to start turning our ship in the direction of the burn:

set np to nd:deltav. //points to node, don't care about the roll direction.
lock steering to np.

//now we need to wait until the burn vector and ship's facing are aligned
wait until abs(np:pitch - facing:pitch) < 0.15 and abs(np:yaw - facing:yaw) < 0.15.

//the ship is facing the right direction, let's wait for our burn time
wait until node:eta <= (burn_duration/2) .

//Now we are ready to burn. It is usually done in the until loop, checking main parameters of the burn every iteration until the burn is complete:

//we only need to lock throttle once to a certain variable in the beginning of the loop, and adjust only the variable itself inside it
set tset to 0.
lock throttle to tset.

set done to False.
//initial deltav
set dv0 to nd:deltav.
until done
{
    //recalculate current max_acceleration, as it changes while we burn through fuel
    set max_acc to ship:maxthrust/ship:mass.

    //throttle is 100% until there is less than 1 second of time left to burn
    //when there is less than 1 second - decrease the throttle linearly
    set tset to min(nd:deltav:mag/max_acc, 1).

    //here's the tricky part, we need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
    //this check is done via checking the dot product of those 2 vectors
    if vdot(dv0, nd:deltav) < 0
    {
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        lock throttle to 0.
        break.
    }

    //we have very little left to burn, less then 0.1m/s
    if nd:deltav:mag < 0.1
    {
        print "Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        //we burn slowly until our node vector starts to drift significantly from initial vector
        //this usually means we are on point
        wait until vdot(dv0, nd:deltav) < 0.5.

        lock throttle to 0.
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        set done to True.
    }
}
unlock steering.
unlock throttle.
wait 1.

//we no longer need the maneuver node
remove nd.

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

//That is all, this short script can execute any maneuver node with 0.1 m/s dv precision or even better.
}.

FUNCTION TESTE_11{//TOQUE_7_NATION().
	TOQUE_7_NATION().

}.








