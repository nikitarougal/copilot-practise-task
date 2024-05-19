public with sharing class IssueTriggerHandler {
  public static void updateRelatedProjects(List<Issue__c> issues) {
    // Initialize a set to store the IDs of related projects
    Set<Id> projectIds = new Set<Id>();

    // Loop over each issue to collect related project IDs
    for (Issue__c issue : issues) {
      if (issue.Severity__c == 'Critical') {
        projectIds.add(issue.RelatedProject__c);
      }
    }

    // Query all related projects outside the loop
    Map<Id, Project__c> projectsToUpdate = new Map<Id, Project__c>(
      [SELECT Id, Status__c FROM Project__c WHERE Id IN :projectIds]
    );

    // Loop over the map to update the project statuses
    for (Project__c project : projectsToUpdate.values()) {
      if (project.Status__c != 'On Hold') {
        project.Status__c = 'On Hold';
      }
    }

    // Perform a DML operation with error handling
    try {
      update projectsToUpdate.values();
    } catch (DmlException e) {
      // Log the exception
      System.debug('DML Exception: ' + e.getMessage());

      // Use Database.update to handle partial success
      Database.SaveResult[] saveResults = Database.update(
        projectsToUpdate.values(),
        false
      );

      // Check for errors and throw a custom exception with user-friendly message
      String errorMessage = 'An error occurred while updating the project:';
      Boolean hasError = false;
      for (Database.SaveResult sr : saveResults) {
        if (!sr.isSuccess()) {
          for (Database.Error err : sr.getErrors()) {
            System.debug('Error updating project: ' + err.getMessage());
            errorMessage += ' ' + err.getMessage();
            hasError = true;
          }
        }
      }
      if (hasError) {
        throw new CustomDmlException(errorMessage);
      }
    }
  }
}
