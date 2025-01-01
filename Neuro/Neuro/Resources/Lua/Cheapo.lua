s.cheapo_charges = 1000
s.cheapo_account = 0

s.purchased_cheapo_caviar = 0
s.purchased_cheapo_sake = 0

s.item_waiting_cheapo_caviar = 0
s.item_waiting_cheapo_sake = 0


Cheapo = Site:new {
	title = "* The Cheapo Hotel *",
	comLinkLevel = 1,
	
	pages = {
		['title'] = {
			message = "Hey, it's better than sleeping in the streets!\nJust enter the password \"GUEST\" to enter our system."
		},
		
		['password'] = {
			type = "password",
		},
		
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Room Service", target = "roomservice" },
				{ key = '2', text = "Local Things to do", target = "thingstodo" },
				{ key = '3', text = "Review Bill", target = "bill_view"  },
				{ key = '4', text = "Edit Bill [level 2?]", target = "bill_edit", level = 2 }
			}
		},
		
		['roomservice'] = {
			type = "store",
			columns = { { field = 'item', width = 25 }, { field = 'in stock', width = 8 }, { field = 'cost', width = 0} },
			items = {
				{ item = "Karanakoy Caviar", ['in stock'] = 1, cost = 200, tag = "cheapo_caviar" },
				{ item = "Yomiuchi brand Sake", ['in stock'] = 3, cost = 15, tag = "cheapo_sake" }
			}
		},
		
		['thingstodo'] = {
			type = "list",
			exit = "main",
			columns = { { field = 'date', width = 8 }, { field = 'subject', width = 0 } },
			hasDetails = true,
			items = {
				{
					date = 111658,
					subject = "Donut World",
					message = "We at Donut World hope to be your breakfast, lunch or dinner place. As per usual 15% discount for all SEA agents. Open 24 hours."
				},
				{
					date = 111658,
					subject = "Manyusha Wana Massage",
					message = "Got then Jacked-in stiffies in your shoulders and back? Do you have a bad sector in your spine? Fret no more. Our Manyusha Wana Massage Parlor is waiting for you just around the corner. We've got services and prices to fit any budget. Our masseuses are prettier than an Ono-Sendai Cyberspace VII and they've got their own ideas about jacking in....\nIf you need to be unwound, come our way. You can't afford to miss what we can do for you.\nBetween Shin's Pawn Shop and Larry's."
				},
				{
					date = 111658,
					subject = "Psychologist",
					message = "PSYCHOLOGIST is an intensely personal analysis service for an elite clientele. It provides a socially-acceptable outlet for private frustrations, phobias, and general concerns. New users can sample on-going mindprobe sessions for insights into their own problems. After the initial contact new users will be assigned a personal password.\n You can reach us at \"PSYCHO\"."
				},
				{
					date = 111658,
					subject = "Crazy Edo's",
					message = "   Crazy Edo's\nWhy buy new when you can buy used for less? Face it, you know the things work. You don't have to rip open hundreds of boxes to sub-assemble this stuff. It's all here. We've got the almost latest in both warez and K-boxes. Check us out!\n\nBetween Metro Holografix and the Matrix Restaurant."
				},
			}
		},
		
		['bill_view'] = {
			type = "custom",
		},
		
		['bill_edit'] = {
			type = "custom",
		},
		
		['bill_modify'] = {
			type = "custom",
		},
	}
}
-- lowercase
cheapo = Cheapo


-- mark one ready for pickup next trip to hotel
function Cheapo:OnPurchasedStoreItem(item)
	local itemVar = string.format("item_waiting_%s", item.tag)
	_G[itemVar] = _G[itemVar] + 1
end



function Cheapo:GetEntries()
	local entries = Site.GetEntries(self)

	if string.sub(self.currentPage, 1, 5) == "bill_" then
		self:GetBillEntries(entries)
	end

	return entries
end

function Cheapo:GetBillEntries(entries)
	
	table.append(entries, { x = 5, y = 2, text = string.format("Room: 92   Name: %s", name) })
	table.append(entries, { x = 0, y = 3, text = "--------------------------------------------------------------------------" })
	table.append(entries, { x = 0, y = 4, text = string.appendPadded("   ", "Total charges:", 26) .. tostring(cheapo_charges) })
	table.append(entries, { x = 0, y = 6, text = string.appendPadded("   ", "Balance:", 26) .. (cheapo_charges - cheapo_account) })
	table.append(entries, { x = 0, y = 7, text = "--------------------------------------------------------------------------" })

	-- the account line, optionally editable
	if (self.currentPage == "bill_view") then
		table.append(entries, { x = 0, y = 5, text = string.appendPadded("   ", "On account1:", 26) .. cheapo_account })
	elseif (self.currentPage == "bill_edit") then
		table.append(entries, { x = 0, y = 5, text = string.appendPadded("O. ", "On account2:", 26) .. cheapo_account, clickId = 10, key = "o" })
	else
		table.append(entries, { x = 0, y = 5, text = string.appendPadded("   ", "On account3:", 26) })
		table.append(entries, { x = 29, y = 5, entryTag = "account", numeric = true })
	end

	-- exit / pay buttons
	exitmoreCenter = self:CenteredX("exit  pay bill")
	table.append(entries, {x = exitmoreCenter, y = 9, text = "exit", clickId = -1, key = "x" } )
	table.append(entries, {x = exitmoreCenter + 6, y = 9, text = "pay bill", clickId = 1, key = "p" } )

end


function Cheapo:HandleClickedEntry(id)

	if (string.sub(self.currentPage, 1, 5) == "bill_" and id > 0) then
		if (id > 0 and id ~= 1 and id ~= 10) then
			error("should only have id 1 (pay) or 10 (edit)")
		end

		if (id == 1) then
			local owed = s.cheapo_charges - s.cheapo_account
			if (owed > 0 and s.money >= owed) then
				s.money = s.money - owed
				s.cheapo_account = s.cheapo_charges
			end
		end

		if (id == 10) then
			self:GoToPage("bill_modify")
		end
	else
		Site.HandleClickedEntry(self, id)
	end
end


function Cheapo:OnTextEntryComplete(text, tag)
	if (tag ~= "account") then
		error("textentry tag should only be 'account'")
	end

	local amount = tonumber(text)

	cheapo_account = math.min(amount, cheapo_charges)

	self:GoToPage("bill_edit")
end

function Cheapo:OnTextEntryCancelled(tag)
	self:GoToPage("bill_edit")
end
