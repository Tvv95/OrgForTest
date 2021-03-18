@isTest
private class TaskForAccTest {
    @isTest
    static void createTaskForAccTest() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
          accList.add(new Account(Name = 'Test Acc' + i));
        }
        Test.startTest();
        insert accList;
        Test.stopTest();
        System.assertEquals(10, [SELECT COUNT() FROM Task WHERE Is_Synced__c=false]);
    }

    @isTest static void updateUserForTasksTest() {
      Account testAcc = new Account(Name = 'Test Acc');
      insert testAcc;

      List<Task> taskList = new List<Task>();
      for (Account acc : [SELECT Id FROM Account]) {
        taskList.add(new Task(Subject='TEST123', WhatId=acc.id, OwnerId='00509000003vb2AAAQ'));
        taskList.add(new Task(Subject='TEST123', WhatId=acc.id, OwnerId='005090000046FwEAAU'));
        taskList.add(new Task(Subject='TEST123', WhatId=acc.id, OwnerId='005090000046FwEAAU'));
        taskList.add(new Task(Subject='TEST123', WhatId=acc.id, OwnerId='00509000003vb2AAAQ'));
      }
      insert taskList;
      Account accToUpdate = [SELECT Name FROM Account LIMIT 1];
      accToUpdate.Name = 'Test Update';
      Test.startTest();
      update accToUpdate;
      Test.stopTest();
      Set<Id> usersIdSet = new Set<Id>();
      for (Task el : [SELECT OwnerId FROM Task WHERE Subject='TEST123']) {
        usersIdSet.add(el.OwnerId);
      }
      System.assertEquals(1, usersIdSet.size());
    }
}
