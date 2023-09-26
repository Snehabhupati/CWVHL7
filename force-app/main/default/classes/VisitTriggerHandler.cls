public class VisitTriggerHandler {
    public static void afterVisitInsert(List<ElixirSuite__Visits__c> newVisits) {
        List<HL7_Staging__c> objHL7Messages = new List<HL7_Staging__c>();
        Map<Id,Id> visitAccountMap = new Map<Id,Id>();
        for (ElixirSuite__Visits__c visit : newVisits) {
            visitAccountMap.put(visit.Id,visit.ElixirSuite__Account__c);
        }
        System.debug('HL7LimitsAfterInsertHandler:'+Limits.getQueries());
        if(!visitAccountMap.isEmpty()){ 
            for(ElixirSuite__Visits__c visit : newVisits){
                String ADTMessage = HL7ADTMessageGenerator.getADTMessage(visit.ElixirSuite__Account__c, visit.Id, 'ADT');
                String eventCode =  HL7GeneralUtil.getTriggerEvent(visit.ElixirSuite__Account__c, visit.Id);
                System.debug('HL7LimitsAfterInsertHandler:'+Limits.getQueries());
                if (String.isNotBlank(ADTMessage)) {
                    HL7_Staging__c objHl7 = new HL7_Staging__c();
                    objHl7.HL7_Message__c = ADTMessage;
                    objHl7.AccountID__c = visit.ElixirSuite__Account__c;
                    objHl7.CareEpisodeID__c = visit.Id;
                    objHl7.MessageType__c = 'ADT';
                    objHl7.MessageSubType__c = eventCode;
                    objHL7Messages.add(objHl7);
                }
            }
        }
        
        if (!objHL7Messages.isEmpty()) {
            System.debug('HL7LimitsAfterInsertHandler:'+Limits.getQueries());
            insert objHL7Messages;
            System.debug('HL7LimitsAfterInsertHandler:'+Limits.getQueries());
        }
    }
    
    public static void afterVisitUpdate(List<ElixirSuite__Visits__c> visitsList,Map<Id,ElixirSuite__Visits__c> oldVisitMap){
        List<HL7_Staging__c> objHL7Messages = new List<HL7_Staging__c>();
        System.debug('HL7LimitsAfterUpdatehandler :'+Limits.getQueries());
        Map<Id,Id> visitAccountMap = new Map<Id,Id>();
        for(ElixirSuite__Visits__c visit : visitsList){
            if(oldVisitMap.get(visit.Id).ElixirSuite__Status__c == 'Active' && visit.ElixirSuite__Status__c == 'Closed'){
                if(String.isNotBlank(visit.Id) && String.isNotBlank(visit.ElixirSuite__Account__c)){
                    visitAccountMap.put(visit.Id,visit.ElixirSuite__Account__c);
                }
            }
        }
        if(!visitAccountMap.isEmpty()){
            String eventCode = '';
            List<HL7_Staging__c> HL7StagingRecords = [SELECT Id, MessageSubType__c FROM HL7_Staging__c
                                                      WHERE AccountID__c IN:visitAccountMap.keySet() AND CareEpisodeID__c IN:visitAccountMap.values()
                                                      AND MessageSubType__c = 'A03'];
            System.debug('HL7LimitsAfterUpdatehandler:'+Limits.getQueries());
            if(HL7StagingRecords.isEmpty()){
                for(ElixirSuite__Visits__c visit : visitsList){
                    System.debug('HL7LimitsAfterUpdatehandler:'+Limits.getQueries());
                    String ADTMessage = HL7ADTMessageGenerator.getADTMessage(visit.ElixirSuite__Account__c, visit.Id, 'ADT');
                    // String eventCode =  HL7GeneralUtil.getTriggerEvent(visit.ElixirSuite__Account__c, visit.Id);
                    System.debug('HL7LimitsAfterUpdatehandler:'+Limits.getQueries());
                    if (String.isNotBlank(ADTMessage)) {
                        
                        list<String> segments = ADTMessage.split('\n');
                        String evnSegment = '';
                        for (String segment : segments) {
                            if (segment.startsWith('EVN')) {
                                evnSegment = segment;
                                List<String> fields = evnSegment.split('\\|');
                                eventCode = fields[1];
                                System.debug('eventCode HAndler'+eventCode);
                            }
                        }
                        
                        HL7_Staging__c objHl7 = new HL7_Staging__c();
                        objHl7.HL7_Message__c = ADTMessage;
                        objHl7.AccountID__c = visit.ElixirSuite__Account__c;
                        objHl7.CareEpisodeID__c = visit.Id;
                        objHl7.MessageType__c = 'ADT';
                        objHl7.MessageSubType__c = eventCode;
                        objHL7Messages.add(objHl7);
                        System.debug('HL7LimitsAfterUpdatehandlerinIf:'+Limits.getQueries());
                    }
                }
                if (!objHL7Messages.isEmpty()) {
                    System.debug('HL7LimitsAfterUpdatehandler:'+Limits.getQueries());
                    insert objHL7Messages;
                }
            }
        }
    }
}