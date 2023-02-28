--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Vanilla Gravity", 1.0, false, false)
Vanilla = rfg.Vector:new(0.0, -9.8, 0.0)
rfg.SetGravity(Vanilla)
rsl.Log("Vanilla Gravity Set [Manual]\n")