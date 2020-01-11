//iw4 stock
CHOICE_BUTTON( 0, "@MENU_GRAPHICS", LOCAL_CLOSE_ALL open "options_graphics" )
CHOICE_BUTTON( 1, "@MENU_TEXTURE_SETTINGS", LOCAL_CLOSE_ALL open "options_graphics_texture" )
CHOICE_BUTTON( 2, "@MENU_AUDIO", LOCAL_CLOSE_ALL  open "pc_options_audio" )
CHOICE_BUTTON( 3, "@MENU_MULTIPLAYER", LOCAL_CLOSE_ALL open "options_multi" )

CHOICE_BUTTON_EX( 4, "@MENU_VOICE", LOCAL_CLOSE_ALL open "pc_options_voice", disabled when ( dvarstring( "gameMode" ) == "sp" || dvarstring( "gameMode" ) == "so" ) )

CHOICE_SEPARATOR( 5 )

CHOICE_BUTTON_EX( 5, "@MENU_RESET_SYSTEM_DEFAULTS", LOCAL_CLOSE_ALL open "options_graphics_defaults";, disabled when ( ( ( dvarstring( "gameMode" ) == "so" && ( dvarbool( "cl_ingame" ) || dvarbool( "sv_running" ) || inlobby() ) ) || ( dvarstring( "gameMode" ) == "mp" && ( dvarbool( "cl_ingame" ) || dvarbool( "sv_running" ) || inlobby() ) ) ) ) )
