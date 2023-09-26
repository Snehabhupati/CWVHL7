/*
Name: Khushi Maurya
Profile: Salesforce Developer
Company: Mirketa Inc
*/
//=======================================================================================================================================
public class HL7SegmentEncoderEVN {
    public static String generateEVNSegment(String accountId, String visitId) {
        
        List<ElixirSuite__Visits__c> objVisit = HL7GeneralUtil.getCareEpisode(accountId, visitId);
        System.debug('HL7EVNLimits:'+Limits.getQueries());        
        String EVN='';
        String eventOccuredDateTime;
        try{
            if(objVisit[0].ElixirSuite__Status__c == null){
                return '';
            }
                if(objVisit[0].ElixirSuite__Visit_Start__c!=null && objVisit[0].ElixirSuite__Status__c=='Active')
                {
                    eventOccuredDateTime=HL7HelperClass.analyze(HL7GeneralUtil.getModifiedDateTime(objVisit[0].ElixirSuite__Visit_Start__c),26);
                }
                
                if(objVisit[0].ElixirSuite__Visit_End__c!=null && objVisit[0].ElixirSuite__Status__c=='Closed')
                {
                    eventOccuredDateTime=HL7HelperClass.analyze(HL7GeneralUtil.getModifiedDateTime(objVisit[0].ElixirSuite__Visit_End__c),26);
                }     
                                
                //=====================================HL7 Encoded EVN  Message==================================================       
                EVN += 'EVN' + '|' ;
                EVN += HL7GeneralUtil.getTriggerEvent(accountId,visitId) + '|';
                EVN +=  HL7HelperClass.analyze((objVisit[0].CreatedDate.format('yyyyMMddHHmmssZ')),26) + '|';
                EVN += '|';
                EVN += '|';//new elixir field -Event ReasonCode      
                EVN += (HL7HelperClass.analyze(objVisit[0].CreatedById, 15) +'^'+
                        HL7HelperClass.analyze(objVisit[0].CreatedBy.LastName ,194) +'^'+
                        HL7HelperClass.analyze(objVisit[0].CreatedBy.FirstName,30)) +'|';
                EVN +=  eventOccuredDateTime +'|' ;
                EVN +=  HL7HelperClass.analyze(objVisit[0].Service_Location__c, 241);
            System.debug('EVN '+EVN);
            return EVN +'\n';
        } catch (Exception e) {         
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 EVN Segment:'+ e.getMessage();
            Insert objExp;
            System.debug('Exception occurred in HL7 EVN Segment: ' + e.getMessage());      
            return '';
        }
    }
}