
class com.customs.PluginManager {
    private static var instance:PluginManager;
    private var plugins:Object;
    private var pendingReady:Array;

    private function PluginManager() {
        plugins = {};
        pendingReady = [];
    }

    public static function getInstance():PluginManager {
        if (instance == undefined) {
            instance = new PluginManager();
        }
        return instance;
    }

    public function registerPlugin(name:String, plugin:Object, metadata:Object):Void {
        if (plugins[name] != undefined) {
            trace("[PluginManager] Plugin already registered: " + name);
            return;
        }
        if (metadata == undefined) metadata = {};
        plugins[name] = {
            instance: plugin,
            status: "initialized",
            metadata: metadata,
            name: name
        };
        trace("[PluginManager] Registered plugin: " + name);
        this.dispatchLifecycleEvent(name, "onInit");

        if (this.dependenciesMet(name)) {
            this.markReady(name);
        } else {
            trace("[PluginManager] '" + name + "' waiting on dependencies: " + metadata.dependencies);
            pendingReady.push(name);
        }
    }

    private function dependenciesMet(name:String):Boolean {
        var deps:Array = plugins[name].metadata.dependencies;
        if (deps == undefined) return true;
        for (var i:Number = 0; i < deps.length; i++) {
            var dep:String = deps[i];
            if (plugins[dep] == undefined || plugins[dep].status != "ready") {
                return false;
            }
        }
        return true;
    }
    public function markReady(name:String):Void {
        if (plugins[name] != undefined) {
            plugins[name].status = "ready";
            trace("[PluginManager] Plugin ready: " + name);
            this.dispatchLifecycleEvent(name, "onReady");
            this.checkPendingPlugins();
        }
    }
	public function getPluginStatus(name:String):String {
		if (plugins[name] != undefined) {
			return plugins[name].status;
		}
		return null;
	}
    private function checkPendingPlugins():Void {
        var stillPending:Array = [];
        for (var i:Number = 0; i < pendingReady.length; i++) {
            var name:String = pendingReady[i];
            if (this.dependenciesMet(name)) {
                this.markReady(name);
            } else {
                stillPending.push(name);
            }
        }
        pendingReady = stillPending;
    }

    public function unloadPlugin(name:String):Void {
        if (plugins[name] != undefined) {
            plugins[name].status = "unloaded";
            trace("[PluginManager] Plugin unloaded: " + name);
            this.dispatchLifecycleEvent(name, "onUnload");
        }
    }

    private function dispatchLifecycleEvent(name:String, event:String):Void {
        var eventName = "plugin:" + name + ":" + event;
        com.customs.PluginEvents.getInstance().dispatchEvent(eventName, {
            name: name,
            status: plugins[name].status,
            plugin: plugins[name].instance,
            metadata: plugins[name].metadata
        });
    }

    public function getPlugin(name:String):Object {
        return plugins[name];
    }
}
