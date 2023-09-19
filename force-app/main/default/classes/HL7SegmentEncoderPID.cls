/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7SegmentEncoderPID {
    public static String generatePIDSegment(String accountId) {    
        String formattedDeceasedDate = '';
        String genderValue = '';
        String ssn = '';
        String lastFourDigitsSSN = '';
        String birthDate = '';
        Account objAccount = HL7GeneralUtil.getAccount(accountId);
        // Add Deceased field to PID segment
        Boolean isDeceased = objAccount.ElixirSuite__Deceased__c;
        String deceasedFlag = isDeceased ? 'Y' : 'N';
        try{
            ssn = objAccount.ElixirSuite__SSN__c;
            if (ssn.length() >= 4) {
                try {
                    Integer lastFourDigits = Integer.valueOf(ssn.substring(ssn.length() - 4));
                    lastFourDigitsSSN = String.valueOf(lastFourDigits);
                } catch (Exception ex) {
                    System.debug('Invalid SSN: ' + ssn);
                    ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
                    objExp.ElixirSuite__Stack_Trace_Long__c = 'Invalid SSN: ' + ssn;
                    Insert objExp;
                }
            }
            if (lastFourDigitsSSN.length() < 4) {
                lastFourDigitsSSN = '';
            } else {
                lastFourDigitsSSN = 'XXX-XX-' + lastFourDigitsSSN;
            }
            ssn = HL7HelperClass.analyze('XXX-XX-' + lastFourDigitsSSN, 11);
            
            genderValue = objAccount.ElixirSuite__Gender__c != null ? objAccount.ElixirSuite__Gender__c :'';
            String genderCode = '';
            if(genderValue == 'Female' || genderValue == 'Male'){
                genderCode =  HL7CodeMappings.getGenderCode(genderValue);
                System.debug('genderCode  '+genderCode);
            }
            else{
                genderCode = 'O';
            }
            if(objAccount.ElixirSuite__Deceased__c==true && objAccount.ElixirSuite__Deceased_Date__c!=null){
                Date dt = objAccount.ElixirSuite__Deceased_Date__c;
                formattedDeceasedDate = HL7GeneralUtil.getDateTimeFormat(dt);
            }
            if(objAccount.ElixirSuite__DOB__c != null){
              Date dt = objAccount.ElixirSuite__DOB__c;
              birthDate = HL7GeneralUtil.getDateTimeFormat(dt);
            }
            String strPID = 'PID';
            strPID += '|' + '';  //pid Optional and not required
            strPID += '|' + '';  //External Id that will be coming from HL7
            strPID += '|' + objAccount.Id;
            strPID += '|' + ''; //Option alternate Patient Id
            strPID += '|' + (HL7HelperClass.analyze(objAccount.ElixirSuite__Last_Name__c,194) + '^' + HL7HelperClass.analyze(objAccount.ElixirSuite__First_Name__c,30) );
            strPID += '|' + ''; // Optional Mother's Maiden Name
            strPID += '|' + HL7HelperClass.analyze(birthDate,26);
            strPID += '|' + genderCode;
            strPID += '|' + ''; //Patient Alias - No elixir field
            strPID += '|' + HL7HelperClass.analyze(HL7CodeMappings.getRaceCode(objAccount.Race__c),250); //Race - No elixir field
            strPID += '|' + (HL7HelperClass.analyze(objAccount.BillingStreet,184) + '^^' + HL7HelperClass.analyze(objAccount.BillingCity,50) + '^' 
                             + HL7HelperClass.analyze(objAccount.BillingState,50) + '^' + HL7HelperClass.analyze(objAccount.BillingPostalCode,12) + '^' 
                             + HL7HelperClass.analyze(HL7CodeMappings.getCountryCode(objAccount.BillingCountry),3) + '^');
            strPID += '|' + ''; //Country Code - No elixir field
            strPID += '|' + HL7HelperClass.analyze(objAccount.Phone,250) +'';
            strPID += '|' + ''; //Phone Business Number
            strPID += '|' + ''; // Primary Language - No elixir field
            strPID += '|' + ''; // Marital Status - No elixir field
            strPID += '|' + ''; // Religion - No elixir field
            strPID += '|' + HL7HelperClass.analyze(objAccount.ElixirSuite__Account_Number__c,250);
            strPID += '|' + lastFourDigitsSSN;
            strPID += '|' + ''; // patient's driver license number
            strPID += '|' + ''; // monther's identifier
            strPID += '|' +  HL7HelperClass.analyze(HL7CodeMappings.getEthnicityCode(objAccount.Ethnicity__c),250); // ethnic group
            strPID += '|' + ''; // birth place
            strPID += '|' + ''; //multiple birth indicator
            strPID += '|' + ''; //birth order>
            strPID += '|' + ''; //citizenship
            strPID += '|' + ''; //veterans military status
            strPID += '|' + ''; //nationality
            strPID += '|' + formattedDeceasedDate;
            strPID += '|' + deceasedFlag;
            strPID += '|' + ''; //identity unknown indicator
            strPID += '|' + ''; //identity reliability code
            strPID += '|' +  HL7HelperClass.analyze(HL7GeneralUtil.getLastModifiedDateTime(objAccount.LastModifiedDate),26); //last update date/time
            strPID += '|' + HL7HelperClass.analyze((HL7CodeMappings.SendingFacility),241); //last update facility
            strPID += '|' + ''; //species code
            strPID += '|' + ''; //breed code>
            strPID += '|' + ''; //strain
            strPID += '|' + ''; //production class code
            strPID += '|' ; //tribal citizenship
            
            System.debug(strPID);             
            return strPID +'\n';
        } catch (Exception e) {
            System.debug('Exception occurred in HL7 PID Segment: ' + e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 PID Segment:'+ e.getMessage();
            Insert objExp;
            return '';
        }
        
    }
}