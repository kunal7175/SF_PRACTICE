@isTest
global class PaymentLinkCalloutMock implements HttpCalloutMock{

    public static final String LINK = 'https://pry.me/p/1698541839';

    global HTTPResponse respond(HTTPRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"payer":{"link":"' + LINK + '"}}');
        return response;
    }
    
}
 