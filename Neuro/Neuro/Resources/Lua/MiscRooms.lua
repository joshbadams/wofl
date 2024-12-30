
StreetWest1 = Room:new {
	name = "streetwest1",
	hasPerson = false,
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
	hasPerson = false,
	hasPax = false,
	hasJack = false,
	
	west = "streetwest1",
	east = "streetcenter1",
	north = "bodyshop",
	south = "donutworld",
}
streetwest2 = StreetWest2

StreetCenter1 = Room:new {
	name = "streetcenter1",
	hasPerson = false,
	hasPax = false,
	hasJack = false,
	
	east = "massageparlor",
	west = "streetwest2",
	north = "larrys",
	south = "streetcenter2",
}
streetcenter1 = StreetCenter1

StreetCenter2 = Room:new {
	name = "streetcenter2",
	hasPerson = false,
	hasPax = false,
	hasJack = false,
	
	east = "shins",
	north = "streetcenter1",
	south = "streetcenter3",
}
streetcenter2 = StreetCenter2

StreetCenter3 = Room:new {
	name = "streetcenter3",
	hasPerson = false,
	hasPax = false,
	hasJack = false,
	
	-- east = "streetmain1",
	west = "cheaphotel",
	north = "streeetcenter2",
	south = "streetcenter4",
}
streetcenter3 = StreetCenter3

StreetCenter4 = Room:new {
	name = "streetcenter4",
	hasPerson = false,
	hasPax = false,
	hasJack = false,
	
	west = "gentlemanloser",
	north = "streetcenter3",
	-- south = "streetcenter5",
}
streetcenter4 = StreetCenter4

DonutWorld = Room:new {
	name = "donutworld",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	north = "streetwest2",
}
donutworld = DonutWorld

Larrys = Room:new {
	name = "larrys",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	south = "streetcenter1",
}
larrys = Larrys

s.massageparlor = 0
MassageParlor = Room:new {
	name = "massageparlor",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	west = "streetcenter1",
	
	longDescription = "A beautiful woman names Akiko is waiting for you here beside a massage table. This is a clean shop with a stainless steel floor.",
	
	description = "The massage parlor.",
		
	conversations = {
		{
			tag = "onEnterRoom",
			lines = {
				"Greetings, cowboy. What service may I perform for you today?"
			},
		},
		
		{
			tag = "lawbot",
			lines = {
				"Look out! It's the lawbot!",
			},
			onEnd = function() ShowMessage("<You were arrested>") end
		},

		{
			options =
			{
				{
					line = "I'm sure I'll think of something.",
					response = " ",
					onEnd = function() Talk("lawbot") end
				},
				{
					line = "Uhh, excuse me, I'm just passing through...",
					response = "You don't know what your missing, cowboy.",
					onEnd = function() self.stoptalking = true end
				},
				{
					line = "I wanna buy some info, babe.",
					response = "Take a hike, meatball! You can't afford it!",
					onEnd = function() Talk("lawbot") end
				},
			}
		},
	},
	
	
	stoptalking = false
}
massageparlor = MassageParlor

function MassageParlor:OnEnter()
	Room:OnEnter()
	s.massageparlor = 0
end

function MassageParlor:GetNextConversation(tag)
	if (self.stoptalking) then
		return nil
	end

	return Room.GetNextConversation(self, tag)
end


Shins = Room:new {
	name = "shins",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	west = "streetcenter2",
}
shins = Shins

CheapHotel = Room:new {
	name = "cheaphotel",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	east = "streetcenter3",
}
cheaphotel = CheapHotel

GentlemanLoser = Room:new {
	name = "gentlemanloser",
	hasPerson = true,
	hasPax = false,
	hasJack = false,
	
	east = "streetcenter4",
}
gentlemanloser = GentlemanLoser


