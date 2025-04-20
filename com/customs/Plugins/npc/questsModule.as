class com.customs.Plugins.npc.questModule {
    var quests = {}; // Stores all quests by questId
    var playerQuestProgress = {}; // Stores player quest progress

    public function questModule() {
        trace("questModule V1.1 initialized.");
    }

    // Add a quest with multiple stages
    public function addQuest(questId, title, description, stages, rewardCoins, rewardItems) {
        quests[questId] = {
            id: questId,
            title: title,
            description: description,
            stages: stages, // Array of stages, each stage can have its own objectives
            progress: {}, // Stores player progress
            rewardCoins: rewardCoins,
            rewardItems: rewardItems
        };
        trace("Quest added: " + title);
    }

    // Accept a quest by player
    public function acceptQuest(playerId, questId) {
        if (quests[questId]) {
            quests[questId].progress[playerId] = {
                currentStage: 0, // Track the current stage the player is on
                completedObjectives: [],
                status: "ongoing"
            };
            trace("Player " + playerId + " accepted quest: " + quests[questId].title);
        } else {
            trace("Quest " + questId + " not found.");
        }
    }

    // Complete an objective for a quest
    public function completeObjective(playerId, questId, objective) {
        if (quests[questId] && quests[questId].progress[playerId]) {
            var progress = quests[questId].progress[playerId];
            if (progress.completedObjectives.indexOf(objective) === -1) {
                progress.completedObjectives.push(objective);
                trace("Player " + playerId + " completed objective: " + objective);
                checkQuestStageCompletion(playerId, questId);
            } else {
                trace("Objective " + objective + " already completed.");
            }
        }
    }

    // Check if a stage of the quest is completed
    public function checkQuestStageCompletion(playerId, questId) {
        var progress = quests[questId].progress[playerId];
        var currentStage = quests[questId].stages[progress.currentStage];

        if (progress.completedObjectives.length === currentStage.objectives.length) {
            trace("Player " + playerId + " has completed stage " + progress.currentStage + " of quest: " + quests[questId].title);
            progress.currentStage++;
            if (progress.currentStage === quests[questId].stages.length) {
                // Quest is completed
                progress.status = "completed";
                giveReward(playerId, questId);
            }
        }
    }

    // Give reward (coins, items) to the player
    public function giveReward(playerId, questId) {
        var rewardCoins = quests[questId].rewardCoins;
        var rewardItems = quests[questId].rewardItems;
        trace("Player " + playerId + " has completed the quest '" + quests[questId].title + "' and received: " + rewardCoins + " coins and items: " + rewardItems);

        // Assuming there's an interface to give rewards:
        SHELL.addCoinsToPlayer(playerId, rewardCoins);
        SHELL.addItemsToPlayer(playerId, rewardItems);
    }

    // Get Quest Information
    public function getQuestInfo(questId) {
        return quests[questId];
    }

    // Get Player's Progress on a specific quest
    public function getPlayerProgress(playerId, questId) {
        return quests[questId] ? quests[questId].progress[playerId] : null;
    }
}
