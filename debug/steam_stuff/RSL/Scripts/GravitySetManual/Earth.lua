--------------------------------
--ULTIMATE GRAVITY MOD BY CAMO
--------------------------------
rfg.AddUiMessage ("Earth's Gravity", 1.0, false, false)
Earth = rfg.Vector:new(0.0, -9.80665, 0.0)
rfg.SetGravity(Earth)
rsl.Log("Earth's Gravity Set [Manual]\n")	
