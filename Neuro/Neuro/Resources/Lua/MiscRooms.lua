
StreetWest1 = Room:new {
	name = "streetwest1",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	east = "streetwest2",
}

function StreetWest1:GetConnectingRoom(direction)
	if (direction == "north") then
		ShowMessage("Chatsubo is closed for good.")
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end
streetwest1 = StreetWest1


StreetWest2 = Room:new {
	name = "streetwest2",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	west = "streetwest1",
	east = "streetwest3",
	north = "bodyshop",
}
streetwest2 = StreetWest2

StreetWest3 = Room:new {
	name = "streetwest3",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	west = "streetwest2",
}
streetwest3 = StreetWest3

