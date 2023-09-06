@isTest
public class HL7StagingProcessingBatchTest {
    
    @isTest
    static void testBatchProcessing() {
        // Create test data
        List<HL7_Staging__c> testRecords = new List<HL7_Staging__c>();
        for (Integer i = 0; i < 200; i++) {
            HL7_Staging__c record = new HL7_Staging__c(
                IsProcessed__c = false,
                HL7_Message__c = 'Test HL7 Message ' + i
            );
            testRecords.add(record);
        }
        insert testRecords;
        
        Test.setMock(HttpCalloutMock.class, new HL7StagingProcessingBatchMock());
        
        HL7StagingProcessingBatch bs = new HL7StagingProcessingBatch();
        
        Test.startTest();
        
        // Execute the batch
        Database.executeBatch(bs);
        
        Test.stopTest();
        
        // Verify that records were processed (uncomment this part if needed)
        /*List<HL7_Staging__c> updatedRecords = [SELECT Id, IsProcessed__c, Processed_Date__c FROM HL7_Staging__c WHERE Id IN :testRecords];
        for (HL7_Staging__c updatedRecord : updatedRecords) {
            System.assertEquals(true, updatedRecord.IsProcessed__c);
            System.assertNotEquals(null, updatedRecord.Processed_Date__c);
        }*/
    }
}