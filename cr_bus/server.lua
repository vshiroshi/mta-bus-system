addEventHandler('onResourceStart',  getResourceRootElement(getThisResource()), function()
	for i,v in ipairs(bus_stops) do
		local x,y,z = unpack(v.position)
		local r     = v.rot
		bus_stops_objects = Object(1257, x,y,z, 0, 0, r)
		bus_stops_objects:setData('stops >> name', v.name)
	end

	local bus_object = Object(1923, -1394.02759, 991.90417, 1024.03687, 0)
	bus_object.interior = 15
end)

addEvent('bca >> trip', true)
addEventHandler('bca >> trip', root, function(p, trip, price, time)
	local x,y,z = unpack(bus_stops[trip]['position']);
	local pPos = p:getPosition();
	if getDistanceBetweenPoints3D(pPos.x, pPos.y, pPos.z, x, y, z) < 5 then
		addNotif(p, 'error', 'Você já está nessa parada.');
	else
		if takeMoney(p, price) then
			triggerClientEvent(p, 'bca >> playsound', p, 'files/break.mp3', false)
			fadeCamera(p, false, 0.5)
			setTimer(function()
				addNotif(p, 'info', 'Aguarde '..math.floor(time)..' minutos para chegar no seu destino.');
				local i = math.random(1, #seat_position)
				local x,y,z = seat_position[i][1], seat_position[i][2], seat_position[i][3]
				p.interior = 15;
				p:setPosition(x,y,z);
				toggleAllControls(p, false);
				p:setAnimation("ped", "SEAT_idle", -1, true, false, false )
				triggerClientEvent(p, 'bca >> playsound', p, 'files/traveling.mp3', true)
				fadeCamera(p, true, 3)
				setTimer(function()
					p:setRotation(0, 0, 0);
				end, 2000, 1)
			end, 7000, 1)
				setTimer(function()
					triggerClientEvent(p, 'bca >> playsound', p, false, false)
					triggerClientEvent(p, 'bca >> playsound', p, 'files/break.mp3', false)
					fadeCamera(p, false, 0.5)
					setTimer(function()
						local x,y,z = unpack(bus_stops[trip]['position']);
						p:setInterior(0)
						p:setAnimation(false)
						p:setPosition(x,y,z)
						toggleAllControls(p, true);
						fadeCamera(p, true, 3)
					end, 7000, 1)
				end, time * 40 * 1000, 1)
		else
			addNotif(p, 'error', 'Dinheiro insuficiente.');
		end
	end
end)

addNotif = function(p, type, msg)
	outputChatBox(msg, p, 255, 255, 255, true)
end

takeMoney = function(p, price)
	if getMoney(p) >= price then
		p:takeMoney(price);
		return true
	else
		return false
	end
end

getMoney = function(p)
	return p:getMoney()
end