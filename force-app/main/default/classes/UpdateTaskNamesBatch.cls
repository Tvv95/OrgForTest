public class UpdateTaskNamesBatch implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT Is_Synced__c, Account_Owner__c, WhatId ' +
      'FROM Task ' +
      'WHERE Is_Synced__c = false'
    );
  }

  public void execute(Database.BatchableContext bc, List<Task> scope) {
    Set<Id> accIdSet = new Set<Id>();
    for (Task el : scope) {
      accIdSet.add(el.WhatId);
    }
    List<Account> accList = [
      SELECT ID, Account.Owner.Name, Updated_By_Task__c
      FROM Account
      WHERE ID IN :accIdSet
    ];
    Map<Id, Account> accMap = new Map<Id, Account>(accList);

    for (Task el : scope) {
      el.Account_Owner__c = accMap.get(el.WhatId).Owner.Name;
      el.Is_Synced__c = true;
    }
    for (Account el : accList) {
      el.Updated_By_Task__c = true;
    }
    update scope;
    update accList;
  }
  public void finish(Database.BatchableContext bc) {
  }
}
