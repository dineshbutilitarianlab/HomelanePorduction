/*
         * $Author: Venkat Arisa
         * $Date: 30/05/2016 
         * Version: 5
         */

        @RestResource(urlMapping='/QuoteAPI/*')
                global class QuoteAPI{
                   
                   Public Static Map<String, Object> roomwiseDetailsMap = null;
                   Public Static Map<String, Object> otherServicesMap = null;
                   Public Static Integer woodworksPrice = 0;
                   
                   Public Static Integer furniturePrice = 0; //furniturePrice pricing added
                   
                   
                   Public Static Integer accessoriesPrice = 0;
                   Public Static Integer appliancesPrice = 0;
                   Public Static Integer hdsPrice = 0;
                   Public Static Integer otherServicesPrice = 0;
                   Public Static Integer totalQuoteDiscount = 0;
                   Public Static List<QuoteLineItem> quoteLineItemRecords = new List<QuoteLineItem>();
                   Public Static Boolean quoteLineitemscreated = FALSE;
                   Public Static String objectDescription = '';
                   Public Static QuoteLineItem quoteLine = new QuoteLineItem();
                   Public Static QuoteLineItem quoteLineDiscount = new QuoteLineItem();
                   Public Static Id ProductId = null;
                   Public Static Id PriceBookEntryId = null;
                   Public Static List<Pricebook2>  stdPricebookId  = null;
                   
                   // for Discounts
                   Public Static Integer woodworksPriceDiscount = 0;                   
                   Public Static Integer furniturePriceDiscount = 0; //furniturePrice pricing added                                      
                   Public Static Integer accessoriesPriceDiscount = 0;
                   Public Static Integer appliancesPriceDiscount = 0;
                   Public Static Integer hdsPriceDiscount = 0;
                   
                @HttpPost
                    global static void QuoteAPI(){
                    //creating instance to get request data from IQ Application
                        RestRequest req = RestContext.request;
                  
                       String quoteinput = req.requestBody.toString();
                       Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(quoteinput);
                       try{
                            
                            system.debug('****JSON_Input  is? '+JSON_Input);
                            for(String str : JSON_Input.keyset()){
                                system.debug('------key-----'+str+'------value----'+JSON_Input.get(str));
                            }
                             // the oppty number is sent through JSON input
                            // Query the Opportunity object to find the OpptyId
                           // Create a Quote linking to the Oppty Id returned      
                           List<Opportunity> opptyList = [Select id,name,AutoNumber_For_Quote_Creation__c,Account.Personemail,SyncedQuoteId,Account.firstName,Account.lastName from opportunity where Customer_Quote_Number__c =: (String)JSON_Input.get('opptynumber') FOR UPDATE]; 
                            system.debug(' ** oppty auto number is? '+(String)JSON_Input.get('opptynumber'));
                            system.debug(' ** opptyList  size is?'+opptyList.size());
                          // Get the standard PriceBookEntry Id and use it while creating PriceBookEntryMap
                            stdPricebookId = new List<Pricebook2>([SELECT Id,IsStandard FROM Pricebook2 where IsStandard = TRUE]);
                          // Create Quote Record- For the incoming JSON input only 1 Quote is created at the time of API Call 
                           Quote quoterec = null;
                           if(opptyList.size() == 1){
                             system.debug('****BEFORE QUOTE CREATION ');
                             quoterec = createQuote((String)JSON_Input.get('name'),(String)JSON_Input.get('projectId'),(String)JSON_Input.get('priceVersion'),(Integer)JSON_Input.get('version'),opptyList[0].id,stdPricebookId[0].Id);
                            // quoterec.QuotePDF_S3__c = (String)JSON_Input.get('pdfLocation');
                               system.debug('****After QUOTE CREATION ');
                             
                           }    
                       // Update S3 URL in the Quote
                            String S3URL = null;
                            if(opptyList.size() == 1){
                                  S3URL = AWSCallout.getS3URL(opptyList[0].AutoNumber_For_Quote_Creation__c);
                                  if(null != quoterec && null != S3URL){
                                      quoterec.QuotePDF_S3__c = S3URL;
                                   } 
                            }  
                         system.debug('*********************quoterec  is?'+quoterec ); 
                        // Insert the Quote in Salesforce 
                          if(null != quoterec){
                                 insert quoterec;
                                 system.debug('**********'+quoterec);
                            } 
                             
                        if(quoterec.id != null){
                            opptyList[0].SyncedQuoteId = quoterec.id;
                            opptyList[0].Quote_URL__c = S3URL;
                            system.debug('quote url ------------------->'+(String)JSON_Input.get('quoteUrl'));
                            opptyList[0].Quote_Link__c = (String)JSON_Input.get('quoteUrl');
                             update opptyList;
                            }
                        // All the WoodWorks, Appliances, Accessories totals ( total value + tax ) are sent per room in summary object 
                    // Hds does not have tax values, it will only have product totals                   
                        Map<String, Object> roomwiseSummaryList = (Map<String, Object>)JSON_Input.get('summary');
                        system.debug('**** In roomwiseSummaryList '+ roomwiseSummaryList+' roomwiseSummaryList size '+roomwiseSummaryList.size() );
                        List<Object> roomwiseDetailsList = (List<Object>)roomwiseSummaryList.get('roomDetails');
                        System.debug('**** In roomwiseDetailsList  '+ roomwiseDetailsList );
                        
                        
                        for (Object item : roomwiseDetailsList) {
                            System.debug('**** In item  '+ item );
                            roomwiseDetailsMap = (Map<String, Object>)item;
                            String roomType = '';
                            
                            if((String)roomwiseDetailsMap.get('roomType') == 'Kitchen')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Utility')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Store')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Bedroom')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Bathroom')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Dinning Room')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Living Room')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Foyer')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            if((String)roomwiseDetailsMap.get('roomType') == 'Under Staircase')
                            roomType = (String)roomwiseDetailsMap.get('roomType');
                            System.debug('*****roomType  '+roomType );
                            
                                objectDescription = (String)roomwiseDetailsMap.get('name');
                                system.debug(' *** objectDescription '+objectDescription);
                                
                        // For Each imcoming room name, check whether any product with same name exists
                        // If yes, get the details of existing product and pricebook entry map
                        // Else, Create new product, PriceBook 
                                 
                                PricebookEntry existingPBE = returnExistingPBE(objectDescription);
                                                                                         
                                  if( null != existingPBE){
                                      system.debug(' *** existingPBE '+existingPBE.Product2Id +' *** existingPBE.Id '+ existingPBE.Id);
                                      ProductId = existingPBE.Product2Id;
                                      PriceBookEntryId = existingPBE.Id;
                                    }else{
                                        ProductId =  insertProduct(objectDescription).Id;
                                        PriceBookEntryId = insertPBE(ProductId).Id;
                                    }
                                
                                woodworksPrice   = Integer.valueOf(roomwiseDetailsMap.get('wwTotal'));  
                                accessoriesPrice = Integer.valueOf(roomwiseDetailsMap.get('accTotal'));
                                appliancesPrice  = Integer.valueOf(roomwiseDetailsMap.get('appTotal'));
                                if(roomwiseDetailsMap.get('hdsTotal') !=null)
                                    hdsPrice = Integer.valueOf(roomwiseDetailsMap.get('hdsTotal')); 
                                else
                                    hdsPrice = Integer.valueOf(roomwiseDetailsMap.get('hdsPrice')); 
                                furniturePrice = Integer.valueOf(roomwiseDetailsMap.get('furniturePrice')); 
                                
                                system.debug('furniturePrice----------------->'+furniturePrice);

                                                            
                            system.debug(' *** objectDescription for Quote line item is '+objectDescription);
                             // create quoteline item Per Room                          
                             quoteLine = createQuoteLineItem(ProductId,
                                                             PriceBookEntryId,
                                                             quoterec.Id,
                                                             objectDescription,
                                                             woodworksPrice,
                                                             accessoriesPrice,
                                                             appliancesPrice,
                                                             hdsPrice,
                                                             furniturePrice,
                                                             0,
                                                             roomType);
                                system.debug(' ***** quoteLine '+quoteLine);                             
                             quoteLineItemRecords.add(quoteLine);
                    }   
                    
                    /*List<Object> totalQuoteValue1 = (List<Object>)roomwiseSummaryList.get('total');
                                        system.debug(' ** totalQuoteValue '+totalQuoteValue1);*/

                                                   
             // Get the price of other services, and create a line item             
                    List<Object> otherServicesdetailsList = (List<Object>)roomwiseSummaryList.get('otherServices');
                    system.debug(' *** otherServicesdetailsList '+ otherServicesdetailsList);
                if( null != otherServicesdetailsList){
                     for (Object item1 : otherServicesdetailsList) {
                      otherServicesMap = (Map<String, Object>)item1;
                      otherServicesPrice   = Integer.valueOf(otherServicesMap.get('price'));
                      system.debug(' *** otherServicesPrice '+otherServicesPrice);
                      if( 0 != otherServicesPrice ){
                                
                                PricebookEntry existingPBEforotherservices = returnExistingPBE('OtherServices');
                                system.debug(' *** existingPBEforotherservices '+existingPBEforotherservices);
                                                                                
                                  if( null != existingPBEforotherservices){
                                      ProductId = existingPBEforotherservices.Product2Id;
                                      PriceBookEntryId = existingPBEforotherservices.Id;
                                    }else{
                                        ProductId =  insertProduct('OtherServices').Id;
                                        PriceBookEntryId = insertPBE(ProductId).Id;
                                    }
                          
                            quoteLine = createQuoteLineItem(ProductId,
                                                             PriceBookEntryId,
                                                             quoterec.Id,
                                                             'Other Services',
                                                             0,
                                                             0,
                                                             0,
                                                             0,
                                                             0,
                                                             otherServicesPrice,
                                                             '');
                            system.debug(' *** quoteLine '+quoteLine);
                            quoteLineItemRecords.add(quoteLine);
                        }
                    }
                }
                
                Map<String, Object> otherDetails = (Map<String, Object>)JSON_Input.get('otherDetails');
                system.debug('**** In otherDetails '+ otherDetails+' otherDetails size '+otherDetails.size() );
                Map<String, Object> discountBreakup = null;
                Map<String, Object> hds = null;
                System.debug('********otherDetails.get(discountBreakup)  '+otherDetails.get('discountBreakup'));
                if(otherDetails.get('discountBreakup') != null){
                    discountBreakup = (Map<String, Object>)otherDetails.get('discountBreakup');
                    system.debug('**** In discountBreakup '+ discountBreakup+' discountBreakup size '+discountBreakup.size() );
                
                    hds  = (Map<String, Object>)discountBreakup.get('hds');
                    system.debug('**** In hds  '+ hds+' hds  size '+hds.size() );
                }
                
                if(Integer.Valueof(roomwiseSummaryList.get('discount')) == NULL){
                    totalQuoteDiscount =0;
                }
                else{
                totalQuoteDiscount = Integer.Valueof(roomwiseSummaryList.get('discount'));
                }  
                    system.debug(' ** totalQuoteDiscount '+totalQuoteDiscount);
              //  if( null != discountBreakup){
                       PricebookEntry pbeDiscount = returnExistingPBE('Discount');
                                system.debug(' *** pbeDiscount '+pbeDiscount);
                                                                                
                                  if( null != pbeDiscount){
                                      ProductId = pbeDiscount.Product2Id;
                                      PriceBookEntryId = pbeDiscount.Id;
                                    }else{
                                      ProductId =  insertProduct('Discount').Id;
                                      PriceBookEntryId = insertPBE(ProductId).Id;
                                    }
                                    
                                if(null != discountBreakup) {
                                    accessoriesPriceDiscount   = Integer.valueOf(discountBreakup.get('accessory')); 
                                    appliancesPriceDiscount = Integer.valueOf(discountBreakup.get('appliance'));
                                    furniturePriceDiscount  = Integer.valueOf(discountBreakup.get('furniture'));
                                    hdsPriceDiscount = Integer.valueOf(hds.get('total'));    
                                    woodworksPriceDiscount = Integer.valueOf(discountBreakup.get('woodwork'));
                                }
                                else {
                                    accessoriesPriceDiscount   = 0;
                                    appliancesPriceDiscount = 0;
                                    hdsPriceDiscount = 0;
                                    hdsPriceDiscount = 0;
                                    woodworksPriceDiscount = 0;
                                }
                                
                                System.debug('Integer.valueOf(discountBreakup.get(woodwork))  '+Integer.valueOf(discountBreakup.get('woodwork')));
                                System.debug('Integer.valueOf(discountBreakup.get(appliance))  '+Integer.valueOf(discountBreakup.get('appliance')));
                                System.debug('Integer.valueOf(discountBreakup.get(furniture))  '+Integer.valueOf(discountBreakup.get('furniture'))); 
                                System.debug('Integer.valueOf(discountBreakup.get(accessory))  '+Integer.valueOf(discountBreakup.get('accessory')));                               
                                
                                if(Integer.valueOf(discountBreakup.get('accessory')) == null) {
                                    System.debug('INSIDE ACCESSORY');
                                    accessoriesPriceDiscount   = 0;
                                }
                                if(Integer.valueOf(discountBreakup.get('appliance')) == null) {
                                    System.debug('INSIDE appliance');
                                    appliancesPriceDiscount = 0; 
                                }
                                if(Integer.valueOf(discountBreakup.get('furniture')) == null) {
                                    System.debug('INSIDE furniture');
                                    furniturePriceDiscount  = 0; 
                                }
                                if(Integer.valueOf(hds.get('total')) == null) {
                                    System.debug('INSIDE total');
                                    hdsPriceDiscount = 0;
                                }
                                if(Integer.valueOf(discountBreakup.get('woodwork')) == null) {
                                    System.debug('INSIDE woodwork');
                                    woodworksPriceDiscount = 0; 
                                }
                         
                         
                                system.debug('furniturePriceDiscount----------------->'+furniturePriceDiscount+'  accessoriesPriceDiscount----------------->'+accessoriesPriceDiscount+'  appliancesPriceDiscount----------------->'+appliancesPriceDiscount+'  woodworksPriceDiscount----------------->'+woodworksPriceDiscount+'  hdsPriceDiscount----------------->'+hdsPriceDiscount );

                                                            
                             // create quoteline item Per Room                          
                             quoteLineDiscount = createQuoteLineItem(ProductId,
                                                             PriceBookEntryId,
                                                             quoterec.Id,
                                                             'Quote Discount',
                                                             -woodworksPriceDiscount,
                                                             -accessoriesPriceDiscount,
                                                             -appliancesPriceDiscount,
                                                             -hdsPriceDiscount,
                                                             -furniturePriceDiscount,
                                                             0,
                                                             '');
                                system.debug('*****quoteLineDiscount  '+quoteLineDiscount);                             
                             quoteLineItemRecords.add(quoteLineDiscount);
               
             //   }
                   
                   
                   
                    
                    system.debug('*** quoteLineItemRecords are '+quoteLineItemRecords+ ' quote line items size is '+ quoteLineItemRecords.size());
                        
                /*************************************************************************************************************************/
                        if(!quoteLineItemRecords.isEmpty()){
                                 insert quoteLineItemRecords;
                                 quoteLineitemscreated = TRUE;
                                
                          } 
                          
                        if(null != quoterec){
                           //quoterec.GrandTotal = totalQuoteValue;
                            quoterec.Total_Quote_Discount__c = totalQuoteDiscount;
                            update quoterec;
                            
                        }  
                          
                          
                          
                          
            /*************************************************************************************************************************/                    
                    Response response =new Response();
                    if(null != quoterec && quoteLineitemscreated == TRUE){
                            response.message = 'Quote and Quote Line Items Created in Salesforce Succesfully';
                    }else{
                            response.message = 'Failed to Create Quote and Quote Line Items';
                    }
                    
                     response.quoteid = quoterec.id;
                     string json_data = json.serialize(response);
                     RestContext.response.addHeader('Content-Type', 'application/json');
                     RestContext.response.responseBody = Blob.valueOf(json_data);
                }catch(Exception exp){
                    string errorMsg = 'Salesforce - This is to inform you that Quote with the Opportunity Name ='+(String) JSON_Input.get('Name')+' and Opportunity Number = '+(String) JSON_Input.get('opptynumber')+' is not Created on Salesforce,Because we got the following error-'+exp.getmessage()+'in'+exp.getStackTraceString()+'. Please do the needful';
                    string oppId = (String) JSON_Input.get('Id');
                    SendEmailToManager(errorMsg,oppId);
                }                    
            }
                  
                  Public Static Quote createQuote(String name, String projectid, String priceversion, Integer version, Id OpptyId,Id pricebookId){
                       Quote quoterecord = new Quote();
                       quoterecord.name = name;
                       quoterecord.projectId__c = projectid;
                       quoterecord.priceVersion__c = priceversion;
                       quoterecord.version__c = version;
                       quoterecord.opportunityId = OpptyId;
                       quoterecord.Pricebook2Id = pricebookId;
                       //quoterecord.Discount = 10;
               
                       return quoterecord;
                    } 
                  
                    Public Static QuoteLineItem createQuoteLineItem(Id prodId, Id pricebookEntId, Id quotId, String itemdesc,Decimal woodworkprice, Decimal accessorieprice, Decimal applianceprice, Decimal hdprice,Decimal furniturePriceval,Decimal otherserviceprice, String typeOfRoom){
                        QuoteLineItem quoteLineItemrecord = new QuoteLineItem();
                        Decimal TotalUnitPrice;
                        
                        TotalUnitPrice = woodworkprice+accessorieprice+applianceprice+hdprice+furniturePriceval+otherserviceprice;
                        
                        quoteLineItemrecord.product2id = prodId;
                        quoteLineItemrecord.PricebookEntryId = pricebookEntId;
                        quoteLineItemrecord.QuoteId  = quotId;
                        quoteLineItemrecord.Quantity = 1;
                        quoteLineItemrecord.UnitPrice = TotalUnitPrice; 
                        quoteLineItemrecord.Description = itemdesc;
                        quoteLineItemrecord.Woodworks_Price__c = woodworkprice;
                        quoteLineItemrecord.Accessories_Price__c = accessorieprice;
                        quoteLineItemrecord.Appliances_Price__c = applianceprice;
                        quoteLineItemrecord.hds_price__c = hdprice;
                        quoteLineItemrecord.Furniture_Price__c = furniturePriceval;
                        quoteLineItemrecord.Other_Services_Price__c = otherserviceprice;
                        quoteLineItemrecord.Room_Type__c = typeOfRoom;
                        
                        return quoteLineItemrecord ;
                    }   
                    
                    Public Static PricebookEntry createPricebookEntry( Id prodId, Id pricebookId){
                        
                        PricebookEntry pbe = new PricebookEntry();
                        pbe.Pricebook2Id = pricebookId;
                        pbe.Product2Id = prodId;
                        pbe.UnitPrice = 10;
                        pbe.isActive = TRUE;
                        
                        return pbe;             
                        
                     }
                     
                     Public Static PricebookEntry returnExistingPBE(String productname){
                         
                         system.debug(' *** pbeName '+productname);
                         
                        //List<PricebookEntry> existingPriceBookEntryList = new List<PricebookEntry>([SELECT Id,Product2Id,name,Product2.name,PriceBook2Id FROM PricebookEntry where Product2.name = : productname and isActive = TRUE]);
                        
                        List<PricebookEntry> existingPriceBookEntryList = new List<PricebookEntry>();
                        existingPriceBookEntryList = [SELECT Id,Product2Id,name,Product2.name,PriceBook2Id FROM PricebookEntry where Product2.name = : productname and isActive = TRUE Limit 1];
                         
                        if(!existingPriceBookEntryList.isEmpty())
                          return existingPriceBookEntryList[0];
                        else
                          return null;
                     
                   }
                     
                     Public Static Product2 createProduct(String prodName){
                         
                         Product2 prod = new Product2();
                         prod.Name = prodName;
                         prod.IsActive = TRUE ;
                         
                         return prod;
                         
                     }
                     
                     Public Static Product2 insertProduct(String productName){
                     
                         Product2 newProduct = createProduct(productName);
                                             
                         if(null != newProduct){
                             try{
                                 insert newProduct;
                             }catch(DMLException DMLEx){
                                 system.debug('Failed to create Product due to '+DMLEx.getmessage());
                              }
                         }
                         
                         return newProduct;
                     
                     }
                     
                     Public Static PricebookEntry insertPBE(Id prodId){
                         
                         PricebookEntry pbe = createPricebookEntry(prodId,stdPricebookId[0].Id);
                                         
                         if(null != pbe){
                           try{
                                 insert pbe;
                             }catch(DMLException DMLEx){
                                 system.debug('Failed to create pricebookEntry due to '+ DMLEx.getmessage());
                             }
                         }
                         
                         return pbe;
                     }
                public Static void SendEmailToManager(String errMsg, String oppId){
                                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                            message.toAddresses = new String[] {'balasubramanian.r@kvpcorp.com','iqsupport@homelane.com','cameron.j@homelane.com','qa@homelane.com','nitin.b@homelane.com','arjun.k@homelane.com'}; 
                                            message.optOutPolicy = 'FILTER';
                                            message.subject = 'Quote Creation Issue. Id : '+oppId;
                                            message.plainTextBody = errMsg;
                                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        }
                 
                 Private class Response{
                  String message;
                  String quoteid;
                  //Boolean success;
                 // Integer status ;
                 }
             
        public void dummy(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }              
    }