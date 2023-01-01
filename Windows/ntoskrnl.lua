local function getComponentAddress(name)
	return component.list(name)() or error("Required " .. name .. " component is missing")
end

local GPUAddress = getComponentAddress("gpu")

-- Initializing
fillDisplay(0x0000FF)

print('OpenComputers (R) Windows Mine NT (TM) Version 1.0 (Build 1: Service pack 1).\n')

local function centrize(width)
	return math.floor(w / 2 - width / 2)
end

local loadingText = 'Windows Mine NT 1.0'


local function centrizedText(y, color, text)
	component.invoke(GPUAddress, "fill", 1, y, w, 1, " ")
	component.invoke(GPUAddress, "setForeground", color)
	component.invoke(GPUAddress, "set", centrize(#text), y, text)
end

local function title()
	local y = math.floor(h / 2 - 1) + 10
	centrizedText(y, 0xFFFFFF, loadingText)

	return y + 2
end

if not save_mode then
	fillDisplay(0x293133)
	title()
else
	reset()
	fillDisplay(0x000000)
	print('OpenComputers (R) Windows Mine NT (TM) Version 1.0 (Build 1: Service pack 1).\nSecure mode enabled\n')
	print('Loading files')
end


while true do
    local evt = table.pack(computer.pullSignal(0.4))
end