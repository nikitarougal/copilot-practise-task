@RestResource(urlMapping='/Project/*')
global with sharing class CalculateTotalProjectsBudget {
  @HttpGet
  global static Double getTotalBudget() {
    // Perform the aggregate query
    AggregateResult[] results = [
      SELECT SUM(Budget__c) total
      FROM Project__c
      WHERE Status__c = 'In Progress'
      GROUP BY Status__c
    ];

    // Extract the sum from the aggregate result
    Double totalSum = 0;
    if (!results.isEmpty()) {
      totalSum = (Double) results[0].get('total');
    }
    return totalSum;
  }
}
