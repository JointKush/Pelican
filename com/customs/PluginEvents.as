
class com.customs.PluginEvents {
    private static var instance:PluginEvents;
    private var eventMap:Object;

    private function PluginEvents() {
        eventMap = {};
    }

    public static function getInstance():PluginEvents {
        if (instance == undefined) {
            instance = new PluginEvents();
        }
        return instance;
    }

    public function addEventListener(event:String, callback:Function):Void {
        if (eventMap[event] == undefined) {
            eventMap[event] = [];
        }
        eventMap[event].push(callback);
    }

    public function removeEventListener(event:String, callback:Function):Void {
        var listeners:Array = eventMap[event];
        if (listeners != undefined) {
            for (var i:Number = 0; i < listeners.length; i++) {
                if (listeners[i] == callback) {
                    listeners.splice(i, 1);
                    break;
                }
            }
        }
    }

    public function dispatchEvent(event:String, data:Object):Void {
        var listeners:Array = eventMap[event];
        if (listeners != undefined) {
            for (var i:Number = 0; i < listeners.length; i++) {
                listeners[i](data);
            }
        }
    }
}
