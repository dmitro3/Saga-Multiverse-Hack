require "main/ctrl/Cat"
require "main/ctrl/PathController"
MainStart = {}
local self = MainStart

--[[
    content：
    1.provides scenario common property data
    3.scene object create、delete、change、control
    4.the catClass create、delete
]]--

function MainStart.Start( ... )
    -- body
    self.InitPublicData()
    --self.CreateCatsPNG()
    self.InitCatList()
end

function MainStart.Update( ... )
    -- body

end

function MainStart.OnDestroy( ... )
    -- body

end



function MainStart.InitPublicData( ... )
    -- body
    self.isEating = false
    self.isDrinking = false
    self.isDefecating = false
end

function MainStart.InitCatList( ... )
    -- body
    GetUserCatList(function ( data )
        for i=1,#playerData.catList do
            local CatModule = playerData.catList[i]
            self.CreateCat(CatModule)
        end
    end)
end

function MainStart.UpdateCatList( ... )
    -- body
    Debug.LogError("UpdateCatList")
    for i=1,#playerData.catList do
        local CatModule = playerData.catList[i]
        self.CreateCat(CatModule)
    end
end


function MainStart.CreateCat( CatModule )
    -- body
    if(_G["Cats"][CatModule.catId] == nil) then
        _G["Cats"][CatModule.catId] = Cat:New()
        _G["Cats"][CatModule.catId]:Init(CatModule,self)
    else
        _G["Cats"][CatModule.catId]:CheckShow(CatModule)
    end
end

--delete cat
function MainStart.DelCat( catId )
    -- body
    if(_G["Cats"][catId] ~= nil) then
        _G["Cats"][catId]:DelCat()
    end
end

--delete all cats
function MainStart.DelAllCat( ... )
    -- body
    for i,v in pairs(_G["Cats"]) do
        self.DelCat(i)
    end
end


function MainStart.AllCatsChecks( ... )
    -- body
    for i,v in pairs(_G["Cats"]) do
        v:CheckDataEvent()
    end
end



function MainStart.HideCat( catId )
    -- body
     _G["Cats"][catId]:HideCat()
end


function MainStart.ShowCat( catId )
    -- body
    _G["Cats"][catId]:ShowCat()
end


--refreshing cat data
function MainStart.SendMsgCatInfoReq( catId )
    -- body
    local CatInfoReq = {}
    CatInfoReq.token = playerData.baseData.data.token
    CatInfoReq.id = catId
    PublicClient.SendMsgCatInfoReq(CatInfoReq,function ( data )
        -- body
        for i=1,#playerData.catList do
            local CatModule = playerData.catList[i]
            if(CatModule.catId == data.catInfo.catId) then
                playerData.catList[i] = data.catInfo
                _G["Cats"][data.catInfo.catId]:UpdateCatModule(data.catInfo)
                break
            end
        end
    end)
end

--send a cat poop message
function MainStart.SendMsgCatCacationReq( CatModule )
    -- body
    local CatCacationReq = {}
    CatCacationReq.token = playerData.baseData.data.token
    CatCacationReq.catId = CatModule.catId
    PublicClient.SendMsgCatCacationReq(CatCacationReq,function ( data )
        -- body
        _G["Cats"][data.catId]:CatCacationActCallback(data) 
        self.SendMsgCatInfoReq(data.catId)
    end)
end


--send a message that cats drink water
function MainStart.SendMsgCatDrinkReq( CatModule )
    local CatDrinkReq = {}
    CatDrinkReq.token = playerData.baseData.data.token
    CatDrinkReq.catId = CatModule.catId
    PublicClient.SendMsgCatDrinkReq(CatDrinkReq,function ( data )
        -- body
        _G["Cats"][data.catId]:CatDrinkAckCallback(data)    
        self.SendMsgCatInfoReq(data.catId)
    end)
end

--send cat feeding messages
function MainStart.SendMsgCatEatReq( CatModule )
    -- body
    local CatEatReq = {}
    CatEatReq.token = playerData.baseData.data.token
    CatEatReq.catId = CatModule.catId
    PublicClient.SendMsgCatEatReq(CatEatReq,function ( data )
        -- body
        _G["Cats"][data.catId]:CatEatAckCallback(data)   
        self.SendMsgCatInfoReq(data.catId)
    end)
end



--determination of illness
function MainStart.SendMsgCatSickJudgeReq( catId )
    -- body
    local CatSickJudgeReq = {}
    CatSickJudgeReq.token = playerData.baseData.data.token
    CatSickJudgeReq.catId = catId
    PublicClient.SendMsgCatSickJudgeReq(CatSickJudgeReq,function ( data )
        -- body
        _G["Cats"][data.catId]:CatSickJudgeAckCallback(data) 
    end)
end


--shelter recovery of cats
function MainStart.SendMsgRecoverShelterReq( catId )
    -- body
    local RecoverShelterReq = {}
    RecoverShelterReq.token = playerData.baseData.data.token
    RecoverShelterReq.catId = catId
    PublicClient.SendMsgRecoverShelterReq(RecoverShelterReq,function ( data )
        -- body
         _G["Cats"][data.catId]:HideCat()
    end)
end



--receive message
function MainStart.EnterCallCat( str )
    -- body
    MainView.EnterCallCat(self[str])
end

--receive message
function MainStart.ExitCallCat( str )
    -- body
    MainView.ExitCallCat()
end

--player enters space
function MainStart.EnterSpace( str )
    -- body
    CS.RoleController.Instance.curSpace = str
end

--player leaving space
function MainStart.ExitSpace( str )
    -- body
    CS.RoleController.Instance.curSpace = str
end

--make photos
function MainStart.CreateCatsPNG( ... )
    -- body
    local num = math.floor(100001)
    self.showCat = Cat:New()
    self.showCat:OnlyShowCat(math.floor(num),_G["PathController"].living_room_37,function ( nameEX )
        -- body
        self.PNGMaker:GetComponent("PNGMaker"):CreatePNG(num,nameEX)
    end)
    

    TimeManager:StartTime("CreateCatsPNG",0,5,true,function ( t )
        if(num == 100010) then
            num = 200001
        end
        if(num == 200010) then
            num = 300001
        end
        if(num == 300010) then
            num = 400001
        end
        if(num == 400010) then
            num = 500001
        end
        if(num == 500010) then
            num = 600001
        end
        if(num == 600010) then
            num = 700001
        end
        if(num == 700010) then
            num = 800001
        end
        if(num == 800010) then
            num = 900001
        end
        if(num == 900010) then
            num = 1000001
        end
        if(num == 1000010) then
            num = 1100001
        end
        if(num == 1100010) then
            num = 1200001
        end
        if(num == 1200010) then
            num = 1300001
        end
        if(num == 1300010) then
            num = 1400001
        end
        if(num == 1400010) then
            num = 1500001
        end
        if(num == 1500010) then
            TimeManager:OverTime("CreateCatsPNG")
            return
        end
        num = math.floor(num + 1)
        GameObject.Destroy(self.showCat.catObj)
        self.showCat = Cat:New()
        self.showCat:OnlyShowCat(math.floor(num),_G["PathController"].living_room_37,function ( nameEX )
            -- body
            self.PNGMaker:GetComponent("PNGMaker"):CreatePNG(num,nameEX)
        end)
        
    end)
end


