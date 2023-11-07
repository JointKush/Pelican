class com.customs.Settings {
	/**
		Plugins - You can load plugins from sub-folders by flagging it with "wildCard" and setting the folder name between "."
	**/
	public function Settings () {
		trace("Settings Loaded");
	}
	static var localPath = "http://localhost/";
	static var plugins = [
		 {name: "customPrompts", isDisabled: false}, 
		 {name: "outfitSaver", isDisabled: false}, 
		 {name: "customBadges", isDisabled: false}, 
		 {name: "npc.NPCManager", isDisabled: false, wildCard: true},
		 {name: "customEmotes", isDisabled: false},
		 {name: "inventoryHints", isDisabled: false},
		 {name: "penguinGlows", isDisabled: false},
		 {name: "customItems", isDisabled: false},
		 {name: "RoomPin", isDisabled: false},
		 {name: "ScavengerHunt", isDisabled: false}
	];
	static var customServices = {EMOTE: "emote_frames", NPC: "npc", CUSTOM_ITEMS: "custom_items", ROOM_PIN: "room_pin"};
}