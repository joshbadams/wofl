
LarryCopTalkShop = ShopBox:new {
	items = { 400 },
}

s.larrys = 0
s.larry_arrested = false
Larrys = Room:new {
	name = "larrys",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	
	north = "panthermoderns",
	south = "streetcenter1",
	
	longDescription = "LARRY'S is one of Chiba's dubious software stores. The walls are lined with slivers of microsoft, spikes of colored silicon mounted on cardboard for display. The shaved head of Larry Moe, with dozens of Microsofts protruding from the carbon socket behind is left ear, is visible beside the counter.",
	description = "LARRY'S is one of Chiba's dubious software stores.",


	namedAnims = {
		{
			name="larry", x=261, y=127, width=125, height=269, framerate = 4,
			frames = { "larry" },
		},
		{
			name="door", x=8, y=53, width=194, height=318, framerate = 4,
			frames = { "larrydoor" },
		},
	},
	
	conversations = {
		{
			tag = "onEnterRoom",
			lines = { "You looking to buy some softs?" },
		},
		
		{
			condition = function() return s.larrys == 0 end,
			options = {
				{
					line = "Got anything good?",
					response = "All my softs are top quality. Too bad I don't have any right now!"
				},
				{
					line = "I'm looking for the Panther Moderns.",
					response = "The Moderns don't like networking with strangers",
					onEnd = function() s.larrys = 1 end
				},
				{
					line = "I'm a cop. You're under arrest unless you answer some questions.",
					response = "You're not a cop. You're a meatball. I'm calling the Lawbot.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "It's cold outside. I just wanted to come in here and warm up.",
					response = "I'll warm you up with a flamethrower if you don't get out of here, pal.",
					onEnd = function() GoToRoom("streetcenter1") end
				},
				{
					line = "Do you know anything about",
					hasTextEntry=true,
					onEnd = function() s.larrys = 3; print("larrry", s.larrys) end
				}
			}
		},
		
		{
			condition = function() return s.larrys == 1 end,
			options = {
				{
					line = "Does that include wealthy strangers? I can pay for a meeting.",
					response = "How much would you pay for a meeting with the Moderns?",
					onEnd = function(self) s.larrys = 2; self:ActivateConversation() end
				},
				{
					line = "You I have a sudden urge to buy something.",
					response = "All my softs are top quality. Too bad I don't have any right now!"
				},
				{
					line = "You're calling ME strange? Have you looked at yourself lately?",
					response = "How much would you pay for a meeting with the Moderns?",
					onEnd = function(self) s.larrys = 2; self:ActivateConversation() end
				},
				{
					line = "Do you know anything about",
					hasTextEntry=true,
					onEnd = function() s.larrys = 3 end
				}
			}
		},

		{
			condition = function() return s.larrys == 2 end,
			options = {
				{
					line = "100 credits.",
					onEnd = function(self) self:HandlePay(100) end
				},
				{
					line = "200 credits.",
					onEnd = function(self) self:HandlePay(200) end
				},
				{
					line = "300 credits",
					onEnd = function(self) self:HandlePay(300) end
				},
				{
					line = "Whoops! I don't have any money!",
					onEnd = function(self) self:HandlePay(99999999) end
				}
			}
		},
		
		{
			condition = function() return s.larrys == 3 end,
			options = {
				{
					line = "Do you know anything about",
					hasTextEntry=true,
				}
			}
		},

		{
			tag = "getOut",
			lines = { "No money, no meeting. Jack out, clown.", },
			onEnd = function() GoToRoom("streetcenter1") end
		},
		
		{
			tag = "paid",
			lines = {
				"All right. Payment in advance. Let's have at it...",
				"What a rube! You really think I'm going to let you just walk right in there? But thanks for the donation!",
			},
		},
		
		{
			tag = "_unknownentry",
			lines = { "You'd know more I would about that." }
		},
		
		{
			tags = { "_skills", "_skill", "_coptalk", "_chip" },
			lines = { "I can seel you a CopTalk skill chip. $100." },
			onEnd = function() OpenBox("LarryCopTalkShop") end,
		},
	},
}

function Larrys:HandlePay(amount)
	if (s.money >= amount) then
		s.money = s.money - amount
		self:ActivateConversation("paid")
	else
		self:ActivateConversation("getOut")
	end
end

function Larrys:OnEnterRoom()
	self.hasPerson = not s.larry_arrested
	Room.OnEnterRoom(self)

	s.larrys = 0
	if (not s.larry_arrested) then
		self:AddAnimation("larry")
	else
		self:AddAnimation("door")
	end
end

function Larrys:GetConnectingRoom(direction)
--	if (direction == "north" and not s.larry_arrested) then
--		return nil
--	end

	return Room.GetConnectingRoom(self, direction)
end

larrys = Larrys

