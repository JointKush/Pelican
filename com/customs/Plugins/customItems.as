class com.customs.Plugins.customItems {

	static var _stage, INTERFACE, SHELL, ENGINE, penguin_layers;
	public function customItems() {
		trace("Custom Items Plugin Loaded");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		ENGINE = com.customs.Pelican._engine;
		_stage = com.customs.Pelican.stageReference;
		this.setOverride();
		
		penguin_layers = ["hand", "head", "face", "neck", "body", "feet"];
	}
	
	public function setOverride(): Void {
		SHELL.custom_item_obj = {};
		SHELL.GLOBAL_CRUMBS.global_path.clothing_custom_photos =  SHELL.getGlobalContentPath() + "clothing/custom/photos/";
		SHELL.GLOBAL_CRUMBS.global_path.clothing_custom_paper =  SHELL.getGlobalContentPath() + "clothing/custom/paper/";
		SHELL.GLOBAL_CRUMBS.global_path.clothing_custom_icons =  SHELL.getGlobalContentPath() + "clothing/custom/icons/";
		SHELL.GLOBAL_CRUMBS.global_path.clothing_custom_sprites =  SHELL.getGlobalContentPath() + "clothing/custom/sprites/";
		SHELL.setCustomItemsData = setCustomItemsData;
		SHELL.mergeCustomObj = mergeCustomObj;
		SHELL.getCustomItemObjById = getCustomItemObjById;
		SHELL.checkIfItemIsCustom = checkIfItemIsCustom;
		INTERFACE.buyInventory = buyInventory;
		INTERFACE.loadPlayerWidgetMenuIcon = loadPlayerWidgetMenuIcon;
		INTERFACE.onPlayerWidgetMenuIconLoadInit = onPlayerWidgetMenuIconLoadInit;
		ENGINE.loadPlayerItem = loadPlayerItem;
		ENGINE.updatePlayerItem = updatePlayerItem;
		ENGINE.onPlayerItemLoadInit = onPlayerItemLoadInit;
	}
	public function setCustomItemsData(obj) {
		for (var _loc2 in obj) { 
			obj[_loc2].id = obj[_loc2].id;
			obj[_loc2].type = obj[_loc2].type;
			obj[_loc2].cost = obj[_loc2].cost;
			obj[_loc2].is_member = obj[_loc2].is_member;
			obj[_loc2].name = obj[_loc2].name;
		} 
		SHELL.mergeCustomObj(SHELL.inventory_crumbs, obj);
		SHELL.custom_item_obj = obj;
	}
	public function getCustomItemObjById(id) {
		var _loc1 = SHELL.custom_item_obj;
		if (_loc1[id] !== undefined) {
			return (_loc1[id]);
		}
	}
	public function checkIfItemIsCustom(id){
		var _loc1 = SHELL.custom_item_obj;
		if (_loc1[id] !== undefined) {
			return (true);
		}
		return (false);
	}
	public function buyInventory(itemID) {
		if (INTERFACE.isMember() || !INTERFACE.isInventoryMemberOnly(itemID)) {
			if (INTERFACE.isItemInInventory(itemID)) {
				INTERFACE.showPrompt("warn", INTERFACE.getLocalizedString("item_in_inventory_warn"));
				return;
			}
			var _loc1 = INTERFACE.getInventoryObjectById(itemID);
			var customItemData = SHELL.getCustomItemObjById(itemID);
			if(customItemData !== undefined) {
				var _loc7 = INTERFACE.getFilePath("clothing_custom_icons")  + itemID + ".swf";
			} else {
				var _loc7 = INTERFACE.getFilePath("clothing_icons") + itemID + ".swf";
			}
			var _loc5 = INTERFACE.getCoins();
			var _loc2;
			if (_loc5 >= _loc1.cost) {
				INTERFACE.setActiveShopItem(itemID);
				if (_loc1.is_medal) {
					_loc2 = INTERFACE.replaceString("%name%", _loc1.name, INTERFACE.getLocalizedString("inventory_medal"));
				} else if (_loc1.is_gift) {
					_loc2 = INTERFACE.replaceString("%name%", _loc1.name, INTERFACE.getLocalizedString("inventory_gift"));
				} else if (_loc1.cost == 0) {
					_loc2 = INTERFACE.replaceString("%name%", _loc1.name, INTERFACE.getLocalizedString("inventory_free"));
				} else {
					var _loc4 = INTERFACE.replaceString("%name%", _loc1.name, INTERFACE.getLocalizedString("buy_inventory"));
					_loc4 = INTERFACE.replaceString("%cost%", String(_loc1.cost), _loc4);
					var _loc6 = INTERFACE.replaceString("%num%", String(_loc5), INTERFACE.getLocalizedString("num_coins"));
					_loc2 = _loc4 + " " + _loc6;
				} 
				INTERFACE.showPrompt("shop", _loc2, _loc7, INTERFACE.sendBuyInventory);
			} else {
				_loc2 = INTERFACE.getLocalizedString("low_coin_warn");
				INTERFACE.showPrompt("warn", _loc2);
			}
		} else {
			INTERFACE.showWindow("oops_inventory", null, "oops_clothing_catalog");
		}
	} 
	public function loadPlayerWidgetMenuIcon(mc, id, type) {
		var _loc2 = new com.clubpenguin.hybrid.HybridMovieClipLoader();
		var customItemData = SHELL.getCustomItemObjById(id);
		if(customItemData !== undefined) {
			var _loc4 = INTERFACE.getFilePath("clothing_custom_icons") + id + ".swf";
		} else {
			var _loc4 = INTERFACE.getFilePath("clothing_icons") + "" + id + ".swf";
		}		var current_outfit_hue = SHELL.getCurrSetOutfitHue();
		var outfitData = SHELL.getOutfitDataByIsset();
		if(outfitData[penguin_layers[type]] === id && outfitData[penguin_layers[type]] !== undefined) {
			_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, INTERFACE.onPlayerWidgetMenuIconLoadInit, current_outfit_hue[penguin_layers[type]]));
		} else {
			_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, INTERFACE.onPlayerWidgetMenuIconLoadInit));
		}
		_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_ERROR, com.clubpenguin.util.Delegate.create(this, INTERFACE.onPlayerWidgetMenuIconLoadError));
		var _loc3 = com.clubpenguin.util.URLUtils.getCacheResetURL(_loc4);
		_loc2.loadClip(_loc3, mc);
	} 
	public function onPlayerWidgetMenuIconLoadInit(event, hue) {
		var _loc1 = event.target;
		if (_loc1) {
			_loc1._parent.loader_mc.gotoAndStop(3);
			_loc1._visible = true;
		} 
		if(hue) {
			ENGINE.updateHue(_loc1, hue);
		}
	} 
	public function loadPlayerItem(mc, item_id, type, player_id) {
		if (item_id > 0) {		
			var customItemData = SHELL.getCustomItemObjById(item_id);
			if(customItemData !== undefined) {
				var _loc3 = SHELL.getPath("clothing_custom_sprites") + item_id + ".swf";
			} else {
				var _loc3 = SHELL.getPath("clothing_sprites") + item_id + ".swf";
			}
			mc._visible = false;
			var _loc2 = new com.clubpenguin.hybrid.HybridMovieClipLoader();
			_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_COMPLETE, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerItemLoadComplete));
			var current_outfit_hue = SHELL.getCurrSetOutfitHue(player_id);
				
				var stringifyOutData = com.clubpenguin.util.JSONParser.stringify(INTERFACE.getPlayerObject(player_id).outfits);

			var outfitData = SHELL.getOutfitDataByIsset(player_id);
			if(outfitData[type] === item_id) {
				_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerItemLoadInit, current_outfit_hue[type]));
			} else {
				_loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerItemLoadInit));
			}
			_loc2.loadClip(_loc3, mc);
		}
	} 
	public function onPlayerItemLoadInit(event, hue) {
		if(hue) {
			ENGINE.updateHue(event.target, hue);
		}
		ENGINE.updatePlayerFrame(event.target._parent.player_id);
		event.target._visible = true;

	}
	public function updatePlayerItem(mc, ob, name, depth) {
		if (ob[name] != mc[name]) {
			removeMovieClip(mc[name + "_mc"]);
			mc.createEmptyMovieClip(name + "_mc", depth);
			ENGINE.loadPlayerItem(mc[name + "_mc"], ob[name], name, ob.player_id);
			mc[name] = ob[name];
		}
	}
	public function mergeCustomObj(obj, src){
		for (var key in src) {
			if(src.hasOwnProperty(key)) obj[key] = src[key];
		}
		return obj;
	}

}
	