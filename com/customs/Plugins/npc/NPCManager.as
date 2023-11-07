class com.customs.Plugins.npc.NPCManager {

	var npc_obj = {};
	static var SHELL, INTERFACE, AIRTOWER, ENGINE;
	
	public function NPCManager () {
		super();
		trace("Loaded NPC V1.4b");
		SHELL = com.customs.Pelican._shell;
		INTERFACE = com.customs.Pelican._interface;
		AIRTOWER = com.customs.Pelican._airtower;
		ENGINE = com.customs.Pelican._engine;
		this.overrideFunc();

	}
	public function overrideFunc() : Void {
		SHELL.handleAddPlayerToRoom = handleAddPlayerToRoom;
		SHELL.sendNPCToRoom = sendNPCToRoom;
		SHELL.setNPCData = setNPCData;
		SHELL.handleStartNPC = handleStartNPC;
		SHELL.npcObjStr = {};
		AIRTOWER.addListener("snpc", SHELL.handleStartNPC);
	}

	public function handleAddPlayerToRoom(obj) {
		var _loc3 = SHELL.getRoomObject();
		var _loc4 = obj.shift();
		var _loc1 = SHELL.makePlayerObjectFromString(obj[0]);
		trace("Player ID: " + _loc1.player_id);
		var _loc2 = _loc1.player_id;
		if (_loc1.nickname == undefined || _loc1.player_id == undefined) {
			return (false);
		}
		if (SHELL.playerIndexInRoom(_loc2) == -1) {
			SHELL.getPlayerList().push(_loc1);
			SHELL.removePlayerFromCacheById(_loc2);
			_loc1.thrownSnowballInCurrentRoom = false;
			_loc1.emoteIDDisplayedInCurrentRoom = -1;
			SHELL.updateListeners(SHELL.ADD_PLAYER, _loc1);
			if (SHELL.isPlayerBuddyById(_loc2)) {
				SHELL.setBuddyAsOnlineById(_loc2);
			} 
		} 
		SHELL.getPlayerOutfit(_loc1.player_id);
	}
	public function handleStartNPC(obj) {
		obj.shift();
		var room_id = obj.shift()
		var _loc4 = SHELL.npcObjStr;
		for (var key in _loc4) {
			if (_loc4.hasOwnProperty(key)) {
				var item = _loc4[key];
				var roomId = key.split('_')[0];
				if (roomId === room_id) {
					var joinArr = [item.uniqueId, item.username, item.bitmask];
					for (var objKey in item.itemsObj) {
						joinArr.push(item.itemsObj[objKey]);
					}
					var npcStr = joinArr.join('|');
					if(item.isEnabled) {
						SHELL.sendNPCToRoom(roomId, npcStr);
					}
				}
			}
		}
	}
	

	public function setNPCData(npcData) {
		SHELL.npcObjStr = npcData;
	}
	
	public function sendNPCToRoom(roomId, npcStr) {
		var roomObj = SHELL.getRoomObject();
	    var npcStrData = npcStr.split("|");
		if(roomId >= 1000 && roomObj.room_id !== roomId) {
			return (false);
		}
		trace("NPC String " + npcStr);
		trace("[sendNPCToRoom -> NPC Joining " + roomId + "]");
		SHELL.handleAddPlayerToRoom([SHELL.getCurrentServerRoomId(), npcStr]);
	}
}			
