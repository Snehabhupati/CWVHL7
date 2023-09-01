/*
Name: Khushi Maurya
Profile: Salesforce Developer
Company: Mirketa Inc
*/
//=======================================================================================================================================
public class HL7SegmentEncoderEVN {
    public static String generateEVNSegment(String accountId, String visitId) {
        
        List<ElixirSuite__Visits__c> objVisit = HL7GeneralUtil.getCareEpisode(accountId, visitId);
        //String eventFacility =  objVisit[0].Service_Location__c;
                
        String EVN='';
        DateTime admitDate;
        DateTime dischargeDate;
        String eventOccuredDateTime;
        String operatorID;
        String operatorFirstName;
        String operatorLastName;
        String operatorIdForUser;
        try{
            
            String recordedDateTime =HL7HelperClass.analyze((objVisit[0].CreatedDate.format('yyyyMMddHHmmssZ')),26) ;     
            if(objVisit[0].ElixirSuite__Status__c!=null)
            {
                
                if(objVisit[0].ElixirSuite__Visit_Start__c!=null && objVisit[0].ElixirSuite__Status__c=='Active')
                {
                    eventOccuredDateTime=HL7HelperClass.analyze(HL7GeneralUtil.getLastModifiedDateTime(objVisit[0].ElixirSuite__Visit_Start__c),26);
                    
                }
                
                if(objVisit[0].ElixirSuite__Visit_End__c!=null && objVisit[0].ElixirSuite__Status__c=='Closed')
                {
                    eventOccuredDateTime=HL7HelperClass.analyze(HL7GeneralUtil.getLastModifiedDateTime(objVisit[0].ElixirSuite__Visit_End__c),26);
                }     
                
                if((objVisit[0].ElixirSuite__Status__c=='Active') || (objVisit[0].ElixirSuite__Status__c=='Closed'))
                { 
                    operatorFirstName=HL7HelperClass.analyze(objVisit[0].CreatedBy.FirstName,30);
                    
                    operatorLastName=HL7HelperClass.analyze(objVisit[0].CreatedBy.LastName ,194);
                    
                    operatorIdForUser= HL7HelperClass.analyze(objVisit[0].CreatedById, 15);
                    
                    operatorID= (operatorIdForUser+'^'+ operatorLastName+'^'+operatorFirstName);
                                        
                }
                
                else  {
                    operatorID= '';
                }
                
                //=====================================HL7 Encoded EVN  Message==================================================       
                EVN += 'EVN' + '|' ;
                EVN += HL7GeneralUtil.getTriggerEvent(accountId,visitId) + '|';
                
                EVN +=  recordedDateTime + '|';
                EVN += '|';
                EVN += '|';//new elixir field -Event ReasonCode      
                EVN += OperatorID +'|';
                EVN +=  eventOccuredDateTime +'|' ;
                //String eventFacility = HL7HelperClass.analyze(objAccount.ElixirSuite__Treatment_Center_Name__c ,241);  
                EVN +=  HL7HelperClass.analyze(objVisit[0].Service_Location__c, 241);
                
            }
            
            else 
            {
                EVN='';
                //ExceptionLog.logDebugString('Unable to generate EVN message due to required fields missing:Trigger Event ');
            }
            System.debug('EVN '+EVN);
            return EVN +'\n';
        } catch (Exception e) {         
            //ExceptionLog.logDebugString('Exception occurred in HL7 EVN Segment: ' + e.getMessage());  
            System.debug('Exception occurred in HL7 EVN Segment: ' + e.getMessage());      
            return '';
        }
    }
}