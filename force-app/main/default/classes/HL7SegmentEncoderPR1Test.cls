@isTest
public class HL7SegmentEncoderPR1Test {
    @isTest
    static void testGeneratePR1Segment() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
         ElixirSuite__ICD_Codes__c diagnosisCode = new ElixirSuite__ICD_Codes__c();
        diagnosisCode.ElixirSuite__Account__c = acc.Id;
        diagnosisCode.ElixirSuite__Diagnosis_Type__c = 'Primary';
        insert diagnosisCode;
        
        ElixirSuite__Visits__c testVisit = new ElixirSuite__Visits__c(
            ElixirSuite__Account__c = acc.Id,
            ElixirSuite__Visit_Start__c = DateTime.newInstance(2023, 1, 1, 0, 0, 0),
            ElixirSuite__Visit_End__c = DateTime.newInstance(2023, 1, 2, 0, 0, 0)         // Set other required fields for the Visit as needed
        );
        insert testVisit;
        
        
        ElixirSuite__Procedure__c testProcedure1 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 1',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = acc.Id,
            ElixirSuite__Visits__c = testVisit.Id
        );
        insert testProcedure1;
        ElixirSuite__Procedure__c testProcedure2 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 2',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = acc.Id,
            ElixirSuite__Visits__c = testVisit.Id
        );
        insert testProcedure2;
        
        ElixirSuite__Procedure__c testProcedure3 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 3',
            ElixirSuite__Code_Category__c = 'ICD -10-PCS',
            ElixirSuite__Code_Description__c = 'Procedure Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Modifier1__c=testProcedure1.Id,
            ElixirSuite__Modifier2__c=testProcedure2.Id,
            ElixirSuite__Account__c = acc.Id,
            ElixirSuite__Visits__c = testVisit.Id
        );
        ElixirSuite__Procedure__c testProcedure4 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 4',
            ElixirSuite__Code_Category__c = 'HCPCS Level 1',
            ElixirSuite__Code_Description__c = 'Procedure Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Modifier3__c=testProcedure1.Id,
            ElixirSuite__Modifier4__c=testProcedure2.Id,
            ElixirSuite__Account__c = acc.Id,
            ElixirSuite__Visits__c = testVisit.Id
        );
        ElixirSuite__Procedure__c testProcedure5 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 5',
            ElixirSuite__Code_Category__c = 'HCPCS Level 1',
            ElixirSuite__Code_Description__c = 'Procedure Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Modifier3__c=testProcedure1.Id,
            ElixirSuite__Modifier4__c=testProcedure2.Id,
            ElixirSuite__Visits__c = testVisit.Id
            
        );
        
        List<ElixirSuite__Procedure__c> ProcedureList = new List<ElixirSuite__Procedure__c>{testProcedure3, testProcedure4, testProcedure5};
            insert ProcedureList;
        
       
        // Call the method being tested
        Test.startTest(); 
        String PR1Segment = HL7SegmentEncoderPR1.generatePR1Segment(acc.Id, testVisit.Id);
        Test.stopTest();
        
    }
}