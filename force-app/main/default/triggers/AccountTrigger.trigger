trigger AccountTrigger on Account (before insert) {
    if (HandlerForOneTimeTriggers.isCallFirstTime()) {
        AccountTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}