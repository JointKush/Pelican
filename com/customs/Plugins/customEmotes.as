class com.customs.Plugins.customEmotes {

	static var _stage, INTERFACE, SHELL, ENGINE, EMOTE_MENU;
	public function customEmotes() {
		trace("Custom Emotes Plugin Loaded v1.2a");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		_stage = com.customs.Pelican.stageReference;
		this.setOverride();
		
		EMOTE_MENU = _stage.emote_menu_mc;
	}
	
	public function setOverride(): Void {
		SHELL.emote_data_obj = {};
		SHELL.setEmoteData = setEmoteData;
		INTERFACE.updateEmotePageText = updateEmotePageText;
		INTERFACE.showEmoteMenu = showEmoteMenu;
		INTERFACE.showEmoteBalloon = showEmoteBalloon;
		INTERFACE.closeEmoteMenu = closeEmoteMenu;
		INTERFACE.emotepage = 0;
		INTERFACE.MAX_EMOTES_PER_PAGE= 21;
	}
	public function setEmoteData(obj) {
		for (var _loc2 in obj) { 
			obj[_loc2].frame_balloon_id = obj[_loc2].frame_balloon_id;
			obj[_loc2].frame_menu_id = obj[_loc2].frame_menu_id;
			obj[_loc2].emote_name = obj[_loc2].emote_name;
		} 
		
		SHELL.emote_data_obj = obj;
	}
	public function updateEmotePageText(page, maxPage) {
		EMOTE_MENU.page_txt.text = ++page +"/"+ ++maxPage;
	}
	public function showEmoteMenu() {
		EMOTE_MENU.gotoAndStop(1);
		EMOTE_MENU.gotoAndStop(2)
		var emoteLeng = SHELL.emote_data_obj.length;
		var pageArr = INTERFACE.paginateArray(SHELL.emote_data_obj, INTERFACE.emotepage, INTERFACE.MAX_EMOTES_PER_PAGE);
    	var maxPage = INTERFACE.getMaxPage(SHELL.emote_data_obj, INTERFACE.MAX_EMOTES_PER_PAGE);
		INTERFACE.updateEmotePageText(INTERFACE.emotepage, maxPage);
		if (INTERFACE.emotepage < maxPage) {
			EMOTE_MENU.next_btn._visible = true;
			EMOTE_MENU.next_btn.onRelease = function() {
				++INTERFACE.emotepage;
				INTERFACE.updateEmotePageText(INTERFACE.emotepage, maxPage);
				INTERFACE.showEmoteMenu();
			};
		} else {
			EMOTE_MENU.next_btn._visible = false;
		}
		if (INTERFACE.emotepage > 0) {
			EMOTE_MENU.prev_btn._visible = true;
			EMOTE_MENU.prev_btn.onRelease = function() {
				--INTERFACE.emotepage;
				INTERFACE.updateEmotePageText(INTERFACE.emotepage, maxPage);
				INTERFACE.showEmoteMenu();
			};
		} else {
			EMOTE_MENU.prev_btn._visible = false;
		}
		for (var i = 0; i < emoteLeng; ++i) {
			var _loc4 = pageArr[i];
			var emotesMC = EMOTE_MENU["e" + i + "_mc"];
			emotesMC._visible = true;
			if (_loc4 != undefined) {
				emotesMC.attachMovie("emotes", "newEmotes_mc", emotesMC.getNextHighestDepth());
				if(_loc4.frame_menu_id > 21) {
					//emotesMC.newEmotes_mc._y = 1;
					emotesMC.newEmotes_mc._xscale = 75;
					emotesMC.newEmotes_mc._yscale = 75;
					emotesMC.newEmotes_mc.loadMovie(SHELL.getGlobalContentPath() + "emotes/" + _loc4.frame_balloon_id + ".swf");
				} else {
					emotesMC.newEmotes_mc.gotoAndStop(_loc4.frame_menu_id);			
				}
				emotesMC.slot_btn.emote_data =_loc4;
				emotesMC.slot_btn.onRelease = function (){
					if(this.emote_data.disabled) {
						return (SHELL.showErrorPrompt("max", "The " + this.emote_data.emote_name + " Emote is Disabled!", "Okay", undefined, ""));
					}
					INTERFACE.clickEmote(this.emote_data.frame_balloon_id);
				};
				continue;
			}
			emotesMC._visible = false;
		}
		EMOTE_MENU.back_btn.onRelease = INTERFACE.closeEmoteMenu;
		EMOTE_MENU.back_btn.onRollOver = INTERFACE.closeEmoteMenu;
		EMOTE_MENU.close_btn.onRelease = INTERFACE.closeEmoteMenu;
		EMOTE_MENU.back_btn.useHandCursor = false;
		EMOTE_MENU.safe_btn.useHandCursor = false;
	}
	public function showEmoteBalloon(playerID, emoteFrame) {
		INTERFACE.BALLOONS.showEmoteBalloon(playerID, emoteFrame);
		if(emoteFrame > 30) {
			INTERFACE.balloons_mc["p" + playerID].icon_mc.loadMovie(SHELL.getGlobalContentPath() + "emotes/" + emoteFrame + ".swf");
		}
	} 
	
	public function closeEmoteMenu() {
		EMOTE_MENU.gotoAndStop(1);
	} 
		
}
	