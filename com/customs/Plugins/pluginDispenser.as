class com.customs.Plugins.pluginDispenser {

	private var customPlugins:Array;
	private var wildCardPlugins:Array;
	private var pluginMap:Object;
	private var visited:Object;

	public function pluginDispenser(plugins:Array) {
		super();
		customPlugins = [];
		wildCardPlugins = [];
		pluginMap = {};
		visited = {};

		if (plugins.length > 0) {
		   setPlugins(plugins);
		}
	}

	public function setPlugins(plugins:Array):Void {
		customPlugins = [];
		wildCardPlugins = [];
		pluginMap = {};
		visited = {};

		for (var i:Number = 0; i < plugins.length; i++) {
			var plugin:Object = plugins[i];
			if (plugin && plugin.name) {
				pluginMap[plugin.name] = plugin;
			}
		}

		var loadedPlugins:Object = {};
		for (var j:Number = 0; j < plugins.length; j++) {
			var plugin:Object = plugins[j];
			if (plugin.isDisabled !== true) {
				loadPluginWithDependencies(plugin, loadedPlugins);
			}
		}

		trace("Finished loading plugins. Custom: " + customPlugins.length + ", WildCard: " + wildCardPlugins.length);
	}

	private function loadPluginWithDependencies(plugin:Object, loaded:Object):Void {
		trace("Attempting to load plugin: " + plugin.name);
	
		if (loaded[plugin.name]) {
			trace("Plugin already loaded: " + plugin.name);
			return;
		}
		if (plugin.isDisabled === true) {
			trace("Plugin disabled: " + plugin.name);
			return;
		}
	
		if (visited[plugin.name]) {
			trace("Cycle detected for plugin: " + plugin.name);
			return;
		}
	
		visited[plugin.name] = true;
	
		if (plugin.dependencies && plugin.dependencies.length > 0) {
			for (var i:Number = 0; i < plugin.dependencies.length; i++) {
				var depName:String = plugin.dependencies[i];
				var dep:Object = pluginMap[depName];
	
				if (dep == undefined) {
					trace("Missing dependency: " + depName + " for plugin: " + plugin.name);
					continue;
				}
	
				loadPluginWithDependencies(dep, loaded);
			}
		}
	
		var pluginName:String = plugin.name;
		var pluginSplit:Array = pluginName.split(".");
		var wildCard:String = plugin.wildCard;
	
		var instance:Object;
	
		try {
			if (wildCard && wildCard !== undefined) {
				var packageName:String = pluginSplit[0];
				var className:String = pluginSplit[1];
				trace("Instantiating wildcard plugin: com.customs.Plugins." + packageName + "." + className);
				instance = new com.customs.Plugins[packageName][className]();
				wildCardPlugins.push(instance);
			} else {
				trace("Instantiating regular plugin: com.customs.Plugins." + pluginName);
				instance = new com.customs.Plugins[pluginName]();
				customPlugins.push(instance);
			}
	
			instance.__meta__ = {
				name: pluginName,
				version: plugin.version || "1.0",
				author: plugin.author || "unknown",
				description: plugin.description || "",
				dependencies: plugin.dependencies || []
			};
	
			if (typeof instance["init"] == "function") {
				trace("Calling init() for plugin: " + pluginName);
				instance.init();
			} else if (typeof instance["run"] == "function") {
				trace("Calling run() for plugin: " + pluginName);
				instance.run();
			}
	
			loaded[plugin.name] = true;
			trace("Successfully loaded plugin: " + pluginName);
		} catch (e:Error) {
			trace("Error instantiating plugin: " + pluginName + " — " + e.toString());
		}
	}

	public function reloadPlugins(newPluginData:Array):Void {
		trace("Reloading plugins...");
		customPlugins = [];
		wildCardPlugins = [];
		pluginMap = {};
		visited = {};
		setPlugins(newPluginData);
	}

	public function loadMultipleConfigs(configs:Array):Void {
		for (var i:Number = 0; i < configs.length; i++) {
			this.loadPluginJSON(configs[i]);
		}
	}

	public function loadPluginJSON(path:String):Void {
		var jsonLoader:LoadVars = new LoadVars();
		var pluginDispenserRef = this;

		jsonLoader.onData = function(rawData:String):Void {
			if (rawData != undefined && rawData.length > 0) {
				var pluginArray:Array = com.clubpenguin.util.JSONParser.parse(rawData);
				pluginDispenserRef.setPlugins(pluginArray);
			} else {
				trace("Error loading plugin JSON from: " + path);
			}
		};

		jsonLoader.load(path);
	}

	public function getCustomPlugins():Array {
		return customPlugins;
	}

	public function getWildCardPlugins():Array {
		return wildCardPlugins;
	}
}
