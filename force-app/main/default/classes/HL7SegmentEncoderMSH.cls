/*
Name: Sneha Bhupati
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7SegmentEncoderMSH {
    public static String generateMSHSegment(String accountId, String visitId, String messageType) {
        String sendApp ='';
        String sendFacility = '';
        String triggerEvent = '';
        String strMSHFieldValue = '';  
        
        try{
            
            //Retrieve Language
            Organization cmpInfo = HL7GeneralUtil.getCompanyInformation(); 
            triggerEvent = HL7GeneralUtil.getTriggerEvent(accountId, visitId);
            
            //getting MessageType
            if(messageType == 'ADT'){
                
                if(triggerEvent == ''){  
                    ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                    objExp.ElixirSuite__Stack_Trace_Long__c = 'Unable to generate MSH message due to required fields missing:[Patient Status]';
                    Insert objExp;
                    return '';
                }                
                strMSHFieldValue = 'ADT^' + HL7HelperClass.analyze(HL7GeneralUtil.getTriggerEvent(accountId, visitId),3); //Message Code, Trigger Event         
                //MessageStructure
                if(triggerEvent == 'A01'){
                    strMSHFieldValue += '^' + 'ADT_A01' ;
                }else if (triggerEvent == 'A03'){
                    strMSHFieldValue += '^' + 'ADT_A03';
                }
                
            } else{
                System.debug('No messageType specified'); 
                return ''; 
            }                      
            //========================================Formation of the message
            
            String strMSH ='';
            
            strMSH = 'MSH' + '|';
            strMSH += HL7HelperClass.getEncodingCharacters() + '|';  //EncodingCharacters
            strMSH += HL7HelperClass.analyze((HL7CodeMappings.SendingApplication),227) + '|';
            strMSH += HL7HelperClass.analyze((HL7CodeMappings.SendingFacility),227) + '|'; //sending facility      
            strMSH += '|'; //ReceivingApplication
            strMSH += '|'; //ReceivingFacility
            strMSH += HL7HelperClass.analyze(HL7GeneralUtil.getCurrentDateTime(),26) + '|';
            strMSH += '|'; //No Security Tag
            strMSH += strMSHFieldValue + '|'; //Message Code, Trigger Event
            strMSH += 'MSG' + HL7HelperClass.analyze(HL7GeneralUtil.getCurrentDateTimeInMilliSecods(),20) + '|'; //Message Control ID
            strMSH += 'P' + '|'; //Processing ID (P, D, T)
            strMSH += '2.5.1'+'|' ; //Version ID 
            strMSH += '|';// Sequence Number
            strMSH += '|';// Continuation pointer
            strMSH += 'AL'+'|';//accept acknowledgement type
            strMSH += '|';//application acknowledgement type
            strMSH +=   HL7HelperClass.analyze(HL7CodeMappings.getCountryCode(cmpInfo.Country),2) + '|';//Country code 
            strMSH += 'ASCII'+'|';//charcter set
            strMSH +=  '^' + HL7HelperClass.analyze(cmpInfo.LanguageLocaleKey.split('_')[0],250) +'|';//principle language of message
            strMSH += '|';//alternate character set 
            strMSH += '|';//message profile handler  
            System.debug('MSH Segment ' +strMSH);
            return strMSH + '\n';
        } catch (Exception e) {
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 MSH Segment:'+ e.getMessage();
            Insert objExp;
            System.debug('Exception occurred in HL7 MSH Segment: ' + e.getMessage());
            return ''; 
        } 
    }
}