class com.customs.Plugins.customPrompts {
	
	static var INTERFACE, SHELL, _stage, SNOW_MENU, currSbColor;
	public function customPrompts () {
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		_stage = com.customs.Pelican.stageReference;
		this.setOverride();
		
		SNOW_MENU = _stage.snow_menu_mc;

	}
	
	public function setOverride(): Void {
		INTERFACE.showPrompt = showPrompt;
		INTERFACE.closePrompt = closePrompt;
		INTERFACE.handleFindPlayer = handleFindPlayer;
		INTERFACE.setCurrentFindPlayerRoom = setCurrentFindPlayerRoom;
		INTERFACE.gotoCurrentFindPlayerRoom = gotoCurrentFindPlayerRoom;
		INTERFACE.showDock = showDock;
		INTERFACE.showSnowMenu = showSnowMenu;
		INTERFACE.closeSnowMenu = closeSnowMenu;
		INTERFACE.processQuickKeyCode = processQuickKeyCode;
		INTERFACE.snowMenuOpened = false;
		SHELL.ITEM_OUT_OF_STOCK = 403;
		SHELL.e_func[SHELL.ITEM_OUT_OF_STOCK] = e_itemOutofStock;
		SHELL.LOCAL_CRUMBS.lang.throw_ball_hint = "Throw Snowball";
		SHELL.LOCAL_CRUMBS.lang.chat_restrict = "a-z A-Z z-A 0-9 !-} ?!.,;:`´-_/\\(){}=&$§\"=?@\'*+-ßäöüÄÖÜ#?<>\n\t";
		SHELL.LOCAL_CRUMBS.error_lang[SHELL.ITEM_OUT_OF_STOCK] = "Sorry, but this item is out of stock!";
	}
	public function showPrompt(style, message, file, positiveSelectionCallback, negativeSelectionCallback) {
		var _loc2 = com.clubpenguin.util.URLUtils.getCacheResetURL(file);
		var PROMPT = _stage.prompt_mc;
		INTERFACE.enableTabLock();
		INTERFACE.stopQuickKeys();
		if (style == "question") {
			PROMPT.gotoAndStop(2);
		} else if (style == "ok") {
			PROMPT.gotoAndStop(4);
		} else if (style == "ok_big") {
			PROMPT.gotoAndStop(11);
		} else if (style == "wait") {
			PROMPT.gotoAndStop(5);
		} else if (style == "game") {
			PROMPT.gotoAndStop(3);
		} else if (style == "igloo") {
			PROMPT.gotoAndStop(6);
			PROMPT.icon_mc.loadMovie(_loc2);
		} else if (style == "shop") {
			PROMPT.gotoAndStop(7);
			PROMPT.icon_mc.loadMovie(_loc2);
		} else if (style == "coin") {
			PROMPT.gotoAndStop(8);
		} else if (style == "input") {
			PROMPT.gotoAndStop(9);
			PROMPT.icon_mc.loadMovie(_loc2);
			PROMPT.text_input.restrict = INTERFACE.getLocalizedString("chat_restrict");
			Selection.setFocus(PROMPT.text_input);
		} else if (style == "smallinput") {
			PROMPT.gotoAndStop(11);
			PROMPT.text_input.restrict = INTERFACE.getLocalizedString("chat_restrict");
			Selection.setFocus(PROMPT.text_input);
		} else if (style == "warn") {
			PROMPT.gotoAndStop(10);
		} else if (style == "AS3_error") {
			PROMPT.gotoAndStop(11);
		} else {
			PROMPT.gotoAndStop(1);
		}
		PROMPT.block_mc.useHandCursor = false;
		PROMPT.block_mc.tabEnabled = false;
		PROMPT.block_mc.onRelease = null;
		PROMPT.message_txt.text = message;
		PROMPT.continue_txt.text = INTERFACE.getLocalizedString("Continue");
		PROMPT.yes_txt.text = INTERFACE.getLocalizedString("Yes");
		PROMPT.no_txt.text = INTERFACE.getLocalizedString("No");
		PROMPT.ok_txt.text = INTERFACE.getLocalizedString("Ok");
		PROMPT.yes_btn.onRelease = function() {
			INTERFACE.closePrompt();
			positiveSelectionCallback();
			INTERFACE.removeTabLock();
		};
		PROMPT.ok_btn.onRelease = function() {
			INTERFACE.closePrompt();
			positiveSelectionCallback();
			INTERFACE.removeTabLock();
		};
		PROMPT.continue_btn.onRelease = function() {
			var _loc1 = PROMPT.text_input.text;
			if (_loc1.length > 0) {
				INTERFACE.closePrompt();
				positiveSelectionCallback(_loc1);
			}
			INTERFACE.removeTabLock();
		};
		PROMPT.no_btn.onRelease = function() {
			INTERFACE.closePrompt();
			negativeSelectionCallback();
			INTERFACE.removeTabLock();
		};
		PROMPT.close_btn.onRelease = function() {
			INTERFACE.closePrompt();
			negativeSelectionCallback();
			INTERFACE.removeTabLock();
		};
	}
	public function closePrompt() {
		var PROMPT = _stage.prompt_mc;
		PROMPT.gotoAndStop(1);
		INTERFACE.startQuickKeys();
	}
	public function handleFindPlayer(ob) {
		INTERFACE.traceObject(ob);
		var _loc2 = ob.room_id;
		var _loc1;
		if (_loc2 > 999) {
			var _loc5 = 2000;
			var _loc4 = _loc2 - _loc5;
			var _loc7 = INTERFACE.getActivePlayerId();
			if (_loc4 == SHELL.getMyPlayerId()) {
				_loc1 = "igloo_yours";
			} else if (_loc4 == _loc7) {
				_loc1 = "igloo_theirs";
			} else {
				_loc1 = "igloo";
			}
		} else if (_loc2 > 899) {
			_loc1 = SHELL.getGameCrumbsKeyById(_loc2);
		} else {
			_loc1 = SHELL.getRoomNameById(_loc2);
		} 
		var _loc6 = INTERFACE.getActivePlayerNickname();
		var _loc3 = SHELL.getLocalizedString(_loc1 + "_find");
		INTERFACE.setCurrentFindPlayerRoom(_loc1);
		_loc3 = INTERFACE.replaceString("%name%", _loc6, _loc3);
		if(_loc2 > 999 && _loc2 > 899) {
			return INTERFACE.showPrompt("ok", _loc3);
		}
		INTERFACE.showPrompt("question", _loc3 +". Would you like to go to them?", "", INTERFACE.gotoCurrentFindPlayerRoom);
	} 
	
	public function setCurrentFindPlayerRoom(room_name) {
		INTERFACE.currentFindPlayerRoom = room_name;
	}
	public function gotoCurrentFindPlayerRoom() {
		return (SHELL.sendJoinRoom(INTERFACE.currentFindPlayerRoom));
	}
	
	public function showSnowMenu (isOpened) {
		SNOW_MENU.gotoAndStop(2)
		INTERFACE.snowMenuOpened = isOpened;
		var player_ob = INTERFACE.getPlayerObject(SHELL.getMyPlayerId());
		if(INTERFACE.snowMenuOpened) {
			SNOW_MENU.back_btn.onRelease = INTERFACE.closeSnowMenu;
			SNOW_MENU.back_btn.onRollOver = INTERFACE.closeSnowMenu;
			SNOW_MENU.scolor_btn.onRelease = function () { 
				SNOW_MENU.gotoAndStop(4);
				var selectedColor = new Color(SNOW_MENU.color_selector_mc.selected_mc);
				selectedColor.setRGB("0x" + player_ob.p_attributes.sbc);
				SNOW_MENU.hex_txt.text = "#" +  player_ob.p_attributes.sbc;
				SNOW_MENU.reset_btn.onRelease = function () {
					INTERFACE.showPrompt("ok", "Snowball has been Reverted back to the Default Color");
					SHELL.sendUpdateSnowballcolor(0);	
				}
				SNOW_MENU.color_selector_mc.onRelease = function() {
					this.gotoAndStop(2);
					var bmp = new flash.display.BitmapData(this.picker_container_mc.picker_mc._width, this.picker_container_mc.picker_mc._height, false);
					bmp.draw(this.picker_container_mc.picker_mc);
					this.picker_container_mc.picker_mc.onMouseMove = function() {
						var _loc2 = bmp.getPixel(this._xmouse, this._ymouse);
						for (var _loc1 = _loc2.toString(16).toUpperCase(); _loc1.length < 6; _loc1 = "0" + _loc1) {}
						SNOW_MENU.hex_txt.text = "#" + _loc1;
						selectedColor.setRGB("0x" + _loc1);
						currSbColor = _loc1;
						
					}
					this.onRelease = function () {
						SHELL.sendUpdateSnowballcolor(currSbColor);	
						this._parent.gotoAndStop(1);
					}
				}
			};
			SNOW_MENU.stype_btn.onRelease = function () {
				SNOW_MENU.gotoAndStop(3);
				
				SNOW_MENU.b1_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(1);
					SNOW_MENU.gotoAndStop(1);

				}
				SNOW_MENU.b2_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(2);	
					SNOW_MENU.gotoAndStop(1);

				}
				SNOW_MENU.b3_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(3);	
					SNOW_MENU.gotoAndStop(1);

				}
				SNOW_MENU.b4_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(4);	
					SNOW_MENU.gotoAndStop(1);

				}
				SNOW_MENU.b5_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(7);	
					SNOW_MENU.gotoAndStop(1);

				}
				SNOW_MENU.b6_mc.slot_btn.onRelease = function () {
					SHELL.sendUpdateSnowballType(9);	
					SNOW_MENU.gotoAndStop(1);

				}

			};
		}
		SNOW_MENU.close_btn.onRelease = INTERFACE.closeSnowMenu;
		SNOW_MENU.back_btn.useHandCursor = false;
		SNOW_MENU.safe_btn.useHandCursor = false;

	}
	public function closeSnowMenu() {
		SNOW_MENU.gotoAndStop(1);
	} 
	public function processQuickKeyCode(keyCode) {
		var _loc2 = INTERFACE.interface_mc.crosshair_mc.target_btn;
		var _loc4 = String(Selection.getFocus());
		var _loc3 = String(_loc2);
		if (Selection.getFocus() != null && _loc4 != _loc3) {
			return;
		}
		switch (keyCode) {
			case 69: {
				INTERFACE.myKeyListener.is_emote = true;
				break;
			}
			case 49: {
				INTERFACE.sendEmote(15);
				break;
			}
			case 191: {
				INTERFACE.sendEmote(14);
				break;
			}
			case 87: {
				INTERFACE.sendPlayerAction(25);
				break;
			}
			case 68: {
				INTERFACE.sendPlayerFrame(26);
				break;
			}
			case 74: {
				INTERFACE.sendJoke();
				break;
			}
			case 83: {
				INTERFACE.sendPlayerSitDown();
				break;
			}
			case 37: {
				INTERFACE.sendPlayerFrame(19);
				break;
			}
			case 39: {
				INTERFACE.sendPlayerFrame(23);
				break;
			}
			case 38: {
				INTERFACE.sendPlayerFrame(21);
				break;
			}
			case 40: {
				INTERFACE.sendPlayerFrame(17);
				break;
			}
			case 84: {
				INTERFACE.showCrosshair();
				break;
			}
			case 72: {
				INTERFACE.sendSafeMessage(1);
				break;
			}
			case 66: {
				INTERFACE.sendSafeMessage(2);
				break;
			}
			case 89: {
				INTERFACE.sendSafeMessage(20);
				break;
			}
			case 78: {
				INTERFACE.sendSafeMessage(21);
				break;
			}
			case 79: {
				INTERFACE.sendSafeMessage(22);
				break;
			}
			case 187: {
				toggleHighQuality();
				break;
			}
			case 189: {
				toggleHighQuality();
				break;
			}
			case 77: {
				INTERFACE.showContent("map");
				break;
			}
		}
	} 
	public function showDock() {
		var _loc3 = "nonmember";
		if (INTERFACE.isMember()) {
			_loc3 = "member";
		} 
		if (INTERFACE.isSafeMode() || SHELL.isWorldSafe()) {
			INTERFACE.DOCK.chat_mc.gotoAndStop(2);
			INTERFACE.DOCK.chat_mc._visible = false;
		} else {
			INTERFACE.DOCK.chat_mc.chat_input.tabIndex = 1;
			INTERFACE.DOCK.chat_mc.chat_input.onSetFocus = function() {
				INTERFACE.is_chat_focused = true;
			};
			INTERFACE.DOCK.chat_mc.chat_input.onKillFocus = function() {
				INTERFACE.is_chat_focused = false;
			};
			INTERFACE.DOCK.chat_mc.chat_input.restrict = INTERFACE.getLocalizedString("chat_restrict");
			INTERFACE.DOCK.chat_mc.send_btn.onRelease = function() {
				var _loc1 = INTERFACE.DOCK.chat_mc.chat_input;
				INTERFACE.sendMessage(_loc1.text);
				_loc1.text = "";
				INTERFACE.closeHint();
			};
			INTERFACE.DOCK.chat_mc.send_btn.onRollOver = function() {
				INTERFACE.showHint(this, "send_hint");
			};
			INTERFACE.DOCK.chat_mc.send_btn.onRollOut = INTERFACE.closeHint;
		} 
		INTERFACE.DOCK.safe_btn.onRelease = function() {
			INTERFACE.showSafeMenu();
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.safe_btn.onRollOver = function() {
			INTERFACE.showHint(this, "safe_hint");
		};
		INTERFACE.DOCK.safe_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.emote_btn.onRelease = function() {
			INTERFACE.showEmoteMenu();
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.emote_btn.onRollOver = function() {
			INTERFACE.showHint(this, "emote_hint");
		};
		INTERFACE.DOCK.emote_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.action_btn.onRelease = function() {
			INTERFACE.showActionMenu();
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.action_btn.onRollOver = function() {
			INTERFACE.showHint(this, "action_hint");
		};
		INTERFACE.DOCK.action_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.throw_btn.onRelease = function() {
			INTERFACE.showCrosshair();
			INTERFACE.closeHint();
			INTERFACE.snowMenuOpened = false;
		};
		INTERFACE.DOCK.throw_btn.onRollOver = function() {
			if(!INTERFACE.snowMenuOpened) {
				INTERFACE.showSnowMenu(true);
			} 
			//INTERFACE.showSnowMenu();
			INTERFACE.showHint(this, "throw_ball_hint");
		};
		INTERFACE.DOCK.throw_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.player_btn.onRelease = function() {
			INTERFACE.showPlayerWidget(INTERFACE.getPlayerId(), INTERFACE.getPlayerNickname());
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.player_btn.onRollOver = function() {
			INTERFACE.showHint(this, "player_hint");
		};
		INTERFACE.DOCK.player_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK_PLAYER_ICON.gotoAndStop(_loc3);
		INTERFACE.DOCK.buddy_btn.onRelease = function() {
			INTERFACE.showBuddyWidget();
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.buddy_btn.onRollOver = function() {
			INTERFACE.showHint(this, "buddy_hint");
		};
		INTERFACE.DOCK.buddy_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.home_btn.onRelease = function() {
			INTERFACE.sendJoinPlayerIgloo(INTERFACE.getPlayerId());
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.home_btn.onRollOver = function() {
			INTERFACE.showHint(this, "home_hint");
		};
		INTERFACE.DOCK.home_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK.help_btn.onRelease = function() {
			INTERFACE.showContent("help");
			INTERFACE.closeHint();
		};
		INTERFACE.DOCK.help_btn.onRollOver = function() {
			INTERFACE.showHint(this, "help_hint");
		};
		INTERFACE.DOCK.help_btn.onRollOut = INTERFACE.closeHint;
		INTERFACE.DOCK._visible = true;
		INTERFACE.DOCK.buddy_online_mc._visible = false;
		INTERFACE.DOCK.buddy_online_mc.gotoAndStop("park");
		if (INTERFACE.DOCK.onMouseDown == undefined) {
			INTERFACE.DOCK.onMouseDown = function() {
				if (Selection.getFocus() != null) {
					Selection.setFocus(null);
				} 
			};
		} 
	}
	public function e_itemOutofStock(obj) {
		var _loc2 = SHELL.window_size[SHELL.WINDOW_SMALL];
		var _loc1 = SHELL.getLocalizedErrorStringById(SHELL.ITEM_OUT_OF_STOCK);
		var _loc3 = SHELL.getLocalizedString("Okay");
		var _loc4 = SHELL.buildErrorCodeString(obj.type, SHELL.ITEM_OUT_OF_STOCK);
		var action = function () {
			INTERFACE.closePrompt();
			SHELL.closeErrorPrompt();
		}
		SHELL.showErrorPrompt(_loc2, _loc1, _loc3, action, _loc4);
	}
}