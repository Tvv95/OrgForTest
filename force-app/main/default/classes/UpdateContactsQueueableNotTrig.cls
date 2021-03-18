public class UpdateContactsQueueableNotTrig implements Queueable {
  private List<Contact> contList;
  public UpdateContactsQueueableNotTrig(List<Account> accs) {
    List<Id> accIdListWithBillAdr = new List<Id>();
    for (Account el : accs) {
      if (el.BillingAddress != null) {
        accIdListWithBillAdr.add(el.Id);
      }
    }
    this.contList = [
      SELECT AccountId, Is_Synced__c, Processed_By_Future__c
      FROM Contact
      WHERE AccountId IN :accIdListWithBillAdr
    ];
  }
  public void execute(QueueableContext context) {
    for (Contact cont : contList) {
      cont.Is_Synced__c = false;
      cont.Processed_By_Queue__c = true;
    }
    update contList;
  }
}
