public class HL7StagingProcessingBatch implements Database.Batchable<sObject>{
public Database.QueryLocator start(Database.BatchableContext context) {
      String query = 'SELECT Id, Name, IsProcessed__c,HL7_Message__c, AccountID__c FROM HL7_Staging__c WHERE IsProcessed__c = false';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext context, List<HL7_Staging__c> scope) {
        system.debug('scope: '+scope);
        for (HL7_Staging__c record : scope) {
            record.IsProcessed__c = true;
            record.Processed_Date__c = System.now();
        }
        update scope;
    }
    public void finish(Database.BatchableContext context) {
    }   

}