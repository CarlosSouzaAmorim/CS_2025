#include <a_samp>
#include <core>
#include <float>

#pragma tabsize 0

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define    COLOR_RED 0xAA3333AA
#define COLOR_RED_ST 0xFF004040
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA

#define COLOR_RED2   	0xFF4040FF
#define COLOR_GREEN2 	0x40FF40FF
#define COLOR_BLUE2  	0x4040FFFF

#define COLOR_CYAN2  	0x40FFFFFF
#define COLOR_PINK2  	0xFF40FFFF
#define COLOR_YELLOW2    0xFFFF40FF

#define COLOR_WHITE2		0xFFFFFFFF
#define COLOR_BLACK2		0x000000FF
#define COLOR_NONE2      0x00000000

#define PocketMoney 50000 // Amount player recieves on spawn.
#define INACTIVE_PLAYER_ID 255
#define GIVECASH_DELAY 5000 // Time in ms between /givecash commands.

#define NUMVALUES 4

forward MoneyGrubScoreUpdate();
forward Givecashdelaytimer(playerid);
forward SetPlayerRandomSpawn(playerid);
forward SetupPlayerForClassSelection(playerid);
forward GameModeExitFunc();

forward SendPlayerFormattedText     (playerid, const str[], define                 );
forward SendAllFormattedText        (playerid, const str[], define                 );

//Mensagens de observacao das funcoes (irrelevantes para o usuario)
forward MOSTRA_INFO3_dd             (playerid, const str[], define      , define2  );//VERDE ESCURO MEDIO (GREEN COLOR_INFO3)

forward SendPlayerFormattedTextDEBUGds  (playerid, const str[], define2     , const str2[]  );
forward DEBUG_LIST_ds               (playerid, const str[], define2     , const str2[]  );
forward DEBUG_LIST2_ds              (playerid, const str[], define2, const str2[]);
forward DEBUGsdds                   (playerid, const str[], const str2[], define        , define2 , const str3[]);
forward DEBUG_sd                    (playerid, const str[], const str2[], define        );
forward DEBUG_ds                    (playerid, const str[], define      , const str2[]  );              //NIVEL 1
forward DEBUG2_ds                    (playerid, const str[], define      , const str2[]  );             //NIVEL 2
forward DEBUG_sds                   (playerid, const str[], const str2[], define, const str3[]);
forward DEBUG_INFO_sd (playerid, const str[], const str2[], define);
forward DEBUG_INFO_ds (playerid, const str[], define, const str2[]);


forward SendPlayerFormattedTextINFOds   (playerid, const str[], define2     , const str2[]  );
forward MOSTRA_INFO2_dd             (playerid, const str[], define      , define2       );
forward SendPlayerFormattedTextINFOsd   (playerid, const str[], const str2[], define2       );
forward MOSTRA_INFO_dss             (playerid, const str[], define,const str1[],const str2[]);
forward MOSTRA_INFO_sd              (playerid, const str[], const str1[], define);
forward MOSTRA_INFO_ssd             (playerid, const str[],const str1[],const str2[], define);
forward MOSTRA_INFO_sdd             (playerid, const str[],const str1[], define, define2);
forward MOSTRA_INFO1_dsd            (playerid, const str[], define,const str2[], define2);       //info1 : INFORMACOES DE DESTAQUE (deven ser vistas pelo usuario)
forward MOSTRA_INFO1_s              (playerid, const str[]);

forward SHOW_HELP                   (playerid, const str[]);
forward SHOW_HELP_d                 (playerid, const str[], define);

forward MOSTRA_TEXTO1               (playerid, const str[], define      );//SUBSTITUI : SendPlayerFormattedText
forward MOSTRA_TEXTO_dss            (playerid, const str[], define, const str1[], const str2[]); //TEXTO DA FUCAO dss //VERMELHO BEM VISIVEL
forward MOSTRA_TEXTO_ssd            (playerid, const str[], const str1[], const str2[],define); //TEXTO DA FUCAO ssd //VERMELHO BEM VISIVEL  para itens encontrados

forward MOSTRA_ERRO_ds              (playerid, const str[], define2     , const str2[]  );
forward MOSTRA_ERRO_sd              (playerid, const str[], const str2[], define2       );
forward MOSTRA_ERRO_sdd(playerid, const str[], const str2[], define1, define2);



//------------------------------------------------------------------------------------------------------

//		SetPlayerFacingAngle(playerid, 300.0);//ISSO DEVERIA ESTAR NO ARRAY POSICOES TB
new Float:gRandomPlayerSpawns[5][4] = {

{2199.6531,1393.3678,10.8203,180.0},    //ok        0	:estacionamento   			lv "AUTO-BAHN" (ruim pra carros) perto da esfinge
{1958.3783,1343.1572,15.3746,270.0}, 	//pos_id =  1 	:numa escada rolanta(carro nao da)    lv (ruim pra carros)
{2483.5977,1222.0825,10.8203,0.0  },    //		    2	:entre ruas perto piramide  (BOM pra carros)
{2637.2712,1127.2743,11.1797,180.0},    //ok	    3    :POSTO X
{2000.0106,1521.1111,17.0625, 0.0}     //          4     barco viking 
//{2024.8190,1917.9425,12.3386},
//{2261.9048,2035.9547,10.8203},
//{2262.0986,2398.6572,10.8203},
//{2244.2566,2523.7280,10.8203},
//{2335.3228,2786.4478,10.8203},
//{2150.0186,2734.2297,11.1763},
//{2158.0811,2797.5488,10.8203},
//{1969.8301,2722.8564,10.8203},
//{1652.0555,2709.4072,10.8265},
//{1564.0052,2756.9463,10.8203},
//{1271.5452,2554.0227,10.8203},
//{1441.5894,2567.9099,10.8203},
//{1480.6473,2213.5718,11.0234},
//{1400.5906,2225.6960,11.0234},
//{1598.8419,2221.5676,11.0625},
//{1318.7759,1251.3580,10.8203},
//{1558.0731,1007.8292,10.8125},
//{-857.0551,1536.6832,22.5870},   Out of Town Spawns
//{817.3494,856.5039,12.7891},
//{116.9315,1110.1823,13.6094},
//{-18.8529,1176.0159,19.5634},
//{-315.0575,1774.0636,43.6406},
//{1705.2347,1025.6808,10.8203}
};

new Float:gCopPlayerSpawns[2][4] = {
{2297.1064,2452.0115,10.8203,300.0},
{2297.0452,2468.6743,10.8203,300.0}
};

enum Carro_info{
    Nome[20],
    tipo[20],
    utilidade[20],
    portas[20],
    special[20]
};
new CarrosNomes[212][Carro_info] = {
    {"Landstal", "jeep off road", "", "", ""}, //400
    {"Bravura", "2p", "", "", ""},
    {"Buffalo", "sport", "", "", ""},
    {"Linerun", "truck", "eng", "", ""},
    {"Peren", "4p", "", "", ""},
    {"Sentinel", "4p", "", "", ""},
    {"Dumper", "big basc", "", "", ""},
    {"Firetruck", "truck agua", "", "", ""},
    {"Trash", "truck lixo", "", "", ""},
    {"Stretch", "limo 4p", "", "", ""},
    {"Manana", "2p", "", "", ""},
    {"Infernus", "sport", "", "", ""},
    {"Voodoo", "Lowrider", "2p", "", ""},
    {"Pony", "furgao", "", "", ""},
    {"Mule", "truck", "bau", "", ""},
    {"Cheetah", "sport", "", "", ""},
    {"Ambulan", "truck", "ambulancia", "", ""},
    {"Leviathn", "hell", "big", "", ""},
    {"Moonbeam", "van 4p", "", "", ""},
    {"Esperant", "2p", "", "", ""},
    {"Taxi", "taxi 4p", "", "", ""},
    {"Washing", "4p", "", "", ""},
    {"Bobcat", "caminhonete", "", "", ""},
    {"Mrwhoop", "truck sorvete", "", "", ""},
    {"Bfinjet", "buggy off road", "", "", ""},
    {"Hunter", "hell", "gun", "mil", ""},
    {"Premier", "sedan", "4p", "", ""},
    {"Enforcer", "truck", "swat", "", ""},
    {"Securica", "truck", "segur", "", ""},
    {"Banshee", "sport", "convers", "", ""},
    {"Predator", "barco", "police", "", ""},
    {"Bus", "onibus", "3e", "", ""},
    {"Rhino", "tank", "mil", "gun", ""},
    {"Barracks", "truck", "mil", "carroc", ""},
    {"Hotknife", "sport", "hotroad", "", ""},
    {"Artic1", "carga", "bau", "2e", ""},
    {"Previon", "sedan", "2p", "", ""},
    {"Coach", "onibus", "3e", "", ""},
    {"Cabbie", "taxi", "4p", "antigo", ""},
    {"Stallion", "sport", "conversivel", "", ""},
    {"Rumpo", "furgao", "portaatras", "", ""},
    {"Rcbandit", "rc", "corrida", "", ""},
    {"Romero", "minvan", "funeral","4p", ""},
    {"Packer", "truck", "rampa", "", ""},
    {"Monster", "caminhonete", "big", "", ""},
    {"Admiral", "sedan", "4p", "", ""},
    {"Squalo", "lancha", "fast", "", ""},
    {"Seaspar", "hell", "aqua", "", ""},
    {"Pizzaboy", "moto", "lambreta", "", ""},
    {"Tram", "vagao", "trilhos", "", ""},
    {"Artic2", "carga", "carroc", "2e", ""},
    {"Turismo", "sport", "", "", ""},
    {"Speeder", "lancha", "fast", "", ""},
    {"Reefer", "barco", "", "", ""},
    {"Tropic", "barco", "", "", ""},
    {"Flatbed", "truck", "carroc"},
    {"Yankee", "truck", "bau", "", ""},
    {"Caddy", "small", "golf", "", ""},
    {"Solair", "minivan", "4p", "", ""},
    {"Topfun", "furgao", "forrc", "", ""},
    {"Skimmer", "aviao", "aqua", "", ""},
    {"Pcj600", "moto", "sport", "", ""},
    {"Faggio", "moto", "lambreta", "", ""},
    {"Freeway", "moto", "custom", "", ""},
    {"Rcbaron", "rc", "aviaorc", "", ""},
    {"Rcraider", "rc", "hellrc", "", ""},
    {"Glendale", "sedan", "4p", "antigo", ""},
    {"Oceanic", "sedan", "4p", "antigo", ""},
    {"Sanchez", "moto", "trilha", "", ""},
    {"Sparrow", "hell", "small", "", ""},
    {"Patriot", "jeep", "4p", "mil", ""},
    {"Quad", "quadriciclo", "", "", ""},
    {"Coastg", "lancha", "guarda", "", ""},
    {"Dinghy", "lancha", "inflavel", "", ""},
    {"Hermes", "sedan", "2p", "antigo", ""},
    {"Sabre", "muscle", "2p", "", ""},
    {"Rustler", "aviao", "monomotor","gun", ""},
    {"Zr350", "sport", "2p", "", ""},
    {"Walton", "caminhonete", "carroceria", "antigo", ""},
    {"Regina", "minivan", "4p", "", ""},
    {"Comet", "sport", "conversivel", "", ""},
    {"Bmx", "bicicleta", "bmx", "", ""},
    {"Burrito", "furgao", "portaatras", "", ""},
    {"Camper", "combi", "2p", "", ""},
    {"Marquis", "barco", "vela", "", ""},
    {"Baggage", "small", "", "", ""},
    {"Dozer", "maquina", "basc", "", ""},
    {"Maverick", "hell", "4p", "", ""},
    {"Vcnmav", "hell", "2p", "news", ""},
    {"Rancher", "jeep", "2p", "", ""},
    {"Fbiranch", "jeep", "4p", "", ""},
    {"Virgo", "sedan", "2p", "", ""},
    {"Greenwoo", "sedan", "4p", "", ""},
    {"Jetmax", "lancha", "fast", "", ""},
    {"Hotring", "sedan", "2p", "competicao", ""},
    {"Sandking", "jeep", "2p", "offroad", ""},
    {"Blistac", "hatch", "2p", "", ""},
    {"Polmav", "hall", "4p", "police", ""},
    {"Boxville", "truck", "bau", "4p?", ""},
    {"Benson", "truck", "bau", "", ""},
    {"Mesa", "jeep", "2p", "convet", ""},
    {"Rcgoblin", "rc", "hellrc", "", ""},
    {"Hotrina", "sedan", "2p", "competicao", ""},
    {"Hotrinb", "sedan", "2p", "competicao", ""},
    {"Bloodra", "sedan", "2p?janela", "competicao", ""},
    {"Rnchlure", "jeep", "2p", "", ""},
    {"Supergt", "sport", "convert", "", ""},
    {"Elegant", "sedan", "4p", "", ""},
    {"Journey", "motorhome", "", "", ""},
    {"Bike", "bicicleta", "2seat?", "", ""},
    {"Mtbike", "bicicleta", "", "", ""},
    {"Beagle", "aviao", "big", "bimotor", ""},
    {"Cropdust", "aviao", "monomotor", "lavoura", ""},
    {"Stunt", "aviao", "monomotor", "manobras", ""},
    {"Petro", "truck", "eng", "", ""},
    {"Rdtrain", "truck", "eng", "", ""},
    {"Nebula", "sedan", "4p", "", ""},
    {"Majestic", "sedan", "2p", "", ""},
    {"Buccanee", "classicsedan", "2p", "", ""},
    {"Shamal", "jato", "big", "", ""},
    {"Hydra", "jato", "2gun", "vertical", ""},
    {"Fcr900", "moto", "sport", "", ""},
    {"Nrg500", "moto", "sport", "", ""},
    {"Copbike", "moto", "custom", "policia", ""},
    {"Cement", "truck", "utilidades", "cimento", "basculante?"},
    {"Towtruck", "caminhonete", "guincho", "utilidades", ""},
    {"Fortune", "sedan", "2p", "", ""},
    {"Cadrona", "sedan", "2p", "", ""},
    {"Fbitruck", "camburao", "2p?", "policia", ""},
    {"Willard", "sedan", "4p", "", ""},
    {"Forklift", "small", "basculante", "empilhadeira", ""},
    {"Tractor", "trator", "basculante", "eng", "lavoura"},
    {"Combine", "maquina", "lavoura", "basculante?", ""},
    {"Feltzer", "sport", "2p", "convert", ""},
    {"Remingtn", "classicsedan", "2p", "", ""},
    {"Slamvan", "caminhonete", "sport", "2p", ""},
    {"Blade", "lowrider?", "2p", "convert", ""},
    {"Freight", "trainvagon", "trilhos", "", ""},
    {"Streak", "trainlocomotive", "trilhos", "", ""},
    {"Vortex", "off road", "barco", "anfibio", ""},
    {"Vincent", "sedan", "4p", "", ""},
    {"Bullet", "sport", "2p", "", ""},
    {"Clover", "muscle", "2p", "antigo", ""},
    {"Sadler", "caminhonete", "2p", "", ""},
    {"Firela", "truck", "agua", "utilidades", ""},
    {"Hustler", "sport","hotroad", "antigo", ""},
    {"Intruder", "sedan", "4p", "", ""},
    {"Primo", "sedan", "4p", "", ""},
    {"Cargobob", "hell", "big", "cargo", ""},
    {"Tampa", "muscle", "antigo", "2p", ""},
    {"Sunrise", "sedan", "4p", "", ""},
    {"Merit", "sedan", "4p", "", ""},
    {"Utility", "caminhonete", "utilidade", "sanitaria", ""},
    {"Nevada", "aviao", "bimotor", "big", ""},
    {"Yosemite", "caminhonete", "2p", "", ""},
    {"Windsor", "sport", "2p", "convert", ""},
    {"Monstera", "caminhonete", "big", "", ""},
    {"Monsterb", "caminhonete", "big", "", ""},
    {"Uranus", "sedan", "2p", "", ""},
    {"Jester", "sport", "2p", "", ""},
    {"Sultan", "sedan", "4p", "", ""},
    {"Stratum", "minivan", "4p", "", ""},
    {"Elegy", "sedan", "2p", "", ""},
    {"Raindanc", "hell", "2p", "utilidade", "bombeiros?"},
    {"Rctiger", "rc", "tankrc", "", ""},
    {"Flash", "hatch", "2p", "", ""},
    {"Tahoma", "sedan", "4p", "", ""},
    {"Savanna", "lowrider", "4p", "convert", ""},
    {"Bandito", "off road", "gaiola", "", ""},
    {"Freiflat", "trainvagon", "trilhos", "", ""},
    {"Streakc", "trainvagon", "trilhos", "", ""},
    {"Kart", "small", "competicao", "", ""},
    {"Mower", "small", "utilidade", "cortador grama", ""},
    {"Duneride", "truck", "sport", "off road", ""},
    {"Sweeper", "small", "limpador ruas", "utilidade", ""},
    {"Broadway", "classicsport", "2p", "antigo", "convert"},
    {"Tornado", "classicsedan", "2p", "antigo", ""},
    {"At400", "aviao", "big", "", ""},
    {"Dft30", "truck", "carroceria", "", ""},
    {"Huntley", "jeep", "4p", "", ""},
    {"Stafford", "sedan", "4p", "", ""},
    {"Bf400", "moto", "", "", ""},
    {"Newsvan", "furgao", "news", "", ""},
    {"Tug", "small", "", "", ""},
    {"Petrotr", "carga", "tanque", "", ""},
    {"Emperor", "sedan", "4p", "", ""},
    {"Wayfarer", "moto", "custom", "", ""},
    {"Euros", "sport", "2p", "", ""},
    {"Hotdog", "konbi", "2p", "", ""},
    {"Club", "hatch", "2p", "", ""},
    {"Freibox", "trainvagon", "trilhos", "imovel", ""},
    {"Artic3", "carga", "bau", "", ""},
    {"Androm", "aviao", "big", "", ""},
    {"Dodo", "aviao", "monomotor", "", ""},
    {"Rccam", "balde", "", "", ""},
    {"Launch", "lancha", "gun?", "", ""},
    {"Copcarla", "sedan", "4p", "policia", ""},
    {"Copcarsf", "sedan", "4p", "policia", ""},
    {"Copcarvg", "sedan", "4p", "policia", ""},
    {"Copcarru", "jeep", "2p", "policia", "off road"},
    {"Picador", "caminhonete", "2p", "", ""},
    {"Swatvan", "tank", "agua", "policia", ""},
    {"Alpha", "sedan", "2p", "", ""},
    {"Phoenix", "muscle", "2p", "gosto", "muito"},
    {"Glenshit", "classicsedan", "4p", "danificado", ""},
    {"Sadlshit", "caminhonete", "2p", "danificado", ""},
    {"Bagboxa", "carga", "small", "bau", ""},
    {"Bagboxb", "carga", "small", "carroceria", ""},
    {"Tugstair", "carga", "escada", "small", ""},
    {"Boxburg", "furgao", "ladrao", "", ""},
    {"Farmtr1", "carga", "trator", "fazenda", ""},
    {"Utiltr1", "carga", "small", "gerador?" , ""}//611    
};
/* e eixos
// p portas

    categorias       portas atras
        jeep, truck, furgao, van tank, taxi, lowrider, caminhonete, sport
        hell, aviao, sedan, barco, bicicleta, onibus, hotroad, rc
    especif
        big, eng, off road, gun, aguagun, aqua, conversivel
        
    utilidade
        ambulancia, policia, mil
    tipo
        corroc, antigo, quebrado

new CarrosModels[2][256] = {
    {400, }
};*/
new NomesArmasIngles[][32] = {
	{"Unarmed (Fist)"}, // 0
	{"Brass Knuckles"}, // 1
	{"Golf Club"}, // 2
	{"Night Stick"}, // 3
	{"Knife"}, // 4
	{"Baseball Bat"}, // 5
	{"Shovel"}, // 6
	{"Pool Cue"}, // 7
	{"Katana"}, // 8
	{"Chainsaw"}, // 9
	{"Purple Dildo"}, // 10
	{"Big White Vibrator"}, // 11
	{"Medium White Vibrator"}, // 12
	{"Small White Vibrator"}, // 13
	{"Flowers"}, // 14
	{"Cane"}, // 15
	{"Grenade"}, // 16
	{"Teargas"}, // 17
	{"Molotov"}, // 18
	{" "}, // 19
	{" "}, // 20
	{" "}, // 21
	{"Colt 45"}, // 22
	{"Colt 45 (Silenced)"}, // 23
	{"Desert Eagle"}, // 24
	{"Normal Shotgun"}, // 25
	{"Sawnoff Shotgun"}, // 26
	{"Combat Shotgun"}, // 27
	{"Micro Uzi (Mac 10)"}, // 28
	{"MP5"}, // 29
	{"AK47"}, // 30
	{"M4"}, // 31
	{"Tec9"}, // 32
	{"Country Rifle"}, // 33
	{"Sniper Rifle"}, // 34
	{"Rocket Launcher"}, // 35
	{"Heat-Seeking Rocket Launcher"}, // 36
	{"Flamethrower"}, // 37
	{"Minigun"}, // 38
	{"Satchel Charge"}, // 39
	{"Detonator"}, // 40
	{"Spray Can"}, // 41
	{"Fire Extinguisher"}, // 42
	{"Camera"}, // 43
	{"Night Vision Goggles"}, // 44
	{"Infrared Vision Goggles"}, // 45
	{"Parachute"}, // 46
	{"Fake Pistol"} // 47
};
new NomesVeiculosIngles[212][] = {	// Vehicle Names - Betamaster
	{"Landstalker"},
	{"Bravura"},
	{"Buffalo"},
	{"Linerunner"},
	{"Perrenial"},
	{"Sentinel"},
	{"Dumper"},
	{"Firetruck"},
	{"Trashmaster"},
	{"Stretch"},
	{"Manana"},
	{"Infernus"},
	{"Voodoo"},
	{"Pony"},
	{"Mule"},
	{"Cheetah"},
	{"Ambulance"},
	{"Leviathan"},
	{"Moonbeam"},
	{"Esperanto"},
	{"Taxi"},
	{"Washington"},
	{"Bobcat"},
	{"Mr Whoopee"},
	{"BF Injection"},
	{"Hunter"},
	{"Premier"},
	{"Enforcer"},
	{"Securicar"},
	{"Banshee"},
	{"Predator"},
	{"Bus"},
	{"Rhino"},
	{"Barracks"},
	{"Hotknife"},
	{"Trailer 1"}, //artict1
	{"Previon"},
	{"Coach"},
	{"Cabbie"},
	{"Stallion"},
	{"Rumpo"},
	{"RC Bandit"},
	{"Romero"},
	{"Packer"},
	{"Monster"},
	{"Admiral"},
	{"Squalo"},
	{"Seasparrow"},
	{"Pizzaboy"},
	{"Tram"},
	{"Trailer 2"}, //artict2
	{"Turismo"},
	{"Speeder"},
	{"Reefer"},
	{"Tropic"},
	{"Flatbed"},
	{"Yankee"},
	{"Caddy"},
	{"Solair"},
	{"Berkley's RC Van"},
	{"Skimmer"},
	{"PCJ-600"},
	{"Faggio"},
	{"Freeway"},
	{"RC Baron"},
	{"RC Raider"},
	{"Glendale"},
	{"Oceanic"},
	{"Sanchez"},
	{"Sparrow"},
	{"Patriot"},
	{"Quad"},
	{"Coastguard"},
	{"Dinghy"},
	{"Hermes"},
	{"Sabre"},
	{"Rustler"},
	{"ZR-350"},
	{"Walton"},
	{"Regina"},
	{"Comet"},
	{"BMX"},
	{"Burrito"},
	{"Camper"},
	{"Marquis"},
	{"Baggage"},
	{"Dozer"},
	{"Maverick"},
	{"News Chopper"},
	{"Rancher"},
	{"FBI Rancher"},
	{"Virgo"},
	{"Greenwood"},
	{"Jetmax"},
	{"Hotring"},
	{"Sandking"},
	{"Blista Compact"},
	{"Police Maverick"},
	{"Boxville"},
	{"Benson"},
	{"Mesa"},
	{"RC Goblin"},
	{"Hotring Racer A"}, //hotrina
	{"Hotring Racer B"}, //hotrinb
	{"Bloodring Banger"},
	{"Rancher"},
	{"Super GT"},
	{"Elegant"},
	{"Journey"},
	{"Bike"},
	{"Mountain Bike"},
	{"Beagle"},
	{"Cropdust"},
	{"Stunt"},
	{"Tanker"}, //petro
	{"Roadtrain"},
	{"Nebula"},
	{"Majestic"},
	{"Buccaneer"},
	{"Shamal"},
	{"Hydra"},
	{"FCR-900"},
	{"NRG-500"},
	{"HPV1000"},
	{"Cement Truck"},
	{"Tow Truck"},
	{"Fortune"},
	{"Cadrona"},
	{"FBI Truck"},
	{"Willard"},
	{"Forklift"},
	{"Tractor"},
	{"Combine"},
	{"Feltzer"},
	{"Remington"},
	{"Slamvan"},
	{"Blade"},
	{"Freight"},
	{"Streak"},
	{"Vortex"},
	{"Vincent"},
	{"Bullet"},
	{"Clover"},
	{"Sadler"},
	{"Firetruck LA"}, //firela
	{"Hustler"},
	{"Intruder"},
	{"Primo"},
	{"Cargobob"},
	{"Tampa"},
	{"Sunrise"},
	{"Merit"},
	{"Utility"},
	{"Nevada"},
	{"Yosemite"},
	{"Windsor"},
	{"Monster A"}, //monstera
	{"Monster B"}, //monsterb
	{"Uranus"},
	{"Jester"},
	{"Sultan"},
	{"Stratum"},
	{"Elegy"},
	{"Raindance"},
	{"RC Tiger"},
	{"Flash"},
	{"Tahoma"},
	{"Savanna"},
	{"Bandito"},
	{"Freight Flat"}, //freiflat
	{"Streak Carriage"}, //streakc
	{"Kart"},
	{"Mower"},
	{"Duneride"},
	{"Sweeper"},
	{"Broadway"},
	{"Tornado"},
	{"AT-400"},
	{"DFT-30"},
	{"Huntley"},
	{"Stafford"},
	{"BF-400"},
	{"Newsvan"},
	{"Tug"},
	{"Trailer 3"}, //petrotr
	{"Emperor"},
	{"Wayfarer"},
	{"Euros"},
	{"Hotdog"},
	{"Club"},
	{"Freight Carriage"}, //freibox
	{"Trailer 3"}, //artict3
	{"Andromada"},
	{"Dodo"},
	{"RC Cam"},
	{"Launch"},
	{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},
	{"Police Ranger"},
	{"Picador"},
	{"S.W.A.T. Van"},
	{"Alpha"},
	{"Phoenix"},
	{"Glendale"},
	{"Sadler"},
	{"Luggage Trailer A"}, //bagboxa
	{"Luggage Trailer B"}, //bagboxb
	{"Stair Trailer"}, //tugstair
	{"Boxville"},
	{"Farm Plow"}, //farmtr1
	{"Utility Trailer"} //utiltr1
};

//Round code stolen from mike's Manhunt :P
//new gRoundTime = 3600000;                   // Round time - 1 hour
//new gRoundTime = 1200000;					// Round time - 20 mins
//new gRoundTime = 900000;					// Round time - 15 mins
//new gRoundTime = 600000;					// Round time - 10 mins
//new gRoundTime = 300000;					// Round time - 5 mins
//new gRoundTime = 120000;					// Round time - 2 mins
//new gRoundTime = 60000;					// Round time - 1 min

new CashScoreOld;
new iSpawnSet[MAX_PLAYERS];

new gActivePlayers[MAX_PLAYERS];
new gLastGaveCash[MAX_PLAYERS];

new player_saved[MAX_PLAYERS];

// ---- FIM JA TINHA NO GAMEMODE 

//new COLOR_MSG   = COLOR_GREEN;          //VERDE ESCURO MEDIO
new COLOR_DEBUG = COLOR_GREEN;
new COLOR_INFO 	= COLOR_RED;
new COLOR_INFO1 = COLOR_RED_ST;
new COLOR_INFO2 = COLOR_RED;            //usado em listagem deve ser diferente de INFO3
new COLOR_INFO3 = COLOR_GREEN;          //USAR EM contraste com info2 para numa lista mostrar o que encontrou
new COLOR_HELP 	= COLOR_WHITE;
new COLOR_HELP1	= COLOR_WHITE;
new COLOR_LIST 	= COLOR_YELLOW;
//new COLOR_CHAT 	= COLOR_GRAY;
new COLOR_ERRO1 = 0xFFFF0000;           //EM TEST 
new COLOR_TEXT1   = COLOR_RED_ST;         //VERMELHO BEM VISIVEL
new COLOR_TEXTALL = 0xFFFF00AA;

new mostra_debug[MAX_PLAYERS];
new mostra_debug_geral[MAX_PLAYERS];
new mostra_debug_list[MAX_PLAYERS];

new mostra_debug_nivel_2[MAX_PLAYERS];
//		setar debug para os computadores que eu testar (pelo nome do player)

//CARACTERISTICAS DO ARQUIVO DO PERFIL:
    new config_do_arquivo[256]="config_line";
    new fim_do_arquivo[256]="fim";
    new sufixo_conf_adc[256] = "_c";
	new dados_totais = 47;//ate team

new PlayerMecanicoMagico[MAX_PLAYERS];
//new InfoPlayer[MAX_PLAYERS][3];
new vehicleid_anterior[MAX_PLAYERS][5];//VID COR1 COR2 PAINTJ
//fazer apagar somente os veiculos que nao tiverem sido usados
// 	apagar quando o player criar outro sem entrar no ultimo criado

	//definidas como globais para usar no comando set:
    new mostra_xyz_cmd[MAX_PLAYERS];
    new mostra_carro_cmd[MAX_PLAYERS];
    
    //para armas
    new mostra_armas_draw[MAX_PLAYERS];
	new Float:x_size[MAX_PLAYERS];      //largura da caixa do texto (para nao quebrar)
	new Float:y_size[MAX_PLAYERS];
	new Float:x_s_l[MAX_PLAYERS];//largura
	new Float:y_s_l[MAX_PLAYERS];//altura
	new Float:pos_x_guns[MAX_PLAYERS];        //move na tela em direcao ao relogio (direita)
 	new Float:pos_y_guns[MAX_PLAYERS];         //move na tela 
	new Float: Passo_y[MAX_PLAYERS];
        
		new Text:text1[MAX_PLAYERS];
		new Text:text2[MAX_PLAYERS];
		new Text:text3[MAX_PLAYERS];
		new Text:text4[MAX_PLAYERS];
		new Text:text5[MAX_PLAYERS];
		new Text:text6[MAX_PLAYERS];
		new Text:text7[MAX_PLAYERS];
		new Text:text8[MAX_PLAYERS];
		new Text:text9[MAX_PLAYERS];
		new Text:text10[MAX_PLAYERS];
		new Text:text11[MAX_PLAYERS];
		new Text:text12[MAX_PLAYERS];
		new Text:text13[MAX_PLAYERS];
		new fontarmas[MAX_PLAYERS];
    
    //para posicao    
    new Text:text_pos[MAX_PLAYERS];
	new Float:pos_x_pos[MAX_PLAYERS];        //move na tela em direcao ao relogio (direita)
 	new Float:pos_y_pos[MAX_PLAYERS];         //move na tela 
	new fontpos[MAX_PLAYERS];
    new mostra_pos_draw[MAX_PLAYERS];
	new Float:x_size_pos[MAX_PLAYERS];      //largura da caixa do texto (para nao quebrar)
	new Float:y_size_pos[MAX_PLAYERS];
	new Float:x_s_l_pos[MAX_PLAYERS];//largura
	new Float:y_s_l_pos[MAX_PLAYERS];//altura

    //para velocidade
    new mostra_vel_draw[MAX_PLAYERS];
    new Text:text_vel[MAX_PLAYERS];
	new Float:pos_x_vel[MAX_PLAYERS];        //move na tela em direcao ao relogio (direita)
 	new Float:pos_y_vel[MAX_PLAYERS];         //move na tela 
	new fontvel[MAX_PLAYERS];
    

//------------------------------------------------------------------------------------------------------
main()
{
		print("\n----------------------------------");
		print("  Running LVDM ~MoneyGrub\n");
		print("         Coded By");
		print("            Jax");
		print("         EDITED BY CARLOS");
		print("            OI");
		print("----------------------------------\n");
}
//------------------------------------------------------------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{//ocorre somente no inicio do jogo
	printf("info: OnPlayerRequestSpawn(%d)",playerid);
	return 1;
}
//------------------------------------------------------------------------------------------------------
public OnPlayerPickUpPickup(playerid, pickupid)
{
	//new s[256];
	//format(s,256,"Picked up %d",pickupid);
	//SendClientMessage(playerid,0xFFFFFFFF,s);
}
//------------------------------------------------------------------------------------------------------
public MoneyGrubScoreUpdate()
{
	new CashScore;
	new name[MAX_PLAYER_NAME];
	//new string[256];
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof(name));
   			CashScore = GetPlayerMoney(i);
			SetPlayerScore(i, CashScore);
			if (CashScore > CashScoreOld)
			{
				CashScoreOld = CashScore;
				//format(string, sizeof(string), "$$$ %s is now in the lead $$$", name);
				//SendClientMessageToAll(COLOR_YELLOW, string);
			}
		}
	}
}
//------------------------------------------------------------------------------------------------------
/*public GrubModeReset()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			SetPlayerScore(i, PocketMoney);
			SetPlayerRandomSpawn(i, classid);
		}
	}

}*/
//------------------------------------------------------------------------------------------------------
public OnPlayerConnect(playerid){
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Las Venturas ~g~MoneyGrub",5000,5);
	MOSTRA_TEXTO1(playerid, "BEM VINDO A Las Venturas PEGA DINHEIRO DOS OUTROS MATANDO, digite /ajuda.", 0);
	gActivePlayers[playerid]++;
	gLastGaveCash[playerid] = GetTickCount();

	return 1;
}
//------------------------------------------------------------------------------------------------------
public OnPlayerDisconnect(playerid){
	player_saved[playerid] = 0;	
	gActivePlayers[playerid]--;
}
//------------------------------------------------------------------------------------------------------
help_cmd_set(item_ajuda){
    //item_ajuda; = 0 todos >0 mostrar o/os indicados
    new playerid = item_ajuda;
    
    //new uso_func_cmd1[150]; new uso_func_cmd2[150]; new uso_func_cmd3[150];
    //new uso_func_cmd4[150]; new uso_func_cmd5[150]; new uso_func_cmd6[256];
    //new uso_func_cmd7[150]; new uso_func_cmd8[150];// new uso_func_cmd9[150];
/*
    new uso_func_cmd1[150] = "USO: /set [list/tipo(d/f/s)] [var] [value])    VARIAVEIS: x ou y f(x_size/pos_x_vel/pos_x_guns/x_s_l),";
  	new uso_func_cmd2[150] = "   : 0 ou 1 d(xyz_cmd, carro_cmd, vel_draw, armas_draw)  : 0 a 10 d(fontarmas fontvel)";
   	new uso_func_cmd3[150] = "   : 0 ou 1 d(mostra_debug, mostra_debug_geral, mostra_debug_list, mostra_debug_nivel_2), ate[256] s( )";
   	new uso_func_cmd4[150] = "   : /set confd [debug] [debug_geral] [debug_list] [debug_nivel_2]";
    new uso_func_cmd5[150] = "   : /set conft [vel_draw] [armas_draw] [xyz_cmd] [carro_cmd]";
   	new uso_func_cmd6[150] = "   : [FAZER] /set confpT [x_size] [y_size] [x_s_l] [y_s_l]";
   	new uso_func_cmd7[150] = "   : [FAZER] /set confpV [pos_x_vel] [pos_y_vel]";
   	new uso_func_cmd8[150] = "   : [FAZER] /set confpA [pos_x_guns] [pos_y_guns]";
   	new uso_func_cmd9[150] = "   : /set conf1 debugs >[soh list=1] draws >[soh draw_vel e armas=1]  conf0 > tudo off";
  */   
            SHOW_HELP(playerid, "USO: /set [list/tipo(d/f/s)] [var] [value])    VARIAVEIS: x ou y f(x_size/pos_x_vel/pos_x_guns/x_s_l),");
            SHOW_HELP(playerid, "   : 0 ou 1 d(xyz_cmd, carro_cmd, vel_draw, armas_draw)  : 0 a 10 d(fontarmas fontvel)");
            SHOW_HELP(playerid, "   : 0 ou 1 d(mostra_debug, mostra_debug_geral, mostra_debug_list, mostra_debug_nivel_2), ate[256] s( )");
            SHOW_HELP(playerid, "   : /set confd [debug] [debug_geral] [debug_list] [debug_nivel_2]");
            SHOW_HELP(playerid, "   : /set conft [vel_draw] [armas_draw] [xyz_cmd] [carro_cmd]");
            SHOW_HELP(playerid, "   : [FAZER] /set confpT [x_size] [y_size] [x_s_l] [y_s_l]");
            SHOW_HELP(playerid, "   : [FAZER] /set confpV [pos_x_vel] [pos_y_vel]");
            SHOW_HELP(playerid, "   : [FAZER] /set confpA [pos_x_guns] [pos_y_guns]");
            SHOW_HELP(playerid, "   : /set conf1 debugs >[soh list=1] draws >[soh draw_vel e armas=1]  conf0 > tudo off");
        }
help_cmd_char(item_ajuda){
   
            SHOW_HELP(item_ajuda, "USO: /char ");
            SHOW_HELP(item_ajuda, "   : ");
        }
help_cmd_car(item_ajuda){
            SHOW_HELP_d(item_ajuda, "USO[%d]: /c [operacao] [distancia] [carro] ([Z_ALT] [saude] [paintj] [cor1] [cor2])", item_ajuda);
            SHOW_HELP_d(item_ajuda, "   : PARA OPERACAO > 2 : /c [operacao] [distancia] [carro] ([linha/linhas/circulo/cores] [Z_ALT] [n_linhas] [ang_rot])", item_ajuda);
            SHOW_HELP_d(item_ajuda, "   : PARA OPERACAO = 2 : bota player no veiculo, toca som teste, apaga carro anterior , show infos", item_ajuda);
        }

get_par_value(playerid, &erro, &idx2, linha_lida[256], nlinha_lida, cfg_char[20], procurado[20]){
    new tmp_getp[20];
    new tmp_get_v[256];
    
    //temp
    //, nlinha_lida, cfg_char[20], procurado[20] 
    /*
    new nlinha_lida;
    new cfg_char[25];
    new procurado[25];
    */
    if (erro == 0) {
        tmp_getp = strtok(linha_lida, idx2);
        if(!strlen(tmp_getp)) {
                format(tmp_get_v, sizeof(tmp_get_v), "linha[%d] conf[%s] falta [%d]par[%s] > [%s]", nlinha_lida, cfg_char, idx2, tmp_getp, procurado);
                MOSTRA_ERRO_sd(playerid,tmp_get_v,"",0);
                erro = 1; 
                return tmp_getp; 
                }
        else {//else do seg item nao vazio
            //ISSO EH UM DEBUG NIVEL 2
            format(tmp_get_v, sizeof(tmp_get_v), "linha[%d] conf[%s] [%d]par[%s] > [%s]", nlinha_lida, cfg_char, idx2, tmp_getp, procurado);
            DEBUG2_ds(playerid, tmp_get_v,0,"");
            return tmp_getp; 
        }//else seg item (seg linha)                                        
    }//erro nao ha erros
    else{//ha erros
        //usar um debug de nivel 2:
        DEBUG2_ds(playerid, "algum parametro faltou:[%d] :nao tentara obter outro.",idx2,"");
        return tmp_getp; 
    }//fim else ha erros
                            
    
}//fim funcao get_par_value
AddLinhaArquivo(playerid, &save_file, &numero_de_linhas, nova_linha_char[256]){
    numero_de_linhas++;
    fwrite(save_file, nova_linha_char);
    
    DEBUG_LIST2_ds(playerid, "[%d]:[%s]", numero_de_linhas, nova_linha_char);//NIVEL 2
    DEBUG_INFO_ds(playerid, "novalinhaadd[%d]:[%s]", numero_de_linhas, nova_linha_char);//DEBUG COM COR DIFERENTE DOS DEMAIS (COLOR_LIST AMARELO)            
}

//------------------------------------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerCommandText(playerid, cmdtext[]){
	new string[256];
	new playermoney;
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new cmd[256];
	new giveplayerid, moneys, idx;
	
	new nov_arma_id, nova_municao;
	new nov_carro_id, nov_carro_mod, nov_carro_idAdd;
	
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/ajuda", true) == 0) {
		MOSTRA_TEXTO1(playerid,"Las Venturas Deathmatch: Money Grub Coded By Jax and the SA-MP Team.",0);
		MOSTRA_TEXTO1(playerid,"Type: /objective : to find out what to do in this gamemode.",0);
		MOSTRA_TEXTO1(playerid,"Type: /givecash [playerid] [money-amount] to send money to other players.",0);
		MOSTRA_TEXTO1(playerid,"Type: /tips : to see some tips from the creator of the gamemode.", 0);

        SHOW_HELP(playerid, "/c /a /a0 /sound /savepos /salva /perfil /char /seat /set /carro /r /colete /status");
    return 1;
	}
	if(strcmp(cmd, "/r", true) == 0) {              //reinicia o gamemode/servidor
        new nome_do_player_do_reset[256];
        
    	GetPlayerName(playerid, nome_do_player_do_reset, sizeof(nome_do_player_do_reset));
        
        format(string, sizeof(string), "info: comando /r por usuario:id(%d): nome(%s)", playerid, nome_do_player_do_reset);
        
      	printf(string);
		MOSTRA_TEXTO1(playerid,string,0);
		MOSTRA_TEXTO1(playerid,"saindo e reiniciando o gamemode/servidor",0);
        GameModeExit();
    return 1;
	}
	if(strcmp(cmd, "/objective", true) == 0) {
		MOSTRA_TEXTO1(playerid,"This gamemode is faily open, there's no specific win / endgame conditions to meet.",0);
		MOSTRA_TEXTO1(playerid,"In LVDM:Money Grub, when you kill a player, you will receive whatever money they have.",0);
		MOSTRA_TEXTO1(playerid,"Consequently, if you have lots of money, and you die, your killer gets your cash.",0);
		MOSTRA_TEXTO1(playerid,"However, you're not forced to kill players for money, you can always gamble in the", 0);
		MOSTRA_TEXTO1(playerid,"Casino's.", 0);
    return 1;
	}
	if(strcmp(cmd, "/tips", true) == 0) {
		MOSTRA_TEXTO1(playerid,"Spawning with just a desert eagle might sound lame, however the idea of this",0);
		MOSTRA_TEXTO1(playerid,"gamemode is to get some cash, get better guns, then go after whoever has the",0);
		MOSTRA_TEXTO1(playerid,"most cash. Once you've got the most cash, the idea is to stay alive(with the",0);
		MOSTRA_TEXTO1(playerid,"cash intact)until the game ends, simple right?", 0);
    return 1;
	}
	
 	if(strcmp(cmd, "/givecash", true) == 0) {
	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, "USAGE: /givecash [playerid] [amount]");
			return 1;
		}
		giveplayerid = strval(tmp);
		
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, "USAGE: /givecash [playerid] [amount]");
			return 1;
		}
 		moneys = strval(tmp);
		
		//printf("givecash_command: %d %d",giveplayerid,moneys);

		
		if (IsPlayerConnected(giveplayerid)) {
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			playermoney = GetPlayerMoney(playerid);
			if (moneys > 0 && playermoney >= moneys) {
				GivePlayerMoney(playerid, (0 - moneys));
				GivePlayerMoney(giveplayerid, moneys);
				format(string, sizeof(string), "You have sent %s(player: %d), $%d.", giveplayer,giveplayerid, moneys);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "You have recieved $%d from %s(player: %d).", moneys, sendername, playerid);
				SendClientMessage(giveplayerid, COLOR_YELLOW, string);
				printf("%s(playerid:%d) has transfered %d to %s(playerid:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);
			}
			else {
				SendClientMessage(playerid, COLOR_YELLOW, "Invalid transaction amount.");
			}
		}
		else {
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
		return 1;
	}
	
	// PROCESS OTHER COMMANDS
	if(strcmp(cmd, "/a0", true) == 0) {//USAR ESSA COR MESMO (amarelo)
		SendClientMessage(playerid, COLOR_LIST, " 0 punho   1 soco    2 golf    3 police   4 faca    5 baseb   6 pa      7 taco    8 katan");
		SendClientMessage(playerid, COLOR_LIST, " 9 motos  10 dildob 11 dildop 12 dildom 13 dildop2 14 flores 15 beng   16 granad 17 gas");
		SendClientMessage(playerid, COLOR_LIST, "18 molotv 19        20        21        22 pistol  23 silent 24 desert 25 escopt 26 serrda");
		SendClientMessage(playerid, COLOR_LIST, "27 12auto 28 microt 29 smg    30 ak47 31 m16 32 minismg 33 esping 34 sniper 35 rpg 36 missil");
		SendClientMessage(playerid, COLOR_LIST, "37 flamet 38 minig  39 bomba 40 button 41 spray 42 estintor 43 foto 44 bin_verde 45 bin_verm 46 paraq");
		SendClientMessage(playerid, COLOR_LIST, "");

			//ADICIONA ARMA:
    //0
    //1 soco ingles
    //2 golf
    //3 Police bat
    //4 FACA
    //5
    return 1;
	}
	
 	if(strcmp(cmd, "/a", true) == 0) {
 	    new uso_func_cmd[256];
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO: /a [arma] [municao]", playerid);
	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;
		}
		nov_arma_id = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;
		}
 		nova_municao = strval(tmp);

		GivePlayerWeapon(playerid,nov_arma_id,nova_municao);
		SetPlayerArmedWeapon(playerid, nov_arma_id);

		mostra_armas(playerid);

		MOSTRA_TEXTO1(playerid,"nova arma:",0);
		format(string, sizeof(string), "ID[%d] MUNIC[%d]", nov_arma_id, nova_municao);
		SendClientMessage(playerid, COLOR_INFO, string);

    return 1;
	}

 	if(strcmp(cmd, "/colete", true) == 0) {
 	    new uso_func_cmd[256];
        new Float:colete, Float:health;
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO: /colete ([nivel=100])", playerid);
        
	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) { SHOW_HELP(playerid, uso_func_cmd); 
                            colete = 100.0;}
        else {colete = floatstr(tmp);}

		SetPlayerArmour(playerid, colete);

		format(string, sizeof(string), "colete em:[%f]", colete);
		MOSTRA_TEXTO1(playerid,string,0);
    return 1;
    
	}
 	if(strcmp(cmd, "/status", true) == 0) {
 	    new uso_func_cmd[256];
        new Float:colete=100.0, Float:saude_player=100.0;
        new player_status=playerid;
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO: /status [player] [saude=100] ([colete=100] FAZER[dinheiro])", playerid);

	    new tmp[256];
        
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {  SHOW_HELP(playerid, uso_func_cmd); }
        else {
            player_status = strval(tmp);
            if (IsPlayerConnected(player_status)){
                tmp = strtok(cmdtext, idx);
                if(!strlen(tmp)) { 
                    SHOW_HELP(playerid, uso_func_cmd); 
                    }
                else {
                    saude_player = floatstr(tmp);
                    SetPlayerHealth(player_status, saude_player);
                            format(string, sizeof(string), "STATUS: player[%d] saude em:[%f]", player_status, saude_player);
                            MOSTRA_TEXTO1(playerid,string,0);
        
                    tmp = strtok(cmdtext, idx);
                    if(!strlen(tmp)) {
                        SHOW_HELP(playerid, uso_func_cmd);
                        }
                        else{
                            colete = floatstr(tmp);
                            SetPlayerArmour(player_status, colete);                        
                            format(string, sizeof(string), "STATUS: player[%d] colete em:[%f]", player_status, colete);
                            MOSTRA_TEXTO1(playerid,string,0);
                        }
                }
            }
            else{
                MOSTRA_TEXTO1(playerid,"player nao esta conectado:[%d]",player_status);
            }
        }
    return 1;
	}
    

	//================================================================================
 	if(strcmp(cmd, "/seat", true) == 0) {
 	    new uso_func_cmd[256];
        new player_id_SEAT = playerid;
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO: /seat [player]", playerid);
		
	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SHOW_HELP(playerid, uso_func_cmd);}
        else {
            player_id_SEAT = strval(tmp);
        }

		if (IsPlayerInAnyVehicle(player_id_SEAT)){
			format(string, sizeof(string), "SEAT: player[%d] veiculoID[%d] assento[%d]", player_id_SEAT, GetPlayerVehicleID(player_id_SEAT), GetPlayerVehicleSeat(player_id_SEAT));
			MOSTRA_TEXTO1(playerid, string,0);
		}
		else{
            MOSTRA_ERRO_ds(playerid,"SEAT: nao esta em nenhum veiculo!", 0, "");
		}
    return 1;
	}
	//================================================================================
	//================================================================================
 	if(strcmp(cmd, "/set", true) == 0) {
		new variavel_tipo[256], variavel_set[256], variavel_value_s[256];
		new variavel_value_d;
		new Float: variavel_value_f;
       		
	    new tmp[256];
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {  help_cmd_set(playerid); }
		else{//este eh o prim par
			variavel_tipo = tmp;

            if (strcmp(variavel_tipo, "list", true) == 0) {
                format(string, sizeof(string), "D: mostra_xyz_cmd[%d] mostra_carro_cmd[%d] mostra_vel_draw[%d] mostra_armas_draw[%d] fontarmas[%d] fontvel[%d]",
                                                mostra_xyz_cmd[playerid], mostra_carro_cmd[playerid], mostra_vel_draw[playerid], mostra_armas_draw[playerid], fontarmas[playerid], fontvel[playerid] ); 
                MOSTRA_TEXTO1(playerid, string,0);
                
                format(string, sizeof(string), "F: x_size[%f] y_size[%f] x_s_l[%f] y_s_l[%f]",
                                                x_size[playerid], y_size[playerid], x_s_l[playerid], y_s_l[playerid]);
                MOSTRA_TEXTO1(playerid, string,0);
                format(string, sizeof(string), "F: pos_x_vel[%f] pos_x_guns[%f] pos_y_vel[%f] pos_y_guns[%f] Passo_y[%f]",
                                                pos_x_vel[playerid], pos_x_guns[playerid],pos_y_vel[playerid], pos_y_guns[playerid], Passo_y[playerid]);
                MOSTRA_TEXTO1(playerid, string,0);
                
                format(string, sizeof(string), "D: mostra_debug[%d], mostra_debug_geral[%d], mostra_debug_nivel_2[%d], mostra_debug_list[%d]",
                                                mostra_debug[playerid], mostra_debug_geral[playerid], mostra_debug_nivel_2[playerid], mostra_debug_list[playerid]);
                MOSTRA_TEXTO1(playerid, string,0);
                
                format(string, sizeof(string), "S: config_do_arquivo[%s], fim_do_arquivo[%s], D: dados_totais[%d]",
                                                config_do_arquivo, fim_do_arquivo, dados_totais);
                MOSTRA_TEXTO1(playerid, string,0);
                
            }
            else if (strcmp(variavel_tipo, "confd", true) == 0){//   /set confd 1 1 0 0  [debug] [debug_geral] [debug_list] [debug_nivel_2]
                tmp = strtok(cmdtext, idx);//[debug]
                if(!strlen(tmp)) {  help_cmd_set(playerid);}
                else{//este eh o terc par
                    mostra_debug[playerid] = strval(tmp);
                    MOSTRA_TEXTO1(playerid,"mostra_debug set [%d]",mostra_debug[playerid]);
                    
                    tmp = strtok(cmdtext, idx);//[debug_geral] 
                    if(!strlen(tmp)) {  help_cmd_set(playerid);}
                    else{//este eh o quato par
                        mostra_debug_geral[playerid] = strval(tmp);
                        MOSTRA_TEXTO1(playerid,"mostra_debug_geral set [%d]",mostra_debug_geral[playerid]);
                        
                        tmp = strtok(cmdtext, idx);// [debug_list]
                        if(!strlen(tmp)) {  help_cmd_set(playerid);}
                        else{//este eh o quinto par
                            mostra_debug_list[playerid] = strval(tmp);
                            MOSTRA_TEXTO1(playerid,"mostra_debug_list set [%d]",mostra_debug_list[playerid]);
                            
                            tmp = strtok(cmdtext, idx);// [debug_nivel_2]
                            if(!strlen(tmp)) {  help_cmd_set(playerid);}
                            else{//este eh o sext par
                                mostra_debug_nivel_2[playerid] = strval(tmp);
                                MOSTRA_TEXTO1(playerid,"mostra_debug_nivel_2 set [%d]",mostra_debug_nivel_2[playerid]);
                            }//fim sexto confd
                        }//fim quinto confd
                    }//fim quarto confd
                }//fim terc confd
            }//fim set confd
            
            else if (strcmp(variavel_tipo, "conft", true) == 0){//   /set conft [vel_draw] [armas_draw] [xyz_cmd] [carro_cmd]
                tmp = strtok(cmdtext, idx);//[vel_draw]
                if(!strlen(tmp)) {  help_cmd_set(playerid);}
                else{//este eh o terc par
                    mostra_vel_draw[playerid] = strval(tmp);
                    MOSTRA_TEXTO1(playerid,"mostra_vel_draw set [%d]",mostra_vel_draw[playerid]);
                    
                    tmp = strtok(cmdtext, idx);//[armas_draw] 
                    if(!strlen(tmp)) {  help_cmd_set(playerid);}
                    else{//este eh o quato par
                        mostra_armas_draw[playerid] = strval(tmp);
                        MOSTRA_TEXTO1(playerid,"mostra_armas_draw set [%d]",mostra_armas_draw[playerid]);
                        
                        tmp = strtok(cmdtext, idx);// [xyz_cmd]
                        if(!strlen(tmp)) {  help_cmd_set(playerid);}
                        else{//este eh o quinto par
                            mostra_xyz_cmd[playerid] = strval(tmp);
                            MOSTRA_TEXTO1(playerid,"mostra_xyz_cmd set [%d]",mostra_xyz_cmd[playerid]);
                            
                            tmp = strtok(cmdtext, idx);// [carro_cmd]
                            if(!strlen(tmp)) {  help_cmd_set(playerid);}
                            else{//este eh o sext par
                                mostra_carro_cmd[playerid] = strval(tmp);
                                MOSTRA_TEXTO1(playerid,"mostra_carro_cmd set [%d]",mostra_carro_cmd[playerid]);
                            }//fim sexto confd
                        }//fim quinto confd
                    }//fim quarto confd
                }//fim terc confd
            }//fim set conft
           
            else if (strcmp(variavel_tipo, "confp", true) == 0){//   /set confp [x_size] [y_size] [pos_x_vel] [pos_y_vel] [pos_x_guns] [pos_y_guns] [x_s_l] [y_s_l]
                tmp = strtok(cmdtext, idx);//[x_size]

            }//fim set confp
            
            else if (strcmp(variavel_tipo, "conf1", true) == 0){//   mostra debug soh das listas, mostra textdraws
                mostra_vel_draw[playerid] = 1;
                mostra_armas_draw[playerid] = 1;
                mostra_xyz_cmd[playerid] = 0;
                mostra_carro_cmd[playerid] = 0;
                
                mostra_debug[playerid] = 0;
                mostra_debug_geral[playerid] = 0;
                mostra_debug_list[playerid] = 1;
                mostra_debug_nivel_2[playerid] = 0;
            }//fim set conf1
            else if (strcmp(variavel_tipo, "conf0", true) == 0){//   oculta tudo 
                mostra_vel_draw[playerid] = 0;
                mostra_armas_draw[playerid] = 0;
                mostra_xyz_cmd[playerid] = 0;
                mostra_carro_cmd[playerid] = 0;
                
                mostra_debug[playerid] = 0;
                mostra_debug_geral[playerid] = 0;
                mostra_debug_list[playerid] = 0;
                mostra_debug_nivel_2[playerid] = 0;
            }//fim set confp
  
            else{// nao e "list"

                tmp = strtok(cmdtext, idx);
                if(!strlen(tmp)) {  help_cmd_set(playerid);}
                else{//este eh o seg par
                    variavel_set = tmp;
                    
                    tmp = strtok(cmdtext, idx);
                    if(!strlen(tmp)) {help_cmd_set(playerid);}
                    else{//resumo: x ou y f(x_size/pos_x/x_s_l), d(xyz_cmd, carro_cmd, vel_draw, armas_draw)
                        
                        if (strcmp(variavel_tipo, "d", true) == 0){variavel_value_d = strval(tmp);}
                        else if (strcmp(variavel_tipo, "f", true) == 0){variavel_value_f = floatstr(tmp);}
                        else if (strcmp(variavel_tipo, "s", true) == 0){variavel_value_s = tmp;}
                        else {MOSTRA_ERRO_sd(playerid, "SET: tipo de variavel(s/f/s) nao especificado: [%s]. Use /set para ajuda.",variavel_tipo,0);}
                        
                        if (strcmp(variavel_set, "x_size", true) == 0){x_size[playerid] = variavel_value_f; MOSTRA_TEXTO1(playerid,"x_size set [%f]",variavel_value_f);}
                        if (strcmp(variavel_set, "y_size", true) == 0){y_size[playerid] = variavel_value_f; MOSTRA_TEXTO1(playerid,"y_size set [%f]",variavel_value_f);}
                        if (strcmp(variavel_set, "x_s_l", true) == 0){x_s_l[playerid] = variavel_value_f; MOSTRA_TEXTO1(playerid,"x_s_l set [%f]",variavel_value_f);}
                        if (strcmp(variavel_set, "y_s_l", true) == 0){y_s_l[playerid] = variavel_value_f; MOSTRA_TEXTO1(playerid,"y_s_l set [%f]",variavel_value_f);}
                        
                        if (strcmp(variavel_set, "pos_x_guns", true) == 0){pos_x_guns[playerid] = variavel_value_f;MOSTRA_TEXTO1(playerid,"pos_x_guns set [%f]", variavel_value_f);
                            recria_textos(playerid); //chamar novamente quando mudar as posicoes
                        }
                        if (strcmp(variavel_set, "pos_x_vel", true) == 0){pos_x_vel[playerid] = variavel_value_f;MOSTRA_TEXTO1(playerid,"pos_x_vel set [%f]", variavel_value_f);
                            recria_textos(playerid);
                        }
                        if (strcmp(variavel_set, "pos_y_guns", true) == 0){pos_y_guns[playerid] = variavel_value_f;MOSTRA_TEXTO1(playerid,"pos_y_guns set [%f]", variavel_value_f);
                            recria_textos(playerid); 
                        }
                        if (strcmp(variavel_set, "pos_y_vel", true) == 0){pos_y_vel[playerid] = variavel_value_f;MOSTRA_TEXTO1(playerid,"pos_y_vel set [%f]", variavel_value_f);
                            recria_textos(playerid);
                        }

                        
                            //ATENCAO OS COMANDO E AS VARIAVEIS SAO DIFERENTES PARA FACILITAR:
                        if (strcmp(variavel_set, "xyz_cmd", true) == 0){mostra_xyz_cmd[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_xyz_cmd set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "carro_cmd", true) == 0){mostra_carro_cmd[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_carro_cmd set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "vel_draw", true) == 0){mostra_vel_draw[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_vel_draw set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "armas_draw", true) == 0){mostra_armas_draw[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_armas_draw set [%d]",variavel_value_d);}
                            
                        if (strcmp(variavel_set, "Passo_y", true) == 0){Passo_y[playerid] = variavel_value_f; MOSTRA_TEXTO1(playerid,"Passo_y set [%f]",variavel_value_f);
                                    recria_textos(playerid); }
                                    
                        if (strcmp(variavel_set, "fontarmas", true) == 0){fontarmas[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"fontarmas set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "fontvel", true) == 0){fontvel[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"fontvel set [%d]",variavel_value_d);}

                        if (strcmp(variavel_set, "mostra_debug", true) == 0){mostra_debug[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_debug set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "mostra_debug_list", true) == 0){mostra_debug_list[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_debug_list set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "mostra_debug_geral", true) == 0){mostra_debug_geral[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_debug_geral set [%d]",variavel_value_d);}
                        if (strcmp(variavel_set, "mostra_debug_nivel_2", true) == 0){mostra_debug_nivel_2[playerid] = variavel_value_d; MOSTRA_TEXTO1(playerid,"mostra_debug_nivel_2 set [%d]",variavel_value_d);}
                        
        /*new Float:x_size = 1.0;
        new Float:y_size = 1.0;
        new Float:x_s_l = 0.5;//largura
        new Float:y_s_l = 1.0;//altura*/
            
                    }	
                }                

                
            }//FIM else do "list"
	
		}//FIM else prim par nao vazio
    return 1;
	}
	//================================================================================
	//================================================================================
 	if(strcmp(cmd, "/carro", true) == 0) {
 	    new uso_func_cmd[256];
        new tmp[256];
		new opcao_carro[256];
		new opcao_item, opcao_item2,opcao_player;
		new doorslocked, objective, vehicleid, slot_component, componentid;
		
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO: /carro [trava/item] ([1/0] [objective=0/slot=0] [player])", playerid);
													//          opcao_carro opc_item    opcao_item2    opcao_player
													// /carro     noitem   [c_id]
													// /carro    itemtype   0           [slot]
													// /carro     item      [c_id]
													// /carro    trava      [doors]     [objective]

/*CARMODTYPE_SPOILER		0
CARMODTYPE_HOOD			1
CARMODTYPE_ROOF			2
CARMODTYPE_SIDESKIRT	3
CARMODTYPE_LAMPS		4
CARMODTYPE_NITRO		5
CARMODTYPE_EXHAUST		6
CARMODTYPE_WHEELS		7
CARMODTYPE_STEREO		8
CARMODTYPE_HYDRAULICS	9
CARMODTYPE_FRONT_BUMPER	10
CARMODTYPE_REAR_BUMPER	11
CARMODTYPE_VENT_RIGHT	12
CARMODTYPE_VENT_LEFT	13 */
                                                    
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;		}
		opcao_carro = tmp;

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {opcao_item = 1;} //para travar acho que default eh 1
		else {
			opcao_item = strval(tmp);
			
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) {opcao_item2 = 0;}
			else {
				opcao_item2 = strval(tmp);				
				
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) {opcao_player = playerid;}
				else {
					opcao_player = strval(tmp);				
				}
			}
		}

		if (IsPlayerInAnyVehicle(opcao_player)){
			format(string, sizeof(string), "player[%d] veiculoID[%d] assento[%d] opcao_carro[%s]", opcao_player, GetPlayerVehicleID(opcao_player), GetPlayerVehicleSeat(opcao_player), opcao_carro);
			SendClientMessage(opcao_player, COLOR_INFO, string);
			
			vehicleid = GetPlayerVehicleID(opcao_player);
			if (strcmp(opcao_carro, "trava", true) == 0) {
				doorslocked = opcao_item;
				objective = opcao_item2;
				SetVehicleParamsForPlayer(vehicleid,opcao_player, objective, doorslocked);
				
				format(string, sizeof(string), "player[%d] veiculoID[%d] assento[%d] trava[%d]", opcao_player, GetPlayerVehicleID(opcao_player), GetPlayerVehicleSeat(opcao_player), opcao_item);
				SendClientMessage(opcao_player, COLOR_INFO, string);
				MOSTRA_TEXTO1(opcao_player,"Travamento de portas: objective=0 (testar)",0);
			}
			if (strcmp(opcao_carro, "item", true) == 0) {
				componentid = opcao_item;
				
				AddVehicleComponent(vehicleid,componentid);
				
				//GetVehicleComponentType(componentid);
				format(string, sizeof(string), "Adicionado: player[%d] veiculoID[%d] component[%d] type[%d]", opcao_player, vehicleid, componentid, GetVehicleComponentType(componentid));
				SendClientMessage(opcao_player, COLOR_INFO, string);
			}
			if (strcmp(opcao_carro, "itemtype", true) == 0) {
				//componentid = opcao_item;
				slot_component = opcao_item2;
				
				componentid = GetVehicleComponentInSlot(vehicleid,slot_component);
				//GetVehicleComponentType(componentid);
				format(string, sizeof(string), "Tipo item: player[%d] veiculoID[%d] slot[%d] component[%d] type[%d]", opcao_player, vehicleid, slot_component,componentid, GetVehicleComponentType(componentid));
				SendClientMessage(opcao_player, COLOR_INFO, string);
			}
			if (strcmp(opcao_carro, "noitem", true) == 0) {
				componentid = opcao_item;
				
				RemoveVehicleComponent(vehicleid, componentid);
				
				//GetVehicleComponentType(componentid);
				format(string, sizeof(string), "Removido: player[%d] veiculoID[%d] component[%d] type[%d]", opcao_player, vehicleid, componentid, GetVehicleComponentType(componentid));
				SendClientMessage(opcao_player, COLOR_INFO, string);
			}
		}
		else{			//nao esta em nenhum veiculo
			format(string, sizeof(string), "player[%d] nao esta em nenhum veiculo", opcao_player);
			SendClientMessage(opcao_player, COLOR_INFO, string);
		}
    return 1;
	}
	//================================================================================
	//=====================================  SOM TOCADO PERTO DO PLAYER  =============
 	if(strcmp(cmd, "/som", true) == 0) {
 	    new som_id, som_player, som_todos;
// 	    new som_distancia;

 	    new uso_func_cmd[256];
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO[%d]: /som [todos] [distancia] [playerid] [som_id]", playerid);

	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;		}
		som_todos = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;		}
 		//som_distancia = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;		}
 		som_player = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;		}
 		som_id = strval(tmp);

		//=============== comum em duas funcoes --------------------------------
		new Float:x,Float:y,Float:z, Float:ang_deg;//, Float:ang_rad;
		//PEGA POSICAO DO PLAYER:
	 	GetPlayerPos(som_player, x, y, z);
	 	GetPlayerFacingAngle(som_player, ang_deg);
		//=============== comum em duas funcoes --------------------------------

		new som_player_name[20];
		GetPlayerName(som_player,som_player_name,sizeof(som_player_name));
		format(string, sizeof(string), "soundID[%d] player[%s]", som_id, som_player_name);
		
		MOSTRA_TEXTO1(som_player,"tocando som para voce:[%d]",som_id);
		MOSTRA_TEXTO1(playerid,"tocando som para player:",0);
		
		SendClientMessage(playerid, COLOR_INFO, string);//somente para quem enviou

		PlayerPlaySound(som_player, som_id, x, y, z);
		
		if (som_todos == 1){
			PlaySoundForAll(som_id, 0.0, 0.0, 0.0);
		}

    return 1;
	}
	//================================================================================

	//================================================================================
	//=====================================  SALVAR ESTADO DO PLAYER     =============
 	if(strcmp(cmd, "/salva", true) == 0) {
 	    new numero_de_linhas = 0;
 	    new nlinha_lida = 0;
 	    //new numero_de_linhas_max = 4;
//		new linhas_gravar[4][256];

 	    new uso_func_cmd[256];
 	    new salva_player_name[256];
 	    new salva_arquivo_temp[256];
 	    new save_file, read_file, file_temp_write;
		new linha_lida[256];
	    new salva_char[256];
 	    //new salva_char_str[256];
 	    
 	    new nova_linha_char[256];

   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO[%d]: /salva [salva_char]", playerid);

	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_HELP, uso_func_cmd);
			return 1;}
		//pega nome do char
		salva_char = tmp;
        new player_class, player_carro, dinheiro, arma_atual, wanted, arma_0, arma_1, arma_2, mun_0, mun_1, mun_2, player_team, cor1, cor2, paintjob, panels, doors, lights, tires;
        new arma_3, mun_3, arma_4, mun_4, arma_5, mun_5;
        new arma_6, mun_6, arma_7, mun_7, arma_8, mun_8, arma_9, mun_9, arma_10, mun_10, arma_11, mun_11, arma_12, mun_12;
		new Float:colete, Float:health, Float:saude_carro;
		
		dinheiro = GetPlayerMoney(playerid);
		arma_atual = GetPlayerWeapon(playerid);
		colete = 0.0;
		GetPlayerArmour(playerid,colete);
		wanted = GetPlayerWantedLevel(playerid);
		health = 0.0;
		GetPlayerHealth(playerid,health);
		arma_0 = 0;
		arma_1 = 0;
		arma_2 = 23;
		mun_0 = 0;
		mun_1 = 0;
		mun_2 = 100;
		cor1 = 0;
		cor2 = 0;
		paintjob = 0;
		
		saude_carro = 1000.0;
		panels = 0;
		doors = 0;
		lights = 0;
		tires = 0;

		//dados do veiculo: -------------------------------------------------------------------------------
		
		//FAZER:
		//GetVehicleComponentInSlot(player_carro,slot_component);
		//GetVehicleComponentType(component);
        new n_carros_player = 0;
		if (n_carros_player > 0){
            //carro1_mod = lista_de_carros_player[playerid][0];
            //podia armazenar nesta variavel as cores de cada carro?
        }
        new carro_atual_id, carro_atual_mod;    
		if (IsPlayerInAnyVehicle(playerid)){
            carro_atual_id = GetPlayerVehicleID(playerid);
			//pega veiculo do char
            //substituir player_carro por carro1_mod
			player_carro = GetVehicleModel(GetPlayerVehicleID(playerid));
            carro_atual_mod = player_carro;
			if ( vehicleid_anterior[playerid][1] ==  player_carro){//para pegar a cor baseado na ultima configuracao
				//nao eh o mesmo carro que ele adicionou > as cores podem ser outras ???
					//onde vou obter isso?
					//					.> usar uma variavel global para cada carro adicionado por player
					//ChangeVehiclePaintjob(nov_carro_idAdd, paintjobid);
					//ChangeVehicleColor(nov_carro_idAdd, cor1, cor2);
				cor1 = vehicleid_anterior[playerid][2];
				cor2 = vehicleid_anterior[playerid][3];
				paintjob = vehicleid_anterior[playerid][4];
			}
			else{
				cor1 = vehicleid_anterior[playerid][2];
				cor2 = vehicleid_anterior[playerid][3];
				paintjob = vehicleid_anterior[playerid][4];
			}
			//partes destruidas:
			GetVehicleDamageStatus(player_carro, panels, doors, lights, tires);
			GetVehicleHealth(player_carro, saude_carro);
		}
		else{//usa o carro anterior
			player_carro = vehicleid_anterior[playerid][1];
			cor1 = vehicleid_anterior[playerid][2];
			cor2 = vehicleid_anterior[playerid][3];
			paintjob = vehicleid_anterior[playerid][4];
			
		}
		//dados das armas : -------------------------------------------------------------------------------
		GetPlayerWeaponData(playerid, 0, arma_0, mun_0);
		GetPlayerWeaponData(playerid, 1, arma_1, mun_1);
		GetPlayerWeaponData(playerid, 2, arma_2, mun_2);
		GetPlayerWeaponData(playerid, 3, arma_3, mun_3);
		GetPlayerWeaponData(playerid, 4, arma_4, mun_4);
		GetPlayerWeaponData(playerid, 5, arma_5, mun_5);
		GetPlayerWeaponData(playerid, 6, arma_6, mun_6);
		GetPlayerWeaponData(playerid, 7, arma_7, mun_7);
		GetPlayerWeaponData(playerid, 8, arma_8, mun_8);
		GetPlayerWeaponData(playerid, 9, arma_9, mun_9);
		GetPlayerWeaponData(playerid, 10, arma_10, mun_10);
		GetPlayerWeaponData(playerid, 11, arma_11, mun_11);
		GetPlayerWeaponData(playerid, 12, arma_12, mun_12);
		
		//dados do char   : -------------------------------------------------------------------------------
		player_team = GetPlayerTeam(playerid);
		
		//pega class do char
        player_class = GetPlayerSkin(playerid);
		//                : -------------------------------------------------------------------------------
        //pega posicao do char
		//=============== comum em duas funcoes --------------------------------
		new Float:x,Float:y,Float:z, Float:ang_deg;
	 	GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, ang_deg);
		//=============== comum em duas funcoes --------------------------------
//GetPlayerArmedWeapon()
//GetPlayerHealth(
//GetPlayerArmour(
//GetPlayerMoney(
//GetPlayerWantedLevel(
//GetPlayerFightingStyle(
//GetPlayerSpecialAction(
//IsPlayerInVehicle(IsPlayerInAnyVehicle())
//)))))
		//dados a serem adicionados:
   		format(nova_linha_char, sizeof(nova_linha_char), "%s %d %d %f %f %f %f %d %d %f %d %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
		   								salva_char, player_class, player_carro, x, y, z, ang_deg, dinheiro, arma_atual, colete, wanted, health, arma_0, arma_1, arma_2, mun_0,mun_1,mun_2, player_team, cor1, cor2, paintjob, panels, doors, lights, tires);

        new char_adc_c0[20];
        new char_adc_c1[20];
        new char_adc_c2[20];
        new char_adc_c3[20];
        new nova_linha_char_c0[256];
        new nova_linha_char_c1[256];
        new nova_linha_char_c2[256];
        new nova_linha_char_c3[256];
        
        //DADOS LINHA C0 (NOVO FORMATO)  -- STATUS DO CHAR --
        format(char_adc_c0, sizeof(char_adc_c0), "%s%s%d", salva_char, sufixo_conf_adc,0);
   		format(nova_linha_char_c0, sizeof(nova_linha_char_c0), "%s %d %d %f %f %f %f %d %d %f %f %d %d\n",
		   								char_adc_c0, player_class, player_team, x, y, z, ang_deg, carro_atual_id, carro_atual_mod , health, colete, dinheiro, wanted);
        //DADOS LINHA C1 (NOVO FORMATO)  -- ARMAS1 DO CHAR --
        format(char_adc_c1, sizeof(char_adc_c1), "%s%s%d", salva_char, sufixo_conf_adc,1);
   		format(nova_linha_char_c1, sizeof(nova_linha_char_c1), "%s %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
		   								char_adc_c1, arma_atual, arma_0, mun_0, arma_1, mun_1,arma_2,mun_2, arma_3, mun_3, arma_4, mun_4, arma_5, mun_5);
        //DADOS LINHA C2 (NOVO FORMATO)  -- ARMAS2 DO CHAR --
        format(char_adc_c2, sizeof(char_adc_c2), "%s%s%d", salva_char, sufixo_conf_adc,2);
   		format(nova_linha_char_c2, sizeof(nova_linha_char_c2), "%s %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
		   								char_adc_c2, arma_6, mun_6, arma_7, mun_7,arma_8,mun_8, arma_9, mun_9, arma_10, mun_10, arma_11, mun_11, arma_12, mun_12);
        //DADOS LINHA C3 (NOVO FORMATO)  -- CARRO1 DO CHAR --
        format(char_adc_c3, sizeof(char_adc_c3), "%s%s%d", salva_char, sufixo_conf_adc,3);
   		format(nova_linha_char_c3, sizeof(nova_linha_char_c3), "%s %d %d %d %d %d %d %d %d\n",
		   								char_adc_c3, player_carro, cor1, cor2, paintjob, panels, doors, lights, tires);

/*                            //NOVA PROPOSTA:
		   					// (salva_char_c0)  //dados status char
                            // player_class, player_team, x, y, z, ang_deg, carro_atual_id, carro_atual_mod   (8par)
                            // health, colete, dinheiro, wanted,                (4)
                            
                            // (salva_char_c1) //dados armas2 (slot 0 a 5)
                            // arma_atual, arma_0, mun_0, arma_1, mun_1,arma_2,mun_2, arma_3, mun_3, arma_4, mun_4, arma_5, mun_5, (13)
                            // (salva_char_c2) //dados armas2 (slot 6 a 12)
                            // arma_6, mun_6, arma_7, mun_7, arma_8, mun_8, arma_9, mun_9, arma_10, mun_10, arma_11, mun_11, arma_12, mun_12  (14)
                            // (salva_char_c3)  //dados carro1
                            // player_carro, cor1, cor2, paintjob, panels, doors, lights, tires, (8)
                            
                            // (salva_char_c4) //debug e textos
                            //mostra_debug, mostra_debug_geral, mostra_debug_nivel_2, mostra_debug_list, PlayerMecanicoMagico (5)
                            //mostra_xyz_cmd, mostra_carro_cmd, mostra_vel_draw, mostra_armas_draw, fontarmas, fontvel (6)
                            // (salva_char_c5) //posicoes textos
                            //x_size, y_size, x_s_l, y_s_l, pos_x_guns, pos_y_guns, Passo_y, pos_x_vel, pos_y_vel (9)
*/
                                        
        //DEFINE O NOME DO ARQUIVO PELO NOME DO PLAYER:
		GetPlayerName(playerid,salva_player_name,sizeof(salva_player_name));
		
		//GREEN eh debug
		//RED   eh info da funcao
		//YELOW eh listagem de itens/linhas arquivos
		//WHITE eh ...
		
		MOSTRA_TEXTO1(playerid,"salvando estado player.",0);
		format(string, sizeof(string), "playerID[%d] player[%s] personagem[%s]", playerid, salva_player_name, salva_char);
		SendClientMessage(playerid, COLOR_INFO, string);
		format(string, sizeof(string), "plyrID[%d] plyer[%s] char[%s] skin[%d] carro[%d] x[%f] y[%f] z[%f] a[%f]", playerid, salva_player_name, salva_char, player_class, player_carro, x, y, z, ang_deg);
		SendClientMessage(playerid, COLOR_DEBUG, string);

		PlayerPlaySound(playerid, 1057, x, y, z);

		if (fexist(salva_player_name))
		{	format(string, sizeof(string), "arquivo[%s] JA existe: abrindo para verificacao", salva_player_name);
			SendClientMessage(playerid, COLOR_DEBUG, string);

			read_file = fopen(salva_player_name, io_read);
			format(salva_arquivo_temp, sizeof(salva_arquivo_temp), "%s_temp", salva_player_name);
			file_temp_write = fopen(salva_arquivo_temp, io_write);

			//para arquivos
			new idx2;
			//new item_da_linha[256];
		    new tmp_item[20];
		    new item_do_char_salvo[256];
		    new fim_do_arquivo_chegou;
		    fim_do_arquivo_chegou = 0;

			while (fim_do_arquivo_chegou == 0)
				{
				    nlinha_lida++;
					idx2 = 0;
				    linha_lida = "";
					fread(read_file, linha_lida, sizeof(linha_lida));
					format(string, sizeof(string), "arquivo[%s] lendo linha:[%d][%s] ", salva_player_name, nlinha_lida, linha_lida);
					SendClientMessage(playerid, COLOR_LIST, string);

					if (strcmp(linha_lida, fim_do_arquivo, false) == 0){
				    	fim_do_arquivo_chegou = 1;
						format(string, sizeof(string), "arquivo[%s] leu linha fim", salva_player_name);
						SendClientMessage(playerid, COLOR_DEBUG, string);
					}
						else{//else do NAO EH LINHA FIM
							//primeiro item: [char name]
							//item_da_linha = strtok(linha_lida, idx2);
							tmp_item = strtok(linha_lida, idx2);
							if(!strlen(tmp_item)) {
								format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha[%d] falta 1par[%s]", nlinha_lida, tmp_item);
								SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
								}
							else {//else do prim item nao vazio
								format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha[%d] 1par[%s]", nlinha_lida, tmp_item);
								SendClientMessage(playerid, COLOR_DEBUG, item_do_char_salvo);

								//num_val_de_item_char = strval(tmp_item);//valor nume
								//item_char[i] = tmp_item;
					    		//verifica se ja existe caracter com mesmo nome mas diferente  skin
							 	if(strcmp(tmp_item, salva_char, false) == 0) {//JA EXISTE O CHAR ----------
								 //ENTAO MODIFICAR > esta nao sera incluida pois sera modificada //pegar novos dados
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "1[%s]: JA EXISTE O CHAR [%s] no arquivo.", tmp_item, salva_char);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha antes[%s]", linha_lida);
									SendClientMessage(playerid, COLOR_DEBUG, item_do_char_salvo);
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha nova[%s]", nova_linha_char);
									SendClientMessage(playerid, COLOR_DEBUG, item_do_char_salvo);
									//nao adicionar aqui: adicionar somente uma vez no geral(so vai mudar a posicao)
								 }                                            //JA EXISTE O CHAR ----------
                                 else if (strcmp(tmp_item, char_adc_c0, false) == 0){
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "1[%s]: JA EXISTE O CHAR [%s] no arquivo.", tmp_item, salva_char);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
//                                    MOSTRA_INFO_dss(playerid, "linha[%d]:1par[%s]: JA EXISTE O CHAR [%s] no arquivo.", nlinha_lida, tmp_item, salva_char);
                                 }
                                 else if (strcmp(tmp_item, char_adc_c1, false) == 0){
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "1[%s]: JA EXISTE O CHAR [%s] no arquivo.", tmp_item, salva_char);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
                                    //MOSTRA_INFO_dss(playerid, "linha[%d]:1par[%s]: JA EXISTE O CHAR [%s] no arquivo.", nlinha_lida, tmp_item, salva_char);
                                 }
                                 else if (strcmp(tmp_item, char_adc_c2, false) == 0){
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "1[%s]: JA EXISTE O CHAR [%s] no arquivo.", tmp_item, salva_char);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
                                    //MOSTRA_INFO_dss(playerid, "linha[%d]:1par[%s]: JA EXISTE O CHAR [%s] no arquivo.", nlinha_lida, tmp_item, salva_char);
                                 }
                                 else if (strcmp(tmp_item, char_adc_c3, false) == 0){
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "1[%s]: JA EXISTE O CHAR [%s] no arquivo.", tmp_item, salva_char);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
                                    //MOSTRA_INFO_dss(playerid, "linha[%d]:1par[%s]: JA EXISTE O CHAR [%s] no arquivo.", nlinha_lida, tmp_item, salva_char);
                                 }
								 else {

									format(string, sizeof(string), "%s", linha_lida);
									//linhas_gravar[numero_de_linhas] = string;
					               	numero_de_linhas++;
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "linhaadd[%d]:[%s]", numero_de_linhas, string);

									fwrite(file_temp_write, string);

									SendClientMessage(playerid, COLOR_LIST, item_do_char_salvo);
								 }

								//segundo item: [char name]
								tmp_item = strtok(linha_lida, idx2);
								if(!strlen(tmp_item)) {
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha[%d] falta 2par[%s] (so lera estes 2)", nlinha_lida, tmp_item);
									SendClientMessage(playerid, COLOR_INFO, item_do_char_salvo);
									}
								else {//else do seg item nao vazio
									format(item_do_char_salvo, sizeof(item_do_char_salvo), "linha[%d] 2par[%s] (so lera estes 2)", nlinha_lida, tmp_item);
									SendClientMessage(playerid, COLOR_DEBUG, item_do_char_salvo);
								}//FIM else do SEG item nao vazio

									//num_val_de_item_char = strval(tmp_item);//valor nume
									//item_char[i] = tmp_item;

							}//FIM else do prim item nao vazio
						}//FIM eh ultima linha lida (com info "fim")
					}//fim do while

			format(string, sizeof(string), "arquivo[%s] terminada verificacao e recuperado dados em [%d]linhas: fechando arquivo.", salva_player_name, numero_de_linhas);
			SendClientMessage(playerid, COLOR_DEBUG, string);

			fclose(file_temp_write);
			fclose(read_file);
		}//fim arquivo com nome do player existe
		else {
			format(string, sizeof(string), "arquivo[%s] NAO existe", salva_player_name);
			SendClientMessage(playerid, COLOR_DEBUG, string);
		}

		save_file = fopen(salva_player_name, io_write);//salva tudo do zero
		format(string, sizeof(string), "arquivo[%s] abriu io_readwrite para gravar.", salva_player_name);
		SendClientMessage(playerid, COLOR_DEBUG, string);

		if (fexist(salva_arquivo_temp)){
			file_temp_write = fopen(salva_arquivo_temp, io_read);//ler todo conteudo copiado
			format(string, sizeof(string), "arquivo[%s] abriu io_read para OBTER flength[%d] em[%d]linhas ", salva_arquivo_temp, flength(file_temp_write), numero_de_linhas);
			SendClientMessage(playerid, COLOR_DEBUG, string);
			
			for (new nlinha_gravar=0; nlinha_gravar < numero_de_linhas; nlinha_gravar++) {
					linha_lida = "";
					fread(file_temp_write, linha_lida, sizeof(linha_lida));
					fwrite(save_file, linha_lida);
					
					format(string, sizeof(string), "gravou idxlinha[%d]de[%d]  total[%d]de[%d]:", nlinha_gravar, (numero_de_linhas - 1), (nlinha_gravar + 1),numero_de_linhas);
                    DEBUG2_ds(playerid, string, 0, "");//DEBUG NIVEL 2
                    //NIVEL 1 (COM COR DE LISTA VERMELHO FRACO)
                    DEBUG_LIST_ds(playerid, "[%d]:[%s] ", nlinha_gravar+1, linha_lida);
				}
			fclose(file_temp_write);	
		}
			//--------------------------------------
//			format(salva_char_str, sizeof(salva_char_str), "%s", salva_char);
//			fwrite(save_file, salva_char_str);
//			format(string, sizeof(string), "gravou:[%s]", salva_char_str);
//			SendClientMessage(playerid, COLOR_YELLOW, string);

//			format(salva_char_str, sizeof(salva_char_str), "%s", fim_do_arquivo);
//			fwrite(save_file, salva_char_str);
//			format(string, sizeof(string), "gravou:[%s]", salva_char_str);
//			SendClientMessage(playerid, COLOR_YELLOW, string);
			//----------------------------------------

            
		//adicionando a nova linha na lista:
		//linhas_gravar[numero_de_linhas] = nova_linha_char;
        //AddLinhaArquivo(playerid,save_file,numero_de_linhas,nova_linha_char);    
        AddLinhaArquivo(playerid,save_file,numero_de_linhas,nova_linha_char_c0);    
        AddLinhaArquivo(playerid,save_file,numero_de_linhas,nova_linha_char_c1);    
        AddLinhaArquivo(playerid,save_file,numero_de_linhas,nova_linha_char_c2);    
        AddLinhaArquivo(playerid,save_file,numero_de_linhas,nova_linha_char_c3);    
        DEBUG2_ds(playerid,"linha FIM add[%d]:[%s]", numero_de_linhas+1,fim_do_arquivo);
        AddLinhaArquivo(playerid,save_file,numero_de_linhas,fim_do_arquivo);    
 
		//adicionando a linha do fim:
//		format(string, sizeof(string), "fim", numero_de_linhas, nova_linha_char);
       	//numero_de_linhas++;                     //esse numero de lin foi atualizado pela leitura que criou o arq temp
        
        // -------- ================  FIM GRAVACAO DAS LINHAS  ================ --------------------------
		format(string, sizeof(string), "arquivo[%s] fechou io_readwrite", salva_player_name);
		SendClientMessage(playerid, COLOR_DEBUG, string);
		fclose(save_file);
		
		player_saved[playerid] = 1;
		
    return 1;
	}
	//================================================================================

	//=====================================  MOSTRA PERFIL DO PLAYER     =============
 	if(strcmp(cmd, "/perfil", true) == 0) {
 	    new uso_func_cmd[256];
	    new mostra_char[256];
 	    new mostra_player_name[256];

 	    new read_file;
		new linha_lida[256];
 	    new nlinha_lida = 0;        //linhas totais
 	    new numero_de_linhas = 0;   //linhas com infos de char
        new char_existe = 0;
 	    
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO[%d]: /perfil [char] (FAZER [skin/tipo/carro/posicao])", playerid);

	    new tmp[256];
		tmp = strtok(cmdtext, idx);

		SHOW_HELP(playerid, uso_func_cmd);
		if(!strlen(tmp)) {	return 1; }
        else {mostra_char = tmp;}
		
		GetPlayerName(playerid,mostra_player_name,sizeof(mostra_player_name));
			
		MOSTRA_TEXTO1(playerid,"mostrando estado player.",0);
		//SendClientMessage(playerid, COLOR_INFO, string);
        MOSTRA_INFO_dss(playerid,"playerID[%d] player[%s] personagem[%s]",playerid,mostra_player_name,mostra_char);
		
		if (fexist(mostra_player_name))
		{	
			DEBUG_sd(playerid, "arquivo[%s] existe: abrindo para exibicao", mostra_player_name,0);

			read_file = fopen(mostra_player_name, io_read);

			new idx2;
		    new tmp_item[256];
		    //new item_do_char_salvo[256];
		    new fim_do_arquivo_chegou;
		    fim_do_arquivo_chegou = 0;

			while (fim_do_arquivo_chegou == 0)
				{
				    nlinha_lida++;
					idx2 = 0;
				    linha_lida = "";
					fread(read_file, linha_lida, sizeof(linha_lida));

					DEBUG_sds(playerid, "arquivo[%s] lendo linha:[%d][%s] ", mostra_player_name, nlinha_lida, linha_lida);
                    DEBUG_LIST_ds(playerid, "[%d]:[%s] ", nlinha_lida, linha_lida);

					if (strcmp(linha_lida, fim_do_arquivo, false) == 0){
				    	fim_do_arquivo_chegou = 1;
						DEBUG_sd(playerid, "arquivo[%s] leu linha fim", mostra_player_name,0);
					}
						else{//else do NAO EH LINHA FIM
							tmp_item = strtok(linha_lida, idx2);
							if(!strlen(tmp_item)) {
								MOSTRA_ERRO_ds(playerid,"linha[%d] falta 1par[%s]", nlinha_lida, tmp_item);
							}
							else {//else do prim item nao vazio
                                DEBUG_ds(playerid,"linha[%d] 1par[%s]", nlinha_lida, tmp_item);
                                
                                if (strcmp(linha_lida, config_do_arquivo, false) == 0){ //
                                    //eh linha de config
                                }
                                else{//SOMENTE testa se e char, lera o segundo par SE nao for linha de config
                                    
                                    
                                    if(strcmp(tmp_item, mostra_char, false) == 0) {//EXISTE O CHAR ----------
                                        numero_de_linhas++;
                                        char_existe = 1;
                                            MOSTRA_INFO_dss(playerid,"ENCONTRADO: linha[%d]: Personagem[%s](char) EXISTE no perfil[%s](arquivo)", numero_de_linhas, tmp_item, mostra_char); 
                                     }                                            //EXISTE O CHAR ----------
                                     else {
                                        format(string, sizeof(string), "%s", linha_lida);
                                        numero_de_linhas++;
                                        DEBUG_ds(playerid,"linha de outro char[%d]:[%s]", numero_de_linhas, string);
                                     }
                                    //segundo item: [char name]
                                    tmp_item = strtok(linha_lida, idx2);
                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 2par[%s] (so lera estes 2)", nlinha_lida, tmp_item); }
                                    else {//else do seg item nao vazio
                                            DEBUG_ds(playerid,"linha[%d] 2par[%s] (so lera estes 2)", nlinha_lida, tmp_item);
                                    }//FIM else do SEG item nao vazio
                                    
                                    
                                    
                                }//FIM nao eh linha de CONFIG

                                
                                
							}//FIM else do prim item nao vazio
						}//FIM nao eh ultima linha lida (com info "fim")
					}//fim do while
            if (char_existe == 1){
                //ja falou quando encontrou
            }
            else{
               MOSTRA_INFO_dss(playerid,"RESULTADO: player id[%d]: Personagem[%s] NAO existe no perfil[%s]", playerid, mostra_char, mostra_player_name); 
            }
            
            DEBUG_sd(playerid,"arquivo[%s] terminada leitura de dados em [%d]linhas: fechando arquivo.", mostra_player_name, numero_de_linhas);

			fclose(read_file);
		}//fim arquivo com nome do player existe
		else {
            MOSTRA_ERRO_sd(playerid, "arquivo[%s] NAO existe",mostra_player_name, 0);
		}
    return 1;
	}
	//================================================================================
	//================================================================================

	//=====================================  CARREGA PERFIL DO PLAYER    =============
 	if(strcmp(cmd, "/char", true) == 0) {
 	    new uso_func_cmd[256];
	    new mostra_char[256];
 	    new mostra_player_name[256];
		new opcao_carregar[256]="tudo";
        new char_adc_conf[20];

		new Float:x,Float:y,Float:z, Float:ang_deg, Float:saude_carro;
        new player_class, dinheiro, wanted, player_team;
		new Float:colete, Float:health;

        // (salva_char_c0)
        new carro_atual_id, carro_atual_mod;
        new temp_d;
        // (salva_char_c1)
        new arma_atual, arma_0, mun_0, arma_1, mun_1,arma_2,mun_2, arma_3, mun_3, arma_4, mun_4, arma_5, mun_5; //, (13)
        // (salva_char_c2)
        new arma_6, mun_6, arma_7, mun_7, arma_8, mun_8, arma_9, mun_9, arma_10, mun_10, arma_11, mun_11, arma_12, mun_12; //  (14)
        new player_carro, cor1, cor2, paintjob, panels, doors, lights, tires; //, (8)
/*
                            //NOVA PROPOSTA:
		   					// (salva_char_c0)
                            // player_class, player_team, x, y, z, ang_deg,    (6par)
                            // health, colete, dinheiro, wanted,                (4)
                            
                            // (salva_char_c3)
                            //mostra_debug, mostra_debug_geral, mostra_debug_nivel_2, mostra_debug_list, PlayerMecanicoMagico (5)
                            //mostra_xyz_cmd, mostra_carro_cmd, mostra_vel_draw, mostra_armas_draw, fontarmas, fontvel (6)
                            // (salva_char_c4)
                            //x_size, y_size, x_s_l, y_s_l, pos_x_guns, pos_y_guns, Passo_y, pos_x_vel, pos_y_vel (9)
*/
		
		//valores padrão para caso nao carregue??
		// dinheiro = 0;
		// arma_atual = 0;
		// colete = 0.0;
		// wanted = 0;
		// health = 0.0;
		// arma_0 = 0;
		// arma_1 = 0;
		// arma_2 = 23;
		// mun_0 = 0;
		// mun_1 = 0;
		// mun_2 = 100;
		// player_team = 0;
		//cor1,cor2,paintjob
		saude_carro = 1000.0;
		panels = 0;
		doors = 0;
		lights = 0;
		tires = 0;
		
 	    new read_file;
		new linha_lida[256];
 	    new nlinha_lida = 0;
 	    new numero_de_linhas = 0;
		new obteve_todos_dados_char = 0;
 	    new ndados_carregados = 0;
		
   		format(uso_func_cmd, sizeof(uso_func_cmd), "USO[%d]: /char [char] [tudo(padrao)/carro/skin]", playerid);

	    new tmp[256];
		
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) { SendClientMessage(playerid, COLOR_HELP, uso_func_cmd); return 1; }
		mostra_char = tmp;//NOME DO PERSONAGEM SALVO

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {//nenhum outro parametro:
			MOSTRA_INFO_sd(playerid,"CHAR: tentara carregar TODOS os dados para char[%s].", mostra_char,0);}
		else{opcao_carregar = tmp;
			 MOSTRA_INFO_dss(playerid, "CHAR: tentara carregar SOMENTE os dados de [%d] para[%s] referente a [%s].", playerid,mostra_char, opcao_carregar); }
                
		GetPlayerName(playerid,mostra_player_name,sizeof(mostra_player_name));
			
        MOSTRA_TEXTO_dss(playerid, "CHAR: carregando estado do player[%d]:[%s] char[%s]", playerid,  mostra_player_name, mostra_char);
		//MOSTRA_TEXTO1(playerid,"carregando estado player.",0);
		
		if (fexist(mostra_player_name)){	
            DEBUG_sd(playerid, "arquivo[%s] existe: abrindo para exibicao", mostra_player_name,0);

			read_file = fopen(mostra_player_name, io_read);

			new idx2;
		    new tmp_item[256];
		    //new item_do_char_salvo[256];
		    new fim_do_arquivo_chegou;
		    fim_do_arquivo_chegou = 0;
            //new char_existe = 0;

			obteve_todos_dados_char = 0;
            new linhas_correspondentes_char = 0;
            new dados_totais_no_arquivo = 0;
			while (fim_do_arquivo_chegou == 0){
                nlinha_lida++;
                idx2 = 0;
                linha_lida = "";
                fread(read_file, linha_lida, sizeof(linha_lida));
                
                DEBUG_LIST_ds(playerid, "[%d]: [%s]", nlinha_lida, linha_lida);
                DEBUGsdds(playerid, "arquivo[%s] linha[%d]len[%d]:[%s] ", mostra_player_name, nlinha_lida, strlen(linha_lida), linha_lida);

                if (strcmp(linha_lida, fim_do_arquivo, false) == 0){//LINHA FIM
                    fim_do_arquivo_chegou = 1;
                    DEBUG_sd(playerid, "arquivo[%s] leu linha fim", mostra_player_name,0);
                    
                }
                else{//else do NAO EH LINHA FIM
                
            
                    ndados_carregados = 0;

                    tmp_item = strtok(linha_lida, idx2);
                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 1par[%s]", nlinha_lida, tmp_item);}
                    else {//else do prim item nao vazio
                        //ISSO EH UM DEBUG NIVEL 2
                        DEBUG_ds(playerid, "linha[%d] 1par[%s]", nlinha_lida, tmp_item);
                        ndados_carregados++;
                        numero_de_linhas++; //linhas totais que nao sao (configs, fim)
                        
                            //NOVA PROPOSTA: (ORIGINAL SOMENTE EDITE AQUI)
		   					// (salva_char_c0)  //dados status char
                            // player_class, player_team, x, y, z, ang_deg, carro_atual_id, carro_atual_mod   (8par)
                            // health, colete, dinheiro, wanted,                (4)
                            
                            // (salva_char_c1) //dados armas2 (slot 0 a 5)
                            // arma_atual, arma_0, mun_0, arma_1, mun_1,arma_2,mun_2, arma_3, mun_3, arma_4, mun_4, arma_5, mun_5, (13)
                            // (salva_char_c2) //dados armas2 (slot 6 a 12)
                            // arma_6, mun_6, arma_7, mun_7, arma_8, mun_8, arma_9, mun_9, arma_10, mun_10, arma_11, mun_11, arma_12, mun_12  (14)
                            // (salva_char_c3)  //dados carro1
                            // player_carro, cor1, cor2, paintjob, panels, doors, lights, tires, (8)
                            
                            // (salva_char_c4) //debug e textos
                            //mostra_debug, mostra_debug_geral, mostra_debug_nivel_2, mostra_debug_list, PlayerMecanicoMagico (5)
                            //mostra_xyz_cmd, mostra_carro_cmd, mostra_vel_draw, mostra_armas_draw, fontarmas, fontvel (6)
                            // (salva_char_c5) //posicoes textos
                            //x_size, y_size, x_s_l, y_s_l, pos_x_guns, pos_y_guns, Passo_y, pos_x_vel, pos_y_vel (9)

                        //C0
                        format(char_adc_conf, sizeof(char_adc_conf), "%s%s%d", mostra_char, sufixo_conf_adc, 0);
                        if (strcmp(tmp_item, char_adc_conf, false) == 0){//existe char_1c (configuracoes adicionais)
                            MOSTRA_INFO_ssd(playerid, "1par[%s]: linha config adicional para[%s] linha[%d]", tmp_item, mostra_char, nlinha_lida);
                                new erro = 0;
                                
                                player_class    = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "skin"));
                                player_team     = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "team"));
                                x       = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "x"));
                                y       = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "y"));
                                z       = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "Z"));
                                ang_deg = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "ang"));
                                carro_atual_id  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "carro_atual_id"));
                                carro_atual_mod = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "carro_atual_mod"));
                                health      = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "health"));
                                colete      = floatstr(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "colete"));
                                dinheiro    = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "dinheiro"));
                                wanted      = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "wanted"));//12
                               
                                ndados_carregados = ndados_carregados + idx2;
                                dados_totais_no_arquivo = dados_totais_no_arquivo + 12;
                        }//fim existe char_0c (configuracoes adicionais)
                        //C1
                        format(char_adc_conf, sizeof(char_adc_conf), "%s%s%d", mostra_char, sufixo_conf_adc, 1);
                        if (strcmp(tmp_item, char_adc_conf, false) == 0){//existe char_1c (configuracoes adicionais)
                            MOSTRA_INFO_ssd(playerid, "1par[%s]: linha config adicional para[%s] linha[%d]", tmp_item, mostra_char, nlinha_lida);
                                new erro = 0;
                                
                                 arma_atual = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_atual"   ));
                                 arma_0 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_0"   ));
                                 mun_0  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_0"    ));
                                 arma_1 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_1"   ));
                                 mun_1  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_1"    ));
                                 arma_2 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_2"   ));
                                 mun_2  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_2"    ));
                                 arma_3 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_3"   ));
                                 mun_3  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_3"    ));
                                 arma_4 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_4"   ));
                                 mun_4  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_4"    ));
                                 arma_5 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_5"   ));
                                 mun_5  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_5"    ));//25 (13)
                                
                                ndados_carregados = ndados_carregados + idx2;
                                dados_totais_no_arquivo = dados_totais_no_arquivo + 13;
                        }//fim existe char_1c (configuracoes adicionais)
                        //C2
                        format(char_adc_conf, sizeof(char_adc_conf), "%s%s%d", mostra_char, sufixo_conf_adc, 2);
                        if (strcmp(tmp_item, char_adc_conf, false) == 0){//existe char_1c (configuracoes adicionais)
                            MOSTRA_INFO_ssd(playerid, "1par[%s]: linha config adicional para[%s] linha[%d]", tmp_item, mostra_char, nlinha_lida);
                                new erro = 0;
                                
                                 arma_6 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_6"   ));
                                 mun_6  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_6"    ));
                                 arma_7 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_7"   ));
                                 mun_7  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_7"    ));
                                 arma_8 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_8"   ));
                                 mun_8  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_8"    ));
                                 arma_9 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_9"   ));
                                 mun_9  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_9"    ));
                                 arma_10 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_10"   ));
                                 mun_10  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_10"    ));
                                 arma_11 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_11"   ));
                                 mun_11  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_11"    ));
                                 arma_12 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "arma_12"   ));
                                 mun_12  = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "mun_12"    ));//39 (14)
                                
                                ndados_carregados = ndados_carregados + idx2;
                                dados_totais_no_arquivo = dados_totais_no_arquivo + 14;
                        }//fim existe char_2c (configuracoes adicionais)39
                        //C3//dados carro1
                        format(char_adc_conf, sizeof(char_adc_conf), "%s%s%d", mostra_char, sufixo_conf_adc, 3);
                        if (strcmp(tmp_item, char_adc_conf, false) == 0){//existe char_3c (configuracoes adicionais)
                            MOSTRA_INFO_ssd(playerid, "1par[%s]: linha config adicional para[%s] linha[%d]", tmp_item, mostra_char, nlinha_lida);
                                new erro = 0;
                                
                                 player_carro = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "player_carro"   ));
                                 cor1 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "cor1"   ));
                                 cor2 = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "cor2"   ));
                                 paintjob = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "paintjob"   ));
                                 panels = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "panels"   ));
                                 doors = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "doors"   ));
                                 lights = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "lights"   ));
                                 tires = strval(get_par_value(playerid, erro, idx2, linha_lida, nlinha_lida, char_adc_conf, "tires"   ));//47 (8)
                                
                                ndados_carregados = ndados_carregados + idx2;
                                dados_totais_no_arquivo = dados_totais_no_arquivo + 8;
                                if (dados_totais_no_arquivo == dados_totais){
                                    obteve_todos_dados_char = 1;
                                    
                                }
                        }//fim existe char_3c (configuracoes adicionais)

                        
                        if(strcmp(tmp_item, mostra_char, false) == 0) {//EXISTE O CHAR ----------
                        
                            //"%s %d %d %f %f %f %f %d %d %f %d %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
		   					// salva_char, player_class, player_carro, x, y, z, ang_deg,    (7par)
                            // dinheiro, arma_atual, colete, wanted, health,                (12)
                            // arma_0, arma_1, arma_2, mun_0,mun_1,mun_2, player_team,      (19)
                            
                         //ENTAO MODIFICAR > esta nao sera incluida pois sera modificada //pegar novos dados
                            MOSTRA_INFO_ssd(playerid, "1[%s]: EXISTE O CHAR [%s] no arquivo linha[%d]", tmp_item, mostra_char, nlinha_lida);
                            
                            linhas_correspondentes_char++;
                                                                     //EXISTE O CHAR ----------
                            if (obteve_todos_dados_char > 0){
                                //ja encontrou uma linha com dados para um char
                            }
                            else{
                                //segundo item: [char skin]
                                tmp_item = strtok(linha_lida, idx2);
                                if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 2par[%s]", nlinha_lida, tmp_item);}
                                else {//else do seg item nao vazio
                                    //ISSO EH UM DEBUG NIVEL 2
                                    DEBUG2_ds(playerid, "linha[%d] 2par[%s]", nlinha_lida, tmp_item);
                                    player_class = strval(tmp_item); ndados_carregados++;

                                    //terceiro item: [char carro]
                                    tmp_item = strtok(linha_lida, idx2);
                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 3par[%s]", nlinha_lida, tmp_item);}
                                    else {
                                        DEBUG2_ds(playerid, "linha[%d] 3par[%s]", nlinha_lida, tmp_item);
                                        player_carro = strval(tmp_item); ndados_carregados++;
                                            
                                        tmp_item = strtok(linha_lida, idx2);//quarto item: [char x]
                                        if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 4par[%s]", nlinha_lida, tmp_item);}
                                        else {
                                            DEBUG2_ds(playerid, "linha[%d] 4par[%s]", nlinha_lida, tmp_item);
                                            x = floatstr(tmp_item); ndados_carregados++;
                                            
                                            tmp_item = strtok(linha_lida, idx2);//quinto item: [char y]
                                            if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 5par[%s]", nlinha_lida, tmp_item);}
                                            else {
                                                DEBUG2_ds(playerid, "linha[%d] 5par[%s] y", nlinha_lida, tmp_item);
                                                y = floatstr(tmp_item);	ndados_carregados++;
                                                
                                                tmp_item = strtok(linha_lida, idx2);//sexto item: [char z]
                                                if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 6par[%s]", nlinha_lida, tmp_item);}
                                                else {
                                                    DEBUG2_ds(playerid, "linha[%d] 6par[%s] z", nlinha_lida, tmp_item);
                                                    z = floatstr(tmp_item); ndados_carregados++;
                                                    
                                                    tmp_item = strtok(linha_lida, idx2);//setimo item: [char ang]
                                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 7par[%s]", nlinha_lida, tmp_item);}
                                                    else {
                                                        DEBUG2_ds(playerid, "linha[%d] 7par[%s] ang", nlinha_lida, tmp_item);
                                                        ang_deg = floatstr(tmp_item);	ndados_carregados++;
                                                        
                                                        tmp_item = strtok(linha_lida, idx2);//oitavo item: [char money]
                                                        if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 8par[%s]", nlinha_lida, tmp_item);}
                                                        else {
                                                            DEBUG2_ds(playerid, "linha[%d] 8par[%s] din", nlinha_lida, tmp_item);
                                                            dinheiro = strval(tmp_item); ndados_carregados++;
                                                            
                                                            tmp_item = strtok(linha_lida, idx2);//nono item: [char arma_atual]
                                                            if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 9par[%s]", nlinha_lida, tmp_item);}
                                                            else {
                                                                DEBUG2_ds(playerid, "linha[%d] 9par[%s]", nlinha_lida, tmp_item);
                                                                arma_atual = strval(tmp_item);	ndados_carregados++;
                                                                
                                                                tmp_item = strtok(linha_lida, idx2);//decimo item: [char colete]
                                                                if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 10par[%s]", nlinha_lida, tmp_item);}
                                                                else {
                                                                    DEBUG2_ds(playerid, "linha[%d] 10par[%s] col", nlinha_lida, tmp_item);
                                                                    colete = floatstr(tmp_item); ndados_carregados++;
                                                                    
                                                                    tmp_item = strtok(linha_lida, idx2);//11 item: [char wanted]
                                                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 11par[%s]", nlinha_lida, tmp_item);}
                                                                    else {
                                                                        DEBUG2_ds(playerid, "linha[%d] 11par[%s]", nlinha_lida, tmp_item);
                                                                        wanted = strval(tmp_item);		ndados_carregados++;
                                                                        
                                                                        tmp_item = strtok(linha_lida, idx2);//12 item: [char saude]
                                                                        if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 12par[%s]", nlinha_lida, tmp_item);}
                                                                        else {
                                                                            DEBUG2_ds(playerid, "linha[%d] 12par[%s]", nlinha_lida, tmp_item);
                                                                            health = floatstr(tmp_item); ndados_carregados++;
                                                                            
                                                                            tmp_item = strtok(linha_lida, idx2);//13 item: [char arma_0]
                                                                            if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 13par[%s]", nlinha_lida, tmp_item);}
                                                                            else {
                                                                                DEBUG2_ds(playerid, "linha[%d] 13par[%s]", nlinha_lida, tmp_item);
                                                                                arma_0 = strval(tmp_item); ndados_carregados++;
                                                                                
                                                                                tmp_item = strtok(linha_lida, idx2);//14 item: [char arma_1]
                                                                                if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 14par[%s]", nlinha_lida, tmp_item);}
                                                                                else {
                                                                                    DEBUG2_ds(playerid, "linha[%d] 14par[%s]", nlinha_lida, tmp_item);
                                                                                    arma_1 = strval(tmp_item); ndados_carregados++;
                                                                                    
                                                                                    tmp_item = strtok(linha_lida, idx2);//15 item: [char arma_2]
                                                                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 15par[%s]", nlinha_lida, tmp_item);}
                                                                                    else {
                                                                                        DEBUG2_ds(playerid, "linha[%d] 15par[%s]", nlinha_lida, tmp_item);
                                                                                        arma_2 = strval(tmp_item); ndados_carregados++;
                                                                                        
                                                                                        tmp_item = strtok(linha_lida, idx2);//16 item: [char mun_0]
                                                                                        if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 16par[%s]", nlinha_lida, tmp_item);}
                                                                                        else {
                                                                                            DEBUG2_ds(playerid, "linha[%d] 16par[%s]", nlinha_lida, tmp_item);
                                                                                            mun_0 = strval(tmp_item); ndados_carregados++;
                                                                                            
                                                                                            tmp_item = strtok(linha_lida, idx2);//17 item: [char mun_1]
                                                                                            if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 17par[%s]", nlinha_lida, tmp_item);}
                                                                                            else {
                                                                                                DEBUG2_ds(playerid, "linha[%d] 17par[%s]", nlinha_lida, tmp_item);
                                                                                                mun_1 = strval(tmp_item); ndados_carregados++;
                                                                                                
                                                                                                tmp_item = strtok(linha_lida, idx2);//18 item: [char mun_2]
                                                                                                if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 18par[%s]", nlinha_lida, tmp_item);}
                                                                                                else {
                                                                                                    DEBUG2_ds(playerid, "linha[%d] 18par[%s]", nlinha_lida, tmp_item);
                                                                                                    mun_2 = strval(tmp_item); ndados_carregados++;
                                                                                                    
                                                                                                    tmp_item = strtok(linha_lida, idx2);//19 item: [char mun_2]
                                                                                                    if(!strlen(tmp_item)) { MOSTRA_ERRO_ds(playerid,"linha[%d] falta 19par[%s]", nlinha_lida, tmp_item);}
                                                                                                    else {
                                                                                                        DEBUG2_ds(playerid, "linha[%d] 19par[%s]", nlinha_lida, tmp_item);
                                                                                                        player_team = strval(tmp_item); ndados_carregados++;
                                                                                                        
                                                                                                        
                                                                                                        //isso fica sempre no ultimo dado possivel de carregar	
                                                                                                        obteve_todos_dados_char = 1;
                                                                                                        //salva_char, player_class, player_carro, x, y, z, ang_deg, dinheiro, arma_atual, colete, wanted, health,
                                                                                                        //arma_0, arma_1, arma_2, mun_0,mun_1,mun_2, player_team
                                                                                                    

                                                                                                    }//FIM else do 19 item nao vazio
                                                                                                }//FIM else do 18 item nao vazio
                                                                                            }//FIM else do 17 item nao vazio
                                                                                        }//FIM else do 16 item nao vazio
                                                                                    }//FIM else do 15 item nao vazio
                                                                                }//FIM else do 14 item nao vazio
                                                                            }//FIM else do 13 item nao vazio
                                                                        }//FIM else do 12 item nao vazio
                                                                    }//FIM else do 11 item nao vazio
                                                                }//FIM else do DECIMO item nao vazio
                                                            }//FIM else do NONO item nao vazio
                                                        }//FIM else do OITAVO item nao vazio
                                                    }//FIM else do SETIMO item nao vazio
                                                }//FIM else do SEXTO item nao vazio
                                            }//FIM else do QUINTO item nao vazio
                                        }//FIM else do QUARTO item nao vazio
                                    }//FIM else do TERC item nao vazio
                                }//FIM else do SEG item nao vazio
                                
                            
                                
                            }// FIM DO else nao encontrou nenhum char correspondente ainda
                            //se quiser que carregue os dados do ultimo encontrado: prossiga com obtencao daqui: problemas com dados pegados antes
                            
                            
                        }// fim EXISTE O CHAR ----------
                        else{//else (nao existe char)
                            //ISSO NAO ERA PARA SER NO ELSE?
                            //format(string, sizeof(string), "%s", linha_lida);
                            DEBUG_LIST_ds(playerid, "linha de outro char[%d]:", numero_de_linhas, "");
                            DEBUG_LIST_ds(playerid, "[%d]:[%s]", numero_de_linhas, linha_lida);
                        }
                            //num_val_de_item_char = strval(tmp_item);//valor nume
                            //item_char[i] = tmp_item;

                    }//FIM else do prim item nao vazio
                
                }//FIM eh ultima linha lida (com info "fim")
			}//fim do while

			DEBUG_sd(playerid, "arquivo[%s] terminada leitura de dados em [%d]linhas: fechando arquivo.", mostra_player_name, numero_de_linhas);
			fclose(read_file);
			if (obteve_todos_dados_char == 0) {//comparar tambem (ndados_carregados e dados_totais)
				MOSTRA_ERRO_sdd(playerid, "arquivo[%s] NAO foi possivel carregar todos os dados. [%d]de[%d]", mostra_player_name, ndados_carregados, dados_totais);
			}
            if (linhas_correspondentes_char > 1){
                MOSTRA_TEXTO_ssd(playerid,"CHAR: existe mais de um registro para [%s] no arquivo[%s]: ha [%d]linhas: usara o primeiro.",mostra_char,mostra_player_name,linhas_correspondentes_char);
            }
			if (obteve_todos_dados_char == 1){
                player_saved[playerid] = 1;//atualiza global pro sistema
                
				MOSTRA_INFO_sdd(playerid, "arquivo[%s] carregado todos os dados disponiveis. [%d]de[%d]", mostra_player_name, ndados_carregados, dados_totais);
				format(string, sizeof(string), "dados[%s %d %d %f %f %f %f %d %d %f %d %f %d %d %d %d %d %d %d %d %d %d]",
		   								mostra_char, player_class, player_carro, x, y, z, ang_deg, dinheiro, arma_atual, colete, wanted, health, arma_0, arma_1, arma_2, mun_0,mun_1,mun_2, player_team, cor1,cor2,paintjob);
				MOSTRA_TEXTO1(playerid, string, 0);

				if ((strcmp(opcao_carregar, "carro", true) == 0)){//carrega somente o carro (FAZER OU opcao_carregar=="tudo")
				//CARREGANDO CRRO:
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang_deg);
					MOSTRA_TEXTO1(playerid,"novo carro carregado",0);
					nov_carro_idAdd = AddStaticVehicle(player_carro,x+2.0,y+2.0,z+2.0,ang_deg,cor1,cor2);
					PutPlayerInVehicle(playerid,nov_carro_idAdd, 0);//seatid 0 motorista, 1 passageiro frente, 
				}
				if ((strcmp(opcao_carregar, "skin", true) == 0)){//carrega somente o skin (FAZER OU opcao_carregar=="tudo")
				//CARREGANDO skin:
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang_deg);
					MOSTRA_TEXTO1(playerid,"novo SKIN carregado(atencao x,y,z )",0);

					GetPlayerWeaponData(playerid, 0, arma_0, mun_0);
					GetPlayerWeaponData(playerid, 1, arma_1, mun_1);
					GetPlayerWeaponData(playerid, 2, arma_2, mun_2);
					
					SetSpawnInfo(playerid, GetPlayerTeam(playerid), player_class,x,y,z,ang_deg,arma_0,mun_0,arma_1,mun_1,arma_2,mun_2);
					SpawnPlayer(playerid);
				}
				if ((strcmp(opcao_carregar, "tudo", true) == 0)){//carrega somente o skin (FAZER OU opcao_carregar=="tudo")
				//CARREGANDO TUDO:
                    //ACOES ANTES DE CARREGAR:
                    temp_d = GetPlayerVehicleID(playerid);
                    RemovePlayerFromVehicle(playerid);
                    DestroyVehicle(temp_d);
                    /*
                    if (veiculo_pertence_ao_player){
                        //GetPlayerVehicleID(playerid);
                        
                    }
                    else{
                        DestroyVehicle(GetPlayerVehicleID(playerid));

                    }
                    */
            
					MOSTRA_TEXTO1(playerid,"carregando TUDO (FAZER)...",0);
					
					format(string, sizeof(string), "spawn: plyr[%d] team[%d] skin[%d] x[%f] y[%f] z[%f] r[%f] wp1[%d] wp1a[%d] wp2[%d] wp2a[%d] wp3[%d] wp3a[%d]",
														playerid,player_team, player_class,x,y,z,ang_deg,arma_0, mun_0, arma_1, mun_1, arma_2, mun_2);
                    DEBUG_sd(playerid, string,"",0);
					SetSpawnInfo(playerid, player_team, player_class,x,y,z,ang_deg,arma_0, mun_0, arma_1, mun_1, arma_2, mun_2);
					SpawnPlayer(playerid);
					SetPlayerPos(playerid,x,y,z);
					
                    new Float:Dist_carro = 5.0;
					nov_carro_idAdd = AddStaticVehicle(player_carro,x+Dist_carro,y+Dist_carro,z,ang_deg,cor1,cor2);
					configura_carro(nov_carro_idAdd, cor1, cor2, paintjob, saude_carro, panels, doors, lights, tires);
					
					if (player_carro == 0){ //se nao existe esse carro ???
						}
					else{
						//bota o cara no carro
						//espera ele estar no carro
						
//						while (!IsPlayerInAnyVehicle(playerid)){
//						}
						
					}
                    //ISSO EH UM DEBUG NIVEL 1
					format(string, sizeof(string), "carro: cid[%d] mod[%d] x[%f] y[%f] z[%f] a[%f] cor1[%d] cor2[%d]",
														nov_carro_idAdd, player_carro,x+Dist_carro,y+Dist_carro,z+Dist_carro,ang_deg,cor1,cor2 );
                    DEBUG_sd(playerid, string,"",0);

					format(string, sizeof(string), "status: dinheiro[%d] arma[%d] procurado[%d] colete[%f] saude[%f]",
														dinheiro, arma_atual, wanted, colete, health );
                    DEBUG_sd(playerid, string,"",0);

					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid, dinheiro);
					
                    GivePlayerWeapon(playerid,arma_0,mun_0);
                    GivePlayerWeapon(playerid,arma_1,mun_1);
                    GivePlayerWeapon(playerid,arma_2,mun_2);
                    GivePlayerWeapon(playerid,arma_3,mun_3);
                    GivePlayerWeapon(playerid,arma_4,mun_4);
                    GivePlayerWeapon(playerid,arma_5,mun_5);
                    GivePlayerWeapon(playerid,arma_6,mun_6);
                    GivePlayerWeapon(playerid,arma_7,mun_7);
                    GivePlayerWeapon(playerid,arma_8,mun_8);
                    GivePlayerWeapon(playerid,arma_9,mun_9);
                    GivePlayerWeapon(playerid,arma_10,mun_10);
                    GivePlayerWeapon(playerid,arma_11,mun_11);
                    GivePlayerWeapon(playerid,arma_12,mun_12);
                    
					SetPlayerArmedWeapon(playerid,arma_atual);
					
					SetPlayerArmour(playerid,colete);
					SetPlayerWantedLevel(playerid, wanted);
					SetPlayerHealth(playerid,health);
                    
					PutPlayerInVehicle(playerid,nov_carro_idAdd, 0);
					
					MOSTRA_INFO_sdd(playerid,"Carregado TUDO perfil[%s] player[%d] skin[%d].",mostra_player_name, playerid,player_class);
				}
				
			//player_class, player_carro, dinheiro, arma_atual, colete, wanted, health, arma_0, arma_1, arma_2, mun_0,mun_1,mun_2, player_team;
				
				
			}
		}//fim arquivo com nome do player existe
		else {
			MOSTRA_ERRO_sd(playerid,"arquivo[%s] perfil NAO existe: use /salva [nome] para criar.", mostra_player_name,0);
		}
    return 1;
	}//fim comando /char
	//================================================================================
	
 	if(strcmp(cmd, "/c", true) == 0) {
		new tipo_disposicao[256] = "linha";
		
		new n_linhas_laterais;
		
		new Float:x,Float:y,Float:z, Float:ang_deg, Float:ang_rad, Float:rot_ang;
 	    //new Fx, Fy, Fz, Fang;
 	    new Float:nFx, Float:nFy, Float:nFang_deg;
        new Float:nFz;
 	    new Float:altura_dif = 0.5;
 	    new Float:nov_carro_dist = 4.0;
        rot_ang = 90.0;

		//padrao para opcionais:
		new Float:saude_carro;
		new paintjobid, cor1, cor2;
		saude_carro = 1000.0;
		paintjobid = 1;
		cor1 = 1;
		cor2 = 20;
		new panels = 0;
		new doors = 0;
		new lights = 0;
		new tires = 0;

	    new tmp[256];
	    
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
            help_cmd_car(playerid);
          
			return 1;}
		nov_carro_id = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
            help_cmd_car(playerid);
			return 1;}
 		nov_carro_dist = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
            help_cmd_car(playerid);
			return 1;}
 		nov_carro_mod = strval(tmp);

        if (nov_carro_id > 2){  //parametros para se id > 2
            //PREPARANDO PARA EXIBICAO RECURSIVA:
            // mostar no angulo desejado
            // setar altura para 0 ou especificar
            // numero de linhas laterais
            // fazer um CIRCULO
            
            tmp = strtok(cmdtext, idx);//quarto parametro
            if (!strlen(tmp)) {	}
            else{tipo_disposicao = tmp; //			linha, linhas, circulo
                tmp = strtok(cmdtext, idx);
                if (!strlen(tmp)) { }
                else { altura_dif= floatstr(tmp);//	ALTURA DO chao
                    tmp = strtok(cmdtext, idx);
                    if (!strlen(tmp)) {}
                    else{n_linhas_laterais = strval(tmp);// n de linhas laterais
                        tmp = strtok(cmdtext, idx);
                        if (!strlen(tmp)) {}
                        else{rot_ang = strval(tmp);//rot ang_ deslocamento 
                            tmp = strtok(cmdtext, idx);
                            if (!strlen(tmp)) {}//fim panels
                            else{panels = strval(tmp);            		// outra 8o par
                                tmp = strtok(cmdtext, idx);
                                if (!strlen(tmp)) {}//fim doors
                                else {doors = strval(tmp);				// outra 9o par
                                    tmp = strtok(cmdtext, idx);
                                    if (!strlen(tmp)) {}//fim ligths
                                    else{lights = strval(tmp);         	// outra 10o par
                                        tmp = strtok(cmdtext, idx);
                                        if (!strlen(tmp)) {}//fim tires
                                        else{tires = strval(tmp);}
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        else
        {
        
            //parametros opcionais:
            tmp = strtok(cmdtext, idx);
            if (!strlen(tmp)) {	}						//  Z_ALT
            else{ altura_dif = floatstr(tmp);

        
				tmp = strtok(cmdtext, idx);
				if (!strlen(tmp)) {	}					//fim saude
				else{saude_carro = floatstr(tmp);
					tmp = strtok(cmdtext, idx);
					if (!strlen(tmp)) { }				//fim paintjob
					else {paintjobid = strval(tmp);
						tmp = strtok(cmdtext, idx);
						if (!strlen(tmp)) {}			//fim cor1
						else{cor1 = strval(tmp);
							tmp = strtok(cmdtext, idx);
							if (!strlen(tmp)) {}		//fim cor1
							else{cor2 = strval(tmp);
								tmp = strtok(cmdtext, idx);
								if (!strlen(tmp)) {}	//fim panels
								else{panels = strval(tmp);
									tmp = strtok(cmdtext, idx);
									if (!strlen(tmp)) {}//fim doors
									else {doors = strval(tmp);
										tmp = strtok(cmdtext, idx);
										if (!strlen(tmp)) {}//fim ligths
										else{lights = strval(tmp);
											tmp = strtok(cmdtext, idx);
											if (!strlen(tmp)) {}//fim tires
											else{tires = strval(tmp);}
										}
									}
								}
							}
						}
					}
				}
			}
        }//fim else > 2
        
		//PEGA POSICAO DO PLAYER:
	 	GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, ang_deg);

	 	//GetPlayerPos(playerid, Fx, Fy, Fz);
	 	//GetPlayerFacingAngle(playerid, Fang);

        nFx = x;
        nFy = y;
        nFz = z+altura_dif;
        nFang_deg = ang_deg;
        
        nova_posicao(nFang_deg, nFx, nFy, nFz, nov_carro_dist, rot_ang);
        
			//SOMENTE SOME COM O VEICULO:
		if (nov_carro_id == 2) {
//		    if (vehicleid_anterior ) {}
				DestroyVehicle(vehicleid_anterior[playerid][1]);
		}
		
		MOSTRA_TEXTO1(playerid,"novo carro",0);
		
		//(POSTO X 2637.2712,1129.2743,11.1797
		//nov_carro_idAdd = AddStaticVehicle(nov_carro_mod,2639.2712,1123.2743,11.1797,359.6861,13,13);   //+2M FRENTE , -6 DIR,
		
		nov_carro_idAdd = AddStaticVehicle(nov_carro_mod,nFx,nFy,nFz,nFang_deg,cor1,cor2);   //+2M FRENTE , -6 DIR,
		
        vehicleid_anterior[playerid][1] = nov_carro_idAdd;
        vehicleid_anterior[playerid][2] = cor1;
        vehicleid_anterior[playerid][3] = cor2;
        vehicleid_anterior[playerid][4] = paintjobid;
		
		//SetPlayerArmedWeapon(playerid, nov_arma_id);
		format(string, sizeof(string), "OPCAO_ID[%d] vid[%d] CARRO[%d] saude[%f] paintj[%d] cor1[%d] cor2[%d] danos:p[%d]d[%d]l[%d]t[%d]", nov_carro_id, nov_carro_idAdd, nov_carro_mod, saude_carro, paintjobid, cor1, cor2, panels, doors, lights, tires);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		   
		configura_carro(nov_carro_idAdd, cor1, cor2, paintjobid, saude_carro, panels, doors, lights, tires);
        
		format(string, sizeof(string), "DADOS DO MODELO: nome[%s] 2[%s] 3[%s] 4[%s] 5[%s]", CarrosNomes[(nov_carro_mod - 400 )][1], CarrosNomes[(nov_carro_mod - 400 )][2], CarrosNomes[(nov_carro_mod - 400 )][3], CarrosNomes[(nov_carro_mod - 400 )][4], CarrosNomes[(nov_carro_mod - 400 )][5]);
		MOSTRA_TEXTO1(playerid, string,0);
	
		//format(string, sizeof(string), "v_status:vx[%f]vy[%f]vz[%f]za[%f]rw[%f]rx[%f]ry[%f]rz[%f]p[%d]d[%d]l[%d]t[%d]", vx, vy, vz, zang, Rw, Rx, Ry, Rz, panels, doors, lights, tires);

		//PARA INFORMACOES E TESTES:
		if (nov_carro_id == 2) {
		    //nov_carro_idAdd;
			format(string, sizeof(string), "ID[%d] CARRO[%d] ANGULO[%f]", nov_carro_idAdd, GetVehicleModel(nov_carro_idAdd), nFang_deg);
			SendClientMessage(playerid, COLOR_GREEN, string);
//			format(string, sizeof(string), "Fang : aSIN[%f] aCOS[%f]", asin(Fang),acos(Fang));
//			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "ang : fSIN[%f] fCOS[%f]", floatsin(ang_rad),floatcos(ang_rad));
			SendClientMessage(playerid, COLOR_GREEN, string);
//			format(string, sizeof(string), "Fx[%f] Fy[%f] Fz[%f] Fa[%f]", Fx, Fy, Fz, Fang);
//			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "x[%f] y[%f] z[%f] a[%f]", x, y, z, ang_deg);
			SendClientMessage(playerid, COLOR_GREEN, string);

			//PlayerPlaySound(playerid, soundid, Fx, Fy, Fz);

			PlaySoundForAll(1095, 0.0, 0.0, 0.0);
			//soundid:
			//  1185 : musica boa mas muito comprida
			
		    //return 1;
			PutPlayerInVehicle(playerid,nov_carro_idAdd, 0);//seatid 0 motorista, 1 passageiro frente, 	
		}
        
        
        if (nov_carro_id > 2){ ///faz uma fila de carros na direcao que o jogador esta olhando
            if (strcmp(tipo_disposicao, "circulo", true) == 0){//faz circulo
                
                
            }
            if (strcmp(tipo_disposicao, "cores", true) == 0){//faz circulo
                //fazer
                
            }
            if (strcmp(tipo_disposicao, "linha", true) == 0){//faz 1 linha (padrao default)
                for (new carro_n=1; carro_n < nov_carro_id; carro_n++)
                    {
                        cor1 = random(nov_carro_id);
                        cor2 = random(nov_carro_id);
                        paintjobid =  random(nov_carro_id);
                      
                        nFang_deg = ang_deg + (rot_ang - 90);
            
            
                        nova_posicao(nFang_deg, nFx, nFy, nFz, nov_carro_dist, rot_ang);
                                            
                        nov_carro_idAdd = AddStaticVehicle( ( nov_carro_mod+carro_n), nFx,nFy,nFz,nFang_deg,cor1,cor2);
                        configura_carro(nov_carro_idAdd, cor1, cor2, paintjobid, saude_carro, panels, doors, lights, tires);
                        
                        format(string, sizeof(string), "OPCAO_ID[%d] vid[%d] CARRO[%d] saude[%f] paintj[%d] cor1[%d] cor2[%d] danos:p[%d]d[%d]l[%d]t[%d]",
                                                nov_carro_id, nov_carro_idAdd, ( nov_carro_mod+carro_n), saude_carro, paintjobid, cor1, cor2, panels, doors, lights, tires);
                        SendClientMessage(playerid, COLOR_LIST, string);
                    }                
            }
            if (strcmp(tipo_disposicao, "linhas", true) == 0){//faz linhas
				
                new n_carros_por_linha = floatdiv( (nov_carro_id ), n_linhas_laterais);
                for (new n_linhas=1; n_linhas < n_linhas_laterais;n_linhas++){
                    nFx = x;
                    nFy = y;
                    nFz = z+altura_dif;
                    nFang_deg = ang_deg + 90.0;
                    //para posicoes relativas as linhas paralelas usar angulo com +90
					
                    nova_posicao(nFang_deg, nFx, nFy, nFz, nov_carro_dist, rot_ang);
                    
                    for (new carro_n=0; carro_n < n_carros_por_linha; carro_n++)
                        {
                            cor1 = random(nov_carro_id);
                            cor2 = random(nov_carro_id);
                            paintjobid =  random(nov_carro_id);
                          
                            nFang_deg = ang_deg;
                
                
                            nova_posicao(nFang_deg, nFx, nFy, nFz, nov_carro_dist, rot_ang);
                                                
                            nov_carro_idAdd = AddStaticVehicle( ( nov_carro_mod+carro_n), nFx,nFy,nFz,nFang_deg,cor1,cor2);
                            configura_carro(nov_carro_idAdd, cor1, cor2, paintjobid, saude_carro, panels, doors, lights, tires);
                            
                            format(string, sizeof(string), "OPCAO_ID[%d] vid[%d] CARRO[%d] saude[%f] paintj[%d] cor1[%d] cor2[%d] danos:p[%d]d[%d]l[%d]t[%d]",
                                                    nov_carro_id, nov_carro_idAdd, nov_carro_mod, saude_carro, paintjobid, cor1, cor2, panels, doors, lights, tires);
                            SendClientMessage(playerid, COLOR_YELLOW, string);
                        }                
                }
            }
        }
        return 1;
    }
	return 0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//posicao de ponto a distancia d em angulo angulo_deg
nova_posicao(&Float:angulo_deg, &Float:x, &Float:y, &Float:z, Float:dist_esp, Float:rot_ang) {
            new Float:ang_rad = (angulo_deg * 2 * 3.14) / 360;
            angulo_deg = angulo_deg + rot_ang;                 //PARA FICAR PERPENDICULAR + 180
            if (angulo_deg > 359) {
                angulo_deg = angulo_deg - 359;            //para não passar de 360
            }
            //degrees to rads
            //	  radian,
            //    grades
            x = ( x - (dist_esp * floatsin(ang_rad) ));
            y = ( y + (dist_esp * floatcos(ang_rad) ));
            z = ( z + 0.0);//+altura_dif
            return 1;
        }
//------------------------------------------------------------------------------------------------------
public OnPlayerSpawn(playerid) {
    new mostra_player_name[256];

    GetPlayerName(playerid,mostra_player_name,sizeof(mostra_player_name));
            
	SetPlayerInterior(playerid,0);
	
	if (player_saved[playerid] == 0){
		GivePlayerMoney(playerid, PocketMoney);
		SetPlayerRandomSpawn(playerid);
        TogglePlayerClock(playerid,1);
        
    //oi  configura texts ------------------------------------------------------------------------------
        //por estes valores no arquivo do player tambem pois vai resetar a cada respawn
    	//definidas como globais para usar no comando set:
        mostra_xyz_cmd[playerid] = 0;
        mostra_carro_cmd[playerid] = 0;
        
        // TEXT ARMAS
        mostra_armas_draw[playerid] = 1;
        
        x_size[playerid] = 560.0;      //largura da caixa do texto (para nao quebrar)
        y_size[playerid] = 1.0;
        x_s_l[playerid] = 0.2;//largura // 0.2 para 23pol fica otimo
        y_s_l[playerid] = 1.0;//altura
        pos_x_guns[playerid] = 480.0;        //move na tela em direcao ao relogio (direita)
        pos_y_guns[playerid] = 100.0;         //move na tela baixo+
        Passo_y[playerid] = 10.0;
		fontarmas[playerid] = 2;  //0 estilsa gta 1 fina 2 quadrada  3 gorda

        // TEXT VELOCIDADE
        mostra_vel_draw[playerid] = 1;

        pos_x_vel[playerid] = 200.0;//TELA ATE 600 DIR+
        pos_y_vel[playerid] = 420.0;//TELA ATE 400 BAIXO+
        fontvel[playerid] = 3;
        
        //TEXT POSICAO
        mostra_pos_draw[playerid] = 1;

        // text_pos x_size_pos, y_size_pos, fontpos, x_s_l_pos, y_s_l_pos, mostra_pos_draw, mostra_posicao_DRAW(), pos_x_pos, pos_y_pos        
        x_size_pos[playerid] = 600.0;      //largura(OU POSICAO???) da caixa do texto (para nao quebrar)
        y_size_pos[playerid] = 1.0;// x_size > pos_x
        x_s_l_pos[playerid] = 0.2;//largura // 0.2 para 23pol fica otimo
        y_s_l_pos[playerid] = 0.8;//altura
        pos_x_pos[playerid] = 150.0;        //move na tela em direcao ao relogio (direita)
        pos_y_pos[playerid] = 400.0;         //move na tela baixo+
		fontpos[playerid] = 1;  //0 estilsa gta 1 fina 2 quadrada  3 gorda

        mostra_debug[playerid] = 1;
        mostra_debug_geral[playerid] = 1;
        mostra_debug_nivel_2[playerid] = 1;
        mostra_debug_list[playerid] = 1;

        recria_textos(playerid); //chamar novamente quando mudar as posicoes
        
        PlayerMecanicoMagico[playerid] = 1;     //repara o carro auto ao sair
    //fim configura texts ------------------------------------------------------------------------------
        
	}// fim player nao esta salvo
    
    //executar "/perfil"
    //MOSTRA_TEXTO1(playerid,"Spawn do player[%d]", playerid);
    MOSTRA_INFO1_dsd(playerid,"Spawn do player[%d]: nome[%s] skin[%d]",playerid,mostra_player_name, GetPlayerSkin(playerid));
   

	return 1;
}
public SetPlayerRandomSpawn(playerid){
    new rand, tamanho_do_array;
    new Float:PX;
    new Float:PY;
    new Float:PZ;
    new Float:ANG;
    
	if (iSpawnSet[playerid] == 1)
	{
        tamanho_do_array = sizeof(gCopPlayerSpawns);
		rand = random(tamanho_do_array);
        PX = gCopPlayerSpawns[rand][0];
        PY = gCopPlayerSpawns[rand][1];
        PZ = gCopPlayerSpawns[rand][2];
        ANG = gCopPlayerSpawns[rand][3];
    }
    else if (iSpawnSet[playerid] == 0)
    {
        tamanho_do_array = sizeof(gRandomPlayerSpawns);
		rand = random(tamanho_do_array);
        PX = gRandomPlayerSpawns[rand][0];
        PY = gRandomPlayerSpawns[rand][1];
        PZ = gRandomPlayerSpawns[rand][2];
        ANG = gRandomPlayerSpawns[rand][3];
	}
    
		SetPlayerPos(playerid, PX, PY, PZ); // Warp the player
		SetPlayerFacingAngle(playerid, ANG);//ISSO DEVERIA ESTAR NO ARRAY POSICOES TB
        
        //INFORMACAO IRRELEVANTE (observacao): COLOR_INFO3 GREEN
        MOSTRA_INFO3_dd(playerid,"player iSpawnSet[playerid] == [%d] : gRandomPlayerSpawns: size[%d]",iSpawnSet[playerid], tamanho_do_array);
      
        SetCameraBehindPlayer(playerid);

        //SetPlayerCameraPos(playerid,PX,PY,PZ);
        //SetPlayerCameraLookAt(playerid,PX,PY+20.2,PZ);// ISSO VAI DEPENDER DO ANGULO?
        //GetPlayerCameraPOs(pid,x,y,z);
        //GetPlayerCameraFrontVector(pid,x,y,z);
    
    MOSTRA_INFO2_dd(playerid,"posicoes selecionadas randomicamente: pos_id[%d]", rand,0);
	return 1;
}
//------------------------------------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------------------
public OnPlayerDeath(playerid, killerid, reason)
{
    new playercash;
	if(killerid == INVALID_PLAYER_ID) {
        SendDeathMessage(INVALID_PLAYER_ID,playerid,reason);
        ResetPlayerMoney(playerid);
	} else {
	    	SendDeathMessage(killerid,playerid,reason);
			SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
			playercash = GetPlayerMoney(playerid);
			if (playercash > 0)  {
				GivePlayerMoney(killerid, playercash);
				ResetPlayerMoney(playerid);
			}
			else
			{
			}
     	}
 	return 1;
}
//------------------------------------------------------------------------------------------------------
/* public OnPlayerDeath(playerid, killerid, reason)
{   haxed by teh mike
	new name[MAX_PLAYER_NAME];
	new string[256];
	new deathreason[20];
	new playercash;
	GetPlayerName(playerid, name, sizeof(name));
	GetWeaponName(reason, deathreason, 20);
	if (killerid == INVALID_PLAYER_ID) {
	    switch (reason) {
			case WEAPON_DROWN:
			{
                format(string, sizeof(string), "*** %s drowned.)", name);
			}
			default:
			{
			    if (strlen(deathreason) > 0) {
					format(string, sizeof(string), "*** %s died. (%s)", name, deathreason);
				} else {
				    format(string, sizeof(string), "*** %s died.", name);
				}
			}
		}
	}
	else {
	new killer[MAX_PLAYER_NAME];
	GetPlayerName(killerid, killer, sizeof(killer));
	if (strlen(deathreason) > 0) {
		format(string, sizeof(string), "*** %s killed %s. (%s)", killer, name, deathreason);
		} else {
				format(string, sizeof(string), "*** %s killed %s.", killer, name);
			}
		}
	SendClientMessageToAll(COLOR_RED, string);
		{
		playercash = GetPlayerMoney(playerid);
		if (playercash > 0)
		{
			GivePlayerMoney(killerid, playercash);
			ResetPlayerMoney(playerid);
		}
		else
		{
		}
	}
 	return 1;
}*/
//------------------------------------------------------------------------------------------------------
public OnPlayerRequestClass(playerid, classid){
	iSpawnSet[playerid] = 0;
	SetupPlayerForClassSelection(playerid);
	return 1;
}
public SetupPlayerForClassSelection(playerid){
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}
public GameModeExitFunc(){
	GameModeExit();
}

recria_textos(playerid) {
    //oi  configura texts ------------------------------------------------------------------------------
		new stringdraw[256];
	
		format(stringdraw, sizeof(stringdraw), "%d", 1);
 
        TextDrawDestroy(text_vel[playerid]);
        TextDrawDestroy(text_pos[playerid]);
 
        TextDrawDestroy(text1[playerid]);
        TextDrawDestroy(text2[playerid]);
        TextDrawDestroy(text3[playerid]);
        TextDrawDestroy(text4[playerid]);
        TextDrawDestroy(text5[playerid]);
        TextDrawDestroy(text6[playerid]);
        TextDrawDestroy(text7[playerid]);
        TextDrawDestroy(text8[playerid]);
        TextDrawDestroy(text9[playerid]);
        TextDrawDestroy(text10[playerid]);
        TextDrawDestroy(text11[playerid]);
        TextDrawDestroy(text12[playerid]);
        TextDrawDestroy(text13[playerid]);
        
        atualiza_textos(playerid);
        
		text_vel[playerid] = TextDrawCreate(pos_x_vel[playerid],pos_y_vel[playerid], stringdraw);
		text_pos[playerid] = TextDrawCreate(pos_x_pos[playerid],pos_y_pos[playerid], stringdraw);
        
		text1[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],0.0), stringdraw);
		text2[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],1.0), stringdraw);
		text3[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],2.0), stringdraw);
		text4[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],3.0), stringdraw);
		text5[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],4.0), stringdraw);
		text6[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],5.0), stringdraw);
		text7[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],6.0), stringdraw);
		text8[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],7.0), stringdraw);
		text9[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],8.0), stringdraw);
		text10[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],9.0), stringdraw);
		text11[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],10.0), stringdraw);
		text12[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],11.0), stringdraw);
		text13[playerid] = TextDrawCreate(pos_x_guns[playerid],pos_y_guns[playerid] + floatmul(Passo_y[playerid],12.0), stringdraw);
    //fim configura texts ------------------------------------------------------------------------------
}
atualiza_textos(playerid) {
        format_text_sizes(text_vel[playerid],playerid,fontvel[playerid]);
        format_text_sizes(text_pos[playerid],playerid,fontpos[playerid]);
        
        format_text_sizes(text1[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text2[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text3[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text4[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text5[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text6[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text7[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text8[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text9[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text10[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text11[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text12[playerid],playerid,fontarmas[playerid]);
        format_text_sizes(text13[playerid],playerid,fontarmas[playerid]);
}
format_text_sizes(&Text_Draw,playerid, fonte_draw){
        //TAMANHO DA AREA DO TEXTO
        //TIPO DA FONTE
        //TAMANHO DA LETRA
		TextDrawTextSize(Text_Draw,  x_size[playerid], y_size[playerid]);//x_size = 1000 maior
		TextDrawFont(Text_Draw, fonte_draw);
		TextDrawLetterSize(Text_Draw,x_s_l[playerid], y_s_l[playerid]);
        
        TextDrawColor(Text_Draw, COLOR_BLACK2);//COLOR_BLUE2 fica bom sem caixa
        TextDrawUseBox(Text_Draw, 1);
        //TextDrawBoxColor(
        //TextDrawAlignment(
        TextDrawSetShadow(Text_Draw, 1.0);
        //TextDrawSetOutline(text, size)
        //(TextDrawBackgroundColor()))))))

 }

//------------------------------------------------------------------------------
public OnGameModeInit(){
	SetGameModeText("Ventura's DM~MG");

	ShowPlayerMarkers(1);
	ShowNameTags(1);
	EnableStuntBonusForAll(0);

	// Car Spawns
	//TESTE COM POSICOES DOS CLASS

	//1958.3783,1343.1572,15.3746,
	//1705.2347,1025.6808,10.8203

	//NA AUTO-BAHN
	//AddStaticVehicle(451,2199.6531,1393.3678,10.8203,183.2439,16,16);//infernus EM CIMA
//	AddStaticVehicle(451,2201.6531,1393.3678,10.8203,183.2439,16,16);//infernus NA FRENTE + 2m
//	AddStaticVehicle(451,2201.6531,1395.3678,10.8203,183.2439,16,16);//infernus NA ESQUERDA + 2m
	AddStaticVehicle(451,2201.6531,1387.3678,10.8203,270.2439,16,16);//infernus NA DIREITA - 6m (180 aponta par sul)(270 para leste)
//	AddStaticVehicle(451,1705.2347,1025.6808,10.8203,183.2439,16,16);

	//AddStaticVehicle(451,2040.0520,1319.2799,10.3779,183.2439,16,16); //INFERNUS                          tirei agora
	
	//OUTRO TESTE (PERTO DA PIRAMIDE ENTRE RUAS)
	AddStaticVehicle(411,2485.5977,1222.0825,10.8203,177.1306,13,13);   //PARA TESTE + 2M NA FRENTE
	
	//OUTRO TESTE (POSTO X 2637.2712,1129.2743,11.1797
	AddStaticVehicle(558,2639.2712,1123.2743,11.1797,359.6861,13,13);   //+2M FRENTE , -6 DIR,
	

	AddStaticVehicle(429,2040.5247,1359.2783,10.3516,177.1306,13,13);   //BANSHE
	AddStaticVehicle(421,2110.4102,1398.3672,10.7552,359.5964,13,13);   //4PORTAS TIPO PRESIDENT
	AddStaticVehicle(411,2074.9624,1479.2120,10.3990,359.6861,64,64);   //INFERNUS2
	AddStaticVehicle(477,2075.6038,1666.9750,10.4252,359.7507,94,94);   //SPORT ZR350
	AddStaticVehicle(541,2119.5845,1938.5969,10.2967,181.9064,22,22);   //SPORT BANSHE 2
	AddStaticVehicle(541,1843.7881,1216.0122,10.4556,270.8793,60,1);
	AddStaticVehicle(402,1944.1003,1344.7717,8.9411,0.8168,30,30);      //buffalo
	AddStaticVehicle(402,1679.2278,1316.6287,10.6520,180.4150,90,90);
	AddStaticVehicle(415,1685.4872,1751.9667,10.5990,268.1183,25,1);    //sport cheeta
	AddStaticVehicle(411,2034.5016,1912.5874,11.9048,0.2909,123,1);
	AddStaticVehicle(411,2172.1682,1988.8643,10.5474,89.9151,116,1);
	AddStaticVehicle(429,2245.5759,2042.4166,10.5000,270.7350,14,14);
	AddStaticVehicle(477,2361.1538,1993.9761,10.4260,178.3929,101,1);
	AddStaticVehicle(550,2221.9946,1998.7787,9.6815,92.6188,53,53);     //4P
	AddStaticVehicle(558,2243.3833,1952.4221,14.9761,359.4796,116,1);   //
	AddStaticVehicle(587,2276.7085,1938.7263,31.5046,359.2321,40,1);
	AddStaticVehicle(587,2602.7769,1853.0667,10.5468,91.4813,43,1);
	AddStaticVehicle(603,2610.7600,1694.2588,10.6585,89.3303,69,1);
	AddStaticVehicle(587,2635.2419,1075.7726,10.5472,89.9571,53,1);
	AddStaticVehicle(437,2577.2354,1038.8063,10.4777,181.7069,35,1);
	AddStaticVehicle(535,2039.1257,1545.0879,10.3481,359.6690,123,1);
	AddStaticVehicle(535,2009.8782,2411.7524,10.5828,178.9618,66,1);
	AddStaticVehicle(429,2010.0841,2489.5510,10.5003,268.7720,1,2);
	AddStaticVehicle(415,2076.4033,2468.7947,10.5923,359.9186,36,1);
	AddStaticVehicle(487,2093.2754,2414.9421,74.7556,89.0247,26,57);
	AddStaticVehicle(506,2352.9026,2577.9768,10.5201,0.4091,7,7);
	AddStaticVehicle(506,2166.6963,2741.0413,10.5245,89.7816,52,52);
	AddStaticVehicle(411,1960.9989,2754.9072,10.5473,200.4316,112,1);
	AddStaticVehicle(429,1919.5863,2760.7595,10.5079,100.0753,2,1);
	AddStaticVehicle(415,1673.8038,2693.8044,10.5912,359.7903,40,1);
	AddStaticVehicle(402,1591.0482,2746.3982,10.6519,172.5125,30,30);
	AddStaticVehicle(603,1580.4537,2838.2886,10.6614,181.4573,75,77);
	AddStaticVehicle(550,1555.2734,2750.5261,10.6388,91.7773,62,62);
	AddStaticVehicle(535,1455.9305,2878.5288,10.5837,181.0987,118,1);
	AddStaticVehicle(477,1537.8425,2578.0525,10.5662,0.0650,121,1);
	AddStaticVehicle(451,1433.1594,2607.3762,10.3781,88.0013,16,16);
	AddStaticVehicle(603,2223.5898,1288.1464,10.5104,182.0297,18,1);
	AddStaticVehicle(558,2451.6707,1207.1179,10.4510,179.8960,24,1);
	AddStaticVehicle(550,2461.7253,1357.9705,10.6389,180.2927,62,62);
	AddStaticVehicle(558,2461.8162,1629.2268,10.4496,181.4625,117,1);
	AddStaticVehicle(477,2395.7554,1658.9591,10.5740,359.7374,0,1);
	AddStaticVehicle(404,1553.3696,1020.2884,10.5532,270.6825,119,50);
	AddStaticVehicle(400,1380.8304,1159.1782,10.9128,355.7117,123,1);
	AddStaticVehicle(418,1383.4630,1035.0420,10.9131,91.2515,117,227);
	AddStaticVehicle(404,1445.4526,974.2831,10.5534,1.6213,109,100);
	AddStaticVehicle(400,1704.2365,940.1490,10.9127,91.9048,113,1);
	AddStaticVehicle(404,1658.5463,1028.5432,10.5533,359.8419,101,101);
	AddStaticVehicle(581,1677.6628,1040.1930,10.4136,178.7038,58,1);
	AddStaticVehicle(581,1383.6959,1042.2114,10.4121,85.7269,66,1);
	AddStaticVehicle(581,1064.2332,1215.4158,10.4157,177.2942,72,1);
	AddStaticVehicle(581,1111.4536,1788.3893,10.4158,92.4627,72,1);
	AddStaticVehicle(522,953.2818,1806.1392,8.2188,235.0706,3,8);
	AddStaticVehicle(522,995.5328,1886.6055,10.5359,90.1048,3,8);
	AddStaticVehicle(521,993.7083,2267.4133,11.0315,1.5610,75,13);
	AddStaticVehicle(535,1439.5662,1999.9822,10.5843,0.4194,66,1);
	AddStaticVehicle(522,1430.2354,1999.0144,10.3896,352.0951,6,25);
	AddStaticVehicle(522,2156.3540,2188.6572,10.2414,22.6504,6,25);
	AddStaticVehicle(598,2277.6846,2477.1096,10.5652,180.1090,0,1);
	AddStaticVehicle(598,2268.9888,2443.1697,10.5662,181.8062,0,1);
	AddStaticVehicle(598,2256.2891,2458.5110,10.5680,358.7335,0,1);
	AddStaticVehicle(598,2251.6921,2477.0205,10.5671,179.5244,0,1);
	AddStaticVehicle(523,2294.7305,2441.2651,10.3860,9.3764,0,0);
	AddStaticVehicle(523,2290.7268,2441.3323,10.3944,16.4594,0,0);
	AddStaticVehicle(523,2295.5503,2455.9656,2.8444,272.6913,0,0);
	AddStaticVehicle(522,2476.7900,2532.2222,21.4416,0.5081,8,82);
	AddStaticVehicle(522,2580.5320,2267.9595,10.3917,271.2372,8,82);
	AddStaticVehicle(522,2814.4331,2364.6641,10.3907,89.6752,36,105);
	AddStaticVehicle(535,2827.4143,2345.6953,10.5768,270.0668,97,1);
	AddStaticVehicle(521,1670.1089,1297.8322,10.3864,359.4936,87,118);
	AddStaticVehicle(487,1614.7153,1548.7513,11.2749,347.1516,58,8);
	AddStaticVehicle(487,1647.7902,1538.9934,11.2433,51.8071,0,8);
	AddStaticVehicle(487,1608.3851,1630.7268,11.2840,174.5517,58,8);
	AddStaticVehicle(476,1283.0006,1324.8849,9.5332,275.0468,7,6); //11.5332
	AddStaticVehicle(476,1283.5107,1361.3171,9.5382,271.1684,1,6); //11.5382
	AddStaticVehicle(476,1283.6847,1386.5137,11.5300,272.1003,89,91);
	AddStaticVehicle(476,1288.0499,1403.6605,11.5295,243.5028,119,117);
	AddStaticVehicle(415,1319.1038,1279.1791,10.5931,0.9661,62,1);
	AddStaticVehicle(521,1710.5763,1805.9275,10.3911,176.5028,92,3);
	AddStaticVehicle(521,2805.1650,2027.0028,10.3920,357.5978,92,3);
	AddStaticVehicle(535,2822.3628,2240.3594,10.5812,89.7540,123,1);
	AddStaticVehicle(521,2876.8013,2326.8418,10.3914,267.8946,115,118);
	AddStaticVehicle(429,2842.0554,2637.0105,10.5000,182.2949,1,3);
	AddStaticVehicle(549,2494.4214,2813.9348,10.5172,316.9462,72,39);
	AddStaticVehicle(549,2327.6484,2787.7327,10.5174,179.5639,75,39);
	AddStaticVehicle(549,2142.6970,2806.6758,10.5176,89.8970,79,39);
	AddStaticVehicle(521,2139.7012,2799.2114,10.3917,229.6327,25,118);
	AddStaticVehicle(521,2104.9446,2658.1331,10.3834,82.2700,36,0);
	AddStaticVehicle(521,1914.2322,2148.2590,10.3906,267.7297,36,0);
	AddStaticVehicle(549,1904.7527,2157.4312,10.5175,183.7728,83,36);
	AddStaticVehicle(549,1532.6139,2258.0173,10.5176,359.1516,84,36);
	AddStaticVehicle(521,1534.3204,2202.8970,10.3644,4.9108,118,118);
	AddStaticVehicle(549,1613.1553,2200.2664,10.5176,89.6204,89,35);
	AddStaticVehicle(400,1552.1292,2341.7854,10.9126,274.0815,101,1);
	AddStaticVehicle(404,1637.6285,2329.8774,10.5538,89.6408,101,101);
	AddStaticVehicle(400,1357.4165,2259.7158,10.9126,269.5567,62,1);
	AddStaticVehicle(411,1281.7458,2571.6719,10.5472,270.6128,106,1);
	AddStaticVehicle(522,1305.5295,2528.3076,10.3955,88.7249,3,8);
	AddStaticVehicle(521,993.9020,2159.4194,10.3905,88.8805,74,74);
	AddStaticVehicle(415,1512.7134,787.6931,10.5921,359.5796,75,1);
	AddStaticVehicle(522,2299.5872,1469.7910,10.3815,258.4984,3,8);
	AddStaticVehicle(522,2133.6428,1012.8537,10.3789,87.1290,3,8);

	//Monday 13th Additions ~ Jax
	AddStaticVehicle(415,2266.7336,648.4756,11.0053,177.8517,0,1); //
	AddStaticVehicle(461,2404.6636,647.9255,10.7919,183.7688,53,1); //
	AddStaticVehicle(506,2628.1047,746.8704,10.5246,352.7574,3,3); //
	AddStaticVehicle(549,2817.6445,928.3469,10.4470,359.5235,72,39); //
	// --- uncommented
	AddStaticVehicle(562,1919.8829,947.1886,10.4715,359.4453,11,1); //
	AddStaticVehicle(562,1881.6346,1006.7653,10.4783,86.9967,11,1); //
	AddStaticVehicle(562,2038.1044,1006.4022,10.4040,179.2641,11,1); //
	AddStaticVehicle(562,2038.1614,1014.8566,10.4057,179.8665,11,1); //
	AddStaticVehicle(562,2038.0966,1026.7987,10.4040,180.6107,11,1); //
	// --- uncommented end

	//Uber haxed
	AddStaticVehicle(422,9.1065,1165.5066,19.5855,2.1281,101,25); //
	AddStaticVehicle(463,19.8059,1163.7103,19.1504,346.3326,11,11); //
	AddStaticVehicle(463,12.5740,1232.2848,18.8822,121.8670,22,22); //
	//AddStaticVehicle(434,-110.8473,1133.7113,19.7091,359.7000,2,2); //hotknife
	AddStaticVehicle(586,69.4633,1217.0189,18.3304,158.9345,10,1); //
	AddStaticVehicle(586,-199.4185,1223.0405,19.2624,176.7001,25,1); //
	//AddStaticVehicle(605,-340.2598,1177.4846,19.5565,182.6176,43,8); // SMASHED UP CAR
	AddStaticVehicle(476,325.4121,2538.5999,17.5184,181.2964,71,77); //
	AddStaticVehicle(476,291.0975,2540.0410,17.5276,182.7206,7,6); //
	AddStaticVehicle(576,384.2365,2602.1763,16.0926,192.4858,72,1); //
	AddStaticVehicle(586,423.8012,2541.6870,15.9708,338.2426,10,1); //
	AddStaticVehicle(586,-244.0047,2724.5439,62.2077,51.5825,10,1); //
	AddStaticVehicle(586,-311.1414,2659.4329,62.4513,310.9601,27,1); //

	//uber haxed x 50
	//AddStaticVehicle(406,547.4633,843.0204,-39.8406,285.2948,1,1); // DUMPER
	//AddStaticVehicle(406,625.1979,828.9873,-41.4497,71.3360,1,1); // DUMPER
	//AddStaticVehicle(486,680.7997,919.0510,-40.4735,105.9145,1,1); // DOZER
	//AddStaticVehicle(486,674.3994,927.7518,-40.6087,128.6116,1,1); // DOZER
	AddStaticVehicle(543,596.8064,866.2578,-43.2617,186.8359,67,8); //
	AddStaticVehicle(543,835.0838,836.8370,11.8739,14.8920,8,90); //
	AddStaticVehicle(549,843.1893,838.8093,12.5177,18.2348,79,39); //
	//AddStaticVehicle(605,319.3803,740.2404,6.7814,271.2593,8,90); // SMASHED UP CAR
	AddStaticVehicle(400,-235.9767,1045.8623,19.8158,180.0806,75,1); //
	AddStaticVehicle(599,-211.5940,998.9857,19.8437,265.4935,0,1); //
	AddStaticVehicle(422,-304.0620,1024.1111,19.5714,94.1812,96,25); //
	AddStaticVehicle(588,-290.2229,1317.0276,54.1871,81.7529,1,1); //
	//AddStaticVehicle(424,-330.2399,1514.3022,75.1388,179.1514,2,2); //BF INJECT
	AddStaticVehicle(451,-290.3145,1567.1534,75.0654,133.1694,61,61); //
	AddStaticVehicle(470,280.4914,1945.6143,17.6317,310.3278,43,0); //
	AddStaticVehicle(470,272.2862,1949.4713,17.6367,285.9714,43,0); //
	AddStaticVehicle(470,271.6122,1961.2386,17.6373,251.9081,43,0); //
	AddStaticVehicle(470,279.8705,1966.2362,17.6436,228.4709,43,0); //
	//AddStaticVehicle(548,292.2317,1923.6440,19.2898,235.3379,1,1); // CARGOBOB
	AddStaticVehicle(433,277.6437,1985.7559,18.0772,270.4079,43,0); //
	AddStaticVehicle(433,277.4477,1994.8329,18.0773,267.7378,43,0); //
	//AddStaticVehicle(432,275.9634,2024.3629,17.6516,270.6823,43,0); // Tank (can cause scary shit to go down)
	AddStaticVehicle(568,-441.3438,2215.7026,42.2489,191.7953,41,29); //
	AddStaticVehicle(568,-422.2956,2225.2612,42.2465,0.0616,41,29); //
	AddStaticVehicle(568,-371.7973,2234.5527,42.3497,285.9481,41,29); //
	AddStaticVehicle(568,-360.1159,2203.4272,42.3039,113.6446,41,29); //
	AddStaticVehicle(468,-660.7385,2315.2642,138.3866,358.7643,6,6); //
	AddStaticVehicle(460,-1029.2648,2237.2217,42.2679,260.5732,1,3); //

	//Uber haxed x 100

    // --- uncommented
	AddStaticVehicle(419,95.0568,1056.5530,13.4068,192.1461,13,76); //
	AddStaticVehicle(429,114.7416,1048.3517,13.2890,174.9752,1,2); //
	//AddStaticVehicle(466,124.2480,1075.1835,13.3512,174.5334,78,76); // exceeds model limit
	AddStaticVehicle(411,-290.0065,1759.4958,42.4154,89.7571,116,1); //
	// --- uncommented end
	AddStaticVehicle(522,-302.5649,1777.7349,42.2514,238.5039,6,25); //
	AddStaticVehicle(522,-302.9650,1776.1152,42.2588,239.9874,8,82); //
	AddStaticVehicle(533,-301.0404,1750.8517,42.3966,268.7585,75,1); //
	AddStaticVehicle(535,-866.1774,1557.2700,23.8319,269.3263,31,1); //
	AddStaticVehicle(550,-799.3062,1518.1556,26.7488,88.5295,53,53); //
	AddStaticVehicle(521,-749.9730,1589.8435,26.5311,125.6508,92,3); //
	AddStaticVehicle(522,-867.8612,1544.5282,22.5419,296.0923,3,3); //
	AddStaticVehicle(554,-904.2978,1553.8269,25.9229,266.6985,34,30); //
	AddStaticVehicle(521,-944.2642,1424.1603,29.6783,148.5582,92,3); //
	// Exceeds model limit, cars need model adjustments
	// --- uncommented
	AddStaticVehicle(429,-237.7157,2594.8804,62.3828,178.6802,1,2); //
	//AddStaticVehicle(431,-160.5815,2693.7185,62.2031,89.4133,47,74); //
	AddStaticVehicle(463,-196.3012,2774.4395,61.4775,303.8402,22,22); //
	//AddStaticVehicle(483,-204.1827,2608.7368,62.6956,179.9914,1,5); //
	//AddStaticVehicle(490,-295.4756,2674.9141,62.7434,359.3378,0,0); //
	//AddStaticVehicle(500,-301.5293,2687.6013,62.7723,87.9509,28,119); //
	//AddStaticVehicle(500,-301.6699,2680.3293,62.7393,89.7925,13,119); //
	AddStaticVehicle(519,-1341.1079,-254.3787,15.0701,321.6338,1,1); //
	AddStaticVehicle(519,-1371.1775,-232.3967,15.0676,315.6091,1,1); //
	//AddStaticVehicle(552,-1396.2028,-196.8298,13.8434,286.2720,56,56); //
	//AddStaticVehicle(552,-1312.4509,-284.4692,13.8417,354.3546,56,56); //
	//AddStaticVehicle(552,-1393.5995,-521.0770,13.8441,187.1324,56,56); //
	//AddStaticVehicle(513,-1355.6632,-488.9562,14.7157,191.2547,48,18); //
	//AddStaticVehicle(513,-1374.4580,-499.1462,14.7482,220.4057,54,34); //
	//AddStaticVehicle(553,-1197.8773,-489.6715,15.4841,0.4029,91,87); //
	//AddStaticVehicle(553,1852.9989,-2385.4009,14.8827,200.0707,102,119); //
	//AddStaticVehicle(583,1879.9594,-2349.1919,13.0875,11.0992,1,1); //
	//AddStaticVehicle(583,1620.9697,-2431.0752,13.0951,126.3341,1,1); //
	//AddStaticVehicle(583,1545.1564,-2409.2114,13.0953,23.5581,1,1); //
	//AddStaticVehicle(583,1656.3702,-2651.7913,13.0874,352.7619,1,1); //
	AddStaticVehicle(519,1642.9850,-2425.2063,14.4744,159.8745,1,1); //
	AddStaticVehicle(519,1734.1311,-2426.7563,14.4734,172.2036,1,1); //
	// --- uncommented end

	AddStaticVehicle(415,-680.9882,955.4495,11.9032,84.2754,36,1); //
	AddStaticVehicle(460,-816.3951,2222.7375,43.0045,268.1861,1,3); //
	AddStaticVehicle(460,-94.6885,455.4018,1.5719,250.5473,1,3); //
	AddStaticVehicle(460,1624.5901,565.8568,1.7817,200.5292,1,3); //
	AddStaticVehicle(460,1639.3567,572.2720,1.5311,206.6160,1,3); //
	AddStaticVehicle(460,2293.4219,517.5514,1.7537,270.7889,1,3); //
	AddStaticVehicle(460,2354.4690,518.5284,1.7450,270.2214,1,3); //
	AddStaticVehicle(460,772.4293,2912.5579,1.0753,69.6706,1,3); //

	// 22/4 UPDATE
	AddStaticVehicle(560,2133.0769,1019.2366,10.5259,90.5265,9,39); //
	AddStaticVehicle(560,2142.4023,1408.5675,10.5258,0.3660,17,1); //
	AddStaticVehicle(560,2196.3340,1856.8469,10.5257,179.8070,21,1); //
	AddStaticVehicle(560,2103.4146,2069.1514,10.5249,270.1451,33,0); //
	AddStaticVehicle(560,2361.8042,2210.9951,10.3848,178.7366,37,0); //
	AddStaticVehicle(560,-1993.2465,241.5329,34.8774,310.0117,41,29); //
	AddStaticVehicle(559,-1989.3235,270.1447,34.8321,88.6822,58,8); //
	AddStaticVehicle(559,-1946.2416,273.2482,35.1302,126.4200,60,1); //
	AddStaticVehicle(558,-1956.8257,271.4941,35.0984,71.7499,24,1); //
	AddStaticVehicle(562,-1952.8894,258.8604,40.7082,51.7172,17,1); //
	AddStaticVehicle(411,-1949.8689,266.5759,40.7776,216.4882,112,1); //
	AddStaticVehicle(429,-1988.0347,305.4242,34.8553,87.0725,2,1); //
	AddStaticVehicle(559,-1657.6660,1213.6195,6.9062,282.6953,13,8); //
	AddStaticVehicle(560,-1658.3722,1213.2236,13.3806,37.9052,52,39); //
	AddStaticVehicle(558,-1660.8994,1210.7589,20.7875,317.6098,36,1); //
	AddStaticVehicle(550,-1645.2401,1303.9883,6.8482,133.6013,7,7); //
	AddStaticVehicle(460,-1333.1960,903.7660,1.5568,0.5095,46,32); //

	// 25/4 UPDATE
	AddStaticVehicle(411,113.8611,1068.6182,13.3395,177.1330,116,1); //
	AddStaticVehicle(429,159.5199,1185.1160,14.7324,85.5769,1,2); //
	AddStaticVehicle(411,612.4678,1694.4126,6.7192,302.5539,75,1); //
	AddStaticVehicle(522,661.7609,1720.9894,6.5641,19.1231,6,25); //
	AddStaticVehicle(522,660.0554,1719.1187,6.5642,12.7699,8,82); //
	AddStaticVehicle(567,711.4207,1947.5208,5.4056,179.3810,90,96); //
	AddStaticVehicle(567,1031.8435,1920.3726,11.3369,89.4978,97,96); //
	AddStaticVehicle(567,1112.3754,1747.8737,10.6923,270.9278,102,114); //
	AddStaticVehicle(567,1641.6802,1299.2113,10.6869,271.4891,97,96); //
	AddStaticVehicle(567,2135.8757,1408.4512,10.6867,180.4562,90,96); //
	AddStaticVehicle(567,2262.2639,1469.2202,14.9177,91.1919,99,81); //
	AddStaticVehicle(567,2461.7380,1345.5385,10.6975,0.9317,114,1); //
	AddStaticVehicle(567,2804.4365,1332.5348,10.6283,271.7682,88,64); //
	AddStaticVehicle(560,2805.1685,1361.4004,10.4548,270.2340,17,1); //
	AddStaticVehicle(506,2853.5378,1361.4677,10.5149,269.6648,7,7); //
	AddStaticVehicle(567,2633.9832,2205.7061,10.6868,180.0076,93,64); //
	AddStaticVehicle(567,2119.9751,2049.3127,10.5423,180.1963,93,64); //
	AddStaticVehicle(567,2785.0261,-1835.0374,9.6874,226.9852,93,64); //
	AddStaticVehicle(567,2787.8975,-1876.2583,9.6966,0.5804,99,81); //
	AddStaticVehicle(411,2771.2993,-1841.5620,9.4870,20.7678,116,1); //
	AddStaticVehicle(420,1713.9319,1467.8354,10.5219,342.8006,6,1); // taxi

	AddStaticPickup(371, 15, 1710.3359,1614.3585,10.1191); //para
	AddStaticPickup(371, 15, 1964.4523,1917.0341,130.9375); //para
	AddStaticPickup(371, 15, 2055.7258,2395.8589,150.4766); //para
	AddStaticPickup(371, 15, 2265.0120,1672.3837,94.9219); //para
	AddStaticPickup(371, 15, 2265.9739,1623.4060,94.9219); //para


	// Player Class's
	AddPlayerClass(0,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(266,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(267,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(268,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(269,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(270,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(271,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(272,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	
	AddPlayerClass(280,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(281,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(282,1958.3783,1343.1572,15.3746,270.1425,0,0,24,300,-1,-1);
	AddPlayerClass(283,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(284,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(285,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(286,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(287,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	
	AddPlayerClass(254,1958.3783,1343.1572,15.3746,0.0,0,0,24,300,-1,-1);
	AddPlayerClass(255,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(256,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(257,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(258,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(259,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(260,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(261,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(262,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(263,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(264,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(274,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(275,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(276,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	
	AddPlayerClass(1,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(2,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(290,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(291,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(292,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(293,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(294,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(295,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(296,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(297,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(298,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
    AddPlayerClass(299,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);

	AddPlayerClass(277,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(278,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(279,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(288,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(47,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(48,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(49,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(50,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(51,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(52,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(53,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(54,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(55,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(56,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(57,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(58,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(59,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(60,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(61,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(62,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(63,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(64,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(66,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(67,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(68,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(69,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(70,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(71,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(72,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(73,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(75,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(76,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(78,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(79,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(80,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(81,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(82,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(83,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(84,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(85,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(87,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(88,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(89,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(91,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(92,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(93,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(95,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(96,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(97,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(98,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(99,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(100,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(101,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(102,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(103,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(104,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(105,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(106,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(107,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(108,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(109,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(110,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(111,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(112,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(113,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(114,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(115,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(116,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(117,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(118,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(120,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(121,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(122,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(123,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(124,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(125,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(126,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(127,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(128,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(129,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(131,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(133,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(134,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(135,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(136,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(137,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(138,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(139,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(140,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(141,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(142,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(143,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(144,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(145,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(146,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(147,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(148,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(150,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(151,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(152,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(153,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(154,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(155,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(156,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(157,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(158,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(159,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(160,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(161,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(162,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(163,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(164,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(165,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(166,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(167,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(168,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(169,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(170,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(171,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(172,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(173,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(174,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(175,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(176,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(177,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(178,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(179,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(180,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(181,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(182,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(183,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(184,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(185,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(186,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(187,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(188,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(189,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(190,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(191,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(192,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(193,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(194,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(195,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(196,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(197,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(198,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(199,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(200,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(201,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(202,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(203,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(204,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(205,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(206,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(207,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(209,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(210,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(211,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(212,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(213,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(214,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(215,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(216,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(217,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(218,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(219,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(220,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(221,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(222,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(223,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(224,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(225,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(226,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(227,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(228,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(229,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(230,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(231,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(232,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(233,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(234,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(235,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(236,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(237,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(238,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(239,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(240,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(241,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(242,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(243,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(244,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(245,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(246,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(247,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(248,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(249,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(250,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(251,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(253,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);

	SetTimer("MoneyGrubScoreUpdate", 1000, 1);
	//SetTimer("GameModeExitFunc", gRoundTime, 0);

	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
  	new V_Mdel[256];
   	new string[256];
	//new Vx, Vy, Vz;//float?
	//new V_id;//, V_Vel;
	new Float: v_health;
	new panels, doors, lights, tires;
    new carro_enter_mod = GetVehicleModel(vehicleid);

	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	
	//format(string, sizeof(string), "v_status:vx[%f]vy[%f]vz[%f]za[%f]rw[%f]rx[%f]ry[%f]rz[%f]p[%d]d[%d]l[%d]t[%d]", vx, vy, vz, zang, Rw, Rx, Ry, Rz, panels, doors, lights, tires);
	
	//ISSO PRA QUANDO SAIR DO CARRO:
	//V_id 	= GetPlayerVehicleID(playerid) //nao deu = 0 (NAO PEGA AQUI POIS NAO ESTA EM NENHUM VEICULO AINDA)
	
	//USA PARAMETRO PASSADO DA FUNCAO:
	format(V_Mdel, sizeof(V_Mdel), "%d", carro_enter_mod);
	//V_Mdel 	= GetVehicleModel(vehicleid);
	
	//PEGA VELOCIDADE: (USAR NO UPDATE)
	//V_Vel	= GetVehicleVelocity(vehicleid, Vx, Vy, Vz);
	
	GetVehicleHealth(vehicleid, v_health);
	format(string, sizeof(string), "VOCE ENTROU NO VEICULO ID[%d] MODEL [%s](player: %d) health[%f] danos:p[%d]d[%d]l[%d]t[%d]", vehicleid, V_Mdel, playerid, v_health, panels, doors, lights, tires);
        MOSTRA_INFO1_s(playerid, string);
    
    carro_enter_mod = carro_enter_mod - 400;
	format(string, sizeof(string), "EnterVehicl: Dados do modelo: nome[%s] 2[%s] 3[%s] 4[%s] 5[%s] ingles:[%s]",
                        CarrosNomes[carro_enter_mod][1], CarrosNomes[carro_enter_mod][2],
                        CarrosNomes[carro_enter_mod][3], CarrosNomes[carro_enter_mod][4],
                        CarrosNomes[carro_enter_mod][5], NomesVeiculosIngles[carro_enter_mod]);
        MOSTRA_INFO2_dd(playerid,string, 0,0);
    
	//printf("%s(playerid:%d) has transfered %d to %s(playerid:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);

	//new s[256];
	//format(s,256,"Picked up %d",pickupid);
	//SendClientMessage(playerid,0xFFFFFFFF,s);
	//GetVehicleModel(vehicleid);

	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerExitVehicle(playerid, vehicleid){
//	new armas_todas[256];
   	new string[256];
	//new armas_todas;
	new weaponid_test;
	//new arma_atual;
	//new nova_municao;	new municao_atual;
	//new slot_arma;
	//new arma_0, arma_1, arma_2;
	//new armas_show[256];
	
	new Float: v_health;
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	GetVehicleHealth(vehicleid, v_health);
	format(string, sizeof(string), "VOCE SAIU DO VEICULO ID[%d] MODEL [%d](player: %d) health[%f] danos:p[%d]d[%d]l[%d]t[%d]",
									vehicleid, GetVehicleModel(vehicleid), playerid, v_health, panels, doors, lights, tires);
        MOSTRA_INFO1_s(playerid, string);
        
	//MOSTRA ARMA ATUAL:
	//arma_atual = GetPlayerWeapon(playerid);

    weaponid_test = 31;
	SetPlayerArmedWeapon(playerid, weaponid_test);
    
    if (PlayerMecanicoMagico[playerid] == 1){
        MOSTRA_INFO3_dd(playerid, "ExitVehicl: Carro[%d] reparado.",vehicleid,0);
        RepairVehicle(vehicleid);
    }
	
	//SOMENTE SOME COM O VEICULO:
	//DestroyVehicle(vehicleid);
	
	return 1;
}
//------------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------
            // ---- helps (COLOR_HELP1)
public SHOW_HELP(playerid, const str[]){	
    new tmpbuf[512];
    format(tmpbuf, sizeof(tmpbuf), str);
	SendClientMessage(playerid,COLOR_HELP1, tmpbuf);    
}
public SHOW_HELP_d(playerid, const str[], define){	
    new tmpbuf[512];
    format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessage(playerid,COLOR_HELP1, tmpbuf);    
}

            // ---- COLOR_TEXT1
public MOSTRA_TEXTO1(playerid, const str[], define){    //SOMENTE TEXTO DA FUCAO NORMAL //VERMELHO BEM VISIVEL (COLOR_TEXT1 CORAQUI)
    new tmpbuf[512];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessage(playerid,COLOR_TEXT1, tmpbuf);}
    
    //inicio de funcao alertas
public MOSTRA_TEXTO_dss(playerid, const str[], define, const str1[], const str2[]){ //TEXTO DA FUCAO dss //VERMELHO BEM VISIVEL
    new tmpbuf[512];
	format(tmpbuf, sizeof(tmpbuf), str, define, str1, str2);
	SendClientMessage(playerid,COLOR_TEXT1, tmpbuf);}
    
    //para itens encontrados
public MOSTRA_TEXTO_ssd(playerid, const str[], const str1[], const str2[],define){ //TEXTO DA FUCAO ssd //VERMELHO BEM VISIVEL 
    new tmpbuf[512];
	format(tmpbuf, sizeof(tmpbuf), str, str1, str2,define);
	SendClientMessage(playerid,COLOR_TEXT1, tmpbuf);}


public SendPlayerFormattedText(playerid, const str[], define){                   //VERMELHO BEM VISIVEL
    new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessage(playerid,COLOR_TEXT1, tmpbuf);}
        
// ---------  ERROSS ---------------------------------------------------------    
                // ---- COLOR_ERRO1
public MOSTRA_ERRO_sd(playerid, const str[], const str2[], define2){             //USAR COR DIFERENTE
    new tmpbuf[256];
    if (mostra_debug_list[playerid] == 1){
    }
        format(tmpbuf, sizeof(tmpbuf), str, str2, define2);
        SendClientMessage(playerid, COLOR_ERRO1, tmpbuf);
}
public MOSTRA_ERRO_sdd(playerid, const str[], const str2[], define1, define2){             //USAR COR DIFERENTE
    new tmpbuf[256];
    if (mostra_debug_list[playerid] == 1){
    }
        format(tmpbuf, sizeof(tmpbuf), str, str2, define1, define2);
        SendClientMessage(playerid, COLOR_ERRO1, tmpbuf);
}
public MOSTRA_ERRO_ds(playerid, const str[], define2, const str2[]){             //USAR UMA COR MAIS CHAMATIVA ok amarelo
    new tmpbuf[256];
    if (mostra_debug_list[playerid] == 1){
    }
        format(tmpbuf, sizeof(tmpbuf), str, define2, str2);
        SendClientMessage(playerid, COLOR_ERRO1, tmpbuf);
}
    
// ---------  DEBUGS ---------------------------------------------------------    
                // ---- COLOR_INFO2 (RED)
public SendPlayerFormattedTextDEBUGds (playerid, const str[], define2, const str2[]) {
    new tmpbuf[256];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, define2, str2);
        SendClientMessage(playerid, COLOR_INFO2, tmpbuf);
    }
}
                // ---- COLOR_DEBUG (green)
public DEBUG_ds (playerid, const str[], define      , const str2[]  ){       //NIVEL 1
	new tmpbuf[512];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, define, str2);
        SendClientMessage(playerid, COLOR_DEBUG, tmpbuf);
    }
}
public DEBUG_sds (playerid, const str[], const str2[], define, const str3[]){ //NIVEL 1
	new tmpbuf[512];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, str2, define, str3);
        SendClientMessage(playerid, COLOR_DEBUG, tmpbuf);
    }
}
public DEBUG_sd (playerid, const str[], const str2[], define){
	new tmpbuf[512];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, str2, define);
        SendClientMessage(playerid, COLOR_DEBUG, tmpbuf);
    }
}
public DEBUGsdds (playerid, const str[], const str2[], define, define2, const str3[]){ //usar para mensagens mais especificas
	new tmpbuf[512];
    if (mostra_debug_nivel_2[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, str2, define, define2, str3);
        SendClientMessage(playerid, COLOR_DEBUG, tmpbuf);
    }
}
public DEBUG2_ds (playerid, const str[], define      , const str2[]  ){       //NIVEL 2
	new tmpbuf[512];
    if (mostra_debug_nivel_2[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, define, str2);
        SendClientMessage(playerid, COLOR_DEBUG, tmpbuf);
    }
}
                // ----  COLOR_LIST               
public DEBUG_INFO_sd (playerid, const str[], const str2[], define){ 
	new tmpbuf[512];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, str2, define);
        SendClientMessage(playerid, COLOR_LIST, tmpbuf);
    }
}
public DEBUG_INFO_ds (playerid, const str[], define, const str2[]){ 
	new tmpbuf[512];
    if (mostra_debug[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, define, str2);
        SendClientMessage(playerid, COLOR_LIST, tmpbuf);
    }
}

                    // ---- DEBUG EM LISTAS  (COLOR_INFO2) RED
//COLOR_LIST DEBUG_LIST_ds(AMARELO) DEBUG2_ds(nao precisa ser list AMARELO)  DEBUGS(???)
public DEBUG_LIST_ds(playerid, const str[], define2, const str2[]){
    new tmpbuf[256];
    if (mostra_debug_list[playerid] == 1){
        format(tmpbuf, sizeof(tmpbuf), str, define2, str2);
        SendClientMessage(playerid, COLOR_INFO2, tmpbuf);
    }
}
public DEBUG_LIST2_ds(playerid, const str[], define2, const str2[]){ //NIVEL 2
    new tmpbuf[256];
    if (mostra_debug_list[playerid] == 1){
        if (mostra_debug_nivel_2[playerid] == 1){
            format(tmpbuf, sizeof(tmpbuf), str, define2, str2);
            SendClientMessage(playerid, COLOR_INFO2, tmpbuf);            
        }
    }
}
    
 
// ---------  INFOS ----------------------------------------------------------  
                // ---- infos 3 (COLOR_INFO3 COLOR_GREEN)
public MOSTRA_INFO3_dd(playerid, const str[], define, define2){   //VERDE ESCURO MEDIO (GREEN COLOR_INFO3)
    new tmpbuf[256];
    //new cor_original = 0xFF004040;
	format(tmpbuf, sizeof(tmpbuf), str, define, define2);
	SendClientMessage(playerid, COLOR_INFO3, tmpbuf);
}
public MOSTRA_INFO_dss(playerid, const str[], define,const str1[],const str2[]){	
    new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define, str1, str2);
	SendClientMessage(playerid, COLOR_INFO3, tmpbuf);    
}
public MOSTRA_INFO_ssd(playerid, const str[],const str1[],const str2[], define){
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, str1, str2, define);
	SendClientMessage(playerid, COLOR_INFO3, tmpbuf);    
}
public MOSTRA_INFO_sdd(playerid, const str[],const str1[], define, define2){
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, str1, define, define2);
	SendClientMessage(playerid, COLOR_INFO3, tmpbuf);    
}
public MOSTRA_INFO_sd(playerid, const str[], const str1[], define){
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, str1, define);
	SendClientMessage(playerid, COLOR_INFO3, tmpbuf);    
}
               // ---- infos 2 (COLOR_INFO2 COLOR_RED)
public MOSTRA_INFO2_dd (playerid, const str[], define, define2) {
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define, define2);
	SendClientMessage(playerid, COLOR_INFO2, tmpbuf);
}
public SendPlayerFormattedTextINFOsd (playerid, const str[], const str2[], define2) {
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, str2, define2);
	SendClientMessage(playerid, COLOR_INFO2, tmpbuf);
} 
public SendPlayerFormattedTextINFOds (playerid, const str[], define2, const str2[]) {
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define2, str2);
	SendClientMessage(playerid, COLOR_INFO2, tmpbuf);
}
                // ---- infos 1 (COLOR_INFO1 COLOR_RED_ST)                                  /// INFORMACOES VIBRANTES VERMELHAS
public MOSTRA_INFO1_dsd (playerid, const str[], define,const str2[], define2){ //INFORMACOES DE DESTAQUE (deven ser vistas pelo usuario)
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define, str2, define2);
	SendClientMessage(playerid, COLOR_INFO1, tmpbuf);
}
public MOSTRA_INFO1_s (playerid, const str[]){
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str,0);
	SendClientMessage(playerid, COLOR_INFO1, tmpbuf);
}

// ---------  MENSAGEM DA FUNCAO EXECUCAO NORMAL -----------------------------      
/*public MOSTRA_MSG_sd(playerid, const str[], const str1[], define){	
    new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, str1, define);
    SendClientMessage(playerid, COLOR_INFO, tmpbuf);       //INFO ESTAVA AMARELO
}*/

// ---------  TO ALL --------------------------------------------------------- 
                // ---- COLOR_TEXTALL
public SendAllFormattedText(playerid, const str[], define){
    //new cor_original = 0xFFFF00AA;
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessageToAll(COLOR_TEXTALL, tmpbuf);}

//------------------------------------------------------------------------------
strtok(const string[], &index){
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
//------------------------------------------------------------------------------
strtopoint(const string[]){
	new length = strlen(string);

	new index = 0;
	//new offset = index;
	new result[20];
	while ((index < length) && !(string[index] == '.') )
	{
		result[index] = string[index];
		index++;
	}
	//result[index] = EOS;
	return result;
}
//------------------------------------------------------------------------------
PlaySoundForAll(soundid, Float:x, Float:y, Float:z){
	for (new i=0; i<MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i))
	    {
		    PlayerPlaySound(i, soundid, x, y, z);
	    }
	}
}
//------------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------
public OnPlayerUpdate(playerid){
        
    if (mostra_xyz_cmd[playerid] == 1) {              // x, y, z, ang, floatsin(ang),floatcos(ang)
        mostra_list_xyz_cmd(playerid);
    }
    if (mostra_carro_cmd[playerid] == 1) {            //vx, vy, vz, zang, Rw, Rx, Ry, Rz, panels, doors, lights, tires
        mostra_veiculo_status_cmd(playerid);
    }
    
    //OS DRAW PRECISAM DESMOSTRAR OS TEXT
    if (mostra_vel_draw[playerid] == 1) {             //vx_str, vy_str, vz_str, vm_str
        mostra_velocidade_draw(playerid);
    }
    else{
        TextDrawHideForPlayer(playerid, text_vel[playerid]);
    }
        
    if (mostra_pos_draw[playerid] == 1) {
        mostra_posicao_DRAW(playerid);
    }
    else{
        TextDrawHideForPlayer(playerid, text_pos[playerid]);
    }

    
    if (mostra_armas_draw[playerid] == 1) {
        mostra_armas_status_Draw(playerid); //3 prim slots
    }
    else{
        TextDrawHideForPlayer(playerid, text1[playerid]);
        TextDrawHideForPlayer(playerid, text2[playerid]);
        TextDrawHideForPlayer(playerid, text3[playerid]);
        TextDrawHideForPlayer(playerid, text4[playerid]);
        TextDrawHideForPlayer(playerid, text5[playerid]);
        TextDrawHideForPlayer(playerid, text6[playerid]);
        TextDrawHideForPlayer(playerid, text7[playerid]);
        TextDrawHideForPlayer(playerid, text8[playerid]);
        TextDrawHideForPlayer(playerid, text9[playerid]);
        TextDrawHideForPlayer(playerid, text10[playerid]);
        TextDrawHideForPlayer(playerid, text11[playerid]);
        TextDrawHideForPlayer(playerid, text12[playerid]);
        TextDrawHideForPlayer(playerid, text13[playerid]);
//        TextDrawHideForPlayer(playerid, text14[playerid]);
//        TextDrawHideForPlayer(playerid, text15[playerid]);
    }
    //SendPlayerFormattedText(playerid,"OnPlayerUpdate: [%d]", playerid);

	return 1;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
mostra_list_xyz_cmd(playerid) {              // x, y, z, ang, floatsin(ang),floatcos(ang)
	new Float:x,Float:y,Float:z, Float:ang;
	new string[256];
	
	//PEGA POSICAO DO PLAYER:
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, ang);

	//degrees to rads	  radian,  grades
	ang = (ang * 2 * 3.14) / 360;

	format(string, sizeof(string), "ang : fSIN[%f] fCOS[%f]", floatsin(ang),floatcos(ang));
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "x[%f] y[%f] z[%f] a[%f]", x, y, z, ang);
	SendClientMessage(playerid, COLOR_GREEN, string);
}
//------------------------------------------------------------------------------
mostra_velocidade_draw(playerid) {       //            vx_str, vy_str, vz_str, vm_str
	new Float:vx,Float:vy,Float:vz;//, Float:zang;
	new Float: modulo_vel;
	new vehicleid = GetPlayerVehicleID(playerid);
	new string[256];
	
	new vx_str[20];
	new vy_str[20];
	new vz_str[20];
	new vm_str[20];
	
	GetVehicleVelocity(vehicleid,vx, vy, vz);

    //vmax do bullet (541) > 1.13 
    //1 mi/h > 1.609 km/h
    
	vx = vx * 100.0 * 1.609;
	vy = vy * 100.0 * 1.609;
	vz = vz * 100.0 * 1.609;
    
	//vx = floatround(vx, floatround_ceil);
	//vy = floatround(vy, floatround_ceil);
	//vz = floatround(vz, floatround_ceil);

	modulo_vel = floatsqroot( (floatmul(vx,vx))+(floatmul(vy,vy))+(floatmul(vz,vz)) );
	//usar floatmul(vx,vx)
	//modulo_vel = floatround(modulo_vel, floatround_ceil);
	
//	valstr(vx_str, vx);
	format(vx_str, sizeof(vx_str), "%f", vx);
	vx_str = strtopoint(vx_str);
	format(vy_str, sizeof(vy_str), "%f", vy);
	vy_str = strtopoint(vy_str);
	format(vz_str, sizeof(vz_str), "%f", vz);
	vz_str = strtopoint(vz_str);
	format(vm_str, sizeof(vm_str), "%f", modulo_vel);
    vm_str = strtopoint(vm_str);

	/*	floatround_round,
	    floor ceil tozero unbiased	*/

	//format(string, sizeof(string), "v_status:vx[%f]vy[%f]vz[%f] mod[%d] x_str[%s]y_str[%s]z_str[%s]m_str[%s]", vx, vy, vz, modulo_vel, vx_str, vy_str, vz_str, vm_str);
	format(string, sizeof(string), "v_status: x[%s] y[%s] z[%s] m[%s] (x160.9) dist/tempo",vx_str, vy_str, vz_str, vm_str);
	//TextDrawCreate(pos_x,pos_y, string);
	
	TextDrawTextSize(text_vel[playerid], x_size[playerid], y_size[playerid]);
	TextDrawFont(text_vel[playerid], fontvel[playerid]);
	TextDrawLetterSize(text_vel[playerid], x_s_l[playerid], y_s_l[playerid]);//largura//altura
	TextDrawShowForPlayer(playerid, text_vel[playerid]);
    
	TextDrawSetString(text_vel[playerid], string);
}
mostra_posicao_DRAW(playerid){
	new Float:x,Float:y,Float:z, Float:ang;
	new string[256];
	new x_str[20];
	new y_str[20];
	new z_str[20];
	new a_str[20];
	
	//PEGA POSICAO DO PLAYER:
 	GetPlayerPos(playerid, x, y, z);

	format(x_str, sizeof(x_str), "%f", x);
	x_str = strtopoint(x_str);
	format(y_str, sizeof(y_str), "%f", y);
	y_str = strtopoint(y_str);
	format(z_str, sizeof(z_str), "%f", z);
	z_str = strtopoint(z_str);
    
		if (IsPlayerInAnyVehicle(playerid)){
            new v_id_pos = GetPlayerVehicleID(playerid); 
            
            //GetVehicleZAngle(vid,&fzang);
            //GetVehicleRotationQuat(vid, &fw,&fx,&fy,&fz);
            GetVehicleZAngle(v_id_pos,ang);
            //GetVehicleRotationQuat(vid, &fw,&fx,&fy,&fz);
            format(a_str, sizeof(a_str), "%f", ang);
            a_str = strtopoint(a_str);            
            format(a_str, sizeof(a_str), "z(%s)", a_str);
		}
		else{//usa o carro anterior
            GetPlayerFacingAngle(playerid, ang);
            format(a_str, sizeof(a_str), "%f", ang);
            a_str = strtopoint(a_str);            
		}
    
	//degrees to rads	  radian,  grades
	ang = (ang * 2 * 3.14) / 360;

//	format(string, sizeof(string), "x[%f] y[%f] z[%f] a[%f] fSIN[%f] fCOS[%f]", x, y, z, ang, floatsin(ang),floatcos(ang));
	format(string, sizeof(string), "x[%s] y[%s] z[%s] a[%s] fSIN[%f] fCOS[%f]", x_str, y_str, z_str, a_str, floatsin(ang),floatcos(ang));
    
	TextDrawTextSize(text_pos[playerid], x_size_pos[playerid], y_size_pos[playerid]);// x_size > pox_x
	TextDrawFont(text_pos[playerid], fontpos[playerid]);
	TextDrawLetterSize(text_pos[playerid], x_s_l_pos[playerid], y_s_l_pos[playerid]);//largura//altura
	TextDrawShowForPlayer(playerid, text_pos[playerid]);
    
	TextDrawSetString(text_pos[playerid], string);
}
//------------------------------------------------------------------------------------------------
format_ARMAS_draw(&Text_Draw,slot_n, playerid){
	new string[256];
    new tipos_armas[13][256] = {
        "de mao",
        "brancas",
        "pistola",
        "calibre",
        "metrlha",
        "assalto",
        "rifles",
        "dstruic",
        "explosv",
        "objetos",
        "pirocas",
        "equipam",
        "botoes"   };
    
	new armas_todas, municao_atual;
    
    GetPlayerWeaponData(playerid, slot_n, armas_todas, municao_atual);
    format(string, sizeof(string), "%s %d %d %d", tipos_armas[slot_n],slot_n, armas_todas, municao_atual);
    TextDrawSetString(Text_Draw, string);
    TextDrawShowForPlayer(playerid, Text_Draw);
}

mostra_armas_status_Draw(playerid) {//3 prim slots
	//new string[256];
	//new lista_de_armas[13][3];

        atualiza_textos(playerid);
		
        format_ARMAS_draw(text1[playerid], 0, playerid);
        format_ARMAS_draw(text2[playerid], 1, playerid);
        format_ARMAS_draw(text3[playerid], 2, playerid);
        format_ARMAS_draw(text4[playerid], 3, playerid);
        format_ARMAS_draw(text5[playerid], 4, playerid);
        format_ARMAS_draw(text6[playerid], 5, playerid);
        format_ARMAS_draw(text7[playerid], 6, playerid);
        format_ARMAS_draw(text8[playerid], 7, playerid);
        format_ARMAS_draw(text9[playerid], 8, playerid);
        format_ARMAS_draw(text10[playerid], 9, playerid);
        format_ARMAS_draw(text11[playerid], 10, playerid);
        format_ARMAS_draw(text12[playerid], 11, playerid);
        format_ARMAS_draw(text13[playerid], 12, playerid);
        
		//SendClientMessage(playerid, COLOR_GREEN, string);
		
	//lista_de_armas = pega_armas(playerid);

}
//------------------------------------------------------------------------------------------------
mostra_veiculo_status_cmd(playerid) {//vx, vy, vz, zang, Rw, Rx, Ry, Rz, panels, doors, lights, tires
	new Float:vx,Float:vy,Float:vz, Float:zang;
	new Float:Rw, Float:Rx, Float:Ry, Float:Rz;
	new panels, doors, lights, tires;
	new vehicleid = GetPlayerVehicleID(playerid);
	new string[256];

	GetVehicleVelocity(vehicleid,vx, vy, vz);
	GetVehicleZAngle(vehicleid, zang);
	GetVehicleRotationQuat(vehicleid, Rw, Rx, Ry, Rz);
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	
	format(string, sizeof(string), "v_status:vx[%f]vy[%f]vz[%f]za[%f]rw[%f]rx[%f]ry[%f]rz[%f]p[%d]d[%d]l[%d]t[%d]", vx, vy, vz, zang, Rw, Rx, Ry, Rz, panels, doors, lights, tires);
	SendClientMessage(playerid, COLOR_GREEN, string);
}
//------------------------------------------------------------------------------

mostra_armas(playerid) {
	new armas_todas;
	new municao_atual;
	new armas_show[256];
	new armas_show2[256];

		format(armas_show, sizeof(armas_show), "ARMAS nos slots:");
		SendClientMessage(playerid, COLOR_YELLOW, armas_show);

    for (new slot_n=0; slot_n < 13; slot_n = slot_n + 2)
	{
		GetPlayerWeaponData(playerid, slot_n, armas_todas, municao_atual);
		format(armas_show, sizeof(armas_show), "[%d]:[%d] munic[%d].", slot_n, armas_todas, municao_atual);
		GetPlayerWeaponData(playerid, (slot_n + 1), armas_todas, municao_atual);
		format(armas_show2, sizeof(armas_show2), "%s   [%d]:[%d] munic[%d].", armas_show, (slot_n + 1 ), armas_todas, municao_atual);
		SendClientMessage(playerid, COLOR_YELLOW, armas_show2);
	}
}
//------------------------------------------------------------------------------
/*ANALISE DOS SLOTS:

0  punho soco
1  golf/pol/faca/base/pa/taco/kata/moto
2  pistol/silent/desert
3  scope/seerrada/12auto
4  microt/smg/minismg
5  ak/m16
6  esping/snipper
7  rpg/missil/flame/minig
8  granada/gas/molotov/bomba
9  spray/estint/fotog
10 dildo b/dildop/dildom/dildop2/flores/beng
11 binvd/binvm/paraq
12 button?? > sempre que joga uma bomba(39) aparece button(40) nos slots 13 e 12
13 button???
*/
pega_armas(playerid) {
	new lista_de_armas[13][3];
	new arma, municao;
	
    for (new slot_n=0; slot_n < 14; slot_n++)
	{
		GetPlayerWeaponData(playerid, slot_n, arma, municao);
		lista_de_armas[slot_n+1][1] = arma;
		lista_de_armas[slot_n+1][2] = municao;
	}
	return lista_de_armas;
}
//--------------------------------------------------------------------------------
configura_carro(carro_id, cor1, cor2, paintjobid, Float:saude_carro, panels, doors, lights, tires){
		ChangeVehiclePaintjob(carro_id, paintjobid);
		ChangeVehicleColor(carro_id, cor1, cor2);
		
		SetVehicleHealth(carro_id, saude_carro);
		//partes destruidas:
		UpdateVehicleDamageStatus(carro_id, panels, doors, lights, tires);	
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

















