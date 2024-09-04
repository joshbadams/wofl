SavedValues = {}



foo=1
bar='test'

function GotMoney()
	return action == 'give' and type == 'money'
end




Room = { }

function Room:new (obj)
  obk = obk or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end


function Room:GetNextConversation(tag)
	print("HECK YES")
	if tag ~= nil then
		for i,c in ipairs(self.conversations) do
			if c.tag ~= nil and c.tag:lower() == tag:lower() then
				print("Returning ", c, c.tag)
				return c
			end
		end
	end

	for i,c in ipairs(self.conversations) do
		if c.condition ~= nil and c:condition() then
			print("22 Returning ", c, c.tag)
			return c
		end
	end

--print(tag)
--print(self.conversations[1].onStart)
--return self.conversations[1]
	print("33 Returning nil")
	return nil
end



Chatsubo = Room:new {
	foobar = "hi",
	conversations = {
		{
			tag = "longdescription",
			message = "You've just spent the night sleeping face-down in a pile of synth-spaghetti in a bar called Chatsubo. After rubbint the sauce out of your eyes, you can see Chiba sky through the window, the color of television tuned to a dead channel.\nA PAX booth is on the wall. Ratz's prosthetic Russin arm whines as he wipes the bar. His teeth are a webwork of East Eurpoean steel and brown decay.",
			onEnd = function(self)
				print("ONE END")
				print(self.foobar)
				s_chatsubo = 0
				Trigger('talk', '')
			end
		},
		
		{
			tag = "description",
			message = "In the Chatsubo bar"
		},
		
		{
			condition = function()
				return s_chatsubo == 0
			end,
			lines = {
				"I don't care if you eat that spaghetti or sleep in it, you still gotta pay for it. 46 credits."
			},
			onEnd = function()
				s_chatsubo = 1
				Trigger('talk', '')
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
		}
	}
}

-- both cases
chatsubo = Chatsubo

function Test()
	print(chatsubo, Chatsubo, Room)
	return chatsubo
end

