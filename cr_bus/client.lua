loadstring(exports.dgs:dgsImportOOPClass())();

local hit = {}
local dgs = {}

addEventHandler('onClientResourceStart', resourceRoot, function()
    for i,v in ipairs(bus_stops) do
        local x,y,z = unpack(v.position)
        hit[i] = Marker(x,y,z, 'cylinder', 1.5, 90, 90, 255, 80)
        addEventHandler('onClientMarkerHit', hit[i], onHit)
    end

    dgs['window'] = dgsWindow(0.35, 0.2, 0.3, 0.5, 'PONTO DE ÔNIBUS - BCA', true)
    dgs['window']:on("dgsWindowClose", function()
        showCursor(false)
        dgs['window']:setVisible(false)
        cancelEvent()
    end)

    gridlist = dgs['window']:dgsGridList(0.0, 0.09, 1, 0.7, true)
    c1 = gridlist:addColumn('Local', 0.65)
    c2 = gridlist:addColumn('Preço', 0.15)
    c3 = gridlist:addColumn('Tempo', 0.15, false, 'right')

    local label = dgs['window']:dgsLabel(0, 0, 1, 0.10, 'Seja bem vindo,escolha onde será sua parada.', true, false, false, false, false, false, false, 'center', 'center')
    local button = dgs['window']:dgsButton(0, 0.8, 1, 0.1, 'IR', true)
    button:on('dgsMouseClick', function(button, state)
    	if button == 'left' and state == 'down' then
    		local selected = gridlist:getSelectedItem()
    		if selected ~= -1 then
    			triggerServerEvent('bca >> trip', localPlayer, localPlayer, selected, calculate(bus_stops[selected]['position'], 'price'), calculate(bus_stops[selected]['position'], 'time'))
    			dgs['window']:setVisible(false)
    			showCursor(false)
    		end
    	end
    end)
    dgs['window']:setVisible(false)
end)

onHit = function(hitElement)
    if assertHit(hitElement) then
        dgs['window']:setVisible(true)
        showCursor(true)
        refresh()
    end
end

refresh = function()
	gridlist:clearRow()
	for i,v in ipairs(bus_stops) do
		local row = gridlist:addRow()
		gridlist:setItemText(row, c1, v.name)
		gridlist:setItemText(row, c2, '$'.. math.floor(calculate(v.position, 'price')) )
		gridlist:setItemText(row, c3, math.round(calculate(v.position, 'time'), 0)..' min')
	end
end

calculate = function(pos, calcType)
	if calcType == 'price' then
		local price_meter = 0.2
		local playerPos = localPlayer:getPosition()
		local x2,y2,z2 = unpack(pos)
		local distance = getDistanceBetweenPoints3D (playerPos.x, playerPos.y, playerPos.z, x2, y2, z2)
		local calculate = distance * price_meter
		local price = calculate
		return math.floor(price)
	elseif calcType == 'time' then
		local timer_meter = 0.0018
		local playerPos = localPlayer:getPosition()
		local x2,y2,z2 = unpack(pos)
		local distance = getDistanceBetweenPoints3D (playerPos.x, playerPos.y, playerPos.z, x2, y2, z2)
		local calculate = distance * timer_meter
		local timer = calculate
		return (timer)
	else
		return 0
	end
end

assertHit = function(element)
    if element:getType() == 'player' and element == localPlayer then return true
    else return false
    end 
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

addEvent('bca >> playsound', true)
addEventHandler('bca >> playsound', root, function(msc, loop)
	if msc then
		sound = playSound(msc, loop)
	else
		if isElement(sound) then
			destroyElement(sound)
		end
	end
end)
