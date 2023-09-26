trigger VisitTrigger on ElixirSuite__Visits__c (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('HL7AfterInsertLimits:'+Limits.getQueries());
        VisitTriggerHandler.afterVisitInsert(Trigger.new);
        System.debug('HL7AfterInsertLimits:'+Limits.getQueries());
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('HL7AfterUpdateLimits:'+Limits.getQueries());
        VisitTriggerHandler.afterVisitUpdate(Trigger.new,Trigger.oldMap);
        System.debug('HL7AfterUpdateLimits:'+Limits.getQueries());
    }
}