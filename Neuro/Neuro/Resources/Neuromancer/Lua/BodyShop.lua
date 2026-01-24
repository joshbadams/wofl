s.bodyshop = 0


BodyShopBuy = ShopBox:new {
	isBasicItemShop = false,
	heading = "BUY PARTS",
	items = {
		300, 301, 302, 303,
		304, 305, 306, 307,
		308, 309, 310, 311,
		312, 313, 314, 315,
		316, 317, 318, 319,
	},
}

function BodyShopBuy:HandleClickedExit()
	if (not self.boughtSold) then
		currentRoom:ActivateConversation("onBoughtNothing")
	end

	ShopBox.HandleClickedExit(self)
end

function BodyShopBuy:OnBoughtSoldItem(itemIndex)
	local id = self.items[itemIndex]
	table.insert(s.organs, id)
	s.hp = s.hp + Items[id].hp
	UpdateInfo()
end

function BodyShopBuy:IsPurchaseAllowed(itemIndex)
	local id = self.items[itemIndex]
	return not table.containsArrayItem(s.organs, id)
end

BodyShopBuyDiscounted = BodyShopBuy:new {
	overridePrices = {
		[300] = 100,
		[301] = 100,
		[302] = 100,
		[303] = 100,
		[304] = 100,
		[305] = 100,
		[306] = 100,
		[307] = 100,
		[308] = 100,
		[309] = 100,
		[310] = 100,
		[311] = 100,
		[312] = 100,
		[313] = 100,
		[314] = 100,
		[315] = 100,
		[316] = 100,
		[317] = 100,
		[318] = 100,
		[319] = 100,
	},
}


BodyShopSell = ShopBox:new {
	isBuying = false,
	isBasicItemShop = false,
	heading = "SELL PARTS",
	items = {
		300, 301, 302, 303,
		304, 305, 306, 307,
		308, 309, 310, 311,
		312, 313, 314, 315,
		316, 317, 318, 319,
	},
}

function BodyShopSell:HandleClickedExit()
	if (self.boughtSold) then
		currentRoom:ActivateConversation("onSoldSomething")
	else
		currentRoom:ActivateConversation("onSoldNothing")
	end

	ShopBox.HandleClickedExit(self)
end

function BodyShopSell:IsPurchaseAllowed(itemIndex)
	local id = self.items[itemIndex]
print("trying to sell", itemIndex, id)
print("currently have?", table.containsArrayItem(s.organs, id))
	return table.containsArrayItem(s.organs, id)
end

function BodyShopSell:OnBoughtSoldItem(itemIndex)
	local id = self.items[itemIndex]
	table.removeArrayItem(s.organs, id)
	s.hp = s.hp - Items[id].hp
	UpdateInfo()
end



BodyShop = Room:new {
	name = "bodyshop",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	
	south = "streetwest2",

	longDescription = "You're in the Body Shop. Jars of human internal organs sit on a shelf, waiting to be refrigerated. A tall man waits behind the counter with a permanent smile where his lips have been removed. His nametag identifies him as \"Chin.\"",
	description = "You're in the Body Shop.",
	
	conversations = {
		{
			tag = "onEnterRoom",
			lines = {
				"Can I be of service? Would you like to sell a body part?"
			},
			onEnd = function(self) s.bodyshop = 1; s.usedBargaining = false; end
		},

		{
			tag = "bargaining",
			lines = { "I'll sell you your parts back at the discount price." },
			onEnd = function(self) s.usedBargaining = true end
		},

		{
			tag = "onBoughtNothing",
			lines = { "Come back when you can afford it, meatball." },
			onEnd = function() GoToRoom("streetwest2") end
		},

		{
			tag = "onSoldNothing",
			lines = { "Let me know if you change your mind! We're offering some great deals!" },
		},

		{
			tag = "onSoldSomething",
			lines = { "Enjoy your cheap plastic replacement." },
			onEnd = function() GoToRoom("streetwest2") end
		},

		{
			tag = "onBoughtSomething",
			lines = { "Thanks for stopping by! Come back real soon!" },
			onEnd = function() GoToRoom("streetwest2") end
		},

		{
			condition = function()
				return s.bodyshop == 1
			end,
			options =
			{
				{
					line = "Yes! I'd love to sell you a piece of my anatomy!",
					response = "Wonderful! We currently have a need for the following parts:",
					onEnd = function() OpenBox("BodyShopSell") end,
				},
				{
					line = "No thanks! Just browsing!",
					response = "Let me know if you change your mind! We're offering great deals!"
				},
				{
					line = "I feel a certain attachment to the body part I previously sold. I'd like to buy another.",
					response = "Let's see if it's still in stock. Aha! Must be your lucky day! Here it is!",
					onEnd = function() if (s.usedBargaining) then OpenBox("BodyShopBuyDiscounted" ) else
						OpenBox("BodyShopBuy") end
					end,
				},
				{
					line = "Oh! Look at the time! I have an urgent dentist appointment! Excuse me!",
					response = "Thanks for stopping by! Come back real soon!",
					onEnd = function() GoToRoom("streetwest2") end,
				}
			}
		},
	}
}
bodyshop = BodyShop

function BodyShop:UseSkill(skill)
print("using skill", skill, skill.name, s.hasTalkedInRoom)
	if (skill.name == "Bargaining" and not s.hasTalkedInRoom) then
		self:ActivateConversation("bargaining")
	else
		Room.UseSkill(self, skill)
	end
end
