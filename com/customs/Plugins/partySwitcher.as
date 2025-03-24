class com.customs.Plugins.partySwitcher {
	
	static var INTERFACE, SHELL, AIRTOWER, ENGINE;
	public function partySwitcher () {
		trace("Loaded Party Switcher Plugin");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		AIRTOWER = com.customs.Pelican._airtower;
		ENGINE = com.customs.Pelican._engine;
		
		this.setOverride();
	}
	
	public function setOverride() : Void {
		SHELL.party_obj = {};
		var roomCrumbs = SHELL.getRoomCrumbs();
		SHELL.oldRoomCrumbs = com.clubpenguin.util.JSONParser.parse(com.clubpenguin.util.JSONParser.stringify(roomCrumbs)); 
		SHELL.setPartyData = setPartyData;
		SHELL.getPartyObjByKey = getPartyObjByKey;
		flash.external.ExternalInterface.addCallback("updateParty", null, updateParty);

	}
	public function setPartyData(obj) {
		SHELL.party_obj = obj;
	}
	public function getPartyObjByKey(party_key) {
		var _loc1 = SHELL.party_obj;
		if (_loc1[party_key] !== undefined) {
			return (_loc1[party_key]);
		}
	}
	public function updateParty(party_key) {
		var party:Object = SHELL.party_obj[party_key];
		if (!party && party_key !== "default" || !party.party_active && party_key !== "default") {
			return SHELL.showErrorPrompt("max", !party ? "Unable to switch as this party does not exist" : "This party isn't currently active, try a different one", "Okay", undefined, "");
		}
		
		var roomCrumbs:Object = SHELL.getRoomCrumbs();
		var isDefault:Boolean = (party_key == "default");
		
		for (var room_name: String in roomCrumbs) {
			roomCrumbs[room_name].path = SHELL.getGlobalContentPath() + (isDefault ? "rooms/" : "rooms/parties/" + party_key + "/") + room_name + ".swf";
			
			roomCrumbs[room_name].music_id = party.party_rooms.hasOwnProperty(room_name) ?
			  party.party_rooms[room_name] : (isDefault ? SHELL.oldRoomCrumbs[room_name].music_id : 0);
			
			if (isDefault) {
			  flash.external.ExternalInterface.call("console.log", "Old Room Music IDs updated " + roomCrumbs[room_name].music_id);
			}
		}
    	ENGINE.handleRefreshRoom();
	}
}
