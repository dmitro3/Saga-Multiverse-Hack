PackageView = {}
local self = PackageView

function PackageView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)

    self.Init()
end

function PackageView.OnEnable( ... )
    -- body
    self.Init()
end


function PackageView.Init( ... )
    -- body
    GetUserItems(function ( data )
        -- body
        self.bg_cur_item:SetActive(false)
        self.foodObjs = ClearObjs(self.foodObjs)
        self.itemObjs = ClearObjs(self.itemObjs)
        self.ingredientObjs = ClearObjs(self.ingredientObjs)
        for i=1,#playerData.itemList do
            local ItemModule = playerData.itemList[i]
            local itemData = item[ItemModule.propId]
            if(itemData.tab == 1) then--food
                local foodObj = GameObject.Instantiate(self.tog_food,self.tog_food.transform.parent)
                foodObj.name = "tog_food_"..ItemModule.propId
                foodObj:SetActive(true)
                self.foodObjs[ItemModule.propId] = foodObj
                foodObj.transform:Find("text_item_name"):GetComponent("TextMeshProUGUI").text = itemData.name
                foodObj.transform:Find("text_item_num"):GetComponent("TextMeshProUGUI").text = ItemModule.propCount
                SetItemSprite(itemData.id,foodObj.transform:Find("icon"))
                foodObj:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
                foodObj:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
                    -- body
                    if(isOn) then
                        self.ShowCurFoodMsg(ItemModule.propId,ItemModule.propCount)
                    end
                end)
            elseif(itemData.tab == 2) then--item
                local itemObj = GameObject.Instantiate(self.tog_item,self.tog_item.transform.parent)
                itemObj.name = "tog_item_"..ItemModule.propId
                itemObj:SetActive(true)
                self.itemObjs[ItemModule.propId] = itemObj
                itemObj.transform:Find("text_item_name"):GetComponent("TextMeshProUGUI").text = itemData.name
                itemObj.transform:Find("text_item_num"):GetComponent("TextMeshProUGUI").text = ItemModule.propCount
                SetItemSprite(itemData.id,itemObj.transform:Find("icon"))
                itemObj:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
                itemObj:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
                    -- body
                    if(isOn) then
                        self.ShowCurItemMsg(ItemModule.propId,ItemModule.propCount)
                    end
                end)
            elseif(itemData.tab == 3) then--ingredients
                local ingredientObj = GameObject.Instantiate(self.tog_ingredient,self.tog_ingredient.transform.parent)
                ingredientObj.name = "tog_ingredient_"..ItemModule.propId
                ingredientObj:SetActive(true)
                self.ingredientObjs[ItemModule.propId] = ingredientObj
                ingredientObj.transform:Find("text_item_name"):GetComponent("TextMeshProUGUI").text = itemData.name
                ingredientObj.transform:Find("text_item_num"):GetComponent("TextMeshProUGUI").text = ItemModule.propCount
                SetItemSprite(itemData.id,ingredientObj.transform:Find("icon"))
                ingredientObj:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
                ingredientObj:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
                    -- body
                    if(isOn) then
                        self.ShowCurItemMsg(ItemModule.propId,ItemModule.propCount)
                    end
                end)
            end
        end
        self.group_tog:SetActive(true)
    end)
    
end



function PackageView.ShowCurFoodMsg( itemID, itemNum )
    -- body
    self.bg_cur_food:SetActive(true)
    local itemData = item[itemID]
    PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cur_food:GetComponent("Image").sprite = sprite
    end)
    self.text_cur_food_name:GetComponent("TextMeshProUGUI").text = itemData.name
    self.text_cur_food_owned:GetComponent("TextMeshProUGUI").text = "owned:"..itemNum
    self.text_cur_food_doc:GetComponent("TextMeshProUGUI").text = itemData.tips
end

function PackageView.ShowCurItemMsg( itemID, itemNum )
    -- body
    self.bg_cur_item:SetActive(true)
    local itemData = item[itemID]
    PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cur_item:GetComponent("Image").sprite = sprite
    end)
    self.text_cur_item_name:GetComponent("TextMeshProUGUI").text = itemData.name
    self.text_cur_item_owned:GetComponent("TextMeshProUGUI").text = "owned:"..itemNum
    self.text_cur_item_doc:GetComponent("TextMeshProUGUI").text = itemData.tips
end


function PackageView.Update( ... )
    -- body
end


function PackageView.OnDestroy( ... )
    -- body
end


function PackageView.Quit( ... )
    -- body
    CS.RoleController.Instance.gameObject:SetActive(true)
    UIManager:ShowUIAsync("main","main_view")
    UIManager:HideUI("package_view")
end
