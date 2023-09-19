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
    public static string getLastModifiedDateTime(datetime dtTime) { //converted to utc
        //DateTime lastModifiedDateTime = getAccount(accountId).LastModifiedDate;
        return dtTime.format('yyyyMMddHHmmssZ');
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
            //ElixirSuite.Exceptionlog.logDebugString('This Patient Does not Exist'+ ex.getMessage());
        }
        return null;
    }   
   /* //GT1
    public static List<Contact> getContactDetail(String accountId){
        List<Contact> contactList = [select Id,Name,FirstName,LastName,MailingStreet,MailingCity,
                                     MailingState,MailingPostalCode,
                                     MailingCountry,Birthdate,
                                     ElixirSuite__Gender__c,MobilePhone,
                                     Phone FROM CONTACT WHERE AccountId=:accountId AND recordtype.name ='Contact'
                                     AND Guarantor__c = TRUE WITH SECURITY_ENFORCED Limit 10];
        if(contactList.size()>0){
            return contactList;
        }
        return null;
    }
    */
    //Get Next of Kin Details of the Patient (to get NK1) 
    public static List<Contact> getContacts(String accountId){  
        
        Id ContactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();        
        List<Contact> contactList = [select Id,Name,FirstName,LastName,MailingStreet,MailingCity,
                                     MailingState,MailingPostalCode,
                                     MailingCountry,Birthdate,
                                     ElixirSuite__Gender__c,MobilePhone,
                                     Phone FROM CONTACT WHERE AccountId=:accountId AND Contact.RecordTypeId =:ContactRecordTypeId
                                     WITH SECURITY_ENFORCED Limit 10];
        
        if(contactList.size()>0){
            return contactList;
        }
        return null;
    }
    
    
  
    //Get Care Episode for PV1 (Patient Visit)  changed the query where before it will return only active visits now it return all statuses
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
    
    
    //Get Medical Examination - Allergy (AL1)
    Public static List<ElixirSuite__Medical_Examination__c> getPatientAllergy(String accountId){
        Id allergyRecordTypeId = Schema.SObjectType.ElixirSuite__Medical_Examination__c.getRecordTypeInfosByDeveloperName().get('Allergy').getRecordTypeId();
        List<ElixirSuite__Medical_Examination__c> patientAllergyList = [ select id, Name, ElixirSuite__Category__c, 
                                                                        ElixirSuite__Allergy_Name__c, ElixirSuite__Allergy_Status__c, ElixirSuite__Severity__c, 
                                                                        ElixirSuite__Reaction__c 
                                                                        FROM ElixirSuite__Medical_Examination__c 
                                                                        WHERE ElixirSuite__Account__c = :accountId AND RecordTypeId = :allergyRecordTypeId 
                                                                        WITH SECURITY_ENFORCED Limit 10];
        
        if(patientAllergyList.size()>0){
            return patientAllergyList;
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
    //AllergyType Code
  /*  public static String getAllergyTypeCodes(String allergyType) {
        List<Allergy_Type_Code__mdt> mdtCode = new List<Allergy_Type_Code__mdt>();
        if (AllergyType != null) {
            //Searching the code in both Label
            
            mdtCode = [SELECT Label, Code__c
                       FROM Allergy_Type_Code__mdt
                       WHERE Label = :allergyType WITH SECURITY_ENFORCED Limit 10];
        }
        
        if (!mdtCode.isEmpty()) {
            return mdtCode[0].Code__c;
        } 
        else {
            return '';
        }
    }
    // Allergy Severity Code
    public static String getAllergySeverityCodes(String allergySeverity) {
        List<Allergy_Severity_Code__mdt> mdtType = new List<Allergy_Severity_Code__mdt>();
        //Searching the code in both Label and Code__c
        mdtType = [SELECT Label, Code__c
                   FROM Allergy_Severity_Code__mdt
                   WHERE Label = :allergySeverity WITH SECURITY_ENFORCED Limit 10];
        if (!mdtType.isEmpty()) {
            return mdtType[0].Code__c;
        } 
        else {
            
            return '';
        }
        
    }*/
    
  /*  //Get Lab Orders for an account
    Public static List<ElixirSuite__Lab_Order__c> getLabOrder(String accountId, String labOrderId){
        List<ElixirSuite__Lab_Order__c> labOrderData =[ Select Id, Name,ElixirSuite__LabName__c,
                                                       ElixirSuite__Lab_Order_Req__c,ElixirSuite__Status__c,
                                                       ElixirSuite__Physician_Name__c,ElixirSuite__Expected_Date_Time__c,
                                                       ElixirSuite__Order_Type__c,CreatedDate,ElixirSuite__Collection_Date_Time__c,
                                                       ElixirSuite__Test_Name__c,ElixirSuite__Doctors_Note__c
                                                       FROM ElixirSuite__Lab_Order__c where 
                                                       ElixirSuite__Account_Id__c = :accountId AND ElixirSuite__Lab_Order_Req__c=:labOrderId WITH SECURITY_ENFORCED Limit 10];
        if(labOrderData.size() > 0){
            return labOrderData;
        }
        //ElixirSuite.Exceptionlog.logDebugString('There are no lab orders for this Patient');   //Change 1
        return null;
    }*/
    
    //Get Dummy Lab Orders for an account
    Public static List<ElixirSuite__UA_Sample_Details__c> getDummyLabOrder(String accountId,String labOrderName){
        List<ElixirSuite__UA_Sample_Details__c> dummyLabOrderData =[ Select Id, Name,ElixirSuite__Medical_Test__c,
                                                                    ElixirSuite__Status__c,ElixirSuite__Collection_Datetime__c,
                                                                    ElixirSuite__Sample_Type__c,ElixirSuite__Order_By__r.Name,
                                                                    ElixirSuite__Order_By__r.LastName,ElixirSuite__Order_By__r.FirstName,
                                                                    CreatedDate,CreatedById,ElixirSuite__Lab_Name__c
                                                                    FROM ElixirSuite__UA_Sample_Details__c where 
                                                                    ElixirSuite__Account__c = :accountId and Name =:labOrderName WITH SECURITY_ENFORCED
                                                                    LIMIT 1];
        if(dummyLabOrderData.size() > 0){
            return dummyLabOrderData;
        }
        //ElixirSuite.Exceptionlog.logDebugString('There are no lab orders for this Patient');   //Change 1
        return null;
    }
    
    //Retrieve lab tests and its corresponding lab results for a lab order - both in single shot
    public static List<ElixirSuite__LabOrder_Hl7_Results_Tests_Info__c> getLabOrderTestAndResults(String labOrderId){
        List<ElixirSuite__LabOrder_Hl7_Results_Tests_Info__c> labTestsList 
            = [Select id, name, ElixirSuite__Test_Result_Name__c, ElixirSuite__Results_RptStatus_Change_Date_Time__c,
               ElixirSuite__Result_Status__c,               
               (Select id, Name, ElixirSuite__Observation_Value_type__c, ElixirSuite__Observe_Result_Status__c, 
                ElixirSuite__Observation_Identifier_Analyte_Code__c, ElixirSuite__Observation_Identifier_Analyte_Descrip__c, 
                ElixirSuite__Observation_Value_Numeric__c, ElixirSuite__Observation_Value_Text__c, ElixirSuite__Observation_Value_TextAREA__c,
                ElixirSuite__Observation_Value_ImageSource__c, ElixirSuite__Observation_Value_Image_Data_type__c, ElixirSuite__Observation_Value_Image_Data_subtype__c,
                ElixirSuite__Observation_Value_ImageEncoding_format__c,ElixirSuite__Observation_Value_Image__c,
                ElixirSuite__Units__c, ElixirSuite__References_Range__c, ElixirSuite__Observation_Value__c, ElixirSuite__Date_Time_Of_Observation__c,
                ElixirSuite__Notes__c
                FROM ElixirSuite__Test_Result_Details__r) 
               
               FROM ElixirSuite__LabOrder_Hl7_Results_Tests_Info__c WHERE ElixirSuite__Lab_Order_Id__r.ElixirSuite__Lab_Order_Req__c=:labOrderId];
        if(labTestsList.size()>0){
            return labTestsList;
        }
        //ElixirSuite.Exceptionlog.logDebugString('There are no lab results for this Patient'); //Change 2
        return null;
    }
    
    //Retrieve Event Information
    public static List<Event> getEventInfo(String accountId)
    {
        List<Event> eventInfo =[Select Id, Subject,WhatId, OwnerId, Owner.FirstName, Owner.LastName, StartDateTime,DurationInMinutes, ElixirSuite__Reason__c, CreatedById, CreatedBy.Name,
                                CreatedBy.FirstName, CreatedBy.LastName, EndDateTime,
                                ElixirSuite__Rooms__r.Name,ElixirSuite__Rooms__r.Id,
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.Name, 
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.ElixirSuite__Address_1__c,
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.ElixirSuite__Country__c,
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.ElixirSuite__State__c,
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.ElixirSuite__City__c,
                                ElixirSuite__Rooms__r.ElixirSuite__Treatment_Center__r.ElixirSuite__Zip_Postal_Code__c
                                from Event where StartDateTime>= today AND 
                                WhatId =: accountId
                                ORDER BY StartDateTime ASC Limit 1];
        
        if(eventInfo.size()>0){
            return eventInfo;
        }
        return null;
        
    }
    //Retrieve Event Contact Information
    public static List<EventWhoRelation > getEventContactInfo(String eventId)
    {
        List<EventWhoRelation > eventInfo = new List<EventWhoRelation >();
        
        eventInfo= [Select Id, RelationId, Relation.FirstName, Relation.LastName,EventId, AccountId
                    from EventWhoRelation where EventId =: eventId AND RelationId != null AND Relation.type='Contact'];
        
        if(eventInfo.size()>0){
            return eventInfo;     
        }
        return null;  
    }
    
    
    public static List<Contact> getEventContactPrefix(String relationId){
        List<Contact> contacts = [ SELECT Id, Salutation FROM Contact WHERE Id =:relationId ];
        if (!contacts.isEmpty()) {
            return contacts;
        }
        return null;
    }
    
    public static List<ElixirSuite__Prescription_Order__c> getPrescriptionOrder(String accountId){
        List<ElixirSuite__Prescription_Order__c> getPrescription = [ SELECT Id, ElixirSuite__Drug_Name__c, ElixirSuite__Patient_SIG__c,
                                                                    ElixirSuite__Dispense_NC__c, ElixirSuite__Dosage_Form__c, ElixirSuite__Pharmacy_NC__c,
                                                                    ElixirSuite__Route_New__c, ElixirSuite__Refills__c 
                                                                    FROM ElixirSuite__Prescription_Order__c WHERE ElixirSuite__Account__c =:accountId WITH SECURITY_ENFORCED];
        if (!getPrescription.isEmpty()) {
            return getPrescription;
        }
        //ElixirSuite.Exceptionlog.logDebugString('We\'ve not found any Prescriptions for this Patient');
        return null;
    }
    public static String getPrescriptionValue() {
        String prescriptionPriority = null;
        
        try {
            ElixirSuite__TabPermissionBasedOnProfiles__c customSetting = ElixirSuite__TabPermissionBasedOnProfiles__c.getInstance();
            // String customSetting = [Select ElixirSuite__LabOrder_Priority__c from ElixirSuite__TabPermissionBasedOnProfiles__c];
            if (customSetting != null) {
                prescriptionPriority = customSetting.ElixirSuite__Prescription_Priority__c;
            }
        } catch (Exception e) {
            // Handle any exceptions or errors that occur during the retrieval process
            System.debug('An error occurred while retrieving the Lab Order Priority value: ' + e.getMessage());
        }
        
        return prescriptionPriority;
    }
    
    public static List<ElixirSuite__Frequency__c> getDummyPrescription(String accountId){
        List<ElixirSuite__Frequency__c> getPrescription = [ SELECT Id, ElixirSuite__Strength_1__c,ElixirSuite__Unit_1__c, ElixirSuite__Quantity_1__c,
                                                           ElixirSuite__Prescription_Order__r.ElixirSuite__Drug_Name__c, ElixirSuite__Prescription_Order__r.ElixirSuite__Dosage_Form__c,ElixirSuite__Prescription_Order__r.ElixirSuite__Route_New__c
                                                           FROM ElixirSuite__Frequency__c 
                                                           WHERE ElixirSuite__Prescription_Order__r.ElixirSuite__Account__c =:accountId and ElixirSuite__Prescription_Order__r.RecordType.DeveloperName = 'Medication' 
                                                           WITH SECURITY_ENFORCED Order by createddate desc];
        if (!getPrescription.isEmpty()) {
            return getPrescription;
        }
        //ElixirSuite.Exceptionlog.logDebugString('We\'ve not found any Prescriptions for this Patient');
        return null;
    }
    public static String getLabOrderValue() {
        String labOrderPriority = null;
        
        try {
            ElixirSuite__TabPermissionBasedOnProfiles__c customSetting = ElixirSuite__TabPermissionBasedOnProfiles__c.getInstance();
            // String customSetting = [Select ElixirSuite__LabOrder_Priority__c from ElixirSuite__TabPermissionBasedOnProfiles__c];
            if (customSetting != null) {
                labOrderPriority = customSetting.ElixirSuite__LabOrder_Priority__c;
            }
        } catch (Exception e) {
            // Handle any exceptions or errors that occur during the retrieval process
            System.debug('An error occurred while retrieving the Lab Order Priority value: ' + e.getMessage());
        }
        
        return labOrderPriority;
    }
    //Get Practitioner Location
    Public static List<ElixirSuite__UserLocation__c> getPractitionerLocation(String contactId){
        Id ContactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Practitioner').getRecordTypeId();
        List<ElixirSuite__UserLocation__c> practitionerLocation =[Select Id, ElixirSuite__Provider__c, 
                                                                  ElixirSuite__Specialty__c,ElixirSuite__Specialty__r.ElixirSuite__Specialty_Name__c, ElixirSuite__Practitioner__c,ElixirSuite__Practitioner__r.Salutation , 
                                                                  ElixirSuite__Practitioner__r.FirstName , ElixirSuite__Practitioner__r.LastName, ElixirSuite__Practitioner__r.MiddleName,ElixirSuite__Practitioner__r.RecordTypeId
                                                                  FROM ElixirSuite__UserLocation__c 
                                                                  where ElixirSuite__Practitioner__c=:contactId AND ElixirSuite__Practitioner__r.RecordTypeId = :ContactRecordTypeId
                                                                  WITH SECURITY_ENFORCED Limit 10];
        if(practitionerLocation.size()>0){
            return practitionerLocation;
        }
        return null;
    }
    Public static List<contact> getPractitioner(String contactId){
        Id ContactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('Practitioner').getRecordTypeId();
        List<Contact> practitioner =[Select id, firstname, lastname, salutation, RecordTypeId 
                                     from contact 
                                     where id=:contactId AND RecordTypeId = :ContactRecordTypeId
                                     WITH SECURITY_ENFORCED Limit 10];
        if(practitioner.size()>0){
            return practitioner;
        }
        return null;
    }
    Public static List<ElixirSuite__Dataset1__c> getPatientProblem(String accountId){
        Id AccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Patient_Account').getRecordTypeId();
        List<ElixirSuite__Dataset1__c> patientProblem =[Select Id, Name, ElixirSuite__Account__r.id,ElixirSuite__Account__r.name,ElixirSuite__SNOMED_CT_Code__c, ElixirSuite__Care_Episode__r.name,
                                                        ElixirSuite__Status__c, ElixirSuite__Date_Onset__c,ElixirSuite__Account__r.RecordTypeId,
                                                        ElixirSuite__Problem_Type__c
                                                        from ElixirSuite__Dataset1__c 
                                                        where ElixirSuite__Account__r.id=:accountId AND ElixirSuite__Account__r.RecordType.id = :AccountRecordTypeId
                                                        WITH SECURITY_ENFORCED Limit 10];
        if(patientProblem.size()>0){
            return patientProblem;
        }
        return null;
    }    
    
    
    /*public static List<RecordType> getProgressNoteId(String accountId){
List<RecordType> ProgressNoteID = [  SELECT Id, Name, DeveloperName, SobjectType FROM RecordType 
WHERE Name Like '%Progress%' AND SobjectType ='Form_Object1__c'
ORDER BY Createddate desc LIMIT 1 ];
if (!ProgressNoteID.isEmpty()) {
return ProgressNoteID;
}
//ElixirSuite.Exceptionlog.logDebugString('We\'ve not found any Progress Note Record Type for this Patient');
return null;
}*/
    
    public static List<Form_Object1__c> getProgressNote(String accountId){
        List<Form_Object1__c> ProgressNote = [  SELECT Id, Name, RecordTypeId, AccountId__c ,LastModifiedDate, CreatedById,CreatedDate,Form_Name__c,
                                              CreatedBy.FirstName, CreatedBy.LastName,LastModifiedById,LastModifiedBy.LastName, LastModifiedBy.FirstName,
                                              Form_unique_id__c,Form_RecordType_Name__c
                                              
                                              FROM Form_Object1__c
                                              WHERE AccountId__c  =: accountId AND Form_RecordType_Name__c Like '%Progress%' ORDER BY Createddate desc LIMIT 1 ];
        if (!ProgressNote.isEmpty()) {
            return ProgressNote;
        }
         //ElixirSuite.Exceptionlog.logDebugString('We\'ve not found any Progress Note for this Patient');
        return null;
    }
    public static List<ElixirSuite__Form_Value__c > getProgressNoteApprovals(String FormUniqueId){
        List<ElixirSuite__Form_Value__c > Approvals = [  SELECT Id, Name,ElixirSuite__Approval_Level__c,ElixirSuite__Approved_Signature__c,
                                                       ElixirSuite__Date_Of_Approval__c,ElixirSuite__Form_Id__c,ElixirSuite__Signed_Patient__c, ElixirSuite__Signed_Patient__r.ElixirSuite__Last_Name__c,
                                                       ElixirSuite__Signed_Patient__r.ElixirSuite__First_Name__c,ElixirSuite__User__c,ElixirSuite__User__r.LastName, ElixirSuite__User__r.FirstName
                                                       FROM ElixirSuite__Form_Value__c where ElixirSuite__Form_Id__c =:FormUniqueId Order by createddate desc LIMIT 1];
        if (!Approvals.isEmpty()) {
            return Approvals;
        }
        
        return null;
    }   
 
}