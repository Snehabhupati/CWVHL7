/*
Name: Sneha Bhupati
Profile: Salesforce Developer
Company: Mirketa Inc
*/
public class HL7SegmentEncoderROL {
    public static String generateROLSegment(ElixirSuite__Procedure__c objProcedure){
        String strRol = '';
        try{  
            if(objProcedure.CreatedBy.FirstName == null){
                ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate ROL message due to FirstName not available';
                Insert objExp;
                return '';
            }
            else{              
                strRol += '\n' + 'ROL';
                strRol += '|' + HL7HelperClass.analyze(objProcedure.CreatedByID, 60); //CreatedByID
                strRol += '|' + 'AD'; //Action Code
                strRol += '|' + '^'+ HL7HelperClass.analyze(objProcedure.CreatedBy.Profile.Name, 199); //Role
                strRol += '|'+  HL7HelperClass.analyze(objProcedure.CreatedBy.CustomText2__c,15) + '^' + HL7HelperClass.analyze((objProcedure.CreatedBy.LastName),194) + '^' + HL7HelperClass.analyze((objProcedure.CreatedBy.FirstName),30)+ '^^^^^^^^^^' + 'NPI';//HL7HelperClass.analyze((objProcedure.CreatedBy.CustomText2__c),5);//Role Person;            
                strRol += '|' ;//ROL.5 - Role Begin Date/Time
                strRol +=  '|' ;//ROL.6 - Role End Date/Time ; 
                strRol +=  '|' ;//ROL.6 - Role End Date/Time ; 
                strRol +=  '|' ;//ROL.7 - Role Duration ; 
                strRol +=  '|' ;//ROL.8 - Role Action Reason;
                strRol +=  '|' ;//ROL.9 - Provider Type;
                strRol +=  '|' + HL7HelperClass.analyze((objProcedure.CreatedBy.Street),184) +'^' + '^' 
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.City),50)  +'^' 
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.State),50)  + '^'
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.PostalCode),12) + '^' 
                    + HL7HelperClass.analyze(HL7CodeMappings.getCountryCode(objProcedure.CreatedBy.Country),3) ;//ROL.11 - Office/Home Address/Birthplace
                strRol +=  '|' + HL7HelperClass.analyze((objProcedure.CreatedBy.Phone),250);

                system.debug('strRol' + strRol);
                
            }
            System.debug('HL7ROLLimits:'+Limits.getQueries());
            return strRol ; 
            
        }catch (exception e) {
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate ROL message due to Room is not linked with this Event';
            Insert objExp;
            system.debug('Exception occurred in HL7 ROL Record Segment : ' + e.getMessage()); 
            return '';
        }
        
    }
    
    
}