BoxReceiveResult = {}
local self = BoxReceiveResult

function BoxReceiveResult.Start( ... )
    -- body

end


function BoxReceiveResult.Update( ... )
    -- body

end


function BoxReceiveResult.OnDestroy( ... )
    -- body

end


function BoxReceiveResult.ShowReceivePropsModule( pmList )
    -- body
    self.receiveObjs = ClearObjs(self.receiveObjs)
    for i=1,#pmList do
        local GetPropsModule = pmList[i]
        if(GetPropsModule.type == 1 or GetPropsModule.type == 2) then
            local itemData = item[GetPropsModule.id]
            local obj = GameObject.Instantiate(self.item_receive,self.item_receive.transform.parent)
            obj:SetActive(true)
            self.receiveObjs[GetPropsModule.id] = obj
            obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
            obj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = GetPropsModule.count
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
            end)
        elseif(GetPropsModule.type == 3) then
        elseif(GetPropsModule.type == 4) then
        end
    end
end