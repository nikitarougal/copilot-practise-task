trigger IssueTrigger on Issue__c(after insert, after update) {
  IssueTriggerHandler.UpdateRelatedProjects(Trigger.new);
}
