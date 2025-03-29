/**
TODO: Rewrite the search system and inventory system, it's pretty messy.
**/

class com.customs.Plugins.inventoryHints {
	
	static var INTERFACE, SHELL, ENGINE;
	public function inventoryHints () {
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		ENGINE = com.customs.Pelican._engine;
		this.setOverride();
		
	}
	
	public function setOverride() : Void {
		INTERFACE.showHint = showHint;
		INTERFACE.showPlayerWidgetMenu = showPlayerWidgetMenu;
		INTERFACE.setupInventorySearch = setupInventorySearch;
		INTERFACE.activeSearchQuery = undefined;
	}
	
	public function showHint(mc, hint, isLocalized) {
		var _loc1 = {
			x: mc._x,
			y: mc._y
		};
		mc._parent.localToGlobal(_loc1);
		INTERFACE.HINT._x = _loc1.x;
		INTERFACE.HINT._y = _loc1.y - 28;
		INTERFACE.HINT.gotoAndStop(1);
		INTERFACE.HINT._visible = true;
		if (isLocalized) {
			INTERFACE.HINT.message_txt.text = hint;
		} else {
			INTERFACE.HINT.message_txt.text = INTERFACE.getLocalizedString(hint);
		}
		var message_width = INTERFACE.HINT.message_txt.textWidth;
		INTERFACE.HINT.message_txt._visible = false;
		INTERFACE.HINT.box_mc._visible = false;
		var frame = 1;
		INTERFACE.HINT.onEnterFrame = function() {
			if (frame == 4) {
				INTERFACE.HINT.box_mc._visible = true;
				INTERFACE.HINT.box_mc._width = 66;
				INTERFACE.HINT.box_mc._height = 16;
			} else if (frame == 5) {
				INTERFACE.HINT.box_mc._width = 81;
				INTERFACE.HINT.box_mc._height = 20;
			} else if (frame == 6) {
				INTERFACE.HINT.box_mc._width = 96;
				INTERFACE.HINT.box_mc._height = 24;
			} else if (frame > 6) {
				if (message_width > 72) {
					INTERFACE.HINT.box_mc._width = message_width + 16;
				} else {
					INTERFACE.HINT.box_mc._width = 88;
				}
				INTERFACE.HINT.box_mc._height = 22;
				INTERFACE.HINT.message_txt._visible = true;
				delete INTERFACE.HINT.onEnterFrame;
			}
			++frame;
		};
	}
	public function setupInventorySearch() {
		var _loc10 = INTERFACE.PLAYER_WIDGET.art_mc;
		_loc10.search_mc.gotoAndStop(2);
		_loc10.search_mc.block_mc.useHandCursor = false;
		_loc10.search_mc.block_mc.tabEnabled = false;
		_loc10.search_mc.block_mc.onRelease = null;
		var listener = new Object();
		listener.onChanged = function(search_txt) {
			var searchTxt = search_txt.text;
			if (searchTxt.length > 0) {
				 _loc10.search_mc.clear_btn._visible = true;
			} else {
				 _loc10.search_mc.clear_btn._visible = false;
			}
			INTERFACE.activeSearchQuery = searchTxt;
			INTERFACE.showPlayerWidgetMenu(searchTxt);
		}
		_loc10.search_mc.search_txt.addListener(listener);
		_loc10.search_mc.search_txt.text = INTERFACE.activeSearchQuery ? (INTERFACE.activeSearchQuery) : ("Search Inventory");
		_loc10.search_mc.clear_btn.onRelease = function () {
			_loc10.search_mc.search_txt.text = "";
			INTERFACE.activeSearchQuery = "";
			INTERFACE.showPlayerWidgetMenu();
			this._visible = false;
		};
		_loc10.search_mc.close_btn.onRelease = function () {
			_loc10.search_mc.gotoAndStop(1);
		};
	}
	public function showPlayerWidgetMenu(query) {
		var _loc10 = INTERFACE.PLAYER_WIDGET.art_mc;
		var _loc4 = INTERFACE.getItemList();
		var _loc6 = [];
		var _loc13 = INTERFACE.PLAYER_WIDGET_MENU_MAX_ITEMS;
		var _loc12 = INTERFACE.player_widget_menu_type;
		var _loc18 = INTERFACE.player_widget_menu_text;
		_loc10.search_btn.onRelease = INTERFACE.setupInventorySearch;
		_loc10.search_btn.onRollOver = function () {
			INTERFACE.showHint(this, "Search Inventory", true);
		};
		_loc10.search_btn.onRollOut = INTERFACE.closeHint;
		if (_loc12 != undefined) {
			if (_loc12 == "INVENTORY_TYPE_ALL") {
				for (var _loc5 in _loc4) {
					if (INTERFACE.activeSearchQuery !== undefined) {
						if (_loc4[_loc5].name.toLowerCase().indexOf(INTERFACE.activeSearchQuery.toLowerCase()) == 0 || _loc4[_loc5].id.toString().indexOf(INTERFACE.activeSearchQuery) > -1) {
						_loc6.push(_loc4[_loc5]);
						}
					} else {
						_loc6 = _loc4;
					}
				}
			_loc6.reverse();
			} else if (_loc12 == "INVENTORY_TYPE_AWARD") {
				var _loc16 = SHELL.INVENTORY_TYPE_FLAG;
				var _loc15 = SHELL.INVENTORY_TYPE_OTHER;
				var _loc14 = SHELL.INVENTORY_TYPE_PHOTO;
	
				for (var _loc5 in _loc4) {
					var _loc8 = _loc4[_loc5].type;
					if (_loc8 == _loc16 || _loc8 == _loc15 || _loc8 == _loc14) {
						INTERFACE.traceOject(_loc4[_loc5]);
						_loc6.push(_loc4[_loc5]);
					}
				}
			} else {
				for (var _loc5 in _loc4) {
					if (INTERFACE.activeSearchQuery !== undefined) {
						if (_loc4[_loc5].name.toLowerCase().indexOf(INTERFACE.activeSearchQuery.toLowerCase()) == 0 || _loc4[_loc5].id.toString().indexOf(INTERFACE.activeSearchQuery) > -1) {
							if (_loc4[_loc5].type == SHELL[_loc12]) {
								_loc6.push(_loc4[_loc5]);
							}
						}
					} else {
						if (_loc4[_loc5].type == SHELL[_loc12]) {
							_loc6.push(_loc4[_loc5]);
						}
					}
				}
			}
		} else {
			_loc6 = _loc4;
		}
		_loc10.sort_mc.sort_txt.text = _loc18 + " (" + _loc6.length + ")";
		_loc6 = _loc6.slice();
		for (var _loc7 = 0; _loc7 < _loc6.length; ++_loc7) {
			if (_loc6[_loc7].hidden == true) {
				_loc6.splice(_loc7, 1);
			}
		}
		_loc6.sortOn(["type", "id"], Array.NUMERIC);
		var _loc17 = Math.ceil(_loc6.length / _loc13) - 1;
		var _loc11 = INTERFACE.paginateArray(_loc6, INTERFACE.player_widget_menu_page, _loc13);
		if (INTERFACE.player_widget_menu_page < _loc17) {
			_loc10.next_btn.onRelease = com.clubpenguin.util.Delegate.create(this, INTERFACE.onNextButtonReleased);
		} else {
			_loc10.next_btn.onRelease = undefined;
		}
		if (INTERFACE.player_widget_menu_page > 0) {
			_loc10.back_btn.onRelease = com.clubpenguin.util.Delegate.create(this, INTERFACE.onBackButtonReleased);
		} else {
			_loc10.back_btn.onRelease = undefined;
		}
		if (_loc10.menu_mc_holder.menu_mc) {
			_loc10.menu_mc_holder.menu_mc.removeMovieClip();
		}
		_loc10.menu_mc_holder.attachMovie(INTERFACE.INVENTORY_LIST_LINKAGE_ID, "menu_mc", 1, {
			_x: 0,
			_y: 0
		});
		for (var _loc5 = 0; _loc5 < _loc13; ++_loc5) {
			var _loc3 = _loc11[_loc5];
			var _loc2 = _loc10.menu_mc_holder.menu_mc["item" + _loc5 + "_mc"];
			if (_loc3 != undefined && !_loc3.hidden) {
				var _loc9 = !_loc3.is_member || _loc3.is_member && INTERFACE.isMember();
				if (_loc9) {
					_loc2.gotoAndStop(1);
					_loc2.button_btn.item_id = _loc3.id;
					_loc2.button_btn.onRelease = function() {
						INTERFACE.clickPlayerWidgetItem(this.item_id);
					};
					_loc2.button_btn.item_name = _loc3.name;
					_loc2.button_btn.onRollOver = function() {
						INTERFACE.showHint(this, this.item_name, true);
					};
					_loc2.button_btn.onRollOut = INTERFACE.closeHint;
					if(_loc3.id == 413 || SHELL.checkIfItemIsCustom(_loc3.id)) {
						_loc2.rmBtn._visible = false;
					}
					_loc2.rmBtn.item_id = _loc3.id;
					_loc2.rmBtn.onRelease = function () {
						 INTERFACE.showPrompt("shop", "Do you want you delete this current item " + INTERFACE.getInventoryObjectById(this.item_id).name + "?", INTERFACE.getFilePath("clothing_icons") + this.item_id + ".swf", function () {
							SHELL.sendRemoveItem(this.item_id);
						});
					};
				} else {
					_loc2.gotoAndStop(2);
					_loc2.button_btn.onRelease = INTERFACE.showMemberItemNotAvailablePrompt;
				}
				_loc2.loader_mc.gotoAndStop(1);
				_loc2.icon_mc._visible = false;
				INTERFACE.loadPlayerWidgetMenuIcon(_loc2.icon_mc, _loc3.id, _loc3.type);
				continue;
			}
			_loc2.loader_mc.gotoAndStop(3);
			_loc2.gotoAndStop(3);
			_loc2.button_btn.onRelease = undefined;
		}
	}
	
}
