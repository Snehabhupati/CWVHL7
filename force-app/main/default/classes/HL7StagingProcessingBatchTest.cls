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
        
        Test.startTest();
        HL7StagingProcessingBatch bs = new HL7StagingProcessingBatch();
        Database.executeBatch(bs);
        
        Test.stopTest();
        
       
    }
}