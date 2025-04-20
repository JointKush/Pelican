class com.customs.Plugins.customEmotes {

	static var _stage, INTERFACE, SHELL, ENGINE, EMOTE_MENU;

	public function customEmotes() {
		trace("Custom Emotes Plugin Loaded v1.2a");

		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		_stage = com.customs.Pelican.stageReference;

		EMOTE_MENU = _stage.emote_menu_mc;

		this.setOverride();
	}

	public function setOverride(): Void {
		SHELL.emote_data_obj = {};
		SHELL.setEmoteData = setEmoteData;
		INTERFACE.updateEmotePageText = updateEmotePageText;
		INTERFACE.showEmoteMenu = showEmoteMenu;
		INTERFACE.showEmoteBalloon = showEmoteBalloon;
		INTERFACE.closeEmoteMenu = closeEmoteMenu;
		INTERFACE.setupNavButtons = setupNavButtons
		INTERFACE.renderEmotes = renderEmotes;
		INTERFACE.setupMenuButtons = setupMenuButtons;


		INTERFACE.emotepage = 0;
		INTERFACE.MAX_EMOTES_PER_PAGE = 21;
	}

	public function setEmoteData(obj): Void {
		for (var key in obj) {
			obj[key].frame_balloon_id = obj[key].frame_balloon_id;
			obj[key].frame_menu_id = obj[key].frame_menu_id;
			obj[key].emote_name = obj[key].emote_name;
		}
		SHELL.emote_data_obj = obj;
	}

	public function updateEmotePageText(page, maxPage): Void {
		EMOTE_MENU.page_txt.text = (page + 1) + "/" + (maxPage + 1);
	}

	public function showEmoteMenu(): Void {
		EMOTE_MENU.gotoAndStop(1);
		EMOTE_MENU.gotoAndStop(2);

		var emotes = SHELL.emote_data_obj;
		var emoteLength = INTERFACE.MAX_EMOTES_PER_PAGE;
		var pageArr = INTERFACE.paginateArray(emotes, INTERFACE.emotepage, emoteLength);
		var maxPage = INTERFACE.getMaxPage(emotes, emoteLength);

		INTERFACE.updateEmotePageText(INTERFACE.emotepage, maxPage);

		INTERFACE.setupNavButtons(maxPage);
		INTERFACE.renderEmotes(pageArr);
		INTERFACE.setupMenuButtons();
	}

	private function setupNavButtons(maxPage): Void {
		if (INTERFACE.emotepage < maxPage) {
			EMOTE_MENU.next_btn._visible = true;
			EMOTE_MENU.next_btn.onRelease = function () {
				++INTERFACE.emotepage;
				INTERFACE.showEmoteMenu();
			};
		} else {
			EMOTE_MENU.next_btn._visible = false;
		}

		if (INTERFACE.emotepage > 0) {
			EMOTE_MENU.prev_btn._visible = true;
			EMOTE_MENU.prev_btn.onRelease = function () {
				--INTERFACE.emotepage;
				INTERFACE.showEmoteMenu();
			};
		} else {
			EMOTE_MENU.prev_btn._visible = false;
		}
	}

	private function renderEmotes(pageArr): Void {
		for (var i = 0; i < INTERFACE.MAX_EMOTES_PER_PAGE; ++i) {
			var emoteData = pageArr[i];
			var emoteMC = EMOTE_MENU["e" + i + "_mc"];

			if (emoteData != undefined) {
				emoteMC._visible = true;
				emoteMC.attachMovie("emotes", "newEmotes_mc", emoteMC.getNextHighestDepth());

				if (emoteData.frame_menu_id > 21) {
				  //emotesMC.newEmotes_mc._y = 1;
					emoteMC.newEmotes_mc._xscale = 75;
					emoteMC.newEmotes_mc._yscale = 75;
					emoteMC.newEmotes_mc.loadMovie(SHELL.getGlobalContentPath() + "emotes/" + emoteData.frame_balloon_id + ".swf");
				} else {
					emoteMC.newEmotes_mc.gotoAndStop(emoteData.frame_menu_id);
				}

				emoteMC.slot_btn.emote_data = emoteData;
				emoteMC.slot_btn.onRelease = function () {
					var data = this.emote_data;
					if (data.disabled) {
						return SHELL.showErrorPrompt("max", "The " + data.emote_name + " Emote is Disabled!", "Okay", undefined, "");
					}
					INTERFACE.clickEmote(data.frame_balloon_id);
				};
			} else {
				emoteMC._visible = false;
			}
		}
	}

	private function setupMenuButtons(): Void {
		EMOTE_MENU.back_btn.onRelease = INTERFACE.closeEmoteMenu;
		EMOTE_MENU.back_btn.onRollOver = INTERFACE.closeEmoteMenu;
		EMOTE_MENU.close_btn.onRelease = INTERFACE.closeEmoteMenu;

		EMOTE_MENU.back_btn.useHandCursor = false;
		EMOTE_MENU.safe_btn.useHandCursor = false;
	}

	public function showEmoteBalloon(playerID, emoteFrame): Void {
		INTERFACE.BALLOONS.showEmoteBalloon(playerID, emoteFrame);
		if (emoteFrame > 30) {
			INTERFACE.balloons_mc["p" + playerID].icon_mc.loadMovie(SHELL.getGlobalContentPath() + "emotes/" + emoteFrame + ".swf");
		}
	}

	public function closeEmoteMenu(): Void {
		EMOTE_MENU.gotoAndStop(1);
	}
}
