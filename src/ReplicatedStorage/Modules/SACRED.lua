--!strict

local module = { 
	musclesNames = {"abs", "torso", "back", 
		"rightneck", "rightshoulder", "rightchest", "rightbicep", "righttricep", "rightforearm",
		"leftneck" , "leftshoulder" , "leftchest" , "leftbicep" , "lefttricep",  "leftforearm",
		"righthamstring", "rightquad","rightcalve","lefthamstring" , "leftquad", "leftcalve"},
	ranks = {'normal','bronze','silver','gold','platinum','titanium','obsidian','raptor','diamond','volcano','rocky'},
	levels = { -- xp until next one 
		[0]  = 10, [1]  = 10, [2]  = 10, [3]  = 10, [4]  = 10,
		[5]  = 10, [6]  = 10, [7]  = 10, [8]  = 10, [9]  = 10,
		[10] = 10, [11] = 10, [12] = 10, [13] = 10, [14] = 10,
		[15] = 10, [16] = 10, [17] = 10, [18] = 10,	[19] = 10,
		[20] = 10, [21] = 10, [22] = 10, [23] = 10, [24] = 10,
	},
	milestones = {
		{ onLevel = 5 , rewards = {'1st MS reward n1', '1st MS reward n2', '1st MS reward n3' }},
		{ onLevel = 12, rewards = {'2nd MS reward n1', '2nd MS reward n2', '2nd MS reward n3' }},
		{ onLevel = 20, rewards = {'3rd MS reward n1', '3rd MS reward n2', '3rd MS reward n3' }}
	},
	food = {
		cookie = 100;
		corndog = 10;  
		dinonuggets = 50;  
		dinosoda = 500;  
		apple = 25;  
		meat = 250;  
		lollipop = 125;  
	},
	tamer = {
		bronze =   { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		silver =   { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		gold   =   { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		platinum = { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		titanium = { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		obsidian = { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		raptor 	=  { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		diamond =  { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		volcano =  { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
		rocky   =  { back = 100, chest = 100, arms = 100, legs = 100, stamina = 300 },
	},
	gym = {
		rewards = {
			back    = {xp = 1, amount = 1, muscles = {'back','rightneck','leftneck'} },
			chest 	= {xp = 1, amount = 1, muscles = {'leftchest','rightchest','abs','torso'}},
			stamina = {xp = 1, amount = 1, muscles = {'leftquad','rightquad' ,'rightcalve','leftcalve'}},
			legs    = {xp = 1, amount = 1, muscles = {'righthamstring','lefthamstring' ,'rightcalve','leftcalve',} },
			arms    = {xp = 1, amount = 1, muscles = {'righttricep','rightbicep','lefttricep','leftbicep','rightshoulder','leftshoulder',	'rightforearm', 'leftforearm',  } },
		},
		weights = {
			stamina = { 
				first  = { min = 0,    reward = 1, cost = 0, }, second = { min = 300,  reward = 2, cost = 0, }, third  = { min = 800,  reward = 3, cost = 0, },
				fourth = { min = 1500, reward = 4, cost = 0, }, fifth  = { min = 3000, reward = 5, cost = 0, }, sixth  = { min = 5000, reward = 6, cost = 0, }
			},
			other = { 
				first  = {min = 0,			reward = 1  , cost = 10  , }, second = {min = 100,		reward = 2  , cost = 20  , }, third  = {min = 1000,		reward = 5  , cost = 50  , },
				fourth = {min = 10000, 	reward = 20 , cost = 200 , }, fifth  = {min = 50000, 	reward = 50 , cost = 500 , }, sixth  = {min = 100000, reward = 100, cost = 1000, } 
			}
		}
	},
	
	assets = {
		dinos = {--Profile Pics
			_locked = "rbxassetid://73935414268749",
			greenraptor = 'rbxassetid://98828136207289',
			lightblue 	= "rbxassetid://118267138774242",
			yellow  	= 'rbxassetid://105674638146134',
			dactyl 		= 'rbxassetid://117766458551209',
			dactly 		= 'rbxassetid://129648496875500',
			yasmin 		= 'rbxassetid://118529940228508',
			buzz 			= 'rbxassetid://110376914891194',
			orange 		= 'rbxassetid://126646817879498',
			green 		= 'rbxassetid://87669188123341',
			tyson 		= 'rbxassetid://97645417107107',
			brown 		= 'rbxassetid://79001940651774',
			gray 		= 'rbxassetid://122553361296431',
			lean 		= 'rbxassetid://121031826122627',
			tom 		= 'rbxassetid://97759726490042',

			--WRONG PICS
			otheryasmin = 'rbxassetid://118529940228508', --THIS ONE
			flea = 'rbxassetid://121031826122627',
			frog = 'rbxassetid://87669188123341',
			rot = 'rbxassetid://126646817879498'
		},

--icons = {  power   	= "rbxassetid://83579736894626",  stamina 	= "rbxassetid://125102150570348",  resistence 	= "rbxassetid://132341633059670",  agility		= "rbxassetid://82547807114138",  perception  = "rbxassetid://88003637275820", },
		icons = {
			legs  = 'rbxassetid://124182945119895',
			chest = 'rbxassetid://83938646505700',
			back  = 'rbxassetid://72862289902600',
			arms   = 'rbxassetid://138490131049082',
			stamina = 'rbxassetid://129940409951049'
		};
 		emotions = {
			hot = "rbxassetid://101391553268882" , nerd = "rbxassetid://104092539988712" , clown = "rbxassetid://105641461381530" ,
			angry = "rbxassetid://112817210918330" ,weary = "rbxassetid://140690952950971" ,mewing = "rbxassetid://107362657346008" ,
			anxious = "rbxassetid://140247511166919" ,neutral = "rbxassetid://132438099056240" ,melting = "rbxassetid://127543556819239" ,
			yawning  = "rbxassetid://129057392327019" , grinning = "rbxassetid://110823159505611" , vomiting = "rbxassetid://113380573880851" ,
			savoring = "rbxassetid://88702903539375"  ,exhaling = "rbxassetid://90861737031988"  ,drooling = "rbxassetid://77332358103655"  ,
			pleading = "rbxassetid://126557040781498" , nauseated = "rbxassetid://119571791304607" , screaming = "rbxassetid://86970197353612"  ,
			astonished 		= "rbxassetid://93067148051175", expressionless 	= "rbxassetid://84978248153602",
		},
		auras = {
			dbzyellow = "rbxassetid://135858864362044",
			dbzorange = "rbxassetid://130717209769455",
			dbzpurple = "",
			dbzred = "rbxassetid://140614601601469",
			dbzlightgreen = "rbxassetid://122827001527454",
			dbzlightblue = "rbxassetid://125972920663997",
		}
	},
	
	-- ===----=====---->= animations <=----====----===
	animations = {
		gym = {
			staminaWithoutPet = 95007774015177,
			stamina = 125237330872604 ,--122422911617093, -- treadmill
			back    = 85930718791547 ,-- pushup
			chest   = 95650062928551, -- bench
			legs 	  = 76416572263780 , -- leg lift
			arms    = 114408369352630,--109108022501449, -- squat
		},
		boss = { init = 85930718791547, lost = 136700641505530, win  = 93747463993003  },
		bossfights = {
			pink = 112473303563847,
			green = 125544415384905,
			bavely = 75207337320689,
			guesty = 81618635018107
		}
	},
	PetAnimations= {
		dactly 	= {idle = 138639237389424,run = 103208851986605,jump = 110904156705939,walk = 112272777854914,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704},
		dactyl	= {idle = 138639237389424,run = 103208851986605,jump = 110904156705939,walk = 112272777854914,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704},

		yasmin 	= {idle = 114093724242276,run = 107626756113379,walk = 123139762193969,jump = 95069270794170,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},
		otheryasmin ={idle = 114093724242276,run = 107626756113379,walk = 123139762193969,jump = 95069270794170,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},
		green	= {idle = 114093724242276,run = 107626756113379,walk = 123139762193969,jump = 95069270794170,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},

		tyson 	= {idle = 117214572128035,jump = 124262662505003,run  = 120908687701937,walk = 79949884207157 
			,back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},
		buzz 	= { run = 94861108669966  , jump = 74061899146678,walk = 77994700478850,idle=72078396392540, 
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057
		},

		orange	= {idle = 113945091990715,run  = 97770854724921,walk = 115236626710504,jump = 77410032998877,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704 },
		rot ={idle = 113945091990715,run  = 97770854724921,walk = 115236626710504,jump = 77410032998877 ,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704},
		greenraptor = {idle = 113945091990715,run  = 97770854724921,walk = 115236626710504,jump = 77410032998877 ,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704},
		flea ={idle = 113945091990715,run  = 97770854724921,walk = 115236626710504,jump = 77410032998877 ,
			back=105520236291147,legs = 117217159707356, arms=83636885842795,chest =95641882370840,stamina=104501706463704},

		tom   = {idle = 124885236656868, run = 135643977769029, walk = 113219168134899, jump = 138619139635009,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},
		brown = {idle = 124885236656868, run = 135643977769029, walk = 113219168134899, jump = 138619139635009,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},
		gray  = {idle = 124885236656868, run = 135643977769029, walk = 113219168134899, jump = 138619139635009,
			back = 121118864695964,chest = 109378723710955 ,stamina = 90851079039358,legs =112564747318755,arms=135312796501057},

		frog =   {idle = 138509667884524, run = 137501026174570, walk = 97694781919518, jump = 103705570909993,
			back=86850994928384,legs = 100841595145600, arms=83654643688133,chest =109100100434145  ,stamina=107203167026660},
		lean =   {idle = 138509667884524, run = 75880769200193, walk = 97694781919518, jump = 103705570909993,
			back=86850994928384,legs = 100841595145600, arms=83654643688133,chest =109100100434145  ,stamina=107203167026660},
		yellow = {idle = 138509667884524, run = 75880769200193, walk = 97694781919518, jump = 103705570909993,
			back=86850994928384,legs = 100841595145600, arms=83654643688133,chest =109100100434145  ,stamina=107203167026660},
		lightblue = {idle = 138509667884524, run = 75880769200193, walk = 97694781919518, jump = 103705570909993,
			back=86850994928384,legs = 100841595145600, arms=83654643688133,chest =109100100434145  ,stamina=107203167026660},
},
	claymaker = {
		animations = {
			blue  =78232307457186,-- 100024911548769,
			green =78232307457186,-- 120102342554081,
			pink = 78232307457186,
		}
	}
}



return module
