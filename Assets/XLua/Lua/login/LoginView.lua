
require "public/net/PublicClient" 

LoginView = {}
local self = LoginView
function LoginView.Start( ... )
    -- body
    LuaManager:DelChunk("main")
    LuaManager:DelChunk("game")
    -- self.btn_code:GetComponent("Button").onClick:AddListener(self.CodeClick)
    -- self.btn_register_ok:GetComponent("Button").onClick:AddListener(self.RegisterClick)
    -- self.btn_login:GetComponent("Button").onClick:AddListener(self.LoginClick)
    self.btn_visitor:GetComponent("Button").onClick:AddListener(self.VisitorClick)
    -- self.btn_choose_accout:GetComponent("Button").onClick:AddListener(self.ShowChooseUsers)

    -- self.users = PlayerPrefs.GetString("users")
    -- self.account:GetComponent("TMP_InputField").text = PlayerPrefs.GetString("curAccount")
    -- self.password:GetComponent("TMP_InputField").text = PlayerPrefs.GetString("curPassword")
end


function LoginView.ShowChooseUsers( ... )
    -- body
    self.panel_choose_accout:SetActive(true)
    self.userObjs = ClearObjs(self.userObjs)
    local userList = Split(self.users,",")
    for i = 1,#userList do
        if(userList[i] ~= "") then
            local obj = GameObject.Instantiate(self.item_account,self.item_account.transform.parent)
            obj:SetActive(true)
            obj.name = "user_"..i
            self.userObjs[i] = obj
            obj.transform:Find("text_user"):GetComponent("TextMeshProUGUI").text = userList[i]
            obj:GetComponent("Button").onClick:RemoveAllListeners()
            obj:GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.panel_choose_accout:SetActive(false)
                if(userList[i] ~= self.account:GetComponent("TMP_InputField").text) then
                    self.account:GetComponent("TMP_InputField").text = userList[i]
                    self.password:GetComponent("TMP_InputField").text = ""
                end
            end)
        end
    end

end

function LoginView.CodeClick( ... )
    -- body
    local email = self.register_account:GetComponent("TMP_InputField").text
    if(email == "") then
        MessageBox("TIPS","Email cannot be empty","OK")
        return
    end

    self.btn_code:GetComponent("Button").enabled = false
    self.text_sms:GetComponent("TextMeshProUGUI").text = "60s"
    TimeManager:StartTime("Code",0,1,true,function ( time )
        -- body
        local num = 60 - math.floor(time)
        self.text_sms:GetComponent("TextMeshProUGUI").text = num.."s"
        if(num <= 0) then
            TimeManager:OverTime("Code")
            self.btn_code:GetComponent("Button").enabled = true
            self.text_sms:GetComponent("TextMeshProUGUI").text = "Verification Code"
        end
    end)
end

function LoginView.RegisterClick( ... )
    -- body
    local ra = self.register_account:GetComponent("TMP_InputField").text
    if(ra == "") then
        MessageBox("TIPS","Email cannot be empty","OK")
        return
    end
    local rp = self.register_password:GetComponent("TMP_InputField").text
    if(rp == "") then
        MessageBox("TIPS","Password cannot be empty","OK")
        return
    end
    local rn = self.register_nickname:GetComponent("TMP_InputField").text
    if(rn == "") then
        MessageBox("TIPS","Nick name cannot be empty","OK")
        return
    end
    local rc = self.register_code:GetComponent("TMP_InputField").text
    if(rc == "") then
        MessageBox("TIPS","Verification code cannot be empty","OK")
        return
    end

    local form = CS.UnityEngine.WWWForm()
    form:AddField("email", ra)
    form:AddField("verificationCode", rc)
    form:AddField("userName", rn)
    form:AddField("deviceId", GameMaster.gameConfig.mac)
    form:AddField("password", rp)
    if(self.tog_male:GetComponent("Toggle").isOn) then
        form:AddField("sex", 1)
    else
        form:AddField("sex", 2)
    end
    
    PostMsg("register",form,function ( msg )
        -- body
        MessageBox("TIPS","Successfully registered account","OK")
        self.panel_register:SetActive(false)
        self.panel_login:SetActive(true)
        self.account:GetComponent("TMP_InputField").text = ra
        self.password:GetComponent("TMP_InputField").text = rp
    end,function ( msg )
        -- body
        MessageBox("TIPS",msg.msg,"OK",function ( ... )
            -- body
            self.btn_login:GetComponent("Button").enabled = true
        end)
    end)
end


function LoginView.LoginClick( ... )
    -- body
    Debug.Log("LoginClick")
 
    local en = self.account:GetComponent("TMP_InputField").text
    if(en == "") then
        MessageBox("TIPS","Email cannot be empty","OK")
        return
    end
    local pw = self.password:GetComponent("TMP_InputField").text
    if(pw == "") then
        MessageBox("TIPS","Password cannot be empty","OK")
        return
    end

    self.btn_login:GetComponent("Button").enabled = false
    local form = CS.UnityEngine.WWWForm()
    form:AddField("email", en)
    form:AddField("deviceId", GameMaster.gameConfig.mac)
    form:AddField("password", pw)
    form:AddField("fastLogin", "false")
    PostMsg("login",form,function ( msg )
        -- body
        PlayerPrefs.SetString("curAccount",en)
        PlayerPrefs.SetString("curPassword",pw)
        if(self.users ~= "") then
            local userList = Split(self.users,",")
            local flag = true
            for i,v in pairs(userList) do
                if(v == en) then
                    flag = false
                    break
                end
            end
            if(flag) then
                self.users = self.users..","..en
                PlayerPrefs.SetString("users",self.users)
            end
        else
            self.users = en
            PlayerPrefs.SetString("users",self.users)
        end
        LoginView.LoginSuccessful(msg)
        
    end,function ( msg )
        -- body
        MessageBox("TIPS",msg.msg,"OK",function ( ... )
            -- body
            self.btn_login:GetComponent("Button").enabled = true
        end)
    end)
end

local visitorMsg = "Some functions of fast login are restricted, and the account is in an unsafe state. Please bind your email as soon as possible after entering the game."
function LoginView.VisitorClick( ... )
    -- body
    -- MessageBox("TIPS",visitorMsg,"CONTINUE",function ( ... )
        
    -- end,"CANCEL")
    self.btn_visitor:GetComponent("Button").enabled = false
    -- self.btn_login:GetComponent("Button").enabled = false
    local form = CS.UnityEngine.WWWForm()
    form:AddField("deviceId", GameMaster.gameConfig.mac.."123456")
    form:AddField("fastLogin", "true")
    PostMsg("login",form,function ( msg )
        -- body
        LoginView.LoginSuccessful(msg)
    end,function ( msg )
        -- body
        MessageBox("TIPS",msg.msg,"OK",function ( ... )
            -- body
            self.btn_visitor:GetComponent("Button").enabled = true
            self.btn_login:GetComponent("Button").enabled = true
        end)
    end)
end



function LoginView.Update( ... )
    -- body
end


function LoginView.OnDestroy( ... )
    -- body
end


function LoginView.LoginSuccessful(msg)
    Debug.Log("LoginSuccessful")
    playerData.baseData = msg
    NetworkManager.userId = playerData.baseData.data.userId
    LoginView.EnterGame()
end


function LoginView.EnterGame( ... )
    -- body
    UIManager:ShowUIAsync("public","loading_view",nil,function ( ... )
        -- body
        UIManager:DelUI("bg_splash_loading")
        UIManager:DelUI("splash_loading")
        CS.LoadingView.Instance.endCallback = function ( ... )
            -- body
            UIManager:ShowUIAsync("main","main_view",nil,function ( ... )
                -- body
                UIManager:DelUI("loading_view")
                UIManager:DelUI("login_view")
            end)
        end
        
        StartSocket(function ( ... )
            -- body
            SceneLoadManager:ChangeScene("main","main")
        end)
    end)
    TimeManager:OverTime("Code")
    
end
