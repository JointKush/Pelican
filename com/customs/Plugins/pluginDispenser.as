class com.customs.Plugins.pluginDispenser {
    
    private var customPlugins:Array;
    private var wildCardPlugins:Array;

    public function pluginDispenser(plugins:Array) {
        super();
        trace("Plugins Loaded: " + plugins.length);
        this.plugins = plugins; 
    }

    public function set plugins(plugins:Array):Void {
        customPlugins = [];
        wildCardPlugins = [];
        
        for (var i:Number = 0; i < plugins.length; i++) {
            var plugin = plugins[i];
            
            if (plugin.isDisabled !== true) { 
                var pluginName:String = plugin.name;
                var pluginSplit:Array = pluginName.split(".");
                var wildCard:String = plugin.wildCard;
                
                if (wildCard && wildCard !== undefined) {
                    var wildCardPluginName:String = pluginSplit[1];
                    wildCardPlugins.push(new com.customs.Plugins[pluginSplit[0]][wildCardPluginName]());
                } else {
                    customPlugins.push(new com.customs.Plugins[pluginName]());
                }
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
