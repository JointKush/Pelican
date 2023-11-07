class com.customs.Plugins.RoomPin {
    var SHELL, ENGINE, INTERFACE, _pinObject, _pinClip, pin_room_obj;

    public function RoomPin() {
		trace("Room Pin Plugin Loaded");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		ENGINE = com.customs.Pelican._engine;
        this.init();
		this.setOverride();
    }
	public function setOverride() : Void {
		ENGINE.setupRoom = setupRoom;
		ENGINE.setupPin = setupPin;
		ENGINE.onRoomDestroyed = onRoomDestroyed;
		ENGINE.destroyPinClip = destroyPinClip;
		ENGINE.onPinClicked = onPinClicked;
		ENGINE.onRoomPinLoadInit = onRoomPinLoadInit;
		SHELL.pin_room_obj = {};
		SHELL.getPinObject = getPinObject;
		SHELL.getPinObjById = getPinObjById;
		SHELL.setRoomPinData = setRoomPinData;
	}

    public function destroy() {
        SHELL.removeListener(SHELL.ROOM_DESTROYED, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomDestroyed));
        ENGINE.destroyPinClip();
   }
   public function getPinObject() {
		var _loc1 = SHELL.getCurrentRoomId();
		return (SHELL.getPinObjById(_loc1));
   }
	public function getPinObjById(id) {
		var _loc1 = SHELL.pin_room_obj;
		for (var _loc3 in _loc1) {
			if (_loc3 === id) {
				return (_loc1[_loc3]);
			} 
		}
	}
	public function setRoomPinData(obj) {
		for (var _loc1 in obj) {
			obj[_loc1].pin_id = obj[_loc1].pin_id;
			obj[_loc1].pin_x = obj[_loc1].pin_x;
			obj[_loc1].pin_y = obj[_loc1].pin_y;
		}
		SHELL.pin_room_obj = obj;
	} 
   public function setupPin() {
        _pinObject = SHELL.getPinObject();
        if (_pinObject != undefined && _pinObject != null) {
            if (_pinObject.pin_id != undefined && _pinObject.pin_id != null && _pinObject.pin_x != undefined && _pinObject.pin_x != null && _pinObject.pin_y != undefined && _pinObject.pin_y != null) {
                var _loc3 = ENGINE.getRoomMovieClip();
                var _loc2 = new com.clubpenguin.hybrid.HybridMovieClipLoader();
                var _loc4 = SHELL.getGlobalContentPath() + "rooms/room_pin/" + _pinObject.pin_id + ".swf";
                _pinClip = _loc3.createEmptyMovieClip("pinClip", _loc3.getNextHighestDepth());
                _loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_ERROR, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomPinLoadError));
                _loc2.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomPinLoadInit));
                _loc2.loadClip(_loc4, _pinClip);
            } 
        }
    } 
    public function init() {
        SHELL.addListener(SHELL.ROOM_DESTROYED, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomDestroyed));
    } 
    public function onRoomDestroyed() {
        ENGINE.destroyPinClip();
    }
    public function destroyPinClip() {
        if (_pinClip != undefined) {
            _pinClip.removeMovieClip();
        } 
    }
	public function onPinClicked() {
      INTERFACE.buyInventory(_pinObject.pin_id);
    } 
    public function onRoomPinLoadError(event) {}
   	public function onRoomPinLoadInit(event) {
        _pinClip._x = _pinObject.pin_x;
        _pinClip._y = _pinObject.pin_y;
        _pinClip.onRelease = com.clubpenguin.util.Delegate.create(this, ENGINE.onPinClicked);
    } 

	public function setupRoom(mc) {
		var _loc3;
		if (mc.room_mc != undefined) {
			_loc3 = mc.room_mc;
			_loc3.start_x = mc.start_x;
			_loc3.start_y = mc.start_y;
		} else {
			_loc3 = mc;
		}
		ENGINE.setRoomMovieClip(_loc3);
		for (var _loc4 in mc) {
			if (typeof(mc[_loc4]) == "movieclip") {
				var _loc1 = mc[_loc4];
				if (_loc1 == mc.block_mc) {
					ENGINE.setRoomBlockMovieClip(_loc1);
					_loc1._visible = false;
					continue;
				}
				if (_loc1 == mc.triggers_mc) {
					ENGINE.setRoomTriggersMovieClip(_loc1);
					_loc1._visible = false;
					continue;
				} 
				if (_loc1 == mc.interface_mc) {
					ENGINE.setRoomInterfaceMovieClip(_loc1);
					_loc1.swapDepths(900002);
					continue;
				}
				if (_loc1 == mc.foreground_mc) {
					_loc1.swapDepths(900001);
					continue;
				}
				if (_loc1 == mc.background_mc) {
					_loc1._visible = true;
					continue;
				}

				if (_loc1._x > 0 && _loc3._x < ENGINE.MAX_SCREEN_WIDTH) {
					if (_loc1._y > 0 && _loc3._y < ENGINE.MAX_SCREEN_HEIGHT) {
						ENGINE.updateObjectDepth(_loc1);
					}
				} 
			}
		}
		ENGINE.setRoomReady(true);
		ENGINE.setupTables();
		ENGINE.setupWaddle();
		ENGINE.setupPlayer();
		SHELL.startRoomMusic();
		_loc3.startRoom();
		SHELL.roomInitiated();
		ENGINE.setupPin();
		ENGINE.puffleManager.setupPathEngine();
		ENGINE.puffleManager.clearPuffles();
	} 
}