public inherited sharing class TaskForAcc {
  @future
  public static void createTaskForAcc(Set<Id> allAccId) {
    List<Account> newAccs = [
      SELECT Id, Name
      FROM Account
      WHERE ID IN :allAccId
    ];
    List<Task> newTasks = new List<Task>();
    for (Account a : newAccs) {
      newTasks.add(
        new Task(Subject = 'Negotiations with ' + a.Name, Is_Synced__c=false, WhatID = a.ID)
      );
    }
    insert newTasks;
  }

  public static void updateUserForTasks(List<Account> accList) {
    List<Id> accsId = new List<Id>();
    for (Account el : accList) {
      accsId.add(el.Id);
    }
    Map<Id, List<Task>> mapIdAccWithTasks = new Map<Id, List<Task>>();

    for (Account el : [
      SELECT Id, (SELECT Id FROM Tasks)
      FROM Account
      WHERE Id IN :accsId
    ]) {
      mapIdAccWithTasks.put(el.id, el.Tasks);
    }

    List<Id> idAccWithManyTask = new List<Id>();

    for (Id el : accsId) {
      if (mapIdAccWithTasks.get(el).size() > 3) {
        idAccWithManyTask.add(el);
      }
    }

    List<User> activeUserList = [
      SELECT IsActive
      FROM User
      WHERE IsActive = TRUE
    ];
    Integer randNumber = (Math.floor(Math.random() * activeUserList.size()))
      .intValue();
    Id randomUserId = activeUserList[randNumber].Id;

    List<Task> taskToUpdate = [
      SELECT WhatId, OwnerId
      FROM Task
      WHERE WhatId IN :idAccWithManyTask
    ];

    for (Task a : taskToUpdate) {
      a.OwnerId = randomUserId;
    }
    update taskToUpdate;
  }
}
