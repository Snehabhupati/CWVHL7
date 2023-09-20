/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7GeneralUtil {
    
   
    //Setup -> Company Information
    public static Organization getCompanyInformation(){
        Organization cmpInfo = [SELECT Id, Name,Phone,LanguageLocaleKey,Street, City, State, PostalCode, Country FROM Organization WITH SECURITY_ENFORCED Limit 1];
        return cmpInfo;
    }
  
    
    //Get the right trigger event (e.g. A01=Admin, A03=Discharge)
    public static string getTriggerEvent(String accountId, String visitId){
        list<ElixirSuite__Visits__c> objVisit = HL7GeneralUtil.getCareEpisode(accountId,visitId );
        if(objVisit[0].ElixirSuite__Status__c == 'Active') {
            return 'A01';
        }
        else if(objVisit[0].ElixirSuite__Status__c == 'Closed') {
            return 'A03';
        }
        else{
            return '';
        }
    }    
    
    //Date in yyyyMMdd e.g. 20230505
    public static string getDateTimeFormat(Date dt){
        DateTime dTime = DateTime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
        String formattedDate = dTime.format('yyyyMMdd');
        System.debug('formattedDate @' +formattedDate);
        if(formattedDate != null){
            return formattedDate; 
        }else{
            return '';
        }
    }
    
    //Time in UTC e.g. 20230512044649-0400
    public static string getCurrentDateTime() { 
        DateTime currentDateTime = System.now();        
        return currentDateTime.format('yyyyMMddHHmmssZ');
    }
    public static string getModifiedDateTime(datetime dtTime) { //converted to utc
        if(dtTime != null){
             return dtTime.format('yyyyMMddHHmmssZ');
        }else{
             return null;
        }
    }
    
    //Time in Milliseconds 20230512044649994 (17-digit unique number)
    public static string getCurrentDateTimeInMilliSecods() {
        DateTime currentDateTime = System.now();
        return currentDateTime.format('yyyyMMddHHmmssSSS');
    }
    
    //Get Account info only if the recordType = 'Patient Account'
    public static Account getAccount(String accountId){  //strip inaccessible        
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Patient_Account').getRecordTypeId();
        Account objAccount;
        try{
            objAccount = [select Id,CreatedDate,ElixirSuite__Current_Status_Of_Patient__c, ElixirSuite__Treatment_Center_Name__c,
                          ElixirSuite__Admit_Date__c,ElixirSuite__dischargeDateNew__c, CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                          ElixirSuite__First_Name__c,ElixirSuite__Last_Name__c, 
                          Phone,ElixirSuite__Patient_s_Birth_Date__c,BillingStreet,
                          ElixirSuite__SSN__c,ElixirSuite__Gender__c,Race__c,Ethnicity__c,
                          ElixirSuite__Deceased__c,ElixirSuite__Deceased_Date__c,
                          AccountNumber,BillingCity,BillingState,BillingPostalCode,
                          BillingCountry,BillingAddress,ElixirSuite__birthdate__c,
                          ElixirSuite__Account_Number__c,ElixirSuite__DOB__c,LastModifiedDate,
                          ElixirSuite__MRN_Number_New__c
                          from Account where Id=:accountId AND RecordTypeId = :patientRecordTypeId WITH SECURITY_ENFORCED Limit 1];
            
            if (objAccount != null){
                return objAccount;  
            } 
        }
        catch (Exception ex) {
           System.debug('This Patient Does not Exist'+ ex.getMessage());
        }
        return null;
    }   
  
  
    //Get Care Episode for PV1 (Patient Visit)  
    Public static List<ElixirSuite__Visits__c> getCareEpisode(String accountId, String visitId){
        List<ElixirSuite__Visits__c> careEpisode =[SELECT Id, ElixirSuite__Care_Episode_Location__r.Name,Service_Location__c, 
                                                   ElixirSuite__Admit_Date__c,ElixirSuite__Discharge_Date__c,CreatedBy.FirstName, CreatedBy.LastName, CreatedById,CreatedDate,
                                                   ElixirSuite__Visit_Start__c,ElixirSuite__Visit_End__c,ElixirSuite__Status__c,ElixirSuite__Account__r.ElixirSuite__MRN_Number_New__c,
                                                   Attending_Clinical_Staff__c,Attending_Clinical_Staff__r.ElixirSuite__Provider_First_Name__c,
                                                   Attending_Clinical_Staff__r.ElixirSuite__Provider_Last_Name__c,Attending_Clinical_Staff__r.ElixirSuite__Provider_Code__c
                                                   FROM ElixirSuite__Visits__c 
                                                   WHERE ElixirSuite__Account__c=:accountId and  Id =: visitId
                                                   WITH SECURITY_ENFORCED Limit 1];
        if(careEpisode.size()>0){
            return careEpisode;
        }
        return null;
    }
    
    //Get Medical Coding Procedure for Patient (PR)
    Public static List<ElixirSuite__Procedure__c> getPatientProcedure(String accountId, String visitId){
        List<ElixirSuite__Procedure__c> patientProcedure =[ Select Id, Name, ElixirSuite__Code_Description__c, ElixirSuite__From_Date_of_Service__c,
                                                           ElixirSuite__To_Date_of_Service__c, ElixirSuite__Code_Category__c,
                                                           ElixirSuite__Modifier1__r.Name,ElixirSuite__Modifier1__r.ElixirSuite__Code_Description__c, ElixirSuite__Modifier2__r.Name, ElixirSuite__Modifier2__r.ElixirSuite__Code_Description__c,
                                                           ElixirSuite__Modifier3__r.Name,ElixirSuite__Modifier3__r.ElixirSuite__Code_Description__c, ElixirSuite__Modifier4__r.Name,ElixirSuite__Modifier4__r.ElixirSuite__Code_Description__c,
                                                           CreatedBy.LastName , CreatedBy.PostalCode, CreatedBy.Profile.Name, CreatedBy.FirstName , CreatedBy.CompanyName , CreatedBy.City ,CreatedBy.State , CreatedBy.Street , CreatedBy.Country ,CreatedBy.Phone, CreatedBy.Address
                                                           FROM ElixirSuite__Procedure__c WHERE ElixirSuite__Code_Category__c!=null and ElixirSuite__Account__c=:accountId AND ElixirSuite__Visits__c =: visitId WITH SECURITY_ENFORCED Limit 10];
        if(patientProcedure.size()>0){
            System.debug('patientProcedure  $$' +patientProcedure);
            return patientProcedure;
        }
        return null;
    }
    
 
    //Get Primary Insurance
    Public static List<ElixirSuite__VOB__c> getPrimaryInsurance(String accountId){
        Id insuranceRecordTypeId = Schema.SObjectType.ElixirSuite__VOB__c.getRecordTypeInfosByDeveloperName().get('VOB_record_type').getRecordTypeId();
        List<ElixirSuite__VOB__c> patientInsuranceList = [ select id,ElixirSuite__Insurance_Plan_Name__c,ElixirSuite__Payer__r.ElixirSuite__Payer_Code__c,ElixirSuite__Payer__r.Id,
                                                          ElixirSuite__Payer__r.Name,ElixirSuite__Payer__r.ElixirSuite__Address__c,ElixirSuite__Payer__r.ElixirSuite__City__c,
                                                          ElixirSuite__Payer__r.ElixirSuite__State__c, ElixirSuite__Payer__r.ElixirSuite__Zip_Code__c, ElixirSuite__Gender__c,
                                                          ElixirSuite__Payer__r.ElixirSuite__PhoneNumber__c,ElixirSuite__Group_Number__c,
                                                          ElixirSuite__Group_Name__c,ElixirSuite__Account__c,ElixirSuite__Card_Issue_Date__c,
                                                          ElixirSuite__Insurance_Type__c,ElixirSuite__Insured_First_Name__c,ElixirSuite__Insured_Last_Name__c,
                                                          ElixirSuite__Patient_Relationship_With_Insured__c,ElixirSuite__Date_Of_Birth__c,
                                                          ElixirSuite__Insured_Address__c,ElixirSuite__Insured_City__c, ElixirSuite__Insured_State__c, 
                                                          ElixirSuite__Insured_Zipcode__c,ElixirSuite__Insured_Country__c,ElixirSuite__Insured_Policy_Group_FECA_Number__c,
                                                          ElixirSuite__VOB_Verification_Status__c,ElixirSuite__Insured_SSN__c
                                                          FROM ElixirSuite__VOB__c 
                                                          WHERE ElixirSuite__Account__c = :accountId AND RecordTypeId = :insuranceRecordTypeId
                                                          AND ElixirSuite__Insurance_Plan_Name__c!=NULL
                                                          WITH SECURITY_ENFORCED Limit 10];
        
        if(patientInsuranceList.size()>0){
            return patientInsuranceList;
        }
        return null;
    }
    Public static List<ElixirSuite__Result__c> getInsuranceResult(String InsuranceId){
        List<ElixirSuite__Result__c>patientInsuranceResultList = [ select id,ElixirSuite__Eligibility_Result_Date__c,
                                                                  ElixirSuite__Plan_Begin_Date__c,ElixirSuite__Plan_End_Date__c
                                                                  FROM ElixirSuite__Result__c 
                                                                  WHERE ElixirSuite__VOB__c = :InsuranceId
                                                                  WITH SECURITY_ENFORCED Limit 10];
        
        if(patientInsuranceResultList.size()>0){
            return patientInsuranceResultList;
        }
        return null;
    }
    //getgetDiagnosis codes
    Public static List<ElixirSuite__Diagnosis_Code__c> getDiagnosis(String accountId){
        
        List<ElixirSuite__Diagnosis_Code__c> PatientList =  [SELECT ID,Name,
                                                             ElixirSuite__Problem__r.Name, ElixirSuite__Problem__r.ElixirSuite__Date_Diagonised__c,         
                                                             ElixirSuite__Problem__r.ElixirSuite__Note__c, 
                                                             ElixirSuite__Diagnosis_Code__r.Id,ElixirSuite__Diagnosis_Code__r.ElixirSuite__Diagnosis_Type__c,ElixirSuite__Diagnosis_Code__r.ElixirSuite__Code_Description1__c,ElixirSuite__Diagnosis_Code__r.Name,
                                                             ElixirSuite__Diagnosis_Code__r.ElixirSuite__Version__c,CreatedDate,CreatedBy.Name,LastModifiedDate, ElixirSuite__Diagnosis_Code__r.ElixirSuite__Effective_Date__c
                                                             FROM ElixirSuite__Diagnosis_Code__c 
                                                             WHERE (ElixirSuite__Problem__r.ElixirSuite__Account__c =: accountId OR 
                                                                    ElixirSuite__Diagnosis_Code__r.ElixirSuite__Account__c =:accountId) AND ElixirSuite__Diagnosis_Code__r.ElixirSuite__Diagnosis_Type__c  != 'NONE' AND  IsDeleted = false  Limit 10];
        
        
        if(PatientList.size()>0){            
            return PatientList;
        }
        return null;
    }

   
}