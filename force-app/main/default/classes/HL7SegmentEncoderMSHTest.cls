@isTest
public class HL7SegmentEncoderMSHTest {
    
@isTest
    static void testGenerateMSHSegment(){
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
            objVisit.ElixirSuite__Visit_Start__c = DateTime.newInstance(2023, 8, 30, 0, 0, 0);
            
        insert objVisit;
        
        Test.startTest();
        String adtMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment(acc.id, objVisit.id, 'ADT'); 
        String omlMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment(acc.id,objVisit.id, 'OML');
        String siuMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment(acc.id,objVisit.id, 'SIU');
        String oruMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment(acc.id,objVisit.id, 'ORU');
        String rgvMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment(acc.id,objVisit.id, 'RGV');
        
        adtMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment('INVALIDID','INVALIDID','INVALIDID');
        omlMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment('INVALIDID','INVALIDID','INVALIDID');
        siuMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment('INVALIDID','INVALIDID','INVALIDID');
        oruMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment('INVALIDID','INVALIDID','INVALIDID'); 
        rgvMSHSegment = HL7SegmentEncoderMSH.generateMSHSegment('INVALIDID','INVALIDID','INVALIDID'); 
        Test.stopTest();
    }  
}