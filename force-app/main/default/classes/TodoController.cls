public with sharing class TodoController {
  @AuraEnabled(cacheable=true)
  public static List<Todo__c> getTodoList(String category, String searchValue) {
    return [
      SELECT
        Id,
        Name,
        Description__c,
        Creation_Date__c,
        Category__c,
        Priority__c,
        Status__c,
        Image__c
      FROM Todo__c
      WHERE Category__c LIKE :category
      AND Name LIKE :('%' + searchValue + '%')
    ];
  }
}
