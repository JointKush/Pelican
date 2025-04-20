class com.customs.Plugins.RoomPin {
    private var SHELL, ENGINE, INTERFACE;
    private var _pinObject, _pinClip;

    public function RoomPin() {
        trace("Room Pin Plugin Loaded");
        INTERFACE = com.customs.Pelican._interface;
        SHELL = com.customs.Pelican._shell;
        ENGINE = com.customs.Pelican._engine;
        
        this.init();
        this.setOverride();
    }

    private function setOverride(): Void {
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

    public function destroy(): Void {
        SHELL.removeListener(SHELL.ROOM_DESTROYED, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomDestroyed));
        ENGINE.destroyPinClip();
    }

    private function getPinObject(): Object {
        var roomId = SHELL.getCurrentRoomId();
        return SHELL.getPinObjById(roomId);
    }

    private function getPinObjById(id: String): Object {
        var pinObjects = SHELL.pin_room_obj;
        for (var pinId in pinObjects) {
            if (pinId === id) {
                return pinObjects[pinId];
            }
        }
    }

    private function setRoomPinData(pinData: Object): Void {
        for (var pinId in pinData) {
            pinData[pinId].pin_id = pinData[pinId].pin_id;
            pinData[pinId].pin_x = pinData[pinId].pin_x;
            pinData[pinId].pin_y = pinData[pinId].pin_y;
        }
        SHELL.pin_room_obj = pinData;
    }

    private function setupPin(): Void {
        _pinObject = SHELL.getPinObject();
        if (_pinObject && _pinObject.pin_id && _pinObject.pin_x && _pinObject.pin_y) {
            var roomClip = ENGINE.getRoomMovieClip();
            var loader = new com.clubpenguin.hybrid.HybridMovieClipLoader();
            var pinPath = SHELL.getGlobalContentPath() + "rooms/room_pin/" + _pinObject.pin_id + ".swf";
            
            _pinClip = roomClip.createEmptyMovieClip("pinClip", roomClip.getNextHighestDepth());
            loader.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_ERROR, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomPinLoadError));
            loader.addEventListener(com.clubpenguin.hybrid.HybridMovieClipLoader.EVENT_ON_LOAD_INIT, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomPinLoadInit));
            
            loader.loadClip(pinPath, _pinClip);
        }
    }

    private function init(): Void {
        SHELL.addListener(SHELL.ROOM_DESTROYED, com.clubpenguin.util.Delegate.create(this, ENGINE.onRoomDestroyed));
    }

    private function onRoomDestroyed(): Void {
        ENGINE.destroyPinClip();
    }

    private function destroyPinClip(): Void {
        if (_pinClip) {
            _pinClip.removeMovieClip();
        }
    }

    private function onPinClicked(): Void {
        INTERFACE.buyInventory(_pinObject.pin_id);
    }

    private function onRoomPinLoadError(event: Object): Void {}

    private function onRoomPinLoadInit(event: Object): Void {
        _pinClip._x = _pinObject.pin_x;
        _pinClip._y = _pinObject.pin_y;
        _pinClip.onRelease = com.clubpenguin.util.Delegate.create(this, ENGINE.onPinClicked);
    }

    private function setupRoom(mc: MovieClip): Void {
        var roomClip = mc.room_mc ? mc.room_mc : mc;
        roomClip.start_x = mc.start_x;
        roomClip.start_y = mc.start_y;
        
        ENGINE.setRoomMovieClip(roomClip);

        for (var clipName in mc) {
            if (typeof(mc[clipName]) == "movieclip") {
                var clip = mc[clipName];
                
                switch (clip) {
                    case mc.block_mc:
                        ENGINE.setRoomBlockMovieClip(clip);
                        clip._visible = false;
                        break;
                    case mc.triggers_mc:
                        ENGINE.setRoomTriggersMovieClip(clip);
                        clip._visible = false;
                        break;
                    case mc.interface_mc:
                        ENGINE.setRoomInterfaceMovieClip(clip);
                        clip.swapDepths(900002);
                        break;
                    case mc.foreground_mc:
                        clip.swapDepths(900001);
                        break;
                    case mc.background_mc:
                        clip._visible = true;
                        break;
                    default:
                        if (clip._x > 0 && roomClip._x < ENGINE.MAX_SCREEN_WIDTH && clip._y > 0 && roomClip._y < ENGINE.MAX_SCREEN_HEIGHT) {
                            ENGINE.updateObjectDepth(clip);
                        }
                        break;
                }
            }
        }

        ENGINE.setRoomReady(true);
        ENGINE.setupTables();
        ENGINE.setupWaddle();
        ENGINE.setupPlayer();
        SHELL.startRoomMusic();
        roomClip.startRoom();
        SHELL.roomInitiated();
        ENGINE.setupPin();
        ENGINE.puffleManager.setupPathEngine();
        ENGINE.puffleManager.clearPuffles();
    }
}
