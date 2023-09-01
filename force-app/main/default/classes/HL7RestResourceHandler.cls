/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7RestResourceHandler {
    
    
    public static String getHL7ResponseADT(String accountId, String messageType) {
        String strMSH='';
        String strEVN='';
        String strPID='';
        String strNK1='';
        String strPV1='';
        String strPR1='';
        String strAL1='';
        String strIN1='';
        String strDG1='';
        String strOBX='';
        String strGT1='';
        String strPRB ='';
        String strTXA ='';
        try{
            strMSH = HL7SegmentEncoderMSH.generateMSHSegment(accountId, messageType);
        } catch (Exception ex) {
            //ExceptionLog.logDebugString('Exception occurred in HL7 MSH Segment:'+ ex.getMessage());
        }
        try{
            strEVN = HL7SegmentEncoderEVN.generateEVNSegment(accountId);
        } catch (Exception ex) {
            //ExceptionLog.logDebugString('Exception occurred in HL7 EVN Segment:'+ ex.getMessage());
        }
        try{
            strPID = HL7SegmentEncoderPID.generatePIDSegment(accountId);
        } catch (Exception ex) {
            //ExceptionLog.logDebugString('Exception occurred in HL7 PID Segment:'+ ex.getMessage());
        }
        try{
            strPV1 = HL7SegmentEncoderPV1.generatePV1Segment(accountId);
        } catch (Exception ex) {
            //ExceptionLog.logDebugString('Exception occurred in HL7 PV1 Segment:'+ ex.getMessage());
        }
       
        if(String.isBlank(strMSH) || String.isBlank(strPID) || String.isBlank(strEVN)|| String.isBlank(strPV1))
        {
            return '';
        }
  
        try{
            strIN1 = HL7SegmentEncoderIN1.generateIN1Segment(accountId);
        } catch (Exception ex) {
           // ExceptionLog.logDebugString('Exception occurred in HL7 AL1 Segment:'+ ex.getMessage());
        }
       System.debug(strMSH + strEVN + strPID + strPV1  + strPR1 + strIN1);
        return strMSH + strEVN + strPID + strPV1  + strPR1 + strIN1;
    }
    
}