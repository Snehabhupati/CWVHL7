@IsTest
private class HL7SegmentEncoderIN1Test {
    @IsTest
    static void testGenerateIN1Segment() {
        // Prepare test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        ElixirSuite__VOB__c testInsurance1 = new ElixirSuite__VOB__c(
            ElixirSuite__Insurance_Plan_Name__c = 'Plan1',
            ElixirSuite__Group_Number__c = 'Group1',
            ElixirSuite__Group_Name__c = 'Group Name1',
            ElixirSuite__Account__c = testAccount.Id
        );
        insert testInsurance1;

        ElixirSuite__VOB__c testInsurance2 = new ElixirSuite__VOB__c(
            ElixirSuite__Insurance_Plan_Name__c = 'Plan2',
            ElixirSuite__Group_Number__c = 'Group2',
            ElixirSuite__Group_Name__c = 'Group Name2',
            ElixirSuite__Account__c = testAccount.Id
        );
        insert testInsurance2;

        // Associate insurance with insurance result
        ElixirSuite__Result__c testInsuranceResult = new ElixirSuite__Result__c(
            ElixirSuite__Plan_Begin_Date__c = Date.today(),
            ElixirSuite__Plan_End_Date__c = Date.today().addDays(30),
            ElixirSuite__Eligibility_Result_Date__c = Date.today(),
            ElixirSuite__VOB__c = testInsurance1.Id
        );
        insert testInsuranceResult;

        Test.startTest();
        // Call the method under test
        String result = HL7SegmentEncoderIN1.generateIN1Segment(testAccount.Id);
        Test.stopTest();
    }
}