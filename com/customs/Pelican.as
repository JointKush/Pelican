class com.customs.Pelican {

    static var _shell, _interface, _airtower, _engine, _server, pluginDispenser, customServices, stageReference;
    var __get__client;


    public function Pelican(_stage) {
        super(_stage);
        stageReference = _stage;
        trace("Pelican - [Dependencies Manager Loaded]");
        this.__get__client();
        loadCustomServices();

        pluginDispenser = new com.customs.Plugins.pluginDispenser([]);
        pluginDispenser.loadPluginJSON("json/pluginsConfig.json");
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
