CHOICE_BUTTON( 0, "Movement", LOCAL_CLOSE_ALL open "pc_options_movement" )
CHOICE_BUTTON( 1, "Actions", LOCAL_CLOSE_ALL open "pc_options_actions" )
CHOICE_BUTTON( 2, "Look", LOCAL_CLOSE_ALL open "pc_options_look" )

CHOICE_SEPARATOR( 3 )

CHOICE_BUTTON_VIS( 3, "@MENU_MULTIPLAYER", LOCAL_CLOSE_ALL open "controls_multi", when( dvarInt( "ui_multiplayer" ) ) )
CHOICE_DBUTTON_VIS( 3, "@MENU_MULTIPLAYER", when( !dvarInt( ui_multiplayer ) ); )

CHOICE_SEPARATOR( 4 )

CHOICE_BUTTON( 4, "@MENU_SET_DEFAULT_CONTROLS", LOCAL_CLOSE_ALL open "options_control_defaults" )