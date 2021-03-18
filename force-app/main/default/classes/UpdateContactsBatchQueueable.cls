public class UpdateContactsBatchQueueable implements Database.Batchable<SObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT Is_Synced__c, AccountId ' +
      'FROM Contact ' +
      'WHERE Is_Synced__c = false'
    );
  }

  public void execute(Database.BatchableContext bc, List<Contact> scope) {
    List<Id> idAccList = new List<Id>();
    for (Contact el : scope) {
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
    for (Contact el : scope) {
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
    update scope;
    update accList;
  }
  public void finish(Database.BatchableContext bc) {
  }
}
