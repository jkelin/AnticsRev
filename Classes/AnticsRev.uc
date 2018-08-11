class AnticsRev extends Gameplay.Mutator config(AnticsRev);
 
var config bool RemoveColorCodes;
var config string SelfServerPackage;
var config string AnticsServerPackage;

event PostBeginPlay()
{
    log("[AnticsRev]: Init");
    SetTimer(2, True);
    LoadCharacterController(); 
}

function LoadCharacterController()
{
	local Gameplay.ModeInfo MI;
    local string newClassName;
	
	foreach AllActors(class'Gameplay.ModeInfo', MI)
	{
		if (MI != None)
		{
            if (MI.PlayerControllerClassName == "antics_v5.anticsCharacterController") {
                Log("[AnticsRev]: Antics detected!");
                newClassName = SelfServerPackage $ ".AnticsRevPCAntics";
            } else if (MI.PlayerControllerClassName == "Gameplay.PlayerCharacterController") {
                newClassName = SelfServerPackage $ ".AnticsRevPC";
            } else {
                Log("[AnticsRev]: Unknown PC class" @ MI.PlayerControllerClassName);
                continue;
            }

			Log("[AnticsRev]: Replacing PC class" @ MI.PlayerControllerClassName @ "with" @ newClassName);
			MI.PlayerControllerClassName = newClassName;
			break;
		}
	}
}

function string RenameEmptyToNewBbood(string s) {
    if (s == "" || s == " " || s == "  " || s == "\\" || s == "\"") {
        return "NewBlood";
    }

    return s;
}

function string ReplaceColorCodes(string s) {
    local int firstC, firstBracket;
    local string substrAfterC;

    firstC = InStr(s, "[c=");
    while (firstC != -1) {
        substrAfterC = Right(s, Len(s) - firstC);
        firstBracket = InStr(substrAfterC, "]");
        substrAfterC = Right(substrAfterC, Len(substrAfterC) - firstBracket - 1);

        s = Left(s, firstBracket - 2) $ substrAfterC;

        firstC = InStr(s, "[c=");
    }

    s = Repl(s, "[b]", "", false);
    s = Repl(s, "[i]", "", false);
    s = Repl(s, "[u]", "", false);
    s = Repl(s, "[s]", "", false);
    
    return s;
}

function string ReplaceIllegalStrings(string s) {
    s = Repl(s, "\\", "", false);
    s = Repl(s, "\"", "", false);

    return s;
}

function RenamePlayers() {
    local int i;
    local TribesReplicationInfo TRI;
    local string originalName, newName;
 
    for (i = 0; i < Level.GRI.PRIArray.Length; ++i)
    {
        TRI = TribesReplicationInfo(Level.GRI.PRIArray[i]);
        originalName = TRI.PlayerName;
        newName = originalName;

        if (RemoveColorCodes) {
            newName = ReplaceColorCodes(newName);
        }

        newName = RenameEmptyToNewBbood(ReplaceIllegalStrings(newName));
        
        if (originalName != newName)
        {
            log("[AnticsRev]: Renamed" @ originalName @ "to" @ newName);
            TRI.PlayerName = newName;
        }
    }
}
 
function Timer()
{
    RenamePlayers();
}

simulated function Mutate(string Command, PlayerController Sender)
{
    local TribesReplicationInfo TRI;
}
 
defaultproperties
{
    RemoveColorCodes = true
    SelfServerPackage = "AnticsRev";
    AnticsServerPackage = "antics_v5";
}
