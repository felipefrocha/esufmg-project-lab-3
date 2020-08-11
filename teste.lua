function sysCall_threadmain()
    -- Get some handles first:
    local leftMotor=sim.getObjectHandle("remoteApiControlledBubbleRobLeftMotor") -- Handle of the left motor
    local rightMotor=sim.getObjectHandle("remoteApiControlledBubbleRobRightMotor") -- Handle of the right motor
    local noseSensor=sim.getObjectHandle("remoteApiControlledBubbleRobSensingNose") -- Handle of the proximity sensor

    -- Choose a port that is probably not used (try to always use a similar code):
    sim.setThreadAutomaticSwitch(false)
    local portNb=sim.getInt32Parameter(sim.intparam_server_port_next)
    print(string.format('Port is %d',portNb))
    local portStart=sim.getInt32Parameter(sim.intparam_server_port_start)
    local portRange=sim.getInt32Parameter(sim.intparam_server_port_range)
    local newPortNb=portNb+1
    if (newPortNb>=portStart+portRange) then
        newPortNb=portStart
    end
    sim.setInt32Parameter(sim.intparam_server_port_next,newPortNb)
    sim.setThreadAutomaticSwitch(true)

    -- Check what OS we are using:
    platf=sim.getInt32Parameter(sim.intparam_platform)
    if (platf==0) then
        pluginFile='simExtRemoteApi.dll'
    end
    if (platf==1) then
        pluginFile='libsimExtRemoteApi.dylib'
    end
    if (platf==2) then
        pluginFile='libsimExtRemoteApi.so'
    end

    -- Check if the required legacy remote Api plugin is there:
    moduleName=0
    moduleVersion=0
    index=0
    pluginNotFound=true
    while moduleName do
        moduleName,moduleVersion=sim.getModuleName(index)
        if (moduleName=='RemoteApi') then
            pluginNotFound=false
        end
        index=index+1
    end

    if (pluginNotFound) then
        -- Plugin was not found
        sim.displayDialog('Error',"Remote Api plugin was not found. ('"..pluginFile.."')&&nSimulation will not run properly",sim.dlgstyle_ok,true,nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
    else
        -- Ok, we found the plugin.
        -- We first start the remote Api server service (this requires the simExtRemoteApi plugin):
        simRemoteApi.start(portNb) -- this server function will automatically close again at simulation end

        -- Now we start the client application:
        result=sim.launchExecutable('bubbleRobClient_remoteApi',portNb.." "..leftMotor.." "..rightMotor.." "..noseSensor,0) -- set the last argument to 1 to see the console of the launched client

        if (result==-1) then
            -- The executable could not be launched!
            sim.displayDialog('Error',"'bubbleRobClient_remoteApi' could not be launched. &&nSimulation will not run properly",sim.dlgstyle_ok,true,nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
        end
    end

    -- This thread ends here. The bubbleRob will however still be controlled by
    -- the client application via the legacy remote Api mechanism!
end