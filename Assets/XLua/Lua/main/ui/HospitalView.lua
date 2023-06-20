HospitalView = {}
local self = HospitalView
local talkTab = {
            "Your cats are very healthy at present.",
            "Don't worry, cats can get good treatment here.",
            "Please note that letting the cat out may make it sick.",
            "The sick cat can't do anything. Please treat it as soon as possible.",
            "Hunger or too long claws can make a cat sick.",}



function HospitalView.Start( ... )
    -- body
   self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
   self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
   self.SendMsgSickCatListReq()
   self.Init()
end


function HospitalView.Update( ... )
    -- body
end


function HospitalView.OnDestroy( ... )
    -- body
    if(self.SickCats) then
        for i=1,#self.SickCats do
            local SickCatModule = self.SickCats[i]
            TimeManager:OverTime("wait_treatment_"..SickCatModule.catId)
        end
    end
end


function HospitalView.Init( ... )
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        --Debug.LogError("ItemModule.propId = "..ItemModule.propId)
        if(ItemModule.propId == 10001) then
            self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
        if(ItemModule.propId == 10002) then
            self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
    end

    

end

--get a list of sick cats
function HospitalView.SendMsgSickCatListReq( ... )
    -- body
    self.catObjs = ClearObjs(self.catObjs)
    local SickCatListReq = {}
    SickCatListReq.token = playerData.baseData.data.token
    PublicClient.SendMsgSickCatListReq(SickCatListReq,function ( data )
        -- body
        self.SickCats = data.catList
        if(#data.catList == 0) then
            self.text_empty:SetActive(true)
            self.talk:SetActive(true)
            self.text_talk:GetComponent("TextMeshProUGUI").text = talkTab[1]
        else
            self.text_empty:SetActive(false)
            self.talk:SetActive(true)
            local i = math.floor(Random.Range(2,#talkTab+1))
            self.text_talk:GetComponent("TextMeshProUGUI").text = talkTab[i]
        end

        for i=1,#data.catList do
            local SickCatModule = data.catList[i]
            local obj = GameObject.Instantiate(self.item_cat,self.item_cat.transform.parent)
            obj:SetActive(true)
            self.catObjs[SickCatModule.catId] = obj
            self.UpdateCatState( SickCatModule )

            obj.transform:Find("btn_treatment_fee"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_treatment_fee"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                --click therapy
                self.ShowBoxHospitalMsg("Do you need to spend  <size=52><sprite=\""..SickCatModule.moneyType.."\" index=0></size>  "..SickCatModule.needMoney.." for  treatment?",function ( ... )
                    -- body
                    self.SendMsgSickTreatmentReq(SickCatModule,function ( data )
                        -- body
                        SickCatModule = data.catInfo
                        self.UpdateCatState( SickCatModule )
                    end)
                end)
            end)

            obj.transform:Find("btn_special_treatment"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_special_treatment"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                --click acceleration
                self.SendMsgTreatmentPriceReq(SickCatModule,function ( data )
                    -- body
                    self.ShowBoxHospitalMsg("Do you need to spend <size=52><sprite=\""..data.moneyType.."\" index=0></size>  "..data.needMoney.." for special treatment?",function ( ... )
                        -- body
                        self.SendMsgAccelerateTreatmentReq(SickCatModule,function ( data )
                            -- body
                            SickCatModule = data.catInfo
                            self.UpdateCatState( SickCatModule )
                        end)
                    end)
                end)
            end)

            obj.transform:Find("btn_take_home"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_take_home"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                obj:SetActive(false)
                --recycling cat
                self.SendMsgTakeItHomeReq(SickCatModule,function ( data )
                    -- body
                    MainStart.ShowCat( SickCatModule.catId )
                end)
            end)
        end
    end)
end

function HospitalView.UpdateCatState( SickCatModule )
    -- body
    local obj = self.catObjs[SickCatModule.catId]
    obj.transform:Find("text_cat_name"):GetComponent("TextMeshProUGUI").text = SickCatModule.name
    obj.transform:Find("text_level"):GetComponent("TextMeshProUGUI").text = "LV."..SickCatModule.level
    
    if(SickCatModule.hasTreat == 0) then
        obj.transform:Find("state_ill").gameObject:SetActive(true)
        obj.transform:Find("state_treat").gameObject:SetActive(false)
        obj.transform:Find("btn_treatment_fee").gameObject:SetActive(true)
        obj.transform:Find("btn_special_treatment").gameObject:SetActive(false)
        obj.transform:Find("btn_take_home").gameObject:SetActive(false)
        obj.transform:Find("text_cat_state"):GetComponent("TextMeshProUGUI").text = "Rehab countdown"
        SetItemSprite(SickCatModule.moneyType,obj.transform:Find("btn_treatment_fee/icon"))
        obj.transform:Find("btn_treatment_fee/text_treatment_fee"):GetComponent("TextMeshProUGUI").text = SickCatModule.needMoney
        obj.transform:Find("text_time"):GetComponent("TextMeshProUGUI").text = ""
    elseif(SickCatModule.hasTreat == 1) then
        obj.transform:Find("state_ill").gameObject:SetActive(false)
        obj.transform:Find("state_treat").gameObject:SetActive(true)
        obj.transform:Find("btn_treatment_fee").gameObject:SetActive(false)
        obj.transform:Find("btn_special_treatment").gameObject:SetActive(true)
        obj.transform:Find("btn_take_home").gameObject:SetActive(false)
        obj.transform:Find("text_cat_state"):GetComponent("TextMeshProUGUI").text = "Under Treatment"
        obj.transform:Find("text_time"):GetComponent("TextMeshProUGUI").text = self.TimeToString(SickCatModule.treatmentTime)
        Debug.LogError(SickCatModule.treatmentTime)
        TimeManager:StartTime("wait_treatment_"..SickCatModule.catId,0,1,false,function ( t )
            if(SickCatModule.treatmentTime - (t*1000) >= 0) then
                obj.transform:Find("text_time"):GetComponent("TextMeshProUGUI").text = self.TimeToString(SickCatModule.treatmentTime - (t*1000))
            else
                self.SendMsgSickCatInfoReq(SickCatModule)
            end
        end)
    elseif(SickCatModule.hasTreat == 2) then
        TimeManager:OverTime("wait_treatment_"..SickCatModule.catId)
        obj.transform:Find("state_ill").gameObject:SetActive(false)
        obj.transform:Find("state_treat").gameObject:SetActive(false)
        obj.transform:Find("btn_treatment_fee").gameObject:SetActive(false)
        obj.transform:Find("btn_special_treatment").gameObject:SetActive(false)
        obj.transform:Find("btn_take_home").gameObject:SetActive(true)
        obj.transform:Find("text_cat_state"):GetComponent("TextMeshProUGUI").text = "<color=#bfeeb9>Treatment completed</color>"  
        obj.transform:Find("text_time"):GetComponent("TextMeshProUGUI").text = ""
    end
end

function HospitalView.TimeToString( time )
    -- body
    local str = ""
    local dayNum = math.floor(time / (1000*60*60*24))
    local hourNum = math.floor(time / (1000*60*60) % 24)
    local minNum = math.floor(time / (1000*60) % 60)
    local secNum = math.floor(time / 1000 % 60)
    if(dayNum > 0) then
        str = str.."<color=#ffe296>"..dayNum.."</color> day "
    end
    if(hourNum > 0) then
        str = str.."<color=#ffe296>"..hourNum.."</color> hr "
    end
    if(minNum > 0) then
        str = str.."<color=#ffe296>"..minNum.."</color> min "
    end
    if(secNum > 0) then
        str = str.."<color=#ffe296>"..secNum.."</color> sec "
    end
    return str
end


function HospitalView.Quit( ... )
    -- body
    CS.RoleController.Instance.gameObject:SetActive(true)
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("bg_hospital")
    UIManager:DelUI("hospital_view")
end


function HospitalView.ShowBoxHospitalMsg(msg,okCallback,quitCallback)
    UIManager:ShowUIAsync("main","box_hospital_msg",nil,function ( obj )
        -- body
        obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = msg
        obj.transform:Find("btn_ok"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_ok"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            if(okCallback) then
                okCallback()
            end
            UIManager:DelUI("box_hospital_msg")
        end)
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            if(quitCallback) then
                quitCallback()
            end
            UIManager:DelUI("box_hospital_msg")
        end)
    end)
end

--start treatment
function HospitalView.SendMsgSickTreatmentReq( SickCatModule,callback )
    -- body
    local SickTreatmentReq = {}
    SickTreatmentReq.token = playerData.baseData.data.token
    SickTreatmentReq.catId = SickCatModule.catId
    PublicClient.SendMsgSickTreatmentReq(SickTreatmentReq,callback)
end

--accelerated treatment
function HospitalView.SendMsgAccelerateTreatmentReq( SickCatModule,callback )
    -- body
    local AccelerateTreatmentReq = {}
    AccelerateTreatmentReq.token = playerData.baseData.data.token
    AccelerateTreatmentReq.catId = SickCatModule.catId
    AccelerateTreatmentReq.dirtyMoney = SickCatModule.needMoney
    PublicClient.SendMsgAccelerateTreatmentReq(AccelerateTreatmentReq,callback)
end

--cat accelerated treatment price
function HospitalView.SendMsgTreatmentPriceReq( SickCatModule,callback )
    -- body
    local TreatmentPriceReq = {}
    TreatmentPriceReq.token = playerData.baseData.data.token
    TreatmentPriceReq.catId = SickCatModule.catId
    PublicClient.SendMsgTreatmentPriceReq(TreatmentPriceReq,callback)
end

--take him home from the hospital after treatment
function HospitalView.SendMsgTakeItHomeReq( SickCatModule,callback )
    -- body
    local TakeItHomeReq = {}
    TakeItHomeReq.token = playerData.baseData.data.token
    TakeItHomeReq.catIds = {SickCatModule.catId}
    PublicClient.SendMsgTakeItHomeReq(TakeItHomeReq,callback)
end

--sick cat details request
function HospitalView.SendMsgSickCatInfoReq( SickCatModule )
    -- body
    local SickCatInfoReq = {}
    SickCatInfoReq.token = playerData.baseData.data.token
    TakeItHomeReq.catId = SickCatModule.catId
    PublicClient.SendMsgSickCatInfoReq(SickCatInfoReq,function ( data )
        -- body
        self.UpdateCatState( data.catInfo )
    end)
end
