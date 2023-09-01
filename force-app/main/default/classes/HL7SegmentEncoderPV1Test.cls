@IsTest
private class HL7SegmentEncoderPV1Test {
    @IsTest
    static void testGeneratePV1Segment() {
        // Create a test Account
        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Patient_Account').getRecordTypeId(),
            ElixirSuite__MRN_Number_New__c = 'MRN001' // Set MRN Number for testing
            // Set other required fields for the Account as needed
        );
        insert testAccount;

        ElixirSuite__ICD_Codes__c diagnosisCode = new ElixirSuite__ICD_Codes__c();
        diagnosisCode.ElixirSuite__Account__c = testAccount.Id;
        diagnosisCode.ElixirSuite__Diagnosis_Type__c = 'Primary';
        insert diagnosisCode;
        
        // Create a test Visit record
        ElixirSuite__Visits__c testVisit = new ElixirSuite__Visits__c(
            ElixirSuite__Account__c = testAccount.Id,
            ElixirSuite__Visit_Start__c = DateTime.newInstance(2023, 1, 1, 0, 0, 0),
            ElixirSuite__Visit_End__c = DateTime.newInstance(2023, 1, 2, 0, 0, 0)         // Set other required fields for the Visit as needed
        );
        insert testVisit;


        // Call the method being tested
        Test.startTest(); 
        String pv1Segment = HL7SegmentEncoderPV1.generatePV1Segment(testAccount.Id, testVisit.Id);
        Test.stoptest();
        // Assert the expected values in the generated PV1 segment
        System.assertEquals('PV1', pv1Segment.substring(0, 3)); // Assert the segment identifier is 'PV1'
        System.assertEquals('|', pv1Segment.split('|')[3]); // Assert the patient class is empty ('|')
        System.assertEquals('|', pv1Segment.split('|')[4]); // Assert the patient class is an empty string ('')


    }

    @IsTest
    static void testGeneratePV1Segment_NullAccount() {
        // Call the method being tested with a null Account Id
        String pv1Segment = HL7SegmentEncoderPV1.generatePV1Segment(null,null);

        // Assert the expected behavior when the Account Id is null
        System.assertEquals('', pv1Segment); // Assert that the PV1 segment is an empty string

        // No need to clean up test data as no Account is created
    }
}