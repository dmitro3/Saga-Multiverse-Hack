PathController = {}
local self = PathController
_G["PathController"] = PathController

function PathController.Start( catId )
    self.saver = {}
    for i=1,self.living_room_pots.transform.childCount do
        self.saver["living_room_"..i] = nil
    end

    for i=1,self.porch_pots.transform.childCount do
        self.saver["porch_"..i] = nil
    end

    for i=1,self.kitchen_pots.transform.childCount do
        self.saver["kitchen_"..i] = nil
    end

    for i=0,self.ground_pots.transform.childCount - 1 do
        self["ground_"..(i+1)] = self.ground_pots.transform:GetChild(i).gameObject
    end
end

function PathController.FixedUpdate( catId )
    
end


function PathController.OnDestroy( catId )
   
end

--formal
function PathController.GetPot( ... )
    -- body
    local num = math.random(3)
    if(num == 1) then
        return self.GetLivingRoomPot()
    elseif(num == 2) then
        return self.GetPorchPot()
    elseif(num == 3) then
        return self.GetKitchenPot()
    end
end

function PathController.GetSickPot( ... )
    -- body
    return self.GetGroundPot()
end


--temporary
-- self.flag = false
-- function PathController.GetPot( ... )
--     return self.living_room_37
-- end

-- function PathController.GetSickPot( ... )
--     -- body
--     return self.living_room_37
-- end



function PathController.GetLivingRoomPot( ... )
    -- body
    local pot = nil
    local num = math.random(self.living_room_pots.transform.childCount)
    --Debug.LogError(num)
    while(self.saver["living_room_"..num] ~= nil) do
        num = math.random(self.living_room_pots.transform.childCount)
    end
    --Debug.LogError(self["living_room_"..num])
    pot = self["living_room_"..num]
    return pot
end

function PathController.GetPorchPot( ... )
    -- body
    local pot = nil
    local num = math.random(self.porch_pots.transform.childCount)
    --Debug.LogError(num)
    while(self.saver["porch_"..num] ~= nil) do
        num = math.random(self.porch_pots.transform.childCount)
    end
    --Debug.LogError(self["porch_"..num])
    pot = self["porch_"..num]
    return pot
end

function PathController.GetKitchenPot( ... )
    -- body
    local pot = nil
    local num = math.random(self.kitchen_pots.transform.childCount)
    --Debug.LogError(num)
    while(self.saver["kitchen_"..num] ~= nil) do
        num = math.random(self.kitchen_pots.transform.childCount)
    end
    --Debug.LogError(self["kitchen_"..num])
    pot = self["kitchen_"..num]
    return pot
end

function PathController.GetGroundPot( ... )
    -- body
    local pot = nil
    local num = math.random(self.ground_pots.transform.childCount)
    --Debug.LogError(num)
    local obj = self["ground_"..num]
    while(self.saver[obj.name] ~= nil) do
        num = math.random(self.ground_pots.transform.childCount)
        obj = self["ground_"..num]
    end
    --Debug.LogError(self["kitchen_"..num])
    pot = self["ground_"..num]
    return pot
end


function PathController.GetEatPot( num )
    -- body
    if(self.saver["eat_"..num] == nil) then
        return self["eat_"..num]
    end
    return nil
end

function PathController.GetDrinkPot( num )
    -- body
    if(self.saver["drink_"..num] == nil) then
        return self["drink_"..num]
    end
    return nil
end

function PathController.GetToiletPot( num )
    -- body
    if(self.saver["toilet_"..num] == nil) then
        return self["toilet_"..num]
    end
    return nil
end


--tagged data
function PathController.SaveData( potName, catId)
    -- body
    --Debug.LogError("tagged data:"..potName)
    self.saver[potName] = catId
    _G["Cats"][catId].catCtrl.potName = potName
end

--delete tag
function PathController.DelData( potName)
    -- body
    --Debug.LogError("delete tag:"..potName)
    self.saver[potName] = nil
end
