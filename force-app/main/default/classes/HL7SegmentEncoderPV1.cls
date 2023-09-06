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
            Account objAccount = HL7GeneralUtil.getAccount(accountId);
            List<ElixirSuite__Visits__c> careEpisode = new List<ElixirSuite__Visits__c>();
            
            if (HL7GeneralUtil.getCareEpisode(accountId, visitId) != null && HL7GeneralUtil.getCareEpisode(accountId, visitId).size() > 0) {
                careEpisode = HL7GeneralUtil.getCareEpisode(accountId, visitId);
            }
            
            String  mdtFacility = HL7CodeMappings.SendingFacility;
            if (mdtFacility != null) {
                sendFacility = mdtFacility;
            }
            
            if (careEpisode != null && careEpisode.size() > 0) {
                if (careEpisode[0].ElixirSuite__Visit_Start__c != null) {
                    DateTime dt = careEpisode[0].ElixirSuite__Visit_Start__c;
                    formattedAdmitDate = dt.format('yyyyMMddHHmmssZ');
                }
                if (careEpisode[0].ElixirSuite__Visit_End__c != null) {
                    DateTime dt = careEpisode[0].ElixirSuite__Visit_End__c;
                    formattedDischargeDate = dt.format('yyyyMMddHHmmssZ');
                }
            }
            sendFacility =HL7HelperClass.replaceSpecialCharacters(sendFacility);
            String pv1Segment =  'PV1';
            pv1Segment += '|';
            pv1Segment += '|O';
            if (careEpisode != null && careEpisode.size() > 0 && careEpisode[0].ElixirSuite__Care_Episode_Location__r != null) {
                String careEpisodeName = careEpisode[0].ElixirSuite__Care_Episode_Location__r.Name;
                String encodedCareEpisodeName = HL7HelperClass.analyze(careEpisodeName, 0);
                pv1Segment += '|' + encodedCareEpisodeName + '^^^' + HL7HelperClass.analyze(sendFacility, 0);
            } else {
                pv1Segment += '|';
            }        
            pv1Segment += '|';
            String mrnNumber = (objAccount.ElixirSuite__MRN_Number_New__c != null) ? objAccount.ElixirSuite__MRN_Number_New__c : '';
            pv1Segment += '|' + (mrnNumber != '' ? mrnNumber + '^^^^MR' : '');
            pv1Segment += '|'; //PriorPatientLocation001
            pv1Segment += '|'; //AttendingDoctor001
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
            pv1Segment += '|'+formattedAdmitDate; // PV1.44 - Admit Date/Time
            pv1Segment += '|'+ formattedDischargeDate; //PV1.45 - Discharge Date/Time
            pv1Segment += '|'; //PV1.38 - Diet Type
            pv1Segment += '|'; //PV1.39 - Servicing Facility
            pv1Segment += '|'; //PV1.40 - Bed Status
            pv1Segment += '|'; 
            pv1Segment += '|'; 
            pv1Segment += '|V';
            pv1Segment += '|'; 
            pv1Segment += '|'; 
            if (careEpisode != null && careEpisode.size() > 0) {
                String careEpisodeId = careEpisode[0].Id;
                pv1Segment += '|' + careEpisodeId;
            } else {
                pv1Segment += '|';
            }
            
            
            System.debug('pv1Segment: ' + pv1Segment);
            
            return pv1Segment + '\n';
        } catch (Exception e) {
            // Log the exception if needed
            System.Debug('Exception Message in PV1'+e.getMessage());
          ElixirSuite__Exception_Log__c objExp = new ElixirSuite__Exception_Log__c();
            objExp.ElixirSuite__Stack_Trace_Long__c = 'Exception occurred in HL7 PV1 Segment:'+ e.getMessage();
            Insert objExp;
            return '';
        }
    }
}