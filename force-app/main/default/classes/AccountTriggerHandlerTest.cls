@isTest
private class AccountTriggerHandlerTest {
  @TestSetup
  static void makeData() {
    List<Account> accList = new List<Account>();
    for (Integer i = 0; i < 10; i++) {
      accList.add(new Account(Name = 'Test Acc123' + i, BillingCity = 'NY'));
    }
    insert accList;
    List<Contact> contList = new List<Contact>();
    for (Account el : accList) {
      contList.add(
        new Contact(LastName = 'Test Contact123', AccountId = el.id)
      );
    }
    insert contList;
  }

  @isTest
  static void updateAccDescriptionTest() {
    Account testAcc = new Account(Name = 'Test');
    Test.startTest();
    insert testAcc;
    Test.stopTest();
    System.assertEquals(
      'Test Trigger Description',
      [SELECT Description FROM Account WHERE Name = 'Test']
      .Description
    );
  }

  @isTest
  static void updateContHelperFutureTest() {
    List<Account> testAccList = [SELECT Id, BillingCity FROM Account];
    for (Account el : testAccList) {
      el.BillingCity = 'LA';
    }
    Test.startTest();
    update testAccList;
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Is_Synced__c = FALSE]
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Processed_By_Future__c = TRUE]
    );
  }

  @isTest
  static void updateContHelperQueueableTest() {
    List<Contact> testContList = [
      SELECT LastName, Is_Synced__c, Processed_By_Queue__c
      FROM Contact
    ];
    UpdateContactsQueueable updateContJob = new UpdateContactsQueueable(
      testContList
    );
    Test.startTest();
    System.enqueueJob(updateContJob);
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Is_Synced__c = FALSE]
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Processed_By_Queue__c = TRUE]
    );
  }
}
