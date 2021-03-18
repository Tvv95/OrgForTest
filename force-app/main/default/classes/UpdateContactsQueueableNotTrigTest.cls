@isTest
private class UpdateContactsQueueableNotTrigTest {
    @TestSetup
    static void makeData() {
      Account acc = new Account(Name = 'Test Acc321', BillingCity = 'NY');
      insert acc;
      Contact cont = new Contact(
        LastName = 'Test Contact321',
        AccountId = acc.id
      );
      insert cont;
    }
  
    @isTest
    static void testUpdateContQueNotTrig() {
      List<Account> testAccList = [
        SELECT Name, BillingAddress
        FROM Account
        WHERE Name = 'Test Acc321'
      ];
      UpdateContactsQueueableNotTrig updateContJob = new UpdateContactsQueueableNotTrig(testAccList);
      Test.startTest();
      System.enqueueJob(updateContJob);
      Test.stopTest();
      Contact resultCont = [
        SELECT LastName, Is_Synced__c, Processed_By_Queue__c
        FROM Contact
        WHERE LastName = 'Test Contact321'
      ];
      System.assertEquals(false, resultCont.Is_Synced__c);
      System.assertEquals(true, resultCont.Processed_By_Queue__c);
    }
}
