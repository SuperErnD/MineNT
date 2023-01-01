local bootFilesystemProxy = component.proxy(component.invoke(component.list("eeprom")(), "getData"))

local function dofile(path)
	local stream, reason = bootFilesystemProxy.open(path, "r")
	
	if stream then
		local data, chunk = ""
		
		while true do
			chunk = bootFilesystemProxy.read(stream, math.huge)
			
			if chunk then
				data = data .. chunk
			else
				break
			end
		end

		bootFilesystemProxy.close(stream)

		local result, reason = load(data, "=" .. path)
		
		if result then
			return result()
		else
			error(reason)
		end
	else
		error(reason)
	end
end
function require(pkg)
  if type(pkg) ~= 'string' then return nil end
  if _ENV[pkg] or _G[pkg] then return _ENV[pkg] or _G[pkg] 
  else return dofile(pkg) end --   return _ENV[pkg] or _G[pkg]
end
setmetatable(component, { __index = function(_, k) return component.getPrimary(k) end })
fsaddr = component.invoke(component.list("eeprom")(), "getData")
local _component_primaries = {}
_component_primaries['filesystem'] = component.proxy(fsaddr)
function component.setPrimary(dev, addr)
for k,v in component.list() do
  if k == addr and v == dev then
    _component_primaries[dev] = component.proxy(addr)
  end
end
end
function component.getPrimary(dev)
if _component_primaries[dev] == null then
  for k, v in component.list() do
    if v == dev then component.setPrimary(v,k) break end
  end
end
return _component_primaries[dev]
end

local function loadDriver(name)
  return dofile('/Windows/drivers/' .. name .. '.lua')
end

local g = loadDriver('Graphics')

w, h = g.getResolution()
cx, cy = 1, 1

function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

function reset() 
  cx, cy = 1, 1
end

function print(str)
  str = tostring(str)
  for i = 1, #str do
    local c = str:sub(i,i)
    if c == '\n' then
      cy = cy + 1
      cx = 1
    else
      g.drawText(cx, cy, c)
      cx = cx + 1
    end
      
  end
  cy = cy + 1
end

function print_raw(x, y, str)
  g.drawText(x, y, str)
end

function fillDisplay(color)
  g.setBG(color)
  for i = 1,50,1 do
    g.fill(1,i,w,1)
  end
end

std_error = bsod

function error(errorCode)
  g.fill(1, 2, w, h)
  fillDisplay(0x0000FF)
  print('*** STOP: ' .. errorCode .. ' (?, ?, ?, ?)')
  computer.beep(2000)
  while true do
    sleep(1)
  end
end



_G.clear_screen = function () g.fill(1, 2, w, h) end
_G.print = print
_G.print_raw = print_raw
_G.bsod = error
_G.fillDisplay = fillDisplay
local computer = require('computer')
error('сосать')
sleep(0.5)
local evt = table.pack(computer.pullSignal(0.4))
print(evt[4])
if evt[4] == 66 then _G.save_mode = true end

require('/Windows/ntoskrnl.lua')