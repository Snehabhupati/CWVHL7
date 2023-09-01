@isTest
public class TestVisitHandler {
    @isTest
    public static void getADTMessage() {
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        
        ElixirSuite__ICD_Codes__c diagnosisCode = new ElixirSuite__ICD_Codes__c();
        diagnosisCode.ElixirSuite__Account__c = acc.Id;
        diagnosisCode.ElixirSuite__Diagnosis_Type__c = 'Primary';
        insert diagnosisCode;
        
        
        
        ElixirSuite__Visits__c objVisit = new ElixirSuite__Visits__c();
        objVisit.Name = 'Test Visit' ;
        objVisit.ElixirSuite__Account__c = acc.Id;  
        objVisit.ElixirSuite__Visit_Start__c = DateTime.newInstance(2023, 8, 30, 0, 0, 0);
        
        insert objVisit;
        
        ElixirSuite__VOB__c testInsurance1 = new ElixirSuite__VOB__c(
            ElixirSuite__Insurance_Plan_Name__c = 'Plan1',
            ElixirSuite__Group_Number__c = 'Group1',
            ElixirSuite__Group_Name__c = 'Group Name1',
            ElixirSuite__Account__c = acc.Id
        );
        insert testInsurance1;
        
         ElixirSuite__Procedure__c testProcedure1 = new ElixirSuite__Procedure__c(
            Name = 'Procedure 3',
            ElixirSuite__Code_Category__c = 'Modifier',
            ElixirSuite__Code_Description__c = 'Modifier Description 1',
            ElixirSuite__From_Date_of_Service__c = Date.today(),
            ElixirSuite__To_Date_of_Service__c=Date.today(), 
            ElixirSuite__Account__c = acc.Id
        );
        insert testProcedure1;
        
        
        Test.startTest();
        VisitHandler.getADTMessage(acc.Id, objVisit.Id, 'ADT');
        Test.stopTest();
    }
    
}