class com.customs.Plugins.customBadges {
	
	static var INTERFACE, SHELL, AIRTOWER, ENGINE, badgeHintTextMap, _paperdoll;
	public function customBadges () {
		trace("Loaded Custom Badges Plugin");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		AIRTOWER = com.customs.Pelican._airtower;
		ENGINE = com.customs.Pelican._engine;		
		this.setOverride();
	}
	
	public function setOverride() : Void {
		INTERFACE.updatePlayerWidget = updatePlayerWidget;
		INTERFACE.showPlayerWidget = showPlayerWidget;
		SHELL.makePlayerObjectFromString = makePlayerObjectFromString;
		SHELL.GLOBAL_CRUMBS.global_path.mod_panel =  SHELL.getGlobalContentPath() + "content/modpanel.swf";
		SHELL.LOCAL_CRUMBS.lang.mod_panel = "Moderator Panel";
		SHELL.parseJson = parseJson;
		badgeHintTextMap = new Object();
		badgeHintTextMap[1] = "Designer";
		badgeHintTextMap[2] = "Moderator";
		badgeHintTextMap[3] = "Developer";
		badgeHintTextMap[4] = "Administrator";
		
	}

	public function showPlayerWidget(playerID, nickname) {
		_paperdoll = new com.clubpenguin.ui.PaperDollRev();
		_paperdoll.__set__shell(SHELL);
		_paperdoll.__set__ui(this);
		_paperdoll.__set__fadeAfterLoad(true);
		var _loc2 = {};
		_loc2.player_id = playerID;
		_loc2.nickname = nickname;
		INTERFACE.setActivePlayerObject(_loc2);
		INTERFACE.showWidget(INTERFACE.PLAYER_WIDGET, INTERFACE.closePlayerWidget);
		INTERFACE.updatePlayerWidget();
		SHELL.addListener(SHELL.LOAD_PLAYER_IGLOO_LIST, INTERFACE.handlePlayerIglooList);
		SHELL.loadPlayerIglooList();
	}
	public function updatePlayerWidget() {
		trace("==UpdatePlayerWidget V4.4 @Override==");
		var _loc2 = INTERFACE.getActivePlayerId();
		var _loc12 = INTERFACE.getActivePlayerNickname();
		var player_ob = INTERFACE.getPlayerObject(_loc2);
		var _loc9 = INTERFACE.getPlayerRelationship(_loc2);
		var _loc10 = INTERFACE.getMembershipBadgeChevronFrame(player_ob.total_membership_days);
		var _loc7 = INTERFACE.PLAYER_WIDGET.art_mc.moderatorButtonEditPlayer;
		var _loc1 = INTERFACE.PLAYER_WIDGET.art_mc.icon_mc;
		var BADGE = INTERFACE.PLAYER_WIDGET.art_mc.badge_mc;
		var _loc5 = _loc1.member_badge_mc.ribbon_mc;
		var _loc4 = _loc1.member_badge_mc.chevron_mc;
		if (player_ob == undefined) {
			INTERFACE.PLAYER_WIDGET.art_mc.gotoAndStop(1);
		} else {
			if (_loc2 === INTERFACE.getPlayerId()) {
				if (INTERFACE.is_player_widget_tab_open) {
					INTERFACE.openPlayerWidgetTab();
				} else if (INTERFACE.is_player_outfit_tab_open) {
					INTERFACE.openPlayerOutfitWidgetTab();
				} else {
					INTERFACE.closePlayerWidgetTab();
				}
				INTERFACE.updatePlayerWidgetCoins();
				INTERFACE.updatePlayerWidgetStamps();
				INTERFACE.showStampBookButton();
			} else {
				INTERFACE.PLAYER_WIDGET.art_mc.gotoAndStop(2);
			}
			if (INTERFACE.isLocalPlayer(_loc2)) {
				_paperdoll.__set__isInteractive(true);
			} else {
				_paperdoll.__set__isInteractive(false);
			}
			if (_paperdoll.__get__paperDollClip() == null) {
				_paperdoll.__set__paperDollClip(INTERFACE.PLAYER_WIDGET.art_mc.paper_doll_mc);
			}
			if (_paperdoll.__get__flagClip() == null) {
				_paperdoll.__set__flagClip(INTERFACE.PLAYER_WIDGET.art_mc.flag_mc);
			}
			if (_paperdoll.__get__backgroundClip() == null) {
				_paperdoll.__set__backgroundClip(INTERFACE.PLAYER_WIDGET.art_mc.photo_mc);
			}
			_paperdoll.__set__colourID(player_ob.colour_id);
			_paperdoll.__set__flagID(player_ob.flag_id);
			_paperdoll.__set__backgroundID(player_ob.photo_id);
			for (var _loc6 in SHELL.PAPERDOLL_DEFAULT_LAYER_DEPTHS) {
				_paperdoll.addItem(_loc6, player_ob[_loc6]);
			}
			INTERFACE.updatePlayerWidgetMenu(_loc2, _loc9);
		}
		
		INTERFACE.PLAYER_WIDGET.art_mc.name_txt.text = _loc12;
		_loc7._visible = false;
		if (INTERFACE.isModerator()) {
			if(_loc2 === INTERFACE.getPlayerId()) {
				_loc7._visible = false;
			} else {
				_loc7._visible = true;
			}
			_loc7.onPress = function() {
				INTERFACE.showContent("mod_panel");
			};
		}
		INTERFACE.updateListeners(INTERFACE.PLAYER_CARD_UPDATED);
		if(_loc2 >= 9000000) {
			INTERFACE.PLAYER_WIDGET.art_mc.gotoAndStop(6);
		}
		BADGE._visible = false;
		if (player_ob.badge) {
			BADGE._visible = true;
			BADGE.gotoAndStop(badgeHintTextMap[player_ob.badge]);
			BADGE.onRollOver = function() {
				var badge = player_ob.badge;
				INTERFACE.showHint(this, badgeHintTextMap[badge], true);
			}
			BADGE.onRollOut = INTERFACE.closeHint;	
		}
		if (INTERFACE.isLocalPlayer(_loc2)) {
			if (INTERFACE.isMember()) {
				_loc1.gotoAndStop(INTERFACE.ICON_LABEL_ME_MEMBER);
				_loc5 = _loc1.member_badge_mc.ribbon_mc;
				_loc4 = _loc1.member_badge_mc.chevron_mc;
				_loc5.gotoAndStop(SHELL.getLocalizedFrame());
				_loc4.gotoAndStop(_loc10);
				return;
			}
			_loc1.gotoAndStop(INTERFACE.ICON_LABEL_ME_FREE);
			return;
		}
		if (_loc9 == "Mascot") {
			_loc1.gotoAndStop(INTERFACE.ICON_LABEL_MASCOT);
			_loc5 = _loc1.member_badge_mc.ribbon_mc;
			_loc4 = _loc1.member_badge_mc.chevron_mc;
			_loc5.gotoAndStop(SHELL.getLocalizedFrame());
			_loc4.gotoAndStop(INTERFACE.FIVE_CHEVRON);
			return;
		}
		var isMember = SHELL.isPlayerMemberById(_loc2);
		if (isMember) {
			_loc1.gotoAndStop(INTERFACE.ICON_LABEL_OTHER_MEMBER);
			_loc5 = _loc1.member_badge_mc.ribbon_mc;
			_loc4 = _loc1.member_badge_mc.chevron_mc;
			_loc5.gotoAndStop(SHELL.getLocalizedFrame());
			_loc4.gotoAndStop(_loc10);
			return;
		}
		_loc1.gotoAndStop(INTERFACE.ICON_LABEL_OTHER_FREE);
		return;
	}
	public function parseJson(obj) {
		if (obj.substr(0, 1) != "{") {
			return;
		}
		var data = com.clubpenguin.util.JSONParser.parse(obj);
		return (data);
	}
	
    public function makePlayerObjectFromString(player_string) {
        var parts = player_string.split("|");
        
        var playerId = Number(parts[0]);
        var username = String(parts[1]);
        var colourId = Number(parts[3]) || 0;
        var head = Number(parts[4]) || 0;
        var face = Number(parts[5]) || 0;
        var neck = Number(parts[6]) || 0;
        var body = Number(parts[7]) || 0;
        var hand = Number(parts[8]) || 0;
        var feet = Number(parts[9]) || 0;
        var flagId = Number(parts[10]) || 0;
        var photoId = Number(parts[11]) || 0;
        
        var playerObj = {
            nickname: username,
            username: username,
            player_id: playerId,
            colour_id: colourId,
            head: head,
            face: face,
            neck: neck,
            body: body,
            hand: hand,
            feet: feet,
            flag_id: flagId,
            photo_id: photoId,
            x: Number(parts[12]) || 0,
            y: Number(parts[13]) || 0,
            frame: Number(parts[14]) || 0,
            is_member: Boolean(Number(parts[15]) || 0),
            total_membership_days: Number(parts[16]) || 0,
            badge: Number(parts[17]) || 0,
            p_attributes: {
                ng: parts[18],
                nc: parts[19],
                bc: parts[20],
                sbc: parts[23],
                sbt: parts[24],
                btc: parts[25]
            },
            outfit_hues: SHELL.parseJson(parts[21]),
            outfits: SHELL.parseJson(parts[22]),
            frame_hack: SHELL.buildFrameHacksString(playerObj),
            thrownSnowballInCurrentRoom: false,
            emoteIDDisplayedInCurrentRoom: -1
        };

        return playerObj;
    }
}