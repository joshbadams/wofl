SystemPhase = {
	Menu = {},
	Save = {},
	Load = {},
	Pausing = {},
	Quit = {},
}

SystemBox = Gridbox:new {
	x = 150,
	y = 480,
	w = 400,
	h = 280,

}

function SystemBox:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)

	self.Phase = SystemPhase.Menu
end

function SystemBox:GetEntries()

	local entries = {}

	if (self.Phase == SystemPhase.Menu) then
		table.append(entries, {x = self:CenteredX("Disk Options"), y = 0, text = "Disk Options" } )
	
		local curY = 1
		table.append(entries, {x = 1, y = curY, text = "L. Load", key = "l", onClick = function() self.Phase = SystemPhase.Load; end } )
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "S. Save", key = "s", onClick = function() self.Phase = SystemPhase.Save; end })
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "P. Pause", key = "p", onClick = function() self.Phase = SystemPhase.Pausing; end })
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "Q. Quit", key = "q", onClick = function() self.Phase = SystemPhase.Quit; end })
	elseif (self.Phase == SystemPhase.Load) then
		table.append(entries, {x = 3, y = 2, text = "1", key = "1", onClick = function() LoadGame(1); self:Close() end })
		table.append(entries, {x = 5, y = 2, text = "2", key = "2", onClick = function() LoadGame(2); self:Close() end })
		table.append(entries, {x = 7, y = 2, text = "3", key = "3", onClick = function() LoadGame(3); self:Close() end })
		table.append(entries, {x = 9, y = 2, text = "4", key = "4", onClick = function() LoadGame(4); self:Close() end })
	elseif (self.Phase == SystemPhase.Save) then
		table.append(entries, {x = 3, y = 2, text = "1", key = "1", onClick = function() SaveGame(1); self:Close() end })
		table.append(entries, {x = 5, y = 2, text = "2", key = "2", onClick = function() SaveGame(2); self:Close() end })
		table.append(entries, {x = 7, y = 2, text = "3", key = "3", onClick = function() SaveGame(3); self:Close() end })
		table.append(entries, {x = 9, y = 2, text = "4", key = "4", onClick = function() SaveGame(4); self:Close() end })
	end
	
	self:AddExitMoreEntries(entries, needsMore)

	return entries
end

function SystemBox:HandleClickedExit()
	if (self.Phase == SystemPhase.Menu) then
		self:Close()
	else
		self.Phase = SystemPhase.Menu
	end
end
