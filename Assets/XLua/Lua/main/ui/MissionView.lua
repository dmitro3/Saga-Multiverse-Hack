MissionView = {}
local self = MissionView

function MissionView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    self.Init()
end


function MissionView.Init( ... )
    -- body
    self.SendMsgGetUserTaskReq()
end


function MissionView.SendMsgGetUserTaskReq( ... )
    -- body
    local GetUserTaskReq = {}
    GetUserTaskReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetUserTaskReq(GetUserTaskReq,function ( data )
        -- body
        self.ShowMissionMsgs(data.taskList)
    end)
end


function MissionView.ShowMissionMsgs( taskList )
    -- body
    self.taskObjs = ClearObjs(self.taskObjs)
    local allTaskNum = #taskList
    local finishTaskNum = 0
    for i=1,#taskList do
        local TaskModule = taskList[i]
        local taskData = task[TaskModule.taskId]
        if(taskData.type == 1) then
            local obj = GameObject.Instantiate(self.item_task,self.item_task.transform.parent)
            self.taskObjs[TaskModule.taskId] = obj
            obj:SetActive(true)
            obj.transform:Find("text_task_msg"):GetComponent("TextMeshProUGUI").text = taskData.intro
            obj.transform:Find("text_task_progress"):GetComponent("TextMeshProUGUI").text = "("..TaskModule.finishCount.."/"..TaskModule.sumCount..")"
            if(taskData.pic) then
                Debug.LogError(taskData.pic)
                PoolManager:SpawnAsync(taskData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    obj.transform:Find("icon_task"):GetComponent("Image").sprite = sprite
                end)
            end
            --whether the reward has been received 1is0no
            if(TaskModule.isReceived == 1) then
                --have received the award
                obj.transform:Find("icon_task").gameObject:SetActive(false)
                obj.transform:Find("task_finish").gameObject:SetActive(true)
                obj.transform:Find("btn_go_task").gameObject:SetActive(false)
                obj.transform:Find("btn_gift/flag_gift_ready").gameObject:SetActive(false)
                obj.transform:Find("btn_gift/flag_gift_received").gameObject:SetActive(true)
                --obj.transform:Find("btn_gift"):GetComponent("Button").onClick:RemoveAllListeners()
                obj.transform:Find("btn_go_task"):GetComponent("Button").onClick:RemoveAllListeners()
                local PointerDown = obj.transform:Find("btn_gift"):GetComponent("EventTrigger").triggers[0]
                PointerDown.callback:RemoveAllListeners()
                local PointerUp = obj.transform:Find("btn_gift"):GetComponent("EventTrigger").triggers[1]
                PointerUp.callback:RemoveAllListeners()
            else

                local PointerDown = obj.transform:Find("btn_gift"):GetComponent("EventTrigger").triggers[0]
                PointerDown.callback:RemoveAllListeners()
                local PointerUp = obj.transform:Find("btn_gift"):GetComponent("EventTrigger").triggers[1]
                PointerUp.callback:RemoveAllListeners()

                if(TaskModule.finishCount >= TaskModule.sumCount) then
                    --he did not accept the prize
                    finishTaskNum = finishTaskNum + 1
                    obj.transform:Find("icon_task").gameObject:SetActive(true)
                    obj.transform:Find("task_finish").gameObject:SetActive(false)
                    obj.transform:Find("btn_go_task").gameObject:SetActive(false)
                    obj.transform:Find("btn_gift/flag_gift_ready").gameObject:SetActive(true)
                    obj.transform:Find("btn_gift/flag_gift_received").gameObject:SetActive(false)
                    PointerDown.callback:AddListener(function ( ... )
                        -- body
                        self.SendMsgFinishTaskReq(TaskModule)
                    end)
                    
                else
                    --unfinished task
                    obj.transform:Find("icon_task").gameObject:SetActive(true)
                    obj.transform:Find("task_finish").gameObject:SetActive(false)
                    obj.transform:Find("btn_go_task").gameObject:SetActive(true)
                    obj.transform:Find("btn_gift/flag_gift_ready").gameObject:SetActive(false)
                    obj.transform:Find("btn_gift/flag_gift_received").gameObject:SetActive(false)
                    obj.transform:Find("btn_go_task"):GetComponent("Button").onClick:RemoveAllListeners()
                    obj.transform:Find("btn_go_task"):GetComponent("Button").onClick:AddListener(function ( ... )
                        -- body
                        self.OnClickGo(taskData.goTo)
                    end)
                    PointerDown.callback:AddListener(function ( ... )
                        self.panel_award:SetActive(true)
                        self.panel_award.transform.position = obj.transform:Find("btn_gift").transform.position
                        self.awardObjs = ClearObjs(self.awardObjs)
                        self.ShowGiftAward(taskData.reward)
                    end)
                    PointerUp.callback:AddListener(function ( ... )
                        self.panel_award:SetActive(false)
                    end)
                end
            end
        elseif(taskData.type == 2) then
            --general task
            self.TotalGiftPointerDown = self.btn_total_gift:GetComponent("EventTrigger").triggers[0]
            self.TotalGiftPointerDown.callback:RemoveAllListeners()
            self.TotalGiftPointerUp = self.btn_total_gift:GetComponent("EventTrigger").triggers[1]
            self.TotalGiftPointerUp.callback:RemoveAllListeners()

            if(TaskModule.isReceived == 1) then
                self.flag_total_gift_received:SetActive(true)
                self.flag_total_gift_ready:SetActive(false)
            else
                if(finishTaskNum >= allTaskNum) then
                    self.flag_total_gift_received:SetActive(false)
                    self.flag_total_gift_ready:SetActive(true)
                    self.TotalGiftPointerDown.callback:AddListener(function ( ... )
                        -- body
                        self.SendMsgFinishTaskReq(TaskModule)
                    end)
                else
                    self.flag_total_gift_received:SetActive(false)
                    self.flag_total_gift_ready:SetActive(false)
                    self.TotalGiftPointerDown.callback:AddListener(function ( ... )
                        self.panel_award:SetActive(true)
                        self.panel_award.transform.localPosition = Vector3.zero
                        self.awardObjs = ClearObjs(self.awardObjs)
                        self.ShowGiftAward(taskData.reward)
                    end)
                    self.TotalGiftPointerUp.callback:AddListener(function ( ... )
                        self.panel_award:SetActive(false)
                    end)
                end
            end
        end
    end
    self.text_finish:GetComponent("TextMeshProUGUI").text = "Completion: "..tostring(math.floor(finishTaskNum/allTaskNum * 100)).."%"
    self.progress_finish:GetComponent("Slider").value = finishTaskNum/allTaskNum
    

end


function MissionView.ShowGiftAward( reward )
    -- body
    
    if(reward[1] == 1 or reward[1] == 2) then
        local itemData = item[reward[2]]
        local obj = GameObject.Instantiate(self.item_award,self.item_award.transform.parent)
        self.awardObjs[reward[2]] = obj
        obj:SetActive(true)
        PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
        end)
        obj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = reward[3]
    elseif(reward[1] == 3) then
    elseif(reward[1] == 4) then
    else
        for i=1,#reward do
            self.ShowGiftAward(reward[i])
        end
    end
end



function MissionView.Update( ... )
    -- body
end


function MissionView.OnDestroy( ... )
    -- body
end


function MissionView.Quit( ... )
    -- body
    UIManager:DelUI("mission_view")

end


function MissionView.SendMsgFinishTaskReq( TaskModule )
    -- body
    local FinishTaskReq = {}
    FinishTaskReq.token = playerData.baseData.data.token
    FinishTaskReq.taskId = TaskModule.taskId
    PublicClient.SendMsgFinishTaskReq(FinishTaskReq,function ( data )
        -- body
        --display get item interface
        --（complete）refresh task
        local obj = self.taskObjs[TaskModule.taskId]
        obj.transform:Find("icon_task").gameObject:SetActive(false)
        obj.transform:Find("task_finish").gameObject:SetActive(true)
        obj.transform:Find("btn_go_task").gameObject:SetActive(false)
        obj.transform:Find("btn_gift/flag_gift_ready").gameObject:SetActive(false)
        obj.transform:Find("btn_gift/flag_gift_received").gameObject:SetActive(true)
        -- obj.transform:Find("btn_gift"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_go_task"):GetComponent("Button").onClick:RemoveAllListeners()

        UIManager:ShowUIAsync("main","box_receive_result",nil,function ( ... )
            -- body
            BoxReceiveResult.ShowReceivePropsModule(data.pmList)
        end)

    end)
end


function MissionView.OnClickGo( tab )
    -- body
    local str = tab[1]
    if(str == "answer") then
        UIManager:ShowUIAsync("main","question_view")
        UIManager:DelUI("mission_view")
    elseif(str == "mint") then

    elseif(str == "luckyBag") then

    elseif(str == "food") then
        UIManager:ShowUIAsync("main","cat_bowl_view",nil,function ( ... )
            -- body
            UIManager:HideUI("main_view")
            UIManager:DelUI("mission_view")
        end)

    elseif(str == "toilet") then
        UIManager:ShowUIAsync("main","cat_toilet_view",nil,function ( ... )
            -- body
            UIManager:HideUI("main_view")
            UIManager:DelUI("mission_view")
        end)
    elseif(str == "tips") then
        MessageBox("TIPS",tab[2],"OK",function ( ... )
            -- body
            UIManager:DelUI("mission_view")
        end)
    elseif(str == "catAttribute") then
        UIManager:ShowUIAsync("main","cat_msg_view",nil,function ( ... )
            -- body
            CS.RoleController.Instance.gameObject:SetActive(false)
            UIManager:HideUI("main_view")
            UIManager:DelUI("mission_view")
        end)

    elseif(str == "shop") then
        UIManager:ShowUIAsync("main","shop_view",nil,function ( ... )
            -- body
            CS.RoleController.Instance.gameObject:SetActive(false)
            UIManager:HideUI("main_view")
            UIManager:DelUI("mission_view")
        end)
    end
end
