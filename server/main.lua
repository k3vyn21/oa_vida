RegisterServerEvent("oa_vida:showersynchserver")
AddEventHandler("oa_vida:showersynchserver", function(target)
    TriggerClientEvent("oa_vida:showersynchclient", -1, target)
end)

RegisterServerEvent("oa_vida:showerdisableserver")
AddEventHandler("oa_vida:showerdisableserver", function(posx, posy, posz)
    TriggerClientEvent("oa_vida:showerdisableclient", -1, posx, posy, posz)
end)
