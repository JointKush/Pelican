class com.customs.Net.CustomServicesManager extends com.clubpenguin.util.EventDispatcher {

    var SHELL, customServices, servicesObj, serviceTypeArr, jsonLoader, dispatchEvent, serviceTypes, __get__serviceType, arrServicesToLoad, _loadingServiceType;
    public function CustomServicesManager() {
        super();
		SHELL = com.customs.Pelican._shell;
		servicesObj = {};
        customServices = com.customs.Settings.customServices;
    }

    public function get serviceType() {
        serviceTypeArr = [];
        for (var i in customServices) {
            serviceTypeArr.push(i);
        }
        return (serviceTypeArr);
    }

    public function serviceTypeVal(val) {
        for (var i in customServices) {
            if (i === val) {
                return (customServices[i]);
            }
        }
    }
	public function getServiceData(type) {
        var typeData = servicesObj[type];
        return (typeData);
    }
	
    public function loadCustomServices() {
        arrServicesToLoad = this.__get__serviceType();
		trace("Loaded Custom Services Manager " + "[" + arrServicesToLoad.length + "]");
        jsonLoader = new com.clubpenguin.util.JSONLoader();
        jsonLoader.addEventListener(com.clubpenguin.util.JSONLoader.COMPLETE, onCustomServicesJSONLoaded, this);
        loadOngoingServices();
    }

    public function loadOngoingServices() {
        if (arrServicesToLoad.length === 0) {
			jsonLoader.removeEventListener(com.clubpenguin.util.JSONLoader.COMPLETE, onCustomServicesJSONLoaded, this);
			 dispatchEvent({
                type: EVENT_INIT_COMPLETE,
                target: this
            });
            return (undefined);
		}
        _loadingServiceType = arrServicesToLoad.shift();
        serviceTypes = _loadingServiceType;
        jsonLoader.load(SHELL.getClientPath() + "json/" + serviceTypeVal(serviceTypes) + ".json");
    }

    public function onCustomServicesJSONLoaded(event) {
        var _local2 = jsonLoader.data;
        servicesObj[serviceTypes] = _local2;
        loadOngoingServices();
		
    }
	static var EVENT_INIT_COMPLETE = "initComplete";
}