ShopView = {}
local self = ShopView



function ShopView.Start( ... )
    -- body
   self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
   self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
   self.SendMsgProducListReq()
   self.Init()
end


function ShopView.Update( ... )
    -- body
end


function ShopView.OnDestroy( ... )
    -- body
end


function ShopView.Init( ... )
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

    local talkTab = {
    "Welcome to the shop, you can choose all kinds of goods.",
    "Welcome to the shop, our ingredients are the freshest.",
    "Welcome to the shop. In the shop, you can buy what cats need every day.",}

    local i = math.floor(Random.Range(1,#talkTab+1))
    self.text_talk:GetComponent("TextMeshProUGUI").text = talkTab[i]

end

--get a list of goods
function ShopView.SendMsgProducListReq( ... )
    -- body
    self.giftObjs = ClearObjs(self.giftObjs)
    self.foodObjs = ClearObjs(self.foodObjs)
    self.itemObjs = ClearObjs(self.itemObjs)
    self.ingredientObjs = ClearObjs(self.ingredientObjs)
    local ProducListReq = {}
    ProducListReq.token = playerData.baseData.data.token
    PublicClient.SendMsgProducListReq(ProducListReq,function ( data )
        -- body
        --Debug.LogError("quantity of goods:"..#data.producs)
        playerData.producs = data.producs
        for i=1,#playerData.producs do
            local ProducModule = data.producs[i]
            local itemData = item[ProducModule.propId]
            if(ProducModule.tab == 1) then
                self.AddFoodObj( ProducModule,itemData )
            elseif(ProducModule.tab == 2) then
                self.AddItemObj( ProducModule,itemData )
            elseif(ProducModule.tab == 3) then
                self.AddGiftObj( ProducModule,itemData )
            elseif(ProducModule.tab == 4) then
                self.AddIngredientObj( ProducModule,itemData )
            end
        end
    end)
end


function ShopView.AddGiftObj( ProducModule,itemData )
    -- body
    local obj = GameObject.Instantiate(self.item_gift,self.item_gift.transform.parent)
    obj:SetActive(true)
    obj.name = "produc_"..ProducModule.id
    self.giftObjs[ProducModule.id] = obj
    obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
    if(ProducModule.limitBuy == 0) then
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = ""
    else
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = "Daily limit: "..ProducModule.limitBuy
    end
    obj.transform:Find("group/text_price"):GetComponent("TextMeshProUGUI").text = ProducModule.costCount
    PoolManager:SpawnAsync(ProducModule.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
    end)
    local buyItem = item[ProducModule.costPropId]
    --Debug.LogError("buyItem.id"..buyItem.id)
    PoolManager:SpawnAsync(buyItem.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("group/icon_gold"):GetComponent("Image").sprite = sprite
    end)
    obj:GetComponent("Button").onClick:RemoveAllListeners()
    obj:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowBoxBuy(ProducModule,itemData)
    end)

end

function ShopView.AddFoodObj( ProducModule,itemData )
    -- body
    local obj = GameObject.Instantiate(self.item_food,self.item_food.transform.parent)
    obj:SetActive(true)
    obj.name = "produc_"..ProducModule.id
    self.foodObjs[ProducModule.id] = obj
    obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
    if(ProducModule.limitBuy == 0) then
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = ""
    else
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = "Daily limit: "..ProducModule.limitBuy
    end
    obj.transform:Find("group/text_price"):GetComponent("TextMeshProUGUI").text = ProducModule.costCount
    PoolManager:SpawnAsync(ProducModule.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
    end)
    local buyItem = item[ProducModule.costPropId]
    PoolManager:SpawnAsync(buyItem.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("group/icon_gold"):GetComponent("Image").sprite = sprite
    end)
    obj:GetComponent("Button").onClick:RemoveAllListeners()
    obj:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowBoxBuy(ProducModule,itemData)
    end)
end

function ShopView.AddItemObj( ProducModule,itemData )
    -- body
    local obj = GameObject.Instantiate(self.item_item,self.item_item.transform.parent)
    obj:SetActive(true)
    obj.name = "produc_"..ProducModule.id
    self.itemObjs[ProducModule.id] = obj
    obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
    if(ProducModule.limitBuy == 0) then
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = ""
    else
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = "Daily limit: "..ProducModule.limitBuy
    end
    obj.transform:Find("group/text_price"):GetComponent("TextMeshProUGUI").text = ProducModule.costCount
    PoolManager:SpawnAsync(ProducModule.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
    end)
    local buyItem = item[ProducModule.costPropId]
    PoolManager:SpawnAsync(buyItem.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("group/icon_gold"):GetComponent("Image").sprite = sprite
    end)

    obj:GetComponent("Button").onClick:RemoveAllListeners()
    obj:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowBoxBuy(ProducModule,itemData)
    end)
end


function ShopView.AddIngredientObj( ProducModule,itemData )
    -- body
    local obj = GameObject.Instantiate(self.item_Ingredient,self.item_Ingredient.transform.parent)
    obj:SetActive(true)
    obj.name = "produc_"..ProducModule.id
    self.ingredientObjs[ProducModule.id] = obj
    obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
    if(ProducModule.limitBuy == 0) then
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = ""
    else
        obj.transform:Find("text_desc"):GetComponent("TextMeshProUGUI").text = "Daily limit: "..ProducModule.limitBuy
    end
    obj.transform:Find("group/text_price"):GetComponent("TextMeshProUGUI").text = ProducModule.costCount
    PoolManager:SpawnAsync(ProducModule.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
    end)
    local buyItem = item[ProducModule.costPropId]
    PoolManager:SpawnAsync(buyItem.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        obj.transform:Find("group/icon_gold"):GetComponent("Image").sprite = sprite
    end)

    obj:GetComponent("Button").onClick:RemoveAllListeners()
    obj:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowBoxBuy(ProducModule,itemData)
    end)
end



function ShopView.ShowBoxBuy( ProducModule,itemData )
    -- body
    self.box_buy:SetActive(true)
    self.box_buy_count = 1
    PoolManager:SpawnAsync(ProducModule.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cur_item:GetComponent("Image").sprite = sprite
    end)
    local buyItem = item[ProducModule.costPropId]
    PoolManager:SpawnAsync(buyItem.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cur_gold:GetComponent("Image").sprite = sprite
        self.icon_buy_cur_item_gold:GetComponent("Image").sprite = sprite
    end)
    self.text_cur_item_name:GetComponent("TextMeshProUGUI").text = itemData.name
    self.text_cur_item_doc:GetComponent("TextMeshProUGUI").text = itemData.tips
    self.text_cur_gold_num:GetComponent("TextMeshProUGUI").text = ProducModule.costCount
    if(ProducModule.limitBuy > 0) then
        self.slider_cur_item_num:GetComponent("Slider").maxValue = ProducModule.limitBuy - ProducModule.buyCount
        self.text_cur_item_limit:GetComponent("TextMeshProUGUI").text = "Daily limit: "..ProducModule.limitBuy
    else
        self.slider_cur_item_num:GetComponent("Slider").maxValue = 99
        self.text_cur_item_limit:GetComponent("TextMeshProUGUI").text = ""
    end
    self.slider_cur_item_num:GetComponent("Slider").onValueChanged:RemoveAllListeners()
    self.slider_cur_item_num:GetComponent("Slider").onValueChanged:AddListener(function ( val )
        -- body
        if(val == 0) then
            val = 1
        end
        self.box_buy_count = val
        self.text_cur_item_num:GetComponent("TextMeshProUGUI").text = math.floor(val)
        self.text_buy_cur_item_gold_num:GetComponent("TextMeshProUGUI").text = math.floor(val * ProducModule.costCount)
    end)
    self.slider_cur_item_num:GetComponent("Slider").value = 0
    self.text_cur_item_num:GetComponent("TextMeshProUGUI").text = math.floor(self.box_buy_count)
    self.text_buy_cur_item_gold_num:GetComponent("TextMeshProUGUI").text = ProducModule.costCount


    self.btn_down:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_down:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        if(self.box_buy_count > 0) then
            self.box_buy_count = self.box_buy_count - 1
        end
        self.slider_cur_item_num:GetComponent("Slider").value = self.box_buy_count
    end)

    self.btn_up:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_up:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        local max = 99
        if(ProducModule.limitBuy > 0) then
            max = ProducModule.limitBuy - ProducModule.buyCount
        end
        if(self.box_buy_count < max) then
            self.box_buy_count = self.box_buy_count + 1
        end
        self.slider_cur_item_num:GetComponent("Slider").value = self.box_buy_count
    end)

    self.btn_box_buy_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_box_buy_quit:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.box_buy:SetActive(false)
    end)

    self.btn_buy:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_buy:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.SendMsgBuyGoodsReq( ProducModule, itemData, self.box_buy_count )
        self.box_buy:SetActive(false)
    end)

end


function ShopView.SendMsgBuyGoodsReq( ProducModule, itemData, val )
    -- body
    local BuyGoodsReq = {}
    BuyGoodsReq.token = playerData.baseData.data.token
    BuyGoodsReq.goodId = ProducModule.id
    BuyGoodsReq.count = math.floor(val)
    PublicClient.SendMsgBuyGoodsReq(BuyGoodsReq,function ( data )
        -- body
        --Debug.LogError("successful purchase")
        ProducModule.buyCount = ProducModule.buyCount + data.addBuyCount
        for i=1,#playerData.producs do
            if(playerData.producs[i].id == ProducModule.id) then
                playerData.producs[i] = ProducModule
                break
            end
        end
        GetUserItems(function ( data )
            -- body
            self.Init()
        end)
        --Debug.LogError("quantity of goods purchased："..#data.items)
        self.ShowBuyResult(data.items)

    end)

end


function ShopView.ShowBuyResult( items )
    -- body
    self.box_buy_result:SetActive(true)
    self.buyObjs = ClearObjs(self.buyObjs)
    for i=1,#items do
        local ItemModule = items[i]
        local itemData = item[ItemModule.propId]
        local obj = GameObject.Instantiate(self.item_buy,self.item_buy.transform.parent)
        obj:SetActive(true)
        self.buyObjs[ItemModule.id] = obj
        obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
        obj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
        end)
    end
end

function ShopView.Quit( ... )
    -- body
    CS.RoleController.Instance.gameObject:SetActive(true)
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("bg_shop")
    UIManager:DelUI("shop_view")
end


