public with sharing class ProjectController {
  @AuraEnabled(cacheable=true)
  public static List<Project__c> getProjectList() {
    return [
      SELECT Name, Status__c, StartDate__c, EndDate__c, Budget__c
      FROM Project__c
    ];
  }
}
