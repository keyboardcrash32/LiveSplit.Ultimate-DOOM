// Ultimate DOOM autosplitter
// Working only on latest versions of source ports

state("crispy-doom")
{
    int map:                    "crispy-doom.exe", 0x19F11C;
    int menuvalue:              "crispy-doom.exe", 0x19E560;
    int playerHealth:           "crispy-doom.exe", 0x19EAAC;
    int levelTime:              "crispy-doom.exe", 0x10BB70;
    int chapter:                "crispy-doom.exe", 0x19E68C;
}

state("chocolate-doom")
{
    int map:                    "chocolate-doom.exe", 0x1231E4;
    int menuvalue:              "chocolate-doom.exe", 0x11A31C;
    int playerHealth:           "chocolate-doom.exe", 0x5F394;
    int levelTime:              "chocolate-doom.exe", 0x1254F0;
    int chapter:                "chocolate-doom.exe", 0x1236F4;
}

state("glboom-plus")
{
    int map:                    "glboom-plus.exe", 0x1A2FD4;
    int menuvalue:              "glboom-plus.exe", 0x215818;
    int playerHealth:           "glboom-plus.exe", 0x1B9180;
    int levelTime:              "glboom-plus.exe", 0x215020;
    int chapter:                "glboom-plus.exe", 0x1A2FD8;
}

state("prboom-plus")
{
    int map:                    "prboom-plus.exe", 0x16C7EC;
    int menuvalue:              "prboom-plus.exe", 0x175A70;
    int playerHealth:           "prboom-plus.exe", 0x16C814;
    int levelTime:              "prboom-plus.exe", 0x1DB164;
    int chapter:                "prboom-plus.exe", 0x16C7F0;
}

state("cndoom")
{
    int map:                    "cndoom.exe", 0x1173C4;
    int menuvalue:              "cndoom.exe", 0x117BD8;
    int playerHealth:           "cndoom.exe", 0x63934;
    int levelTime:              "cndoom.exe", 0x129890;
    int chapter:                "cndoom.exe", 0x117A34;
}

startup
{
    settings.Add("enablesplit", true, "Enable autosplitter");
    settings.Add("misc", false, "Misc.");
    settings.CurrentDefaultParent = "enablesplit";
    settings.Add("start", true, "Start");
    settings.Add("reset", true, "Reset");
    settings.Add("split", true, "Split");
    settings.Add("lr", true, "Load-Removal");
    settings.CurrentDefaultParent = "misc";
    settings.Add("chaptersplit", false, "Splitting chapters only");
}

init
{
    // var mms = modules.First().ModuleMemorySize;
    // print("0x" + mms.ToString("X"));

    if(modules.First().ModuleMemorySize == 0x165000)
        version = "3.0.1";
    else if(modules.First().ModuleMemorySize == 0x390000)
        version = "5.10.3";
    else if(modules.First().ModuleMemorySize == 0x284000 || modules.First().ModuleMemorySize == 0x24A000)
        version = "2.5.1.4";
    else if(modules.First().ModuleMemorySize == 0x6C0000)
        version = "2.0.3.2";
    else
    {
        version = "UNDETECTED";
        MessageBox.Show(timer.Form, "Ultimate-Doom autosplitter startup failure. I could not recognize what the version of the game you are running", "Ultimate-Doom startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }

    vars.timerRunning = 0;
	vars.splitsCurrent = 0;
	vars.splitsTemp = 0;
	vars.splitsTotal = 0;
}

start
{
    if(current.map == 1 && current.menuvalue == 0 && vars.timerRunning == 0 && current.playerHealth != 0 && settings["start"])
    {
        vars.timerRunning = 1;
        vars.splitsCurrent = 0;
		vars.splitsTemp = 0;
		vars.splitsTotal = 0;
        return true;
    }
}

split
{
    if(current.map > old.map && settings["split"] && !settings["chaptersplit"])
    {
        vars.splitsTemp = vars.splitsTotal;
        return true;
    }
    if(current.chapter > old.chapter && settings["chaptersplit"] && settings["split"])
    {
        vars.splitsTemp = vars.splitsTotal;
        return true;
    }
}

reset
{
    if(current.map < old.map && settings["reset"])
    {
        vars.timerRunning = 0;
        return true;
    }
    if(current.playerHealth == 0 && settings["reset"])
    {
        vars.timerRunning = 0;
        return true;
    }
    if(current.map == 1 && current.levelTime < old.levelTime && settings["reset"])
    {
        vars.timerRunning = 0;
        return true;
    }
}

isLoading
{
    if(current.levelTime == old.levelTime && settings["lr"])
    {
        return true;
    } else{
        return false;
    }
}

update
{
    if(version.Contains("UNDETECTED")){
        return false;
    }
}

shutdown
{
    timer.OnStart -= vars.TimerStart;
}

exit
{
    timer.OnStart -= vars.TimerStart;
}
