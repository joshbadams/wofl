
StreetWest1 = Room:new {
	name = "streetwest1",
	
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
	
	west = "streetwest1",
	east = "streetcenter1",
	north = "bodyshop",
	south = "donutworld",
}
streetwest2 = StreetWest2

StreetCenter1 = Room:new {
	name = "streetcenter1",
	
	east = "massageparlor",
	west = "streetwest2",
	north = "larrys",
	south = "streetcenter2",
}
streetcenter1 = StreetCenter1

StreetCenter2 = Room:new {
	name = "streetcenter2",
	
	east = "shins",
	north = "streetcenter1",
	south = "streetcenter3",
}
streetcenter2 = StreetCenter2

function StreetCenter2:GetConnectingRoom(direction)
	if (direction == "east" and s.shins > 0) then
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end

StreetCenter3 = Room:new {
	name = "streetcenter3",
	
	east = "streetmain1",
	west = "cheaphotel",
	north = "streetcenter2",
	south = "streetcenter4",
}
streetcenter3 = StreetCenter3

StreetCenter4 = Room:new {
	name = "streetcenter4",
	
	west = "gentlemanloser",
	north = "streetcenter3",
	south = "streetcenter5",
	
	longDescription = ""
}
streetcenter4 = StreetCenter4

StreetCenter5 = Room:new {
	name = "streetcenter5",
	
	-- west = "maas",
	east = "deane",
	north = "streetcenter4",
	south = "streetcenter6",
	
	longDescription = ""
}
streetcenter5 = StreetCenter5

StreetCenter6 = Room:new {
	name = "streetcenter6",
	
	west = "spaceport",
	north = "streetcenter5",
	
	longDescription = ""
}
streetcenter6 = StreetCenter6


s.main1Count = 0
StreetMain1 = Room:new {
	name = "streetmain1",
	
	west = "streetcenter3",
	east = "streetmain2",
	
	girlMessage = "One of Lonny Zone's working girls is standing here in the street, leaning against a light tower. She carefully looks you over.",
	
	conversations = {
		condition = function(self) return self.hasPerson end,
		tag = "girlstart",
		lines = {
			"Hey, sailer. New in town?"
		}
	}
}

function StreetMain1:OnEnterRoom()
	Room.OnEnterRoom(self)

--	if (s.mainCount == 2)
	
end

streetmain1 = StreetMain1


StreetMain2 = Room:new {
	name = "streetmain2",
	
	west = "streetmain1",
	east = "streetmain3",
	north = "metro"
}
streetmain2 = StreetMain2

StreetMain3 = Room:new {
	name = "streetmain3",
	
	west = "streetmain2",
	east = "streetmain4",
	north = "streetmid2",
	south = "crazyedos",
}
streetmain3 = StreetMain3

StreetMain4 = Room:new {
	name = "streetmain4",
	
	west = "streetmain3",
	east = "streetmain5",
	south = "matrix",
}
streetmain4 = StreetMain4

StreetMain5 = Room:new {
	name = "streetmain5",
	
	west = "streetmain4",
	east = "streetmain6",
}
streetmain5 = StreetMain5


s.securitybot = 1
StreetMain6 = Room:new {
	name = "streetmain6",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetmain5",
	east = "streeteast2",
	
	longDescription = "You have reached a maximum security gate which blocks your entry to the high-tech area of Chiba City. The security computer scans you.",
	description = "You are at the maximum security gate.",
	
	animations =
	{
		{
			name="lasers", x=1165, y=130, width=55, height=305, framerate = 4,
			frames = { "laser1", "laser2" },
		},
	},

	conversations = {
		{
			tag = "onEnter",
			lines = { "Kudasai, by which company are you employed?" },
			onEnd = function() s.securitybot = 1 end
		},
		
		{
			condition = function(self) return s.securitybot == 1 end,
			options = {
				{
					line = "I'm a volunteer for Hitachi Biotech.",
					response = "You are cleared for limited access. Please proceed directly North to Hitachi Biotech. Be aware that you will not be allowed admittance to any other buildings in this zone.",
					onEnd = function(self) s.securitybot = 2; self:RemoveAnimation("lasers"); end
				},
				{
					line = "Sorry. I just stumbled in here by mistake.",
					onEnd = function(self) GoToRoom(self.west) end,
				},
				{
					line = "I work for",
					hasTextEntry=true,
				},
			}
		},

		{
			tag = "_unknownentry",
			lines = { "You appear to be lost. That company is not in the Chiba high-tech zone." }
		},
		{
			tags = { "_fuji", "_musabori", "_sense/net" },
			lines = { "You are not listed as an employee of the company you named. If you made a mistake, please try again." }
		},
		-- TODO:
		-- "You are also not listed as an employee of that company. Please remain here while I summon the authorities"
		{
			tags = { "_hosaka", "_hosakacorp" },
			lines = { function(self)
				if (s.employed) then return "Domo arigato. You are cleared for entry." end
				return "You are not listed as an employee of the company you named. If you made a mistake, please try again."
				end
			},
			onEnd = function(self) if (s.employed) then s.securitybot = 2; self:RemoveAnimation("lasers"); end end,
		},

	},
}
streetmain6 = StreetMain6

function StreetMain6:GetConnectingRoom(direction)
	if (direction == "east" and s.securitybot == 1) then
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end

StreetMid1 = Room:new {
	name = "streetmid1",
	
	north = "pong",
	south = "streetmid2",
}
streetmid1 = StreetMid1

StreetMid2 = Room:new {
	name = "streetmid2",
	
	east = "asano",
	north = "streetmid1",
	south = "streetmain3",
}
streetmid2 = StreetMid2



StreetEast1 = Room:new {
	name = "streeteast1",

	north = "hitachi",
	south = "streeteast2",
	east = "hosaka",
	west = "fujihq",
}
streeteast1 = StreetEast1


StreetEast2 = Room:new {
	name = "streeteast2",

	north = "streeteast1",
	west = "streetmain6",
	east = "musabori",
	south = "sensenet",
}
streeteast2 = StreetEast2

function StreetEast2:GetConnectingRoom(direction)
	if ((direction == "south" or direction == "east") and not s.employed) then
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end

FreesideStreet1 = Room:new {
	name = "freesidestreet1",
	
	east = "freesidestreet2",
	north = "straylight",
}
freesidestreet1 = FreesideStreet1

FreesideStreet2 = Room:new {
	name = "freesidestreet2",
	
	west = "freesidestreet1",
	east = "freesidestreet3",
	north = "freeside",
}
freesidestreet2 = FreesideStreet2

FreesideStreet3 = Room:new {
	name = "freesidestreet3",
	
	west = "freesidestreet2",
	east = "freesidestreet4",
	north = "berne",
}
freesidestreet3 = FreesideStreet3

FreesideStreet4 = Room:new {
	name = "freesidestreet4",
	
	west = "freesidestreet3",
	north = "gemeinschaft",

	longDescription = "You are outside of Bank Gemeinschaft. A sign on the wall reads, 'WARNING. SECURED AREA. Unauthorized entry punishable by termination'.",
	description = "You are outside of Bank Gemeinschaft. A sign on the wall reads, 'WARNING. SECURED AREA. Unauthorized entry punishable by termination'.",
}
freesidestreet4 = FreesideStreet4
