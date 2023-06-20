PublicClient = {}
local self = PublicClient
self.isConnect = false
self.GetPlayerDataCallback = nil

function PublicClient.Connect(ip,port,callback)
    -- body
    self.OnConnectCallBack = callback
    if(not self.isConnect) then
        CS.GameLoading.Instance:Show()
        LoadPB("client")
        self.ip = ip
        self.port = port
        self.keepConnect = true
        NetworkManager:AddSocket("PublicClient", self.GetMsg)
        NetworkManager:SendConnect("PublicClient",ip,port)
    end
end

function PublicClient.OnConnect( ... )
    -- body
    CS.GameLoading.Instance:Hide()
    print("PublicClient link success")
    self.isConnect = true
    if(self.LoginReq) then
        self.Login()
    elseif(self.OnConnectCallBack) then
        self.OnConnectCallBack()
    end
end

function PublicClient.OnDisconnected(id)
    -- body
    print("PublicClient disconnect")
    self.Close()
    if(self.keepConnect) then
        self.ReConnect()
    else
        CS.GameLoading.Instance:Hide()
    end
end



function PublicClient.Close()
    -- body
    CS.GameLoading.Instance:Show(true)
    self.isConnect = false
    NetworkManager:DelSocket("PublicClient")
    TimeManager:OverTime("PublicClient")
    TimeManager:OverTime("SendPublicClient")
end


function PublicClient.ReConnect()
    -- body
    if(not self.reConnectNum) then
        self.reConnectNum = 0
    end
    self.reConnectNum = self.reConnectNum + 1
    print("PublicClient number of reconnections = "..self.reConnectNum)
    TimeManager:StartTime("PublicClientReConnect"..self.reConnectNum,0,5,true,function ( time )
        -- body
        self.Connect(self.ip,self.port)
        TimeManager:OverTime("PublicClientReConnect"..self.reConnectNum)
    end)
end



function PublicClient.Login( callback )
    
    if(self.LoginReq == nil) then
        self.LoginReq = {}
        self.LoginReq.token = playerData.baseData.data.token
        self.LoginReq.version_id = ""
    end
    local bytes = assert(pb.encode("LoginReq", self.LoginReq))
    NetworkManager:SendMessage("PublicClient",pb.enum("CS","LOGIN_REQ"),0,bytes)

end

--heartbeat
function  PublicClient.SendKeepAlive()
    -- body
    if(not self.isConnect) then
        Debug.LogWarning("PublicClient OnDisconnected")
        return
    end
    

    NetworkManager:SendMessage("PublicClient",pb.enum("CS","HEARTBEAT_REQ"),0,"")
end


function PublicClient.StartKeepAlive( ... )
    -- body
    TimeManager:StartTime("PublicClient",0,5,true,function ( time )
        -- body
        if(self.isConnect) then
            self.SendKeepAlive()
        else
            TimeManager:OverTime("PublicClient")
        end
    end)
end


--gets the current backend timestamp
function PublicClient.SendMsgGetNowTimeReq(callback)
    -- body
    local GetNowTimeReq = {}
    GetNowTimeReq.token = playerData.baseData.data.token
    local bytes = self.SetMsg("GetNowTimeReq",GetNowTimeReq,callback)
    NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETNOWTIME_REQ"),0,bytes)
end
--user logout request  LOGOUT_REQ
function PublicClient.SendMsgLogoutReq( tab,callback )
	local bytes = self.SetMsg("LogoutReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","LOGOUT_REQ"),0,bytes)
end
--get user information request GETUSERINFO_REQ
function PublicClient.SendMsgGetUserInfoReq( tab,callback )
	local bytes = self.SetMsg("GetUserInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETUSERINFO_REQ"),0,bytes)
end
--modify a user information request UPUSERINFO_REQ
function PublicClient.SendMsgUpUserInfoReq( tab,callback )
	local bytes = self.SetMsg("UpUserInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","UPUSERINFO_REQ"),0,bytes)
end
--get the cat list request GETUSERCATLIST_REQ
function PublicClient.SendMsgGetUserCatListReq( tab,callback )
	local bytes = self.SetMsg("GetUserCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETUSERCATLIST_REQ"),0,bytes)
end
--obtain cat request GETCAT_REQ
function PublicClient.SendMsgGetCatReq( tab,callback )
	local bytes = self.SetMsg("GetCatReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCAT_REQ"),0,bytes)
end
--cat detail request CATINFO_REQ
function PublicClient.SendMsgCatInfoReq( tab,callback )
	local bytes = self.SetMsg("CatInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATINFO_REQ"),0,bytes)
end
--user backpack request USERITEM_REQ
function PublicClient.SendMsgUserItemReq( tab,callback )
	local bytes = self.SetMsg("UserItemReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","USERITEM_REQ"),0,bytes)
end
--gets all of the user's tool requests GETUSERTOOLS_REQ
function PublicClient.SendMsgGetUserToolsReq( tab,callback )
	local bytes = self.SetMsg("GetUserToolsReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETUSERTOOLS_REQ"),0,bytes)
end
--obtain a request for litter information GETCATHOUSEINFO_REQ
function PublicClient.SendMsgGetCatHouseInfoReq( tab,callback )
	local bytes = self.SetMsg("GetCatHouseInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATHOUSEINFO_REQ"),0,bytes)
end
--obtain cat box information request GETCATBOWLINFO_REQ
function PublicClient.SendMsgGetCatBowlInfoReq( tab,callback )
	local bytes = self.SetMsg("GetCatBowlInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATBOWLINFO_REQ"),0,bytes)
end
--obtain cat basin cabinet information request GETCATWATERINFO_REQ
function PublicClient.SendMsgGetCatWaterInfoReq( tab,callback )
	local bytes = self.SetMsg("GetCatWaterInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATWATERINFO_REQ"),0,bytes)
end
--get a cat toilet information request GETCATTOILETINFO_REQ
function PublicClient.SendMsgGetCatToiletInfoReq( tab,callback )
	local bytes = self.SetMsg("GetCatToiletInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATTOILETINFO_REQ"),0,bytes)
end
--obtain the request for information about the cat scratching board GETCATBOARDINFO_REQ
function PublicClient.SendMsgGetCatBoardInfoReq( tab,callback )
	local bytes = self.SetMsg("GetCatBoardInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATBOARDINFO_REQ"),0,bytes)
end
--the cat triggers a feeding request CATEAT_REQ
function PublicClient.SendMsgCatEatReq( tab,callback )
	local bytes = self.SetMsg("CatEatReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATEAT_REQ"),0,bytes)
end
--cat triggers water request CATDRINK_REQ
function PublicClient.SendMsgCatDrinkReq( tab,callback )
	local bytes = self.SetMsg("CatDrinkReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATDRINK_REQ"),0,bytes)
end
--cat triggers defecation request CATCACTTION_REQ
function PublicClient.SendMsgCatCacationReq( tab,callback )
	local bytes = self.SetMsg("CatCacationReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATCACTTION_REQ"),0,bytes)
end
--cat triggers licking body request CATCLEANBODY_REQ
function PublicClient.SendMsgCatCleanBodyReq( tab,callback )
	local bytes = self.SetMsg("CatCleanBodyReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATCLEANBODY_REQ"),0,bytes)
end
--cat triggers sleep request CATSLEEP_REQ
function PublicClient.SendMsgCatSleepReq( tab,callback )
	local bytes = self.SetMsg("CatSleepReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATSLEEP_REQ"),0,bytes)
end
--the cat triggered the scratching board request CATSCRATCHINGPOST_REQ
function PublicClient.SendMsgCatScratchingPostReq( tab,callback )
	local bytes = self.SetMsg("CatScratchingPostReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATSCRATCHINGPOST_REQ"),0,bytes)
end
--cat triggers sick determination request CATSICKJUDGE_REQ
function PublicClient.SendMsgCatSickJudgeReq( tab,callback )
	local bytes = self.SetMsg("CatSickJudgeReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATSICKJUDGE_REQ"),0,bytes)
end
--GMcommand request GMCODE_REQ
function PublicClient.SendMsgGMCodeReq( tab,callback )
	local bytes = self.SetMsg("GMCodeReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GMCODE_REQ"),0,bytes)
end
--use item request USEPROPS_REQ
function PublicClient.SendMsgUsePropsReq( tab,callback )
	local bytes = self.SetMsg("UsePropsReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","USEPROPS_REQ"),0,bytes)
end
--housekeeping request CLEANTOILET_REQ
function PublicClient.SendMsgCleanToiletReq( tab,callback )
	local bytes = self.SetMsg("CleanToiletReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CLEANTOILET_REQ"),0,bytes)
end
--add a water request to the basin cabinet ADDWATER_REQ
function PublicClient.SendMsgAddWaterReq( tab,callback )
	local bytes = self.SetMsg("AddWaterReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ADDWATER_REQ"),0,bytes)
end
--fixed cat scratch board durability request REPAIRBOARD_REQ
function PublicClient.SendMsgRepairBoardReq( tab,callback )
	local bytes = self.SetMsg("RepairBoardReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REPAIRBOARD_REQ"),0,bytes)
end
--upgrade cat request UPCATLEVEL_REQ
function PublicClient.SendMsgUpCatLevelReq( tab,callback )
	local bytes = self.SetMsg("UpCatLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","UPCATLEVEL_REQ"),0,bytes)
end
--obtain cat food warehouse request GETCATFOODWAREHOUSE_REQ
function PublicClient.SendMsgGetCatFoodWareHouseReq( tab,callback )
	local bytes = self.SetMsg("GetCatFoodWareHouseReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATFOODWAREHOUSE_REQ"),0,bytes)
end
--get the litter warehouse request GETCATLITTERWAREHOUSE_REQ
function PublicClient.SendMsgGetCatLitterWareHouseReq( tab,callback )
	local bytes = self.SetMsg("GetCatLitterWareHouseReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCATLITTERWAREHOUSE_REQ"),0,bytes)
end
--add cat food request REPLENISHCATFOOD_REQ
function PublicClient.SendMsgReplenishCatFoodReq( tab,callback )
	local bytes = self.SetMsg("ReplenishCatFoodReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REPLENISHCATFOOD_REQ"),0,bytes)
end
--add kitty litter request REPLENISHCATLITTER_REQ
function PublicClient.SendMsgReplenishCatLitterReq( tab,callback )
	local bytes = self.SetMsg("ReplenishCatLitterReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REPLENISHCATLITTER_REQ"),0,bytes)
end
--cat handling request STROKECAT_REQ
function PublicClient.SendMsgStrokeCatReq( tab,callback )
	local bytes = self.SetMsg("StrokeCatReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","STROKECAT_REQ"),0,bytes)
end
--get the intimacy claim rule request GETINTIMACYREWARD_REQ
function PublicClient.SendMsgGetIntimacyRewardReq( tab,callback )
	local bytes = self.SetMsg("GetIntimacyRewardReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETINTIMACYREWARD_REQ"),0,bytes)
end
--get the intimacy reward request RECEIVEINTIMACYREWARD_REQ
function PublicClient.SendMsgReceiveIntimacyRewardReq( tab,callback )
	local bytes = self.SetMsg("ReceiveIntimacyRewardReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","RECEIVEINTIMACYREWARD_REQ"),0,bytes)
end
--item list request PRODUCTLIST_REQ
function PublicClient.SendMsgProducListReq( tab,callback )
	local bytes = self.SetMsg("ProducListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PRODUCTLIST_REQ"),0,bytes)
end
--purchase request BUYGOODS_REQ
function PublicClient.SendMsgBuyGoodsReq( tab,callback )
	local bytes = self.SetMsg("BuyGoodsReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","BUYGOODS_REQ"),0,bytes)
end
--cat basin upgrade request WATERUPLEVEL_REQ
function PublicClient.SendMsgWaterUpLevelReq( tab,callback )
	local bytes = self.SetMsg("WaterUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","WATERUPLEVEL_REQ"),0,bytes)
end
--upgrade request of the cat scratch board BOARDUPLEVEL_REQ
function PublicClient.SendMsgBoardUpLevelReq( tab,callback )
	local bytes = self.SetMsg("BoardUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","BOARDUPLEVEL_REQ"),0,bytes)
end
--cat box upgrade request BOWLUPLEVEL_REQ
function PublicClient.SendMsgBowlUpLevelReq( tab,callback )
	local bytes = self.SetMsg("BowlUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","BOWLUPLEVEL_REQ"),0,bytes)
end
--cat toilet upgrade request TOILETUPLEVEL_REQ
function PublicClient.SendMsgToiletUpLevelReq( tab,callback )
	local bytes = self.SetMsg("ToiletUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","TOILETUPLEVEL_REQ"),0,bytes)
end
--kitty upgrade request HOUSEUPLEVEL_REQ
function PublicClient.SendMsgHouseUpLevelReq( tab,callback )
	local bytes = self.SetMsg("HouseUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","HOUSEUPLEVEL_REQ"),0,bytes)
end
--equipment fragment exchange request EXCHANGEAVATAR_REQ
function PublicClient.SendMsgExchangeAvatarReq( tab,callback )
	local bytes = self.SetMsg("ExchangeAvatarReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","EXCHANGEAVATAR_REQ"),0,bytes)
end
--user equipment list request USERAVATARLIST_REQ
function PublicClient.SendMsgUserAvatarListReq( tab,callback )
	local bytes = self.SetMsg("UserAvatarListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","USERAVATARLIST_REQ"),0,bytes)
end
--request for wearing equipment WEARAVATAR_REQ
function PublicClient.SendMsgWearAvatarReq( tab,callback )
	local bytes = self.SetMsg("WearAvatarReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","WEARAVATAR_REQ"),0,bytes)
end
--unloading request REMOVINGAVATAR_REQ
function PublicClient.SendMsgRemovingAvatarReq( tab,callback )
	local bytes = self.SetMsg("RemovingAvatarReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REMOVINGAVATAR_REQ"),0,bytes)
end
--request for upgrading cat poop capacity CATEXCREMENTUPLEVEL_REQ
function PublicClient.SendMsgCatExcrementUpLevelReq( tab,callback )
	local bytes = self.SetMsg("CatExcrementUpLevelReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATEXCREMENTUPLEVEL_REQ"),0,bytes)
end
--empty cat toilet cat poop request CLEANCATEXCREMENT_REQ
function PublicClient.SendMsgCleanExcrementReq( tab,callback )
	local bytes = self.SetMsg("CleanExcrementReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CLEANCATEXCREMENT_REQ"),0,bytes)
end
--use the cat prop request CATPLAY_REQ
function PublicClient.SendMsgCatPlayReq( tab,callback )
	local bytes = self.SetMsg("CatPlayReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATPLAY_REQ"),0,bytes)
end
--smell、hand licking、rub one's feet、stomp request CATACTION_REQ
function PublicClient.SendMsgCatActionReq( tab,callback )
	local bytes = self.SetMsg("CatActionReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATACTION_REQ"),0,bytes)
end
--cats increase or decrease health requests  CATCHANGEHEALTH_REQ
function PublicClient.SendMsgCatChangeHealthReq( tab,callback )
	local bytes = self.SetMsg("CatChangeHealthReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATCHANGEHEALTH_REQ"),0,bytes)
end
--obtain the daily task request of the current user  GETUSERTASK_REQ
function PublicClient.SendMsgGetUserTaskReq( tab,callback )
	local bytes = self.SetMsg("GetUserTaskReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETUSERTASK_REQ"),0,bytes)
end
--complete task request  FINISHTASK_REQ
function PublicClient.SendMsgFinishTaskReq( tab,callback )
	local bytes = self.SetMsg("FinishTaskReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","FINISHTASK_REQ"),0,bytes)
end
--answer request  STARTANSWER_REQ
function PublicClient.SendMsgStartAnswerReq( tab,callback )
	local bytes = self.SetMsg("StartAnswerReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","STARTANSWER_REQ"),0,bytes)
end
--submit answer request  SUBMITQUESTION_REQ
function PublicClient.SendMsgSubmitQuestionReq( tab,callback )
	local bytes = self.SetMsg("SubmitQuestionReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SUBMITQUESTION_REQ"),0,bytes)
end
--list of cats admitted to the hospital SICKCATLIST_REQ
function PublicClient.SendMsgSickCatListReq( tab,callback )
	local bytes = self.SetMsg("SickCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SICKCATLIST_REQ"),0,bytes)
end
--a request for treatment of illness SICKTREATMENT_REQ
function PublicClient.SendMsgSickTreatmentReq( tab,callback )
	local bytes = self.SetMsg("SickTreatmentReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SICKTREATMENT_REQ"),0,bytes)
end
--accelerated recovery request ACCELERATETREATMENT_REQ
function PublicClient.SendMsgAccelerateTreatmentReq( tab,callback )
	local bytes = self.SetMsg("AccelerateTreatmentReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ACCELERATETREATMENT_REQ"),0,bytes)
end
--user lifting cat item list request STROKECATITEM_REQ
function PublicClient.SendMsgStrokeCatItemReq( tab,callback )
	local bytes = self.SetMsg("StrokeCatItemReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","STROKECATITEM_REQ"),0,bytes)
end
--recycle to shelter request RECOVERSHELTER_REQ
function PublicClient.SendMsgRecoverShelterReq( tab,callback )
	local bytes = self.SetMsg("RecoverShelterReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","RECOVERSHELTER_REQ"),0,bytes)
end
--a list of cat requests to be redeemed REDEEMCATLIST_REQ
function PublicClient.SendMsgRedeemCatListReq( tab,callback )
	local bytes = self.SetMsg("RedeemCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REDEEMCATLIST_REQ"),0,bytes)
end
--request for redemption of shelter cat REDEEM_REQ
function PublicClient.SendMsgRedeemReq( tab,callback )
	local bytes = self.SetMsg("RedeemReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","REDEEM_REQ"),0,bytes)
end
--shelf cat request PUTONSHELVE_REQ
function PublicClient.SendMsgPutonShelveReq( tab,callback )
	local bytes = self.SetMsg("PutonShelveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PUTONSHELVE_REQ"),0,bytes)
end
--remove the cat request LOWERSHELVE_REQ
function PublicClient.SendMsgLowerShelveReq( tab,callback )
	local bytes = self.SetMsg("LowerShelveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","LOWERSHELVE_REQ"),0,bytes)
end
--request for cats listed at the current user's shelter PSCATSLISTBYUSER_REQ
function PublicClient.SendMsgPsCatListByUserReq( tab,callback )
	local bytes = self.SetMsg("PsCatListByUserReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PSCATSLISTBYUSER_REQ"),0,bytes)
end
--cat list requests from all users of the shelter PSCATSLIST_REQ
function PublicClient.SendMsgPsCatListReq( tab,callback )
	local bytes = self.SetMsg("PsCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PSCATSLIST_REQ"),0,bytes)
end
--shelter cat adoption request ADOPTCAT_REQ
function PublicClient.SendMsgAdoptCatReq( tab,callback )
	local bytes = self.SetMsg("AdoptCatReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ADOPTCAT_REQ"),0,bytes)
end
--reduce health request after illness SICKREDUCTHEALTH_REQ
function PublicClient.SendMsgSickReductHealthReq( tab,callback )
	local bytes = self.SetMsg("SickReductHealthReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SICKREDUCTHEALTH_REQ"),0,bytes)
end
--hospital request SENDTOHOSPITAL_REQ
function PublicClient.SendMsgSendToHospitalReq( tab,callback )
	local bytes = self.SetMsg("SendToHospitalReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SENDTOHOSPITAL_REQ"),0,bytes)
end
--request to take home from hospital after treatment is completed TAKEITHOME_REQ
function PublicClient.SendMsgTakeItHomeReq( tab,callback )
	local bytes = self.SetMsg("TakeItHomeReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","TAKEITHOME_REQ"),0,bytes)
end
--cat accelerated cure price request TREATMENTPRICE_REQ
function PublicClient.SendMsgTreatmentPriceReq( tab,callback )
	local bytes = self.SetMsg("TreatmentPriceReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","TREATMENTPRICE_REQ"),0,bytes)
end
--item recovery request RECYCLEPROPS_REQ
function PublicClient.SendMsgRecyclePropsReq( tab,callback )
	local bytes = self.SetMsg("RecyclePropsReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","RECYCLEPROPS_REQ"),0,bytes)
end
--user's vegetable patch list request USERFIELDLIST_REQ
function PublicClient.SendMsgUserFieldListReq( tab,callback )
	local bytes = self.SetMsg("UserFieldListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","USERFIELDLIST_REQ"),0,bytes)
end
--request for a vegetable plot UNLOCKFIELD_REQ
function PublicClient.SendMsgUnLockFieldReq( tab,callback )
	local bytes = self.SetMsg("UnLockFieldReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","UNLOCKFIELD_REQ"),0,bytes)
end
--user-owned torrent list requests USERSEED_REQ
function PublicClient.SendMsgUserSeedReq( tab,callback )
	local bytes = self.SetMsg("UserSeedReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","USERSEED_REQ"),0,bytes)
end
--seed request SEED_REQ
function PublicClient.SendMsgSeedReq( tab,callback )
	local bytes = self.SetMsg("SeedReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SEED_REQ"),0,bytes)
end
--offensive cat list request ATTACKCATLIST_REQ
function PublicClient.SendMsgAttackCatListReq( tab,callback )
	local bytes = self.SetMsg("AttackCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ATTACKCATLIST_REQ"),0,bytes)
end
--request for attack ATTACK_REQ
function PublicClient.SendMsgAttackReq( tab,callback )
	local bytes = self.SetMsg("AttackReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ATTACK_REQ"),0,bytes)
end
--defensive cat list request DEFENSECATLIST_REQ
function PublicClient.SendMsgDefenseCatListReq( tab,callback )
	local bytes = self.SetMsg("DefenseCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","DEFENSECATLIST_REQ"),0,bytes)
end
--defensive call DEFENSE_REQ
function PublicClient.SendMsgDefenseReq( tab,callback )
	local bytes = self.SetMsg("DefenseReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","DEFENSE_REQ"),0,bytes)
end
--stealing catgrass reward claim request ATTACKRECEIVE_REQ
function PublicClient.SendMsgAttackReceiveReq( tab,callback )
	local bytes = self.SetMsg("AttackReceiveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ATTACKRECEIVE_REQ"),0,bytes)
end
--sick cat details request SICKCATINFO_REQ
function PublicClient.SendMsgSickCatInfoReq( tab,callback )
	local bytes = self.SetMsg("SickCatInfoReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","SICKCATINFO_REQ"),0,bytes)
end
--recovery request  PICKUP_REQ
function PublicClient.SendMsgPickUpReq( tab,callback )
	local bytes = self.SetMsg("PickUpReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PICKUP_REQ"),0,bytes)
end
--gets user cooling request for cat handling   GETCOOLING_REQ
function PublicClient.SendMsgGetCoolingReq( tab,callback )
	local bytes = self.SetMsg("GetCoolingReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","GETCOOLING_REQ"),0,bytes)
end
--multiple cats attack request MOSTATTACK_REQ
function PublicClient.SendMsgMostAttackReq( tab,callback )
	local bytes = self.SetMsg("MostAttackReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MOSTATTACK_REQ"),0,bytes)
end
--get the playground cat list request PLAYGROUNDCATLIST_REQ
function PublicClient.SendMsgPlayGroundCatListReq( tab,callback )
	local bytes = self.SetMsg("PlayGroundCatListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PLAYGROUNDCATLIST_REQ"),0,bytes)
end
--make a request for fun activities PLAYGROUND_REQ
function PublicClient.SendMsgPlayGroundReq( tab,callback )
	local bytes = self.SetMsg("PlayGroundReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PLAYGROUND_REQ"),0,bytes)
end
--playground award claim request PLAYGROUNDRECEIVE_REQ
function PublicClient.SendMsgPlayGroundReceiveReq( tab,callback )
	local bytes = self.SetMsg("PlayGroundReceiveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PLAYGROUNDRECEIVE_REQ"),0,bytes)
end
--multiple cats to participate in playground activities request MOSTPLAYGROUND_REQ
function PublicClient.SendMsgMostPlayGroundReq( tab,callback )
	local bytes = self.SetMsg("MostPlayGroundReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MOSTPLAYGROUND_REQ"),0,bytes)
end
--playground reward history request PLAYGROUNDHISTORY_REQ
function PublicClient.SendMsgPlayGroundHistoryReq( tab,callback )
	local bytes = self.SetMsg("PlayGroundHistoryReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PLAYGROUNDHISTORY_REQ"),0,bytes)
end
--mailing list request MAIL_LIST_REQ
function PublicClient.SendMsgMailListReq( tab,callback )
	local bytes = self.SetMsg("MailListReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MAIL_LIST_REQ"),0,bytes)
end
--mail collection request MAIL_RECEIVE_REQ
function PublicClient.SendMsgMailReceiveReq( tab,callback )
	local bytes = self.SetMsg("MailReceiveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MAIL_RECEIVE_REQ"),0,bytes)
end
--mail read request MAIL_READ_REQ
function PublicClient.SendMsgMailReadReq( tab,callback )
	local bytes = self.SetMsg("MailReadReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MAIL_READ_REQ"),0,bytes)
end
--mail deletion request MAIL_DELETE_REQ
function PublicClient.SendMsgMailDeleteReq( tab,callback )
	local bytes = self.SetMsg("MailDeleteReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","MAIL_DELETE_REQ"),0,bytes)
end
--cooldown request using the cat lift item CATPLAY_COOLING_REQ
function PublicClient.SendMsgCatPlayCoolingReq( tab,callback )
	local bytes = self.SetMsg("CatPlayCoolingReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","CATPLAY_COOLING_REQ"),0,bytes)
end
--shelter statistics request PS_STATISTICS_REQ
function PublicClient.SendMsgPsStatisticsReq( tab,callback )
	local bytes = self.SetMsg("PsStatisticsReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","PS_STATISTICS_REQ"),0,bytes)
end
--playground rewards one-click claim request ALLPLAYGROUNDRECEIVE_REQ
function PublicClient.SendMsgAllPlayGroundReceiveReq( tab,callback )
	local bytes = self.SetMsg("AllPlayGroundReceiveReq",tab,callback)
	NetworkManager:SendMessage("PublicClient",pb.enum("CS","ALLPLAYGROUNDRECEIVE_REQ"),0,bytes)
end
function PublicClient.GetMsg(id,reader)
    if(id == -1) then
        self.OnConnect()
        return
    elseif(id == -2 or id == -3) then
        Debug.LogWarning("PublicClientdisconnect"..id)
        if(self.DisconnectCallback) then
            self.DisconnectCallback()
            self.DisconnectCallback = nil       --broken line callback
        end
        self.OnDisconnected(id)
        return
    end
    reader:ReadInt32()
    id = reader:ReadInt32()
    reader:ReadBytes(8)
    Debug.Log("PublicClientreceived back packet:"..id)
    if(id == pb.enum("SC","HEARTBEAT_ACK")) then   --heartbeat
        Debug.Log("PublicClientheartbeat return packet")
    elseif(id == pb.enum("SC","LOGIN_ACK")) then  --logon back packet
        local dataTab = GetSocketDataTab("LoginAck",reader)
        if(dataTab.code == 0) then
            print("you have logged in to the central server successfully")
            self.StartKeepAlive()       --start the heartbeat
            self.SendMsgGetNowTimeReq()
            if(self.LoginAckCallback)then
                self.LoginAckCallback()
            end
        else
            MessageBox("prompt",dataTab.message,"determine")
        end
    elseif(id == pb.enum("SC","LOGOUT_ACK")) then  --log out the game results
        self.ReadMsg(reader,"LogoutAck",function ( data )
            -- body
            Debug.Log(data.message)
            self.keepConnect = false
            if(not self.LogoutAckCallback) then
                UserLogout(data.message)
            end
        end)  
    elseif(id == pb.enum("SC","GETNOWTIME_ACK")) then  --gets the back-end current timestamp response
        self.ReadMsg(reader,"GetNowTimeAck",function ( data )
            -- body
            Debug.Log("gets the back-end current timestamp response")
            TimeManager.timeOffset = data.nowTime - TimeManager:GetTimeStamp(false)
        end)
	elseif(id == pb.enum("SC","ERROR_ACK")) then  --error message
		self.ReadMsg(reader,"ErrorAck",function ( data )
			Debug.Log("error message")
		end)
	elseif(id == pb.enum("SC","GETUSERINFO_ACK")) then  --get user information response
		self.ReadMsg(reader,"GetUserInfoAck",function ( data )
			Debug.Log("get user information response")
		end)
	elseif(id == pb.enum("SC","UPUSERINFO_ACK")) then  --modify the user information response
		self.ReadMsg(reader,"UpUserInfoAck",function ( data )
			Debug.Log("modify the user information response")
		end)
	elseif(id == pb.enum("SC","GETUSERCATLIST_ACK")) then  --get the cat list response
		self.ReadMsg(reader,"GetUserCatListAck",function ( data )
			Debug.Log("get the cat list response")
		end)
	elseif(id == pb.enum("SC","GETCAT_ACK")) then  --obtain cat response
		self.ReadMsg(reader,"GetCatAck",function ( data )
			Debug.Log("obtain cat response")
		end)
	elseif(id == pb.enum("SC","CATINFO_ACK")) then  --cat details response
		self.ReadMsg(reader,"CatInfoAck",function ( data )
			Debug.Log("cat details response")
		end)
	elseif(id == pb.enum("SC","USERITEM_ACK")) then  --user backpack response
		self.ReadMsg(reader,"UserItemAck",function ( data )
			Debug.Log("user backpack response")
		end)
	elseif(id == pb.enum("SC","GETUSERTOOLS_ACK")) then  --get all the tool responses from the user
		self.ReadMsg(reader,"GetUserToolsAck",function ( data )
			Debug.Log("get all the tool responses from the user")
		end)
	elseif(id == pb.enum("SC","GETCATHOUSEINFO_ACK")) then  --get the cat's nest information response
		self.ReadMsg(reader,"GetCatHouseInfoAck",function ( data )
			Debug.Log("get the cat's nest information response")
		end)
	elseif(id == pb.enum("SC","GETCATBOWLINFO_ACK")) then  --get the cat box message response
		self.ReadMsg(reader,"GetCatBowlInfoAck",function ( data )
			Debug.Log("get the cat box message response")
		end)
	elseif(id == pb.enum("SC","GETCATWATERINFO_ACK")) then  --get cat birdbath cabinet information response
		self.ReadMsg(reader,"GetCatWaterInfoAck",function ( data )
			Debug.Log("get cat birdbath cabinet information response")
		end)
	elseif(id == pb.enum("SC","GETCATTOILETINFO_ACK")) then  --get cat toilet message response
		self.ReadMsg(reader,"GetCatToiletInfoAck",function ( data )
			Debug.Log("get cat toilet message response")
		end)
	elseif(id == pb.enum("SC","GETCATBOARDINFO_ACK")) then  --get the cat scratch board message response
		self.ReadMsg(reader,"GetCatBoardInfoAck",function ( data )
			Debug.Log("get the cat scratch board message response")
		end)
	elseif(id == pb.enum("SC","CATEAT_ACK")) then  --cats trigger feeding responses
		self.ReadMsg(reader,"CatEatAck",function ( data )
			Debug.Log("cats trigger feeding responses")
		end)
	elseif(id == pb.enum("SC","CATDRINK_ACK")) then  --the cat triggers a water response
		self.ReadMsg(reader,"CatDrinkAck",function ( data )
			Debug.Log("the cat triggers a water response")
		end)
	elseif(id == pb.enum("SC","CATCACTTION_ACK")) then  --cats trigger a defecation response
		self.ReadMsg(reader,"CatCacationAck",function ( data )
			Debug.Log("cats trigger a defecation response")
		end)
	elseif(id == pb.enum("SC","CATCLEANBODY_ACK")) then  --cats trigger body licking in response
		self.ReadMsg(reader,"CatCleanBodyAck",function ( data )
			Debug.Log("cats trigger body licking in response")
		end)
	elseif(id == pb.enum("SC","CATSLEEP_ACK")) then  --cats trigger a sleep response
		self.ReadMsg(reader,"CatSleepAck",function ( data )
			Debug.Log("cats trigger a sleep response")
		end)
	elseif(id == pb.enum("SC","CATSCRATCHINGPOST_ACK")) then  --cat trigger scratching cat scratching board response
		self.ReadMsg(reader,"CatScratchingPostAck",function ( data )
			Debug.Log("cat trigger scratching cat scratching board response")
		end)
	elseif(id == pb.enum("SC","CATSICKJUDGE_ACK")) then  --cat triggers sick decision response
		self.ReadMsg(reader,"CatSickJudgeAck",function ( data )
			Debug.Log("cat triggers sick decision response")
		end)
	elseif(id == pb.enum("SC","GMCODE_ACK")) then  --GMcommand response
		self.ReadMsg(reader,"GMCodeAck",function ( data )
			Debug.Log("GMcommand response")
		end)
	elseif(id == pb.enum("SC","USEPROPS_ACK")) then  --use props to respond
		self.ReadMsg(reader,"UsePropsAck",function ( data )
			Debug.Log("use props to respond")
		end)
	elseif(id == pb.enum("SC","CLEANTOILET_ACK")) then  --clean the room response
		self.ReadMsg(reader,"CleanToiletAck",function ( data )
			Debug.Log("clean the room response")
		end)
	elseif(id == pb.enum("SC","ADDWATER_ACK")) then  --add water response to the basin cabinet
		self.ReadMsg(reader,"AddWaterAck",function ( data )
			Debug.Log("add water response to the basin cabinet")
		end)
	elseif(id == pb.enum("SC","REPAIRBOARD_ACK")) then  --fixed cat scratch board durability response
		self.ReadMsg(reader,"RepairBoardAck",function ( data )
			Debug.Log("fixed cat scratch board durability response")
		end)
	elseif(id == pb.enum("SC","UPCATLEVEL_ACK")) then  --upgraded cat response
		self.ReadMsg(reader,"UpCatLevelAck",function ( data )
			Debug.Log("upgraded cat response")
		end)
	elseif(id == pb.enum("SC","GETCATFOODWAREHOUSE_ACK")) then  --obtain cat food warehouse response
		self.ReadMsg(reader,"GetCatFoodWareHouseAck",function ( data )
			Debug.Log("obtain cat food warehouse response")
		end)
	elseif(id == pb.enum("SC","GETCATLITTERWAREHOUSE_ACK")) then  --get litter warehouse response
		self.ReadMsg(reader,"GetCatLitterWareHouseAck",function ( data )
			Debug.Log("get litter warehouse response")
		end)
	elseif(id == pb.enum("SC","REPLENISHCATFOOD_ACK")) then  --add cat food response
		self.ReadMsg(reader,"ReplenishCatFoodAck",function ( data )
			Debug.Log("add cat food response")
		end)
	elseif(id == pb.enum("SC","REPLENISHCATLITTER_ACK")) then  --add cat litter response
		self.ReadMsg(reader,"ReplenishCatLitterAck",function ( data )
			Debug.Log("add cat litter response")
		end)
	elseif(id == pb.enum("SC","STROKECAT_ACK")) then  --cat response
		self.ReadMsg(reader,"StrokeCatAck",function ( data )
			Debug.Log("cat response")
		end)
	elseif(id == pb.enum("SC","GETINTIMACYREWARD_ACK")) then  --get the intimacy get the rule response
		self.ReadMsg(reader,"GetIntimacyRewardAck",function ( data )
			Debug.Log("get the intimacy get the rule response")
		end)
	elseif(id == pb.enum("SC","RECEIVEINTIMACYREWARD_ACK")) then  --get the intimacy reward response
		self.ReadMsg(reader,"ReceiveIntimacyRewardAck",function ( data )
			Debug.Log("get the intimacy reward response")
		end)
	elseif(id == pb.enum("SC","PRODUCTLIST_ACK")) then  --merchandise list response
		self.ReadMsg(reader,"ProducListAck",function ( data )
			Debug.Log("merchandise list response")
		end)
	elseif(id == pb.enum("SC","BUYGOODS_ACK")) then  --purchase response
		self.ReadMsg(reader,"BuyGoodsAck",function ( data )
			Debug.Log("purchase response")
		end)
	elseif(id == pb.enum("SC","WATERUPLEVEL_ACK")) then  --cat birdbath cabinet upgrade response
		self.ReadMsg(reader,"WaterUpLevelAck",function ( data )
			Debug.Log("cat birdbath cabinet upgrade response")
		end)
	elseif(id == pb.enum("SC","BOARDUPLEVEL_ACK")) then  --cat scratch board upgrade upgrade response
		self.ReadMsg(reader,"BoardUpLevelAck",function ( data )
			Debug.Log("cat scratch board upgrade upgrade response")
		end)
	elseif(id == pb.enum("SC","BOWLUPLEVEL_ACK")) then  --cat box upgrade response
		self.ReadMsg(reader,"BowlUpLevelAck",function ( data )
			Debug.Log("cat box upgrade response")
		end)
	elseif(id == pb.enum("SC","TOILETUPLEVEL_ACK")) then  --cat toilet upgrade response
		self.ReadMsg(reader,"ToiletUpLevelAck",function ( data )
			Debug.Log("cat toilet upgrade response")
		end)
	elseif(id == pb.enum("SC","HOUSEUPLEVEL_ACK")) then  --the cat's nest escalates in response
		self.ReadMsg(reader,"HouseUpLevelAck",function ( data )
			Debug.Log("the cat's nest escalates in response")
		end)
	elseif(id == pb.enum("SC","EXCHANGEAVATAR_ACK")) then  --equip fragment exchange response
		self.ReadMsg(reader,"ExchangeAvatarAck",function ( data )
			Debug.Log("equip fragment exchange response")
		end)
	elseif(id == pb.enum("SC","USERAVATARLIST_ACK")) then  --user equipment list response
		self.ReadMsg(reader,"UserAvatarListAck",function ( data )
			Debug.Log("user equipment list response")
		end)
	elseif(id == pb.enum("SC","WEARAVATAR_ACK")) then  --wearable response
		self.ReadMsg(reader,"WearAvatarAck",function ( data )
			Debug.Log("wearable response")
		end)
	elseif(id == pb.enum("SC","REMOVINGAVATAR_ACK")) then  --disarming response
		self.ReadMsg(reader,"RemovingAvatarAck",function ( data )
			Debug.Log("disarming response")
		end)
	elseif(id == pb.enum("SC","CATEXCREMENTUPLEVEL_ACK")) then  --cat poop capacity upgrade response
		self.ReadMsg(reader,"CatExcrementUpLevelAck",function ( data )
			Debug.Log("cat poop capacity upgrade response")
		end)
	elseif(id == pb.enum("SC","CLEANCATEXCREMENT_ACK")) then  --empty the cat toilet cat poop response
		self.ReadMsg(reader,"CleanExcrementAck",function ( data )
			Debug.Log("empty the cat toilet cat poop response")
		end)
	elseif(id == pb.enum("SC","CATPLAY_ACK")) then  --respond with the cat prop
		self.ReadMsg(reader,"CatPlayAck",function ( data )
			Debug.Log("respond with the cat prop")
		end)
	elseif(id == pb.enum("SC","CATACTION_ACK")) then  --smell、hand licking、rub one's feet、milk response
		self.ReadMsg(reader,"CatActionAck",function ( data )
			Debug.Log("smell、hand licking、rub one's feet、milk response")
		end)
	elseif(id == pb.enum("SC","CATCHANGEHEALTH_ACK")) then  --cats increase or decrease fitness response
		self.ReadMsg(reader,"CatChangeHealthAck",function ( data )
			Debug.Log("cats increase or decrease fitness response")
		end)
	elseif(id == pb.enum("SC","GETUSERTASK_ACK")) then  --get the daily task response of the current user
		self.ReadMsg(reader,"GetUserTaskAck",function ( data )
			Debug.Log("get the daily task response of the current user")
		end)
	elseif(id == pb.enum("SC","FINISHTASK_ACK")) then  --complete task response
		self.ReadMsg(reader,"FinishTaskAck",function ( data )
			Debug.Log("complete task response")
		end)
	elseif(id == pb.enum("SC","STARTANSWER_ACK")) then  --answer
		self.ReadMsg(reader,"StartAnswerAck",function ( data )
			Debug.Log("answer")
		end)
	elseif(id == pb.enum("SC","SUBMITQUESTION_ACK")) then  --submit answer
		self.ReadMsg(reader,"SubmitQuestionAck",function ( data )
			Debug.Log("submit answer")
		end)
	elseif(id == pb.enum("SC","SICKCATLIST_ACK")) then  --a list of cats admitted to the hospital
		self.ReadMsg(reader,"SickCatListAck",function ( data )
			Debug.Log("a list of cats admitted to the hospital")
		end)
	elseif(id == pb.enum("SC","SICKTREATMENT_ACK")) then  --the response to treating an illness
		self.ReadMsg(reader,"SickTreatmentAck",function ( data )
			Debug.Log("the response to treating an illness")
		end)
	elseif(id == pb.enum("SC","ACCELERATETREATMENT_ACK")) then  --accelerated recovery response
		self.ReadMsg(reader,"AccelerateTreatmentAck",function ( data )
			Debug.Log("accelerated recovery response")
		end)
	elseif(id == pb.enum("SC","STROKECATITEM_ACK")) then  --user masturbation item list response
		self.ReadMsg(reader,"StrokeCatItemAck",function ( data )
			Debug.Log("user masturbation item list response")
		end)
	elseif(id == pb.enum("SC","RECOVERSHELTER_ACK")) then  --recycle to shelter response
		self.ReadMsg(reader,"RecoverShelterAck",function ( data )
			Debug.Log("recycle to shelter response")
		end)
	elseif(id == pb.enum("SC","REDEEMCATLIST_ACK")) then  --the list of cats that need to be redeemed responds
		self.ReadMsg(reader,"RedeemCatListAck",function ( data )
			Debug.Log("the list of cats that need to be redeemed responds")
		end)
	elseif(id == pb.enum("SC","REDEEM_ACK")) then  --redeemed shelter cat response
		self.ReadMsg(reader,"RedeemAck",function ( data )
			Debug.Log("redeemed shelter cat response")
		end)
	elseif(id == pb.enum("SC","PUTONSHELVE_ACK")) then  --shelf cat response
		self.ReadMsg(reader,"PutonShelveAck",function ( data )
			Debug.Log("shelf cat response")
		end)
	elseif(id == pb.enum("SC","LOWERSHELVE_ACK")) then  --off the shelf cat response
		self.ReadMsg(reader,"LowerShelveAck",function ( data )
			Debug.Log("off the shelf cat response")
		end)
	elseif(id == pb.enum("SC","PSCATSLISTBYUSER_ACK")) then  --response to the current user's list of cats on shelter shelves
		self.ReadMsg(reader,"PsCatListByUserAck",function ( data )
			Debug.Log("response to the current user's list of cats on shelter shelves")
		end)
	elseif(id == pb.enum("SC","PSCATSLIST_ACK")) then  --response to a list of cats listed by all users at the shelter
		self.ReadMsg(reader,"PsCatListAck",function ( data )
			Debug.Log("response to a list of cats listed by all users at the shelter")
		end)
	elseif(id == pb.enum("SC","ADOPTCAT_ACK")) then  --shelter adoption cat response
		self.ReadMsg(reader,"AdoptCatAck",function ( data )
			Debug.Log("shelter adoption cat response")
		end)
	elseif(id == pb.enum("SC","SICKREDUCTHEALTH_ACK")) then  --reduced health response after illness
		self.ReadMsg(reader,"SickReductHealthAck",function ( data )
			Debug.Log("reduced health response after illness")
		end)
	elseif(id == pb.enum("SC","SENDTOHOSPITAL_ACK")) then  --hospital response
		self.ReadMsg(reader,"SendToHospitalAck",function ( data )
			Debug.Log("hospital response")
		end)
	elseif(id == pb.enum("SC","TAKEITHOME_ACK")) then  --after the treatment is completed, take him home from the hospital to respond
		self.ReadMsg(reader,"TakeItHomeAck",function ( data )
			Debug.Log("after the treatment is completed, take him home from the hospital to respond")
		end)
	elseif(id == pb.enum("SC","TREATMENTPRICE_ACK")) then  --cat accelerated treatment price response
		self.ReadMsg(reader,"TreatmentPriceAck",function ( data )
			Debug.Log("cat accelerated treatment price response")
		end)
	elseif(id == pb.enum("SC","RECYCLEPROPS_ACK")) then  --recovery item response
		self.ReadMsg(reader,"RecyclePropsAck",function ( data )
			Debug.Log("recovery item response")
		end)
	elseif(id == pb.enum("SC","USERFIELDLIST_ACK")) then  --the user's vegetable patch list responds
		self.ReadMsg(reader,"UserFieldListAck",function ( data )
			Debug.Log("the user's vegetable patch list responds")
		end)
	elseif(id == pb.enum("SC","UNLOCKFIELD_ACK")) then  --the planting of vegetable fields responded
		self.ReadMsg(reader,"UnLockFieldAck",function ( data )
			Debug.Log("the planting of vegetable fields responded")
		end)
	elseif(id == pb.enum("SC","USERSEED_ACK")) then  --user-owned torrent list responses
		self.ReadMsg(reader,"UserSeedAck",function ( data )
			Debug.Log("user-owned torrent list responses")
		end)
	elseif(id == pb.enum("SC","SEED_ACK")) then  --seed response
		self.ReadMsg(reader,"SeedAck",function ( data )
			Debug.Log("seed response")
		end)
	elseif(id == pb.enum("SC","ATTACKCATLIST_ACK")) then  --the attacking cat list responds
		self.ReadMsg(reader,"AttackCatListAck",function ( data )
			Debug.Log("the attacking cat list responds")
		end)
	elseif(id == pb.enum("SC","ATTACK_ACK")) then  --offensive response
		self.ReadMsg(reader,"AttackAck",function ( data )
			Debug.Log("offensive response")
		end)
	elseif(id == pb.enum("SC","DEFENSECATLIST_ACK")) then  --the defensive cat list responds
		self.ReadMsg(reader,"DefenseCatListAck",function ( data )
			Debug.Log("the defensive cat list responds")
		end)
	elseif(id == pb.enum("SC","DEFENSE_ACK")) then  --defensive response
		self.ReadMsg(reader,"DefenseAck",function ( data )
			Debug.Log("defensive response")
		end)
	elseif(id == pb.enum("SC","ATTACKRECEIVE_ACK")) then  --steal cat grass reward receive response
		self.ReadMsg(reader,"AttackReceiveAck",function ( data )
			Debug.Log("steal cat grass reward receive response")
		end)
	elseif(id == pb.enum("SC","SICKCATINFO_ACK")) then  --sick cat details response
		self.ReadMsg(reader,"SickCatInfoAck",function ( data )
			Debug.Log("sick cat details response")
		end)
	elseif(id == pb.enum("SC","PICKUP_ACK")) then  --recovery response
		self.ReadMsg(reader,"PickUpAck",function ( data )
			Debug.Log("recovery response")
		end)
	elseif(id == pb.enum("SC","PICKUP_ACK")) then  --get the cooling response of the user's cat action
		self.ReadMsg(reader,"GetCoolingAck",function ( data )
			Debug.Log("get the cooling response of the user's cat action")
		end)
	elseif(id == pb.enum("SC","MOSTATTACK_ACK")) then  --multiple cats attack and respond
		self.ReadMsg(reader,"MostAttackAck",function ( data )
			Debug.Log("multiple cats attack and respond")
		end)
	elseif(id == pb.enum("SC","PLAYGROUNDCATLIST_ACK")) then  --get playground cat list responses
		self.ReadMsg(reader,"PlayGroundCatListAck",function ( data )
			Debug.Log("get playground cat list responses")
		end)
	elseif(id == pb.enum("SC","PLAYGROUND_ACK")) then  --respond with fun activities
		self.ReadMsg(reader,"PlayGroundAck",function ( data )
			Debug.Log("respond with fun activities")
		end)
	elseif(id == pb.enum("SC","PLAYGROUNDRECEIVE_ACK")) then  --playground reward claim response
		self.ReadMsg(reader,"PlayGroundReceiveAck",function ( data )
			Debug.Log("playground reward claim response")
		end)
	elseif(id == pb.enum("SC","MOSTPLAYGROUND_ACK")) then  --multiple cats responded by participating in the playground activities
		self.ReadMsg(reader,"MostPlayGroundAck",function ( data )
			Debug.Log("multiple cats responded by participating in the playground activities")
		end)
	elseif(id == pb.enum("SC","PLAYGROUNDHISTORY_ACK")) then  --playground rewards historical record response
		self.ReadMsg(reader,"PlayGroundHistoryAck",function ( data )
			Debug.Log("playground rewards historical record response")
		end)
	elseif(id == pb.enum("SC","MAIL_LIST_ACK")) then  --mailing list response
		self.ReadMsg(reader,"MailListAck",function ( data )
			Debug.Log("mailing list response")
		end)
	elseif(id == pb.enum("SC","MAIL_RECEIVE_ACK")) then  --mail collection response
		self.ReadMsg(reader,"MailReceiveAck",function ( data )
			Debug.Log("mail collection response")
		end)
	elseif(id == pb.enum("SC","MAIL_READ_ACK")) then  --the email has been read and responded
		self.ReadMsg(reader,"MailReadAck",function ( data )
			Debug.Log("the email has been read and responded")
		end)
	elseif(id == pb.enum("SC","MAIL_DELETE_ACK")) then  --email deletion response
		self.ReadMsg(reader,"MailDeleteAck",function ( data )
			Debug.Log("email deletion response")
		end)
	elseif(id == pb.enum("SC","MAIL_NEW_ACK")) then  --new email response
		self.ReadMsg(reader,"MailNewAck",function ( data )
			Debug.Log("new email response")
		end)
	elseif(id == pb.enum("SC","CATPLAY_COOLING_ACK")) then  --use the cooling response of the cat prop
		self.ReadMsg(reader,"CatPlayCoolingAck",function ( data )
			Debug.Log("use the cooling response of the cat prop")
		end)
	elseif(id == pb.enum("SC","PS_STATISTICS_ACK")) then  --shelter statistical response
		self.ReadMsg(reader,"PsStatisticsAck",function ( data )
			Debug.Log("shelter statistical response")
		end)
	elseif(id == pb.enum("SC","ALLPLAYGROUNDRECEIVE_ACK")) then  --playground reward one-click claim response
		self.ReadMsg(reader,"AllPlayGroundReceiveAck",function ( data )
			Debug.Log("playground reward one-click claim response")
		end)
    else
        Debug.LogError("the return packet was not processed:"..id)
    end
end

function PublicClient.SetMsg( reqName, tab, callback, errorCallback)
    -- body
    local ack = string.gsub(reqName,"Req","Ack")
    self[ack.."Callback"] = callback
    self[ack.."Error"] = errorCallback
    return assert(pb.encode(reqName, tab))
end


function PublicClient.ReadMsg(reader,msgName,callback)
    -- body
    local dataTab = GetSocketDataTab(msgName,reader)
    if(dataTab.code == 0) then
        if(self[msgName.."Callback"]) then
            self[msgName.."Callback"](dataTab)
        end
        if(callback) then
            callback(dataTab)
        end
    else
        if(self[msgName.."Error"]) then
            self[msgName.."Error"](dataTab.message)
        else
            MessageBox("prompt",dataTab.message,"determine")
        end
        
    end
end

