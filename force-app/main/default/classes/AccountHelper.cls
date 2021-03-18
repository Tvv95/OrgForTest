public with sharing class AccountHelper {
  public static void updateAccDescription(List<Account> accList) {
    if (HandlerForOneTimeTriggers.isCallFirstTime()) {
      for (Account a : accList) {
        a.Description = 'Test Trigger Description';
      }
    }
  }

  public static List<Id> getNeedtoUpdateAccsId(
    List<Account> newAccList,
    List<Account> oldAccList
  ) {
    List<Id> updatedAccsId = new List<Id>();
    for (Integer i = 0; i < newAccList.size(); i++) {
      if (
        newAccList[i].BillingStreet != oldAccList[i].BillingStreet ||
        newAccList[i].BillingCity != oldAccList[i].BillingCity ||
        newAccList[i].BillingState != oldAccList[i].BillingState ||
        newAccList[i].BillingPostalCode != oldAccList[i].BillingPostalCode ||
        newAccList[i].BillingCountry != oldAccList[i].BillingCountry
      ) {
        updatedAccsId.add(newAccList[i].Id);
      }
    }
    List<Contact> resultContact = [
      SELECT Id, AccountId
      FROM Contact
      WHERE AccountId IN :updatedAccsId
    ];
    List<Id> resultIdContacts = new List<Id>();
    for (Contact el : resultContact) {
      resultIdContacts.add(el.id);
    }
    return resultIdContacts;
  }

  @future
  public static void updateContHelperFuture(List<Id> contIdList) {
    List<Contact> contList = [SELECT Id FROM CONTACT WHERE Id IN :contIdList];
    for (Contact cont : contList) {
      cont.Is_Synced__c = false;
      cont.Processed_By_Future__c = true;
    }
    update contList;
  }

  public static void updateContHelperQueueable(List<Id> contIdList) {
    List<Contact> contList = [SELECT Id FROM CONTACT WHERE Id IN :contIdList];
    UpdateContactsQueueable updateContJob = new UpdateContactsQueueable(
      contList
    );
    System.enqueueJob(updateContJob);
  }
}
