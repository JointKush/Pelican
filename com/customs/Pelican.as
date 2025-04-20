class com.customs.Pelican {

    static var _shell, _interface, _airtower, _engine, _server, pluginDispenser, customServices, stageReference;
    var __get__client;

    public function Pelican(_stage) {
        super(_stage);
        stageReference = _stage;
        trace("Pelican - [Dependencies Manager Loaded]");

        this.__get__client(); 
        loadCustomServices();
        loadPlugins(); 
    }

	public function loadPlugins():Void {
		var lv:LoadVars = new LoadVars();
		var self = this;
	
		lv.onData = function(raw:String) {
			if (raw != undefined) {
				var plugins:Array = self.parseJSON(raw);
				self.pluginDispenser = new com.customs.Plugins.pluginDispenser(plugins);
				self.initializePlugins();
			} else {
				trace("Failed to load pluginsConfig.json");
			}
		};
	
		lv.load("json/pluginsConfig.json");
	}
	public function parseJSON(jsonStr:String):Array {
		var result:Array = [];
	
		if (jsonStr != null && jsonStr != "") {
        	jsonStr = jsonStr.split(" ").join("").split("\n").join("").split("\r").join("");
	
			if (jsonStr.charAt(0) == "[" && jsonStr.charAt(jsonStr.length - 1) == "]") {
				jsonStr = jsonStr.substring(1, jsonStr.length - 1);
	
				var elements:Array = jsonStr.split(",");
	
				for (var i:Number = 0; i < elements.length; i++) {
					result.push(elements[i]); 
				}
			} else {
				trace("Invalid JSON format: Not an array.");
			}
		} else {
			trace("Error: Invalid JSON string.");
		}
	
		return result;
	}


    public function loadCustomServices() {
        var servicesManager = new com.customs.Net.CustomServicesManager();
        setCustomServices(servicesManager);
        servicesManager.addEventListener(com.customs.Net.CustomServicesManager.EVENT_INIT_COMPLETE, customServicesInitComplete, this);
        servicesManager.loadCustomServices();
    }

    public function setCustomServices(services) {
        customServices = services;
    }

    public function getCustomServices() {
        return customServices;
    }

    public function customServicesInitComplete() {
        var services = getCustomServices();
        
        _shell.setEmoteData(services.getServiceData("EMOTE"));
        _shell.setNPCData(services.getServiceData("NPC"));
        _shell.setCustomItemsData(services.getServiceData("CUSTOM_ITEMS"));
        _shell.setRoomPinData(services.getServiceData("ROOM_PIN"));
        _shell.setPartyData(services.getServiceData("PARTIES"));
    }

    public function initializePlugins():Void {
        var plugins:Array = pluginDispenser.getCustomPlugins();
        for (var i:Number = 0; i < plugins.length; i++) {
            var plugin:Object = plugins[i];
            if (plugin.metadata.dependencies.length == 0 || areDependenciesMet(plugin.metadata.dependencies)) {
             
                trace("Plugin " + plugin.metadata.name + " is ready.");
                plugin.initialize(); 
            } else {
                trace("Plugin " + plugin.metadata.name + " is waiting for dependencies.");
            }
        }
    }

    public function areDependenciesMet(dependencies:Array):Boolean {
        for (var i:Number = 0; i < dependencies.length; i++) {
            if (!isPluginReady(dependencies[i])) {
                return false; 
            }
        }
        return true;
    }

    public function isPluginReady(pluginName:String):Boolean {
        var plugin:Object = pluginDispenser.getCustomPlugins().find(function(p:Object):Boolean {
            return p.metadata.name == pluginName;
        });
        return plugin != undefined && plugin.status == "ready"; 

    public function stringify(obj) {
        return com.clubpenguin.util.JSONParser.stringify(obj);
    }

    public function callExt(func, arg) {
        return flash.external.ExternalInterface.call(func, arg);
    }

    public function get client() {
        _shell = _global.getCurrentShell();
        _interface = _global.getCurrentInterface();
        _airtower = _global.getCurrentAirtower();
        _engine = _global.getCurrentEngine();
        _server = _global.getServerConfiguration();
    }
}
