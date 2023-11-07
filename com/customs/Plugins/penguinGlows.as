class com.customs.Plugins.penguinGlows {
	
	static var INTERFACE, SHELL, ENGINE, AIRTOWER, _stage;
	public function penguinGlows () {
		trace("Penguin Glows Loaded v1.5b");
		_stage = com.customs.Pelican.stageReference;
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		AIRTOWER = com.customs.Pelican._airtower;
		ENGINE = com.customs.Pelican._engine;
		this.setOverride();
	}
	
	public function setOverride() : Void {
		ENGINE.addPlayer = addPlayer;
		ENGINE.updatePlayerAttributes = updatePlayerAttributes;
		ENGINE.throwBall = throwBall;
		SHELL.handleSendUpdatePlayerAttribute = handleSendUpdatePlayerAttribute;
		SHELL.sendUpdateSnowballcolor = sendUpdateSnowballcolor;
		SHELL.sendUpdateSnowballType = sendUpdateSnowballType;
		SHELL.UPDATE_PLAYER_ATTR = "updatePlayerAttributes";
		SHELL.addListener(SHELL.UPDATE_PLAYER_ATTR, ENGINE.updatePlayerAttributes);
		SHELL.addListener(SHELL.BALL_LAND, com.clubpenguin.util.Delegate.create(this, this.onBallLand));
		AIRTOWER.UPDATE_PLAYER_ATTRIBUTE = "upattr";
		AIRTOWER.addListener(AIRTOWER.UPDATE_PLAYER_ATTRIBUTE, SHELL.handleSendUpdatePlayerAttribute);
		INTERFACE.showBalloon = showBalloon;
	}

	public function addPlayer(player_ob, targetX, targetY) {

		var _loc10 = ENGINE.getRoomMovieClip();
		var _loc14 = ENGINE.getRoomBlockMovieClip();
		var _loc3 = player_ob.player_id;
		var _loc8 = player_ob.nickname;
		ENGINE.removePlayer(_loc3);
		var _loc7 = ENGINE.addPlayerDepth(_loc3);
		var _loc5 = "p" + String(_loc3);
		INTERFACE.nicknames_mc.attachMovie("nickname", _loc5, _loc7, {
			_x: targetX,
			_y: targetY,
			_visible: false
		});
		var _loc4 = INTERFACE.nicknames_mc[_loc5].name_txt;
		_loc4.text = _loc8;
		_loc4.textColor = 0;
		if(player_ob.p_attributes.nc && player_ob.p_attributes.nc !== "0") {
			_loc4.textColor = "0x" + player_ob.p_attributes.nc;
		}
		if(player_ob.p_attributes.ng && player_ob.p_attributes.ng !== "0") {
			var glows = String("0x") + String(player_ob.p_attributes.ng);
			_loc4.filters = [new flash.filters.GlowFilter(glows , 10, 1.700000, 1.700000, 15, 3, false, false)];
		}
		if(_loc3 >= 900000) { //Sets NPC glows by default but will remove later to allow it to be set within "npc.json" if needed
		   _loc4.textColor = "0xFFFFFF";
		   _loc4.filters = [new flash.filters.GlowFilter(0x000000, 10, 1.700000, 1.700000, 15, 3, false, false)];
		}
		_loc10.createEmptyMovieClip(_loc5, _loc7);
		var _loc2 = _loc10[_loc5];
		_loc2.createEmptyMovieClip("art_mc", 1);
		_loc2._visible = true;
		_loc2.mc.art_mc._visible = true;
		_loc2.createEmptyMovieClip("book_mc", 70);
		_loc2.createEmptyMovieClip("head_mc", 60);
		_loc2.createEmptyMovieClip("face_mc", 50);
		_loc2.createEmptyMovieClip("hand_mc", 40);
		_loc2.createEmptyMovieClip("neck_mc", 30);
		_loc2.createEmptyMovieClip("body_mc", 20);
		_loc2.createEmptyMovieClip("feet_mc", 10);
		_loc2.colour_id = 0;
		_loc2.head = 0;
		_loc2.face = 0;
		_loc2.neck = 0;
		_loc2.body = 0;
		_loc2.hand = 0;
		_loc2.feet = 0;
		_loc2.player_id = _loc3;
		_loc2.nickname = _loc8;
		_loc2.depth_id = _loc7;
		_loc2.frame = player_ob.frame;
		_loc2.is_moving = false;
		_loc2.is_ready = false;
		_loc2.is_reading = false;
		_loc2.is_table = false;
		_loc2.onRelease = com.clubpenguin.util.Delegate.create(this, ENGINE.clickPlayer, _loc3, _loc8);
		if (SHELL.isMyPlayer(_loc3)) {
			var _loc12 = SHELL.getLocalizedString("load_penguin");
			SHELL.showLoading(_loc12, ENGINE.listener);
		} 
		var _loc11 = com.clubpenguin.util.URLUtils.getCacheResetURL(SHELL.getPath("penguin"));
		var _loc6 = new com.clubpenguin.hybrid.HybridMovieClipLoader();
		_loc6.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerLoadInit, player_ob, _loc3, targetX, targetY));
		_loc6.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_START, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerLoadStart, ENGINE.target_mc));
		_loc6.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_PROGRESS, com.clubpenguin.util.Delegate.create(this, ENGINE.onPlayerLoadProgress, ENGINE.target_mc));
		_loc6.loadClip(_loc11, _loc2.art_mc);
	}
	public function showBalloon(playerID, message) {
		INTERFACE.BALLOONS.showTextBalloon(playerID, message);
		var player_ob = SHELL.getPlayerObjectById(playerID);
		if(player_ob.p_attributes.bc && player_ob.p_attributes.bc !== "0") {
			var _loc1 = INTERFACE.balloons_mc["p" + playerID].balloon_mc;
			var _loc3 = INTERFACE.balloons_mc["p" + playerID].pointer_mc;
			var color = String("0x") + String(player_ob.p_attributes.bc);
			var _loc2:Color = new Color(_loc1);
			_loc2.setRGB(color);
			var _loc4:Color = new Color(_loc3);
			_loc4.setRGB(color);
		}
		if(player_ob.p_attributes.btc && player_ob.p_attributes.btc !== "0") {
			INTERFACE.balloons_mc["p" + playerID].message_txt.textColor = "0x" + player_ob.p_attributes.btc;
		}

	}
	public function updatePlayerAttributes(player_ob) {
		var _loc4 = INTERFACE.nicknames_mc["p" + player_ob.player_id].name_txt;
	
		if (player_ob.player_id === undefined) return;
	
		if (player_ob.attr_type === "nc") {
			if (player_ob.p_attributes.nc && player_ob.p_attributes.nc !== "0") {
				_loc4.textColor = "0x" + player_ob.p_attributes.nc;
				return;
			}
			_loc4.textColor = 0;
	
		}
		if (player_ob.attr_type === "ng") {
			if (player_ob.p_attributes.ng && player_ob.p_attributes.ng !== "0") {
				var glows = String("0x") + String(player_ob.p_attributes.ng);
				_loc4.filters = [new flash.filters.GlowFilter(glows, 10, 1.700000, 1.700000, 15, 3, false, false)];
				return;
			}
			_loc4.filters = undefined;
		}
		
		if(player_ob.attr_type === "bc") {
			if(player_ob.p_attributes.bc && player_ob.p_attributes.bc !== "0") {
				var _loc1 = INTERFACE.balloons_mc["p" + player_ob.player_id].balloon_mc;
				var _loc3 = INTERFACE.balloons_mc["p" + player_ob.player_id].pointer_mc;
				var color = String("0x") + String(player_ob.p_attributes.bc);
				var _loc2:Color = new Color(_loc1);
				_loc2.setRGB(color);
				var _loc4:Color = new Color(_loc3);
				_loc4.setRGB(color);
				return;
			}
		}
	}
	public function handleSendUpdatePlayerAttribute(obj) {
		var _loc5 = obj.shift();
		var _loc2 = Number(obj[0]);
		var _loc3 = obj[1];
		var _loc4 = obj[2];
		if (_loc2 !== undefined) {
			var _loc1 = SHELL.getPlayerObjectFromRoomById(_loc2);
			if (_loc1 != undefined) {
				_loc1.p_attributes[_loc3] = _loc4;
				_loc1.attr_type = _loc3;
				SHELL.updateListeners(SHELL.UPDATE_PLAYER_ATTR, _loc1);
			}     
		} 
	}
	public function sendUpdateSnowballcolor(value) {
	
		return (AIRTOWER.send(AIRTOWER.PLAY_EXT, "pattr#sbc", [value], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId()));
	}
	public function sendUpdateSnowballType(type) {
	
		return (AIRTOWER.send(AIRTOWER.PLAY_EXT, "pattr#sbt", [type], AIRTOWER.STRING_TYPE, SHELL.getCurrentServerRoomId()));
	}
	public function throwBall(player_id, target_x, target_y, start_height, max_height, wait) {
		var _loc2 = ENGINE.getPlayerMovieClip(player_id);
		var player_ob = SHELL.getPlayerObjectFromRoomById(player_id);
		var room_mc =  ENGINE.getRoomMovieClip();
		if (_loc2.is_reading) {
			 ENGINE.removePlayerBook(player_id);
		} 
		if (_loc2.is_ready && !_loc2.is_moving) {
			if ( ENGINE.throw_item_counter == undefined) {
				 ENGINE.throw_item_counter = 0;
			} 
			if ( ENGINE.throw_item_counter > 10) {
				 ENGINE.throw_item_counter = 0;
			} 
			var start_x = _loc2._x;
			var start_y = _loc2._y;
			var c =  ENGINE.throw_item_counter++;
			var _loc3 = "i" + c;
			if (room_mc[_loc3] != undefined) {
				room_mc[_loc3].removeMovieClip();
			} 
			room_mc.attachMovie("ball", _loc3, 1000200 + c);
			var mc = room_mc[_loc3];
			if (player_ob.p_attributes.sbc && player_ob.p_attributes.sbc !== "0") {
				var ballColor = new Color(mc);
				ballColor.setRGB("0x" + player_ob.p_attributes.sbc);
			}
			var ball_type_l = new MovieClipLoader();
			var listener = new Object();
			listener.onLoadInit = function(mc) {
				mc.player_id = player_id;
				mc.id = c;
				mc._x = start_x;
				mc._y = start_y;
				mc.type = player_ob.p_attributes.sbt;
				ENGINE.updateItemDepth(mc, c);
				var _loc6 =  ENGINE.findDistance(start_x, start_y, target_x, target_y);
				var _loc5 =  ENGINE.findAngle(start_x, start_y, target_x, target_y);
				var _loc4 = Math.round(ENGINE.findDirection(_loc5) / 2);
				 ENGINE.updatePlayerFrame(player_id, 26 + _loc4);
				var duration = _loc6 / 15;
				var change_x = target_x - start_x;
				var change_y = target_y - start_y;
				var peak = duration / 2;
				var change_height1 = max_height - start_height;
				var change_height2 = -max_height;
				mc.art._y = start_height;
				mc._visible = false;
				var t = 0;
				var w = 0;
				mc.onEnterFrame = function() {
					if (w > wait) {
						mc._visible = true;
						++t;
						if (t < duration) {
							mc._x =  ENGINE.mathLinearTween(t, start_x, change_x, duration);
							mc._y =  ENGINE.mathLinearTween(t, start_y, change_y, duration);
							 ENGINE.updateItemDepth(mc, c);
							if (t < peak) {
								mc.art._y =  ENGINE.mathEaseOutQuad(t, start_height, change_height1, peak);
							} else {
								mc.art._y =  ENGINE.mathEaseInQuad(t - peak, max_height, change_height2, peak);
							}
						} else {
							mc._x = target_x;
							mc._y = target_y;
							mc.art._y = 0;
							//mc.gotoAndStop(2);
							room_mc.handleThrow(mc);
							SHELL.updateListeners(SHELL.BALL_LAND, {
								snowBallMC: mc,
								id: mc.id,
								player_id: mc.player_id,
								x: mc._x,
								y: mc._y,
								type: mc.type
							});
							if (room_mc.snowballBlock != undefined) {
								if (room_mc.snowballBlock.hitTest(mc._x, mc._y, true)) {
									mc._visible = false;
								} 
							} 
							this.onEnterFrame = null;
						} 
					} else {
						++w;
					} 
				}
			};
			ball_type_l.addListener(listener);
			ball_type_l.loadClip((SHELL.getGlobalContentPath() + "snowballs/") + (player_ob.p_attributes.sbt ? (player_ob.p_attributes.sbt) : (1)) + ".swf", mc);
		} 
	} 
	
	
	public function onBallLand(snowBallInfo) {		
        var playerList = SHELL.getPlayerList();
		var snowBallClip = snowBallInfo.snowBallMC;
		var playerHitArr = [];
		
        for (var i in playerList) {
            var _loc2 = playerList[i];
            var _loc3 = ENGINE.getPlayerMovieClip(_loc2.player_id);
            var _loc4 = _loc3.hitTest(snowBallInfo.x, snowBallInfo.y, true);
            if (_loc4) {
                playerHitArr.push(_loc2);
            } 
        }
		if(snowBallInfo.snowBallMC._totalFrames >= 4) {
			snowBallInfo.snowBallMC.gotoAndStop("hit");
		} else {
			snowBallInfo.snowBallMC.gotoAndStop(2);
		}
		var _loc10 = playerHitArr[0];
		var player_ob = SHELL.getPlayerObjectFromRoomById(_loc10.player_id);
	    trace("onLandBall [player_id] = " + snowBallInfo.player_id);
		trace("onLandBall [type] = " + snowBallInfo.type);
		trace("You just threw a snowball at " + player_ob.username);
	}
}