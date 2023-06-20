QuestionView = {}
local self = QuestionView

function QuestionView.Start( ... )
    -- body
    self.btn_quit_question_start:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit_question_start:GetComponent("Button").onClick:AddListener(self.DelUI)
    self.btn_quit_question_answer:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit_question_answer:GetComponent("Button").onClick:AddListener(self.HideUI)
    self.btn_question_result_ok:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_question_result_ok:GetComponent("Button").onClick:AddListener(self.DelUI)
    self.btn_quit_question_result:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit_question_result:GetComponent("Button").onClick:AddListener(self.DelUI)
    self.Init()
end



function QuestionView.Init( ... )
    -- body
    self.SendMsgStartAnswerReq()
end


function QuestionView.SendMsgStartAnswerReq( ... )
    -- body
    local StartAnswerReq = {}
    StartAnswerReq.token = playerData.baseData.data.token
    PublicClient.SendMsgStartAnswerReq(StartAnswerReq,function ( data )
        self.questionId = data.questionId
        self.questionList = data.questionList
        Debug.Log("data.answerStatus = "..data.answerStatus)
        if(data.answerStatus == 0) then
            self.question_start:SetActive(true)
            self.question_answer:SetActive(false)
            self.question_result:SetActive(false)
            self.btn_start_question:GetComponent("Button").onClick:RemoveAllListeners()
            self.btn_start_question:GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.ShowQuestion(1)
            end)
        elseif(data.answerStatus == 1) then
            self.ShowQuestion(data.finishCount + 1)
        elseif(data.answerStatus == 2) then
            self.question_start:SetActive(false)
            self.question_answer:SetActive(false)
            self.question_result:SetActive(true)
        end

    end)
end


--display problem（index）
function QuestionView.ShowQuestion( index )
    -- body
    self.question_start:SetActive(false)
    self.question_answer:SetActive(true)
    self.question_result:SetActive(false)
    self.questionIndex = index
    local QuestionModule = self.questionList[index]
    self.text_question_num:GetComponent("TextMeshProUGUI").text = "Q"..QuestionModule.orderNum
    self.text_question_msg:GetComponent("TextMeshProUGUI").text = QuestionModule.intro
    self.text_answer_1:GetComponent("TextMeshProUGUI").text = QuestionModule.optionA
    self.text_answer_2:GetComponent("TextMeshProUGUI").text = QuestionModule.optionB
    self.text_answer_3:GetComponent("TextMeshProUGUI").text = QuestionModule.optionC
    self.text_answer_4:GetComponent("TextMeshProUGUI").text = QuestionModule.optionD
    local tab = {"A","B","C","D"}

    local closeAllBtn = function ( ... )
        -- body
        for i=1,4 do
            local obj = self["btn_answer_"..i]
            obj:GetComponent("Button").enabled = false
        end
    end

    local openAllBtn = function ( ... )
        -- body
        for i=1,4 do
            local obj = self["btn_answer_"..i]
            obj:GetComponent("Button").enabled = true
        end
    end

    openAllBtn()
    for i=1,4 do
        local obj = self["btn_answer_"..i]
        obj.transform:Find("choose").gameObject:SetActive(false)
        obj.transform:Find("right").gameObject:SetActive(false)
        obj.transform:Find("wrong").gameObject:SetActive(false)
        if(tab[i] == QuestionModule.correntAnswer) then
            self.rightObj = obj
        end

        obj:GetComponent("Button").onClick:RemoveAllListeners()
        obj:GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            TimeManager:OverTime("AnswerTime")
            obj.transform:Find("choose").gameObject:SetActive(true)
            if(tab[i] == QuestionModule.correntAnswer) then
                Debug.Log("answer correctly")
                obj.transform:Find("right").gameObject:SetActive(true)
            else
                Debug.Log("wrong answer")
                obj.transform:Find("wrong").gameObject:SetActive(true)
                self.rightObj.transform:Find("choose").gameObject:SetActive(true)
                self.rightObj.transform:Find("right").gameObject:SetActive(true)
            end

            closeAllBtn()
            self.SendMsgSubmitQuestionReq(QuestionModule,tab[i],function ( data )
                -- body
                if(index < #self.questionList) then
                    Debug.Log("wait3seconds，let's move on to the next problem")
                    util.coroutine_call(function()
                        yield_return(WaitForSeconds(3))
                        self.ShowQuestion( index+1 )
                    end)()
                else
                    Debug.Log("answer all")
                    Debug.Log(data.rewardInfo)
                    self.ShowQuestionResult(data.rewardInfo)
                end
            end)
        end)

        --Dotweenanimation progress bar reduced
        self.progressTime = 0
        TimeManager:StartTime("AnswerTime",0,10,true,function ( t )
            Debug.Log("no answer at the time")
            closeAllBtn()
            self.SendMsgSubmitQuestionReq(QuestionModule,"",function ( data )
                -- body
                if(index < #self.questionList) then
                    Debug.Log("let's move on to the next problem")
                    self.ShowQuestion( index+1 )
                else
                    Debug.Log("answer all")
                    Debug.Log(data.rewardInfo)
                    self.ShowQuestionResult(data.rewardInfo)
                end
            end)
        end)

    end
end


function QuestionView.SendMsgSubmitQuestionReq( QuestionModule,chooseOption,callback )
    -- body
    local SubmitQuestionReq = {}
    SubmitQuestionReq.token = playerData.baseData.data.token
    SubmitQuestionReq.orderNum = QuestionModule.orderNum
    SubmitQuestionReq.chooseOption = chooseOption
    PublicClient.SendMsgSubmitQuestionReq(SubmitQuestionReq,function ( data )
        -- body
        Debug.Log("answer sent over")
        if(callback) then
            callback(data)
        end
    end)
end


function QuestionView.ShowQuestionResult( ... )
    -- body
    self.question_start:SetActive(false)
    self.question_answer:SetActive(false)
    self.question_result:SetActive(true)
end




function QuestionView.Update( ... )
    -- body
    if(self.progressTime ~= nil) then
        self.progressTime = self.progressTime + Time.deltaTime
        if(self.progressTime <= 10) then
            self.progress_question_time:GetComponent("Image").fillAmount = 1-(self.progressTime / 10)
        else
            self.progress_question_time:GetComponent("Image").fillAmount = 0
        end
    end
end


function QuestionView.OnDestroy( ... )
    -- body
    TimeManager:OverTime("AnswerTime")
    TimeManager:OverTime("next")
end



function QuestionView.HideUI( ... )
    -- body
    UIManager:HideUI("question_view")
end

function QuestionView.DelUI( ... )
    -- body
    UIManager:DelUI("question_view")
end
