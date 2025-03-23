class com.customs.Plugins.pluginDispenser {
	
	var __set__plugins, customPlugins, wildCardPlugins;
	public function pluginDispenser (plugins) {
		super();
		trace("Plugins Loaded: " + plugins.length);
		this.__set__plugins(plugins);
	}
	
	public function set plugins(plugins) {
		for (var i in plugins) {
			if(plugins[i].isDisabled !== true) {
				var pluginName = plugins[i].name;
				var pluginLength = pluginName.length
				var wildCard = plugins[i].wildCard;
				var pluginSplit = pluginName.split(".");
				if (wildCard && wildCard !== undefined) {
					wildCardPlugins = pluginSplit[1].substring(0, pluginSplit[1].length);
					trace("Wild Card Plugin " + wildCardPlugins);
					wildCardPlugins = new com.customs.Plugins[pluginSplit[0]][wildCardPlugins]();
				}
				customPlugins = new com.customs.Plugins[pluginName]();
			}
		}
	}
}