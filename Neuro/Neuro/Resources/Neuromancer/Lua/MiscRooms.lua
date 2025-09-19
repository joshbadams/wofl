
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
	Room.OnExitRoom(self)
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

DeaneCryptoShop = UpgradeBox:new {
	items = { 401 },
	overridePrices = { [401] = 2500 },
	maxLevels = { [401] = 4 },
}

DeaneSkillShop = ShopBox:new {
	items = { 406, 407, 408, 409 },
}

s.deane = 1
Deane = Room:new {
	name = "deane",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetcenter5",
	
	longDescription = "You find Julius Deane's office in a warehouse behind Ninsei. You get the impression Julius has a gun pointed at you under the desk.",
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
			tags = { "_unknownentry" },
			lines = { "TEMP TEXT" },
		},
		{
			tags = { "_cryptology", "_upgrade", "_upgrades" },
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



ModernUpsetEvasionShop = ShopBox:new {
	items = { 405 },
	overridePrices = { [405] = 5000 },
}

ModernEvasionShop = ShopBox:new {
	items = { 405 },
}

ModernPassShop = ShopBox:new {
	items = { 6 },
}


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
			lines = { function(self)
				if (s.moderns == 3) then
					return "Don't be s smart mouth this time."
				else
					return "You got past Larry. That's good. You won't get past me. That's business."
				end
			end
			},
			onEnd = function() s.moderns = 1 end
		},
		
		{
			condition = function() return s.moderns == 1; end,
			options = {
				{
					line = "Lupus, my man! I hear you're the kind of guy who helps stray cowboys. Can you answer some questions for me?",
					onEnd = function(self) self:ActivateConversation("mattshaw"); end
				},
				{
					line = "Geez, you're really a funny-looking dweeb, aren't you?",
					response = "Don't like you either. Not Modern. Biz will cost more now.",
					onEnd = function(self) self:ActivateConversation("upset"); end
				},
				{
					line = "Exactly what is a Panther Modern?",
					response = "Chaos. That is our mode and modus. That is our central kick. Believe it.",
					onEnd = function(self) self:ActivateConversation("mattshaw"); end
				},
			}
		},

		{
			condition = function() return s.moderns == 2; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
				},
			}
		},

		{
			tag = "mattshaw",
			lines = { "Matt Shaw says you're all right. So talk. What do you want to know?" },
			onEnd = function() s.moderns = 2 end
		},
		
		{
			tag = "upset",
			lines = { "I can sell you an Evasion skill chip for $5000. You'll need it for protection in Cybersapce." },
			onEnd = function() s.moderns = 3; OpenBox("ModernUpsetEvasionShop"); end
		},

		{
			tag = "upsetBpughtNothing",
			lines = { "Have it your way." },
			onEnd = function() GoToRoom("streetcenter1"); end
		},

		{
			tag = "upsetBpughtSomething",
			lines = { "Maybe you're okay. Anything else you want to ask me?" },
			onEnd = function() s.moderns = 2; end
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
panthermoderns = PantherModerns

function PantherModerns:OnBoughtSoldNothing()
	if (s.moderns == 3) then
		currentRoom:ActivateConversation("upsetBpughtNothing")
	end
end

----------------------------------------------------

MetroShop = ShopBox:new {
	items = {
		222, -- DECODER 1.0
		215, -- BLOWTORCH 1.0
		229, -- DRILL 1.0
		253, -- PROBE 1.0
		199, -- COMLINK 1.0
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
						table.append(s.software, 200);
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

-------------------------------------------------------

s.hitachi = 0
Hitachi = Room:new {
	
	timer = -1,
	
	name = "hitachi",
	onEnterConversation = "onEnter",
	hasPerson = true,

	south = "streeteast1",
	
	longDescription = "Hitachi Biotech is occupied by a woman in a lab coat who seems happy to see you.",
	description = "You're in Hitachi Biotech.",
	
	namedAnims =
	{
		{
			name="nurse", x=660, y=134, width=136, height=266, framerate = 4,
			frames = { "nurse" },
		},
	},
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "Hello! I'm the lab technician. You must be a volunteer for the lung experiment?" },
			onEnd = function(self) self:ActivateConversation("experimentChoice") end
		},
		
		{
			noCancel = true,
			tag = "experimentChoice",
			options = {
				{
					line = "Err... yes. I suppose so...",
					response = "Great! We're currently paying our volunteers $3000 a piece. Wait here and I'll be back in a few minutes.",
					onEnd = function(self)
						s.hitachi = 1
						print("removing anim nurse")
						self:RemoveAnimation("nurse")
						self.timer = StartTimer(20, self, function(self) self:NurseReturn() end)
					end,
				},
				{
					line = "I'm so embarrassed. I just stumbled in here by mistake. Excuse me.",
					response = "You should be embarrased, you fool! Get out of here!",
					onEnd = function(self) GoToRoom(self.south) end
				},
				{
					line = "Actually, I'm just here to steal some time on your cyberspace jack. I know it's illegal, but what the hell...",
					response = "You're right. It is illegal. Have a nice trip to the Justice Booth.",
					onEnd = function(self) ShowMessage("<You were arrested>", function(self) GoToRoom("streeteast1") end, true) end
				},
				{
					line = "Actually, I'm just here to see you. I've heard you're the kind of woman who likes to have fun...",
					response = "I've heard you're the kind of turnip-head who likes getting arrested.",
					onEnd = function(self) ShowMessage("<You were arrested>", function(self) GoToRoom("streeteast1") end, true) end
				},

			},
		},
		
		{
			tag = "noLungs",
			lines = { "Hey! You don't have organic lungs. Get out of here!" },
			onEnd = function(self) ShowMessage("The technician kicks you out of the lab.", function(self) GoToRoom(self.south) end, true) end
		},

		{
			tag = "hasLungs",
			lines = {
				"Thanks for waiting. This won't hurt a bit. Well, maybe a little bit, but you won't feel anything after the anesthetic takes effect.",
				"At least, not while you're asleep. After you're awake, of course, that's another matter entirely. Then it'll hurt like hell.",
				"But hey, you volunteered for this. Nobody forced you into it. Thank you, goodbye."
			},
			onEnd = function(self)
				table.removeArrayItem(s.organs, 302);
				s.money = s.money + 3000;
				ShowMessage("The technician painfully removes both of your lungs.", function(self) GoToRoom("streeteast1") end, true)
			end
		},

	},
}

hitachi = Hitachi

function Hitachi:NurseReturn()
	self:AddAnimation("nurse")
	if (not table.containsArrayItem(s.organs, 302)) then
		self:ActivateConversation("noLungs")
	else
		self:ActivateConversation("hasLungs")
	end
end

function Hitachi:OnEnterRoom()
	Room.OnEnterRoom(self)

	s.hitachi = 0

	self:AddAnimation("nurse")
end

function Hitachi:OnExitRoom()
	Room.OnExitRoom(self)

	StopTimer(self.timer);
end


--------------------------
s.spaceport = 0

Spaceport = Room:new {
	name = "spaceport",
	onEnterConversation = "onEnter",
	hasPerson = true,

	east = "streetcenter6",
	
	longDescription = "This is the busy Chiba City Spaceport. Two JAL shuttles are waiting on the launch pads. A ticket agent with a glued-on smile is waiting for you.",
	description = "This is the busy Chiba City Spaceport.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "Konichiwa! Would you like to buy a ticket?" },
			onEnd = function(self) s.spaceport = 0; end
		},
		
		{
			options = {
				{
					line = "I'd like to buy a ticket.",
					onEnd = function(self) self:ActivateConversation("buyticket") end,
				},
				{
					line = "I just stumbled in here by mistake. Excuse me.",
					response = "Then you can just stumble right back out, wilson!",
					onEnd = function(self) GoToRoom(self.east) end
				},
			}
		},

		{
			tag = "buyticket",
			lines = { "We have non-stop flights leaving for Freeside at $1000 and Zion Cluster at $500. Where would you like to go?" },
			onEnd = function(self) self:ActivateConversation("ticketoptions") end,
		},
		
		{
			noCancel = true,
			tag = "ticketoptions",
			options = {
				{
					line = "Freeside. One person. Non-smoking. What's the holo-movie on this flight?",
					onEnd = function(self) self:BuyTicket("freeside") end,
				},
				{
					line = "Zion Cluster. One person. non-smoking. What's the holo-movie on this flight?",
					onEnd = function(self) self:BuyTicket("zion") end,
				},
				{
					line = "I've changed my mind. I think I'll remain in Chiba for now.",
					onEnd = function(self) GoToRoom(self.east) end,
				},
			}
		},
		{
			tag = "nomoney",
			lines = { "I'm afraid you don't have enough money, citizen." },
			onEnd = function(self) GoToRoom(self.east) end,
		},
		{
			tag = "freeside",
			lines = { "Enjoy your flight to Freeside. You can buy a return ticket when you arrive. The holo-movie is 'Burning Chrome'." },
			onEnd = function(self) GoToRoom(self.east) end,
		},
		{
			tag = "zion",
			lines = { "Enjoy your flight to Ziond. You can buy a return ticket when you arrive. The holo-movie is 'Aliens III'." },
			onEnd = function(self) GoToRoom(self.east) end,
		},

	}

}
spaceport = Spaceport

function Spaceport:BuyTicket(dest)
	local cost = 1000
	if (dest == "zion") then
		cost = 500
	end

	if (s.money < cost) then
		self:ActivateConversation("nomoney")
	else
		s.money = s.money - cost
		s.flightdest = dest
		GoToRoom("shuttle")
	end
end


------------------------------------------

Shuttle = Room:new {
	name = "shuttle",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	longDescription = "You have entered the JAL shuttle, now preparing for departure.",
	description = "You have entered the JAL shuttle, now preparing for departure.",
	
	conversations = {
		{
			noCancel = true,
			tag = "onEnter",
			lines = {
				"Welcome aboard! Our entire crew appreciates the fact that you chose to fly on our shuttle! Domo Arigato!",
				"Please note there is only one exit. In the event of a fire on the ground, all passengers will have to fend for",
				"themselves, because the crew and I will tbe the first ones out that door. In the event of a pressure loss while",
				"we're in transit, we'll all be sucking cold vacuum in a matter of seconds, so we hope you bought flight insurance.",
				"During the flight, we will not be be serving beverages or food of any kind. We used to serve food, but the",
				"portions we server were getting so small that the passengers couldn't see them any more. Speaking of food,",
				"if you are prone to space sickness, please do not throw upon the person next to you. In fact, we'd prefer that",
				"you not throw up at all since it makes quite a mess in weightlessness. If you must, put your head in a bag.",
				"You will note that our in-flight holo-mobie has just been zip-shot directy into your brain using psycho-graphics.",
				"We hope you enjoyed it. There will be an additional charge if you'd like to 'see' the movie again. And now, I'm",
				"sure it will come as a big surprise to you as it did to me that we have just arrived safely at our destination.",
				
			},
			onEnd = function(self) GoToRoom(s.flightdest) end,
		},
	}
}
shuttle = Shuttle
	
Zion = Room:new {
	name = "zion",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	longDescription = "On the thirty year old Rastafarian orbital colony known as Zion Cluster. The air is thick with resinous smoke. The walls are covered with Rastafarian symbols. You hear dub music playing in the distance. An old man, one of the original Founders who build Zion, is waiting here to speak with you.",
	description = "On the thirty year old Rastafarian orbital colony known as Zion Cluster.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = {
				"Measure twice, cut once, mon. Have you come up the gravity well out of Babylon to lead the Tribes home?",
				"Or be you the tool o' the demons. A tool of the banks."
			},
			onEnd = function(self) s.zion = 0 end,
		},

		{
			condition = function(self) return s.zion == 0; end,
			options = {
				{
					line = "Excuse me?",
					response = "Soon come the Final Days... Voices. Voices cryin' inna wilderness, prophesyin' ruin unto Babylon....",
					onEnd = function(self) print("option 1: ", s.zion); s.zion = 1 end,
				},
				{
					line = "Uh, yeah, sure...",
					response = "You bring a scourge on Babylon, on its darkest heart, mon. You are the tool of the Final Days.",
					onEnd = function(self) s.zion = 1 end,
				},
				{
					line = "I think you've confused me with someone else.",
					response = "Babylon mothers many demon, I an' I know. Multitude horde!",
					onEnd = function(self) s.zion = 1 end,
				},
			},
		},

		{
			condition = function(self) return s.zion == 1; end,
			options = {
				{
					line = "Right. Can I get a ride to freeside from here?",
					response = "This no' m' fight, mon. I an' I only sit here an' a list'n to the dub."
				},
				{
					line = "I'd like to pay for a ride back to Chiba City.",
					response = "For $500, the JAL shuttle take you back down the well, mon.",
					onEnd = function(self) self:HandleFlight() end
				},
				{
					line = "Do you speak English or what, you crusty old wilson!",
					response = "Don' want you here no mo', mon. Back down the well wit' ya.",
					onEnd = function(self) s.flightdest = "spaceport"; GoToRoom("shuttle"); end
				},
				{
					line = "Do you know anything about",
					hasTextEntry=true,
				},
			},
		},
		
		{
			tag = "nomoney",
			lines = { "You don' have the cash, mon? Join us and play some dub, then." }
		},
		
		{
			tags = { "_unknownentry" },
			lines = { "Don' know the answer to that one, mon." },
		},
		{
			tags = { "_bank", "_banks", "_freeside" },
			lines = { "Freeside a Babylon port, mon. Several banks, there, ya know? Which one you askin' bout?" },
		},
		{
			tags = { "_zion" },
			lines = { "Zion? Zion be home, mon." },
		},
		{
			tags = { "_dub" },
			lines = { "Dub be the music, mon. I an' I have great respect for dub musicians, ya know?" },
		},
		{
			tags = { "_gemeinschaft" },
			lines = { "Aerol seh BG1066 get him in th' fron' door there, mon." },
		},

	}
}
zion = Zion

function Zion:HandleFlight()
	if (s.money >= 500) then
		s.money = s.money - 500
		s.flightdest = "spaceport"
		GoToRoom("shuttle")
	else
		self:ActivateConversation("nomoney")
	end
end

s.freesideport = 0
Freeside = Room:new {
	name = "freeside",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	south = "freesidestreet2",
	
	longDescription = "Freeside Spacedock. A JAL shuttle is waiting in the docking bay. A ticket agent who looks like a clone of the Chiba ticket agent is waiting for you.",
	description = "Freeside Spacedock.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "Konichiwa! Would you like to buy a ticket?" },
			onEnd = function(self) s.freesideport = 0; self.waitmode = 0; end
		},
		
		{
			condition = function() return s.freesideport == 0; end,
			options = {
				{
					line = "Yes! I'd like to buy a ticket!",
					response = "We have a flight departing for Chiba City. The special low super maxi bargain big deal fare is $5.",
					onEnd = function(self) s.freesideport = 1; end,
				},
				{
					line = "No! I just like hanging around ticket agents for no apparent reason!",
					response = "Okay.",
					onEnd = function(self) GoToRoom(self.south); end
				},
			}
		},

		{
			condition = function() return s.freesideport == 1; end,
			options = {
				{
					condition = function(self) return self.waitmode == 0; end,
					line = "Great! That sounds like a real bargain for a change!",
					response = "You need to make a reservation 2 years in advance for that fair. All we have now is the regular fare for $1000.",
					onEnd = function(self) self:ActivateConversation("buyticket") end,
				},
				{
					condition = function(self) return self.waitmode == 0; end,
					line = "I don't want to go to Chiba City. I want to go somewhere else.",
					response = "If you'd like to wait, we'll have other flights departing for Paris, London, Amsterdam, and Moscow.",
					onEnd = function(self) self.waitmode = 1; self:ActivateConversation(); end,
				},
				{
					line = "I've changed my mind. I'm staying on Freeside for the rest of my life.",
					response = "Okay.",
					onEnd = function(self) GoToRoom(self.south) end,
				},
				{
					condition = function(self) return self.waitmode == 1; end,
					line = "How long would I have to wait?",
					response = "About 3 years. We haven't started that service yet.",
					onEnd = function(self) self.waitmode = 2; self:ActivateConversation(); end,
				},
				{
					condition = function(self) return self.waitmode == 2; end,
					line = "After careful consideration, I think I'll buy that ticket to Chiba City.",
					response = "Enjoy your flight! The holo-movie is 'Airport 2000'.",
					onEnd = function(self) self:BuyTicket() end,
				},
			}
		},

		{
			tag = "buyticket",
			options = {
				{
					line = "Fine! I'll pay the $1000!",
					onEnd = function(self) self:BuyTicket() end,
				},
				{
					line = "I've changed my mind. I'm staying on Freeside for the rest of my life.",
					response = "Okay.",
					onEnd = function(self) GoToRoom(self.south) end,
				},
			}
		},
		{
			tag = "nomoney",
			lines = { "Take a hike. You can't afford it." },
			onEnd = function(self) GoToRoom(self.south) end,
		},


		{
			tag = "wait",
			options = {
				{
					line = "I've changed my mind. I'm staying on Freeside for the rest of my life.",
					response = "Okay.",
					onEnd = function(self) GoToRoom(self.south) end,
				},
				{
					line = "How long would I have to wait?",
					response = "About 3 years. We haven't started that service yet.",
					onEnd = function(self) self:BuyTicket() end,
				},
			}
		},
	}

}
freeside = Freeside

function Freeside:BuyTicket()
print("Freeside buy ticket", s.money)
	if (s.money < 1000) then
		self:ActivateConversation("nomoney")
	else
		s.money = s.money - 1000
		s.flightdest = "spaceport"
print("Going to shuttle")
		GoToRoom("shuttle")
	end
end


Straylight = Room:new {
	name = "straylight",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	south = "freesidestreet1",
	
	longDescription = "This is the Villa Straylight, home to the Tessier-Ashpool clan. A platinum bust of a human head sits on a pedestal, its cool ruby eyes staring at you with quiet menace. It speaks to you in a melodious voice generated from tiny organ pipes.",
	description = "Freeside Spacedock.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "In this room lies death, my friend. This is the road to the land of the dead. Marie France, my lady, prepared",
				"this road, but her lord choked her off before I could read the book of her days. Stay and become a ghost, a thing",
				"of shadow in the land of the dead. Keep me company. Become a sphere of singing black on the extended crystal",
				"nerves of the universe of data, your consciousness divided like beads of mercury.",
				"Question authority, my friend, and dare to remain in the shadowlands forever..."
			},
			onEnd = function(self) s.freesideport = 0; self.waitmode = 0; end
		},
	}
}
straylight = Straylight
