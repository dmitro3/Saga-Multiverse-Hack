
��
client.proto"8
LoginReq
token (	Rtoken
userId (	RuserId"8
LoginAck
code (Rcode
message (	Rmessage"
	LogoutReq"R
	LogoutAck
code (Rcode
message (	Rmessage
user_id (RuserId"
HeartbeatReq"
HeartbeatAck"8
ErrorAck
code (Rcode
message (	Rmessage"&
GetUserInfoReq
token (	Rtoken"�
GetUserInfoAck
code (Rcode
message (	Rmessage
userName (	RuserName
sex (Rsex
email (	Remail$
walletAddress (	RwalletAddress
type (Rtype(
charitableValue (RcharitableValue
password	 (	Rpassword"�
UpUserInfoReq
token (	Rtoken
userName (	RuserName
sex (Rsex
email (	Remail$
walletAddress (	RwalletAddress
password (	Rpassword"=
UpUserInfoAck
code (Rcode
message (	Rmessage")
GetUserCatListReq
token (	Rtoken"�
GetUserCatListAck
code (Rcode
message (	Rmessage$
catList (2
.CatModuleRcatList
hasSick (RhasSick"8
	GetCatReq
token (	Rtoken
cat_id (RcatId"9
	GetCatAck
code (Rcode
message (	Rmessage"2

CatInfoReq
token (	Rtoken
id (Rid"`

CatInfoAck
code (Rcode
message (	Rmessage$
catInfo (2
.CatModuleRcatInfo"�
	CatModule
catId (RcatId
	character (R	character
sex (Rsex
birthday (Rbirthday

generation (R
generation
catImage (	RcatImage
name (	Rname
level (Rlevel
intimacy	 (Rintimacy
growth
 (Rgrowth
health (Rhealth"
nowCleanTime (RnowCleanTime"
maxCleanTime (RmaxCleanTime*
maxCleanNumerial (RmaxCleanNumerial.
everyTimeCleanTime (ReveryTimeCleanTime8
everyTimeDirtyCleanTime (ReveryTimeDirtyCleanTime*
cleanBodySetting (	RcleanBodySetting$
nowHungerTime (RnowHungerTime$
maxHungerTime (RmaxHungerTime,
maxHungerNumerial (RmaxHungerNumerial0
everyTimeHungerTime (ReveryTimeHungerTime

eatSetting (	R
eatSetting&
nowThirstyTime (RnowThirstyTime&
maxThirstyTime (RmaxThirstyTime.
maxThirstyNumerial (RmaxThirstyNumerial2
everyTimeThirstyTime (ReveryTimeThirstyTime"
drinkSetting (	RdrinkSetting(
nowDefecateTime (RnowDefecateTime(
maxDefecateTime (RmaxDefecateTime0
maxDefecateNumerial (RmaxDefecateNumerial4
everyTimeDefecateTime (ReveryTimeDefecateTime(
cacationSetting  (	RcacationSetting0
nowSharpenClawsTime! (RnowSharpenClawsTime0
maxSharpenClawsTime" (RmaxSharpenClawsTime8
maxSharpenClawsNumerial# (RmaxSharpenClawsNumerial<
everyTimeSharpenClawsTime$ (ReveryTimeSharpenClawsTime4
scratchingPostSetting% (	RscratchingPostSetting2
sleepCatHouseSetting& (	RsleepCatHouseSetting*
nowHappinessTime' (RnowHappinessTime*
maxHappinessTime( (RmaxHappinessTime2
maxHappinessNumerial) (RmaxHappinessNumerial6
everyTimeHappinessTime* (ReveryTimeHappinessTime
stamina+ (Rstamina.
maxStaminaNumerial, (RmaxStaminaNumerial
charm- (Rcharm
strength. (Rstrength
charmAdd/ (RcharmAdd 
strengthAdd0 (RstrengthAdd
sick1 (Rsick
userId2 (RuserId=
behaviorList3 (2.CatBehaviorHistoryModuleRbehaviorList&
ageCoefficient4 (RageCoefficient$
upLevelGrowth5 (RupLevelGrowth*
upLevelMoneyType6 (RupLevelMoneyType,
upLevelMoneyCount7 (RupLevelMoneyCount 
basicsCharm8 (RbasicsCharm&
basicsStrength9 (RbasicsStrength
isTreat: (RisTreat
status; (Rstatus
quality< (Rquality
	maxHealth= (R	maxHealth"�
CatBehaviorHistoryModule
userId (RuserId
	userCatId (R	userCatId"
behaviorTime (RbehaviorTime
actionId (RactionId
msg (	Rmsg"#
UserItemReq
token (	Rtoken"�
UserItemAck
code (Rcode
message (	Rmessage'
itemList (2.ItemModuleRitemList/
foodList (2.CatWareHouseModuleRfoodList3

litterList (2.CatWareHouseModuleR
litterList"�

ItemModule
id (Rid
propType (RpropType
propId (RpropId
	propCount (R	propCount

durability (R
durability
saleType (RsaleType
	saleCount (R	saleCount"'
GetUserToolsReq
token (	Rtoken"�
GetUserToolsAck
code (Rcode
message (	Rmessage+
catHouse (2.CatHouseModuleRcatHouse(
catBowl (2.CatBowlModuleRcatBowl+
catWater (2.CatWaterModuleRcatWaterI
catScratchingBoard (2.CatScratchingBoardModuleRcatScratchingBoard.
	catToilet (2.CatToiletModuleR	catToilet"*
GetCatHouseInfoReq
token (	Rtoken"o
GetCatHouseInfoAck
code (Rcode
message (	Rmessage+
catHouse (2.CatHouseModuleRcatHouse")
GetCatBowlInfoReq
token (	Rtoken"k
GetCatBowlInfoAck
code (Rcode
message (	Rmessage(
catBowl (2.CatBowlModuleRcatBowl"*
GetCatWaterInfoReq
token (	Rtoken"o
GetCatWaterInfoAck
code (Rcode
message (	Rmessage+
catWater (2.CatWaterModuleRcatWater"+
GetCatToiletInfoReq
token (	Rtoken"s
GetCatToiletInfoAck
code (Rcode
message (	Rmessage.
	catToilet (2.CatToiletModuleR	catToilet"*
GetCatBoardInfoReq
token (	Rtoken"y
GetCatBoardInfoAck
code (Rcode
message (	Rmessage5
catBoard (2.CatScratchingBoardModuleRcatBoard"�
CatHouseModule
id (Rid
userId (RuserId
	toolLevel (R	toolLevel*
upLevelMoneyType (RupLevelMoneyType,
upLevelMoneyCount (RupLevelMoneyCount
ruleTime (RruleTime"
ruleRecovery (RruleRecovery"�
CatBowlModule
id (Rid
userId (RuserId
	toolLevel (R	toolLevel
	sumVolume (R	sumVolume$
surplusVolume (RsurplusVolume0
surplusVolumeDetail (	RsurplusVolumeDetail*
upLevelMoneyType (RupLevelMoneyType,
upLevelMoneyCount (RupLevelMoneyCount 
wareHouseId	 (RwareHouseId"�
CatWaterModule
id (Rid
userId (RuserId
	toolLevel (R	toolLevel
	sumVolume (R	sumVolume$
surplusVolume (RsurplusVolume0
surplusVolumeDetail (	RsurplusVolumeDetail*
upLevelMoneyType (RupLevelMoneyType,
upLevelMoneyCount (RupLevelMoneyCount"�
CatScratchingBoardModule
id (Rid
userId (RuserId
	toolLevel (R	toolLevel
	sumVolume (R	sumVolume$
surplusVolume (RsurplusVolume0
surplusVolumeDetail (	RsurplusVolumeDetail*
upLevelMoneyType (RupLevelMoneyType,
upLevelMoneyCount (RupLevelMoneyCount*
repairMoneyCount	 (RrepairMoneyCount(
repairMoneyType
 (RrepairMoneyType"�
CatToiletModule
id (Rid
userId (RuserId
	toolLevel (R	toolLevel
	sumVolume (R	sumVolume$
surplusVolume (RsurplusVolume0
surplusVolumeDetail (	RsurplusVolumeDetail

dirtyCount (R
dirtyCount
	dirtyTime (R	dirtyTime*
upLevelMoneyType	 (RupLevelMoneyType,
upLevelMoneyCount
 (RupLevelMoneyCount 
wareHouseId (RwareHouseId(
sumCatExcrement (RsumCatExcrement"
catExcrement (RcatExcrement&
excrementLevel (RexcrementLevel<
upExcrementLevelMoneyType (RupExcrementLevelMoneyType>
upExcrementLevelMoneyCount (RupExcrementLevelMoneyCount(
cleanMoneyCount (RcleanMoneyCount&
cleanMoneyType (RcleanMoneyType"%
GetNowTimeReq
token (	Rtoken"W
GetNowTimeAck
code (Rcode
message (	Rmessage
nowTime (RnowTime"7
	CatEatReq
token (	Rtoken
catId (RcatId"�
	CatEatAck
code (Rcode
message (	Rmessage$
addHungerTime (RaddHungerTime
	addHealth (R	addHealth 
reduceCount (RreduceCount
	addGrowth (R	addGrowth
catId (RcatId"9
CatDrinkReq
token (	Rtoken
catId (RcatId"�
CatDrinkAck
code (Rcode
message (	Rmessage&
addThirstyTime (RaddThirstyTime
	addHealth (R	addHealth 
reduceCount (RreduceCount
	addGrowth (R	addGrowth
catId (RcatId"<
CatCacationReq
token (	Rtoken
catId (RcatId"�
CatCacationAck
code (Rcode
message (	Rmessage(
addDefecateTime (RaddDefecateTime 
reduceCount (RreduceCount

dirtyCount (R
dirtyCount
catId (RcatId"=
CatCleanBodyReq
token (	Rtoken
catId (RcatId"�
CatCleanBodyAck
code (Rcode
message (	Rmessage"
addCleanTime (RaddCleanTime
	addHealth (R	addHealth
	addGrowth (R	addGrowth
catId (RcatId"9
CatSleepReq
token (	Rtoken
catId (RcatId"q
CatSleepAck
code (Rcode
message (	Rmessage

addStamina (R
addStamina
catId (RcatId"B
CatScratchingPostReq
token (	Rtoken
catId (RcatId"�
CatScratchingPostAck
code (Rcode
message (	Rmessage0
addSharpenClawsTime (RaddSharpenClawsTime 
reduceCount (RreduceCount
catId (RcatId"=
CatSickJudgeReq
token (	Rtoken
catId (RcatId"m
CatSickJudgeAck
code (Rcode
message (	Rmessage
isSick (RisSick
catId (RcatId"5
	GMCodeReq
token (	Rtoken
code (	Rcode"9
	GMCodeAck
code (Rcode
message (	Rmessage"W
UsePropsReq
token (	Rtoken
itemId (RitemId
useCount (RuseCount"^
UsePropsAck
code (Rcode
message (	Rmessage!
items (2.ItemModuleRitems"&
CleanToiletReq
token (	Rtoken"�
CleanToiletAck
code (Rcode
message (	Rmessage 
reduceCount (RreduceCount

addCsCount (R
addCsCount'
items (2.ReduceItemModuleRitems"#
AddWaterReq
token (	Rtoken"w
AddWaterAck
code (Rcode
message (	Rmessage
addCount (RaddCount

addCsCount (R
addCsCount"&
RepairBoardReq
token (	Rtoken"�
RepairBoardAck
code (Rcode
message (	Rmessage
addCount (RaddCount

addCsCount (R
addCsCount'
items (2.ReduceItemModuleRitems";
UpCatLevelReq
token (	Rtoken
catId (RcatId"�
UpCatLevelAck
code (Rcode
message (	Rmessage,
reduceGrowthCount (RreduceGrowthCount
addLevel (RaddLevel
addCharm (RaddCharm 
addStrength (RaddStrength'
items (2.ReduceItemModuleRitems
catId (RcatId".
GetCatFoodWareHouseReq
token (	Rtoken"y
GetCatFoodWareHouseAck
code (Rcode
message (	Rmessage1
	houseList (2.CatWareHouseModuleR	houseList"0
GetCatLitterWareHouseReq
token (	Rtoken"{
GetCatLitterWareHouseAck
code (Rcode
message (	Rmessage1
	houseList (2.CatWareHouseModuleR	houseList"�
CatWareHouseModule
id (Rid
userId (RuserId$
warehouseType (RwarehouseType
	propCount (R	propCount
	brandName (	R	brandName
brandId (RbrandId"l
ReduceItemModule
id (Rid
	propCount (R	propCount*
reduceDurability (RreduceDurability"i
ReplenishCatFoodReq
token (	Rtoken 
wareHouseId (RwareHouseId
addCount (RaddCount"�
ReplenishCatFoodAck
code (Rcode
message (	Rmessage"
addFoodCount (RaddFoodCount

addCsCount (R
addCsCount"k
ReplenishCatLitterReq
token (	Rtoken 
wareHouseId (RwareHouseId
addCount (RaddCount"�
ReplenishCatLitterAck
code (Rcode
message (	Rmessage&
addLitterCount (RaddLitterCount

addCsCount (R
addCsCount"Z
StrokeCatReq
token (	Rtoken
catId (RcatId

strokeType (R
strokeType"�
StrokeCatAck
code (Rcode
message (	Rmessage"
addHappiness (RaddHappiness

addCsCount (R
addCsCount
catId (RcatId"B
GetIntimacyRewardReq
token (	Rtoken
catId (RcatId"�
GetIntimacyRewardAck
code (Rcode
message (	Rmessage/
rewards (2.IntimacyRewardModuleRrewards
catId (RcatId"v
IntimacyRewardModule
rewardId (RrewardId"
needIntimacy (RneedIntimacy

isReceived (R
isReceived"b
ReceiveIntimacyRewardReq
token (	Rtoken
catId (RcatId
rewardId (RrewardId"�
ReceiveIntimacyRewardAck
code (Rcode
message (	Rmessage!
items (2.ItemModuleRitems'
pmList (2.GetPropsModuleRpmList
catId (RcatId"%
ProducListReq
token (	Rtoken"f
ProducListAck
code (Rcode
message (	Rmessage'
producs (2.ProducModuleRproducs"�
ProducModule
id (Rid
tab (Rtab
type (Rtype
propId (RpropId
	shopIndex (R	shopIndex
	limitTime (R	limitTime
offTime (RoffTime
limitBuy (RlimitBuy
buyCount	 (RbuyCount

costPropId
 (R
costPropId
	costCount (R	costCount
	saleCount (R	saleCount
	recommend (R	recommend
tips (	Rtips
pic (	Rpic"Q
BuyGoodsReq
token (	Rtoken
goodId (RgoodId
count (Rcount"�
BuyGoodsAck
code (Rcode
message (	Rmessage 
addBuyCount (RaddBuyCount!
items (2.ItemModuleRitems
	foodCount (R	foodCount 
litterCount (RlitterCount"A
WaterUpLevelReq
token (	Rtoken
waterId (RwaterId"�
WaterUpLevelAck
code (Rcode
message (	Rmessage#
tool (2.CatWaterModuleRtool

addCsCount (R
addCsCount"A
BoardUpLevelReq
token (	Rtoken
boardId (RboardId"�
BoardUpLevelAck
code (Rcode
message (	Rmessage-
tool (2.CatScratchingBoardModuleRtool

addCsCount (R
addCsCount">
BowlUpLevelReq
token (	Rtoken
bowlId (RbowlId"�
BowlUpLevelAck
code (Rcode
message (	Rmessage"
tool (2.CatBowlModuleRtool

addCsCount (R
addCsCount"D
ToiletUpLevelReq
token (	Rtoken
toiletId (RtoiletId"�
ToiletUpLevelAck
code (Rcode
message (	Rmessage$
tool (2.CatToiletModuleRtool

addCsCount (R
addCsCount"A
HouseUpLevelReq
token (	Rtoken
houseId (RhouseId"�
HouseUpLevelAck
code (Rcode
message (	Rmessage#
tool (2.CatHouseModuleRtool

addCsCount (R
addCsCount"A
ExchangeAvatarReq
token (	Rtoken
propId (RpropId"d
ExchangeAvatarAck
code (Rcode
message (	Rmessage!
tool (2.AvatarModuleRtool")
UserAvatarListReq
token (	Rtoken"h
UserAvatarListAck
code (Rcode
message (	Rmessage%
avatar (2.AvatarModuleRavatar"h
AvatarModule
id (Rid
avatarId (RavatarId
userId (RuserId
catId (RcatId"K
WearAvatarReq
token (	Rtoken
id (Rid
catId (RcatId"y
WearAvatarAck
code (Rcode
message (	Rmessage$
catInfo (2
.CatModuleRcatInfo
catId (RcatId"O
RemovingAvatarReq
token (	Rtoken
id (Rid
catId (RcatId"}
RemovingAvatarAck
code (Rcode
message (	Rmessage$
catInfo (2
.CatModuleRcatInfo
catId (RcatId"J
CatExcrementUpLevelReq
token (	Rtoken
toiletId (RtoiletId"l
CatExcrementUpLevelAck
code (Rcode
message (	Rmessage$
tool (2.CatToiletModuleRtool")
CleanExcrementReq
token (	Rtoken"�
CleanExcrementAck
code (Rcode
message (	Rmessage2
reduceExcrementCount (RreduceExcrementCount

addCsCount (R
addCsCount"h

CatPlayReq
token (	Rtoken
catId (RcatId
playId (RplayId
propId (RpropId"�

CatPlayAck
code (Rcode
message (	Rmessage"
addHappiness (RaddHappiness

addCsCount (R
addCsCount
catId (RcatId"V
CatActionReq
token (	Rtoken
catId (RcatId
actionId (RactionId"v
CatActionAck
code (Rcode
message (	Rmessage"
addHappiness (RaddHappiness
catId (RcatId"V
CatChangeHealthReq
token (	Rtoken
catId (RcatId
count (Rcount"�
CatChangeHealthAck
code (Rcode
message (	Rmessage
count (Rcount
	addGrowth (R	addGrowth
catId (RcatId"&
GetUserTaskReq
token (	Rtoken"g
GetUserTaskAck
code (Rcode
message (	Rmessage'
taskList (2.TaskModuleRtaskList"�

TaskModule
taskId (RtaskId

isReceived (R
isReceived
sumCount (RsumCount 
finishCount (RfinishCount"=
FinishTaskReq
token (	Rtoken
taskId (RtaskId"f
FinishTaskAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList"&
StartAnswerReq
token (	Rtoken"�
StartAnswerAck
code (Rcode
message (	Rmessage

questionId (R
questionId"
answerStatus (RanswerStatus 
finishCount (RfinishCount3
questionList (2.QuestionModuleRquestionList"�
QuestionModule
orderNum (RorderNum
intro (	Rintro
optionA (	RoptionA
optionB (	RoptionB
optionC (	RoptionC
optionD (	RoptionD$
correntAnswer (	RcorrentAnswer"
chooseOption (	RchooseOption"i
SubmitQuestionReq
token (	Rtoken
orderNum (RorderNum"
chooseOption (	RchooseOption"j
SubmitQuestionAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList"&
SickCatListReq
token (	Rtoken"h
SickCatListAck
code (Rcode
message (	Rmessage(
catList (2.SickCatModuleRcatList">
SickTreatmentReq
token (	Rtoken
catId (RcatId"�
SickTreatmentAck
code (Rcode
message (	Rmessage(
catInfo (2.SickCatModuleRcatInfo

addCsCount (R
addCsCount
catId (RcatId"D
AccelerateTreatmentReq
token (	Rtoken
catId (RcatId"�
AccelerateTreatmentAck
code (Rcode
message (	Rmessage

dirtyMoney (R
dirtyMoney(
catInfo (2.SickCatModuleRcatInfo
catId (RcatId"�
SickCatModule
catId (RcatId
	character (R	character
sex (Rsex
catImage (	RcatImage
name (	Rname
level (Rlevel
intimacy (Rintimacy
sick (Rsick
hasTreat	 (RhasTreat&
startTreatTime
 (RstartTreatTime$
treatmentTime (RtreatmentTime
	needMoney (R	needMoney
	moneyType (R	moneyType
quality (Rquality"^
GetPropsModule
type (Rtype
id (Rid
count (Rcount
time (Rtime"L
DirtyPropsModule
type (Rtype
id (Rid
count (Rcount"(
StrokeCatItemReq
token (	Rtoken"r
StrokeCatItemAck
code (Rcode
message (	Rmessage0
propList (2.StrokeCatPropModuleRpropList"g
StrokeCatPropModule
propType (RpropType
propId (RpropId
	propCount (R	propCount"�
ShelterCatModule
	shelterId (R	shelterId
catId (RcatId
	character (R	character
sex (Rsex
birthday (Rbirthday

generation (R
generation
catImage (	RcatImage
name (	Rname
level	 (Rlevel
intimacy
 (Rintimacy
growth (Rgrowth
health (Rhealth
clean (Rclean
hunger (Rhunger
thirsty (Rthirsty
defecate (Rdefecate"
sharpenClaws (RsharpenClaws
	happiness (R	happiness
stamina (Rstamina
charm (Rcharm 
basicsCharm (RbasicsCharm
strength (Rstrength&
basicsStrength (RbasicsStrength
charmAdd (RcharmAdd 
strengthAdd (RstrengthAdd
sick (Rsick
userId (RuserId0
sickCalculationTime (RsickCalculationTime
	startTime (R	startTime
endTime (RendTime*
listingPriceType (RlistingPriceType"
listingPrice  (RlistingPrice
status! (Rstatus
quality" (Rquality"?
RecoverShelterReq
token (	Rtoken
catId (RcatId"W
RecoverShelterAck
code (Rcode
message (	Rmessage
catId (RcatId"(
RedeemCatListReq
token (	Rtoken"m
RedeemCatListAck
code (Rcode
message (	Rmessage+
catList (2.ShelterCatModuleRcatList"?
	RedeemReq
token (	Rtoken
	shelterId (R	shelterId"9
	RedeemAck
code (Rcode
message (	Rmessage"`
PutonShelveReq
token (	Rtoken
catId (RcatId"
listingPrice (RlistingPrice"T
PutonShelveAck
code (Rcode
message (	Rmessage
catId (RcatId"D
LowerShelveReq
token (	Rtoken
	shelterId (R	shelterId">
LowerShelveAck
code (Rcode
message (	Rmessage"*
PsCatListByUserReq
token (	Rtoken"�
PsCatListByUserAck
code (Rcode
message (	Rmessage+
catList (2.ShelterCatModuleRcatList
nowTime (RnowTime"$
PsCatListReq
token (	Rtoken"�
PsCatListAck
code (Rcode
message (	Rmessage+
catList (2.ShelterCatModuleRcatList
nowTime (RnowTime"A
AdoptCatReq
token (	Rtoken
	shelterId (R	shelterId";
AdoptCatAck
code (Rcode
message (	Rmessage"W
SickReductHealthReq
token (	Rtoken
catId (RcatId
count (Rcount"{
SickReductHealthAck
code (Rcode
message (	Rmessage 
reductCount (RreductCount
catId (RcatId"A
SendToHospitalReq
token (	Rtoken
catIds (RcatIds"A
SendToHospitalAck
code (Rcode
message (	Rmessage"=
TakeItHomeReq
token (	Rtoken
catIds (RcatIds"=
TakeItHomeAck
code (Rcode
message (	Rmessage"?
TreatmentPriceReq
token (	Rtoken
catId (RcatId"�
TreatmentPriceAck
code (Rcode
message (	Rmessage
	needMoney (R	needMoney
	moneyType (R	moneyType
catId (RcatId"U
RecyclePropsReq
token (	Rtoken
itemId (RitemId
count (Rcount"h
RecyclePropsAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList"�
FieldModule
id (Rid
userId (RuserId
seedId (RseedId
status (Rstatus
seedTime (RseedTime
endTime (RendTime
nowCount (RnowCount

unLockNeed (R
unLockNeed$
needMoneyType	 (RneedMoneyType
	needMoney
 (R	needMoney"(
UserFieldListReq
token (	Rtoken"l
UserFieldListAck
code (Rcode
message (	Rmessage*
	fieldList (2.FieldModuleR	fieldList"@
UnLockFieldReq
token (	Rtoken
fieldId (RfieldId">
UnLockFieldAck
code (Rcode
message (	Rmessage"#
UserSeedReq
token (	Rtoken"d
UserSeedAck
code (Rcode
message (	Rmessage'
itemList (2.ItemModuleRitemList"Q
SeedReq
token (	Rtoken
fieldId (RfieldId
itemId (RitemId"7
SeedAck
code (Rcode
message (	Rmessage"�
ActivitiesCatModule
catId (RcatId
	character (R	character
sex (Rsex
catImage (	RcatImage
name (	Rname
level (Rlevel
intimacy (Rintimacy
growth (Rgrowth
health	 (Rhealth
stamina
 (Rstamina
charm (Rcharm
strength (Rstrength
status (Rstatus
	startTime (R	startTime
endTime (RendTime
piCount (RpiCount
useTime (RuseTime$
receiveStatus (RreceiveStatus"(
AttackCatListReq
token (	Rtoken"p
AttackCatListAck
code (Rcode
message (	Rmessage.
catList (2.ActivitiesCatModuleRcatList"M
	AttackReq
token (	Rtoken
catId (RcatId
count (Rcount"O
	AttackAck
code (Rcode
message (	Rmessage
catId (RcatId")
DefenseCatListReq
token (	Rtoken"q
DefenseCatListAck
code (Rcode
message (	Rmessage.
catList (2.ActivitiesCatModuleRcatList"8

DefenseReq
token (	Rtoken
catId (RcatId"P

DefenseAck
code (Rcode
message (	Rmessage
catId (RcatId">
AttackReceiveReq
token (	Rtoken
catId (RcatId"
AttackReceiveAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList
catId (RcatId"<
SickCatInfoReq
token (	Rtoken
catId (RcatId"~
SickCatInfoAck
code (Rcode
message (	Rmessage(
catInfo (2.SickCatModuleRcatInfo
catId (RcatId"!
	PickUpReq
token (	Rtoken"_
	PickUpAck
code (Rcode
message (	Rmessage$
catList (2
.CatModuleRcatList"S
GetCoolingReq
token (	Rtoken
playId (RplayId
catId (RcatId"Q
GetCoolingAck
code (Rcode
message (	Rmessage
time (Rtime"Q
MostAttackReq
token (	Rtoken*
catList (2.AttackCatModuleRcatList"=
MostAttackAck
code (Rcode
message (	Rmessage"=
AttackCatModule
catId (RcatId
count (Rcount",
PlayGroundCatListReq
token (	Rtoken"t
PlayGroundCatListAck
code (Rcode
message (	Rmessage.
catList (2.ActivitiesCatModuleRcatList"Q
PlayGroundReq
token (	Rtoken
catId (RcatId
count (Rcount"S
PlayGroundAck
code (Rcode
message (	Rmessage
catId (RcatId"B
PlayGroundReceiveReq
token (	Rtoken
catId (RcatId"�
PlayGroundReceiveAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList
catId (RcatId"U
MostPlayGroundReq
token (	Rtoken*
catList (2.AttackCatModuleRcatList"A
MostPlayGroundAck
code (Rcode
message (	Rmessage",
PlayGroundHistoryReq
token (	Rtoken"m
PlayGroundHistoryAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList"M
MailListReq
token (	Rtoken
limit (Rlimit
page (Rpage"�
MailListAck
code (Rcode
message (	Rmessage!
mailList (2.MailRmailList
total (Rtotal
size (Rsize
current (Rcurrent
pages (Rpages"�
Mail
id (Rid

createTime (	R
createTime
	contentId (R	contentId
gifts (	Rgifts
sendUser (RsendUser
toUser (RtoUser
statue (Rstatue
type (Rtype

readStatue	 (R
readStatue'
pmList
 (2.GetPropsModuleRpmList&
replaceContent (	RreplaceContent"
sendUserName (	RsendUserName"8
MailReceiveReq
token (	Rtoken
ids (Rids">
MailReceiveAck
code (Rcode
message (	Rmessage"5
MailReadReq
token (	Rtoken
ids (Rids";
MailReadAck
code (Rcode
message (	Rmessage"7
MailDeleteReq
token (	Rtoken
ids (Rids"=
MailDeleteAck
code (Rcode
message (	Rmessage"P

MailNewAck
code (Rcode
message (	Rmessage
count (Rcount"?
CatPlayCoolingReq
token (	Rtoken
catId (RcatId"�
CatPlayCoolingAck
code (Rcode
message (	Rmessage
catId (RcatId0
coolingList (2.CoolingModuleRcoolingList"A
CoolingModule
playId (RplayId
cooling (Rcooling"'
PsStatisticsReq
token (	Rtoken"�
PsStatisticsAck
code (Rcode
message (	Rmessage
	catCount1 (R	catCount1

userCount1 (R
userCount1
	catCount2 (R	catCount2

userCount2 (R
userCount2
	catCount3 (R	catCount3

userCount3 (R
userCount3
	catCount4	 (R	catCount4

userCount4
 (R
userCount4"/
AllPlayGroundReceiveReq
token (	Rtoken"p
AllPlayGroundReceiveAck
code (Rcode
message (	Rmessage'
pmList (2.GetPropsModuleRpmList*%
MESSAGE_TYPE
MESSAGE_TYPE_INIT *�
CS
INIT 
BEGIN��
	LOGIN_REQ��

LOGOUT_REQ��
HEARTBEAT_REQ��
	ERROR_REQ��
GETUSERINFO_REQ��
UPUSERINFO_REQ��
GETUSERCATLIST_REQ��

GETCAT_REQ��
CATINFO_REQ��
USERITEM_REQ��
GETUSERTOOLS_REQ��
GETCATHOUSEINFO_REQ��
GETCATBOWLINFO_REQ��
GETCATWATERINFO_REQ��
GETCATTOILETINFO_REQ��
GETCATBOARDINFO_REQ��
GETNOWTIME_REQ��

CATEAT_REQ��
CATDRINK_REQ��
CATCACTTION_REQ��
CATCLEANBODY_REQ��
CATSLEEP_REQ��
CATSCRATCHINGPOST_REQ��
CATSICKJUDGE_REQ��

GMCODE_REQ��
USEPROPS_REQ��
CLEANTOILET_REQ��
ADDWATER_REQ��
REPAIRBOARD_REQ��
UPCATLEVEL_REQ��
GETCATFOODWAREHOUSE_REQ��
GETCATLITTERWAREHOUSE_REQ��
REPLENISHCATFOOD_REQ��
REPLENISHCATLITTER_REQ��
STROKECAT_REQ��
GETINTIMACYREWARD_REQ��
RECEIVEINTIMACYREWARD_REQ��
PRODUCTLIST_REQ��
BUYGOODS_REQ��
WATERUPLEVEL_REQ��
BOARDUPLEVEL_REQ��
BOWLUPLEVEL_REQ��
TOILETUPLEVEL_REQ��
HOUSEUPLEVEL_REQ��
EXCHANGEAVATAR_REQ��
USERAVATARLIST_REQ��
WEARAVATAR_REQ¿
REMOVINGAVATAR_REQÿ
CATEXCREMENTUPLEVEL_REQĿ
CLEANCATEXCREMENT_REQſ
CATPLAY_REQƿ
CATACTION_REQǿ
CATCHANGEHEALTH_REQȿ
GETUSERTASK_REQɿ
FINISHTASK_REQʿ
STARTANSWER_REQ˿
SUBMITQUESTION_REQ̿
SICKCATLIST_REQͿ
SICKTREATMENT_REQο
ACCELERATETREATMENT_REQϿ
STROKECATITEM_REQп
RECOVERSHELTER_REQѿ
REDEEMCATLIST_REQҿ

REDEEM_REQӿ
PUTONSHELVE_REQԿ
LOWERSHELVE_REQտ
PSCATSLISTBYUSER_REQֿ
PSCATSLIST_REQ׿
ADOPTCAT_REQؿ
SICKREDUCTHEALTH_REQٿ
SENDTOHOSPITAL_REQڿ
TAKEITHOME_REQۿ
TREATMENTPRICE_REQܿ
RECYCLEPROPS_REQݿ
USERFIELDLIST_REQ޿
UNLOCKFIELD_REQ߿
USERSEED_REQ�
SEED_REQ�
ATTACKCATLIST_REQ�

ATTACK_REQ�
DEFENSECATLIST_REQ�
DEFENSE_REQ�
ATTACKRECEIVE_REQ�
SICKCATINFO_REQ�

PICKUP_REQ�
GETCOOLING_REQ�
MOSTATTACK_REQ�
PLAYGROUNDCATLIST_REQ�
PLAYGROUND_REQ�
PLAYGROUNDRECEIVE_REQ�
MOSTPLAYGROUND_REQ�
PLAYGROUNDHISTORY_REQ�
MAIL_LIST_REQ�
MAIL_RECEIVE_REQ�
MAIL_READ_REQ�
MAIL_DELETE_REQ�
CATPLAY_COOLING_REQ��
PS_STATISTICS_REQ��
ALLPLAYGROUNDRECEIVE_REQ��	
END��*�
SC
HSC_S2C_INIT 
HSC_S2C_BEGIN��
	LOGIN_ACK��

LOGOUT_ACK��
HEARTBEAT_ACK��
	ERROR_ACK��
GETUSERINFO_ACK��
UPUSERINFO_ACK��
GETUSERCATLIST_ACK��

GETCAT_ACK��
CATINFO_ACK��
USERITEM_ACK��
GETUSERTOOLS_ACK��
GETCATHOUSEINFO_ACK��
GETCATBOWLINFO_ACK��
GETCATWATERINFO_ACK��
GETCATTOILETINFO_ACK��
GETCATBOARDINFO_ACK��
GETNOWTIME_ACK��

CATEAT_ACK��
CATDRINK_ACK��
CATCACTTION_ACK��
CATCLEANBODY_ACK��
CATSLEEP_ACK��
CATSCRATCHINGPOST_ACK��
CATSICKJUDGE_ACK��

GMCODE_ACK��
USEPROPS_ACK��
CLEANTOILET_ACK��
ADDWATER_ACK��
REPAIRBOARD_ACK��
UPCATLEVEL_ACK��
GETCATFOODWAREHOUSE_ACK��
GETCATLITTERWAREHOUSE_ACK��
REPLENISHCATFOOD_ACK��
REPLENISHCATLITTER_ACK��
STROKECAT_ACK��
GETINTIMACYREWARD_ACK��
RECEIVEINTIMACYREWARD_ACK��
PRODUCTLIST_ACK��
BUYGOODS_ACK��
WATERUPLEVEL_ACK��
BOARDUPLEVEL_ACK��
BOWLUPLEVEL_ACK��
TOILETUPLEVEL_ACK��
HOUSEUPLEVEL_ACK��
EXCHANGEAVATAR_ACK��
USERAVATARLIST_ACK��
WEARAVATAR_ACK¿
REMOVINGAVATAR_ACKÿ
CATEXCREMENTUPLEVEL_ACKĿ
CLEANCATEXCREMENT_ACKſ
CATPLAY_ACKƿ
CATACTION_ACKǿ
CATCHANGEHEALTH_ACKȿ
GETUSERTASK_ACKɿ
FINISHTASK_ACKʿ
STARTANSWER_ACK˿
SUBMITQUESTION_ACK̿
SICKCATLIST_ACKͿ
SICKTREATMENT_ACKο
ACCELERATETREATMENT_ACKϿ
STROKECATITEM_ACKп
RECOVERSHELTER_ACKѿ
REDEEMCATLIST_ACKҿ

REDEEM_ACKӿ
PUTONSHELVE_ACKԿ
LOWERSHELVE_ACKտ
PSCATSLISTBYUSER_ACKֿ
PSCATSLIST_ACK׿
ADOPTCAT_ACKؿ
SICKREDUCTHEALTH_ACKٿ
SENDTOHOSPITAL_ACKڿ
TAKEITHOME_ACKۿ
TREATMENTPRICE_ACKܿ
RECYCLEPROPS_ACKݿ
USERFIELDLIST_ACK޿
UNLOCKFIELD_ACK߿
USERSEED_ACK�
SEED_ACK�
ATTACKCATLIST_ACK�

ATTACK_ACK�
DEFENSECATLIST_ACK�
DEFENSE_ACK�
ATTACKRECEIVE_ACK�
SICKCATINFO_ACK�

PICKUP_ACK�
GETCOOLING_ACK�
MOSTATTACK_ACK�
PLAYGROUNDCATLIST_ACK�
PLAYGROUND_ACK�
PLAYGROUNDRECEIVE_ACK�
MOSTPLAYGROUND_ACK�
PLAYGROUNDHISTORY_ACK�
MAIL_LIST_ACK�
MAIL_RECEIVE_ACK�
MAIL_READ_ACK�
MAIL_DELETE_ACK�
MAIL_NEW_ACK��
CATPLAY_COOLING_ACK��
PS_STATISTICS_ACK��
ALLPLAYGROUNDRECEIVE_ACK��B!
com.server.networkBClientProtobproto3