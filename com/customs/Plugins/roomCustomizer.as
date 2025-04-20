class com.customs.Plugins.roomCustomizer {
    private var pluginName:String = "roomCustomizer";

    public function roomCustomizer() {
        trace("Loaded Room Customizer Plugin");

        com.customs.PluginManager.getInstance().registerPlugin(pluginName, this, {
            name: pluginName,
            version: "1.0.0",
            dependencies: ["partySwitcher"]
        });

        com.customs.PluginEvents.getInstance().addEventListener("plugin:partySwitcher:onReady", this.init);
    }

    public function init(info:Object):Void {
        trace("[roomCustomizer] PartySwitcher is ready. Initializing RoomCustomizer.");
        com.customs.PluginManager.getInstance().markReady("roomCustomizer");
    }
}
