public class UpdateContactsBatchIterable implements Database.Batchable<Contact> {
  public Iterable<Contact> start(Database.BatchableContext bc) {
    List<Contact> contactList = [
      SELECT Is_Synced__c, AccountId
      FROM Contact
      WHERE Is_Synced__c = FALSE
    ];
    return contactList;
  }
  public void execute(Database.BatchableContext bc, List<Contact> contList) {
    List<Id> idAccList = new List<Id>();
    for (Contact el : contList) {
      idAccList.add(el.AccountId);
    }
    Map<Id, Account> mapAccs = new Map<Id, Account>(
      [
        SELECT
          Id,
          Updated_By_Contact__c,
          BillingStreet,
          BillingCity,
          BillingState,
          BillingPostalCode,
          BillingCountry
        FROM Account
        WHERE Id IN :idAccList
      ]
    );
    for (Contact el : contList) {
      el.MailingStreet = mapAccs.get(el.AccountId).BillingStreet;
      el.MailingCity = mapAccs.get(el.AccountId).BillingCity;
      el.MailingState = mapAccs.get(el.AccountId).BillingState;
      el.MailingPostalCode = mapAccs.get(el.AccountId).BillingPostalCode;
      el.MailingCountry = mapAccs.get(el.AccountId).BillingCountry;
      el.Is_Synced__c = true;
    }
    List<Account> accList = [
      SELECT Id, Updated_By_Contact__c
      FROM Account
      WHERE Id IN :idAccList
    ];
    for (Account el : accList) {
      el.Updated_By_Contact__c = true;
    }
    update contList;
    update accList;
  }
  public void finish(Database.BatchableContext bc) {
  }
}
