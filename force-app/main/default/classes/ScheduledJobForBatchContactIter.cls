public class ScheduledJobForBatchContactIter implements Schedulable {
  public static String sch30 = '0 30 * ? * *';
  public static String sch00 = '0 00 * ? * *';

  public static String runScheduleContactIter00() {
    ScheduledJobForBatchContactIter sc = new ScheduledJobForBatchContactIter();
    return System.schedule('Job update contact-Iter 00', sch00, sc);
  }
  public static void runScheduleContactIter30() {
    ScheduledJobForBatchContactIter sc = new ScheduledJobForBatchContactIter();
    System.schedule('Job update contact-Iter 30', sch30, sc);
  }

  public void execute(SchedulableContext sc) {
    UpdateContactsBatchIterable inst = new UpdateContactsBatchIterable();
    ID batchprocessid = Database.executeBatch(inst, 50);
  }
}
