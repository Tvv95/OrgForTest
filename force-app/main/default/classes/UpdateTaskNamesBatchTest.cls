@isTest
private class UpdateTaskNamesBatchTest {
  @testSetup
  static void makeData() {
    List<Account> accList = new List<Account>();
    List<Task> taskList = new List<Task>();
    for (Integer i = 0; i < 10; i++) {
      accList.add(new Account(Name = 'AccTest' + i));
    }
    insert accList;
    for (Account el : accList) {
      taskList.add(
        new Task(Subject = 'Test Task', WhatId = el.Id, Is_Synced__c = false));
    }
    insert taskList;
  }

  @isTest
  static void test() {
    Test.startTest();
    UpdateTaskNamesBatch inst = new UpdateTaskNamesBatch();
    Id batchId = Database.executeBatch(inst);
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Task WHERE Is_Synced__c = true AND Subject='Test Task']
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Account WHERE Updated_By_Task__c = TRUE]
    );
  }
}
