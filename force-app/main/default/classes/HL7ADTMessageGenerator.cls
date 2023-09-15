public class HL7ADTMessageGenerator {
    public static String getADTMessage(String accountId, String visitId, String messageType) {
        String strMSH='';
        String strEVN='';
        String strPID='';
        String strPV1='';
        String strPR1='';
        String strIN1='';
        String strDG1='';
        
        try{
            strMSH = HL7SegmentEncoderMSH.generateMSHSegment(accountId,visitId, messageType);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 MSH Segment:'+ ex.getMessage());
        }
        try{
            strEVN = HL7SegmentEncoderEVN.generateEVNSegment(accountId, visitId);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 EVN Segment:'+ ex.getMessage());
        }
        try{
            strPID = HL7SegmentEncoderPID.generatePIDSegment(accountId);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 PID Segment:'+ ex.getMessage());
        }
        try{
            strPV1 = HL7SegmentEncoderPV1.generatePV1Segment(accountId, visitId);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 PV1 Segment:'+ ex.getMessage());
        }
        
        if(String.isBlank(strMSH) || String.isBlank(strPID) || String.isBlank(strEVN)|| String.isBlank(strPV1))
        {
            return '';
        }
        try{
            strIN1 = HL7SegmentEncoderIN1.generateIN1Segment(accountId);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 IN1 Segment:'+ ex.getMessage());
        }
        try{
            strPR1 = HL7SegmentEncoderPR1.generatePR1Segment(accountId,visitId);
        } catch (Exception ex) {
            System.debug('Exception occurred in HL7 PR1 Segment:'+ ex.getMessage());
        }
        try{
            strDG1 = HL7SegmentEncoderDG1.generateDG1Segment(accountId);
        } catch (Exception ex) {
           System.debug('Exception occurred in HL7 DG1 Segment:'+ ex.getMessage());
        }
        System.debug(strMSH + strEVN + strPID + strPV1  + strPR1 + strIN1 + strDG1);
        return strMSH  + strEVN + strPID + strPV1  + strPR1 + strIN1 + strDG1;
    }
    
}