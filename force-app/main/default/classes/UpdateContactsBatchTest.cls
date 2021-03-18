@isTest
private class UpdateContactsBatchTest {
  @TestSetup
  static void makeData() {
    List<Account> accList = new List<Account>();
    List<Contact> contList = new List<Contact>();
    for (Integer i = 0; i < 10; i++) {
      accList.add(new Account(Name = 'AccTest' + i, BillingCity = 'NY'));
    }
    insert accList;
    for (Account el : accList) {
      contList.add(
        new Contact(
          LastName = 'TestName',
          AccountId = el.id,
          Is_Synced__c = false
        )
      );
    }
    insert contList;
  }

  @isTest
  static void testQueueable() {
    Test.startTest();
    UpdateContactsBatchQueueable inst = new UpdateContactsBatchQueueable();
    Id batchId = Database.executeBatch(inst);
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE MailingCity = 'NY']
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Is_Synced__c = TRUE]
    );
    System.assertEquals(
      0,
      [SELECT COUNT() FROM Contact WHERE Processed_By_Queue__c = TRUE]
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Account WHERE Updated_By_Contact__c = TRUE]
    );
  }

  @isTest
  static void testIterable() {
    Test.startTest();
    UpdateContactsBatchIterable inst = new UpdateContactsBatchIterable();
    Id batchId = Database.executeBatch(inst);
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE MailingCity = 'NY']
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Contact WHERE Is_Synced__c = TRUE]
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM Account WHERE Updated_By_Contact__c = TRUE]
    );
  }
}
