--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Reversed Gravity", 1.0, false, false)
UpEarth = rfg.Vector:new(0.0, 9.80665, 0.0)
rfg.SetGravity(UpEarth)
rsl.Log("Reversed Gravity Set [Manual]\n")