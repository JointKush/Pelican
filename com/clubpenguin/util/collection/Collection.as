class com.clubpenguin.util.collection.Collection implements com.clubpenguin.util.collection.ICollection
{
    var _itemLookup, _itemType, _itemCount, _totalItemCount, changed, itemsAdded, itemsRemoved;
    function Collection(itemType)
    {
        _itemLookup = {};
        _itemType = itemType;
        _itemCount = 0;
        _totalItemCount = 0;
        changed = new org.osflash.signals.Signal();
        itemsAdded = new org.osflash.signals.Signal(Array);
        itemsRemoved = new org.osflash.signals.Signal(Array);
    } // End of the function
    function destroy(destroyItems)
    {
        for (var _loc2 in _itemLookup)
        {
            if (destroyItems)
            {
                _itemLookup[_loc2].destroy();
            } // end if
            _itemLookup[_loc2] = null;
        } // end of for...in
        _itemCount = 0;
        _itemLookup = {};
    } // End of the function
    function refresh()
    {
        changed.dispatch();
    } // End of the function
    function getType()
    {
        return (_itemType);
    } // End of the function
    function getSize()
    {
        return (_itemCount);
    } // End of the function
    function isEmpty()
    {
        return (_itemCount == 0);
    } // End of the function
    function addItem(item, suppressSignal)
    {
        if (_itemLookup[item.getID()] == null)
        {
            _itemLookup[item.getID()] = item;
            if ((org.osflash.signals.Signal)(_itemLookup[item.getID()].removed))
            {
                (org.osflash.signals.Signal)(_itemLookup[item.getID()].removed).add(onItemRemoved, this);
            } // end if
            ++_itemCount;
        }
        else
        {
            this.updateItem(item);
        } // end else if
        if (suppressSignal != true)
        {
            changed.dispatch();
            itemsAdded.dispatch([item]);
        } // end if
        return (item);
    } // End of the function
    function updateItem(item)
    {
        _itemLookup[item.getID()].update(item);
    } // End of the function
    function onItemRemoved(itemToremove, surpressSignal)
    {
        this.removeItem(itemToremove, false, surpressSignal);
    } // End of the function
    function add(itemsToAdd)
    {
        var _loc4 = [];
        for (var _loc2 = 0; _loc2 < itemsToAdd.length; ++_loc2)
        {
            this.addItem(itemsToAdd[_loc2], true);
            _loc4.push(itemsToAdd[_loc2]);
        } // end of for
        changed.dispatch();
        itemsAdded.dispatch(_loc4);
    } // End of the function
    function removeItem(item, destroyItem, suppressSignal)
    {
        var _loc3 = _itemLookup[item.getID()];
        if (destroyItem)
        {
            item.destroy();
        } // end if
        if (_itemLookup[item.getID()])
        {
            --_itemCount;
        } // end if
        _itemLookup[item.getID()] = null;
        delete _itemLookup[item.getID()];
        if (suppressSignal != true)
        {
            changed.dispatch();
            itemsRemoved.dispatch([item]);
        } // end if
        return (_loc3);
    } // End of the function
    function remove(itemsToRemove, destroyItems)
    {
        var _loc4 = [];
        for (var _loc2 = 0; _loc2 < itemsToRemove.length; ++_loc2)
        {
            _loc4.push(this.removeItem(itemsToRemove[_loc2], destroyItems, true));
        } // end of for
        changed.dispatch();
        itemsRemoved.dispatch([_loc4]);
    } // End of the function
    function clear(destroyItems)
    {
        _itemLookup = {};
    } // End of the function
    function getItems()
    {
        var _loc2 = [];
        for (var _loc3 in _itemLookup)
        {
            if (_itemLookup[_loc3])
            {
                _loc2.push(_itemLookup[_loc3]);
            } // end if
        } // end of for...in
        return (_loc2);
    } // End of the function
    function getItemByID(itemID)
    {
        return (_itemLookup[itemID]);
    } // End of the function
    function toString()
    {
        return ("[Collection] " + _itemType);
    } // End of the function
    function getChanged()
    {
        return (changed);
    } // End of the function
    function getItemsAdded()
    {
        return (itemsAdded);
    } // End of the function
    function getItemsRemoved()
    {
        return (itemsRemoved);
    } // End of the function
    function contains(vo)
    {
        return (this.getItemByID(vo.getID()) != null);
    } // End of the function
    var name = "noname";
} // End of Class
