@isTest
public class HL7SegmentEncoderDG1Test {
    @isTest
    static void testGenerateDG1Segment() {
        // Create a test account
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;
         
        ElixirSuite__ICD_Codes__c icdCodes = new ElixirSuite__ICD_Codes__c();
        icdCodes.Name = '9092';
        icdCodes.ElixirSuite__Account__c = acc.Id;
        icdCodes.ElixirSuite__Active__c = true;
        icdCodes.ElixirSuite__Version__c = 'ICD 10';
        icdCodes.ElixirSuite__Diagnosis_Type__c = 'Secondary';
        
        ElixirSuite__ICD_Codes__c icdCodes2 = new ElixirSuite__ICD_Codes__c();
        icdCodes2.Name = '2441';
        icdCodes2.ElixirSuite__Account__c = acc.Id;
        icdCodes2.ElixirSuite__Active__c = true;
        icdCodes2.ElixirSuite__Version__c = 'ICD 9';
        
        
        insert new list<ElixirSuite__ICD_Codes__c>{icdCodes, icdCodes2};

        ElixirSuite__Diagnosis_Code__c diagnosisCodes1 = new ElixirSuite__Diagnosis_Code__c();        
        diagnosisCodes1.ElixirSuite__Diagnosis_Code__c = icdCodes.Id;        
       
        ElixirSuite__Diagnosis_Code__c diagnosisCodes2 = new ElixirSuite__Diagnosis_Code__c();
        diagnosisCodes2.ElixirSuite__Diagnosis_Code__c = icdCodes2.Id;
        
        
        insert new list<ElixirSuite__Diagnosis_Code__c> {diagnosisCodes1, diagnosisCodes2} ;
            
        Test.startTest();
        String DG1Segment = HL7SegmentEncoderDG1.generateDG1Segment(acc.Id);     
        HL7SegmentEncoderDG1.generateDG1SegmentRecord(1,diagnosisCodes1);
        String DG1 =  HL7SegmentEncoderDG1.generateDG1SegmentRecord(2,diagnosisCodes2);        
        DG1Segment=HL7SegmentEncoderDG1.generateDG1Segment('INVALIDID');        
        Test.stopTest();
    }  
}