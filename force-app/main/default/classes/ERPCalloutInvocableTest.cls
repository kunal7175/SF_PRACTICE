@isTest
public with sharing class ERPCalloutInvocableTest {
    @isTest
    public static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock()); 
        Participant__c participant = new Participant__c(Status__c = 'In Queue');
        insert participant;

        List<Id> ids = new List<Id>();
        ids.add(participant.Id);

        Test.startTest();
        List<String> erpsIDs = ERPCalloutInvocable.sendToERP(ids);
        Test.stopTest();

        Assert.areEqual(1, erpsIDs.size());
        Assert.areEqual(ERPCalloutMock.ERPID, erpsIDs.get(0));
    }
}