@isTest
public class HL7SegmentEncoderROLTest {
   /* @isTest
    public static void generateROLSegmentTest(){
        ElixirSuite__Procedure__c objProcedure = new ElixirSuite__Procedure__c();
        
        objProcedure.Name = 'Test Procedure';
        objProcedure.ElixirSuite__Code_Category__c = 'Modifier';
        objProcedure.ElixirSuite__Code_Description__c = 'Modifier Description 1';
        objProcedure.ElixirSuite__From_Date_of_Service__c = Date.today();
        objProcedure.ElixirSuite__To_Date_of_Service__c=Date.today();
        
        
        insert objProcedure;
        ElixirSuite__Procedure__c objProcedures = [Select Id, Name,
                                                   ElixirSuite__To_Date_of_Service__c, ElixirSuite__Code_Category__c,
                                                   CreatedBy.LastName , CreatedBy.PostalCode, CreatedBy.Profile.Name, CreatedBy.FirstName , CreatedBy.CompanyName , CreatedBy.City ,CreatedBy.State , CreatedBy.Street , CreatedBy.Country ,CreatedBy.Phone, CreatedBy.Address
                                                   FROM ElixirSuite__Procedure__c WHERE Id =: objProcedure.Id  WITH SECURITY_ENFORCED Limit 1];
        Test.startTest();
        String strROL = HL7SegmentEncoderROL.generateROLSegment(objProcedures);
        HL7SegmentEncoderROL.generateROLSegment(null);
        System.assertNotEquals('', strROL);
        System.assertEquals(true, strROL.contains('ROL|'));
        Test.stopTest();
    }*/
    
}