public inherited sharing class AccountTriggerHandler {
  public static void handleBeforeInsert(List<Account> accList) {
    AccountHelper.updateAccDescription(accList);
  }

  public static void handleAfterInsert(Set<Id> newAccIdList) {
    TaskForAcc.createTaskForAcc(newAccIdList);
  }

  public static void handleAfterUpdate(
    List<Account> newAccList,
    List<Account> oldAccList
  ) {
    TaskForAcc.updateUserForTasks(newAccList);
    List<Id> contactsToUpdateId = AccountHelper.getNeedtoUpdateAccsId(
      newAccList,
      oldAccList
    );
    if (contactsToUpdateId.size() != 0) {
      AccountHelper.updateContHelperFuture(contactsToUpdateId);
      AccountHelper.updateContHelperQueueable(contactsToUpdateId);
    }
  }
}
