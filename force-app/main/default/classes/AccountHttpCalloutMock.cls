@isTest
global class AccountHttpCalloutMock implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('"0010900000Bi0kmAAB"');
    response.setStatusCode(200);
    return response;
  }
}
