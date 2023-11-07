class com.clubpenguin.security.Domains {
    static var allowedDomains;
    function Domains() {
		
    } 
    static function getAllowedDomains() {
        if ( com.clubpenguin.security.Domains.allowedDomains == undefined)  {
             com.clubpenguin.security.Domains.initialiseDomainList();
        }
        return (com.clubpenguin.security.Domains.allowedDomains);
    } 
    static function initialiseDomainList() {
        allowedDomains = new Array(); 
        com.clubpenguin.security.Domains.allowedDomains.push("*");
		com.clubpenguin.security.Domains.allowedDomains.push("localhost");
    } 
} 
