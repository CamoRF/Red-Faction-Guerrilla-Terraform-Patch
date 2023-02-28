--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Gravity Left", 1.0, false, false)
LeftEarth = rfg.Vector:new(9.80665, 0.0, 0.0)
rfg.SetGravity(LeftEarth)
rsl.Log("Gravity Left Set [Manual]\n")