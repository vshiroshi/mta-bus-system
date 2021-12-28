txd = engineLoadTXD ( "replace/bus.txd" )
engineImportTXD ( txd, 1923 )
col = engineLoadCOL ( "replace/bus.col" )
engineReplaceCOL ( col, 1923 )
dff = engineLoadDFF ( "replace/bus.dff" )
engineReplaceModel ( dff, 1923 )

for i,v in ipairs(getElementsByType('object')) do
	if v:getModel() == 1923 then
		setElementDoubleSided (v, true)
	end
end