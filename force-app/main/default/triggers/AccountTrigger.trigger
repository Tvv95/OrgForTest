trigger AccountTrigger on Account(before insert, after update, after insert) {
  if (Trigger.isBefore && Trigger.isInsert) {
    AccountTriggerHandler.handleBeforeInsert(Trigger.new);
  }
  if (Trigger.isAfter && Trigger.isInsert) {
    AccountTriggerHandler.handleAfterInsert(Trigger.newMap.keySet());
  }
  if (Trigger.isAfter && Trigger.isUpdate) {
    AccountTriggerHandler.handleAfterUpdate(
      Trigger.new,
      Trigger.old
    );
  }
}
