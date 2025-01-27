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
	hasPax = false,
	hasJack = false,
	
	south = "streetwest2",

	longDescription = "You're in the Body Shop. Jars of human internal organs sit on a shelf, waiting to be refrigerated. A tall man waits behind the counter with a permanent smile where his lips have been removed. His nametag identifies him as \"Chin.\"",
	description = "You're in the Body Shop.",
	
	conversations = {
		{
			tag = "onEnterRoom",
			lines = {
				"Can I be of service? Would you like to sell a body part?"
			},
			onEnd = function() s.bodyshop = 1 end
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
					onEnd = function() print("About to open sell"); OpenBox("BodyShopSell") end,
				},
				{
					line = "No thanks! Just browsing!",
					response = "Let me know if you change your mind! We're offering great deals!"
				},
				{
					line = "I feel a certain attachment to the body part I previously sold. I'd like to buy another.",
					response = "Let's see if it's still in stock. Aha! Must be your lucky day! Here it is!",
					onEnd = function() print("About to open sell"); OpenBox("BodyShopBuy") end,
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

