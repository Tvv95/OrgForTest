public class UpdateContactsFuture {
  @future
  public static void updateContacts() {
    List<Account> accList = [SELECT Id, BillingAddress FROM Account LIMIT 150];
    List<Id> accIdListWithBillAdr = new List<Id>();
    for (Account el : accList) {
      if (el.BillingAddress != null) {
        accIdListWithBillAdr.add(el.Id);
      }
    }
    List<Contact> contList = [
      SELECT AccountId, Is_Synced__c, Processed_By_Future__c
      FROM Contact
      WHERE AccountId IN :accIdListWithBillAdr
    ];
    for (Contact el : contList) {
      el.Is_Synced__c = false;
      el.Processed_By_Future__c = true;
    }
    update contList;
  }
}
