/*
Name: Khushi Maurya
Profile: Salesforce Developer
Company: Mirketa Inc
*/
//=======================================================================================================================================

@isTest
public class HL7SegmentEncoderEVNTest {
    @isTest
    public static void testGenerateEVNSegment() {
        //create test data
        Account acc = new Account(
            Name = 'test acc'
        );
        insert acc;
        
        ElixirSuite__ICD_Codes__c diagnosisCode = new ElixirSuite__ICD_Codes__c();
        diagnosisCode.ElixirSuite__Account__c = acc.Id;
        diagnosisCode.ElixirSuite__Diagnosis_Type__c = 'Primary';
        insert diagnosisCode;
        
        ElixirSuite__Visits__c objVisit = new ElixirSuite__Visits__c();
        objVisit.Name = 'Test Visit' ;
        objVisit.ElixirSuite__Account__c = acc.Id;  
        objVisit.ElixirSuite__Status__c = 'Active';
        objVisit.Service_Type__c = 'MHRS - COUNSELING - COMMUNITY BASED';
   
        insert objVisit;
        
        // Call the method being tested
        Test.startTest(); 
        String EVNSegment = HL7SegmentEncoderEVN.generateEVNSegment(acc.Id,objVisit.Id);
        System.assertNotEquals('', EVNSegment);
        //For exception method
        String EVNSegmentwithException=HL7SegmentEncoderEVN.generateEVNSegment('INVALIDID', 'INVALIDID');
        Test.stopTest(); 
    } 
}