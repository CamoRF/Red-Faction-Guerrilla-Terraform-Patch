--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Gravity Right", 1.0, false, false)
RightEarth = rfg.Vector:new(0.0, 0.0, 9.80665)
rfg.SetGravity(RightEarth)
rsl.Log("Gravity Right Set [Manual]\n")