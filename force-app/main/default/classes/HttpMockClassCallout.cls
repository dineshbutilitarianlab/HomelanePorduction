@isTest
global class HttpMockClassCallout implements HttpCalloutMock {
    
    protected String header;
    protected string body;
    protected string status;
    protected Integer statuscode;
    
    public HttpMockClassCallout(string body,string status,Integer statuscode)
    {
        this.body = body;
        this.status = status;
        this.statuscode = statuscode;
    }
    
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatus(status);
        res.setStatusCode(statuscode);
        return res; 
    }
}