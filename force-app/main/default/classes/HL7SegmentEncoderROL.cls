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
                // ExceptionLog.logDebugString('Unable to generate ROL message due to Room is not linked with this Event');
                ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate ROL message due to Room is not linked with this Event';
                Insert objExp;
                return '';
            }
            else{              
                strRol += '\n' + 'ROL';
                strRol += '|' + HL7HelperClass.analyze(objProcedure.CreatedByID, 0); //CreatedByID
                strRol += '|' + 'ADD'; //Action Code
                strRol += '|' + '^'+ HL7HelperClass.analyze(objProcedure.CreatedBy.Profile.Name, 0); //Role
                strRol += '|'+  objProcedure.CreatedById + '^' + HL7HelperClass.analyze((objProcedure.CreatedBy.LastName),0) + '^' + HL7HelperClass.analyze((objProcedure.CreatedBy.FirstName),0);//Role Person;            
                strRol += '|' ;//ROL.5 - Role Begin Date/Time
                strRol +=  '|' ;//ROL.6 - Role End Date/Time ; 
                strRol +=  '|' ;//ROL.6 - Role End Date/Time ; 
                strRol +=  '|' ;//ROL.7 - Role Duration ; 
                strRol +=  '|' ;//ROL.8 - Role Action Reason;
                strRol +=  '|' ;//ROL.9 - Provider Type;
                
                strRol +=  '|' + HL7HelperClass.analyze((objProcedure.CreatedBy.Street),0) +'^' + '^' 
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.City),0)  +'^' 
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.State),0)  + '^'
                    + HL7HelperClass.analyze((objProcedure.CreatedBy.PostalCode),0) + '^' 
                    + HL7HelperClass.analyze(HL7CodeMappings.getCountryCode(objProcedure.CreatedBy.Country),2) ;//ROL.11 - Office/Home Address/Birthplace
                strRol +=  '|' + HL7HelperClass.analyze((objProcedure.CreatedBy.Phone),0);
                strRol +=  '|' ;
                strRol +=  '|' + HL7HelperClass.analyze((objProcedure.CreatedBy.CompanyName),0);
                system.debug('strRol' + strRol);
                
            }
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