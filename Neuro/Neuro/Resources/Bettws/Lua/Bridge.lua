
Bridge = Room:new {
	name = "bridge",
--	onEnterConversation = "onEnter",
--	hasPerson = true,
	
	north = "bridgenorth",
	
	longDescription = "You are under a bridge, overlooking a peaceful, yet powerful, river pouring down from the mountains. You arrived in Bettws-y-Coed, Wales this morning, and have already seen most there is to see.",
	description = "Under a bridge.",
}
bridge = Bridge

BridgeNorth = Room:new {
	name = "bridgenorth",
--	onEnterConversation = "onEnter",
--	hasPerson = true,
	
	south = "bridge",
	
	longDescription = "North of the bridge, you see some more river.",
	description = "North of the bridge.",
}
bridgenorth = BridgeNorth
