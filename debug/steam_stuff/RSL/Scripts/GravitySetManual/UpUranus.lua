--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Gravity Up Uranus", 1.0, false, false)
UpUranus = rfg.Vector:new(0.0, 8.69, 0.0) --No pun intended
rfg.SetGravity(UpUranus)
rsl.Log("Reversed Uranus Gravity Set [Manual] \n")	