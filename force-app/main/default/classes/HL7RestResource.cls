/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

@RestResource(urlMapping='/hl7/*')
global class HL7RestResource {
    
    @HttpPost
    global static void returnHL7Message(String patient, String messageType, String labOrderId) {
        String strHL7Message ='';
        RestResponse res = RestContext.response;
        try {
            if (patient == null || patient=='') {
                res.statusCode = 400;
                //ExceptionLog.logDebugString('Patient parameter is not found');
                res.responseBody = Blob.valueOf('Bad Request: Patient parameter is not found');
            } 
            else if(HL7GeneralUtil.getAccount(patient)==null){
                res.responseBody = Blob.valueOf('This Patient Does not Exist');
                //ExceptionLog.logDebugString('This Patient Does not Exist '+patient);
            }
            else {
                if(messageType == 'ADT'){              
                    strHL7Message = HL7RestResourceHandler.getHL7ResponseADT(patient, messageType);
                }
               
                if (strHL7Message== null || strHL7Message== '') {
                    res.statusCode = 500;
                    res.responseBody = Blob.valueOf('Server Internal Error: Unable to generate HL7 message at the moment. Please contact your system administrator.'); 
                } else {                    
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(strHL7Message);
                }
            }
        }catch (Exception ex) {
            res.statusCode = 500;
            //ExceptionLog.logError(ex);
            
        }
    }
}