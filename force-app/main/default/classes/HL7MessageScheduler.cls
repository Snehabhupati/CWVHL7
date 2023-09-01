public class HL7MessageScheduler implements Schedulable {
      public void execute(SchedulableContext sc) {
        HL7StagingProcessingBatch b = new HL7StagingProcessingBatch();
        Database.executeBatch(b);
    }
}