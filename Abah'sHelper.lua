AbahsHelper = {}
AbahsHelper.name = "Abah'sHelper"

local function Print(message)
    d("[Abah's Helper] " .. message)
end

-- Addon Initialization
function AbahsHelper.OnAddOnLoaded(eventCode, addonName)
    if addonName ~= AbahsHelper.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(AbahsHelper.name, EVENT_ADD_ON_LOADED)
    EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_QUEST_OFFERED, AbahsHelper.OnQuestOffered)
    EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_CHATTER_BEGIN, AbahsHelper.OnChatterBegin)
end

-- Quest offered callback
-- Listens for all quest offerings and checks for Tip Board interaction
function AbahsHelper.OnQuestOffered(eventCode)
    Print("OnQuestOffered")
    if AbahsHelper:IsTipBoard(GetRawUnitName('interact')) then
        EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_QUEST_ADDED, AbahsHelper.OnQuestAdded)
        AcceptOfferedQuest()
    end
end

-- Quest added callback
-- Checks if the quest we are looking for was added
function AbahsHelper.OnQuestAdded(eventCode, journalIndex, questName, objectiveName)
    Print("OnQuestAdded")
    if AbahsHelper:IsCorrectQuest(questName) then
        Print("Got the quest.")
    elseif AbahsHelper:IsWrongQuest(questName) then
        Print("Got wrong quest. Abandoning...")
        AbandonQuest(journalIndex)
    end
end

-- Chatter begin callback
-- Either chatter with Countress or Kari
function AbahsHelper.OnChatterBegin(eventCode, optionCount)
    Print("OnChatterBegin")
    if AbahsHelper:IsCountess(GetRawUnitName('interact')) then
        Print("It's Countess!")
        EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_CONVERSATION_UPDATED, AbahsHelper.OnConversationUpdated)
    elseif AbahsHelper:IsKari(GetRawUnitName('interact')) then
        Print("It's Kari!")
        EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_QUEST_COMPLETE_DIALOG, AbahsHelper.OnQuestCompleteDialog)
    else
        Print("It's someone else...")
        return
    end
    SelectChatterOption(1)
end

-- Coversation updated callback
-- Second conversation window with Countess
function AbahsHelper.OnConversationUpdated(eventCode, ...)
    Print("OnConversationUpdated")
    if AbahsHelper:IsCountess(GetRawUnitName('interact')) then
        CloseChatter()
        EVENT_MANAGER:UnregisterForEvent(AbahsHelper.name, EVENT_CONVERSATION_UPDATED)
    end
end

-- Quest complete dialog callback
-- Completion dialog with Kari
function AbahsHelper.OnQuestCompleteDialog(eventCode, ...)
    Print("OnQuestCompleteDialog")
    if AbahsHelper:IsKari(GetRawUnitName('interact')) then
        EVENT_MANAGER:UnregisterForEvent(AbahsHelper.name, EVENT_QUEST_COMPLETE_DIALOG)
        CompleteQuest()
    end
end

-- Helper functions
function AbahsHelper:IsCorrectQuest(questName)
    return questName == "The Covetous Countess"
end

function AbahsHelper:IsWrongQuest(questName)
    return questName == "Idle Hands" or questName == "Crime Spree" or questName == "Plucking Fingers" or questName == "Under Our Thumb" 
end

function AbahsHelper:IsTipBoard(interactName)
    return interactName == "Tip Board"
end

function AbahsHelper:IsCountess(interactName)
    return interactName == "Countess Viatrix Celata^F"
end

function AbahsHelper:IsKari(interactName)
    return interactName == "Kari^F"
end

EVENT_MANAGER:RegisterForEvent(AbahsHelper.name, EVENT_ADD_ON_LOADED, AbahsHelper.OnAddOnLoaded)