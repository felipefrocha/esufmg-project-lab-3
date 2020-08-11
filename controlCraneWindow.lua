local function isempty(s)
  return s == nil or s == ''
end
function sysCall_init()

    arm=sim.getObjectHandle('armActuator')
    if isempty(arm)then
        print('deuruin')
        return
    end
    
    crab=sim.getObjectHandle('CrabMove')
    if isempty(crab)then
        print('deuruin')
        return
    end
    
    hoist=sim.getObjectHandle('UpperMass')
    if isempty(hoist) then
        print('deuruin')
        return
    end
    
    suction=sim.getObjectHandle('suctionPad')
    if isempty(arm)then
        print('deuruin')
        return
    end
    xml = [[
<ui title="Speed Control" closeable="true" on-close="closeEventHandler" resizable="false" activate="false">
    <group layout="form" flat="true">
        <label text="Arm Speed (rad/s):0.00 " id="1"/>
        <hslider tick-position="above" tick-interval="1" minimum="-10" maximum="10" on-change="armActuatorSpeedChange" id="2"/>
        <label text="Crab Speed (m/s): 0.0" id="3"/>
        <hslider tick-position="above" tick-interval="1" minimum="-10" maximum="10" on-change="crabActuratorSpeedChange" id="4"/>
        <label text="Hoist Speed (m/s): 0.0" id="5"/>
        <hslider tick-position="above" tick-interval="1" minimum="-10" maximum="10" on-change="hoistActuatorSpeedChange" id="6"/>
        <label text="Magnet" id="7"/>
        <button text="Active Magnet" on-click="actuateMagnet" checkable="true" id="8"/>
    </group>
    <label text="" style="* {margin-left: 400px;}"/>
</ui>
]]
    ui=simUI.create(xml)
end
-- See the user manual or the available code snippets for additional callback functions and details
function armActuatorSpeedChange(ui,id,  newVal)
    local value = newVal*0.2
    print(string.format('Arm speed: %.2f(rad/s)',value))
    simUI.setLabelText(ui, 1,string.format('Arm speed: %.2f(rad/s)',value))
    sim.setJointTargetVelocity(arm,value)
end

function crabActuratorSpeedChange(ui,id,  newVal)
    local value = newVal*0.1
    print(string.format('Crab speed: %.2f(rad/s)',value))
    simUI.setLabelText(ui,3,string.format('Crab speed: %.2f(rad/s)',value))
    sim.setJointTargetVelocity(crab,value)
end


function hoistActuatorSpeedChange(ui,id,  newVal)
    local value = newVal*0.1
    print(string.format('Hoist speed: %.2f(m/s)',value))
    simUI.setLabelText(ui, 5,string.format('Hoist speed: %.2f(rad/s)',value))
    sim.setJointTargetVelocity(hoist,value)
end

function actuateMagnet(ui,id,  newVal)
    local state = sim.getUserParameter(suction, 'active')
    if state then
        sim.setUserParameter(suction,'active','false')
        simUI.setButtonText(ui,8,'deactivated')
    else
        sim.setUserParameter(suction,'active','true')
        simUI.setButtonText(ui,8,'activated')
    end
end
function closeEventHandler(h)
    sim.removeScript(sim.handle_self)
    simUI.destroy(h)
end

