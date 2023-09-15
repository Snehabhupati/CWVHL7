/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7SegmentEncoderPV1 {
    
    public static string generatePV1Segment(String accountId, String visitId) {
        String sendFacility = '';
        String formattedAdmitDate ='';
        String formattedDischargeDate ='';
        try{
            List<ElixirSuite__Visits__c> careEpisode = HL7GeneralUtil.getCareEpisode(accountId, visitId);
            
            String pv1Segment =  'PV1';
            pv1Segment += '|';
            pv1Segment += '|O';
            if (careEpisode != null && careEpisode.size() > 0 && careEpisode[0].ElixirSuite__Care_Episode_Location__r != null) {
                String careEpisodeName = careEpisode[0].ElixirSuite__Care_Episode_Location__r.Name;
                String encodedCareEpisodeName = HL7HelperClass.analyze(careEpisodeName, 20);
                pv1Segment += '|' + encodedCareEpisodeName + '^^^' + HL7HelperClass.analyze((HL7CodeMappings.SendingFacility), 227);
            } else {
                pv1Segment += '|';
            }        
            pv1Segment += '|';
            String mrnNumber = (careEpisode[0].ElixirSuite__Account__r.ElixirSuite__MRN_Number_New__c != null) ? careEpisode[0].ElixirSuite__Account__r.ElixirSuite__MRN_Number_New__c : '';
            pv1Segment += '|' + (mrnNumber != '' ? mrnNumber + '^^^^MR' : '');
            pv1Segment += '|'; //PriorPatientLocation001
            pv1Segment += '|' + HL7HelperClass.analyze(careEpisode[0].Attending_Clinical_Staff__r.ElixirSuite__Provider_Code__c, 15) + '^'+
                HL7HelperClass.analyze(careEpisode[0].Attending_Clinical_Staff__r.ElixirSuite__Provider_Last_Name__c, 194) + '^'+
                HL7HelperClass.analyze(careEpisode[0].Attending_Clinical_Staff__r.ElixirSuite__Provider_First_Name__c, 30); //AttendingDoctor001
            pv1Segment += '|'; //ReferringDoctor001
            pv1Segment += '|'; //ConsultingDoctor001
            pv1Segment += '|';
            pv1Segment += '|'; //TemporaryLocation001
            pv1Segment += '|'; //ReadmissionIndicator001
            pv1Segment += '|'; //AdmitSource001
            pv1Segment += '|'; //AmbulatoryStatus001
            pv1Segment += '|'; //VIPIndicator001
            pv1Segment += '|'; //AdmittingDoctor001
            pv1Segment += '|'; //PatientType001
            pv1Segment += '|'; //VisitNumber001
            pv1Segment += '|'; //FinancialClass001
            pv1Segment += '|'; //ChargePriceIndicator001
            pv1Segment += '|'; //CourtesyCode001
            pv1Segment += '|'; //CreditRating001
            pv1Segment += '|'; //ContractRole001
            pv1Segment += '|'; //ContractEffectiveDate001
            pv1Segment += '|'; //ContractAmount001
            pv1Segment += '|'; //ContractDate001
            pv1Segment += '|'; //InterestCode001
            pv1Segment += '|'; //TransferToBadDebtCode001 
            pv1Segment += '|'; //PV1.30 - Transfer To Bad Debt Date
            pv1Segment += '|'; //PV1.31 - Bad Debt Agency Code 
            pv1Segment += '|'; //TransferToBadDebtCode001 
            pv1Segment += '|'; //TransferToBadDebtCode001 
            pv1Segment += '|'; //TransferToBadDebtCode001 
            pv1Segment += '|'; //PV1.31 - Bad Debt Agency Code
            pv1Segment += '|'; //PV1.32 - Bad Debt Transfer Amount
            pv1Segment += '|'; //PV1.33 - Bad Debt Recovery Amount
            pv1Segment += '|'; //PV1.34 - Delete Account Indicator
            pv1Segment += '|'; //PV1.35 - 
            pv1Segment += '|'; //PV1.36 - Discharge Disposition
            pv1Segment += '|'; //PV1.37 - Discharged To Location
            pv1Segment += '|'; //PV1.38 - Diet Type
            pv1Segment += '|'; //PV1.39 - Servicing Facility
            pv1Segment += '|'; //PV1.40 - Bed Status
            pv1Segment += '|'+HL7HelperClass.analyze(HL7GeneralUtil.getLastModifiedDateTime(careEpisode[0].ElixirSuite__Visit_Start__c),26); // PV1.44 - Admit Date/Time
            pv1Segment += '|'+HL7HelperClass.analyze(HL7GeneralUtil.getLastModifiedDateTime(careEpisode[0].ElixirSuite__Visit_End__c),26); //PV1.45 - Discharge Date/Time
            pv1Segment += '|'; //PV1.38 - Diet Type
            pv1Segment += '|'; //PV1.39 - Servicing Facility
            pv1Segment += '|'; //PV1.40 - Bed Status
            pv1Segment += '|'; 
            pv1Segment += '|'; 
            pv1Segment += '|V';
            pv1Segment += '|'; 
            pv1Segment += '|'; 
            pv1Segment += '|' + careEpisode[0].Id;
            
            return pv1Segment + '\n';
        } catch (Exception e) {
            System.Debug('Exception Message in PV1'+e.getMessage());
            ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 PV1 Segment:'+ e.getMessage();
            Insert objExp;
            return '';
        }
    }
}