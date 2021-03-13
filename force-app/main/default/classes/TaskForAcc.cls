public inherited sharing class TaskForAcc {
  @InvocableMethod(
    label='Create Task for Acc'
    description='When new Account is created, create new Task object.'
    category='Account'
  )
  public static void createTaskForAcc(List<Account> accList) {
    List<Id> allAccId = new List<Id>();

    for (Account a : accList) {
      allAccId.add(a.Id);
    }

    List<Id> idAccWithTask = new List<Id>();

    for (Task a : [SELECT WhatId FROM Task WHERE WhatId IN :allAccId]) {
      idAccWithTask.add(a.WhatID);
    }

    List<Account> newAccs = [
      SELECT Id, Name
      FROM Account
      WHERE ID NOT IN :idAccWithTask AND ID IN :allAccId
    ];

    List<Task> newTasks = new List<Task>();

    if (newAccs.size() > 0) {
      for (Account a : newAccs) {
        newTasks.add(
          new Task(Subject = 'Negotiations with ' + a.Name, WhatID = a.ID)
        );
      }
    }

    if (idAccWithTask.size() > 0) {
      idAccWithTask.sort();
      Integer counter = 0;
      Id tempId = idAccWithTask[0];
      Set<Id> idAccWithManyTask = new Set<Id>();

      for (Id a : idAccWithTask) {
        if (tempId != a) {
          tempId = a;
          counter = 1;
        } else {
          counter += 1;
        }

        if (counter > 3) {
          idAccWithManyTask.add(a);
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

      for (Task a : [
        SELECT WhatId
        FROM Task
        WHERE WhatId IN :idAccWithManyTask
      ]) {
        a.OwnerId = randomUserId;
        newTasks.add(a);
      }
    }
    upsert newTasks;
  }
}
