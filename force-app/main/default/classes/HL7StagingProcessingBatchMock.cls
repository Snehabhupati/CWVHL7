@isTest
global class HL7StagingProcessingBatchMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "mock_access_token", "instance_url": "mock_instance_url", "token_type": "Bearer"}');
        res.setStatusCode(200);
        return res;
    }
}