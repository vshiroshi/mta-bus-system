function dxDrawOctagon3D(x, y, z, radius, width, color)
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		return false
	end

	local radius = radius or 1
	local radius2 = radius/math.sqrt(2)
	local width = width or 1
	local color = color or tocolor(255,255,255,150)

	point = {}

		for i=1,8 do
			point[i] = {}
		end

		point[1].x = x
		point[1].y = y-radius
		point[2].x = x+radius2
		point[2].y = y-radius2
		point[3].x = x+radius
		point[3].y = y
		point[4].x = x+radius2
		point[4].y = y+radius2
		point[5].x = x
		point[5].y = y+radius
		point[6].x = x-radius2
		point[6].y = y+radius2
		point[7].x = x-radius
		point[7].y = y
		point[8].x = x-radius2
		point[8].y = y-radius2
		
	for i=1,8 do
		if i ~= 8 then
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[i+1].x,point[i+1].y,z
		else
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[1].x,point[1].y,z
		end
		dxDrawLine3D(x, y, z, x2, y2, z2, color, width)
	end
	return true
end

markersCache = {}
addEventHandler('onClientResourceStart',  getRootElement(), function()
    for i, gMarker in ipairs(getElementsByType('marker')) do 
	    if gMarker:getData('markerc >> type') then
	    	local x,y,z = getElementPosition(gMarker)
	    	markersCache[gMarker] = {dxCreateTexture('files/'..gMarker:getData('markerc >> type')..'.png'), x, y, z}
	    end
	end
end)

function drawnOctagon()
    for i, v in pairs(markersCache) do 
    	if isElement(i) then
	        local material = v[1]
		    local x,y,z = (v[2]), (v[3]), (v[4])
		    if isElementStreamedIn(i) then
			    local z = z - 1.3
			    local z = z + 0.399
			    local now = getTickCount()
			    local multipler, alpha = interpolateBetween(-0.5, 0, 0, 0.1, 255, 0, now / 2500, "CosineCurve")
			    dxDrawOctagon3D(x, y, z, 1.5, 1.5, tocolor(255,255,255,alpha))
			    local z = z + multipler
			    if material then
			        dxDrawImage3D(x, y, z+2, 1.5, 1.5, material,tocolor(255,255,255,alpha))
			   	end
			end
		end
    end
end
addEventHandler('onClientRender', root, drawnOctagon)

function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... )
    return dxDrawMaterialLine3D( x, y, z, x, y, z - width, material, height, color or 0xFFFFFFFF, ... )
end