@IsTest
private class HL7SegmentEncoderPIDTest {
    @IsTest
    static void testGeneratePIDSegment() {
        // Create a test Account
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

        // Call the method being tested
        String pidSegment = HL7SegmentEncoderPID.generatePIDSegment(testAccount.Id);

        // Assert the expected values in the generated PID segment
        // Add your assertions here based on the expected values in the pidSegment variable
        // For example:
        // System.assertEquals('PID', pidSegment.substring(0, 3)); // Assert the segment identifier is 'PID'
        // System.assertEquals(testAccount.Id, pidSegment.split('|')[3]); // Assert the Account Id is correct

        // Add more assertions as needed to cover the expected behavior

        // Clean up the test data
        delete testAccount;
    }
}