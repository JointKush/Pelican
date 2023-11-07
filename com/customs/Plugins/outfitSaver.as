class com.customs.Plugins.outfitSaver {

	static var SHELL, INTERFACE, AIRTOWER, ENGINE, penguin_layers;
	public function outfitSaver() {
		trace("Outfit Saver Plugin Loaded");
		SHELL = com.customs.Pelican._shell;
		INTERFACE = com.customs.Pelican._interface;
		AIRTOWER = com.customs.Pelican._airtower;
		ENGINE = com.customs.Pelican._engine;
		
		penguin_layers = ["hand", "head", "face", "neck", "body", "feet", "color"];

		this.setOverride();
	}
	public function setOverride(): Void {
		INTERFACE.checkOutfitItems = checkOutfitItems;
		INTERFACE.loadOutfitSaver = loadOutfitSaver;
		INTERFACE.setOutfitToPenguin = setOutfitToPenguin;
		INTERFACE.outfitContinueName = outfitContinueName;
		INTERFACE.clearOutfitDollMC = clearOutfitDollMC;
		INTERFACE.closePlayerWidgetTab = closePlayerWidgetTab;
		INTERFACE.openPlayerOutfitWidgetTab = openPlayerOutfitWidgetTab;
		INTERFACE.openPlayerWidgetTab = openPlayerWidgetTab;
		INTERFACE.is_player_outfit_tab_open = false;
		INTERFACE.MAX_OUTFIT_SLOTS = 6;
		INTERFACE.PLAYER_WIDGET.loadMovie(SHELL.getClientPath() + "playercard.swf");
		SHELL.getCurrSetOutfitHue = getCurrSetOutfitHue;
		SHELL.getOutfitDataByIsset = getOutfitDataByIsset;
		SHELL.getOutfitHuesBySlotID = getOutfitHuesBySlotID;
		SHELL.sendSaveOutfit = sendSaveOutfit;
		SHELL.sendDeleteOutfit = sendDeleteOutfit;
		SHELL.handleSetCurrentOutfit = handleSetCurrentOutfit;
		SHELL.sendSetCurrentOutfit = sendSetCurrentOutfit;
		SHELL.handleSaveOutfit  = handleSaveOutfit;
		SHELL.handleDeleteCurrOutfit = handleDeleteCurrOutfit;
		SHELL.handleSendRemoveClothing = handleSendRemoveClothing;
		SHELL.GLOBAL_CRUMBS.global_path.outfit_editor =  SHELL.getGlobalContentPath() + "content/edit_outfit.swf";
		SHELL.LOCAL_CRUMBS.lang.outfit_editor = "Outfit Editor";
		ENGINE.updateHue = updateHue;
		AIRTOWER.addListener("saveoutfit", SHELL.handleSaveOutfit);
		AIRTOWER.addListener("delcurrfit", SHELL.handleDeleteCurrOutfit);
		AIRTOWER.addListener("setcurroutfit", SHELL.handleSetCurrentOutfit);
	    AIRTOWER.addListener("rmc", SHELL.handleSendRemoveClothing);
	}
	public function setOutfitToPenguin(itemID) {
		
		if (itemID.color) {
			SHELL.sendUpdatePlayerColour(itemID.color);
		}
		if (itemID.head) {
			SHELL.sendUpdatePlayerHead(itemID.head);
		}
		if (itemID.face) {
			SHELL.sendUpdatePlayerFace(itemID.face);
		}
		if (itemID.neck) {
			SHELL.sendUpdatePlayerNeck(itemID.neck);
		}
		if (itemID.body) {
			SHELL.sendUpdatePlayerBody(itemID.body);
		}
		if (itemID.hand) {
			SHELL.sendUpdatePlayerHand(itemID.hand);
		}
		if (itemID.feet) {
			SHELL.sendUpdatePlayerFeet(itemID.feet);
		}
	}
	public function outfitContinueName () {
		INTERFACE.showPrompt("smallinput", "Please set a name for this current outfit.", "", SHELL.sendSaveOutfit);
	}
	public function checkOutfitItems (slot) {
		for (var f in penguin_layers) {
			var _loc1 = slot[penguin_layers[f]];
			if (_loc1 !== 0 && _loc1 !== undefined && _loc1 !== "" && _loc1 !== null) {
				return (true);
			}
		}
		return (false);
	}
	public function clearOutfitDollMC (slot) {
		for (var _loc3 in slot.paper_doll_mc) {
			if (typeof(slot.paper_doll_mc[_loc3]) == "movieclip") {
				var _loc2 = slot.paper_doll_mc[_loc3];
				_loc2.removeMovieClip();
			}
		}
		var _loc3 = Number(SHELL.getPlayerHexFromId(1));
		SHELL.setColourFromHex(slot.paper_doll_mc.body, Number(_loc3));
		delete slot.slot_btn.onRollOver;
	}

	public function loadOutfitSaver() {
		var _loc1 = INTERFACE.PLAYER_WIDGET.art_mc;
		var player_ob = INTERFACE.getPlayerObject(INTERFACE.getActivePlayerId());
		var itemJsonData = player_ob.outfits;
		for (var i = 1; i <= INTERFACE.MAX_OUTFIT_SLOTS; ++i) {
			var slotMC = _loc1.outfits_mc["slot" + i + "_mc"];
			var slotData = itemJsonData["slot" + i];
			var current_outfit_hue = SHELL.getOutfitHuesBySlotID("slot" + i);

			if (INTERFACE.checkOutfitItems(slotData)) {
				slotMC.slot_btn.slot = slotData;
				slotMC.slot_btn.slot_id = i;
				slotMC.slot_btn.onRollOver = function() {
					this.slot.name ? (INTERFACE.showHint(this, this.slot.name, true)) : ("");
				};
				slotMC.slot_btn.onRollOut = INTERFACE.closeHint;
				slotMC.slot_btn.onRelease = function() {
					SHELL.sendClearPaperdoll();
					SHELL.sendSetCurrentOutfit(this.slot, this.slot_id);
				};
				slotMC.delete_btn.slot_id = i;
				slotMC.delete_btn.slotMC = slotMC
				slotMC.delete_btn.onRelease = function() {
					INTERFACE.showPrompt("question", "You're about to delete this outfit! Are you sure?", "", SHELL.sendDeleteOutfit);
					INTERFACE.currSlotId = this.slot_id;
					INTERFACE.currSlot = this.slotMC;
				};
				slotMC.edit_btn.slot = slotData;
				slotMC.edit_btn.slot_id = i;
				slotMC.edit_btn.onRelease = function() {
					INTERFACE.currSlot = this.slot;
					INTERFACE.currSlotId = this.slot_id;
					INTERFACE.showContent("outfit_editor");
				};
				slotMC.delete_btn._visible = true;
				slotMC.edit_btn._visible = true;
				for (var f in penguin_layers) {
					var layerDepths = SHELL.PAPERDOLL_DEFAULT_LAYER_DEPTHS[penguin_layers[f]];
					var depthDoll = slotMC.paper_doll_mc.createEmptyMovieClip(penguin_layers[f] + "_mc", layerDepths);
					depthDoll.createEmptyMovieClip("itemClip", depthDoll.getNextHighestDepth());
					var loadDollItems = new com.clubpenguin.hybrid.HybridMovieClipLoader();
					if (slotData[penguin_layers[f]] !== 0 && penguin_layers[f] !== "color") {
						loadDollItems.loadClip(SHELL.getPath("clothing_paper") + slotData[penguin_layers[f]] + ".swf", depthDoll);
						if(current_outfit_hue[penguin_layers[f]] !== undefined) {
							ENGINE.updateHue(depthDoll, current_outfit_hue[penguin_layers[f]]);
						}
					}
				}
				var _loc3 = Number(SHELL.getPlayerHexFromId(slotData.color));
				SHELL.setColourFromHex(slotMC.paper_doll_mc.body, Number(_loc3));
			} else {
				slotMC.slot_btn.slot_id = i;
				slotMC.slot_btn.onRelease = function() {
					INTERFACE.showPrompt("question", "You're about to save this outfit in this Slot. Are you sure?", "", INTERFACE.outfitContinueName);
					INTERFACE.currSlotId = this.slot_id;
				};
				slotMC.delete_btn._visible = false;
				slotMC.edit_btn._visible = false;
			}
		};
	}
	public function openPlayerWidgetTab() {
		var _loc1 = INTERFACE.PLAYER_WIDGET.art_mc;
		INTERFACE.is_player_widget_tab_open = true;
		_loc1.gotoAndStop(4);
		_loc1.tab_btn.onRelease = INTERFACE.closePlayerWidgetTab;
		_loc1.tab_mc.onRelease = undefined;
		_loc1.tab_mc.useHandCursor = false;
		INTERFACE.showPlayerWidgetMenu();
		_loc1.sort_mc.sort_btn.onRelease = function() {
			INTERFACE.openPlayerWidgetSortMenu();
		};
	}
	public function openPlayerOutfitWidgetTab() {
		var _loc1 = INTERFACE.PLAYER_WIDGET.art_mc;
		INTERFACE.is_player_outfit_tab_open = true;
		_loc1.gotoAndStop(5);
		INTERFACE.loadOutfitSaver();
		_loc1.outfit_tab_btn.onRelease = INTERFACE.closePlayerWidgetTab;
		_loc1.tab_mc.onRelease = undefined;
		_loc1.tab_mc.useHandCursor = false;
	}
	
	public function closePlayerWidgetTab() {
		var _loc1 = INTERFACE.PLAYER_WIDGET.art_mc;
		INTERFACE.is_player_widget_tab_open = false;
		INTERFACE.is_player_outfit_tab_open = false;
		_loc1.gotoAndStop(3);
		_loc1.tab_btn.onRelease = INTERFACE.openPlayerWidgetTab;
		_loc1.outfit_tab_btn.onRelease = INTERFACE.openPlayerOutfitWidgetTab;
	} 

	public function getCurrSetOutfitHue(player_id) {
		var player_ob = INTERFACE.getPlayerObject(player_id ? (player_id) : (INTERFACE.getActivePlayerId()));
		var outfit = player_ob.outfits;
		var outfitHue = player_ob.outfit_hues;
		for (var i in outfit) {
			if(outfit[i].isset === true) {
				return (outfitHue[i]);
			}
		}
	}
	public function getOutfitHuesBySlotID(slot_id, player_id) {
		var player_ob = INTERFACE.getPlayerObject(player_id ? (player_id) : (INTERFACE.getActivePlayerId()));
		var outfitHue = player_ob.outfit_hues;
		for (var i in outfitHue) {
			if(i === slot_id) {
				return (outfitHue[i]);
			}
		}
	}
	public function getOutfitDataByIsset(player_id) {
		var player_ob = INTERFACE.getPlayerObject(player_id ? (player_id) : (INTERFACE.getActivePlayerId()));
		var outfit = player_ob.outfits;
		for (var prop in outfit) {
			if(outfit[prop].isset === true) {
				trace(com.clubpenguin.util.JSONParser.stringify(outfit[prop]));
				return(outfit[prop]);
			}
		}
	}
	public function updateHue(mc, number) {
		//trace("mc > " + mc + " value > " + number);
		if (!isNaN(number) && number !== 0) {
			var _loc3_ = new flash.filters.ColorMatrixFilter();
			var _loc1_ = new com.gskinner.geom.ColorMatrix();
			if (number == -181) {
				_loc1_.adjustSaturation(number);
			} else {
				_loc1_.adjustHue(number);
			}
			_loc3_.matrix = _loc1_;
			mc.filters = [_loc3_];
		} else {
			mc.filters = [];
		}
	}
	public function sendSaveOutfit(outfitName) {
		var _loc1 = SHELL.getPlayerObjectById(SHELL.getMyPlayerId());
		outfitName = outfitName.split("\n").join("");
		outfitName = outfitName.split("\r").join("");
	
		if (outfitName.length <= 3) {
			return (SHELL.showErrorPrompt("max", "Your Outfit name needs be longer than 3 characters", "Okay", undefined, ""));
		} else if (outfitName.length >= 15) {
			return (SHELL.showErrorPrompt("max", "Your Outfit name needs be shorter than 15 characters", "Okay", undefined, ""));
		}
		AIRTOWER.send(AIRTOWER.PLAY_EXT, "outfit#save", [outfitName, int(INTERFACE.currSlotId), _loc1.colour_id, _loc1.head, _loc1.face, _loc1.neck, _loc1.body, _loc1.hand, _loc1.feet], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId());
	}
	public function sendSetCurrentOutfit(items, slot_id) {
		var player_id = SHELL.getMyPlayerId();
		var player_ob = INTERFACE.getPlayerObject(player_id);
		if (player_ob.outfits === undefined && player_id === INTERFACE.getActivePlayerId()) {
			return (false);
		}	
		var outfitData = player_ob.outfits;
		for (var prop in outfitData) { 
		  outfitData[prop].isset = false;
		}
		outfitData["slot" + slot_id].isset = true;
		
		var stringifyOutData = com.clubpenguin.util.JSONParser.stringify(outfitData);
		INTERFACE.setOutfitToPenguin(items);
		
		return (AIRTOWER.send(AIRTOWER.PLAY_EXT, "outfit#setcurr", [stringifyOutData], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId()));
	}
	public function sendUpdateOutfitHue(type, value) {
	
		return (AIRTOWER.send(AIRTOWER.PLAY_EXT, "outfit#updhue", [int(INTERFACE.currSlotId), type, value], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId()));
	}
	public function sendDeleteOutfit () {
		var player_id = SHELL.getMyPlayerId();
		var player_ob = INTERFACE.getPlayerObject(player_id);
		if (player_ob.outfits === undefined && player_id === INTERFACE.getActivePlayerId()) {
			return (false);
		}	
		return (AIRTOWER.send(AIRTOWER.PLAY_EXT, "outfit#delete", [int(INTERFACE.currSlotId)], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId()));
	}
	public function handleSaveOutfit(obj) {
		obj.shift()
		var _loc1 = obj.shift();
		var player_id = SHELL.getMyPlayerId();
		var player_ob = INTERFACE.getPlayerObject(player_id);
		if (_loc1 === undefined && player_ob.outfits === undefined && player_id === INTERFACE.getActivePlayerId()) {
			return (false);
		}	
		player_ob.outfits = SHELL.parseJson(_loc1);
		INTERFACE.updatePlayerWidget();
	}
	public function handleDeleteCurrOutfit(obj) {
		obj.shift()
		var _loc1 = obj.shift();
		var player_id = SHELL.getMyPlayerId();
		var player_ob = INTERFACE.getPlayerObject(player_id);
		if (_loc1 === undefined && player_ob.outfits === undefined && player_id === INTERFACE.getActivePlayerId()) {
			return (false);
		}	
		player_ob.outfits = SHELL.parseJson(_loc1);
		INTERFACE.updatePlayerWidget();
		INTERFACE.clearOutfitDollMC(INTERFACE.currSlot);
	}
	public function handleSetCurrentOutfit(obj) {
		obj.shift();
		var outfit_data = obj.shift();
		var player_id = Number(obj.shift());
		var player_ob = SHELL.getPlayerObjectFromRoomById(player_id);
		player_ob.outfits = SHELL.parseJson(outfit_data);
	}
	public function handleSendRemoveClothing(obj) {
		var _loc5 = obj.shift();
		var _loc2 = Number(obj[0]);
		if (!isNaN(_loc2)) {
			var _loc1 = SHELL.getPlayerObjectFromRoomById(_loc2);
			if (_loc1 != undefined) {
				_loc1.feet = 0;
				_loc1.head = 0;
				_loc1.neck = 0;
				_loc1.face = 0;
				_loc1.hand = 0;
				_loc1.body = 0;
				_loc1.frame_hack = SHELL.buildFrameHacksString(_loc1);
				SHELL.updateListeners(SHELL.UPDATE_PLAYER, _loc1);
				if (SHELL.isMyPlayer(_loc2)) {
					SHELL.com.clubpenguin.login.LocalData.saveRoomPlayerObject(_loc1);
				}
			}
		}
	}
}



