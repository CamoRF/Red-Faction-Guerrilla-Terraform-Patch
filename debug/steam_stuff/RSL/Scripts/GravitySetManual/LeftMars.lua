--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Gravity Left Mars", 1.0, false, false)
LeftMars = rfg.Vector:new(3.72076, 0.0, 0.0) --No pun intended
rfg.SetGravity(LeftMars)
rsl.Log("Gravity Left Mars Set [Manual]\n")