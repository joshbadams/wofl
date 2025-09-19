s.chessMembership = 0
s.chessOpponentLevel = 1
WorldChess = Site:new {
	title = "* World Chess Confederation *",
	
	passwords = {
		"novice",
		"member",
		"<cyberspace>"
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = "You've entered the wonderful world of chess. Please feel free to look around. If we interest you, please join us. For access, enter \"NOVICE\"."
		},
		['password'] = {
			type = "password",
		},
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "About this system", target = "aboutsystem" },
				{ key = '2', text = "About the Tournaments", target = "abouttournaments" },
				{ key = '3', text = "Membership Application", target = "application" },
				{ key = '4', text = "Enter Tournament", target = "tournament", level = 2 },
				{ key = '5', text = "Challenge Morphy", target = "morphy", level = 2 },
			}
		},
		['aboutsystem'] = {
			type = "message",
			message = "The World Chess Confederation computer network has been around since the beginning of computer networks. In fact. the WCC has always supported computerized competitions and sponsored the first CyberSpace competition ever. Though that match between Palos Morphy and Victor Lavaska ended in tragedy, the WCC has held many thousands of successful matches since then. All persons interested in joining the daily tournaments are encouragee to become WCC members.\n\nThe WCC network allowd members a chance to play against the best and, if you think yourself worthy, you can even pit your skills against those of the legendary simulation of Palos Morphy himself.",
			exit = "main"
		},
		['abouttournaments'] = {
			type = "message",
			message = "Daily Tournaments\nThe WCC sponsors daily chess tournaments in which any member can participate. Players are allowed to use optimizer programs matched to their level of play. The classes of competition are listed below:\n1. unranked beginner\n2. unranked Novice\n3. Ranked Novice\n4. Apprentice\n5. Journeyman\n6. Junior Master\n7. Master\n8. Grandmaster\n9. Victor\n\nCash prized are awarded in each category on a daily basis.",
			exit = "main"
		},
		['application'] = {
			type = "generic",
			showHeader = true,
			entries = {
				{x = 0, y = 2, text = "If you'd like to become a member, select between the two membership options:", wrap = -1},
				{x = 5, y = 5, key = 'x', text = "X. Exit", clickId = 1},
				{x = 5, y = 6, key = 't', text = "T. Temporary Membership $10", clickId = 2},
				{x = 5, y = 7, key = 'f', text = "F. Full Membership     $150", clickId = 3},
				{x = 0, y = 9, text = "Temporary membership allows participation in one tournament.\n\nFull membership allows participation in all tournaments and activities as a club member.", wrap = -1},
			},
		},
		['tournament'] = {
			type = "custom",
		},
		['morphy'] = {
			type = "message",
			message = "\nIf you think you're read for me, look for me in cyberspace... I'll be waiting.",
			exit = "main"
		},
		['deducted'] = {
			type = "generic",
			showHeader = true,
			exit = "main",
			entries = {
				{x = 3, y = 4, text = "The fee has been deducted from your credit chip.\nYour new password is \"MEMBER\"", wrap = -1 },
			}
		},
		['funds'] = {
			type = "generic",
			showHeader = true,
			exit = "main",
			entries = {
				{x = 3, y = 4, text = "Insufficient funds in credit chip" },
			}
		},
	},
	
	rewards = {
		-- todo check these
		250, 350,
	},
	
	ranks = {
		"unranked beginner",
		"unranked Novice",
		"Ranked Novice",
		"Apprentice",
		-- todo more, and build welcome string out of them
	}

	-- Coord.--0-160/80  AI--Morphy weakness=Logic
}

function WorldChess:GetEntries()
	local entries = Site.GetEntries(self)

	if (self.currentPage == "tournament") then
		self:GetTournamentEntries(entries)
	end

	return entries
end

function WorldChess:BuyMembership(cost, level)

	if (s.money < cost) then
		self:GoToPage("funds")
	else
		s.money = s.money - cost
		if (s.chessMembership < level) then
			s.chessMembership = level
		end
		if (self.passwordLevel < 2) then
			self.passwordLevel = 2
		end
		self:GoToPage("deducted")
	end
end

function WorldChess:HandleClickedEntry(id)

	if (self.currentPage ~= "application") then
		return Site.HandleClickedEntry(self, id)
	end
	if (id == 1) then
		self:GoToPage("main")
	elseif (id == 2) then
		self:BuyMembership(10, 1)
	elseif (id == 3) then
		self:BuyMembership(150, 2)
	end
end

function WorldChess:OnGenericContinueInput()
	if (self.currentPage == "tournament") then
		if (self.tournamentPhase == 0 or self.tournamentPhase == 2 or self.tournamentPhase >= 4) then
			self:GoToPage("main")
		end
	else
		Site.OnGenericContinueInput(self)
	end
end

function WorldChess:GoToPage(pageName)
	Site.GoToPage(self, pageName)

	local page = self:GetCurrentPage()
	if (self.currentPage == "tournament") then
		if (s.chessMembership == 0) then
			self.tournamentPhase = 0
		else
			self.tournamentPhase = 1
			if (self.chessMembership == 1) then
				self.chessMembership = 0
			end
			OpenBox("InvBox_Site")
		end
	end
end

function WorldChess:GetTournamentEntries(entries)
	local message

	self:GetPageHeaderFooterEntries(self:GetCurrentPage(), entries)

	if (self.tournamentPhase == 0) then
		table.append(entries, {x=0, y=2, text="Temporary members are allowed only one game."})
	end

	if (self.tournamentPhase == 1 or self.tournamentPhase == 2) then
		message = "Please upload your software."
		table.append(entries, {x=self:CenteredX(message), y=2, text=message})
		if (self.tournamentPhase == 2) then
			message = "Incompatible software."
			table.append(entries, {x=self:CenteredX(message), y=4, text=message})
		end
	end

	if (self.tournamentPhase == 3 or self.tournamentPhase == 4 or self.tournamentPhase == 5) then
		local oppLevel = s.chessOpponentLevel
		if (self.tournamentPhase == 4) then
			oppLevel = oppLevel - 1
		end

		local message = "contestant " .. oppLevel .. " vs " .. s.name
		table.append(entries, {x=self:CenteredX(message), y=2, text=message})
		message = "playing game ..."
		table.append(entries, {x=self:CenteredX(message), y=4, text=message})
		if (self.tournamentPhase == 5) then
			message = "Sorry you lost."
			table.append(entries, {x=self:CenteredX(message), y=6, text=message})
		elseif (self.tournamentPhase == 4) then
			message = "You won, your ranking has been upgraded to " .. self.ranks[s.chessOpponentLevel] .. ". Prize money of " .. self.rewards[s.chessOpponentLevel - 1] .. " credits has been added to your credit chip."
			table.append(entries, {x=0, y=6, text=message, wrap = -1})
		end
	end
end

function WorldChess:CanUseSoftware(software)
	if (self.currentPage ~= "tournament") then
		return Site.CanUseSoftware(self, software)
	end

	return nil
end

function WorldChess:UseSoftware(software)
	if (self.currentPage ~= "tournament") then
		return Site.UseSoftware(self, software)
	end

	if (software ~= nil and software.name == "BattleChess") then
		self.tournamentPhase = 3
		self.battlechessLevel = software.version
		self.blockInput = true
		StartTimer(2, self, function(self) self:FinishTournament() end)
	else
		self.tournamentPhase = 2
	end

	UpdateBoxes()
end

function WorldChess:FinishTournament()
print("finishe", self, self.battlechessLevel, s.chessOpponentLevel)

	-- todo how does battlechess 4.0 work???
	if (self.battlechessLevel >= s.chessOpponentLevel) then
		self.tournamentPhase = 4
		s.money = s.money + self.rewards[s.chessOpponentLevel]
		s.chessOpponentLevel = s.chessOpponentLevel + 1
	else
		self.tournamentPhase = 5
	end

	self.blockInput = false
	
	UpdateBoxes()
end

worldchess=WorldChess
