public class UpdateContactsQueueable implements Queueable {
  private List<Contact> contList;
  public UpdateContactsQueueable(List<Contact> contList) {
    this.contList = contList;
  }
  public void execute(QueueableContext context) {
    for (Contact cont : contList) {
      cont.Is_Synced__c = false;
      cont.Processed_By_Queue__c = true;
    }
    update contList;
  }
}
