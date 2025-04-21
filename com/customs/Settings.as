class com.customs.Settings {
    
    /**
     * Settings class manages plugins and configuration.
     * You can load plugins from sub-folders by flagging them with "wildCard" and setting the folder name between ".".
     */
    
    public function Settings() {}

    static var localPath: String = "http://localhost/";
	
	static var allowPlugins:Array = [
        com.customs.Plugins.PartySwitcher
    ];

    static var customServices:Object = {
        EMOTE: "emote_frames",
        NPC: "npc",
        CUSTOM_ITEMS: "custom_items",
        ROOM_PIN: "room_pin",
        PARTIES: "parties"
    };

}
