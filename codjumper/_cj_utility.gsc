/* ______      ____      __
  / ____/___  / __ \    / /_  ______ ___  ____  ___  _____ _________  ____ ___
 / /   / __ \/ / / /_  / / / / / __ `__ \/ __ \/ _ \/ ___// ___/ __ \/ __ `__ \
/ /___/ /_/ / /_/ / /_/ / /_/ / / / / / / /_/ /  __/ /  _/ /__/ /_/ / / / / / /
\____/\____/_____/\____/\__,_/_/ /_/ /_/ .___/\___/_/  (_)___/\____/_/ /_/ /_/
                                      /_/
   --------------------------------------------------
   - Thanks for taking an interest in OUR mod.      -
   - Feel free to borrow our code and claim it as   -
   - your own. It hasn't stopped you in the past.   -
   -               * CoDJumper Team *               -
   ------------------------------------------------*/

#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;

isEven(int)
{
	if(int % 2 == 0)
		return true;
	else
		return false;
}

monotone(str)
{
	if(!isdefined(str) || (str == ""))
		return ("");

	_s = "";

	_colorCheck = false;
	for (i=0;i<str.size;i++)
	{
		ch = str[i];
		if(_colorCheck)
		{
			_colorCheck = false;

			switch ( ch )
			{
			  case "0":	// black
			  case "1":	// red
			  case "2":	// green
			  case "3":	// yellow
			  case "4":	// blue
			  case "5":	// cyan
			  case "6":	// pink
			  case "7":	// white
			  case "8":
			  case "9":
			  	break;
			  default:
			  	_s += ("^" + ch);
			  	break;
			}
		}
		else if(ch == "^")
			_colorCheck = true;
		else
			_s += ch;
	}

	return (_s);
}

RemoveTurrets()
{
	deletePlacedEntity( "misc_turret" );
	deletePlacedEntity( "misc_mg42" );
}

setupAdvert()
{
	// TODO
/*
	if ( !isDefined( self.cj["hud"] ) || !isDefined( self.cj["hud"]["advert"] ) )
	{
		self.cj["hud"]["advert"] = newclienthudelem(self);
		self.cj["hud"]["advert"].alignX = "left";
		self.cj["hud"]["advert"].alignY = "bottom";
		self.cj["hud"]["advert"].horzalign = "left";
		self.cj["hud"]["advert"].vertAlign = "bottom";
		self.cj["hud"]["advert"].x = 3;
		self.cj["hud"]["advert"].y = -3;
		self.cj["hud"]["advert"].alpha = 0.8;
		self.cj["hud"]["advert"].sort = 0;
		self.cj["hud"]["advert"] setShader("sponsor",234,30);
	}

	if ( !isDefined( self.cj["hud"] ) || !isDefined( self.cj["hud"]["logo"] ) )
	{
		self.cj["hud"]["logo"] = newclienthudelem(self);
		self.cj["hud"]["logo"].alignX = "left";
		self.cj["hud"]["logo"].alignY = "bottom";
		self.cj["hud"]["logo"].horzalign = "left";
		self.cj["hud"]["logo"].vertAlign = "bottom";
		self.cj["hud"]["logo"].x = 3;
		self.cj["hud"]["logo"].y = -3;
		self.cj["hud"]["logo"].alpha = 0.8;
		self.cj["hud"]["logo"].sort = 0;
		self.cj["hud"]["logo"] setShader("cjbanner",100,30);
	}

	if ( (!isDefined(self.cj["hud"]) || !isDefined(self.cj["hud"]["custom"])) && level._customlogo == 1 )
	{
		self.cj["hud"]["custom"] = newclienthudelem(self);
		self.cj["hud"]["custom"].alignX = "right";
		self.cj["hud"]["custom"].alignY = "bottom";
		self.cj["hud"]["custom"].horzalign = "right";
		self.cj["hud"]["custom"].vertAlign = "bottom";
		self.cj["hud"]["custom"].x = -3;
		self.cj["hud"]["custom"].y = -3;
		self.cj["hud"]["custom"].alpha = level._customlogo_a;
		self.cj["hud"]["custom"].sort = 0;
		self.cj["hud"]["custom"] setShader("custom",level._customlogo_w,level._customlogo_h);
	}
*/
}

changeAdvert()
{
	// TODO
/*
	//self endon("joined_spectators");

	self setupAdvert();

	self.cj["hud"]["logo"].y = -3;
	self.cj["hud"]["advert"] setShader("sponsor",234,30);
	self.cj["hud"]["logo"].alpha = 0;
	wait 10;
	self.cj["hud"]["advert"] setShader("sponsored",100,10);
	self.cj["hud"]["logo"].alpha = 0.8;
	self.cj["hud"]["logo"].y = -14;
*/
}

setErr(err)
{
	setDvar("cj_errors", (getDvar("cj_errors") + "\n" + err));
}

setLog(str)
{
	logprint("|#CJ#|#" + str + "#|\n");
}

voteInProgress()
{
	return level.cjVoteInProgress;
}

disableVoting()
{
	self endon("disconnect");
	self iPrintln("You have been ^1locked^7 from voting!");

	for(i=level.cjvotelockout;i>0;i--)
	{
		self.cj["vote"]["novoting"] = i;
		wait 1;
	}

	self.cj["vote"]["novoting"] = 0;
}

startCountdown(time)
{
	self endon("disconnect");
	level endon ("votecancelled");
	level endon ("voteforce");
	self.votetime = time;

	for(i=time;i>0;i-=0.5)
	{
		if(i == int(i))
			self.votetime--;

		self setClientDvar("ui_cj_countdown", self.votetime);
		self thread updateVoteHud();
		if(i == int(i) && i<=5)
			self playLocalSound("ui_mp_suitcasebomb_timer");

		wait 0.5;
	}
}

playerCheck(arg)
{
	if((level.players[arg] getEntityNumber()) == (self.cj["vote"]["playerent"]))
		if(level.players[arg].cj["status"] < 1)
			return true;

	return false;
}

createVoteHud()
{
	if(isDefined(self.cj["hud"]["custom"]))
		self.cj["hud"]["custom"].alpha = 0;

	if(!isDefined(self.cj["hud"]["vote"]))
	{
		self.cj["hud"]["vote"] = createFontString( "objective", 1.4 );
		self.cj["hud"]["vote"].alignx = "left";
		self.cj["hud"]["vote"].aligny = "bottom";
		self.cj["hud"]["vote"].horzAlign = "right";
		self.cj["hud"]["vote"].vertAlign = "bottom";
		self.cj["hud"]["vote"].x = -190;
		self.cj["hud"]["vote"].y = -50;
		self.cj["hud"]["vote"].sort = -1;
		switch(level.cjvotetype)
		{
			case "Vote: Kick Player":
				self.cj["hud"]["vote"] setText(&"CJ_VOTE_PLAYER_KICK");
				break;
			case "Vote: Extend Time":
				self.cj["hud"]["vote"] setText(&"CJ_VOTE_MAP_EXTEND");
				break;
			case "Vote: Rotate Map":
				self.cj["hud"]["vote"] setText(&"CJ_VOTE_MAP_ROTATE");
				break;
			case "Vote: Change Map":
				self.cj["hud"]["vote"] setText(&"CJ_VOTE_MAP_CHANGE");
				break;
		}
	}

	if(!isDefined(self.cj["hud"]["voteyes"]))
	{
		self.cj["hud"]["voteyes"] = createFontString( "default", 1.4 );
		self.cj["hud"]["voteyes"].alignx = "left";
		self.cj["hud"]["voteyes"].aligny = "bottom";
		self.cj["hud"]["voteyes"].horzAlign = "right";
		self.cj["hud"]["voteyes"].vertAlign = "bottom";
		self.cj["hud"]["voteyes"].x = -190;
		self.cj["hud"]["voteyes"].y = -20;
		self.cj["hud"]["voteyes"].sort = -1;
		self.cj["hud"]["voteyes"].label = &"CJ_VOTE_YES";
	}
	if(!isDefined(self.cj["hud"]["voteno"]))
	{
		self.cj["hud"]["voteno"] = createFontString( "default", 1.4 );
		self.cj["hud"]["voteno"].alignx = "left";
		self.cj["hud"]["voteno"].aligny = "bottom";
		self.cj["hud"]["voteno"].horzAlign = "right";
		self.cj["hud"]["voteno"].vertAlign = "bottom";
		self.cj["hud"]["voteno"].x = -190;
		self.cj["hud"]["voteno"].y = -5;
		self.cj["hud"]["voteno"].sort = -1;
		self.cj["hud"]["voteno"].label = &"CJ_VOTE_NO";
	}
	if(!isDefined(self.cj["hud"]["voteyeskey"]))
	{
		self.cj["hud"]["voteyeskey"] = createFontString( "default", 1.4 );
		self.cj["hud"]["voteyeskey"].alignx = "left";
		self.cj["hud"]["voteyeskey"].aligny = "bottom";
		self.cj["hud"]["voteyeskey"].horzAlign = "right";
		self.cj["hud"]["voteyeskey"].vertAlign = "bottom";
		self.cj["hud"]["voteyeskey"].x = -150;
		self.cj["hud"]["voteyeskey"].y = -20;
		self.cj["hud"]["voteyeskey"].sort = -1;
		self.cj["hud"]["voteyeskey"].label = &"CJ_VOTE_YES_KEY";
		self.cj["hud"]["voteyeskey"] setValue(level.cjvoteyes);
	}
	if(!isDefined(self.cj["hud"]["votenokey"]))
	{
		self.cj["hud"]["votenokey"] = createFontString( "default", 1.4 );
		self.cj["hud"]["votenokey"].alignx = "left";
		self.cj["hud"]["votenokey"].aligny = "bottom";
		self.cj["hud"]["votenokey"].horzAlign = "right";
		self.cj["hud"]["votenokey"].vertAlign = "bottom";
		self.cj["hud"]["votenokey"].x = -150;
		self.cj["hud"]["votenokey"].y = -5;
		self.cj["hud"]["votenokey"].sort = -1;
		self.cj["hud"]["votenokey"].label = &"CJ_VOTE_NO_KEY";
		self.cj["hud"]["votenokey"] setValue(level.cjvoteno);
	}
	if(!isDefined(self.cj["hud"]["votearg"]))
	{
		self.cj["hud"]["votearg"] = createFontString( "default", 1.4 );
		self.cj["hud"]["votearg"].alignx = "left";
		self.cj["hud"]["votearg"].aligny = "bottom";
		self.cj["hud"]["votearg"].horzAlign = "right";
		self.cj["hud"]["votearg"].vertAlign = "bottom";
		self.cj["hud"]["votearg"].x = -190;
		self.cj["hud"]["votearg"].y = -35;
		self.cj["hud"]["votearg"].sort = -1;
		switch(level.cjvotetype)
		{
			case "Vote: Kick Player":
				self.cj["hud"]["votearg"] setPlayerNameString(level.players[level.cjvotearg]);
				break;
			case "Vote: Change Map":
				self.cj["hud"]["votearg"] setText(level.cjvotearg);
				break;
		}
	}
	if(!isDefined(self.cj["hud"]["votetime"]))
	{
		self.cj["hud"]["votetime"] = createFontString( "default", 1.4 );
		self.cj["hud"]["votetime"].alignx = "right";
		self.cj["hud"]["votetime"].aligny = "bottom";
		self.cj["hud"]["votetime"].horzAlign = "right";
		self.cj["hud"]["votetime"].vertAlign = "bottom";
		self.cj["hud"]["votetime"].x = -45;
		self.cj["hud"]["votetime"].y = -12;
		self.cj["hud"]["votetime"].sort = -1;
		self.cj["hud"]["votetime"].color = (0, 1, 0);
		self.cj["hud"]["votetime"].glowColor = (0, 1, 1);
		self.cj["hud"]["votetime"].glowAlpha = 0.8;
		self.cj["hud"]["votetime"] setValue(self.votetime);
	}
	if(!isDefined(self.cj["hud"]["votebg"]))
	{
		self.cj["hud"]["votebg"] = NewClientHudElem( self );
		self.cj["hud"]["votebg"].alignx = "right";
		self.cj["hud"]["votebg"].aligny = "bottom";
		self.cj["hud"]["votebg"].horzAlign = "right";
		self.cj["hud"]["votebg"].vertAlign = "bottom";
		self.cj["hud"]["votebg"].x = -18;
		self.cj["hud"]["votebg"].y = -1;
		self.cj["hud"]["votebg"].sort = -2;
		self.cj["hud"]["votetime"].color = (0.2, 0.2, 0.6);
		self.cj["hud"]["votebg"].alpha = 0.6;
		self.cj["hud"]["votebg"] setShader("white", 195, 70 );
	}
}

updateVoteHud()
{
	i = 1 / getDvarFloat("cj_voteduration");

	if(isDefined(self.cj["hud"]["voteyeskey"]))
		self.cj["hud"]["voteyeskey"] setValue(level.cjvoteyes);

	if(isDefined(self.cj["hud"]["votenokey"]))
		self.cj["hud"]["votenokey"] setValue(level.cjvoteno);

	if(self.cj["vote"]["voted"] == true)
	{
		self.cj["hud"]["votenokey"].color = (0.24, 0.62, 0.62);
		self.cj["hud"]["voteyeskey"].color = (0.24, 0.62, 0.62);
	}

	if(isDefined(self.cj["hud"]["votetime"]))
	{
		self.cj["hud"]["votetime"] setValue(self.votetime);
		green = i * self.votetime;
		red = 1 - (green);
		self.cj["hud"]["votetime"].color = (red, green, 0);
	}

}

removeVoteHud()
{
	if(isDefined(self.cj["hud"]["vote"]))
		self.cj["hud"]["vote"] destroy();

	if(isDefined(self.cj["hud"]["voteno"]))
		self.cj["hud"]["voteno"] destroy();

	if(isDefined(self.cj["hud"]["voteyes"]))
		self.cj["hud"]["voteyes"] destroy();

	if(isDefined(self.cj["hud"]["votenokey"]))
		self.cj["hud"]["votenokey"] destroy();

	if(isDefined(self.cj["hud"]["voteyeskey"]))
		self.cj["hud"]["voteyeskey"] destroy();

	if(isDefined(self.cj["hud"]["votetime"]))
		self.cj["hud"]["votetime"] destroy();

	if(isDefined(self.cj["hud"]["votearg"]))
		self.cj["hud"]["votearg"] destroy();

	if(isDefined(self.cj["hud"]["votebg"]))
		self.cj["hud"]["votebg"] destroy();

	if(isDefined(self.cj["hud"]["custom"]))
		self.cj["hud"]["custom"].alpha = level._customlogo_a;
}

maplist()
{
	rotation = getDvar("sv_maprotation");
	rotation = strTok(rotation, " ");

	level.maplist = [];

	for(i=0; i<rotation.size; i++)
		if(rotation[i] == "map")
			level.maplist[level.maplist.size] = rotation[i+1];
}

triggerWait()
{
	wait 10;
	self.cj["trigWait"] = 0;
}

wrongGametype()
{
	if(getDvar("g_gametype") != "cj")
	{
		wait 5;

		changeRotation();
		iPrintlnbold("^1*** ^5Incorrect Gametype Loaded ^1***");
		iPrintlnbold("^2*** ^5Loading CoDJumper Gametype ^2***");
		wait 1;
		iPrintlnbold("5..");
		wait 1;
		iPrintlnbold("4..");
		wait 1;
		iPrintlnbold("3..");
		wait 1;
		iPrintlnbold("2..");
		wait 1;
		iPrintlnbold("1..");
		setDvar("g_gametype", "cj");
		wait 0.5;
		exitLevel(false);
	}
}

changeRotation()
{
	rot = getDvar("sv_maprotation");
	new = "";

	for(i=0;i<rot.size;i++)
	{
		if(rot[i] != "d")
			new+=rot[i];
		else if((i+2) < rot.size)
		{
			if(rot[i+1] == "m" && rot[i+2] == " ")
			{
				new+="cj ";
				i+=2;
			}
			else
				new+=rot[i];
		}
	}
	setDvar("sv_maprotationcurrent", "");
	setDvar("sv_maprotation", new);
}

checkIfWep(wep)
{
	switch(wep)
	{
		case "ak47_mp":
		case "ak47_acog_mp":
		case "ak47_eotech_mp":
		case "ak47_fmj_mp":
		case "ak47_gl_mp":
		case "ak47_heartbeat_mp":
		case "ak47_reflex_mp":
		case "ak47_shotgun_mp":
		case "ak47_silencer_mp":
		case "ak47_thermal_mp":
		case "ak47_xmags_mp":
		case "ak47_acog_fmj_mp":
		case "ak47_acog_gl_mp":
		case "ak47_acog_heartbeat_mp":
		case "ak47_acog_shotgun_mp":
		case "ak47_acog_silencer_mp":
		case "ak47_acog_xmags_mp":
		case "ak47_eotech_fmj_mp":
		case "ak47_eotech_gl_mp":
		case "ak47_eotech_heartbeat_mp":
		case "ak47_eotech_shotgun_mp":
		case "ak47_eotech_silencer_mp":
		case "ak47_eotech_xmags_mp":
		case "ak47_fmj_gl_mp":
		case "ak47_fmj_heartbeat_mp":
		case "ak47_fmj_reflex_mp":
		case "ak47_fmj_shotgun_mp":
		case "ak47_fmj_silencer_mp":
		case "ak47_fmj_thermal_mp":
		case "ak47_fmj_xmags_mp":
		case "ak47_gl_heartbeat_mp":
		case "ak47_gl_reflex_mp":
		case "ak47_gl_silencer_mp":
		case "ak47_gl_thermal_mp":
		case "ak47_gl_xmags_mp":
		case "ak47_heartbeat_reflex_mp":
		case "ak47_heartbeat_shotgun_mp":
		case "ak47_heartbeat_silencer_mp":
		case "ak47_heartbeat_thermal_mp":
		case "ak47_heartbeat_xmags_mp":
		case "ak47_reflex_shotgun_mp":
		case "ak47_reflex_silencer_mp":
		case "ak47_reflex_xmags_mp":
		case "ak47_shotgun_silencer_mp":
		case "ak47_shotgun_thermal_mp":
		case "ak47_shotgun_xmags_mp":
		case "ak47_silencer_thermal_mp":
		case "ak47_silencer_xmags_mp":
		case "ak47_thermal_xmags_mp":
		case "m16_mp":
		case "m16_acog_mp":
		case "m16_eotech_mp":
		case "m16_fmj_mp":
		case "m16_gl_mp":
		case "m16_heartbeat_mp":
		case "m16_reflex_mp":
		case "m16_shotgun_mp":
		case "m16_silencer_mp":
		case "m16_thermal_mp":
		case "m16_xmags_mp":
		case "m16_acog_fmj_mp":
		case "m16_acog_gl_mp":
		case "m16_acog_heartbeat_mp":
		case "m16_acog_shotgun_mp":
		case "m16_acog_silencer_mp":
		case "m16_acog_xmags_mp":
		case "m16_eotech_fmj_mp":
		case "m16_eotech_gl_mp":
		case "m16_eotech_heartbeat_mp":
		case "m16_eotech_shotgun_mp":
		case "m16_eotech_silencer_mp":
		case "m16_eotech_xmags_mp":
		case "m16_fmj_gl_mp":
		case "m16_fmj_heartbeat_mp":
		case "m16_fmj_reflex_mp":
		case "m16_fmj_shotgun_mp":
		case "m16_fmj_silencer_mp":
		case "m4_mp":
		case "m4_acog_mp":
		case "m4_eotech_mp":
		case "m4_fmj_mp":
		case "m4_gl_mp":
		case "m4_heartbeat_mp":
		case "m4_reflex_mp":
		case "m4_shotgun_mp":
		case "m4_silencer_mp":
		case "m4_thermal_mp":
		case "m4_xmags_mp":
		case "m4_acog_fmj_mp":
		case "m4_acog_gl_mp":
		case "m4_acog_heartbeat_mp":
		case "m4_acog_shotgun_mp":
		case "m4_acog_silencer_mp":
		case "m4_acog_xmags_mp":
		case "m4_eotech_fmj_mp":
		case "m4_eotech_gl_mp":
		case "m4_eotech_heartbeat_mp":
		case "m4_eotech_shotgun_mp":
		case "m4_eotech_silencer_mp":
		case "m4_eotech_xmags_mp":
		case "m4_fmj_gl_mp":
		case "m4_fmj_heartbeat_mp":
		case "m4_fmj_reflex_mp":
		case "m4_fmj_shotgun_mp":
		case "m4_fmj_silencer_mp":
		case "m4_fmj_thermal_mp":
		case "m4_fmj_xmags_mp":
		case "m4_gl_heartbeat_mp":
		case "m4_gl_reflex_mp":
		case "m4_gl_silencer_mp":
		case "m4_gl_thermal_mp":
		case "m4_gl_xmags_mp":
		case "m4_heartbeat_reflex_mp":
		case "m4_heartbeat_shotgun_mp":
		case "m4_heartbeat_silencer_mp":
		case "m4_heartbeat_thermal_mp":
		case "m4_heartbeat_xmags_mp":
		case "m4_reflex_shotgun_mp":
		case "m4_reflex_silencer_mp":
		case "m4_reflex_xmags_mp":
		case "m4_shotgun_silencer_mp":
		case "m4_shotgun_thermal_mp":
		case "m4_shotgun_xmags_mp":
		case "m4_silencer_thermal_mp":
		case "m4_silencer_xmags_mp":
		case "m4_thermal_xmags_mp":
		case "fn2000_mp":
		case "fn2000_acog_mp":
		case "fn2000_eotech_mp":
		case "fn2000_fmj_mp":
		case "fn2000_gl_mp":
		case "fn2000_heartbeat_mp":
		case "fn2000_reflex_mp":
		case "fn2000_shotgun_mp":
		case "fn2000_silencer_mp":
		case "fn2000_thermal_mp":
		case "fn2000_xmags_mp":
		case "fn2000_acog_fmj_mp":
		case "fn2000_acog_gl_mp":
		case "fn2000_acog_heartbeat_mp":
		case "fn2000_acog_shotgun_mp":
		case "fn2000_acog_silencer_mp":
		case "fn2000_acog_xmags_mp":
		case "fn2000_eotech_fmj_mp":
		case "fn2000_eotech_gl_mp":
		case "fn2000_eotech_heartbeat_mp":
		case "fn2000_eotech_shotgun_mp":
		case "fn2000_eotech_silencer_mp":
		case "fn2000_eotech_xmags_mp":
		case "fn2000_fmj_gl_mp":
		case "fn2000_fmj_heartbeat_mp":
		case "fn2000_fmj_reflex_mp":
		case "fn2000_fmj_shotgun_mp":
		case "fn2000_fmj_silencer_mp":
		case "fn2000_fmj_thermal_mp":
		case "fn2000_fmj_xmags_mp":
		case "fn2000_gl_heartbeat_mp":
		case "fn2000_gl_reflex_mp":
		case "fn2000_gl_silencer_mp":
		case "fn2000_gl_thermal_mp":
		case "fn2000_gl_xmags_mp":
		case "fn2000_heartbeat_reflex_mp":
		case "fn2000_heartbeat_shotgun_mp":
		case "fn2000_heartbeat_silencer_mp":
		case "fn2000_heartbeat_thermal_mp":
		case "fn2000_heartbeat_xmags_mp":
		case "fn2000_reflex_shotgun_mp":
		case "fn2000_reflex_silencer_mp":
		case "fn2000_reflex_xmags_mp":
		case "fn2000_shotgun_silencer_mp":
		case "fn2000_shotgun_thermal_mp":
		case "fn2000_shotgun_xmags_mp":
		case "fn2000_silencer_thermal_mp":
		case "fn2000_silencer_xmags_mp":
		case "fn2000_thermal_xmags_mp":
		case "masada_mp":
		case "masada_acog_mp":
		case "masada_eotech_mp":
		case "masada_fmj_mp":
		case "masada_gl_mp":
		case "masada_heartbeat_mp":
		case "masada_reflex_mp":
		case "masada_shotgun_mp":
		case "masada_silencer_mp":
		case "masada_thermal_mp":
		case "masada_xmags_mp":
		case "masada_acog_fmj_mp":
		case "masada_acog_gl_mp":
		case "masada_acog_heartbeat_mp":
		case "masada_acog_shotgun_mp":
		case "masada_acog_silencer_mp":
		case "masada_acog_xmags_mp":
		case "masada_eotech_fmj_mp":
		case "masada_eotech_gl_mp":
		case "masada_eotech_heartbeat_mp":
		case "masada_eotech_shotgun_mp":
		case "masada_eotech_silencer_mp":
		case "masada_eotech_xmags_mp":
		case "masada_fmj_gl_mp":
		case "masada_fmj_heartbeat_mp":
		case "masada_fmj_reflex_mp":
		case "masada_fmj_shotgun_mp":
		case "masada_fmj_silencer_mp":
		case "masada_fmj_thermal_mp":
		case "masada_fmj_xmags_mp":
		case "masada_gl_heartbeat_mp":
		case "masada_gl_reflex_mp":
		case "masada_gl_silencer_mp":
		case "masada_gl_thermal_mp":
		case "masada_gl_xmags_mp":
		case "masada_heartbeat_reflex_mp":
		case "masada_heartbeat_shotgun_mp":
		case "masada_heartbeat_silencer_mp":
		case "masada_heartbeat_thermal_mp":
		case "masada_heartbeat_xmags_mp":
		case "masada_reflex_shotgun_mp":
		case "masada_reflex_silencer_mp":
		case "masada_reflex_xmags_mp":
		case "masada_shotgun_silencer_mp":
		case "masada_shotgun_thermal_mp":
		case "masada_shotgun_xmags_mp":
		case "masada_silencer_thermal_mp":
		case "masada_silencer_xmags_mp":
		case "masada_thermal_xmags_mp":
		case "famas_mp":
		case "famas_acog_mp":
		case "famas_eotech_mp":
		case "famas_fmj_mp":
		case "famas_gl_mp":
		case "famas_heartbeat_mp":
		case "famas_reflex_mp":
		case "famas_shotgun_mp":
		case "famas_silencer_mp":
		case "famas_thermal_mp":
		case "famas_xmags_mp":
		case "famas_acog_fmj_mp":
		case "famas_acog_gl_mp":
		case "famas_acog_heartbeat_mp":
		case "famas_acog_shotgun_mp":
		case "famas_acog_silencer_mp":
		case "famas_acog_xmags_mp":
		case "famas_eotech_fmj_mp":
		case "famas_eotech_gl_mp":
		case "famas_eotech_heartbeat_mp":
		case "famas_eotech_shotgun_mp":
		case "famas_eotech_silencer_mp":
		case "famas_eotech_xmags_mp":
		case "famas_fmj_gl_mp":
		case "famas_fmj_heartbeat_mp":
		case "famas_fmj_reflex_mp":
		case "famas_fmj_shotgun_mp":
		case "famas_fmj_silencer_mp":
		case "famas_fmj_thermal_mp":
		case "famas_fmj_xmags_mp":
		case "famas_gl_heartbeat_mp":
		case "famas_gl_reflex_mp":
		case "famas_gl_silencer_mp":
		case "famas_gl_thermal_mp":
		case "famas_gl_xmags_mp":
		case "famas_heartbeat_reflex_mp":
		case "famas_heartbeat_shotgun_mp":
		case "famas_heartbeat_silencer_mp":
		case "famas_heartbeat_thermal_mp":
		case "famas_heartbeat_xmags_mp":
		case "famas_reflex_shotgun_mp":
		case "famas_reflex_silencer_mp":
		case "famas_reflex_xmags_mp":
		case "famas_shotgun_silencer_mp":
		case "famas_shotgun_thermal_mp":
		case "famas_shotgun_xmags_mp":
		case "famas_silencer_thermal_mp":
		case "famas_silencer_xmags_mp":
		case "famas_thermal_xmags_mp":
		case "fal_mp":
		case "fal_acog_mp":
		case "fal_eotech_mp":
		case "fal_fmj_mp":
		case "fal_gl_mp":
		case "fal_heartbeat_mp":
		case "fal_reflex_mp":
		case "fal_shotgun_mp":
		case "fal_silencer_mp":
		case "fal_thermal_mp":
		case "fal_xmags_mp":
		case "fal_acog_fmj_mp":
		case "fal_acog_gl_mp":
		case "fal_acog_heartbeat_mp":
		case "fal_acog_shotgun_mp":
		case "fal_acog_silencer_mp":
		case "fal_acog_xmags_mp":
		case "fal_eotech_fmj_mp":
		case "fal_eotech_gl_mp":
		case "fal_eotech_heartbeat_mp":
		case "fal_eotech_shotgun_mp":
		case "fal_eotech_silencer_mp":
		case "fal_eotech_xmags_mp":
		case "fal_fmj_gl_mp":
		case "fal_fmj_heartbeat_mp":
		case "fal_fmj_reflex_mp":
		case "fal_fmj_shotgun_mp":
		case "fal_fmj_silencer_mp":
		case "fal_fmj_thermal_mp":
		case "fal_fmj_xmags_mp":
		case "fal_gl_heartbeat_mp":
		case "fal_gl_reflex_mp":
		case "fal_gl_silencer_mp":
		case "fal_gl_thermal_mp":
		case "fal_gl_xmags_mp":
		case "fal_heartbeat_reflex_mp":
		case "fal_heartbeat_shotgun_mp":
		case "fal_heartbeat_silencer_mp":
		case "fal_heartbeat_thermal_mp":
		case "fal_heartbeat_xmags_mp":
		case "fal_reflex_shotgun_mp":
		case "fal_reflex_silencer_mp":
		case "fal_reflex_xmags_mp":
		case "fal_shotgun_silencer_mp":
		case "fal_shotgun_thermal_mp":
		case "fal_shotgun_xmags_mp":
		case "fal_silencer_thermal_mp":
		case "fal_silencer_xmags_mp":
		case "fal_thermal_xmags_mp":
		case "scar_mp":
		case "scar_acog_mp":
		case "scar_eotech_mp":
		case "scar_fmj_mp":
		case "scar_gl_mp":
		case "scar_heartbeat_mp":
		case "scar_reflex_mp":
		case "scar_shotgun_mp":
		case "scar_silencer_mp":
		case "scar_thermal_mp":
		case "scar_xmags_mp":
		case "scar_acog_fmj_mp":
		case "scar_acog_gl_mp":
		case "scar_acog_heartbeat_mp":
		case "scar_acog_shotgun_mp":
		case "scar_acog_silencer_mp":
		case "scar_acog_xmags_mp":
		case "scar_eotech_fmj_mp":
		case "scar_eotech_gl_mp":
		case "scar_eotech_heartbeat_mp":
		case "scar_eotech_shotgun_mp":
		case "scar_eotech_silencer_mp":
		case "scar_eotech_xmags_mp":
		case "scar_fmj_gl_mp":
		case "scar_fmj_heartbeat_mp":
		case "scar_fmj_reflex_mp":
		case "scar_fmj_shotgun_mp":
		case "scar_fmj_silencer_mp":
		case "scar_fmj_thermal_mp":
		case "scar_fmj_xmags_mp":
		case "scar_gl_heartbeat_mp":
		case "scar_gl_reflex_mp":
		case "scar_gl_silencer_mp":
		case "scar_gl_thermal_mp":
		case "scar_gl_xmags_mp":
		case "scar_heartbeat_reflex_mp":
		case "scar_heartbeat_shotgun_mp":
		case "scar_heartbeat_silencer_mp":
		case "scar_heartbeat_thermal_mp":
		case "scar_heartbeat_xmags_mp":
		case "scar_reflex_shotgun_mp":
		case "scar_reflex_silencer_mp":
		case "scar_reflex_xmags_mp":
		case "scar_shotgun_silencer_mp":
		case "scar_shotgun_thermal_mp":
		case "scar_shotgun_xmags_mp":
		case "scar_silencer_thermal_mp":
		case "scar_silencer_xmags_mp":
		case "scar_thermal_xmags_mp":
		case "tavor_mp":
		case "tavor_acog_mp":
		case "tavor_eotech_mp":
		case "tavor_fmj_mp":
		case "tavor_gl_mp":
		case "tavor_heartbeat_mp":
		case "tavor_reflex_mp":
		case "tavor_shotgun_mp":
		case "tavor_silencer_mp":
		case "tavor_thermal_mp":
		case "tavor_xmags_mp":
		case "tavor_acog_fmj_mp":
		case "tavor_acog_gl_mp":
		case "tavor_acog_heartbeat_mp":
		case "tavor_acog_shotgun_mp":
		case "tavor_acog_silencer_mp":
		case "tavor_acog_xmags_mp":
		case "tavor_eotech_fmj_mp":
		case "tavor_eotech_gl_mp":
		case "tavor_eotech_heartbeat_mp":
		case "tavor_eotech_shotgun_mp":
		case "tavor_eotech_silencer_mp":
		case "tavor_eotech_xmags_mp":
		case "tavor_fmj_gl_mp":
		case "tavor_fmj_heartbeat_mp":
		case "tavor_fmj_reflex_mp":
		case "tavor_fmj_shotgun_mp":
		case "tavor_fmj_silencer_mp":
		case "tavor_fmj_thermal_mp":
		case "tavor_fmj_xmags_mp":
		case "tavor_gl_heartbeat_mp":
		case "tavor_gl_reflex_mp":
		case "tavor_gl_silencer_mp":
		case "tavor_gl_thermal_mp":
		case "tavor_gl_xmags_mp":
		case "tavor_heartbeat_reflex_mp":
		case "tavor_heartbeat_shotgun_mp":
		case "tavor_heartbeat_silencer_mp":
		case "tavor_heartbeat_thermal_mp":
		case "tavor_heartbeat_xmags_mp":
		case "tavor_reflex_shotgun_mp":
		case "tavor_reflex_silencer_mp":
		case "tavor_reflex_xmags_mp":
		case "tavor_shotgun_silencer_mp":
		case "tavor_shotgun_thermal_mp":
		case "tavor_shotgun_xmags_mp":
		case "tavor_silencer_thermal_mp":
		case "tavor_silencer_xmags_mp":
		case "tavor_thermal_xmags_mp":
		case "mp5k_mp":
		case "mp5k_acog_mp":
		case "mp5k_akimbo_mp":
		case "mp5k_eotech_mp":
		case "mp5k_fmj_mp":
		case "mp5k_reflex_mp":
		case "mp5k_rof_mp":
		case "mp5k_silencer_mp":
		case "mp5k_thermal_mp":
		case "mp5k_xmags_mp":
		case "mp5k_acog_fmj_mp":
		case "mp5k_acog_rof_mp":
		case "mp5k_acog_silencer_mp":
		case "mp5k_acog_xmags_mp":
		case "mp5k_akimbo_fmj_mp":
		case "mp5k_akimbo_rof_mp":
		case "mp5k_akimbo_silencer_mp":
		case "mp5k_akimbo_xmags_mp":
		case "mp5k_eotech_fmj_mp":
		case "mp5k_eotech_rof_mp":
		case "mp5k_eotech_silencer_mp":
		case "mp5k_eotech_xmags_mp":
		case "mp5k_fmj_reflex_mp":
		case "mp5k_fmj_rof_mp":
		case "mp5k_fmj_silencer_mp":
		case "mp5k_fmj_thermal_mp":
		case "mp5k_fmj_xmags_mp":
		case "mp5k_reflex_rof_mp":
		case "mp5k_reflex_silencer_mp":
		case "mp5k_reflex_xmags_mp":
		case "mp5k_rof_silencer_mp":
		case "mp5k_rof_thermal_mp":
		case "mp5k_rof_xmags_mp":
		case "mp5k_silencer_thermal_mp":
		case "mp5k_silencer_xmags_mp":
		case "mp5k_thermal_xmags_mp":
		case "uzi_mp":
		case "uzi_acog_mp":
		case "uzi_akimbo_mp":
		case "uzi_eotech_mp":
		case "uzi_fmj_mp":
		case "uzi_reflex_mp":
		case "uzi_rof_mp":
		case "uzi_silencer_mp":
		case "uzi_thermal_mp":
		case "uzi_xmags_mp":
		case "uzi_acog_fmj_mp":
		case "uzi_acog_rof_mp":
		case "uzi_acog_silencer_mp":
		case "uzi_acog_xmags_mp":
		case "uzi_akimbo_fmj_mp":
		case "uzi_akimbo_rof_mp":
		case "uzi_akimbo_silencer_mp":
		case "uzi_akimbo_xmags_mp":
		case "uzi_eotech_fmj_mp":
		case "uzi_eotech_rof_mp":
		case "uzi_eotech_silencer_mp":
		case "uzi_eotech_xmags_mp":
		case "uzi_fmj_reflex_mp":
		case "uzi_fmj_rof_mp":
		case "uzi_fmj_silencer_mp":
		case "uzi_fmj_thermal_mp":
		case "uzi_fmj_xmags_mp":
		case "uzi_reflex_rof_mp":
		case "uzi_reflex_silencer_mp":
		case "uzi_reflex_xmags_mp":
		case "uzi_rof_silencer_mp":
		case "uzi_rof_thermal_mp":
		case "uzi_rof_xmags_mp":
		case "uzi_silencer_thermal_mp":
		case "uzi_silencer_xmags_mp":
		case "uzi_thermal_xmags_mp":
		case "p90_mp":
		case "p90_acog_mp":
		case "p90_akimbo_mp":
		case "p90_eotech_mp":
		case "p90_fmj_mp":
		case "p90_reflex_mp":
		case "p90_rof_mp":
		case "p90_silencer_mp":
		case "p90_thermal_mp":
		case "p90_xmags_mp":
		case "p90_acog_fmj_mp":
		case "p90_acog_rof_mp":
		case "p90_acog_silencer_mp":
		case "p90_acog_xmags_mp":
		case "p90_akimbo_fmj_mp":
		case "p90_akimbo_rof_mp":
		case "p90_akimbo_silencer_mp":
		case "p90_akimbo_xmags_mp":
		case "p90_eotech_fmj_mp":
		case "p90_eotech_rof_mp":
		case "p90_eotech_silencer_mp":
		case "p90_eotech_xmags_mp":
		case "p90_fmj_reflex_mp":
		case "p90_fmj_rof_mp":
		case "p90_fmj_silencer_mp":
		case "p90_fmj_thermal_mp":
		case "p90_fmj_xmags_mp":
		case "p90_reflex_rof_mp":
		case "p90_reflex_silencer_mp":
		case "p90_reflex_xmags_mp":
		case "p90_rof_silencer_mp":
		case "p90_rof_thermal_mp":
		case "p90_rof_xmags_mp":
		case "p90_silencer_thermal_mp":
		case "p90_silencer_xmags_mp":
		case "p90_thermal_xmags_mp":
		case "kriss_mp":
		case "kriss_acog_mp":
		case "kriss_akimbo_mp":
		case "kriss_eotech_mp":
		case "kriss_fmj_mp":
		case "kriss_reflex_mp":
		case "kriss_rof_mp":
		case "kriss_silencer_mp":
		case "kriss_thermal_mp":
		case "kriss_xmags_mp":
		case "kriss_acog_fmj_mp":
		case "kriss_acog_rof_mp":
		case "kriss_acog_silencer_mp":
		case "kriss_acog_xmags_mp":
		case "kriss_akimbo_fmj_mp":
		case "kriss_akimbo_rof_mp":
		case "kriss_akimbo_silencer_mp":
		case "kriss_akimbo_xmags_mp":
		case "kriss_eotech_fmj_mp":
		case "kriss_eotech_rof_mp":
		case "kriss_eotech_silencer_mp":
		case "kriss_eotech_xmags_mp":
		case "kriss_fmj_reflex_mp":
		case "kriss_fmj_rof_mp":
		case "kriss_fmj_silencer_mp":
		case "kriss_fmj_thermal_mp":
		case "kriss_fmj_xmags_mp":
		case "kriss_reflex_rof_mp":
		case "kriss_reflex_silencer_mp":
		case "kriss_reflex_xmags_mp":
		case "kriss_rof_silencer_mp":
		case "kriss_rof_thermal_mp":
		case "kriss_rof_xmags_mp":
		case "kriss_silencer_thermal_mp":
		case "kriss_silencer_xmags_mp":
		case "kriss_thermal_xmags_mp":
		case "ump45_mp":
		case "ump45_acog_mp":
		case "ump45_akimbo_mp":
		case "ump45_eotech_mp":
		case "ump45_fmj_mp":
		case "ump45_reflex_mp":
		case "ump45_rof_mp":
		case "ump45_silencer_mp":
		case "ump45_thermal_mp":
		case "ump45_xmags_mp":
		case "ump45_acog_fmj_mp":
		case "ump45_acog_rof_mp":
		case "ump45_acog_silencer_mp":
		case "ump45_acog_xmags_mp":
		case "ump45_akimbo_fmj_mp":
		case "ump45_akimbo_rof_mp":
		case "ump45_akimbo_silencer_mp":
		case "ump45_akimbo_xmags_mp":
		case "ump45_eotech_fmj_mp":
		case "ump45_eotech_rof_mp":
		case "ump45_eotech_silencer_mp":
		case "ump45_eotech_xmags_mp":
		case "ump45_fmj_reflex_mp":
		case "ump45_fmj_rof_mp":
		case "ump45_fmj_silencer_mp":
		case "ump45_fmj_thermal_mp":
		case "ump45_fmj_xmags_mp":
		case "ump45_reflex_rof_mp":
		case "ump45_reflex_silencer_mp":
		case "ump45_reflex_xmags_mp":
		case "ump45_rof_silencer_mp":
		case "ump45_rof_thermal_mp":
		case "ump45_rof_xmags_mp":
		case "ump45_silencer_thermal_mp":
		case "ump45_silencer_xmags_mp":
		case "ump45_thermal_xmags_mp":
		case "rpd_mp":
		case "rpd_acog_mp":
		case "rpd_eotech_mp":
		case "rpd_fmj_mp":
		case "rpd_grip_mp":
		case "rpd_heartbeat_mp":
		case "rpd_reflex_mp":
		case "rpd_silencer_mp":
		case "rpd_thermal_mp":
		case "rpd_xmags_mp":
		case "rpd_acog_fmj_mp":
		case "rpd_acog_grip_mp":
		case "rpd_acog_heartbeat_mp":
		case "rpd_acog_silencer_mp":
		case "rpd_acog_xmags_mp":
		case "rpd_eotech_fmj_mp":
		case "rpd_eotech_grip_mp":
		case "rpd_eotech_heartbeat_mp":
		case "rpd_eotech_silencer_mp":
		case "rpd_eotech_xmags_mp":
		case "rpd_fmj_grip_mp":
		case "rpd_fmj_heartbeat_mp":
		case "rpd_fmj_reflex_mp":
		case "rpd_fmj_silencer_mp":
		case "rpd_fmj_thermal_mp":
		case "rpd_fmj_xmags_mp":
		case "rpd_grip_heartbeat_mp":
		case "rpd_grip_reflex_mp":
		case "rpd_grip_silencer_mp":
		case "rpd_grip_thermal_mp":
		case "rpd_grip_xmags_mp":
		case "rpd_heartbeat_reflex_mp":
		case "rpd_heartbeat_silencer_mp":
		case "rpd_heartbeat_thermal_mp":
		case "rpd_heartbeat_xmags_mp":
		case "rpd_reflex_silencer_mp":
		case "rpd_reflex_xmags_mp":
		case "rpd_silencer_thermal_mp":
		case "rpd_silencer_xmags_mp":
		case "rpd_thermal_xmags_mp":
		case "sa80_mp":
		case "sa80_acog_mp":
		case "sa80_eotech_mp":
		case "sa80_fmj_mp":
		case "sa80_grip_mp":
		case "sa80_heartbeat_mp":
		case "sa80_reflex_mp":
		case "sa80_silencer_mp":
		case "sa80_thermal_mp":
		case "sa80_xmags_mp":
		case "sa80_acog_fmj_mp":
		case "sa80_acog_grip_mp":
		case "sa80_acog_heartbeat_mp":
		case "sa80_acog_silencer_mp":
		case "sa80_acog_xmags_mp":
		case "sa80_eotech_fmj_mp":
		case "sa80_eotech_grip_mp":
		case "sa80_eotech_heartbeat_mp":
		case "sa80_eotech_silencer_mp":
		case "sa80_eotech_xmags_mp":
		case "sa80_fmj_grip_mp":
		case "sa80_fmj_heartbeat_mp":
		case "sa80_fmj_reflex_mp":
		case "sa80_fmj_silencer_mp":
		case "sa80_fmj_thermal_mp":
		case "sa80_fmj_xmags_mp":
		case "sa80_grip_heartbeat_mp":
		case "sa80_grip_reflex_mp":
		case "sa80_grip_silencer_mp":
		case "sa80_grip_thermal_mp":
		case "sa80_grip_xmags_mp":
		case "sa80_heartbeat_reflex_mp":
		case "sa80_heartbeat_silencer_mp":
		case "sa80_heartbeat_thermal_mp":
		case "sa80_heartbeat_xmags_mp":
		case "sa80_reflex_silencer_mp":
		case "sa80_reflex_xmags_mp":
		case "sa80_silencer_thermal_mp":
		case "sa80_silencer_xmags_mp":
		case "sa80_thermal_xmags_mp":
		case "mg4_mp":
		case "mg4_acog_mp":
		case "mg4_eotech_mp":
		case "mg4_fmj_mp":
		case "mg4_grip_mp":
		case "mg4_heartbeat_mp":
		case "mg4_reflex_mp":
		case "mg4_silencer_mp":
		case "mg4_thermal_mp":
		case "mg4_xmags_mp":
		case "mg4_acog_fmj_mp":
		case "mg4_acog_grip_mp":
		case "mg4_acog_heartbeat_mp":
		case "mg4_acog_silencer_mp":
		case "mg4_acog_xmags_mp":
		case "mg4_eotech_fmj_mp":
		case "mg4_eotech_grip_mp":
		case "mg4_eotech_heartbeat_mp":
		case "mg4_eotech_silencer_mp":
		case "mg4_eotech_xmags_mp":
		case "mg4_fmj_grip_mp":
		case "mg4_fmj_heartbeat_mp":
		case "mg4_fmj_reflex_mp":
		case "mg4_fmj_silencer_mp":
		case "mg4_fmj_thermal_mp":
		case "mg4_fmj_xmags_mp":
		case "mg4_grip_heartbeat_mp":
		case "mg4_grip_reflex_mp":
		case "mg4_grip_silencer_mp":
		case "mg4_grip_thermal_mp":
		case "mg4_grip_xmags_mp":
		case "mg4_heartbeat_reflex_mp":
		case "mg4_heartbeat_silencer_mp":
		case "mg4_heartbeat_thermal_mp":
		case "mg4_heartbeat_xmags_mp":
		case "mg4_reflex_silencer_mp":
		case "mg4_reflex_xmags_mp":
		case "mg4_silencer_thermal_mp":
		case "mg4_silencer_xmags_mp":
		case "mg4_thermal_xmags_mp":
		case "m240_mp":
		case "m240_acog_mp":
		case "m240_eotech_mp":
		case "m240_fmj_mp":
		case "m240_grip_mp":
		case "m240_heartbeat_mp":
		case "m240_reflex_mp":
		case "m240_silencer_mp":
		case "m240_thermal_mp":
		case "m240_xmags_mp":
		case "m240_acog_fmj_mp":
		case "m240_acog_grip_mp":
		case "m240_acog_heartbeat_mp":
		case "m240_acog_silencer_mp":
		case "m240_acog_xmags_mp":
		case "m240_eotech_fmj_mp":
		case "m240_eotech_grip_mp":
		case "m240_eotech_heartbeat_mp":
		case "m240_eotech_silencer_mp":
		case "m240_eotech_xmags_mp":
		case "m240_fmj_grip_mp":
		case "m240_fmj_heartbeat_mp":
		case "m240_fmj_reflex_mp":
		case "m240_fmj_silencer_mp":
		case "m240_fmj_thermal_mp":
		case "m240_fmj_xmags_mp":
		case "m240_grip_heartbeat_mp":
		case "m240_grip_reflex_mp":
		case "m240_grip_silencer_mp":
		case "m240_grip_thermal_mp":
		case "m240_grip_xmags_mp":
		case "m240_heartbeat_reflex_mp":
		case "m240_heartbeat_silencer_mp":
		case "m240_heartbeat_thermal_mp":
		case "m240_heartbeat_xmags_mp":
		case "m240_reflex_silencer_mp":
		case "m240_reflex_xmags_mp":
		case "m240_silencer_thermal_mp":
		case "m240_silencer_xmags_mp":
		case "m240_thermal_xmags_mp":
		case "aug_mp":
		case "aug_acog_mp":
		case "aug_eotech_mp":
		case "aug_fmj_mp":
		case "aug_grip_mp":
		case "aug_heartbeat_mp":
		case "aug_reflex_mp":
		case "aug_silencer_mp":
		case "aug_thermal_mp":
		case "aug_xmags_mp":
		case "aug_acog_fmj_mp":
		case "aug_acog_grip_mp":
		case "aug_acog_heartbeat_mp":
		case "aug_acog_silencer_mp":
		case "aug_acog_xmags_mp":
		case "aug_eotech_fmj_mp":
		case "aug_eotech_grip_mp":
		case "aug_eotech_heartbeat_mp":
		case "aug_eotech_silencer_mp":
		case "aug_eotech_xmags_mp":
		case "aug_fmj_grip_mp":
		case "aug_fmj_heartbeat_mp":
		case "aug_fmj_reflex_mp":
		case "aug_fmj_silencer_mp":
		case "aug_fmj_thermal_mp":
		case "aug_fmj_xmags_mp":
		case "aug_grip_heartbeat_mp":
		case "aug_grip_reflex_mp":
		case "aug_grip_silencer_mp":
		case "aug_grip_thermal_mp":
		case "aug_grip_xmags_mp":
		case "aug_heartbeat_reflex_mp":
		case "aug_heartbeat_silencer_mp":
		case "aug_heartbeat_thermal_mp":
		case "aug_heartbeat_xmags_mp":
		case "aug_reflex_silencer_mp":
		case "aug_reflex_xmags_mp":
		case "aug_silencer_thermal_mp":
		case "aug_silencer_xmags_mp":
		case "aug_thermal_xmags_mp":
		case "barrett_mp":
		case "barrett_acog_mp":
		case "barrett_fmj_mp":
		case "barrett_heartbeat_mp":
		case "barrett_silencer_mp":
		case "barrett_thermal_mp":
		case "barrett_xmags_mp":
		case "barrett_acog_fmj_mp":
		case "barrett_acog_heartbeat_mp":
		case "barrett_acog_silencer_mp":
		case "barrett_acog_xmags_mp":
		case "barrett_fmj_heartbeat_mp":
		case "barrett_fmj_silencer_mp":
		case "barrett_fmj_thermal_mp":
		case "barrett_fmj_xmags_mp":
		case "barrett_heartbeat_silencer_mp":
		case "barrett_heartbeat_thermal_mp":
		case "barrett_heartbeat_xmags_mp":
		case "barrett_silencer_thermal_mp":
		case "barrett_silencer_xmags_mp":
		case "barrett_thermal_xmags_mp":
		case "wa2000_mp":
		case "wa2000_acog_mp":
		case "wa2000_fmj_mp":
		case "wa2000_heartbeat_mp":
		case "wa2000_silencer_mp":
		case "wa2000_thermal_mp":
		case "wa2000_xmags_mp":
		case "wa2000_acog_fmj_mp":
		case "wa2000_acog_heartbeat_mp":
		case "wa2000_acog_silencer_mp":
		case "wa2000_acog_xmags_mp":
		case "wa2000_fmj_heartbeat_mp":
		case "wa2000_fmj_silencer_mp":
		case "wa2000_fmj_thermal_mp":
		case "wa2000_fmj_xmags_mp":
		case "wa2000_heartbeat_silencer_mp":
		case "wa2000_heartbeat_thermal_mp":
		case "wa2000_heartbeat_xmags_mp":
		case "wa2000_silencer_thermal_mp":
		case "wa2000_silencer_xmags_mp":
		case "wa2000_thermal_xmags_mp":
		case "m21_mp":
		case "m21_acog_mp":
		case "m21_fmj_mp":
		case "m21_heartbeat_mp":
		case "m21_silencer_mp":
		case "m21_thermal_mp":
		case "m21_xmags_mp":
		case "m21_acog_fmj_mp":
		case "m21_acog_heartbeat_mp":
		case "m21_acog_silencer_mp":
		case "m21_acog_xmags_mp":
		case "m21_fmj_heartbeat_mp":
		case "m21_fmj_silencer_mp":
		case "m21_fmj_thermal_mp":
		case "m21_fmj_xmags_mp":
		case "m21_heartbeat_silencer_mp":
		case "m21_heartbeat_thermal_mp":
		case "m21_heartbeat_xmags_mp":
		case "m21_silencer_thermal_mp":
		case "m21_silencer_xmags_mp":
		case "m21_thermal_xmags_mp":
		case "cheytac_mp":
		case "cheytac_acog_mp":
		case "cheytac_fmj_mp":
		case "cheytac_heartbeat_mp":
		case "cheytac_silencer_mp":
		case "cheytac_thermal_mp":
		case "cheytac_xmags_mp":
		case "cheytac_acog_fmj_mp":
		case "cheytac_acog_heartbeat_mp":
		case "cheytac_acog_silencer_mp":
		case "cheytac_acog_xmags_mp":
		case "cheytac_fmj_heartbeat_mp":
		case "cheytac_fmj_silencer_mp":
		case "cheytac_fmj_thermal_mp":
		case "cheytac_fmj_xmags_mp":
		case "cheytac_heartbeat_silencer_mp":
		case "cheytac_heartbeat_thermal_mp":
		case "cheytac_heartbeat_xmags_mp":
		case "cheytac_silencer_thermal_mp":
		case "cheytac_silencer_xmags_mp":
		case "cheytac_thermal_xmags_mp":
		case "riotshield_mp":
		case "beretta_mp":
		case "beretta_akimbo_mp":
		case "beretta_fmj_mp":
		case "beretta_silencer_mp":
		case "beretta_tactical_mp":
		case "beretta_xmags_mp":
		case "beretta_akimbo_fmj_mp":
		case "beretta_akimbo_silencer_mp":
		case "beretta_akimbo_xmags_mp":
		case "beretta_fmj_silencer_mp":
		case "beretta_fmj_tactical_mp":
		case "beretta_fmj_xmags_mp":
		case "beretta_silencer_tactical_mp":
		case "beretta_silencer_xmags_mp":
		case "beretta_tactical_xmags_mp":
		case "usp_mp":
		case "usp_akimbo_mp":
		case "usp_fmj_mp":
		case "usp_silencer_mp":
		case "usp_tactical_mp":
		case "usp_xmags_mp":
		case "usp_akimbo_fmj_mp":
		case "usp_akimbo_silencer_mp":
		case "usp_akimbo_xmags_mp":
		case "usp_fmj_silencer_mp":
		case "usp_fmj_tactical_mp":
		case "usp_fmj_xmags_mp":
		case "usp_silencer_tactical_mp":
		case "usp_silencer_xmags_mp":
		case "usp_tactical_xmags_mp":
		case "deserteagle_mp":
		case "deserteagle_akimbo_mp":
		case "deserteagle_fmj_mp":
		case "deserteagle_tactical_mp":
		case "deserteagle_akimbo_fmj_mp":
		case "deserteagle_fmj_tactical_mp":
		case "coltanaconda_mp":
		case "coltanaconda_akimbo_mp":
		case "coltanaconda_fmj_mp":
		case "coltanaconda_tactical_mp":
		case "coltanaconda_akimbo_fmj_mp":
		case "coltanaconda_fmj_tactical_mp":
		case "tmp_mp":
		case "tmp_akimbo_mp":
		case "tmp_eotech_mp":
		case "tmp_fmj_mp":
		case "tmp_reflex_mp":
		case "tmp_silencer_mp":
		case "tmp_xmags_mp":
		case "tmp_akimbo_fmj_mp":
		case "tmp_akimbo_silencer_mp":
		case "tmp_akimbo_xmags_mp":
		case "tmp_eotech_fmj_mp":
		case "tmp_eotech_silencer_mp":
		case "tmp_eotech_xmags_mp":
		case "tmp_fmj_reflex_mp":
		case "tmp_fmj_silencer_mp":
		case "tmp_fmj_xmags_mp":
		case "tmp_reflex_silencer_mp":
		case "tmp_reflex_xmags_mp":
		case "tmp_silencer_xmags_mp":
		case "glock_mp":
		case "glock_akimbo_mp":
		case "glock_eotech_mp":
		case "glock_fmj_mp":
		case "glock_reflex_mp":
		case "glock_silencer_mp":
		case "glock_xmags_mp":
		case "glock_akimbo_fmj_mp":
		case "glock_akimbo_silencer_mp":
		case "glock_akimbo_xmags_mp":
		case "glock_eotech_fmj_mp":
		case "glock_eotech_silencer_mp":
		case "glock_eotech_xmags_mp":
		case "glock_fmj_reflex_mp":
		case "glock_fmj_silencer_mp":
		case "glock_fmj_xmags_mp":
		case "glock_reflex_silencer_mp":
		case "glock_reflex_xmags_mp":
		case "glock_silencer_xmags_mp":
		case "beretta393_mp":
		case "beretta393_akimbo_mp":
		case "beretta393_eotech_mp":
		case "beretta393_fmj_mp":
		case "beretta393_reflex_mp":
		case "beretta393_silencer_mp":
		case "beretta393_xmags_mp":
		case "beretta393_akimbo_fmj_mp":
		case "beretta393_akimbo_silencer_mp":
		case "beretta393_akimbo_xmags_mp":
		case "beretta393_eotech_fmj_mp":
		case "beretta393_eotech_silencer_mp":
		case "beretta393_eotech_xmags_mp":
		case "beretta393_fmj_reflex_mp":
		case "beretta393_fmj_silencer_mp":
		case "beretta393_fmj_xmags_mp":
		case "beretta393_reflex_silencer_mp":
		case "beretta393_reflex_xmags_mp":
		case "beretta393_silencer_xmags_mp":
		case "pp2000_mp":
		case "pp2000_akimbo_mp":
		case "pp2000_eotech_mp":
		case "pp2000_fmj_mp":
		case "pp2000_reflex_mp":
		case "pp2000_silencer_mp":
		case "pp2000_xmags_mp":
		case "pp2000_akimbo_fmj_mp":
		case "pp2000_akimbo_silencer_mp":
		case "pp2000_akimbo_xmags_mp":
		case "pp2000_eotech_fmj_mp":
		case "pp2000_eotech_silencer_mp":
		case "pp2000_eotech_xmags_mp":
		case "pp2000_fmj_reflex_mp":
		case "pp2000_fmj_silencer_mp":
		case "pp2000_fmj_xmags_mp":
		case "pp2000_reflex_silencer_mp":
		case "pp2000_reflex_xmags_mp":
		case "pp2000_silencer_xmags_mp":
		case "ranger_mp":
		case "ranger_akimbo_mp":
		case "ranger_fmj_mp":
		case "ranger_akimbo_fmj_mp":
		case "model1887_mp":
		case "model1887_akimbo_mp":
		case "model1887_fmj_mp":
		case "model1887_akimbo_fmj_mp":
		case "striker_mp":
		case "striker_eotech_mp":
		case "striker_fmj_mp":
		case "striker_grip_mp":
		case "striker_reflex_mp":
		case "striker_silencer_mp":
		case "striker_xmags_mp":
		case "striker_eotech_fmj_mp":
		case "striker_eotech_grip_mp":
		case "striker_eotech_silencer_mp":
		case "striker_eotech_xmags_mp":
		case "striker_fmj_grip_mp":
		case "striker_fmj_reflex_mp":
		case "striker_fmj_silencer_mp":
		case "striker_fmj_xmags_mp":
		case "striker_grip_reflex_mp":
		case "striker_grip_silencer_mp":
		case "striker_grip_xmags_mp":
		case "striker_reflex_silencer_mp":
		case "striker_reflex_xmags_mp":
		case "striker_silencer_xmags_mp":
		case "aa12_mp":
		case "aa12_eotech_mp":
		case "aa12_fmj_mp":
		case "aa12_grip_mp":
		case "aa12_reflex_mp":
		case "aa12_silencer_mp":
		case "aa12_xmags_mp":
		case "aa12_eotech_fmj_mp":
		case "aa12_eotech_grip_mp":
		case "aa12_eotech_silencer_mp":
		case "aa12_eotech_xmags_mp":
		case "aa12_fmj_grip_mp":
		case "aa12_fmj_reflex_mp":
		case "aa12_fmj_silencer_mp":
		case "aa12_fmj_xmags_mp":
		case "aa12_grip_reflex_mp":
		case "aa12_grip_silencer_mp":
		case "aa12_grip_xmags_mp":
		case "aa12_reflex_silencer_mp":
		case "aa12_reflex_xmags_mp":
		case "aa12_silencer_xmags_mp":
		case "m1014_mp":
		case "m1014_eotech_mp":
		case "m1014_fmj_mp":
		case "m1014_grip_mp":
		case "m1014_reflex_mp":
		case "m1014_silencer_mp":
		case "m1014_xmags_mp":
		case "m1014_eotech_fmj_mp":
		case "m1014_eotech_grip_mp":
		case "m1014_eotech_silencer_mp":
		case "m1014_eotech_xmags_mp":
		case "m1014_fmj_grip_mp":
		case "m1014_fmj_reflex_mp":
		case "m1014_fmj_silencer_mp":
		case "m1014_fmj_xmags_mp":
		case "m1014_grip_reflex_mp":
		case "m1014_grip_silencer_mp":
		case "m1014_grip_xmags_mp":
		case "m1014_reflex_silencer_mp":
		case "m1014_reflex_xmags_mp":
		case "m1014_silencer_xmags_mp":
		case "spas12_mp":
		case "spas12_eotech_mp":
		case "spas12_fmj_mp":
		case "spas12_grip_mp":
		case "spas12_reflex_mp":
		case "spas12_silencer_mp":
		case "spas12_xmags_mp":
		case "spas12_eotech_fmj_mp":
		case "spas12_eotech_grip_mp":
		case "spas12_eotech_silencer_mp":
		case "spas12_eotech_xmags_mp":
		case "spas12_fmj_grip_mp":
		case "spas12_fmj_reflex_mp":
		case "spas12_fmj_silencer_mp":
		case "spas12_fmj_xmags_mp":
		case "spas12_grip_reflex_mp":
		case "spas12_grip_silencer_mp":
		case "spas12_grip_xmags_mp":
		case "spas12_reflex_silencer_mp":
		case "spas12_reflex_xmags_mp":
		case "spas12_silencer_xmags_mp":

		case "ak47classic_mp":
		case "ak47classic_acog_fmj_mp":
		case "ak47classic_acog_mp":
		case "ak47classic_acog_silencer_mp":
		case "ak47classic_acog_xmags_mp":
		case "ak47classic_fmj_gl_mp":
		case "ak47classic_fmj_mp":
		case "ak47classic_fmj_reflex_mp":
		case "ak47classic_fmj_silencer_mp":
		case "ak47classic_fmj_xmags_mp":
		case "ak47classic_gl_mp":
		case "ak47classic_gl_reflex_mp":
		case "ak47classic_gl_silencer_mp":
		case "ak47classic_gl_xmags_mp":
		case "ak47classic_reflex_mp":
		case "ak47classic_reflex_silencer_mp":
		case "ak47classic_reflex_xmags_mp":
		case "ak47classic_silencer_mp":
		case "ak47classic_silencer_xmags_mp":
		case "ak47classic_xmags_mp":
		case "gl_ak47classic_mp":
		case "dragunov_mp":
		case "ak74u_mp":
		case "ak74u_acog_mp":
		case "ak74u_xmags_mp":
		case "ak74u_acog_xmags_mp":
		case "peacekeeper_mp":
		case "m40a3_mp":
		case "deserteaglegold_mp":
		case "deserteaglegold_akimbo_fmj_mp":
		case "deserteaglegold_akimbo_mp":
		case "deserteaglegold_fmj_mp":
		case "deserteaglegold_fmj_tactical_mp":
		case "deserteaglegold_tactical_mp":
		case "winchester1200":

			return true;
		default:
			return false;
	}
}