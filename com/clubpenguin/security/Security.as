class com.clubpenguin.security.Security {
    function Security() {
		
    } 
    static function doSecurityCheck($stageURL, $stageParent) {
         com.clubpenguin.security.Security.allowDomains();
         com.clubpenguin.security.Security.checkDomain($stageURL, $stageParent);
    } 
    static function checkDomain($stageURL, $stageParent) {
        var _loc2 = false;
        if ($stageURL.substr(0, 4) == "http") {
            var _loc4 = new Array();
            _loc4 = $stageURL.split("/");
            var _loc3 = "localhost";
            if (_loc4[2].substr(-_loc3.length) == _loc3) {
                _loc2 = true;
            } 
        } 
        if ($stageParent == undefined) {
            _loc2 = false;
        } 
        if (_loc2) {
            _root.loadMovie();
        } 
    } 
    static function allowDomains() {
        var _loc2 =  com.clubpenguin.security.Domains.getAllowedDomains();
        var _loc1 = 0;
        var _loc3 = _loc2.length;
        while (_loc1 < _loc3) {
            System.security.allowDomain(_loc2[_loc1]);
            ++_loc1;
        } 
    }
} 
