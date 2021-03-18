public class ScheduledJobForBatchTask implements Schedulable {
  public static String sch30 = '0 30 * ? * *';
  public static String sch00 = '0 00 * ? * *';

  public static String runScheduleTask00() {
    ScheduledJobForBatchTask sc = new ScheduledJobForBatchTask();
    return System.schedule('Job update tasks 00', sch00, sc);
  }
  public static void runScheduleTask30() {
    ScheduledJobForBatchTask sc = new ScheduledJobForBatchTask();
    System.schedule('Job update tasks 30', sch30, sc);
  }

  public void execute(SchedulableContext sc) {
    UpdateTaskNamesBatch inst = new UpdateTaskNamesBatch();
    ID batchprocessid = Database.executeBatch(inst, 50);
  }
}
