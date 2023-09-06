/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7SegmentEncoderPID {
    public static String generatePIDSegment(String accountId) {    
        String formattedDeceasedDate = '';
        String formattedBirthDate = '';
        String genderValue = '';
        String countryCode = '';
        String lastModifiedDateTime = '';
        String sendFacility = '';
        String lastName = '';
        String firstName = '';
        String billingStreet = '';
        String billingCity = '';
        String billingState = '';
        String billingPostalCode = '';
        String accountNumber = '';
        String ssn = '';
        String phone ='';
        String lastFourDigitsSSN = '';
        
        Account objAccount = HL7GeneralUtil.getAccount(accountId);
        // Add Deceased field to PID segment
        Boolean isDeceased = objAccount.ElixirSuite__Deceased__c;
        String deceasedFlag = isDeceased ? 'Y' : 'N';
        try{
            String mdtFacility = HL7CodeMappings.SendingFacility;
            if(mdtFacility != null){
                sendFacility = mdtFacility;
            }
            sendFacility =HL7HelperClass.replaceSpecialCharacters(sendFacility);
            lastName = HL7HelperClass.analyze(objAccount.ElixirSuite__Last_Name__c,194);
            firstName = HL7HelperClass.analyze(objAccount.ElixirSuite__First_Name__c,30);
            billingStreet = HL7HelperClass.analyze(objAccount.BillingStreet,184);
            billingCity = HL7HelperClass.analyze(objAccount.BillingCity,50);
            billingState = HL7HelperClass.analyze(objAccount.BillingState,50);
            billingPostalCode = HL7HelperClass.analyze(objAccount.BillingPostalCode,12);
            accountNumber = HL7HelperClass.analyze(objAccount.ElixirSuite__Account_Number__c,250);
            ssn = objAccount.ElixirSuite__SSN__c;
            phone = HL7HelperClass.analyze(objAccount.Phone,250);
            
            if (ssn.length() >= 4) {
                try {
                    Integer lastFourDigits = Integer.valueOf(ssn.substring(ssn.length() - 4));
                    lastFourDigitsSSN = String.valueOf(lastFourDigits);
                } catch (Exception ex) {
                    System.debug('Invalid SSN: ' + ssn);
                    //ExceptionLog.logError(ex);
                }
            }
            
            if (lastFourDigitsSSN.length() < 4) {
                lastFourDigitsSSN = '';
            } else {
                lastFourDigitsSSN = 'XXX-XX-' + lastFourDigitsSSN;
            }
            
            System.debug('lastFourDigitsSSN: ' + lastFourDigitsSSN);
            
            ssn = HL7HelperClass.analyze('XXX-XX-' + lastFourDigitsSSN, 11);
            System.debug('lastName' + lastName);
     
            if(HL7GeneralUtil.getLastModifiedDateTime(objAccount.LastModifiedDate)!=null){
                lastModifiedDateTime = HL7GeneralUtil.getLastModifiedDateTime(objAccount.LastModifiedDate);
            }
            genderValue = objAccount.ElixirSuite__Gender__c != null ? objAccount.ElixirSuite__Gender__c :'';
            System.debug('genderValue  '+genderValue);
            String genderCode = '';
            if(genderValue == 'Female' || genderValue == 'Male'){
                genderCode =  HL7CodeMappings.getGenderCode(genderValue);
                System.debug('genderCode  '+genderCode);
            }
            else{
                genderCode = 'O';
            }
            
            if(HL7CodeMappings.getCountryCode(accountId)!=null && objAccount.BillingCountry!=null){
                countryCode = HL7HelperClass.replaceSpecialCharacters(objAccount.BillingCountry);
                countryCode = HL7CodeMappings.getCountryCode(countryCode);
            }
            System.debug('countryCode'+countryCode);
            
            if(objAccount.ElixirSuite__Deceased__c==true && objAccount.ElixirSuite__Deceased_Date__c!=null){
                Date dt = objAccount.ElixirSuite__Deceased_Date__c;
                formattedDeceasedDate = HL7GeneralUtil.getDateTimeFormat(dt);
            }
            
            if(objAccount.ElixirSuite__DOB__c!=null){
                Date dt = objAccount.ElixirSuite__DOB__c;
                formattedBirthDate = HL7GeneralUtil.getDateTimeFormat(dt);
            }
            
            String strPID = 'PID';
            strPID += '|' + '';  //pid Optional and not required
            strPID += '|' + '';  //External Id that will be coming from HL7
            strPID += '|' + objAccount.Id;
            strPID += '|' + ''; //Option alternate Patient Id
            strPID += '|' + (lastName + '^' + firstName );
            strPID += '|' + ''; // Optional Mother's Maiden Name
            strPID += '|' + formattedBirthDate;
            strPID += '|' + genderCode;
            strPID += '|' + ''; //Patient Alias - No elixir field
            strPID += '|' + ''; //Race - No elixir field
            strPID += '|' + (billingStreet + '^^' + billingCity + '^' + billingState + '^' + billingPostalCode + '^' + countryCode + '^');
            strPID += '|' + ''; //Country Code - No elixir field
            strPID += '|' + phone +'';
            strPID += '|' + ''; //Phone Business Number
            strPID += '|' + ''; // Primary Language - No elixir field
            strPID += '|' + ''; // Marital Status - No elixir field
            strPID += '|' + ''; // Religion - No elixir field
            strPID += '|' + accountNumber;
            strPID += '|' + lastFourDigitsSSN;
            strPID += '|' + ''; // patient's driver license number
            strPID += '|' + ''; // monther's identifier
            strPID += '|' + ''; // ethnic group
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
            strPID += '|' + lastModifiedDateTime; //last update date/time
            strPID += '|' + sendFacility; //last update facility
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