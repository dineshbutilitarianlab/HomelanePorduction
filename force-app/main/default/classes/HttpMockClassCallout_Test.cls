@isTest
global class HttpMockClassCallout_Test implements HttpCalloutMock {
    
    protected String header;
    protected string body;
    protected string status;
    protected Integer statuscode;
    
    global HTTPResponse respond(HTTPRequest req) {
    System.debug('Test Mock Up Called'+req);
        if(req.getEndpoint().contains('sc-backend-qa.homelane.com')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://homelane.verloop.io/api/v1/Campaign/SendMessage/Test')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }  
        else if(req.getEndpoint().contains('http://api1.cloudagent.in:4567/CAServices/v2/Test?username=HomeLane&apikey=abcd&campaignName=TEST_AUTOLEAD')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[{"AgentId":"Test@mailnator.com","AgentName":"Balaji","State":"Ready","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"},{"AgentId":"Test1@mailnator.com","AgentName":"Balaji","State":"AWC","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"}]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        } 
        else if(req.getEndpoint().contains('http://api1.cloudagent.in:4567/CAServices/v2/Test2?username=HomeLane&apikey=abcd&campaignName=TEST_AUTOLEAD')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[{"AgentId":"Test@mailnator.com","AgentName":"Balaji","State":"AWC","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"},{"AgentId":"Test1@mailnator.com","AgentName":"Balaji","State":"AWC","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"}]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }   
        else if(req.getEndpoint().contains('http://api1.cloudagent.in:4567/CAServices/v2/Test1?username=HomeLane&apikey=abcd&campaignName=TEST_AUTOLEAD')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[{"AgentId":"Test@mailnator.com","AgentName":"Balaji","State":"BUSY","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"},{"AgentId":"Test1@mailnator.com","AgentName":"Balaji","State":"BUSY","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"}]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }  
        else if(req.getEndpoint().contains('http://api1.cloudagent.in:4567/CAServices/v2/Test4?username=HomeLane&apikey=abcd&campaignName=TEST_AUTOLEAD')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }  

        else if(req.getEndpoint().contains('https://sandbox-roster.homelane.com/apis/general/scvm_rain_flow/Test')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        } 
                             
        else if(req.getEndpoint().contains('https://www.homelane.com/apis/quotes/generateTinyUrl?')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"response":"success","tiny_url":"tinyurl.com/y45cog","status":1}');
            response.setStatusCode(200);
            return response; 
        }    

        else if(req.getEndpoint().contains('https://api-in21.leadsquared.com/v2/LeadManagement.svc/Lead/Bulk/CreateOrUpdate?')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('[{"RowNumber":1,"LeadId":"a4f351b9-bc2a-44a9-9a38-f1303cca214a","LeadCreated":false,"LeadUpdated":true,"AffectedRows":1}]');
            response.setStatusCode(200);
            return response; 
        } 
        else if(req.getEndpoint().contains('https://homelane--hlprod.cs72.my.salesforce.com/services/apexrest/AddressInfoAPI')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":True,"errorMsg":""}');
            response.setStatusCode(200);
            return response; 
        } 
        else if(req.getEndpoint().contains('https://homelane--hlprod.cs72.my.salesforce.com/services/oauth2/token')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token":"SESSION_ID_REMOVED","instance_url":"https://homelane--HLProd.cs72.my.salesforce.com","id":"https://test.salesforce.com/id/00D5D0000000UdQUAU/005280000030TdSAAU","token_type":"Bearer","issued_at":"1568892439621","signature":"gZo+KytEI9wpgL49lPFmsoZPo4Hzwt62fspTJcOx8T8="}');
            response.setStatusCode(200);
            return response; 
        } 
        else if(req.getEndpoint().contains('https://rosters.homelane.com/apis/ops/trigger_payment_emailonnps/test')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('[Status=Ok, StatusCode=200]');
            response.setStatusCode(200);
            return response; 
        }    
        else if(req.getEndpoint().contains('http://sc-backend-qa.homelane.com')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('[Status=Ok, StatusCode=200]');
            response.setStatusCode(200);
            return response; 
        }
        else if(req.getEndpoint().contains('https://api.webengage.com/v1/accounts/~47b65dd3/bulk-events')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "response": {"status": "queued"}}');
            response.setStatusCode(201);
            return response;
        }
        else if(req.getEndpoint().contains('https://api.webengage.com/v1/accounts/~47b65dd3/bulk-users')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "response": {"status": "queued"}}');
            response.setStatusCode(201);
            return response;
        }
        
       else if(req.getEndpoint().contains('https://sc-backend-qa.homelane.com/project/')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(' {"status": "OK"}');
            response.setStatusCode(201);
            return response;
        }
        
       else if(req.getEndpoint().contains('https://stage-iqapi.homelane.com/assign/Error')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(' {"status":"error","data":"Email Not updated"}');
            response.setStatusCode(201);
            return response;
        }   
       else if(req.getEndpoint().contains('https://stage-iqapi.homelane.com/assign')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(' {"status":"success","data":"Email updated"}');
            response.setStatusCode(201);
            return response;
        }
       else if(req.getEndpoint().contains('https://homelane.verloop.io/api/v1/Campaign/SendMessage/V2')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(' {"status":"success"}');
            response.setStatusCode(200);
            return response;
        }  
       else if(req.getEndpoint().contains('https://homelane.verloop.io/api/v1/Campaign/SendMessage/V1')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(' {"status":"success"}');
            response.setStatusCode(400);
            return response;
        }
        else if(req.getEndpoint().contains('https://www.homelane.com/apis/quotes/generateTinyUrl?/V1')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"response":"success","tiny_url":"tinyurl.com/y45cog","status":1}');
            response.setStatusCode(200);
            return response; 
        } 
        else if(req.getEndpoint().contains('https://api1.cloudagent.in/CAServices/AgentDetails/AgentDetails.php?userName=')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{message=({AgentId=bharatesh@warpdrivetech.in, AgentName=bharatesh, Mode=Inbound, PhoneNumber=null, Skill=Bharatesh_AutoLead, Test2_AutoLead, Test_AutoLead, State=NOT READY}), status=success}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://api1.cloudagent.in/cloudAgentRestAPI/index.php/CloudAgent/CloudAgentAPI/addCamapaignData?')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"code":"200","status":"Success","message":null,"response":[{"AgentId":"Test@mailnator.com","AgentName":"Balaji","State":"AWC","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"},{"AgentId":"Test1@mailnator.com","AgentName":"Balaji","State":"AWC","PhoneNumber":"08861135220","Mode":"Blended","Skill":"TEST_AUTOLEAD"}]}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('apis/ops/getWorksContractStatus')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":true,"data":{"dpEmail":"dponeohtest@mailinator.com","dpName":"dponeohtest","cmEmail":"jg_sushma.k@homelane.com","cmName":"Sushma K","currentOrderStage":"pushed_to_production"},"msg":"Success"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://dp-score.homelane.com/user/login')){
 
            HttpResponse res = new HttpResponse();
            res.setBody('{"message": "Logged in as roster","access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2Mzg1NTU1MzAsIm5iZiI6MTYzODU1NTUzMCwianRpIjoiMDI5MWIyOGMtYTIwMC00MGU4LWFkOWUtNTU4NjAwZDI4ZmNmIiwiZXhwIjoxNjM4NTU2NDMwLCJpZGVudGl0eSI6InJvc3RlciIsImZyZXNoIjpmYWxzZSwidHlwZSI6ImFjY2VzcyJ9.H4djeGUgSh59ArVlk81_NP_ZYGfABiQMZbcWj1de2sA","refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2Mzg1NTU1MzAsIm5iZiI6MTYzODU1NTUzMCwianRpIjoiZTM2YTBiNDktMTgzZC00YTdhLTg2OTItNDVhZDhjMzY5NGVkIiwiZXhwIjoxNjQxMTQ3NTMwLCJpZGVudGl0eSI6InJvc3RlciIsInR5cGUiOiJyZWZyZXNoIn0.tppNlrJT6ksPDAGIRRByGS68iT5bV8O1k51a8OtiYA4"}');
			res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://dp-score.homelane.com/api/v1/get_irm_attendence')){
            
            HttpResponse res = new HttpResponse();
            res.setBody('{"error": false,"response": {"TestShowRoomUSer@test.com": true},"msg": ""}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://app.squadrun.co/api/v4/leads/create/')){
            HttpResponse res = new HttpResponse();
            res.setBody('[{"city":"Bengaluru","email_id":"ehnlrtpq922@mail.com100","Property_Status__c":null,"contact_name":"chnlprtnqa eight cpa","phone_number":"1823646000","PostalCode":"560103","lead_id":"00Q9D0000039RnbUAE"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://sandbox-rosters-oh.homelane.com/apis/General/sf_emails')){
            HttpResponse res = new HttpResponse();
            res.setBody('{"error": false,"response": {true},"msg": ""}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
         }
        else if(req.getEndpoint().contains('https://home.nimbusbpo.com/QuickCall/UploadLead.php')){
            HttpResponse res = new HttpResponse();
            res.setBody('{"STATUS": "DU000", "MESSAGE": {"insertednumbers": ["8978675645"]},"refno": "00QC4000002BdMfMAK"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://blitz-property-searcher.homelane.com/blitz-property?')){
            HttpResponse res = new HttpResponse();
            res.setBody('[{ "area": "KA&KL","city": "Bengaluru","property": "Sobha", "score": 4.04024,"similarity": 0.8333333333333334, "zone": "South"}]');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://graph.facebook.com/v15.0/1474943816139936/events?access_token=EAAE87nqgdSEBAMpvhZAP8X8dnqzHhswEYXLLKeopzlFZCIo42prYFDHPgofpTxEPlEDxG6uyW8ZCNtJgxRKDaJIQc5DLKqjSfN5sZAshhZCVXfpOdrL1Fup5GRj5ZCx3G2oAg7GrguAoiWHefdr1QIwBZBiOJ4n6J0VyMBbjtpdFI6df5NImdiT')){
            HttpResponse res = new HttpResponse();
            //res.setBody('{"Property": "Snn Raj", "score":"2.728", "similarity":"5.7229"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
         else if(req.getEndpoint().contains('https://88f2905a42807de7499a2e23bae7c99e5745d496f3e76427:72f89a2e7c8d2e1302769ceafb1fb035eed1e6b6ba006592@api.exotel.com/v1/Accounts/homelane4/Calls/connect?')){
            HttpResponse res = new HttpResponse();
            //res.setBody('{"Property": "Snn Raj", "score":"2.728", "similarity":"5.7229"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
         else if(req.getEndpoint().contains('https://api.exotel.com/v1/Accounts/homelane4/Calls/connect.json')){
            HttpResponse res = new HttpResponse();
            //res.setBody('{"Property": "Snn Raj", "score":"2.728", "similarity":"5.7229"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
        else if(req.getEndpoint().contains('https://homelane-api.globiva.com/routes/send-lead')){
            HttpResponse res = new HttpResponse();
            //res.setBody('{"Property": "Snn Raj", "score":"2.728", "similarity":"5.7229"}');
            res.setStatusCode(200);
            System.debug('Test Mock Up Called'+res );
            return res;
        }
  
      return null;
    }
}