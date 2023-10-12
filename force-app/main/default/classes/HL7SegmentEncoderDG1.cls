/*
Name: Sneha Bhupati
Profile: Salesforce Developer
Company: Mirketa Inc
*/
public class HL7SegmentEncoderDG1 {
    public static String generateDG1Segment(String accountId) {
        String strDG1 ='';
        try{
            List<ElixirSuite__Diagnosis_Code__c> objICDCodes = HL7GeneralUtil.getDiagnosis(accountId);
            Integer segmentCounter = 1;
            for(integer i = 0; i < objICDCodes.size(); i++){
                
                String segment = generateDG1SegmentRecord(segmentCounter, objICDCodes[i]) + '\n';
                if (!String.isBlank(segment)) {
                    strDG1 += segment;
                    segmentCounter++; // Increment the segment counter only if a segment is generated
                }
            }
            return strDG1;
        }catch (Exception e) {
            System.debug('Exception occurred in HL7  DG1 Segment: ' + e.getMessage());
            return '';
        }
    }  
    public static String generateDG1SegmentRecord(integer counter, ElixirSuite__Diagnosis_Code__c objICDCodes){
        
        String version = '';
        
        //================================Formation of message 
        try{
            if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == null){                 
                ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate strDG1 message due to required fields missing: [Version, Diagnosis type]';
                Insert objExp;                    
                return '';
            }
                else{
                    if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == 'ICD 10'){
                        version = 'I10';
                    }else if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == 'ICD 9'){
                        version = 'I9';
                    }
                    
                    String strDG1 = 'DG1';
                    strDG1 += '|' + counter ;// setId
                    strDG1 += '||' + HL7HelperClass.analyze(objICDCodes.ElixirSuite__Diagnosis_Code__r.Name, 20) + '^'  
                        + HL7HelperClass.analyze(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Code_Description1__c, 199) + '^' 
                        + HL7HelperClass.analyze(version, 20) ;  //  Diagnosis Code - Dg1
                    strDG1 += '||' + HL7HelperClass.analyze(HL7GeneralUtil.getDateTimeFormat(objICDCodes.ElixirSuite__Problem__r.ElixirSuite__Date_Diagonised__c),26);//Diagnosis Date/Time  
                    strDG1 += '|'  + 'F';
                    System.debug(strDG1);
                    return strDG1;                
                }
            
        }catch (exception e) {          
            System.Debug('Exception Message in DG1'+e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 DG1 Segment:'+ e.getMessage();
            Insert objExp;          
            return '';
        }
    }
}