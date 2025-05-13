@LAZYGLOBAL OFF.
//c3_nav.ks
// x funcoes: yyy linhas

//uses: 
//runoncepath("c3_init_vars").

// ====    FUNCOES PARA MOSTRAR INFOS DE VOO DA NAVE (NAVBALL) ========================================================================

	CLEARSCREEN.

PRINT "c3_nav : FUNCOES PARA MOSTRAR INFOS DE VOO DA NAVE (NAVBALL)".
PRINT "c3_nav :     USE [abort] PARA DESATIVAR".


//------------------------------------------------------------------------------------------------
						
local LINHA_HEADING is "[----------|----------]".
local LINHA_INCLIN 	is "[----------|----------]".
local LINHA_ROT 	is "[----------|----------]".

local LINHA_PREENCHE_top 	is "-----------|-----------".
local LINHA_PREENCHE_meio 	is "|          |          |".

local LINHA_VX is "[----------|----------]".
local LINHA_VY is "[----------|----------]".
local LINHA_VZ is "[----------|----------]".

local LINHA_PIT is "[---------|-----------]".
local LINHA_YAW is "[---------|-----------]".
local LINHA_ROL is "[---------|-----------]".

local lin_pos_init is 5.
local esp_col		is 10. //espaco entre colunas : deve caber o teste

local lin_hed_pos is lin_pos_init.
local lin_inc_pos is lin_pos_init+2.
local lin_rot_pos is lin_pos_init+4.

local lin_pit_pos is lin_pos_init.
local lin_yaw_pos is lin_pos_init+2.
local lin_rol_pos is lin_pos_init+4.


local lin_vx_pos is lin_pos_init+8.
local lin_vy_pos is lin_pos_init+10.
local lin_vz_pos is lin_pos_init+12.

local lin_Vy_axis_pos	is lin_pos_init.
local lin_Vx_axis_pos	is lin_pos_init + round(LINHA_HEADING:length/2,0).
local pos_para_axis_xy_y_lin is 0.
local pos_para_axis_xy_x_col is 0.


local lin_info_status is lin_pos_init+15.
local col_info_1	is 3.
local col_info_2	is col_info_1 + 15.
local col_info_3	is col_info_2 + 15.
local col_info_4	is col_info_3 + 27.

local title_heading		is "head:".
local title_inclination	is "bear:".
local title_rotation	is "rot :".

local title_vx			is "vx  :".
local title_vy			is "vy  :".
local title_vz			is "vz  :".

local title_pitch		is "pit :".
local title_yaw			is "yaw :".
local title_roll		is "roll:".

local col_print			is 10.
local col_print_title	is col_print - ((title_heading:LENGTH)).

local col_print_7	is col_print + 80.


local col_print_2	is col_print + (title_heading:LENGTH) + LINHA_HEADING:length + esp_col.
local col_print_2_title	is col_print_2 - ((title_heading:LENGTH)).

local v_max 		is 100.

//calcular o v_max conforme as unidades de tracos:



//------------------------------------------------------------------------------------------------
until abort {


	//imprime os titulos:
	print title_vx at(col_print_title, lin_VX_pos).
	print title_vy at(col_print_title, lin_VY_pos).
	print title_vz at(col_print_title, lin_VZ_pos).

	print title_heading 	at(col_print_title, lin_hed_pos).
	print title_inclination at(col_print_title, lin_inc_pos).
	print title_rotation 	at(col_print_title, lin_rot_pos).

	print title_pitch 	at(col_print_2_title, lin_hed_pos).
	print title_yaw 	at(col_print_2_title, lin_inc_pos).
	print title_roll 	at(col_print_2_title, lin_rot_pos).

	//calculo da pos do marcador:
	local pos_marc_head is 0.

	local porcent_head is (ship:heading)*( ((LINHA_HEADING:length-2)/2) /180).
	//retorna numero negativo:
	local porcent_bear is (ship:bearing + 180) * (  ((LINHA_HEADING:length-3)) /360).
	//local porcent_rot is (ship:???)*( ((LINHA_HEADING:length)/2) /180).

	local porcent_pitch is (ship:facing:pitch)*( ((LINHA_HEADING:length)/2) /180).
	local porcent_yaw 	is (ship:facing:yaw)*( ((LINHA_HEADING:length)/2) /180).
	local porcent_roll 	is (ship:facing:roll)*( ((LINHA_HEADING:length)/2) /180).


	if (SHIP:VELOCITY:SURFACE:MAG < 1){
		//SHIP:VERTICALSPEED,SHIP:VELOCITY:SURFACE:MAG
		set v_max to 1.
	}
	else if (SHIP:VELOCITY:SURFACE:MAG < 10){
		set v_max to 10.
	}
	else if (SHIP:VELOCITY:SURFACE:MAG < 100){
		set v_max to 100.
	}
	else if (SHIP:VELOCITY:SURFACE:MAG < 1000){
		set v_max to 1000.
	}
	else{//escolhe a maior velocidade para referencia:
		//set v_max to SHIP:VELOCITY:SURFACE:x.
		set v_max to SHIP:VELOCITY:SURFACE:mag.
		if (SHIP:VELOCITY:SURFACE:y > v_max){set v_max to SHIP:VELOCITY:SURFACE:y.}
		if (SHIP:VELOCITY:SURFACE:z > v_max){set v_max to SHIP:VELOCITY:SURFACE:z.}
	}

	local porcent_vx	is (SHIP:VELOCITY:SURFACE:x + v_max)*( ((LINHA_HEADING:length-3)) /(2*v_max)).
	local porcent_vy	is (SHIP:VELOCITY:SURFACE:y + v_max)*( ((LINHA_HEADING:length-3)) /(2*v_max)).
	local porcent_vz 	is (SHIP:VELOCITY:SURFACE:z + v_max)*( ((LINHA_HEADING:length-3)) /(2*v_max)).
	
	set porcent_vx to round(porcent_vx,0).
	set porcent_vy to round(porcent_vy,0).
	set porcent_vz to round(porcent_vz,0).

	print "porcent_head:" + round(porcent_head,1) at(col_info_1, lin_info_status).
	print "head:" + round(ship:heading,3) at(col_info_1, lin_info_status+1).
	print "bear:" + round(ship:bearing,3) at(col_info_1, lin_info_status+2).
//	print "head:" + ship:heading at(col_print, lin_info_status+1).

//If you just need the angle that the ship makes from the forevector of the ship and the top of the navball you can use this:
	//set pitch to vectorangle(up:vector,ship:forevector).
	// Define Pitch https://www.reddit.com/r/Kos/comments/318w7l/finding_navball_pitch/
	local pitch TO 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).
	
	print "p_calc:" + round(pitch,3) at(col_info_1, lin_info_status+3).

	print " facing" at(col_info_2, 	lin_info_status -1).
	print "pitch:" + round(ship:facing:pitch,3) at(col_info_2, lin_info_status+0).
	print "yaw:  " + round(ship:facing:yaw,3) 	at(col_info_2, lin_info_status+1).
	print "roll: " + round(ship:facing:roll,3) 	at(col_info_2, lin_info_status+2).


//direcao stering calculada
	local direcao_calc to Up + R(ship:facing:pitch, ship:facing:yaw, ship:facing:roll).
	
	print " d_calc: " + UP at(col_info_3, 	lin_info_status -1).
	print "dirfp:" + round(direcao_calc:pitch,3) at(col_info_3, lin_info_status+0).
	print "dirfy:" + round(direcao_calc:yaw,3) at(col_info_3, lin_info_status+1).
	print "dirfr:" + round(direcao_calc:roll,3) at(col_info_3, lin_info_status+2).
	

	set porcent_head to round(porcent_head,0).
	set porcent_bear to round(porcent_bear,0).
	//set porcent_rot  to round(porcent_rot,0).
	
	
	set porcent_pitch to round(porcent_pitch,0).
	set porcent_yaw to round(porcent_yaw,0).
	set porcent_roll to round(porcent_roll,0).
	
	//aqui loop
	print LINHA_HEADING + "     " 	at(col_print, lin_hed_pos).
	print LINHA_INCLIN 	+ "     " 	at(col_print, lin_INC_pos).
	print LINHA_ROT 	+ "     "  	at(col_print, lin_ROT_pos).

	print LINHA_PIT + "     " 	at(col_print_2,	lin_pit_pos).
	print LINHA_YAW + "     " 	at(col_print_2, lin_yaw_pos).
	print LINHA_ROL + "     " 	at(col_print_2, lin_rol_pos).

	print LINHA_VX + "     " 	at(col_print,lin_VX_pos).
	print LINHA_VY + "     " 	at(col_print, lin_VY_pos).
	print LINHA_VZ + "     " 	at(col_print, lin_VZ_pos).
	
//PREPARA EIXOS ----------------------------------------------------------------:
	print LINHA_PREENCHE_top	at(col_print_7, lin_Vy_axis_pos).
	from {local l to 0.} 
		until l = (LINHA_HEADING:length - 1)
		step {set l to l + 1.}
		do {
				if ((lin_Vy_axis_pos + l +1) = (lin_Vx_axis_pos)){
					print LINHA_VX	at(col_print_7, lin_Vx_axis_pos).
				}else{
					print LINHA_PREENCHE_meio	at(col_print_7, lin_Vy_axis_pos + l +1).
				}
			}	
	print LINHA_PREENCHE_top	at(col_print_7, lin_Vy_axis_pos + LINHA_HEADING:length ).
//FIM PREPARA EIXOS:
//IMPRIME NOS EIXOS:---------------------------------------------------------------------------------------------
	
		//eixo Y : de cima para baixo
	print "X" at(col_print_7 + round(LINHA_HEADING:length /2,0) -1, (lin_Vy_axis_pos + 1)  + porcent_vy	).
	set pos_para_axis_xy_y_lin to (lin_Vy_axis_pos + 1)  + porcent_vy.
	set pos_para_axis_xy_x_col to col_print_7 +1 + porcent_vx.
	print "*" at(pos_para_axis_xy_x_col, pos_para_axis_xy_y_lin).
	print "X" at(pos_para_axis_xy_x_col, lin_Vx_axis_pos	).
	

//heading, bearing
	//print "X" at(col_print + porcent_head , lin_hed_pos).
	print "X" at((col_print +1 ) + porcent_head , lin_hed_pos).
	print "X" at((col_print +1 ) + porcent_bear , lin_inc_pos).
	//print "X" at(col_print + porcent_rot , lin_rot_pos).
	print porcent_head at(col_print + LINHA_HEADING:length + 2 , lin_hed_pos).
	print porcent_bear 	at(col_print + LINHA_HEADING:length + 2 , lin_inc_pos).
	//print porcent_rot 	at(col_print + LINHA_HEADING:length + 2 , lin_rot_pos).


//pitch, yaw, roll
	print "X" at(col_print_2 + porcent_pitch , 	lin_pit_pos).
	print "X" at(col_print_2 + porcent_yaw , 	lin_yaw_pos).
	print "X" at(col_print_2 + porcent_roll , 	lin_rol_pos).

	print porcent_pitch at(col_print_2 + LINHA_HEADING:length + 2 , lin_pit_pos).
	print porcent_yaw 	at(col_print_2 + LINHA_HEADING:length + 2 , lin_yaw_pos).
	print porcent_roll 	at(col_print_2 + LINHA_HEADING:length + 2 , lin_rol_pos).
	
	
//vx, vy, vz
	print "v_max:" + round(v_max,2) at(col_print, 	lin_vx_pos -1).

	print "X" at(col_print +1 + porcent_vx, 	lin_vx_pos).
	print "X" at(col_print +1 + porcent_vy, 	lin_vy_pos).
	print "X" at(col_print +1 + porcent_vz, 	lin_vz_pos).

	print porcent_vx 	at(col_print + LINHA_HEADING:length + 2 , lin_vx_pos).
	print porcent_vy 	at(col_print + LINHA_HEADING:length + 2 , lin_vy_pos).
	print porcent_vz 	at(col_print + LINHA_HEADING:length + 2 , lin_vz_pos).
	
	print " vel_surf: " + round(SHIP:VELOCITY:SURFACE:mag,2) at(col_info_4, 	lin_info_status -1).
	print "vx:" + round(SHIP:VELOCITY:SURFACE:x,3) 	at(col_info_4, lin_info_status+0).
	print "vy:" + round(SHIP:VELOCITY:SURFACE:y,3) 	at(col_info_4, lin_info_status+1).
	print "vz:" + round(SHIP:VELOCITY:SURFACE:z,3) 	at(col_info_4, lin_info_status+2).
	
	

	wait 0.0001.
	
}.

//https://www.youtube.com/watch?v=7AkakB5TOSw&list=PLB3Ia8aQsDKgAa9pyjeSDic49oi591zqC&index=3&t=0s


// BEARING	scalar (deg)	relative heading to this vessel
// HEADING	scalar (deg)	Absolute heading to this vessel

// FACING	Direction	The way the vessel is pointed
	// PITCH	scalar (deg)	Rotation around x axis
	// YAW		scalar (deg)	Rotation around y axis
	// ROLL	scalar (deg)	Rotation around z axis

//------------------------------------------------------------------------------------------------

// na tela:

// nvaball:

		// heading:    [-----=--------------]
		// incl   :    [-----=--------------]

		// rot    :    [-----=--------------]

// velocity:

		// vx     :    [-----=--------------]
		// vy     :    [-----=--------------]

		// vz     :    [-----=--------------]



// display_block(Col_Init + 20,Linha_Init,seekAlt, alt_radar, Kp, Kd, Ki, Fg, am, THROTTLE, T_star,ship:availablethrust,
                        // dir_1, dir_2, dir_3,compass_dir_1, pitch_dir_2,
                        // SHIP:VERTICALSPEED,SHIP:VELOCITY:SURFACE:MAG,
						// SHIP:VELOCITY:SURFACE:x,SHIP:VELOCITY:SURFACE:y,SHIP:VELOCITY:SURFACE:z,
						// SHIP:MASS,Fg).

// structureOrbitable
// These terms are all read-only.

// Suffix	Type (units)
// NAME	String
// BODY	Body
// HASBODY	boolean
// HASORBIT	boolean
// HASOBT	boolean
// OBT	Orbit
// ORBIT	Orbit
// UP	Direction
// NORTH	Direction
// PROGRADE	Direction
// SRFPROGRADE	Direction
// RETROGRADE	Direction
// SRFRETROGRADE	Direction
// POSITION	Vector
// VELOCITY	OrbitableVelocity
// DISTANCE	scalar (m)
// DIRECTION	Direction
// LATITUDE	scalar (deg)
// LONGITUDE	scalar (deg)
// ALTITUDE	scalar (m)
// GEOPOSITION	GeoCoordinates
// PATCHES	List of Orbits
// APOAPSIS	scalar (m) (Deprecated, use :OBT:APOAPSIS instead.)
// PERIAPSIS	scalar (m) (Deprecated, use :OBT:PERIAPSIS instead.)


// A library of functions to calculate navball-based directions:

// This file is distributed under the terms of the MIT license, (c) the KSLib team

//@lazyglobal off.
//https://github.com/KSP-KOS/KSLib/blob/master/library/lib_navball.ks

function east_for {
  parameter ves.

  return vcrs(ves:up:vector, ves:north:vector).
}

function compass_for {
  parameter ves.

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

  return 90 - vang(ves:up:vector, ves:facing:forevector).
}

function roll_for {
  parameter ves.
  
  if vang(ves:facing:vector,ves:up:vector) < 0.2 { //this is the dead zone for roll when the vessel is vertical
    return 0.
  } else {
    local raw is vang(vxcl(ves:facing:vector,ves:up:vector), ves:facing:starvector).
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
	