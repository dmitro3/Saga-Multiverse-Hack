require "main/ctrl/Cat"
CatController = {}

function CatController.Setting( catId, k, v )
    -- body
    if(_G["Cats"][catId] ~= nil) then
        _G["Cats"][catId][k] = v
    else
        Debug.LogError("cat empty :"..catId)
    end
end

function CatController.Start( catId )
    if(_G["Cats"][catId] ~= nil) then
        _G["Cats"][catId]:Start()
    end
end

function CatController.FixedUpdate( catId )
    if(_G["Cats"][catId] ~= nil) then
        _G["Cats"][catId]:FixedUpdate()
    end
end


function CatController.OnDestroy( catId )
    if(_G["Cats"][catId] ~= nil) then
        _G["Cats"][catId]:OnDestroy()
        _G["Cats"][catId] = nil
    end
end


return CatController
