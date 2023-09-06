trigger VisitTrigger on ElixirSuite__Visits__c (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        VisitTriggerHandler.afterVisitInsert(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        VisitTriggerHandler.afterVisitUpdate(Trigger.new,Trigger.oldMap);
    }
}