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

savePos(i)
{
	if(i < 0 || i > 100)
		return; /* TODO: Insert msg for Max saves */

	if(level._cj_nosave)
	{
		self iPrintln(self.cj["local"]["NOSAVE"], getDvar("mapname"));
		return;
	}

	if(self codjumper\_cj_mappers::CheckSaveZones())
	{
		self iPrintln(self.cj["local"]["NOSAVEZONE"]);
		return;
	}

	wait 0.05;
	self.cj["save"]["org"+i] = self.origin;
	self.cj["save"]["ang"+i] = self getPlayerAngles();
	self iprintln(self.cj["local"]["SAVED"], i);
}

loadPos(i)
{
	if(i < 0 || i > 100)
		return;

	if(!isDefined(self.cj["save"]["org"+i]))
	{
		self iPrintln(self.cj["local"]["NOPOS"], i);
		return;
	}

	self freezecontrols(true);
	wait 0.05;

	if(!self isOnGround())
		wait 0.05;

	self setPlayerAngles(self.cj["save"]["ang"+i]);
	self setOrigin(self.cj["save"]["org"+i]);

	if(!self isOnGround())
		wait 0.05;

	wait 0.05;

	self iprintln(self.cj["local"]["POSLOAD"], i);
	self freezecontrols(false);
}