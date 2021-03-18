public class ScheduledJobForBatchContQue implements Schedulable {
  public static String sch30 = '0 30 * ? * *';
  public static String sch00 = '0 00 * ? * *';

  public static String runScheduleContactQue00() {
    ScheduledJobForBatchContQue sc = new ScheduledJobForBatchContQue();
    return System.schedule('Job update contact-Que 00', sch00, sc);
  }
  public static void runScheduleContactQue30() {
    ScheduledJobForBatchContQue sc = new ScheduledJobForBatchContQue();
    System.schedule('Job update contact-Que 30', sch30, sc);
  }

  public void execute(SchedulableContext sc) {
    UpdateContactsBatchQueueable inst = new UpdateContactsBatchQueueable();
    ID batchprocessid = Database.executeBatch(inst, 50);
  }
}
