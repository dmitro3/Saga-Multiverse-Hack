ShelterView = {}
local self = ShelterView


function ShelterView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    self.main_btn_enter:GetComponent("Button").onClick:RemoveAllListeners()
    self.main_btn_enter:GetComponent("Button").onClick:AddListener(self.MainEnterClick)
    self.SendMsgPsStatisticsReq()
    self.Init()
end



function ShelterView.Update( ... )
    -- body
end


function ShelterView.OnDestroy( ... )
    -- body

end


function ShelterView.Init( ... )
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        if(ItemModule.propId == 10001) then
            self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
        if(ItemModule.propId == 10002) then
            self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
    end
    
    local talkTab = {
    "Welcome to the shelter. I hope you can adopt a cat.",
    "If you can't take care of the cat, we will take it back.",
    "If you want others to adopt your cat, you can find the right person here.",}

    local i = math.floor(Random.Range(1,#talkTab+1))
    self.text_talk:GetComponent("TextMeshProUGUI").text = talkTab[i]
end


function ShelterView.Quit( ... )
    -- body
    self.OverAllTime()
    CS.RoleController.Instance.gameObject:SetActive(true)
    UIManager:DelUI("bg_shelter")
    UIManager:DelUI("shelter_view")
    MainStart.UpdateCatList()
    UIManager:ShowUIAsync("main","main_view")
    
end

function ShelterView.OverAllTime( ... )
    -- body
    TimeManager:OverTime("change_data")
    if(self.catList) then
        for i=1,#self.catList do
            TimeManager:OverTime("adopt_"..self.catList[i].shelterId)
            TimeManager:OverTime("self_"..self.catList[i].shelterId)
        end
    end

    if(self.redeemCatList) then
        for i=1,#self.redeemCatList do
            TimeManager:OverTime("redeem_"..self.redeemCatList[i].shelterId)
        end
    end
end

function ShelterView.SendMsgPsStatisticsReq( ... )
    -- body
    local PsStatisticsReq = {}
    PsStatisticsReq.token = playerData.baseData.data.token
    PublicClient.SendMsgPsStatisticsReq(PsStatisticsReq,function ( data )
        -- body
        if(self.change == nil) then
            self.change = 1
            self.ShowMainData( data )
        end

        TimeManager:StartTime("change_data",0,3,true,function ( t )
            self.change = self.change + 1
            if(self.change > 4) then
                self.change = 1
            end
            self.ShowMainData( data )
        end)

        self.main_btn_right:GetComponent("Button").onClick:RemoveAllListeners()
        self.main_btn_right:GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.change = self.change + 1
            if(self.change > 4) then
                self.change = 1
            end
            self.ShowMainData( data )
        end)

        self.main_btn_left:GetComponent("Button").onClick:RemoveAllListeners()
        self.main_btn_left:GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.change = self.change - 1
            if(self.change < 1) then
                self.change = 4
            end
            self.ShowMainData( data )
        end)
    end)
end

function ShelterView.ShowMainData( data )
    -- body
    self.main_btn_right:SetActive(true)
    self.main_btn_left:SetActive(true)
    if(self.change == 1) then
        self.main_tex_LastHours:GetComponent("TextMeshProUGUI").text = "Last <color=#FFFBD7>24</color> Hours"
        self.main_btn_left:SetActive(false)
    elseif(self.change == 2) then
        self.main_tex_LastHours:GetComponent("TextMeshProUGUI").text = "Last <color=#FFFBD7>7</color> Days"
    elseif(self.change == 3) then
        self.main_tex_LastHours:GetComponent("TextMeshProUGUI").text = "Last <color=#FFFBD7>30</color> Days"
    elseif(self.change == 4) then
        self.main_tex_LastHours:GetComponent("TextMeshProUGUI").text = "All records"
        self.main_btn_right:SetActive(false)
    end
    self["mainPoint_"..self.change]:GetComponent("Toggle").isOn = true
    self.main_tex_Adopt:GetComponent("TextMeshProUGUI").text = tostring(data["catCount"..self.change])
    self.main_tex_Accumulated:GetComponent("TextMeshProUGUI").text = tostring(data["userCount"..self.change])
end

function ShelterView.MainEnterClick( ... )
    -- body
    self.mainMsg:SetActive(false)
    self.panel_function:SetActive(true)
    self.InitAdoptSetting()
    self.SendMsgPsCatListReq()
    self.UpdateUserCatList()
    self.SendMsgRedeemCatListReq()
end

function ShelterView.InitAdoptSetting( ... )
    -- body
    self.sex = {true,true}
    self.character = {true,true,true,true,true}
    self.General_Level_Slider = self.General_Level:GetComponent("LRSliderCtrl")
    self.General_Level_Slider:SetInitValue(Vector2(1,parameterClient[3].value[1]))
    self.General_Generation_Slider = self.General_Generation:GetComponent("LRSliderCtrl")
    self.General_Generation_Slider:SetInitValue(Vector2(1,parameterClient[7].value[1]))
    self.General_Age_Slider = self.General_Age:GetComponent("LRSliderCtrl")
    self.General_Age_Slider:SetInitValue(Vector2(1,parameterClient[6].value[1]))
    self.Stats_Lovely_Slider = self.Stats_Lovely:GetComponent("LRSliderCtrl")
    self.Stats_Lovely_Slider:SetInitValue(Vector2(1,parameterClient[2].value[1]))
    self.Stats_Strong_Slider = self.Stats_Strong:GetComponent("LRSliderCtrl")
    self.Stats_Strong_Slider:SetInitValue(Vector2(1,parameterClient[1].value[1]))
    self.General_Birthday_Input = self.General_Birthday:GetComponent("BirthdayInputCtrl")

    self.adopt_Filter_General_Sex_Male:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Sex_Male:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.sex[1] = isOn
    end)
    self.adopt_Filter_General_Sex_Male:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Sex_Female:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Sex_Female:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.sex[2] = isOn
    end)
    self.adopt_Filter_General_Sex_Female:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Charactor_Maverick:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Charactor_Maverick:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.character[1] = isOn
    end)
    self.adopt_Filter_General_Charactor_Maverick:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Charactor_Sticky:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Charactor_Sticky:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.character[2] = isOn
    end)
    self.adopt_Filter_General_Charactor_Sticky:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Charactor_Lovely:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Charactor_Lovely:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.character[3] = isOn
    end)
    self.adopt_Filter_General_Charactor_Lovely:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Charactor_Timid:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Charactor_Timid:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.character[4] = isOn
    end)
    self.adopt_Filter_General_Charactor_Timid:GetComponent("Toggle").isOn = true

    self.adopt_Filter_General_Charactor_Lazy:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.adopt_Filter_General_Charactor_Lazy:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
        -- body
        self.character[5] = isOn
    end)
    self.adopt_Filter_General_Charactor_Lazy:GetComponent("Toggle").isOn = true

    self.adopt_btn_Drop:GetComponent("TMP_Dropdown").onValueChanged:RemoveAllListeners()
    self.adopt_btn_Drop:GetComponent("TMP_Dropdown").onValueChanged:AddListener(self.AdoptDropChange)

    self.adopt_btn_Screen:GetComponent("Button").onClick:RemoveAllListeners()
    self.adopt_btn_Screen:GetComponent("Button").onClick:AddListener(self.ScreenClick)

end

--cat list requests from all users of the shelter
function ShelterView.SendMsgPsCatListReq( callback )
    -- body
    local PsCatListReq = {}
    PsCatListReq.token = playerData.baseData.data.token
    PublicClient.SendMsgPsCatListReq(PsCatListReq,function ( data )
        -- body
        Debug.LogError("number of cats listed by all users："..#data.catList)
        self.offsetTime = data.nowTime - TimeManager:GetTimeStamp(false)
        self.catList = data.catList
        self.adopt_text:GetComponent("TextMeshProUGUI").text = "A total of <color=#fffbd7>"..tostring(#data.catList).."</color> cats are waiting for adoption"
        self.adoptObjs = ClearObjs(self.adoptObjs)
        for i=1,#data.catList do
            local ShelterCatModule = data.catList[i]
            local obj = GameObject.Instantiate(self.item_adopt,self.item_adopt.transform.parent)
            self.adoptObjs[ShelterCatModule.shelterId] = obj
            obj:SetActive(true)
            self.ItemAdoptSetting(obj,ShelterCatModule)
        end
        if(callback) then
            callback()
        end
    end)
end


function ShelterView.ItemAdoptSetting( obj, ShelterCatModule)
    -- body
    if(ShelterCatModule.userId == playerData.baseData.data.userId) then
        --a cat that players put on their own shelves
        obj.transform:SetSiblingIndex(1)
        obj.transform:Find("item_btn_Reclaim").gameObject:SetActive(true)
        obj.transform:Find("item_btn_Reclaim"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Reclaim"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            Debug.LogError("take off the shelf")
            self.ShowBoxReclaimMsg(ShelterCatModule)
        end)
    else
        --cats that other players put on the shelves
        obj.transform:Find("item_btn_Adopt").gameObject:SetActive(true)
        obj.transform:Find("item_btn_Adopt"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Adopt"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            Debug.LogError("purchase")
            self.ShowBoxAdopt( ShelterCatModule )
        end)
    end

    obj.transform:Find("item_tex_Lv"):GetComponent("TextMeshProUGUI").text = "LV."..ShelterCatModule.level
    obj.transform:Find("item_obj_tex_Puss"):GetComponent("TextMeshProUGUI").text = ShelterCatModule.name
    obj.transform:Find("item_obj_timeYellow/item_tex_timeYellow"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false)))
    TimeManager:StartTime("adopt_"..ShelterCatModule.shelterId,0,60,true,function ( t )
        obj.transform:Find("item_obj_timeYellow/item_tex_timeYellow"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false)))
    end)

    obj.transform:Find("item_tex_Paw"):GetComponent("TextMeshProUGUI").text = tostring(ShelterCatModule.listingPrice)..item[ShelterCatModule.listingPriceType].name
    obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:RemoveAllListeners()
    obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowTipsInformation(ShelterCatModule,obj.transform:Find("item_btn_Information").transform.position)
    end)
end


function ShelterView.ShowBoxAdopt( ShelterCatModule )
    -- body
    self.box_adopt:SetActive(true)
    self.adopt_cat_Lv:GetComponent("TextMeshProUGUI").text = "LV."..ShelterCatModule.level
    self.adopt_cat_name:GetComponent("TextMeshProUGUI").text = ShelterCatModule.name
    if(self.CheckMoney( ShelterCatModule.listingPrice,ShelterCatModule.listingPriceType )) then
        self.text_adopt_cat_price:GetComponent("TextMeshProUGUI").text = tostring(ShelterCatModule.listingPrice)..item[ShelterCatModule.listingPriceType].name
        self.btn_box_adopt_ok:SetActive(true)
        self.btn_box_adopt_ok:GetComponent("Button").onClick:RemoveAllListeners()
        self.btn_box_adopt_ok:GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            Debug.LogError("adopt a cat")
            self.SendMsgAdoptCatReq(ShelterCatModule)
            self.box_adopt:SetActive(false)
        end)
    else
        self.text_adopt_cat_price:GetComponent("TextMeshProUGUI").text = "<color=#bd3026>"..tostring(ShelterCatModule.listingPrice)..item[ShelterCatModule.listingPriceType].name.."</color>"
        self.btn_box_adopt_ok:SetActive(false)
    end
end

function ShelterView.SendMsgAdoptCatReq( ShelterCatModule )
    -- body
    local AdoptCatReq = {}
    AdoptCatReq.token = playerData.baseData.data.token
    AdoptCatReq.shelterId = ShelterCatModule.shelterId
    PublicClient.SendMsgAdoptCatReq(AdoptCatReq,function ( data )
        -- body
        Debug.LogError("successful cat adoption："..ShelterCatModule.shelterId)
        self.DelAdoptCat( ShelterCatModule.shelterId )
        self.UpdateUserInfo()
        self.UpdateUserCatList()
    end)

end

function ShelterView.ShowTipsInformation( ShelterCatModule,pot )
    -- body
    self.tips_information:SetActive(true)
    local savePot = self.obj_tips.transform.position
    self.obj_tips.transform.position = Vector3(pot.x,savePot.y,savePot.z)
    self.tips_tex_Lv:GetComponent("TextMeshProUGUI").text = "LV."..ShelterCatModule.level
    self.tips_obj_tex_Puss:GetComponent("TextMeshProUGUI").text = ShelterCatModule.name
    self.tips_obj_Attributes_1_Value:GetComponent("TextMeshProUGUI").text = ShelterCatModule.charm.." <color=#ffb16c>(+"..ShelterCatModule.charmAdd..")</color>"
    self.tips_obj_Attributes_2_Value:GetComponent("TextMeshProUGUI").text = ShelterCatModule.strength.." <color=#91d5b7>(+"..ShelterCatModule.strengthAdd..")</color>"
    self.tips_obj_Age_Value:GetComponent("TextMeshProUGUI").text = math.ceil((TimeManager.Now - ShelterCatModule.birthday) / (1000*60*60*24*365))
    local birthday = TimeManager:GetDateTime(ShelterCatModule.birthday,-5)
    self.tips_obj_Birthday_Value:GetComponent("TextMeshProUGUI").text = birthday:ToString("MMMM", CS.System.Globalization.CultureInfo("en-us")).." "..birthday:ToString("dd")
    self.tips_obj_Generation_Value:GetComponent("TextMeshProUGUI").text = ConvertToRoman(ShelterCatModule.generation)
    local characterTab = {"Maverick","Sticky","Lively","Timid","Lazy"}
    self.tips_obj_Character_Value:GetComponent("TextMeshProUGUI").text = characterTab[ShelterCatModule.character]
    local actionIds = {401,402,403,404}
    self.actionObjs = ClearObjs(self.actionObjs)
    for i=1,#actionIds do
        local id = actionIds[i]
        local actionData = cat_action[id]
        if(ShelterCatModule.intimacy >= actionData.needIntimacy) then
            local obj = GameObject.Instantiate(self.tips_obj_Action_temp,self.tips_obj_Action_temp.transform.parent)
            self.actionObjs[id] = obj
            obj:SetActive(true)
            PoolManager:SpawnAsync(actionData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("tips_obj_Action_temp_icon"):GetComponent("Image").sprite = sprite
            end)
        end
    end
end


function ShelterView.ScreenClick( ... )
    -- body
    for i=1,#self.catList do
        local ShelterCatModule = self.catList[i]
        local obj = self.adoptObjs[ShelterCatModule.shelterId]
        obj:SetActive(true)
        if(ShelterCatModule.level < self.General_Level_Slider.value.x or ShelterCatModule.level > self.General_Level_Slider.value.y) then
            Debug.LogError("ShelterCatModule.level:"..ShelterCatModule.level)
            obj:SetActive(false)
        end
        if(ShelterCatModule.generation < self.General_Generation_Slider.value.x or ShelterCatModule.generation > self.General_Generation_Slider.value.y) then
            Debug.LogError("ShelterCatModule.generation:"..ShelterCatModule.generation)
            obj:SetActive(false)
        end
        local age = math.ceil((TimeManager.Now - ShelterCatModule.birthday) / (1000*60*60*24*365))
        if(age < self.General_Age_Slider.value.x or age > self.General_Age_Slider.value.y) then
            Debug.LogError("age:"..age)
            obj:SetActive(false)
        end

        if(not self.sex[ShelterCatModule.sex]) then
            Debug.LogError("sex:"..ShelterCatModule.sex)
            obj:SetActive(false)
        end

        
        if(self.General_Birthday_Input.mon > 0) then
            local birthday = TimeManager:GetDateTime(ShelterCatModule.birthday,-5)
            if(birthday.Month ~= self.General_Birthday_Input.mon or birthday.Day ~= self.General_Birthday_Input.day) then
                Debug.LogError(birthday.Month.."-"..birthday.Day)
                obj:SetActive(false)
            end
        end

        if(self.character[ShelterCatModule.character] ~= true) then
            Debug.LogError("ShelterCatModule.character:"..ShelterCatModule.character)
            obj:SetActive(false)
        end

        if(ShelterCatModule.charm < self.Stats_Lovely_Slider.value.x or ShelterCatModule.charm > self.Stats_Lovely_Slider.value.y) then
            Debug.LogError("ShelterCatModule.charm:"..ShelterCatModule.charm)
            obj:SetActive(false)
        end

        if(ShelterCatModule.strength < self.Stats_Strong_Slider.value.x or ShelterCatModule.strength > self.Stats_Strong_Slider.value.y) then
            Debug.LogError("ShelterCatModule.strength:"..ShelterCatModule.strength)
            obj:SetActive(false)
        end


    end
end

function ShelterView.AdoptDropChange( num )
    -- body
    local saveTab = {}
    for i=1,#self.catList do
        local saveNum = 0
        local saveJ = 0
        for j=1,#self.catList do
            if(saveTab[j] ~= true) then
                if(num == 0) then
                    if(self.catList[j].startTime > saveNum) then
                        saveNum = self.catList[j].startTime
                        saveJ = j
                    end
                elseif(num == 1) then
                    if(self.catList[j].listingPrice > saveNum) then
                        saveNum = self.catList[j].listingPrice
                        saveJ = j
                    end
                elseif(num == 2) then
                    if(self.catList[j].listingPrice < saveNum or saveNum == 0) then
                        saveNum = self.catList[j].listingPrice
                        saveJ = j
                    end
                end
            end
        end
        if(saveJ > 0) then
            saveTab[saveJ] = true
            local obj = self.adoptObjs[self.catList[saveJ].shelterId]
            obj.transform:SetSiblingIndex(i)
        end
    end
    self.ScreenClick()
end


--decide if the money is enough
function ShelterView.CheckMoney( moneyNum,moneyType )
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        if(ItemModule.propId == moneyType) then
            if(ItemModule.propCount >= moneyNum) then
                return true
            else
                return false
            end
        end
    end
    return false
end


--delete a cat from the adoption list
function ShelterView.DelAdoptCat( shelterId )
    -- body
    TimeManager:OverTime("adopt_"..shelterId)
    local obj = self.adoptObjs[shelterId]
    GameObject.Destroy(obj)
    self.adoptObjs[shelterId] = nil
    local flagIndex = 0
    for i=1,#self.catList do
        if(self.catList[i].shelterId == shelterId) then
            flagIndex = i
        end
    end
    if(flagIndex ~= 0) then
        table.remove(self.catList,flagIndex)
    end
end


--refresh player stats
function ShelterView.UpdateUserInfo( ... )
    -- body
    GetUserInfo(function ( data )
        -- body
        for i=1,#playerData.itemList do
            local ItemModule = playerData.itemList[i]
            if(ItemModule.propId == 10001) then
                self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
            end
            if(ItemModule.propId == 10002) then
                self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
            end
        end
    end)
end

--refresh the player cat list
function ShelterView.UpdateUserCatList( ... )
    -- body
    GetUserCatList(function ( data )
        -- body
        self.userCatList = ClearObjs(self.userCatList)
        for i=1,#playerData.catList do
            local CatModule = playerData.catList[i]
            local obj = GameObject.Instantiate(self.item_foster,self.item_foster.transform.parent)
            self.userCatList[CatModule.catId] = obj
            obj:SetActive(true)
            self.ItemFosterSetting(obj,CatModule)
        end
    end)
end

function ShelterView.ItemFosterSetting( obj, CatModule )
    -- body
    local ShelterCatModule = nil
    for i=1,#self.catList do
        if(self.catList[i].catId == CatModule.catId) then
            ShelterCatModule = self.catList[i] 
            break
        end
    end

    if(ShelterCatModule == nil) then
        obj.transform:Find("item_tex_Lv"):GetComponent("TextMeshProUGUI").text = "LV."..CatModule.level
        obj.transform:Find("item_obj_tex_Puss"):GetComponent("TextMeshProUGUI").text = CatModule.name
        obj.transform:Find("item_obj_timeYellow").gameObject:SetActive(false)
        obj.transform:Find("item_obj_Paw_bg").gameObject:SetActive(false)
        obj.transform:Find("item_tex_Paw").gameObject:SetActive(false)
        obj.transform:Find("item_obj_healthy").gameObject:SetActive(true)
        if(CatModule.health >= 100) then
            obj.transform:Find("item_obj_healthy/item_tex_healthy"):GetComponent("TextMeshProUGUI").text = CatModule.health.."/"..CatModule.maxHealth
            obj.transform:Find("item_btn_Foster_Green").gameObject:SetActive(true)
            obj.transform:Find("item_btn_Foster_Green"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("item_btn_Foster_Green"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                Debug.LogError("shelf")
                self.ShowBoxPutonShelve( CatModule )
            end)
        else
            obj.transform:Find("item_obj_healthy/item_tex_healthy"):GetComponent("TextMeshProUGUI").text = "<color=#bd3026>"..CatModule.health.."/"..CatModule.maxHealth.."</color>"
            obj.transform:Find("item_btn_Foster_Gray").gameObject:SetActive(true)
        end
        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.ShowTipsInformation(CatModule,obj.transform:Find("item_btn_Information").transform.position)
        end)
    else
        obj.transform:Find("item_tex_Lv"):GetComponent("TextMeshProUGUI").text = "LV."..ShelterCatModule.level
        obj.transform:Find("item_obj_tex_Puss"):GetComponent("TextMeshProUGUI").text = ShelterCatModule.name
        obj.transform:Find("item_obj_timeYellow").gameObject:SetActive(true)
        obj.transform:Find("item_obj_Paw_bg").gameObject:SetActive(true)
        obj.transform:Find("item_tex_Paw").gameObject:SetActive(true)
        obj.transform:Find("item_obj_healthy").gameObject:SetActive(false)
        obj.transform:Find("item_obj_timeYellow/item_tex_timeYellow"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false)))
        TimeManager:StartTime("self_"..ShelterCatModule.shelterId,0,60,true,function ( t )
            obj.transform:Find("item_obj_timeYellow/item_tex_timeYellow"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false)))
        end)

        obj.transform:Find("item_tex_Paw"):GetComponent("TextMeshProUGUI").text = tostring(ShelterCatModule.listingPrice)..item[ShelterCatModule.listingPriceType].name
        obj.transform:SetSiblingIndex(1)
        obj.transform:Find("item_btn_Reclaim").gameObject:SetActive(true)
        obj.transform:Find("item_btn_Reclaim"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Reclaim"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            Debug.LogError("take off the shelf")
            self.ShowBoxReclaimMsg(ShelterCatModule)
        end)

        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.ShowTipsInformation(ShelterCatModule,obj.transform:Find("item_btn_Information").transform.position)
        end)
    end

end

--display shelf panel
function ShelterView.ShowBoxPutonShelve( CatModule )
    -- body
    self.box_foster:SetActive(true)
    self.Input_fostering_price:GetComponent("TMP_InputField").text = ""
    self.text_custoday_fees:GetComponent("TextMeshProUGUI").text = "-PAW"
    self.text_custoday_income:GetComponent("TextMeshProUGUI").text = "-PAW"
    self.btn_box_foster_ok_grey:SetActive(true)
    self.btn_box_foster_ok:SetActive(false)
    self.Input_fostering_price:GetComponent("TMP_InputField").onEndEdit:RemoveAllListeners()
    self.Input_fostering_price:GetComponent("TMP_InputField").onEndEdit:AddListener(function ( str )
        -- body
        if(tonumber(str) ~= nil and tonumber(str) > 0) then
            self.fosterPrice = tonumber(str)
            self.fees = math.floor(self.fosterPrice * parameterClient[4].value[1])
            if(self.CheckMoney(self.fees,10001)) then
                self.text_custoday_fees:GetComponent("TextMeshProUGUI").text = tostring(self.fees).."PAW"
                self.text_custoday_income:GetComponent("TextMeshProUGUI").text = tostring(self.fosterPrice - self.fees).."PAW"
                self.btn_box_foster_ok_grey:SetActive(false)
                self.btn_box_foster_ok:SetActive(true)
            else
                self.text_custoday_fees:GetComponent("TextMeshProUGUI").text = "<color=#bd3026>"..tostring(self.fees).."PAW</color>"
                self.text_custoday_income:GetComponent("TextMeshProUGUI").text = "<color=#bd3026>"..tostring(self.fosterPrice - self.fees).."PAW</color>"
                self.btn_box_foster_ok_grey:SetActive(true)
                self.btn_box_foster_ok:SetActive(false)
            end
        else
            self.Input_fostering_price:GetComponent("TMP_InputField").text = ""
            self.btn_box_foster_ok_grey:SetActive(true)
            self.btn_box_foster_ok:SetActive(false)
        end
    end)
    self.btn_box_foster_ok:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_box_foster_ok:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.box_foster:SetActive(false)
        self.SendMsgPutonShelveReq(CatModule.catId,self.fosterPrice)
    end)
end

--send shelf request
function ShelterView.SendMsgPutonShelveReq( catId,listingPrice )
    -- body
    local PutonShelveReq = {}
    PutonShelveReq.token = playerData.baseData.data.token
    PutonShelveReq.catId = catId
    PutonShelveReq.listingPrice = listingPrice
    PublicClient.SendMsgPutonShelveReq(PutonShelveReq,function ( data )
        -- body
        Debug.LogError("shelf success catId:"..catId)
        self.UpdateUserInfo()
        self.InitAdoptSetting()
        self.SendMsgPsCatListReq(function ( ... )
            -- body
            self.UpdateUserCatList()
        end)
        
    end)
end


--the removal dialog box is displayed
function ShelterView.ShowBoxReclaimMsg(ShelterCatModule)
    self.box_reclaim:SetActive(true)
    local reclaimPrice = math.floor(ShelterCatModule.listingPrice * parameterClient[5].value[1])
    if(self.CheckMoney(reclaimPrice,ShelterCatModule.listingPriceType)) then
        self.box_reclaim.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = "Are you sure to reclaim?\nCost: <sprite=\""..ShelterCatModule.listingPriceType.."\" index=0> "..reclaimPrice
        self.btn_box_reclaim_ok:SetActive(true)
        self.btn_box_reclaim_ok_grey:SetActive(false)
    else
        self.box_reclaim.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = "Are you sure to reclaim?\nCost: <sprite=\""..ShelterCatModule.listingPriceType.."\" index=0> <color=#bd3026>"..reclaimPrice.."</color>"
        self.btn_box_reclaim_ok:SetActive(false)
        self.btn_box_reclaim_ok_grey:SetActive(true)
    end
    self.btn_box_reclaim_ok:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_box_reclaim_ok:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.box_reclaim:SetActive(false)
        self.SendMsgLowerShelveReq(ShelterCatModule)
    end)
end


function ShelterView.SendMsgLowerShelveReq( ShelterCatModule )
    -- body
    local LowerShelveReq = {}
    LowerShelveReq.token = playerData.baseData.data.token
    LowerShelveReq.shelterId = ShelterCatModule.shelterId
    PublicClient.SendMsgLowerShelveReq(LowerShelveReq,function ( data )
        -- body
        Debug.LogError("removed successfully catId:"..ShelterCatModule.catId)
        TimeManager:OverTime("adopt_"..ShelterCatModule.shelterId)
        TimeManager:OverTime("self_"..ShelterCatModule.shelterId)
        self.UpdateUserInfo()
        self.InitAdoptSetting()
        self.SendMsgPsCatListReq(function ( ... )
            -- body
            self.UpdateUserCatList()
        end)
    end)
end


function ShelterView.SendMsgRedeemCatListReq( ... )
    -- body
    local RedeemCatListReq = {}
    RedeemCatListReq.token = playerData.baseData.data.token
    PublicClient.SendMsgRedeemCatListReq(RedeemCatListReq,function ( data )
        -- body
        Debug.LogError("number of cats to be collected："..#data.catList)
        self.redeemCatList = data.catList
        self.redeemCatObjs = ClearObjs(self.redeemCatObjs)
        for i=1,#data.catList do
            local ShelterCatModule = data.catList[i]
            local obj = GameObject.Instantiate(self.item_get_back,self.item_get_back.transform.parent)
            self.redeemCatObjs[ShelterCatModule.shelterId] = obj
            obj:SetActive(true)
            self.ItemRedeemSetting(obj,ShelterCatModule)
        end
    end)

end


function ShelterView.ItemRedeemSetting( obj, ShelterCatModule )
    -- body
    obj.transform:Find("item_tex_Lv"):GetComponent("TextMeshProUGUI").text = "LV."..ShelterCatModule.level
    obj.transform:Find("item_obj_tex_Puss"):GetComponent("TextMeshProUGUI").text = ShelterCatModule.name
    local redeemTime = ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false))
    Debug.LogError(ShelterCatModule.endTime)
    Debug.LogError(self.offsetTime + TimeManager:GetTimeStamp(false))
    Debug.LogError("redeemTime:"..redeemTime)
    redeemTime = -redeemTime
    if(redeemTime > 0) then
        obj.transform:Find("item_obj_timeRed/item_tex_timeRed"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(redeemTime)
        TimeManager:StartTime("redeem_"..ShelterCatModule.shelterId,0,60,true,function ( t )
            redeemTime = ShelterCatModule.endTime - (self.offsetTime + TimeManager:GetTimeStamp(false))
            if(redeemTime > 0) then
                obj.transform:Find("item_obj_timeRed/item_tex_timeRed"):GetComponent("TextMeshProUGUI").text = ShowTimeStr(redeemTime)
            else
                TimeManager:OverTime("redeem_"..ShelterCatModule.shelterId)
                GameObject.Destroy(obj)
                self.redeemCatObjs[ShelterCatModule.shelterId] = nil
            end
        end)

        obj.transform:Find("item_tex_Paw"):GetComponent("TextMeshProUGUI").text = tostring(ShelterCatModule.listingPrice)..item[ShelterCatModule.listingPriceType].name
        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("item_btn_Information"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.ShowTipsInformation(ShelterCatModule,obj.transform:Find("item_btn_Information").transform.position)
        end)

    else
        Debug.LogError("ShelterCatModule.shelterId:"..ShelterCatModule.shelterId)
        Debug.LogError("ShelterCatModule.endTime:"..ShelterCatModule.endTime)
        TimeManager:OverTime("redeem_"..ShelterCatModule.shelterId)
        GameObject.Destroy(obj)
        self.redeemCatObjs[ShelterCatModule.shelterId] = nil
    end

    obj.transform:Find("item_btn_GetBack"):GetComponent("Button").onClick:RemoveAllListeners()
    obj.transform:Find("item_btn_GetBack"):GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        Debug.LogError("redemption")
        self.ShowBoxRedeem(ShelterCatModule)
    end)

end


--display redemption panel
function ShelterView.ShowBoxRedeem( ShelterCatModule )
    -- body
    self.box_redeem:SetActive(true)
    local redeemPrice = ShelterCatModule.listingPrice
    if(self.CheckMoney(redeemPrice,ShelterCatModule.listingPriceType)) then
        self.text_box_redeem:GetComponent("TextMeshProUGUI").text = "The cat will return to your home immediately after payment.\nCost: <sprite=\""..ShelterCatModule.listingPriceType.."\" index=0> "..redeemPrice
        self.btn_box_redeem_ok:SetActive(true)
        self.btn_box_redeem_ok_grey:SetActive(false)
    else
        self.text_box_redeem:GetComponent("TextMeshProUGUI").text = "The cat will return to your home immediately after payment.\nCost: <sprite=\""..ShelterCatModule.listingPriceType.."\" index=0> <color=#bd3026>"..redeemPrice.."</color>"
        self.btn_box_redeem_ok:SetActive(false)
        self.btn_box_redeem_ok_grey:SetActive(true)
    end
    self.btn_box_redeem_ok:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_box_redeem_ok:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.box_redeem:SetActive(false)
        self.SendMsgRedeemReq(ShelterCatModule)
    end)
end

--send redemption request
function ShelterView.SendMsgRedeemReq( ShelterCatModule )
    -- body
    local RedeemReq = {}
    RedeemReq.token = playerData.baseData.data.token
    RedeemReq.shelterId = ShelterCatModule.shelterId
    PublicClient.SendMsgRedeemReq(RedeemReq,function ( data )
        -- body
        Debug.LogError("successful redemption catId:"..ShelterCatModule.catId)
        TimeManager:OverTime("redeem_"..ShelterCatModule.shelterId)
        self.UpdateUserInfo()
        self.SendMsgRedeemCatListReq()
        self.SendMsgPsCatListReq(function ( ... )
            -- body
            self.UpdateUserCatList()
        end)
    end)
end
