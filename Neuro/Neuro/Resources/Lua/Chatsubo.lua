s_chatsubo = 0

Chatsubo = Room:new {
	name = "chatsubo",
	background = "chatsubo",
	hasPerson = true,
	hasPax = true,
	hasJack = true,
	
	longDescription = "You've just spent the night sleeping face-down in a pile of synth-spaghetti in a bar called Chatsubo. After rubbint the sauce out of your eyes, you can see Chiba sky through the window, the color of television tuned to a dead channel.\nA PAX booth is on the wall. Ratz's prosthetic Russin arm whines as he wipes the bar. His teeth are a webwork of East Eurpoean steel and brown decay.",
	
	description = "In the Chatsubo bar",
	
	conversations = {
		{
			condition = function()
				return s_chatsubo == 0
			end,
			lines = {
				"I don't care if you eat that spaghetti or sleep in it, you still gotta pay for it. 46 credits."
			},
			onEnd = function()
				s_chatsubo = 1
				Talk()
			end
		},
		
		{
			condition = function()
				return s_chatsubo == 1
			end,
			options =
			{
				{
					line = "Sorry, Ratz. I can't afford it. Want me to give it back?",
					response = "Pay up, cyberscum. Use the PAX if you need money."
				},
				{
					line = "How about if I owe it to you? You can trust me.",
					response = "Pay up, cyberscum. Use the PAX if you need money."
				},
				{
					line = "I'm ready for dessert. Have you got any pudding for me to sleep in?",
					response = "Pay up, cyberscum. Use the PAX if you need money."
				},
				{
					line = "I'd like to sleep on it some more, if that's okay with you, Ratz.",
					response = "You been sleepin' in that stuff all night. Now pay up or I call a lawbot."
				}
			}
		},

		{
			condition = function() return s_chatsubo == 2 end,
			options =
			{
				{
					line = "What deck does Shin have?",
					response = "Your Yamamitsu UXB, Herr %name%. Shin says you pawned it at his shop."
				},
				{
					line = "Anything else come up?",
					response = "One of Lonny Zone's girls was looking for you too. You got biz with Zone?", 
					onEnd = function() s_chatsubo = 3 end
				},
				{
					line = "Who you calling an artiste?",
					response = "You are the artiste of the slighly funny deal, Herr %name%."
				}
			}
		},

		
		{
			condition = function() return s_chatsubo == 3 end,
			options =
			{
				{ 
					line = "Zone's a close friend of mine. Did I hear something about the Health Department closing this place?",
					response = "A minor problem, friend artiste. I'll be back in business within the week."
				},
				{
					line = "Anything else you want to tell me?",
					response = "Better find a way to pay your bill at Cheap Hotel, or they'll start asking you to sell yout body parts.",
					onEnd = function() s_chatsubo = 4 end
				}
			}
		},
		{
			condition = function() return s_chatsubo==4 end,
			options =
			{
				{
					line = "So I sell a kidney or two. Why don't you get off my case, Ratz?",
					response = "You should have fear, artiste. It may be your friend. Now get out of here before the lawbot arrives.",
					onEnd = function() s_chatsubo=5 end
				},
				{
					line = "That's it. I'm leaving.",
					response = "Good luck, artiste. You're going to need it.",
					onEnd = function() s_chatsubo=5 end,
				}
			}
		}
	}
}

function Chatsubo:OnFirstEnter()
	s_chatsubo = 0
	print("FIRST ENTER!")
	ShowMessage(self.longDescription, function() Talk() end)
end

-- comment

function Chatsubo:GiveMoney(amount)
	if amount >= 46 then
		-- actually give the money away
		Room:GiveMoney(amount)

		Say("Thanks, friend artiste. Shin came by, but he didn't want to interrupt your beauty sleep. He still has your deck.")
		s_chatsubo = 2
	else
		ShowMessage("Ratz refuses to take your credits.", function() Say("I said 46 credits, buckwheat. Are you deaf?") end)
	end
end
