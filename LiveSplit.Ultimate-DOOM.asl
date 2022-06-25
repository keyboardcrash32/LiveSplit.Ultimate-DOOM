// ULTIMATE DOOM AUTOSPLITTER
// WADS TESTED:
// - Doom.wad
// - Doom2.wad
// - Plutonia.wad
// - TNT.wad
// - Variety of custom wads
//
// HOW TO USE: https://github.com/rogender/LiveSplit.Ultimate-DOOM/blob/main/README.md
// PLEASE REPORT THE PROBLEMS TO EITHER THE ISSUES SECTION IN THE GITHUB REPOSITORY ABOVE
//
// !! NOTE !! WORKING ONLY ON LATEST VERSION OF SOURCE PORTS

state("crispy-doom", "5.11.1")
{
    int map:                    "crispy-doom.exe", 0x1A01CC;
    int menuvalue:              "crispy-doom.exe", 0x1A1890;
    int playerHealth:           "crispy-doom.exe", 0xAA2D4;
    int levelTime:              "crispy-doom.exe", 0x10CB70;
    int chapter:                "crispy-doom.exe", 0x19F76C;
}

state("chocolate-doom", "3.0.1")
{
    int map:                    "chocolate-doom.exe", 0x1231E4;
    int menuvalue:              "chocolate-doom.exe", 0x11A31C;
    int playerHealth:           "chocolate-doom.exe", 0x5F394;
    int levelTime:              "chocolate-doom.exe", 0x1254F0;
    int chapter:                "chocolate-doom.exe", 0x1236F4;
}

state("glboom-plus", "2.5.1.4")
{
    int map:                    "glboom-plus.exe", 0x1A2FD4;
    int menuvalue:              "glboom-plus.exe", 0x215818;
    int playerHealth:           "glboom-plus.exe", 0x1B9180;
    int levelTime:              "glboom-plus.exe", 0x215020;
    int chapter:                "glboom-plus.exe", 0x1A2FD8;
}

state("prboom-plus", "2.6.2")
{
    int map:                    "prboom-plus.exe", 0x115988;
    int menuvalue:              "prboom-plus.exe", 0x18D310;
    int playerHealth:           "prboom-plus.exe", 0x19A66C;
    int levelTime:              "prboom-plus.exe", 0x192318;
    int chapter:                "prboom-plus.exe", 0x16CD38;
}

state("cndoom", "2.0.3.2")
{
    int map:                    "cndoom.exe", 0x1173C4;
    int menuvalue:              "cndoom.exe", 0x117BD8;
    int playerHealth:           "cndoom.exe", 0x63934;
    int levelTime:              "cndoom.exe", 0x129890;
    int chapter:                "cndoom.exe", 0x117A34;
}

startup
{
    vars.Log = (Action<object>)(output => print("[Ultimate-DOOM ASL] " + output));

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
    
    refreshRate = 30;

    vars.Log("ModuleMemorySize - 0x" + (modules.First().ModuleMemorySize).ToString("X"));

    switch(modules.First().ModuleMemorySize)
    {
        case 0x165000: version = "3.0.1";      break;
        case 0x391000: version = "5.11.1";     break;
        case 0x284000: version = "2.6.2";      break;
        case 0x254000: version = "2.5.1.4";    break;
        case 0x6C0000: version = "2.0.3.2";    break;

        default:       version = "UNDETECTED"; MessageBox.Show(timer.Form, "Ultimate-Doom autosplitter startup failure. \nI could not recognize what the version of the game you are running", "Ultimate-Doom startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error); break;
    }
}

start
{
    return current.map == 1 && current.menuvalue == 0 && current.playerHealth != 0 && settings["start"];
}

split
{
    return (current.chapter > old.chapter && settings["chaptersplit"] && settings["split"]) || ((current.map > old.map || current.chapter > old.chapter) && settings["split"] && !settings["chaptersplit"]);
}

reset
{
    return (current.map < old.map && settings["reset"]) || (current.playerHealth == 0 && settings["reset"]) || (current.map == 1 && current.levelTime < old.levelTime && settings["reset"]);
}

isLoading
{
    return current.levelTime == old.levelTime && settings["lr"];
}

update
{
    if(version.Contains("UNDETECTED"))
        return false;
}

shutdown
{
    timer.OnStart -= vars.TimerStart;
}

exit
{
    timer.OnStart -= vars.TimerStart;
}
