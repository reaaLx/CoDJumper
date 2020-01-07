#include maps\mp\_utility;

init()
{
	if ( !isDefined( game["gamestarted"] ) )
	{
		game["menu_team"] = "team_marinesopfor";
		game["menu_class_allies"] = "class_marines";
		game["menu_changeclass_allies"] = "changeclass_marines";
		game["menu_initteam_allies"] = "initteam_marines";
		game["menu_class_axis"] = "class_opfor";
		game["menu_changeclass_axis"] = "changeclass_opfor";
		game["menu_initteam_axis"] = "initteam_opfor";
		game["menu_class"] = "class";
		game["menu_changeclass"] = "changeclass";
		game["menu_controls"] = "main_controls";
		game["menu_muteplayer"] = "muteplayer";
		game["menu_options"] = "main_options";
		game["menu_leavegame"] = "popup_leavegame";

		// load CodJumper Menus
		game["menu_cj_admin"] = "admin";
		game["menu_cj"] = "cj";

		game["menu_cj_vote"] = "cjvote";
		game["menu_cj_votemap"] = "cjvotemap";
		game["menu_cj_votemapchange"] = "cjvotemapchange";
		game["menu_cj_voteplayerkick"] = "cjvoteplayerkick";
		game["menu_cj_voteprogressing"] = "voteprogressing";

		game["menu_cj_graphics"] = "graphics";
		
		precacheMenu(game["menu_cj_admin"]);
		precacheMenu(game["menu_cj"]);

		precacheMenu(game["menu_cj_vote"]);
		precacheMenu(game["menu_cj_votemap"]);
		precacheMenu(game["menu_cj_votemapchange"]);
		precacheMenu(game["menu_cj_voteplayerkick"]);
		precacheMenu(game["menu_cj_voteprogressing"]);

		precacheMenu(game["menu_cj_graphics"]);
		// END LOADING 

		precacheMenu(game["menu_muteplayer"]);		
		precacheMenu(game["menu_controls"]);
		precacheMenu(game["menu_options"]);
		precacheMenu(game["menu_leavegame"]);

		precacheMenu("scoreboard");
		precacheMenu(game["menu_team"]);
		precacheMenu(game["menu_class_allies"]);
		precacheMenu(game["menu_changeclass_allies"]);
		precacheMenu(game["menu_initteam_allies"]);
		precacheMenu(game["menu_class_axis"]);
		precacheMenu(game["menu_changeclass_axis"]);
		precacheMenu(game["menu_class"]);
		precacheMenu(game["menu_changeclass"]);
		precacheMenu(game["menu_initteam_axis"]);
		
		precacheString( &"MP_HOST_ENDED_GAME" );
		precacheString( &"MP_HOST_ENDGAME_RESPONSE" );
	}
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player thread onMenuResponse();
	}
}


isOptionsMenu( menu )
{
	if ( menu == game["menu_changeclass"] )
		return true;
		
	if ( menu == game["menu_team"] )
		return true;

	if ( menu == game["menu_controls"] )
		return true;

	if ( isSubStr( menu, "pc_options" ) )
		return true;

	return false;
}


onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if ( response == "back" )
		{
			self closepopupMenu();
			self closeInGameMenu();

			if ( isOptionsMenu( menu ) )
			{
				if( self.pers["team"] == "allies" )
					self openpopupMenu( game["menu_class_allies"] );
				if( self.pers["team"] == "axis" )
					self openpopupMenu( game["menu_class_axis"] );
			}
			continue;
		}
		
		if(response == "changeteam")
		{
			self closepopupMenu();
			self closeInGameMenu();
			self openpopupMenu(game["menu_team"]);
		}
/*
		if(response == "changeclass_marines" )
		{
			self closepopupMenu();
			self closeInGameMenu();
			self openpopupMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closepopupMenu();
			self closeInGameMenu();
			self openpopupMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openpopupMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openpopupMenu( "changeclass_opfor_splitscreen" );
*/
		if(response == "endgame")
		{
			if(level.splitscreen)
			{
				endparty();

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_gamelogic::forceEnd();
				}
			}
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				level thread maps\mp\gametypes\_gamelogic::forceEnd();
			}
			else
			{
				self closepopupMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
				self [[level.allies]]();
				break;

			case "spectator":
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if ( menu == game["menu_changeclass"] ||
				( isDefined( game["menu_changeclass_defaults_splitscreen"] ) && menu == game["menu_changeclass_defaults_splitscreen"] ) ||
				( isDefined( game["menu_changeclass_custom_splitscreen"] ) && menu == game["menu_changeclass_custom_splitscreen"] ) )
		{
			self closepopupMenu();
			self closeInGameMenu();

			self.selectedClass = true;
			self [[level.class]](response);
		}

			// team_marinesopfor functions
			if(response == "player")
				self [[level.allies]]();
			else if(response == "spectate")
				self [[level.spectator]]();

		else if ( !level.console )
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
	}
}


getTeamAssignment()
{
	teams[0] = "allies";
	teams[1] = "axis";
	
	if ( !level.teamBased )
		return teams[randomInt(2)];

	if ( self.sessionteam != "none" && self.sessionteam != "spectator" && self.sessionstate != "playing" && self.sessionstate != "dead" )
	{
		assignment = self.sessionteam;
	}
	else
	{
		playerCounts = self maps\mp\gametypes\_teams::CountPlayers();
				
		// if teams are equal return the team with the lowest score
		if ( playerCounts["allies"] == playerCounts["axis"] )
		{
			if( getTeamScore( "allies" ) == getTeamScore( "axis" ) )
				assignment = teams[randomInt(2)];
			else if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
				assignment = "allies";
			else
				assignment = "axis";
		}
		else if( playerCounts["allies"] < playerCounts["axis"] )
		{
			assignment = "allies";
		}
		else
		{
			assignment = "axis";
		}
	}
	
	return assignment;
}


menuAutoAssign()
{
	self closeMenus();

	assignment = getTeamAssignment();
		
	if ( isDefined( self.pers["team"] ) && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		if ( assignment == self.pers["team"] )
		{
			self beginClassChoice();
			return;
		}
		else
		{
			self.switching_teams = true;
			self.joining_team = assignment;
			self.leaving_team = self.pers["team"];
			self suicide();
		}
	}

	self addToTeam( assignment );
	self.pers["class"] = undefined;
	self.class = undefined;
	
	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";
	
	self notify("end_respawn");
	
	self beginClassChoice();
}


beginClassChoice( forceNewChoice )
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];

	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	self openpopupMenu( game[ "menu_changeclass_" + team ] );
	
	if ( !isAlive( self ) )
		self thread maps\mp\gametypes\_playerlogic::predictAboutToSpawnPlayerOverTime( 0.1 );
}


beginTeamChoice()
{
	self openpopupMenu( game["menu_team"] );
}


showMainMenuForTeam()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];
	
	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.	
	self openpopupMenu( game[ "menu_class_" + team ] );
}

menuAllies()
{
	self closeMenus();
	
	if(self.pers["team"] != "allies")
	{
		if( level.teamBased && !maps\mp\gametypes\_teams::getJoinTeamPermissions( "allies" ) )
		{
			self openpopupMenu(game["menu_team"]);
			return;
		}
		
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && !self.hasDoneCombat )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self addToTeam( "allies" );
		self.pers["class"] = undefined;
		self.class = undefined;

		self notify("end_respawn");

		self.selectedClass = true;
		self [[level.class]]("specops_mp,0");
	}
	}


menuAxis()
{
	self closeMenus();
	
	if(self.pers["team"] != "axis")
	{
		if( level.teamBased && !maps\mp\gametypes\_teams::getJoinTeamPermissions( "axis" ) )
		{
			self openpopupMenu(game["menu_team"]);
			return;
		}

		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && !self.hasDoneCombat )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self addToTeam( "axis" );
		self.pers["class"] = undefined;
		self.class = undefined;

		self notify("end_respawn");

		self.selectedClass = true;
		self [[level.class]]("specops_mp,0");
	}
}


menuSpectator()
{
	self closeMenus();
	
	if( isDefined( self.pers["team"] ) && self.pers["team"] == "spectator" )
		return;

	if( isAlive( self ) )
	{
		assert( isDefined( self.pers["team"] ) );
		self.switching_teams = true;
		self.joining_team = "spectator";
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self addToTeam( "spectator" );
	self.pers["class"] = undefined;
	self.class = undefined;

	self thread maps\mp\gametypes\_playerlogic::spawnSpectator();
}


menuClass( response )
{
	self closeMenus();
	
	// clear new status of unlocked classes
	if ( response == "demolitions_mp,0" && self getPlayerData( "featureNew", "demolitions" ) )
	{
		self setPlayerData( "featureNew", "demolitions", false );
	}
	if ( response == "sniper_mp,0" && self getPlayerData( "featureNew", "sniper" ) )
	{
		self setPlayerData( "featureNew", "sniper", false );
	}

	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	class = self maps\mp\gametypes\_class::getClassChoice( response );
	primary = self maps\mp\gametypes\_class::getWeaponChoice( response );

	if ( class == "restricted" )
	{
		self beginClassChoice();
		return;
	}

	if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) && 
		(isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
		return;

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;

		if ( game["state"] == "postgame" )
			return;

		if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
		}
		else
		{
			self iPrintLnBold( game["strings"]["change_class"] );
		}
	}
	else
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;

		if ( game["state"] == "postgame" )
			return;

		if ( game["state"] == "playing" && !isInKillcam() )
			self thread maps\mp\gametypes\_playerlogic::spawnClient();
	}

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}



addToTeam( team, firstConnect )
{
	// UTS update playerCount remove from team
	if ( isDefined( self.team ) )
		self maps\mp\gametypes\_playerlogic::removeFromTeamCount();
		
	self.pers["team"] = team;
	// this is the only place self.team should ever be set
	self.team = team;
	
	// session team is readonly in ranked matches on console
	if ( !matchMakingGame() || isDefined( self.pers["isBot"] ) )
	{
		if ( level.teamBased )
		{
			self.sessionteam = team;
		}
		else
		{
			if ( team == "spectator" )
				self.sessionteam = "spectator";
			else
				self.sessionteam = "none";
		}
	}

	// UTS update playerCount add to team
	if ( game["state"] != "postgame" )
		self maps\mp\gametypes\_playerlogic::addToTeamCount();	

	self updateObjectiveText();

	// give "joined_team" and "joined_spectators" handlers a chance to start
	// these are generally triggered from the "connected" notify, which can happen on the same
	// frame as these notifies
	if ( isDefined( firstConnect ) && firstConnect )
		waittillframeend;

	self updateMainMenu();

	if ( team == "spectator" )
	{
		self notify( "joined_spectators" );
		level notify( "joined_team" );
	}
	else
	{
		self notify( "joined_team" );
		level notify( "joined_team" );
	}
}
