----------------------
-- System Functions --
----------------------

_UGGlobals = { }
_DynamicGlobals = { }
_ActiveTable = ""

-- Assign a value to global variable. Any nil-assignment raises an error.
--
function _CatchNilAssignment(t, k, v)
	if (v == nil) then
		error("attempted to initialize global variable '"..k.."' with nil value")
	elseif (_ActiveTable ~= "") then
		rawset( _DynamicGlobals[ _ActiveTable ], k, v )
	else
		rawset(t, k, v)
	end
end

-- Catch an attempt to write to an undefined global variable
--
function _CatchUndefinedGlobalWrite(t, k, v)
	if (v == nil) then
		error("attempted to initialize global variable '"..k.."' with nil value")
		return
	end

	for i, table in pairs( _DynamicGlobals ) do

		local val = rawget( table, k )
		if (val ~= nil) then
			rawset( table, k, v )
			return
		end

	end

	error("attempted to write to undefined global variable '"..k.."'")
end

-- Find a value in the Dynamic table since it's not in UGGlobals
--
function _GetDynamicGlobal( t, k )
	for i, table in pairs( _DynamicGlobals ) do

		local v = rawget( table, k )
		if (v ~= nil) then
			return v
		end

	end

	error("attempted to read undefined global variable '"..k.."'")
end

-- Prepare to load a lua script into the dynamic table
--
function _PrepareForDynamicGlobals( filename )
	_DynamicGlobals[ filename ] = { }
	_ActiveTable = filename

	setmetatable( _UGGlobals, {__index = _GetDynamicGlobal, __newindex = _CatchNilAssignment} )
end

-- Callback for loading of dynamic table complete
--
function _DynamicGlobalsLoadComplete( )
	_ActiveTable = ""

	setmetatable( _UGGlobals, {__index = _GetDynamicGlobal, __newindex = _CatchUndefinedGlobalWrite} )
end

-- Unload a table of Dynamic globals
--
function _UnloadDynamicGlobals( filename )
	rawset( _DynamicGlobals, filename, nil ) -- erase the entry from the table
end

-- Returns number of elements in a table
--
-- ...:			table of elements
--
-- returns:		number of elements in a table
--
function sizeof_table(...)
	return sizeof_table_do(arg)
end

-- Delay execution for a certain amount of time
--
-- duration:	duration of delay, in seconds (if time_seconds <= 0, execution will delay for exactly one frame)
--
function delay(duration)
	local elapsed_time = 0.0
	repeat
		thread_yield()
		elapsed_time = elapsed_time + get_frame_time()
	until (delay_check_done(elapsed_time, duration))
end

-- Call a function in a new thread
--
-- func_name:	name of function to execute in new thread
-- arg:			(optional) arguments to pass to the function
--
-- returns:		handle to the new thread, nil if thread could not be created
--
function thread_new(func_name, ...)
	return thread_new_do(func_name, arg)
end
