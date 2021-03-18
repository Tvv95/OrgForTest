@isTest
private class IntegrationWithOtherOrgAccountsTest {
  @TestSetup
  static void makeData() {
    Account test = new Account(Name = 'Test Name', Site='Test Site');
    insert test;
  }
  @isTest
  static void getAccountFromOrgTest() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('AccountForRestTest');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, mock);
    Test.stopTest();
    Account result = IntegrationWithOtherOrgAccounts.getAccountFromOrg(
      '0010900000Bi0kmAAB'
    );
    System.assertEquals(result.Name, [SELECT Name FROM Account].Name, 'Account names check');
  }

  @isTest
  static void createAccOnOrgTest() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock());
    Test.stopTest();
    Id result = IntegrationWithOtherOrgAccounts.createAccOnOrg('Test Name', 'Test Site');
    System.assertEquals(result, '0010900000Bi0kmAAB', 'Created acc Id check');
  }

  @isTest
  static void deleteAccOnOrgTest() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock());
    Test.stopTest();
    String result = IntegrationWithOtherOrgAccounts.deleteAccOnOrg('0010900000Bi0kmAAB');
    System.assertEquals('Acc Deleted', result);
  }

  @isTest
  static void upsertAccOnOrgTest() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock());
    Test.stopTest();
    Id result = IntegrationWithOtherOrgAccounts.upsertAccOnOrg('New Name', 'New Site', '');
    Id result2 = IntegrationWithOtherOrgAccounts.upsertAccOnOrg('Updated Name', 'Updated Site', '0010900000Bi0kmAAB');
    System.assertEquals(result, '0010900000Bi0kmAAB', 'Put-new Id check');
    System.assertEquals(result2, '0010900000Bi0kmAAB', 'Put-update Id check');
  }

  @isTest
  static void updateAccOnOrgTest() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock());
    Test.stopTest();
    Id result = IntegrationWithOtherOrgAccounts.updateAccOnOrg('0010900000Bi0kmAAB', 'Updated Name', 'Updated Site');
    System.assertEquals(result, '0010900000Bi0kmAAB', 'Updated Account Id check');
  }
}
