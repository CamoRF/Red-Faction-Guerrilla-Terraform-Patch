highestUid = 0
for i=0, rfg.ExplosionInfos:Length(), 1 do
    local Info = rfg.ExplosionInfos[i]
    if(Info ~= nil) then
    --rsl.Log("{} UID = {}\n", Info.Name, Info.UniqueId)
        if Info.UniqueId > highestUid then
        highestUid = Info.UniqueId
    end
    end
end

rsl.Log("Highest explosion UID = {}\n", highestUid)