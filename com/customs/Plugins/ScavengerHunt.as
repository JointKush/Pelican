class com.customs.Plugins.ScavengerHunt {
	
	static var INTERFACE, SHELL;
	public function ScavengerHunt () {
		trace("Scavanger Hunt Plugin Loaded");
		INTERFACE = com.customs.Pelican._interface;
		SHELL = com.customs.Pelican._shell;
		this.overrideFunc();

	}
	
	public function overrideFunc() : Void {
		INTERFACE.updateScavengerView = updateScavengerView;
		INTERFACE.makeScavengeMessage = makeScavengeMessage;
		INTERFACE.setupScavengerHuntWindow = setupScavengerHuntWindow;
		INTERFACE.claimScavPrize = claimScavPrize;
		INTERFACE.showScavHint = showScavHint;
		INTERFACE.SCAV_ITEM_ID = 331;
		INTERFACE.SCAV_PRIZE_ID = 9006;
		SHELL.GLOBAL_CRUMBS.global_path.extra_interface_icons =  SHELL.getGlobalContentPath() + "scavenger_hunt/scavenger_hunt_icon.swf";
		SHELL.GLOBAL_CRUMBS.global_path.scavenger_hunt_ui =  SHELL.getGlobalContentPath() + "scavenger_hunt/scavenger_hunt_ui.swf";
		SHELL.GLOBAL_CRUMBS.global_path.halloween_hunt =  SHELL.getGlobalContentPath() + "scavenger_hunt/scavenger_hunt_ui.swf"; //Rooms sends `halloween_hunt` when candy is found
		SHELL.LOCAL_CRUMBS.lang.scavenger_title = "Halloween Candy Hunt";
		SHELL.LOCAL_CRUMBS.lang.scavenger_claim_prize = "Claim Prize";
		SHELL.LOCAL_CRUMBS.lang.scavenger_continue = "Continue";
		SHELL.LOCAL_CRUMBS.lang.scavenger_error = "Before you begin the Halloween Candy Hunt, you need to get a basket to hold all of your candy! Once you've found the basket, click the pumpkin again to start the scavenger hunt!";
		SHELL.LOCAL_CRUMBS.lang.scavenger_items_found = "You have found %num% treat";
		SHELL.LOCAL_CRUMBS.lang.scavenger_items_found_plural = "You have found %num% treats";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue0 = "Here’s a treat you can try\n\n When you lower the flag";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue1 = "This candy treat is out of Sight\n\n Above the dancing, in the light";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue2 = "Beside Three Candles lit aflame, inside a blue box by a competitive game";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue3 = "Bubble Bubble Toil and Trouble\n\n We'll have candy stew on the double";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue4 = "This Treat can Swim just Fine,\n\n but then it read the warning sign";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue5 = "We'll see this candy from afar,\n\n amongst the colors in the sky";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue6 = "On a tower way up high,\n\n wait for three flashes in the sky";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue7 = "Find this treat in a book to end the game. What's the secret of the emerald flame?";
		SHELL.LOCAL_CRUMBS.lang.scavenger_clue8 = "Congraulations! You have found all the treats, now just claim your prize!";
	}
	
	public function setupScavengerHuntWindow(mc) {
		this.updateScavengerView(mc);
		if(!SHELL.isItemInMyInventory(INTERFACE.SCAV_ITEM_ID) && INTERFACE.SCAV_ITEM_ID !== 0) {
			mc.gotoAndStop(2);
			mc.content.message_txt.text = SHELL.getLocalizedString("scavenger_error");
		}

		mc.content.title_txt.text = SHELL.getLocalizedString("scavenger_title").toUpperCase();
		mc.content.claim_mc.claimTextHolder.claim_txt.text = SHELL.getLocalizedString("scavenger_claim_prize");
        mc.content.continue_mc.continueTextHolder.continue_txt.text = SHELL.getLocalizedString("scavenger_continue");

	}
	public function updateScavengerView(mc) {
		var _loc1 = SHELL.getHuntCrumbs();
		var _loc3 = 0;
		var firstUnfoundItem = undefined;
		for (var _loc2 in _loc1) {
			if (_loc1[_loc2].is_found) {
				mc.content["item" + _loc1[_loc2].id].gotoAndStop(2);
				++_loc3;
			} 
			mc.content["item" + _loc2].onRelease = com.clubpenguin.util.Delegate.create(this, showScavHint, _loc2, mc);
		} 
		if (firstUnfoundItem == undefined) {
			firstUnfoundItem = _loc3;
			this.showScavHint(firstUnfoundItem, mc);
		}
        if (!firstUnfoundItem) {
            firstUnfoundItem = 0;
            this.showScavHint(firstUnfoundItem, mc);
        }
		if (_loc3 == 8) {
            mc.content.claim_mc.gotoAndStop("show");
            mc.content.continue_mc.gotoAndStop("hide");
            mc.content.claim_mc.claim_btn.onRelease = com.clubpenguin.util.Delegate.create(this, claimScavPrize);
			//Send the Scav stamp here if needed
        } else {
            mc.content.claim_mc.gotoAndStop("hide");
            mc.content.continue_mc.gotoAndStop("show");
            mc.content.continue_mc.continue_btn.onRelease = com.clubpenguin.util.Delegate.create(this, INTERFACE.closeContent);
        } 
		this.makeScavengeMessage(mc, _loc3);
	}	
	public function claimScavPrize() {
		INTERFACE.buyInventory(INTERFACE.SCAV_PRIZE_ID);
	}
	public function showScavHint(itemID, mc) {
        var _loc2 = "scavenger_clue" + itemID;
        mc.content.clue_mc.clue_txt.text = SHELL.getLocalizedString(_loc2).toUpperCase();
    }
	public function makeScavengeMessage(mc, txt) {
		if (txt == 0) {
			mc.content.message_txt.text = com.clubpenguin.util.StringUtils.replaceString("%num%", String(txt), SHELL.getLocalizedString("scavenger_items_found"));
		} else if (txt !== 1) {
			mc.content.message_txt.text = com.clubpenguin.util.StringUtils.replaceString("%num%", String(txt), SHELL.getLocalizedString("scavenger_items_found_plural"));
		} else {
			mc.content.message_txt.text = com.clubpenguin.util.StringUtils.replaceString("%num%", String(txt), SHELL.getLocalizedString("scavenger_items_found"));
		}
	 }
}