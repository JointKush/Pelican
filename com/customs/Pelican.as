class com.customs.Pelican extends com.customs.Settings {
	
	static var _shell, _interface, _airtower, _engine, _server, pluginDispenser, custom_services, stageReference;
	var __get__client;
	public function Pelican (_stage) {
		super(_stage);
		stageReference = _stage;
		trace("Pelican - [Dependendencies Manager Loaded]");
		this.__get__client();
		loadCustomServices();
		pluginDispenser = new com.customs.Plugins.pluginDispenser(plugins);
	}
	public function loadCustomServices() {
		var _loc1 = new com.customs.Net.CustomServicesManager();
		setCustomServices(_loc1);
		_loc1.addEventListener(com.customs.Net.CustomServicesManager.EVENT_INIT_COMPLETE, customServicesInitComplete, this);
		_loc1.loadCustomServices();
	}
	public function setCustomServices(services) {
		custom_services = services;
	}
	public function getCustomServices () {
		return (custom_services);
	}
	public function customServicesInitComplete() {
		var _loc2 = getCustomServices();
		_shell.setEmoteData(_loc2.getServiceData("EMOTE"));
		_shell.setNPCData(_loc2.getServiceData("NPC"));
	    _shell.setCustomItemsData(_loc2.getServiceData("CUSTOM_ITEMS"));
		_shell.setRoomPinData(_loc2.getServiceData("ROOM_PIN"));
	} 
	public function stringify(obj) {
		return (com.clubpenguin.util.JSONParser.stringify(obj));
	}
	public function call_ext(func, arg) {
		return (flash.external.ExternalInterface.call(func, arg));
	}
	public function get client() {
		_shell = _global.getCurrentShell();
		_interface = _global.getCurrentInterface();
		_airtower = _global.getCurrentAirtower();
		_engine = _global.getCurrentEngine();
		_server = _global.getServerConfiguration();
	}

}
