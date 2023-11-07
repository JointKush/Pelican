class com.clubpenguin.util.JSONLoader extends com.clubpenguin.util.EventDispatcher
{
    var loadVars, updateListeners;
    function JSONLoader()
    {
        super();
    } // End of the function
    function load(url)
    {
        raw = "";
        data = null;
        loadVars = new LoadVars();
        loadVars.onData = com.clubpenguin.util.Delegate.create(this, onData);
        loadVars.load(url);
    } // End of the function
    function onData(jsonText)
    {
        if (jsonText == undefined)
        {
            this.updateListeners(com.clubpenguin.util.JSONLoader.FAIL);
            return;
        } // end if
        try
        {
            raw = jsonText;
            data = com.clubpenguin.util.JSONParser.parse(jsonText);
            this.updateListeners(com.clubpenguin.util.JSONLoader.COMPLETE);
        } // End of try
        catch (ex)
        {
            this.updateListeners(com.clubpenguin.util.JSONLoader.FAIL);
        } // End of catch
    } // End of the function
    function toString()
    {
        return ("[JSONLoader]");
    } // End of the function
    static var COMPLETE = "complete";
    static var FAIL = "fail";
    static var CLASS_NAME = "com.clubpenguin.util.JSONLoader";
    var raw = "";
    var data = null;
} // End of Class
