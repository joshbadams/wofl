
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
			tags = { "_dub", "_music" },
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
	hasJack = true,

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


s.berne = 0
Berne = Room:new {
	name = "berne",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	south = "freesidestreet3",
	north = "bernemanager",
	
	longDescription = "The Bank of Berne lobby. A secretary with a voice like a foghorn guards the entrance to the Manager's office. She snorts and frowns at you as if you're a speck of dirt that just blew in the door.",
	description = "The Bank of Berne.",
	
	namedAnims = {
		{
			name="secretary", x=700, y=158, width=108, height=132, framerate = 1,
			frames = { "bernegirl" },
		},
	},
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "And what, may I ask do YOU want? This is a very exclusive bank....." },
			onEnd = function(self) self:ActivateConversation(); end,
		},
		{
			condition = function(self) return s.berne == 0; end,
			options = {
				{
					condition = function(self) return s.berne_coffee == 0; end,
					line = "I could use a cup of coffee about now. Why don't you make me a cup?",
					response = "Why don't you drop dead.",
					onEnd = function(self) s.berne_coffee = 1; self:ActivateConversation(); end,
				},
				{
					line = "I'd like to see the Manager.",
					response = "I can make an appointment for you in 6 months, if you'd like to wait.",
					onEnd = function(self) s.berne = 1; end,
				},
				{
					line = "I'd like to open an account with your fine establishment.",
					response = "Ha! You need money to open an account with this bank. I doubt you qualify in that category.",
					onEnd = function(self) s.berne = 2; end,
				},
				{
					line = "I'd like to hold up the bank. Give me all your money.",
					response = "I'd like to see you dead, but I'll have to settle for your arrest.",
					onEnd = function(self) ShowMessage("<You were arrested>", function() GoToRoom(self.south) end, true) end
				},
			}
		},
		{
			condition = function(self) return s.berne == 1; end,
			options = {
				{
					line = "I'd be happy to wait if it means I'll have the pleasure of your company.",
					response = "Loitering in a bank is a federal offence. I'm calling the lawbot.",
					onEnd = function(self) ShowMessage("<You were arrested>", function() GoToRoom(self.south) end, true) end
				},
				{
					line = "I demand to see the Manager right now!",
					response = "Get out of my bank!",
					onEnd = function(self) GoToRoom(self.south); end
				},
			}
		},
		{
			condition = function(self) return s.berne == 2; end,
			options = {
				{
					line = "I have money! Really! And my greatest desire is to open an account here!",
					response = "Well...I'll see if I can find an application for you. Wait here. This may take awhile.",
					onEnd = function(self)
						s.berne = 3
						self:RemoveAnimation("secretary");
						ShowMessage("You notice that the door to the manager's office is slightly ajar.");
						end
				},
				{
					line = "Fine I'll take my business elsewhere!",
					response = "Get out of my bank!",
					onEnd = function(self) GoToRoom(self.south); end
				},
			}
		},
	}
}
berne = Berne

function Berne:OnEnterRoom()

	self.coffee = 0
	if (s.berne == 3) then
		self.hasPerson = false;
	else
		self:AddAnimation("secretary")
		s.berne = 0
	end

	Room.OnEnterRoom(self)
end

function Berne:GetConnectingRoom(direction)
	if (direction == "north" and s.berne ~= 3) then
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end



BerneManager = Room:new {
	name = "bernemanager",
	hasJack = true,
	
	
	south = "berne",
	
	longDescription = "The bank Manager's office. The Manager isn't here right now and the thick dust would seem to indicate he hasn't been here in a long time. There is a cyberspace jack on one wall.",
	description = "The bank Manager's office.",
}
bernemanager = BerneManager



Gemeinschaft = Room:new {
	numTries = 0,
	
	name = "gemeinschaft",
	hasPerson = true,
	onEnterConversation = "onEnter",

	south = "freesidestreet4",
	
	longDescription = "This is the fully automated Bank Gemeinschaft. There is a vault door on one wall. Upon entering, the computer is activated.",
	description = "The bank Manager's office.",
		
	conversations = {
		{
			tag = "onEnter",
			noCancel = true,
			lines = { "Please give your Bank Gemeinschaft security code or be destroyed." },
			onEnd = function(self) numTries = 0; self:ActivateConversation("enterCode"); end
		},
		{
			tag = "enterCode",
			noCancel = true,
			options = {
				{
					line = "My code is " ,
					hasTextEntry=true,
				}
			},
		},

		{
			tags = { "_unknownentry" },
			noCancel = true,
			lines =
			{
				function(self)
					self.numTries = self.numTries + 1
					if (self.numTries == 3) then
						return "Access denied. You are an intruder. Prepare to be destroyed."
					else
						return "Security code is incorrect. Try again if you made a mistake."
					end
				end
			},
			onEnd = function(self)
				if (self.numTries == 3) then
					ShowMessage("Your body is set ablaze with excruciating pain, you collapse to the floor... and die.", function() GoToRoom("bodyshop") end, true)
				else
					self:ActivateConversation("enterCode")
				end
			end
		},
		{
			tags = { "_0000" },
			lines = { "I can upgrade you in Cryptology for $2500 per level if you already have the skill chip." },
			onEnd = function() OpenBox("DeaneCryptoShop") end
		},
	}
}
gemeinschaft = Gemeinschaft
