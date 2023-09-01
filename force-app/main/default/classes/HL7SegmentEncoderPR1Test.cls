@isTest
public class HL7SegmentEncoderPR1Test {
    @isTest
    static void testGeneratePR1Segment() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
           ElixirSuite__Procedure__c testProcedure1 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 3',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = acc.Id
        );
        insert testProcedure1;
        ElixirSuite__Procedure__c testProcedure2 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 4',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = acc.Id
        );
        insert testProcedure2;
        
        ElixirSuite__Procedure__c testProcedure3 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 1',
            ElixirSuite__Code_Category__c = 'ICD -10-PCS',
            ElixirSuite__Code_Description__c = 'Procedure Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Modifier1__c=testProcedure1.Id,
             ElixirSuite__Modifier2__c=testProcedure2.Id,
             ElixirSuite__Account__c = acc.Id
        );
        ElixirSuite__Procedure__c testProcedure4 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 2',
            ElixirSuite__Code_Category__c = 'HCPCS Level 1',
            ElixirSuite__Code_Description__c = 'Procedure Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
             ElixirSuite__Modifier3__c=testProcedure1.Id,
             ElixirSuite__Modifier4__c=testProcedure2.Id,
             ElixirSuite__Account__c = acc.Id
        );
          ElixirSuite__Procedure__c testProcedure5 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 2',
            ElixirSuite__Code_Category__c = 'HCPCS Level 1',
            ElixirSuite__Code_Description__c = 'Procedure Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
             ElixirSuite__Modifier3__c=testProcedure1.Id,
             ElixirSuite__Modifier4__c=testProcedure2.Id
            
        );
     
        List<ElixirSuite__Procedure__c> ProcedureList = new List<ElixirSuite__Procedure__c>{testProcedure3, testProcedure4, testProcedure5};
            insert ProcedureList;
        
        // Call the method being tested
         Test.startTest(); 
        String PR1Segment = HL7SegmentEncoderPR1.generatePR1Segment(acc.Id);
             
        System.assertNotEquals('', PR1Segment);
        System.assertEquals(true, PR1Segment.contains('PR1|1|'));
        System.assertEquals(true, PR1Segment.contains('PR1|2|'));
        
        Test.stopTest();
      
    }
}