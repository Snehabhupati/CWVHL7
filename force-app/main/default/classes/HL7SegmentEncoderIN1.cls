/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7SegmentEncoderIN1 {
    public static String generateIN1Segment(String accountId) {
        String strIN1 ='';
        try{
            Account objAccount = HL7GeneralUtil.getAccount(accountId);
            List<ElixirSuite__VOB__c> objInsuranceList = new List<ElixirSuite__VOB__c>();
            if (HL7GeneralUtil.getPrimaryInsurance(accountId) != null && HL7GeneralUtil.getPrimaryInsurance(accountId).size() > 0) {
                objInsuranceList = HL7GeneralUtil.getPrimaryInsurance(accountId);
            }
            for(integer i = 0; i < objInsuranceList.size(); i++){
                strIN1 += generateIN1SegmentRecord(i+1, objInsuranceList[i]) + '\n';
                
            }
            System.debug('strIN1'+strIN1);
            return strIN1;
        } catch (Exception e) {
            //  ExceptionLog.logDebugString('Exception occurred in HL7 IN1 Segment: ' + e.getMessage());
            return '';
        } 
    }
    public static string generateIN1SegmentRecord(integer counter, ElixirSuite__VOB__c objInsurance){
        String IN1='';
        Date planEffectiveDate = null;
        String formattedCardIssueDate='';
        Date planEndDate = null;
        String formattedCardEndDate='';
        Date insuredDob = null;
        String formattedInsuredDob = '';
        Date eligibilityResultDate = null;
        String formattedEligibilityResultDate = '';
        String formattedPlanStartDate ='';
        String formattedPlanEndDate ='';
        String genderCode ='';
        ElixirSuite__Result__c resultRecord = null;
        Date planStartDate = null;
        Integer numberOfDays =0;
        String planValidDays ='';
        system.debug('city'+objInsurance.ElixirSuite__Payer__r.ElixirSuite__City__c);
        String payorStreet = HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.ElixirSuite__Address__c,0) ;
        String payorCity =  HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.ElixirSuite__City__c,0) ;
        String payorState =  HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.ElixirSuite__State__c,0);
        String payorZipCode = HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.ElixirSuite__Zip_Code__c,0);
        
        String insuredStreet = HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_Address__c,0) ;
        String insuredCity =  HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_City__c,0) ;
        String insuredState =  HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_State__c,0);
        String insuredZipCode = HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_Zipcode__c,0);
        String insuredCountry = HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_Country__c,0);
        
        if(HL7CodeMappings.getCountryCode(insuredCountry) != '')
        {
            
            insuredCountry = HL7CodeMappings.getCountryCode(insuredCountry);
        }
        else
        {
            insuredCountry = '';
        }
        
        List<ElixirSuite__Result__c> insuranceResults = new List<ElixirSuite__Result__c>();
        try {
            if(objInsurance!=null){
                insuranceResults = HL7GeneralUtil.getInsuranceResult(objInsurance.Id);
            }
            if (insuranceResults != null && insuranceResults.size() > 0) {
                if(insuranceResults[0].ElixirSuite__Plan_Begin_Date__c!=null && insuranceResults[0].ElixirSuite__Plan_End_Date__c!=null){
                    planStartDate = insuranceResults[0].ElixirSuite__Plan_Begin_Date__c;
                    formattedPlanStartDate = HL7HelperClass.analyze(HL7GeneralUtil.getDateTimeFormat(planStartDate),0);
                    planEndDate = insuranceResults[0].ElixirSuite__Plan_End_Date__c;
                    formattedPlanEndDate = HL7HelperClass.analyze(HL7GeneralUtil.getDateTimeFormat(planEndDate),0);
                    numberOfDays = planStartDate.daysBetween(planEndDate);
                    
                    planValidDays=String.valueOf(numberOfDays);
                    
                }           
                if(insuranceResults[0].ElixirSuite__Eligibility_Result_Date__c!=null){
                    eligibilityResultDate = insuranceResults[0].ElixirSuite__Eligibility_Result_Date__c;
                    formattedEligibilityResultDate = HL7GeneralUtil.getDateTimeFormat(eligibilityResultDate);
                }
            }
            
            if(objInsurance.ElixirSuite__Card_Issue_Date__c!=null){
                planEffectiveDate = objInsurance.ElixirSuite__Card_Issue_Date__c;
                formattedCardIssueDate = HL7GeneralUtil.getDateTimeFormat(planEffectiveDate);          
            }
            if(objInsurance.ElixirSuite__Date_Of_Birth__c!=null){
                insuredDob = objInsurance.ElixirSuite__Date_Of_Birth__c;
                formattedInsuredDob = HL7GeneralUtil.getDateTimeFormat(insuredDob); 
            }
            String ssn = HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_SSN__c,0);
            String lastFourDigitsSSN = '';
            
            if (ssn.length() >= 4) {
                try {
                    Integer lastFourDigits = Integer.valueOf(ssn.substring(ssn.length() - 4));
                    lastFourDigitsSSN = String.valueOf(lastFourDigits);
                } catch (Exception ex) {
                    System.debug('Invalid SSN: ' + ssn);
                    //  ExceptionLog.logError(ex);
                }
            }
            
            if (lastFourDigitsSSN.length() < 4) {
                lastFourDigitsSSN = '';
            } else {
                lastFourDigitsSSN = 'XXX-XX-' + lastFourDigitsSSN;
            }
            
            System.debug('lastFourDigitsSSN: ' + lastFourDigitsSSN);
            
            genderCode = objInsurance.ElixirSuite__Gender__c != null ? objInsurance.ElixirSuite__Gender__c :'';
            
            if(HL7CodeMappings.getGenderCode(genderCode) != null)
            {
                genderCode = HL7CodeMappings.getGenderCode(genderCode);
            }
            else
            {
                genderCode = '';
            }
            
            //========================================Formation of the message
            IN1+=  'IN1';
            IN1+= '|' + counter; //Set ID
            IN1+= '|' + '^' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Insurance_Plan_Name__c,0); 
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.ElixirSuite__Payer_Code__c,0); 
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.Name,0) + '^' + 'D';
            if(payorStreet =='' && payorCity=='' && payorState == '' && payorZipCode=='')
            {
                IN1+= '|' +''; 
            }
            else
            {
                IN1+= '|' +payorStreet +'^'+ '^'+payorCity+'^'+ payorState +'^'+ payorZipCode;   
            }
            
            IN1+= '|' ;
            if(objInsurance.ElixirSuite__Payer__r.ElixirSuite__PhoneNumber__c!=null){
                IN1+= '|' + objInsurance.ElixirSuite__Payer__r.ElixirSuite__PhoneNumber__c;
                System.debug('ElixirSuite__Phone_Number__c  ' +objInsurance.ElixirSuite__Payer__r.ElixirSuite__PhoneNumber__c);
            }
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Group_Number__c,0);
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Group_Name__c,0);
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Payer__r.Id,0);
            IN1+= '|' ;
            IN1+= '|' + formattedPlanStartDate;
            IN1+= '|' + formattedPlanEndDate;
            IN1+= '|';
            String insuranceType = HL7HelperClass.analyze(objInsurance.ElixirSuite__Insurance_Type__c, 0);
            IN1+= '|' + (String.isNotBlank(insuranceType) ? '^' + insuranceType : insuranceType);            
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_Last_Name__c,0) +'^' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_First_Name__c,0);
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Patient_Relationship_With_Insured__c,0);
            IN1+= '|' + HL7HelperClass.analyze(formattedInsuredDob,0);
            if(insuredStreet=='' && insuredCity=='' && insuredState == '' && insuredZipCode=='' && insuredCountry=='' )
            {
                IN1+= '|' +''; 
            }
            else
            {
                IN1+= '|' +insuredStreet +'^'+ '^'+insuredCity+'^'+ insuredState +'^'+ insuredZipCode + '^'+insuredCountry;   
            }
            
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            if (insuranceResults!=null && insuranceResults.size() > 0) {
                IN1 += 'Y';
            } else {
                IN1 += 'N';
            }
            IN1+= '|' + HL7HelperClass.analyze(formattedEligibilityResultDate,0);
            IN1+= '|';
            IN1+= '|';
            IN1+= '|' + HL7HelperClass.analyze(formattedEligibilityResultDate,0);
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|' + HL7HelperClass.analyze(objInsurance.ElixirSuite__Insured_Policy_Group_FECA_Number__c,0);
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|' + planValidDays != '0' ? planValidDays : '';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|'+ genderCode;
            IN1+= '|';
            String vobVerificationStatus = HL7HelperClass.analyze(objInsurance.ElixirSuite__VOB_Verification_Status__c, 0);
            if (vobVerificationStatus != null && vobVerificationStatus.equalsIgnoreCase('approved')) {
                IN1 += '|V';
            } else {
                IN1 += '|U';
            }            
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|' + lastFourDigitsSSN;
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            IN1+= '|';
            
            
        } catch (exception e) {
            System.debug('e.getMessage()'+e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 IN1 Segment:'+ e.getMessage();
            Insert objExp;
            return '';
        }     
        System.debug(IN1);
        return IN1;
    }
}