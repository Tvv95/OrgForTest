public class IntegrationWithOtherOrgAccounts {
  public static Account getAccountFromOrg(String idToGet) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:Rest_Serv_Credent/services/apexrest/Accounts/' + idToGet
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      Account takenAcc = new Account();
      takenAcc.Name = String.valueof(result.get('Name'));
      takenAcc.Site = String.valueof(result.get('Site'));
      return takenAcc;
    }
    return null;
  }

  public static Id createAccOnOrg(String name, String site) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:Rest_Serv_Credent/services/apexrest/Accounts/'
    );
    request.setMethod('POST');
    request.setBody('{\"name\":\"' + name + '\",\"site\":\"' + site + '\"}');
    request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      String resultString = JSON.deserializeUntyped(response.getBody()).toString();
      Id newAccId = Id.valueOf(resultString);
      return newAccId;
    }
    return null;
  }

  public static String deleteAccOnOrg(String idToDelete) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:Rest_Serv_Credent/services/apexrest/Accounts/' + idToDelete
    );
    request.setMethod('DELETE');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      System.debug('Acc with ID = ' + idToDelete + ' DELETED');
      return 'Acc Deleted';
    } else {
      System.debug('ERROR');
      return 'ERROR';
    }
  }

  public static Id upsertAccOnOrg(String name, String site, String idToUpsert) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:Rest_Serv_Credent/services/apexrest/Accounts/' + idToUpsert
    );
    request.setMethod('PUT');
    request.setBody('{\"id\":\"' + idToUpsert + '\",\"name\":\"' + name + '\",\"site\":\"' + site + '\"}');
    request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      String resultString = JSON.deserializeUntyped(response.getBody()).toString();
      Id upsertedAccId = Id.valueOf(resultString);
      return upsertedAccId;
    }
    return null;
  }

  public static Id updateAccOnOrg(String idToUpdate, String name, String site) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:Rest_Serv_Credent/services/apexrest/Accounts/' + idToUpdate
    );
    request.setMethod('PATCH');
   request.setBody('{\"name\":\"' + name + '\",\"site\":\"' + site + '\"}');
    request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      String resultString = JSON.deserializeUntyped(response.getBody()).toString();
      Id upsertedAccId = Id.valueOf(resultString);
      return upsertedAccId;
    }
    return null;
  }
}
