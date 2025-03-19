
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
	-- south = "streetcenter6",
	
	longDescription = ""
}
streetcenter5 = StreetCenter5


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

StreetMain6 = Room:new {
	name = "streetmain6",
	
	west = "streetmain5",
	--east = "streetmain7",
}
streetmain6 = StreetMain6

----------------------------------------------------------------------------------

-- state:
-- 0: walking in first time, or after using coptalk
-- 1: has chosen "I came in for a donut. Is there some law against that?", which activates some options without kicking out
-- 2: has left room and come back, angering cop
-- 11: said CopTalk level 1 line
-- 12: said CopTalk level 2 line
s.donutworld = 0
s.usingCopTalk = 0
DonutWorld = Room:new {
	
	name = "donutworld",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	north = "streetwest2",
	
	longDescription = "This is a Donut World. A SEA cop who looks like a sumo wrestler is eating donuts and caffeine at a table by the door. He gives you an ugly look when you walk in.",
	description = "This is Donut World.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { function() if (s.donutworld < 2) then return "Hey! We don't allow your kind in Donut World, hamsterhead." else
				return "Back again? I warned you once. Looking for trouble, citizen?" end end }
		},
				
		{
			condition = function() return s.donutworld < 2 end,
			options = {
				{
					condition = function() return s.donutworld == 0 and s.usingCopTalk >= 2 end,
					line = "Saint Patty's Day. I'm looking for the Little People, don't you know..",
					response = "Mulligan! I can barely understand your thick Irish accent! And I almost didn't recognize you!",
					onEnd = function() s.donutworld = 12; end
				},
				{
					condition = function() return s.donutworld == 0 and s.usingCopTalk >= 1; end,
					line = "Sure and begorrah, O'Riley. If you don't recognize me, you'll get my Irish up.",
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 11; end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I came in for a donut. Is there some law against that?",
					response = "This is a donut shop, citizen. Only cops are allowed in donut shops.",
					onEnd = function() s.donutworld = 1 end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I'm looking for pirated software.",
					response = "That's it your under arrest.",
					onEnd = function() GoToRoom("streetwest2"); ShowMessage("<You were arrested>") end
				},
				{
					line = "Drop dead, flatfoot.",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "You'll never take me alive, copper!",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Forgive me, sir. I thoroughly despise myself for making such a blunder.",
					response = "Just don't let me catch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
				{
					condition = function() return s.donutworld == 1 end,
					line = "Am I ever going to catch a break in this game?",
					response = "Just don't let me catch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
			}
		},
		{
			condition = function() return s.donutworld == 2 end,
			options = {
				{
					condition = function() return s.usingCopTalk >= 2; end,
					line = "Sure and begorrah, O'Riley. If you don't recognize me, you'll get my Irish up.",
					response = "FMulligan! I can barely understand your thick Irish accent! And I almost didn't recognize you!",
					onEnd = function() s.donutworld = 12; end
				},
				{
					condition = function() return s.usingCopTalk >= 1 end,
					line = "Well, now! My Irish eyes are smiling, O'Riley! Corned beef and cabbage! Got any news?",
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 11; end
				},
				{
					line = "Can't a man get a donut in this town without getting arrested?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Yeah, I'm looking for trouble. Have you seen any?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Sorry, my mistake. I left my brain in my other pants.",
					response = "I've warned you about this before! You're under arrest!",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
			}
		},
		
		{
			condition = function() return s.donutworld >= 11 end,
			options = {
				{
					line = "Begorrah! I forgot the comlink number for the Chiba Tactical Police!",
					response = "Don't worry. It's KEISATSU. Better write it down this time.",
				},
				{
					line = "What's the password for the Software Enforcement Agency? Is it \"Wild Irish Rose?\"",
					response = "Wild Irish Rose is a hooker on Memory Lane! The coded SEA password is SMEEGLDIPO, remember?",
				},
				{
					line = "O'Riley! I heard the changed the Fuji Electric password to \"Uisquebaugh.\" Is that right?",
					response = "The coded Fuji password is ABURAKKOI. They haven't changed it in years.",
				},
				{
					condition = function() return s.donutworld >= 12 end,
					line = "Have you heard any news, then, O'Riley? Found out where the Little People keep their warez?",
					response = "Just got through questioning Shiva. She says illegal warez are available on the Gentleman Loser DB.",
				},
				{
					condition = function() return s.donutworld >= 12 end,
					line = "Fergus gave me the second level password for the Chiba Tactical Police but I seem to have forgotten it again!",
					response = "You seem to be forgetting a lot! The coded word is SNORSKEE.",
				},
			}
		},
	}
}

function DonutWorld:UseSkill(skill)
	-- if using CopTalk before we've opened our mouth, active cop mode
	if (skill.name == "CopTalk" and not s.hasTalkedInRoom) then
		s.usingCopTalk = s.skillLevels[400]

print("using coptalk", skill.name, s.usingCopTalk)

		-- immediately talk
		self:ActivateConversation()
	end

end

function DonutWorld:OnEnterRoom()
	s.usingCopTalk = 0
	Room.OnEnterRoom(self)
end

function DonutWorld:OnExitRoom()
	-- if we used coptalk, reset to "happy cop" on next enter
	if (s.usingCopTalk) then
		s.donutworld = 0
	-- otherwise use "angry cop" mode
	else
		s.donutworld = 2
	end
end

donutworld = DonutWorld

-------------------------------------------------------------------------------------

LarryCopTalkShop = ShopBox:new {
	items = { 400 },
}

s.larrys = 0
s.larry_arrested = false
Larrys = Room:new {
	name = "larrys",
	onEnterConversation = "onEnterRoom",
	hasPerson = function() return s.larry_arrested == false end,
	
	south = "streetcenter1",
	
	longDescription = "LARRY'S is one of Chiba's dubious software stores. The walls are lined with slivers of microsoft, spikes of colored silicon mounted on cardboard for display. The shaved head of Larry Moe, with dozens of Microsofts protruding from the carbon socket behind is left ear, is visible beside the counter.",
	description = "LARRY'S is one of Chiba's dubious software stores.",

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
	s.larrys = 0
	Room.OnEnterRoom(self)
end

larrys = Larrys

-------------------------------------------------------------------------------------

s.massageparlor = 1
MassageParlor = Room:new {
	name = "massageparlor",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	
	west = "streetcenter1",
	
	longDescription = "A beautiful woman names Akiko is waiting for you here beside a massage table. This is a clean shop with a stainless steel floor.",
	
	description = "The massage parlor.",
		
	conversations = {
		{
			tag = "onEnterRoom",
			lines = { "Greetings, cowboy. What service may I perform for you today?" },
		},
		
		{
			tag = "lawbot",
			lines = {
				"Look out! It's the lawbot!",
			},
			onEnd = function() ShowMessage("<You were arrested>", function() GoToRoom("streetcenter1") end, true) end
		},

		{
			tag = "moreinfo",
			lines = { "I have more info, if you have more money," },
			onEnd = function(self) print("switchibnv to lawbot"); self:ActivateConversation("lawbot") end
		},

		{
			options =
			{
				{
					line = "I'm sure I'll think of something.",
					onEnd = function(self) print("self", self); self:ActivateConversation("lawbot") end
				},
				{
					line = "Uhh, excuse me, I'm just passing through...",
					response = "You don't know what your missing, cowboy.",
					onEnd = function(self) self.stoptalking = true end
				},
				{
					line = "I wanna buy some info, babe.",
					response = function(self) return self:BuyInfo() end,
					onEnd = function(self) self:ActivateConversation(self.nextConvo) end
				},
			}
		},
	},
	
	info = {
		[1] = { cost = 20, message = "Here's a hot tip. The Panther Modern link code is \"CHAOS\". The password is \"MAINLINE\". They can help you." },
		[2] = { cost = 50, message = "The banking center is on the Freeside orbital colony, but the link number for the Bank of Zurich is \"BOZOBANK\"." },
		[3] = { cost = 75, message = "Be careful when dealing with the Moderns. Not all of them will be your friends." },
		[4] = { cost = 100, message = "Some cowboy said he avoids court fees when he gets arrested by setting up multiple bank accounts." },
		[5] = { cost = 150, message = "Just heard that Mass Biolabs finished work on a cyberspace superdeck they call \"CyberEyes\". Apparently, with CyberEyes, you don't need a regular cyberdeck to get around in cyberspace. It stores programs in your head!" },
	},

	
	stoptalking = false
}


function MassageParlor:BuyInfo()
print("buy info", self);
	
	if (s.money < self.info[s.massageparlor].cost) then
		self.nextConvo = "lawbot"
		return "Take a hike, meatball! You can't afford it!"
	elseif (s.massageparlor <= #self.info) then
		self.nextConvo = "moreinfo"
		s.money = s.money - self.info[s.massageparlor].cost
		s.massageparlor = s.massageparlor + 1
		return self.info[s.massageparlor - 1].message
	else
		self.nextConvo = "lawbot"
		return "You know more than me now."
	end
end

massageparlor = MassageParlor

function MassageParlor:OnEnterRoom()
	print("massage salf", self)
	Room.OnEnter(self)
end

function MassageParlor:GetNextConversation(tag)
	if (self.stoptalking) then
		return nil
	end

	return Room.GetNextConversation(self, tag)
end

---------------------------------------------------------------------------

s.shins = 0

Shins = Room:new {
	name = "shins",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetcenter2",
	
	longdescription = "Shin's Pawn Shop is filled with odd looking junk that nobody wants, glued to thei respective display shelves by time and dirt. The smell of raw fish wafts in from a nearby sushi stall. Shin eyes you with a mixture of hope, greed and suspicion.",
	
	hasAskedAboutRush = false,
	boughtDeck = false,
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "Ah. You back. I have your deck. " },
			onEnd = function(self) self:ActivateConversation("firstChoice") end,
		},
		
		{
			tag = "firstChoice",
			options =
			{
				{
					condition = function(self) print("self",self); return not self.hasAskedAboutRush end,
					line = "Why are you in such a rush to give me my deck back?",
					response = "Your deck scare away good customer. No more favor.",
					onEnd = function(self) self.hasAskedAboutRush = true; self:ActivateConversation("firstChoice") end
				},
				{
					line = "Okay. Give me the deck. I can't operate without one.",
					response = function(self) if table.containsArrayItem(s.inventory, 1) then return "Give ticket and money. Shin busy. Many customer." else
						return "No have ticket? Shin give deck anyways." end end,
					onEnd = function(self)
							table.removeArrayItem(s.inventory, 1)
							local shop = OpenBox("ShinShop")
						end
				},
				{
					line = "I don't have the cash right now, I'll come back later.",
					response = "What? I no want deck! Here! Take deck now! No charge! Go away!",
					onEnd = function(self) ShowMessage("Shin gives you your deck."); table.append(s.inventory, 100); self:ActivateConversation("secondChoice") end
				},
			}
		},

		{
			tag = "secondChoice",
			options =
			{
				{
					condition = function(self) return self.boughtDeck end,
					line = "Thanks for my deck, Shin. I really appreciate you looking after it.",
					onEnd = function(self) self:KickedOut() end,
				},
				{
					line = "Okay, pal! I'll go away! And I'll tell all my friends about this place!",
					onEnd = function(self) self:KickedOut() end,
				},
				{
					condition = function(self) return not self.boughtDeck end,
					line = "Thanks, Shin. I knew you'd see it my way.",
					onEnd = function(self) self:KickedOut() end,
				},
			}
		},
		
		{
			tag = "boughtChoice",
			options =
			{
				{
					line = "Thanks, Shin. I knew you'd see it my way.",
					onEnd = function(self) ShowMessage("Shin slams the door <smething>") GoToRoom("streetcenter2") end,
				},
			}
		}

	}
}
shins = Shins

function Shins:KickedOut()
	ShowMessage("Shin slams and bolts the door behind you.", function() GoToRoom("streetcenter2") end, true)
end

function Shins:OnExitRoom()
	s.shins = 1
end

ShinShop = ShopBox:new {
	items = { 100 },
}

function ShinShop:OnBoughtSoldItem(clickId)
	ShopBox.OnBoughtSoldItem(self, clickId)

	Shins.boughtDeck = true
	Shins:ActivateConversation("secondChoice")
end

function ShinShop:CannotAfford(itemIndex)
	ShopBox.CannotAfford(self, itemIndex)
	Shins:ActivateConversation("firstChoice")
end

function ShinShop:HandleClickedExit()
	Shins:ActivateConversation("firstChoice")
	self:Close()
end


--------------------------------------------------------------------------

DeaneCryptoShop = ShopBox:new {
	items = { 400 },
}

DeaneSkillShop = ShopBox:new {
	items = { 400 },
}

s.deane = 1
Deane = Room:new {
	name = "deane",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetcenter5",
	
	longdescription = "You find Julius Deane's office in a warehouse behind Ninsei. You get the impression Julius has a gun pointed at you under the desk.",
	description = "In Julius Deane's office.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "What brings you around, boyo? I deal in exotic hardware and information." },
			onEnd = function() s.deane = 1 end
		},
			
		{
			condition = function() return s.deane == 1; end,
			options = {
				{
					line = "I'm just looking around right now.",
					response = "Go hand around someone else's office. I'm a busy man.",
					onEnd = function() GoToRoom("streetcenter5"); end
				},
				{
					line = "My friends tell me that someone is trying to kill me. Heard anything?",
					response = "Not always easy to know who your friends are, is it? I haven't heard anything about it.",
					onEnd = function() s.deane = 2; end
				},
				{
					line = "What do you know about",
					hasTextEntry=true,
					onEnd = function() s.deane = 3; end
				}

			}
		},
		
		{
			condition = function() return s.deane == 2; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
					onEnd = function() s.deane = 3; end
				},
				{
					line = "Maybe the people from Cheap Hotel are after me? I ran up a big bill there.",
					response = "Of course, if I did hear something, I might not be able to tell you. Biz being what it is, you understand.",
					onEnd = function() s.deane = 1; end
				},
			}
		},
		
		{
			condition = function() return s.deane == 3; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
				},
			}
		},
		
		{
			tags = { "_cryptology", "_upgrade" },
			lines = { "I can upgrade you in Cryptology for $2500 per level if you already have the skill chip." },
			onEnd = function() OpenBox("DeaneCryptoShop") end
		},
		{
			tags = { "_chip", "_skill", "_skills", "_chips" },
			lines = { "I've got Bargaining, Psychoanalysis, Philosophy, and Phenomenology at $1000 each. Or I can upgrade certin skills." },
			onEnd = function() OpenBox("DeaneSkillShop") end
		},
		{
			tags = { "_neuromancer" },
			lines = { "It's an old novel by Willam Gibson." },
		},
		{
			tags = { "_fuji" },
			lines = { "I've heard the password is \"DUMBO\", but that's probably in code." },
		},
		{
			tags = { "_hitachi" },
			lines = { "Just one word you need to remember: \"GENESPLICE\"." },
		},
		{
			tags = { "_hosaka" },
			lines = { "I've heard the password is \"VULCAN\" but that's probably in code." },
		},
		{
			tags = { "_musabori" },
			lines = { "I've heard the password is \"PLEIADES\", but that's probavly in code." },
		},
		{
			tags = { "_hardware" },
			lines = { "Only have one thing right now. Maybe you're interested in it." },
			onEnd = function() OpenBox("DeaneGasMaskShop") end
		},
		{
			tags = { "_software", "_rom" },
			lines = { "Try the Finn at Metro Holografix for that sort of thing." },
		},
	}
}

deane = Deane


s.moderns = 1
PantherModerns = Room:new {
	name = "panthermoderns",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	south = "larrys",
	
	longdescription = "The meeting room of the Panther Moderns, presently occupied by their leader, Lupus Yonderboy. He's dressed in a polycarbon suit and his eyes have been modified to catch the light like a cat's. Lupus is watching you with a slight smile on hit lips. Tattooed on his hand is the word, \"CHAOS\"",
	description = "The meeting room of the Panther Moderns.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "You got past Larry. That's good. You won't get past me. That's business." },
			onEnd = function() s.moderns = 1 end
		},
		
		{
			condition = function() return s.moderns == 1; end,
			options = {
				{
					line = "Lupus, my man! I hear you're the kind of guy who helps stray cowboys. Can you answer some questions for me?",
					response = "aadsd",
				},
				{
					line = "Geez, you're really a funny-looking dweeb, aren't you?",
					response = "asdasd",
--					onEnd = function() s.deane = 2; end
				},
				{
					line = "Exactly what is a Panther Modern?",
					response = "Chaos. That is our mode and modus. That is our central kick. Believe it.",
					onEnd = function(self) s.moderns = 2; self:ActivateConversation(); end
				},
			}
		},

		{
			condition = function() return s.moderns == 2; end,
			lines = { "Matt Shaw says you're all right. So talk. What do you want to know?" },
		},
		
		{
			condition = function() return s.moderns == 3; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
				},
			}
		},


		{
			tags = { "_skill", "_skills", "_chip", "_chips", "_evasion" },
			lines = { "I can sell you an Evasion chip for $2000. You'll need it for protection in Cyberspace." },
			onEnd = function(self) OpenBox("ModernEvasionShop") end
		},

		{
			tags = { "_software" },
			lines = { "Try the Finn. I hear Drill 1.0 is a great icebreaker." },
		},

		{
			tags = { "_neuromancer" },
			lines = { "Sound familiar. It's an old computer game, or a book, or something like that, right?" },
		},

		{
			tags = { "_ai" },
			lines = { "Turing knows about them. Try cycling through your skills in combat. I hear that one is not enough." },
		},

		{
			tags = { "_cyberspace" },
			lines = { "Cyberspace is reality, wilson." },
		},

		{
			tags = { "_bank" },
			lines = { "I've been siphoning from account number 646328356481, for years." },
		},

		{
			tags = { "_pass", "_sense/net", "_security" },
			lines = { "If you want a ROM Construct from Sense/Net, I can sell you a Security Pass to get you into the building." },
			onEnd = function(self) OpenBox("ModernPassShop") end
		},

		{
			tags = { "_rom", "_rom construct" },
			lines = { "Sense/Net has all the ROM Constructs in their Vault. Hard to get in there." },
		},
	}
}
pantermoderns = PantherModerns

----------------------------------------------------

MetroShop = ShopBox:new {
	items = {
		222, -- DECODER 1.0
		215, -- BLOWTORCH 1.0
		229, -- DRILL 1.0
		253, -- PROBE 1.0
		200, -- COMLINK 1.0
	}
}

MetroJoystickShop = ShopBox:new {
	items = { 5 }
}

MetroSkillShop = ShopBox:new {
	items = { 403, 404 }
}

s.metro = 0
Metro = Room:new {
	name = "metro",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	south = "streetmain2",
	
	longdescription = "You're in Metro Holografix.",
	description = "You're in Metro Holografix.",

	conversations = {
		{
			tag = "onEnter",
			lines = { "Hey kid! You need some chips or software? I just got some new stuff from those bridge-and-tunnel kids in Jersey." },
			onEnd = function() s.metro = 1 end
		},
		
		{
			condition = function() return s.metro == 1 end,
			options =
			{
				{
					line = "Yeah, Finn. I'm looking for some hot softwarez.",
					response = "You want software, you got software.",
					onEnd = function() s.metro = 4; OpenBox("MetroShop"); end
				},
				{
					line = "I'm just browsing right now.",
					response = "Hope you're not allergic to dust. Can I answer any questions?",
					onEnd = function() s.metro = 2; end
				},
				{
					line = "I need a scan, Finn. Then, maybe I'll buy something.",
					response = "Scanned when you came in. No implants, no biologicals. You're clean.",
					onEnd = function() s.metro = 3; end
				}
			}
		},

		{
			condition = function() return s.metro == 2 end,
			options =
			{
				{
					line = "Hey, Finn, did anyone ever tell you your head looks like it was designed in a wind tunnel?",
					response = "You got about as much class as those yahoos from Jersey. Get out of here!",
					onEnd = function(self) GoToRoom(self.south) end
				},
				{
					line = "Okay, what do you know about",
					hasTextEntry=true,
					onEnd = function() s.metro = 3; end
				},
			}
		},
		
		{
			condition = function() return s.metro >= 3 end,
			options =
			{
				{
					line = "Tell me about",
					hasTextEntry=true,
				},
				{
					condition = function() return s.metro == 3; end,
					line = "Leave me alone! I said I'm just browsing!",
					response = "Well, excuse me! Sounds like someone's having a rough day!",
					onEnd = function(self) s.metro = 4; GoToRoom(self.south) end
				},

			}
		},

		{
			tags = { "_software", "_warez" },
			lines = { "You want software, you got software." },
			onEnd = function() s.metro = 4; OpenBox("MetroShop"); end,
		},
		{
			tags = { "_skill", "_skills", "_chip", "_chips" },
			lines = { "You want software, you got software." },
			onEnd = function() s.metro = 4; OpenBox("MetroShop"); end,
		},
		{
			tags = { "_rom" },
			lines = { "You'll have to hit Sense/Net for one of those." },
		},
		{
			tags = { "_joystick" },
			lines = { "So, you're on a holy mission, eh? I got what you need." },
			onEnd = function() OpenBox("MetroJoystickShop"); end,
		},
		{
			tags = { "_neuromancer" },
			lines = { "It's an old novel by Willam Gibson." },
		},
		{
			tags = { "_ai" },
			lines = { "Artificial Intelligence. A smart computer. They design all the ice." },
		},
	}

}
metro = Metro

------------------------------------------

Matrix = Room:new {
	name = "matrix",
	hasPerson = true,
	
	north = "streetmain4",
	
	longDescription = "The Matrix Restaurant is the place to be if you're a wealthy cowboy in Chiba City. This is a club for Members Only. When you enter, you see Emperor Norton and King Osric, deep in a conversation. There are waiters around, but they're respectfully staying out of sight. There's also a PAX terminal here.",
	description = "You're in the Matrix Restaurant."
}
matrix = Matrix

function Matrix:HandleEnter(desc)
	local message = desc
	local postFunc = nil

	if (not table.containsArrayItem(s.inventory, 4)) then
		message = message .. "\n\nYou are kicked out for not having a pass."
		postFunc = function(self) GoToRoom(self.north) end
	end

	-- true means to pause before continuing
	ShowMessage(message, postFunc, postFunc ~= nil)
end

function Matrix:OnFirstEnter()
	self:HandleEnter(self.longDescription)
end

function Matrix:OnEnter()
	self:HandleEnter(self.description)
end

-------------------------------------------------

EdosShop = ShopBox:new {
	items = {
		103,
		108,
		109,
		102,
		105,
		110,
		116,
		111,
	}
}

function EdosShop:OnBoughtSoldNothing()
	currentRoom:ActivateConversation("boughtNothing")
end

s.edosGaveCaviar = false
CrazyEdos = Room:new {
	name = "crazyedos",
	hasPerson = true,
	onEnterConversation =
		function(self)
			if (s.edosGaveCavier) then
				return "mainPrompt"
			elseif (table.containsArrayItem(s.inventory, 2)) then
				return "hasCaviar"
			else
				return "mentionCaviar"
			end
		end,

	north = "streetmain3",
	
	longDescription = "You're in Crazy Edo's Used Hardware Emporium. Edo's eyes instantly light up as he recognizes you. A vast array of scratched, dented, twisted and dusty computer hardware lines the walls. Loose cables litter the floor.",
	description = "Crazy Edo's Used Hardware Emporium",
	
	conversations = {
		{
			tag = "mentionCaviar",
			lines = { "Hey! You said you'd bring me some caviar the next time you came in!" },
			onEnd = function(self) self:ActivateConversation("caviarChoices") end
		},

		{
			noCancel = true,
			tag = "caviarChoices",
			options = {
				{
					line = "Did I say that? Sorry. Guess I'm not thinking too clearly. I spent the night sleeping in spaaghetti.",
					onEnd = function(self) self:ActivateConversation("caviarOffer") end
				},
				{
					line = "Get your own caviar! Go squeeze a sturgeon! I'm no delivery boy!",
					response = "You having a rough day or something?",
					onEnd = function(self) self:ActivateConversation("caviarOffer") end
				},
			},
		},
		{
			tag = "caviarOffer",
			lines = { "For a can of caviar, I'll give you ComLink 2.0. It's great software!" },
			onEnd = function(self) self:ActivateConversation("mainPrompt") end
		},

		{
			tag = "hasCaviar",
			lines = { "You brought the caviar, my old friend! Do you want to trade it?" },
			onEnd = function(self) self:ActivateConversation("caviarTrade") end
		},
		{
			noCancel = true,
			tag = "caviarTrade",
			options = {
				{
					line = "Of course I want to trade it!",
					response = "Domo arigato gozaimasu! Here's your ComLink 2.0 software.",
					onEnd = function(self)
						edosGaveCaviar = true;
						table.append(s.software, 201);
						table.removeArrayItem(s.inventory, 2);
						ShowMessage("Edo installs the software in your deck.");
						self:ActivateConversation("mainChoices");
					end
				},
				{
					line = "I think I'll hang on to it right now.",
					response = "All right. Maybe next time.",
					onEnd = function(self) self:ActivateConversation("mainPrompt") end
				},
			}
		},

		{
			tag = "mainPrompt",
			lines = { "Can I interest you in some hardware? Remember, my prices are much better than that pig, Asano, can do." },
			onEnd = function(self) self:ActivateConversation("mainChoices") end
		},

		{
			noCancel = true,
			tag = "mainChoices",
			options = {
				{
					line = "Let me see what you've got.",
					response = "Tbis is my current inventory. Of course, none of the decks are cyberspace-capable.",
					onEnd = function(self) OpenBox("EdosShop") end
				},
				{
					line = "I'm just browsing.",
					response = "All right. Maybe next time.",
					onEnd = function(self) GoToRoom(self.north) end
				},
			}
		},

		{
			tag = "boughtNothing",
			lines = { "Come back again when you feel like buying." },
			onEnd = function(self) GoToRoom(self.north) end
		},
	}
}
crazyedos = CrazyEdos

function CrazyEdos:OnEnterRoom()
	Room.OnEnterRoom(self)

end
