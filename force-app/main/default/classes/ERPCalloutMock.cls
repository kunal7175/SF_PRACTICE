@isTest
global class ERPCalloutMock implements HttpCalloutMock {

    public static final String ERPID = '52';

    global HTTPResponse respond(HTTPRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"Name":"P-0033","Email":"Email 52","erpId":"'+ ERPID + '"}');
        return response;
    }
    
}