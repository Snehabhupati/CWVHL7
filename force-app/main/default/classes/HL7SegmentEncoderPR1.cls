public class HL7SegmentEncoderPR1 {
    public static String generatePR1Segment(String accountId, String visitId ) {
        String strPR1 ='';
        try{ 
            List<ElixirSuite__Procedure__c> objProcedureList = new List<ElixirSuite__Procedure__c>();
            List<ElixirSuite__Procedure__c> ProcedureList = HL7GeneralUtil.getPatientProcedure(accountId, visitId);
            if (ProcedureList != null) {
                objProcedureList = ProcedureList;
            }
            for(integer i = 0; i < objProcedureList.size(); i++){
                strPR1 += generatePR1SegmentRecord(i+1, objProcedureList[i]) + '\n';
            }
            System.debug(strPR1);
            return strPR1;
        } catch (Exception e) {
            // Log the exception if needed
            System.debug('Exception occurred in HL7 PR1 Segment: ' + e.getMessage());
            // Return an empty string
            return '';
        }
    }
    public static string generatePR1SegmentRecord(integer counter, ElixirSuite__Procedure__c objProcedure){
        String PR1='';
        String ProcedureCode='';
        
        try {
            //========================================Formation of the message
            PR1+='PR1';
            PR1+= '|' + counter; //Set ID
            PR1+= '|' ; //Procedure Coding Method
            if(objProcedure.ElixirSuite__Code_Category__c=='ICD -10-PCS')
            {
                ProcedureCode=HL7HelperClass.analyze(objProcedure.Name, 20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Code_Description__c,199)+'^'+ 'I10P';//Procedure Code
            }
            if(objProcedure.ElixirSuite__Code_Category__c=='HCPCS Level 1'||objProcedure.ElixirSuite__Code_Category__c=='HCPCS Level 2')
            {
                ProcedureCode=HL7HelperClass.analyze(objProcedure.Name, 20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Code_Description__c,199)+ '^'+'HPC';//Procedure Code
            }
            
            PR1+= '|' +ProcedureCode;
            PR1+= '|'; //Procedure Description
            PR1+= '|' + HL7HelperClass.analyze((HL7GeneralUtil.getModifiedDateTime(objProcedure.ElixirSuite__From_Date_of_Service__c)),26); //Procedure Date/Time
            PR1+= '|'; //Procedure Functional Type
            if(objProcedure.ElixirSuite__To_Date_of_Service__c!= null && objProcedure.ElixirSuite__From_Date_of_Service__c!=null )
            {
                string ProcedureMinutes= String.valueOf((objProcedure.ElixirSuite__To_Date_of_Service__c.getTime() - objProcedure.ElixirSuite__From_Date_of_Service__c.getTime())/60000);//Procedure Minutes
                PR1+= '|' + ProcedureMinutes;
            }
            else
            {
                PR1+= '|';
            }
            PR1+= '|'; //Anesthesiologist
            PR1+= '|'; //Anesthesia Code
            PR1+= '|'; //Anesthesia Minutes
            PR1+= '|'; //Surgeon
            PR1+= '|'; //Procedure Practitioner
            PR1+= '|'; //Consent Code
            PR1+= '|'; //Procedure Priority
            PR1+= '|'; // Associated Diagnosis Code
            
            String Modifier='';
            if(objProcedure.ElixirSuite__Modifier1__r.Name!=null)
            {
                Modifier+=HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier1__r.Name,20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier1__r.ElixirSuite__Code_Description__c,199)+'^'+'CPTM';
            }
            if(objProcedure.ElixirSuite__Modifier2__r.Name!=null)
            {
                Modifier+='~'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier2__r.Name,20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier2__r.ElixirSuite__Code_Description__c,199)+'^'+'CPTM';
            }
            
            if(objProcedure.ElixirSuite__Modifier3__r.Name!=null)
            {
                Modifier+='~'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier3__r.Name,20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier3__r.ElixirSuite__Code_Description__c,199)+'^'+'CPTM';
            }   
            if(objProcedure.ElixirSuite__Modifier4__r.Name!=null)
            {
                Modifier+='~'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier4__r.Name,20)+'^'+HL7HelperClass.analyze(objProcedure.ElixirSuite__Modifier1__r.ElixirSuite__Code_Description__c,199)+'^'+'CPTM';
            }
            
            PR1+= '|'+ Modifier;
            
            PR1+= '|'; //Procedure Drg Type
            PR1+= '|'; //Tissue Type Code
            PR1+= '|' + objProcedure.Id; //Procedure Identifier
            PR1+= '|'; //Procedure Action Code
            PR1+= '|'; //DRG Procedure Determination Status
            PR1+= '|'; // Drg Procedure Relevance
            PR1+= '|'; //Treating Organizational Unit
            PR1+= '|'; //Respiratory Within Surgery
            PR1+= '|'; //Parent Procedure Id
            
            PR1 += HL7SegmentEncoderROL.generateROLSegment(objProcedure);
        } 
        
        catch (exception e) {
            System.debug('Exception occurred in HL7 PR1 Record Segment: ' + e.getMessage());
            // Return an empty string
            return '';
        }   
        system.debug('PR1' +PR1);
        return PR1;
    }
}