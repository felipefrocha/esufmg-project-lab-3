function sysCall_init()
    simRemoteApi.start(19999)
end

function displayText_function(inInts,inFloats,inStrings,inBuffer)
    -- Simply display a dialog box that prints the text stored in inStrings[1]:
    if #inStrings>=1 then
        sim.displayDialog('Message from the remote API client',inStrings[1],sim.dlgstyle_ok,false)
        return {},{},{'message was displayed'},'' -- return a string
    end
end

function createDummy_function(inInts,inFloats,inStrings,inBuffer)
    -- Create a dummy object with specific name and coordinates
    if #inStrings>=1 and #inFloats>=3 then
        local dummyHandle=sim.createDummy(0.05)
        local position={inInts[2],inInts[3],inInts[4]}
        sim.setObjectName(dummyHandle+sim.handleflag_silenterror,inStrings[1])
        sim.setObjectPosition(dummyHandle,-1,inFloats)
        return {dummyHandle},{},{},'' -- return the handle of the created dummy
    end
end

function createDummy_function(inInts,inFloats,inStrings,inBuffer)
    -- Create a dummy object with specific name and coordinates
    if #inStrings>=1 and #inFloats>=3 then
        dummyHandle=sim.createDummy(0.05)
        local parent_handle=-1
        if #inInts>0 then
            parent_handle=inInts[1]
        end
        result = sim.setObjectName(dummyHandle+sim.handleflag_silenterror,inStrings[1])
        if result == -1 then
          sim.displayDialog('Setting object name failed',inStrings[1],sim.dlgstyle_ok,false)
        end
        if parent_handle>=0 then
            sim.setObjectParent(dummyHandle,parent_handle)
        end
        sim.setObjectPosition(dummyHandle,parent_handle,inFloats)
        if #inFloats>=7 then
            local orientation={unpack(inFloats, 4, 7)} -- get 4 quaternion entries from 4 to 7
            sim.setObjectQuaternion(dummyHandle,parent_handle,orientation)
        end
        return {dummyHandle},{},{},'' -- return the handle of the created dummy
    end
end

function executeCode_function(inInts,inFloats,inStrings,inBuffer)
    -- Execute the code stored in inStrings[1]:
    if #inStrings>=1 then
        return {},{},{loadstring(inStrings[1])()},'' -- return a string that contains the return value of the code execution
    end
end

function createPointCloud_function(inInts,inFloats,inStrings,inBuffer)
    -- Create a point cloud
    if #inInts>=3 and #inStrings>=1 and #inFloats>=3 then

        -- The parent handle is the first integer parameter
        local parent_handle=inInts[1]

        -- Find an existing cloud with the specified name or create a new one
        cloudHandle=sim.getObjectHandle(inStrings[1]..'@silentError')

        if cloudHandle ~= -1 then
            sim.removeObject(cloudHandle)
        end
        -- create a new cloud if none exists
        cloudHandle=sim.createPointCloud(0.01, 10, 0, 10)

        -- Update the name of the cloud
        result = sim.setObjectName(cloudHandle+sim.handleflag_silenterror,inStrings[1])
        if result == -1 then
            sim.displayDialog('Setting object name failed',inStrings[1],sim.dlgstyle_ok,false)
        end
        --- Set the position of the cloud relative to teh parent handle
        __setObjectPosition__(cloudHandle,parent_handle,inFloats)

        poseEntries=inInts[2]
        if #inFloats>=7 then
            local orientation={unpack(inFloats, 4, 7)} -- get 4 quaternion entries from 4 to 7
            sim.setObjectQuaternion(cloudHandle,parent_handle,orientation)
        end
        -- sim.addLog(sim.verbosity_scriptinfos,'pose vec quat:'.. {unpack(inFloats, 4, 7)})
        -- local cloud = sim.unpackFloatTable(inStrings[2])
        cloudFloatCount=inInts[3]
        sim.auxiliaryConsolePrint('cloudFloatCount: '..cloudFloatCount)
        pointBatchSize=30
        colorBatch=nil
        -- bit 1 is 1 so point clouds in cloud reference frame
        options = 1
        if #inStrings > 2 then
          -- bit 2 is 1 so each point is colored
          options = 3
          colors = sim.unpackUInt8Table(inStrings[3])
        end
        -- Insert the point cloud points
        for i = 1, cloudFloatCount, pointBatchSize do
            startEntry=1+poseEntries+i
            local pointBatch={unpack(inFloats, startEntry, startEntry+pointBatchSize)}
            sim.auxiliaryConsolePrint('threePoints:')

            sim.auxiliaryConsolePrint(pointBatch[1])
            sim.auxiliaryConsolePrint(pointBatch[2])
            sim.auxiliaryConsolePrint(pointBatch[3])
            if #inStrings > 2 then
                colorBatch = {unpack(colors, startEntry, startEntry+pointBatchSize)}
            end

           sim.insertPointsIntoPointCloud(cloudHandle, options, pointBatch, colors)
        end
        return {cloudHandle},{},{},'' -- return the handle of the created dummy
    end
end

