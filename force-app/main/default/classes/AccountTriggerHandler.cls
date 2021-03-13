public inherited sharing class AccountTriggerHandler {
  public static void handleBeforeInsert(List<Account> newList) {
    if (HandlerForOneTimeTriggers.isCallFirstTime()) {
      for (Account a : newList) {
        a.Description = 'Test Trigger Description';
      }
    }
  }
}
