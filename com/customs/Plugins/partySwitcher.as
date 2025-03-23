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
			
		var party = SHELL.party_obj[party_key];
        if (party == undefined) {
            return (SHELL.showErrorPrompt("max", "Unable to switch as this party does not exist", "Okay", undefined, ""));
        }        
		var roomCrumbs = SHELL.getRoomCrumbs();

		for (var room_name:String in roomCrumbs) {
			roomCrumbs[room_name].path = SHELL.getGlobalContentPath() + "rooms/parties/" + party_key + "/" + room_name + ".swf";
			
			if (party.party_rooms.hasOwnProperty(room_name)) {

				roomCrumbs[room_name].music_id = party.party_rooms[room_name];
			} else {
				roomCrumbs[room_name].music_id = 0; 
			}
		}
		ENGINE.handleRefreshRoom();
	}
}