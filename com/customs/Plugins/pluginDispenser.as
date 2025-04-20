class com.customs.Plugins.pluginDispenser {

    private var customPlugins:Array;
    private var wildCardPlugins:Array;
    private var pluginManager:com.customs.PluginManager;

    public function pluginDispenser(plugins:Array) {
        super();
        this.pluginManager = com.customs.PluginManager.getInstance();
        this.plugins = plugins;
    }

    public function set plugins(plugins:Array):Void {
        customPlugins = [];
        wildCardPlugins = [];

        for (var i:Number = 0; i < plugins.length; i++) {
            var pluginDef:Object = plugins[i];
            if (pluginDef.isDisabled === true) continue;

            var pluginName:String = pluginDef.name;
            var pluginSplit:Array = pluginName.split(".");
            var wildCard:String = pluginDef.wildCard;
            var pluginClass:Object;
            var pluginInstance:Object;

            if (wildCard && wildCard !== undefined) {
                var wildCardPluginName:String = pluginSplit[1];
                pluginClass = com.customs.Plugins[pluginSplit[0]][wildCardPluginName];
                pluginInstance = new pluginClass();
                wildCardPlugins.push(pluginInstance);
            } else {
                pluginClass = com.customs.Plugins[pluginName];
                pluginInstance = new pluginClass();
                customPlugins.push(pluginInstance);
            }

            var metadata:Object = pluginDef.metadata || {
                name: pluginName,
                version: "1.0.0",
                dependencies: pluginDef.dependencies || []
            };
            this.pluginManager.registerPlugin(pluginName, pluginInstance, metadata);
        }

        for (var i:Number = 0; i < plugins.length; i++) {
            var pluginDef:Object = plugins[i];
            if (pluginDef.isDisabled === true) continue;
            var name:String = pluginDef.name;
			if (this.pluginManager.getPluginStatus(name) != "ready" && this.pluginManager.dependenciesMet(name)) {
				this.pluginManager.markReady(name);
			}
        }
    }

    public function getCustomPlugins():Array {
        return customPlugins;
    }

    public function getWildCardPlugins():Array {
        return wildCardPlugins;
    }
}
