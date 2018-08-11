class AnticsRevPCAntics extends antics_v5.anticsCharacterController;

exec function Admin(string cmd)
{
    local string cmdCommand;
    local string cmdLower;

    cmdLower = Locs(cmd);
    cmdCommand = Left(cmdLower, InStr(cmdLower, " "));
    
    if (cmdCommand != "get" && cmdCommand != "set") {
        super.Admin(cmd);
    }
}

defaultProperties {
    
}
