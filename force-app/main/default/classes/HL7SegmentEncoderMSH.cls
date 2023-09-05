/*
Name: Sneha Bhupati
Profile: Salesforce Developer
Company: Mirketa Inc
*/

global with sharing class HL7SegmentEncoderMSH {
    public static String generateMSHSegment(String accountId, String visitId, String messageType) {
        String sendApp ='';
        String sendFacility = '';
        String triggerEvent = '';
        String strMSHFieldValue = '';  
        
        try{
            
            list<Sender_MetaData__mdt> sendAppdata = HL7GeneralUtil.getSendingApplication();       
            if (sendAppdata !=null && sendAppdata.size() > 0 && sendAppdata[0].value__c !=null){
                sendApp = sendAppdata[0].value__c;
                
            }        
            List<Sender_MetaData__mdt> mdtFacility = HL7GeneralUtil.getSendingFacility();
            if (mdtFacility !=null && mdtFacility.size() > 0 && mdtFacility[0].value__c !=null){
                sendFacility = mdtFacility[0].value__c;
                
            }
            
            //Retrieve Language
            Organization cmpInfo = HL7GeneralUtil.getCompanyInformation();   
            sendApp =HL7HelperClass.encodeAndTruncateString(sendApp,227);      
            sendFacility =HL7HelperClass.encodeAndTruncateString(sendFacility,227);
            triggerEvent = HL7GeneralUtil.getTriggerEvent(accountId, visitId);
            
            //getting MessageType
            if(messageType == 'ADT'){
                
                if(triggerEvent == ''){                    
                    //  ExceptionLog.logDebugString('Unable to generate MSH message due to required fields missing:[Patient Status]');  
                    return '';
                }                
                strMSHFieldValue = 'ADT^' + HL7HelperClass.analyze(HL7GeneralUtil.getTriggerEvent(accountId, visitId),3); //Message Code, Trigger Event         
                //MessageStructure
                if(triggerEvent == 'A01' || triggerEvent == 'A08'){
                    strMSHFieldValue += '^' + 'ADT_A01' ;
                }else if (triggerEvent == 'A03'){
                    strMSHFieldValue += '^' + 'ADT_A03';
                }
                
            } else if (messageType == 'OML'){
                strMSHFieldValue = 'OML^O21^OML_O21';//Messagecode 
            } else if (messageType == 'SIU'){
                strMSHFieldValue = 'SIU^S12^SIU_S12';//Messagecode
            } else if (messageType == 'ORU'){
                strMSHFieldValue = 'ORU^R01^ORU_R01' ;//Messagecode
            } else if (messageType == 'RGV'){
                strMSHFieldValue = 'RGV^O15^RGV_O15';//Messagecode
            } else{
                //    ExceptionLog.logDebugString('No messageType specified'); 
                return ''; 
            }                      
            //========================================Formation of the message
            
            String strMSH ='';
            
            strMSH = 'MSH' + '|';
            strMSH += HL7HelperClass.getEncodingCharacters() + '|';  //EncodingCharacters
            strMSH += HL7HelperClass.analyze(sendApp,227) + '|';
            strMSH += HL7HelperClass.analyze(sendFacility,227) + '|'; //sending facility      
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
            strMSH +=   HL7HelperClass.analyze(HL7GeneralUtil.getCountryCodes(cmpInfo.Country),2) + '|';//Country code 
            strMSH += 'ASCII'+'|';//charcter set
            strMSH +=  '^' + HL7HelperClass.analyze(cmpInfo.LanguageLocaleKey.split('_')[0],250) +'|';//principle language of message
            strMSH += '|';//alternate character set 
            strMSH += '|';//message profile handler  
            System.debug('MSH Segment ' +strMSH);
            return strMSH + '\n';
        } catch (Exception e) {
            //   ExceptionLog.logDebugString('Exception occurred in HL7 MSH Segment: ' + e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 MSH Segment:'+ e.getMessage();
            Insert objExp;
            System.debug('Exception occurred in HL7 MSH Segment: ' + e.getMessage());
            return ''; 
        } 
    }
}