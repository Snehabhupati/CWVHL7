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
            //ExceptionLog.logDebugString('Exception occurred in HL7  DG1 Segment: ' + e.getMessage());
            return '';
        }
    }  
    public static String generateDG1SegmentRecord(integer counter, ElixirSuite__Diagnosis_Code__c objICDCodes){
        
        String version = '';
        
        //================================Formation of message 
        try{
            if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == 'ICD 10'){
                version = 'I10';
            }else if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == 'ICD 9'){
                version = 'I9';
            }
            if(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c == null || objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Diagnosis_Type__c == null){                 
                //  ExceptionLog.logDebugString('Unable to generate strDG1 message due to required fields missing: [Version, Diagnosis type]');
                ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate strDG1 message due to required fields missing: [Version, Diagnosis type]';
                Insert objExp;                    
                return '';
            }
            
            else{
                String strDG1 = 'DG1';
                strDG1 += '|' + counter ;// setId
                strDG1 += '||' + HL7HelperClass.analyze(objICDCodes.ElixirSuite__Diagnosis_Code__r.Name, 0) + '^'  
                    + HL7HelperClass.analyze(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Code_Description1__c, 0) + '^' 
                    + HL7HelperClass.analyze(version, 0) ;  //  Diagnosis Code - Dg1
                strDG1 += '||' + HL7HelperClass.analyze(HL7GeneralUtil.getDateTimeFormat(objICDCodes.ElixirSuite__Problem__r.ElixirSuite__Date_Diagonised__c),0);//Diagnosis Date/Time  
                strDG1 += '|'  +'^'+ HL7HelperClass.analyze(objICDCodes.ElixirSuite__Diagnosis_Code__r.ElixirSuite__Diagnosis_Type__c,0);
                System.debug(strDG1);
                return strDG1;                
            }
            
        }catch (exception e) {          
            //ExceptionLog.logDebugString('Exception occurred in HL7 DG1 Record Segment: ' + e.getMessage()); 
            System.Debug('Exception Message in DG1'+e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 DG1 Segment:'+ e.getMessage();
            Insert objExp;          
            return '';
            
        }
    }
}