@isTest
public class HL7ADTMessageGeneratorTest {
    @isTest
    public static void getADTMessageTest(){
        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Patient_Account').getRecordTypeId(),
            ElixirSuite__Last_Name__c = 'Doe',
            ElixirSuite__First_Name__c = 'John',
            BillingStreet = '123 Test Street',
            BillingCity = 'Test City',
            BillingState = 'Test State',
            BillingPostalCode = '12345',
            ElixirSuite__Account_Number__c = 'ACCT123',
            ElixirSuite__SSN__c = '123-45-6789',
            Phone = '123-456-7890',
            ElixirSuite__Gender__c = 'Male'
            // Set other required fields for the Account as needed
        );
        insert testAccount;
        
        ElixirSuite__ICD_Codes__c diagnosisCode = new ElixirSuite__ICD_Codes__c();
        diagnosisCode.ElixirSuite__Account__c = testAccount.Id;
        diagnosisCode.ElixirSuite__Diagnosis_Type__c = 'Primary';
        insert diagnosisCode;
        
        ElixirSuite__Visits__c objVisit = new ElixirSuite__Visits__c();
        objVisit.Name = 'Test Visit' ;
        objVisit.ElixirSuite__Account__c = testAccount.Id;  
        objVisit.ElixirSuite__Status__c = 'Active';
        objVisit.Service_Type__c = 'MHRS - COUNSELING - COMMUNITY BASED';
   
        insert objVisit;
        
         ElixirSuite__Procedure__c testProcedure1 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 3',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = testAccount.Id
        );
        //insert testProcedure1;
        
        ElixirSuite__Procedure__c testProcedure2 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 2',
            ElixirSuite__Code_Category__c = 'HCPCS Level 1',
            ElixirSuite__Code_Description__c = 'Procedure Description 2',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
             ElixirSuite__Modifier3__c=testProcedure1.Id,
             ElixirSuite__Account__c = testAccount.Id
        );
        
        List<ElixirSuite__Procedure__c> procedureList = new List<ElixirSuite__Procedure__c>{testProcedure1,testProcedure2};
        insert procedureList;
        
        
       ElixirSuite__VOB__c testInsurance1 = new ElixirSuite__VOB__c(
            ElixirSuite__Insurance_Plan_Name__c = 'Plan1',
            ElixirSuite__Group_Number__c = 'Group1',
            ElixirSuite__Group_Name__c = 'Group Name1',
            ElixirSuite__Account__c = testAccount.Id
        );

        ElixirSuite__VOB__c testInsurance2 = new ElixirSuite__VOB__c(
            ElixirSuite__Insurance_Plan_Name__c = 'Plan2',
            ElixirSuite__Group_Number__c = 'Group2',
            ElixirSuite__Group_Name__c = 'Group Name2',
            ElixirSuite__Account__c = testAccount.Id
        );

        List<ElixirSuite__VOB__c> insurenceList = new List<ElixirSuite__VOB__c>{testInsurance1,testInsurance2};
         insert insurenceList;   
        
        // Associate insurance with insurance result
        ElixirSuite__Result__c testInsuranceResult = new ElixirSuite__Result__c(
            ElixirSuite__Plan_Begin_Date__c = Date.today(),
            ElixirSuite__Plan_End_Date__c = Date.today().addDays(30),
            ElixirSuite__Eligibility_Result_Date__c = Date.today(),
            ElixirSuite__VOB__c = testInsurance1.Id
        );
        insert testInsuranceResult;
        
        Test.startTest();
        HL7ADTMessageGenerator.getADTMessage(testAccount.Id, objVisit.Id, 'ADT');
        HL7ADTMessageGenerator.getADTMessage('INVALIDID','INVALIDID','INVALIDID');
        Test.stopTest();

        
    }
}