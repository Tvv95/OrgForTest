@isTest
private class UpdateContactsFutureTest {
  @isTest
  static void updateContactsFutureTest() {
    List<Account> accList = new List<Account>();
    for (Integer i = 0; i < 10; i++) {
      accList.add(new Account(Name = 'AccForTest' + i, BillingCity = 'NY'));
    }
    insert accList;
    List<Contact> contList = new List<Contact>();
    for (Account el : accList) {
      contList.add(new Contact(LastName = 'Test', AccountId = el.Id));
    }
    insert contList;
    Test.startTest();
    UpdateContactsFuture.updateContacts();
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM CONTACT WHERE Is_Synced__c = FALSE]
    );
    System.assertEquals(
      10,
      [SELECT COUNT() FROM CONTACT WHERE Processed_By_Future__c = TRUE]
    );
  }
}
