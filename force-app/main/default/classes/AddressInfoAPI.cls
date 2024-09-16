@RestResource(urlMapping='/AddressInfoAPI/*')
global class AddressInfoAPI{

    Public Static Map<String, Object> roomwiseDetailsMap = null;
    Public Static Map<String, Object> otherServicesMap = null;
    Public Static Integer woodworksPrice = 0;
    @HttpPost
    global static void AddressInfoAPI(){
    //creating instance to get request data from IQ Application
        RestRequest req = RestContext.request;
        List<FinalWrapper> finalList = new List<FinalWrapper>();
        list<Master__c> lstPropertyWithInOneKm = new list<Master__c>();
        list<Master__c> lstGoogleVerifiedProperty = new list<Master__c>();
        list<Master__c> lstManuallyVerifiedProperty = new list<Master__c>();
        list<Master__c> lstPropertyWithPropertyId = new list<Master__c>();
        Map<String,String> mapRecordType = new Map<String,String>();
        String Name;
        String sGooglePlaceId;
        String GooglePropertyID;
        String sUniqueName;
        String propertyType;
        Boolean bGoogleVerifiedExactStringMatch = false;
        Boolean bGoogleVerifiedStringMatch = false;
        Boolean bManuallyVerifiedExactMatch = false;
        Boolean bManuallyVerifiedMatch = false;
        Boolean bPropertIdMatch = false; 
        String updatePropertyTypeOnly ='';
        try
        {    
            master__c newProperty = new master__c();
            String inputData = req.requestBody.toString();
            system.debug('Input_data '+inputData);
            system.debug('input'+ String.valueOf(inputData));
            
            Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(inputData);
            system.debug('JSON_Input : '+JSON_Input );

            //Name = (String) JSON_Input.get('Name');
            Name = (String) JSON_Input.get(GenericConstants.PROPERTY_NAME);
            GooglePropertyID = (String) JSON_Input.get(GenericConstants.PROPERTY_PLACEID);
            propertyType =(String) JSON_Input.get(GenericConstants.Property_Type);
            updatePropertyTypeOnly = (String) JSON_Input.get(GenericConstants.Update_Property_Type);
            
            System.debug('=====Name====='+Name+'===GooglePropertyID=='+GooglePropertyID);

            if(String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LEADID))){
                Lead objLead = new Lead();
                system.debug('------objLead----'+String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LEADID)));
                objLead.id = (String) JSON_Input.get(GenericConstants.PROPERTY_LEADID);
                    
                //Get RecordTypeID and RecordTypeName From Salesforce 
                Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
                for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
                   mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId()); 
                }
                
                //Logic 
                if(String.isNotBlank(Name) && String.isNotBlank(GooglePropertyID)&& String.isBlank(updatePropertyTypeOnly) ){
                    if(String.isNotBlank(GooglePropertyID)){
                        sGooglePlaceId = '%'+GooglePropertyID+'%';
                        lstPropertyWithPropertyId = [Select id,Name,PlaceId__c,Description__c from Master__c
                                                        where PlaceId__c Like :sGooglePlaceId and Verification_Status__c = 'Google Verified'
                                                         Limit 1];
                        if(lstPropertyWithPropertyId!= NULL && !lstPropertyWithPropertyId.isEmpty()){
                            objLead.Property__c = lstPropertyWithPropertyId[0].Id;
                             objLead.Property_Type__c = propertyType;
                            update objLead;   
                            bPropertIdMatch = true;  
                            FinalWrapper fin = new FinalWrapper(true,'');
                            finalList.add(fin); 
                        }                          
                    }
                    if(!bPropertIdMatch){
                        sUniqueName = removeString(Name);
                        if(String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_TYPE_INPUT)))
                        {
                            if(String.isNotBlank((String) JSON_Input.get(GenericConstants.PROPERTY_LNG)) && String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LAT)))
                            {
                                Decimal x =  Decimal.ValueOf((String) JSON_Input.get(GenericConstants.PROPERTY_LAT));
                                Decimal y =  Decimal.ValueOf((String) JSON_Input.get(GenericConstants.PROPERTY_LNG));
                                //Property with in 1km Radius
                                lstPropertyWithInOneKm = [Select id,Name,Unique_Name__c,Verification_Status__c,PlaceId__c,Description__c from Master__c
                                                                Where (Verification_Status__c = 'Google Verified' 
                                                                OR Verification_Status__c = 'Manually Verified')
                                                                and Unique_Name__c =: sUniqueName.replaceAll( '\\s+','')
                                                                and  DISTANCE(Location__c, GEOLOCATION(:x,:y), 'km' ) < 1 ORDER BY DISTANCE(Location__c, GEOLOCATION(:x,:y), 'km')];
                                System.debug('+++++lstPropertyWithInOneKm++++'+lstPropertyWithInOneKm);

                                if(lstPropertyWithInOneKm !=NULL && !lstPropertyWithInOneKm.isEmpty())
                                {
                                    //Check if the exact match occur in onekm with google verified 
                                    for(master__C objPro:lstPropertyWithInOneKm){
                                        if(objPro.Verification_Status__c == GenericConstants.PROPERTY_GOOGLE_VERIFIED){                                          
                                                objLead.Property__c = objPro.Id;
                                                objLead.Property_Type__c = propertyType;
                                               // objLead.Lead_Property_Name__c =objPro.Name;
                                                update objLead;
                                                bGoogleVerifiedExactStringMatch = true;
                                                updateMaster(Name,objPro,GooglePropertyID,objLead.id);
                                                FinalWrapper fin = new FinalWrapper(true,'');
                                                finalList.add(fin);
                                                break;                                             
                                        }
                                    } 
                                }
                            }   

                            //If Exact String is Not matched Check For SubString Match 
                            if(!bGoogleVerifiedExactStringMatch){
                                Name = Name.replaceAll('[^a-zA-Z\\s+]', '');
                                Name = Name.replaceAll('[0-9]', '');
                                Name = Name.trim();
                                system.debug('name '+ Name);
                                String nameWords='';
                                Set<string> newWordsSet = new Set<String>();
                                if(String.isNotBlank(Name)){
                                    for(String sNewWords:Name.split(' ')){
                                        if(sNewWords.length() >2){
                                            nameWords ='%'+sNewWords+'%';
                                            newWordsSet.add(nameWords);
                                        }
                                    }
                                    System.debug('newWordsSet '+ newWordsSet);
                                }
                                lstGoogleVerifiedProperty = [Select id,Name,Unique_Name__c,Verification_Status__c,PlaceId__c,Description__c
                                                                from Master__c
                                                                Where Verification_Status__c = 'Google Verified'
                                                            AND Name Like  :newWordsSet];
                                System.debug('+++++lstGoogleVerifiedProperty++++'+lstGoogleVerifiedProperty);                                
                                if(lstGoogleVerifiedProperty!= NULL && !lstGoogleVerifiedProperty.isEmpty()){                               
                                    for(master__C objPro:lstGoogleVerifiedProperty){
                                        if(objPro.Verification_Status__c == GenericConstants.PROPERTY_GOOGLE_VERIFIED){ 
                                            //FullName Check
                                            if(matchPropertyName(objPro.Name,sUniqueName)){                                         
                                                objLead.Property__c = objPro.Id;
                                                 objLead.Property_Type__c = propertyType;
                                                //objLead.Lead_Property_Name__c = objPro.Name;
                                                update objLead;
                                                bGoogleVerifiedStringMatch = true;
                                                updateMaster(Name,objPro,GooglePropertyID,objLead.id);
                                                FinalWrapper fin = new FinalWrapper(true,'');
                                                finalList.add(fin);
                                                break;      
                                            }                                           
                                        }
                                    }                                      
                                } 
                            }

                            if(!bGoogleVerifiedExactStringMatch && !bGoogleVerifiedStringMatch) {
                                if(lstPropertyWithInOneKm !=NULL && !lstPropertyWithInOneKm.isEmpty())
                                {
                                //Check if the exact match occur in onekm with Manually verified 
                                    for(master__C objPro:lstPropertyWithInOneKm){
                                        if(objPro.Verification_Status__c == GenericConstants.PROPERTY_MANUALLY_VERIFIED){                                          
                                            objLead.Property__c = objPro.Id;
                                             objLead.Property_Type__c = propertyType;
                                            //objLead.Lead_Property_Name__c = objPro.Name;
                                            update objLead;
                                            bManuallyVerifiedExactMatch = true;
                                            updateMaster(Name,objPro,GooglePropertyID,objLead.id);
                                            FinalWrapper fin = new FinalWrapper(true,'');
                                            finalList.add(fin);
                                            break;                                             
                                        }
                                    } 
                                }   
                            }

                            if(!bGoogleVerifiedExactStringMatch && !bGoogleVerifiedStringMatch && !bManuallyVerifiedExactMatch) {
                                lstManuallyVerifiedProperty = [Select id,Name,Unique_Name__c,PlaceId__c,Description__c from Master__c
                                                                Where Verification_Status__c = 'Manually Verified'];
                                System.debug('+++++lstManuallyVerifiedProperty++++'+lstManuallyVerifiedProperty);                                 
                                if(lstManuallyVerifiedProperty !=NULL && !lstManuallyVerifiedProperty.isEmpty())
                                {
                                //Check if the SubString match occur in record
                                    for(master__C objPro:lstManuallyVerifiedProperty){                                                                                  
                                        if(matchPropertyName(objPro.Name,sUniqueName)){                                         
                                            objLead.Property__c = objPro.Id;
                                             objLead.Property_Type__c = propertyType;
                                            //objLead.Lead_Property_Name__c = objPro.Name;
                                            update objLead;
                                            bManuallyVerifiedMatch = true;
                                            updateMaster(Name,objPro,GooglePropertyID,objLead.id);
                                            FinalWrapper fin = new FinalWrapper(true,'');
                                            finalList.add(fin);
                                            break;      
                                        } 
                                    } 
                                }   
                            }

                            if(!bGoogleVerifiedExactStringMatch && !bGoogleVerifiedStringMatch && 
                                !bManuallyVerifiedExactMatch && !bManuallyVerifiedMatch){
                                    newProperty = createMaster(JSON_Input,mapRecordType.get((String)JSON_Input.get(GenericConstants.PROPERTY_TYPE_INPUT)),GenericConstants.PROPERTY_GOOGLE_VERIFIED,inputData);
                                    objLead.Property__c = newProperty.Id;
                                     objLead.Property_Type__c = propertyType;
                                   //objLead.Lead_Property_Name__c= newProperty.Name;
                                    update objLead;
                                    FinalWrapper fin = new FinalWrapper(true,'');
                                    finalList.add(fin);
                            }
                        }
                    }        
                } 
                else{
                    if( String.isBlank(updatePropertyTypeOnly)){
                        newProperty = createMaster(JSON_Input,mapRecordType.get((String)JSON_Input.get(GenericConstants.PROPERTY_TYPE_INPUT)),GenericConstants.PROPERTY_GOOGLE_NOT_VERIFIED,inputData);
                        objLead.Property__c = newProperty.Id;
                    }
                   
                    objLead.Property_Type__c = propertyType;
                    //objLead.Lead_Property_Name__c= newProperty.Name;
                    update objLead;
                    FinalWrapper fin = new FinalWrapper(true,'');
                    finalList.add(fin);
                    //CallOutToR_Function.callFunction(objLead.id);
                }
            }
            else{
                FinalWrapper fin = new FinalWrapper(false,'Lead Id Is not Present ');
                finalList.add(fin);
            }
        
        }   

        catch(Exception e){
             System.debug('Exception occured'+e.getMessage()+''+e.getStackTraceString());
            Logger.log('Exception','AddressInfoAPI','AddressInfoAPI',e.getMessage(),e.getStackTraceString(),NULL);
           
            FinalWrapper fin = new FinalWrapper(false,e.getMessage());
            finalList.add(fin);
            
        } 
        if(!Test.isRunningTest()){string json_data = json.serialize(finalList);RestContext.response.addHeader('Content-Type', 'application/json');RestContext.response.responseBody = Blob.valueOf(json_data);}                            
    }
    /*********************************************************************************************************  
    * Name: matchPropertyName
    * Description : Matches the Property Name by removing special character
    *=============================== Modification Log ================================
    * Balaji    ----- 17/06/2019 --------Don't compare if the Name conatins is a single letter 
    *********************************************************************************************************/ 
    Public static Boolean matchPropertyName(String sExisting,String sMatchString){
        try{
            Boolean sStringMatchWithExisting = false;
            Boolean sStringMatchWithNew = false;
			System.debug('sExisting: '+sExisting);
                System.debug('sMatchString: '+sMatchString);
            if(String.isNotBlank(sExisting) && String.isNotBlank(sMatchString)){
                
                if(sMatchString.length() > 2){
                    for(String sNewWords:sMatchString.split(' '))
                    {
                        if(sExisting.containsIgnoreCase(sNewWords)){
                            sStringMatchWithExisting = true;
                        }
                        else{
                            sStringMatchWithExisting = false;
                            break;
                        }
                    }
                } 

                if(!sStringMatchWithExisting){
                    if(sExisting.length()>2){
                        for(String sOldWords:sExisting.split(' '))
                        {
                            if(sMatchString.containsIgnoreCase(sOldWords)){
                                sStringMatchWithNew = true;
                            }
                            else{
                                sStringMatchWithNew = false;
                                break;
                            }    
                        }
                    }
                }
            }
            System.debug('sStringMatchWithNew: '+sStringMatchWithNew);
            System.debug('sStringMatchWithExisting: '+sStringMatchWithExisting);
            return sStringMatchWithNew||sStringMatchWithExisting?true:false;
        }  
          
        catch(Exception e){
            Logger.log('Exception','AddressInfoAPI','AddressInfoAPI',e.getMessage(),e.getStackTraceString(),NULL);
            return NULL;
        }  
    }

    global class FinalWrapper{
        public boolean status{get;set;}
        public String errorMsg{get;set;}

        public FinalWrapper(Boolean bStatus,String sErrorMsg)
        {
            this.status = bStatus;
            this.errorMsg = sErrorMsg;
        }
    }

    public Static void updateMaster(String Name,Master__c objmaster,String PlaceID, String leadId){
        try{ 
            if(String.isNotBlank(Name) && String.isNotBlank(PlaceID)){
                if(String.isBlank(objmaster.Description__c)){
                    objmaster.Description__c = Name + ' Property Merged with ' +objmaster.Name + ' for lead Id: '+leadId;
                }
                else {
                    objmaster.Description__c = Name + ' Property Merged with ' +objmaster.Name+ ' for lead Id: '+leadId+ '\n'+objmaster.Description__c;
                }
                if(String.isBlank(objmaster.PlaceId__c))
                {
                    objmaster.PlaceId__c = PlaceID ;
                }
                else if((objmaster.PlaceId__c +';'+PlaceID).length()>255){
                    system.debug('Lenght'+(objmaster.PlaceId__c +';'+PlaceID).length());
                }
                else{
                    objmaster.PlaceId__c = objmaster.PlaceId__c +';'+PlaceID;
                }
                system.debug('objmaster----updateMaster'+objmaster);
                update objmaster;
            }
        }   
        catch(Exception e){
            Logger.log('Exception','AddressInfoAPI','AddressInfoAPI',e.getMessage(),e.getStackTraceString(),NULL);
           
        }    
    }

    Public Static String removeString(String Name){
        String newString;
        String s1;
        String s2;
        try{
            if(String.isNotBlank(Name)){
                System.debug('+++Name Before++'+Name);

                //Add Space at begining and Ending of the word
                Name = ' '+Name.toLowerCase()+' ';
                System.debug('+++Name lower++'+Name);
                //replace Double space with single space  
                Name = Name.replace('  ',' ');

               
                //Remove the Number 
                Name = Name.replaceAll('[0-9]', '');

                // Remove Special Character  
                Name = Name.replaceAll('[^a-zA-Z\\s+]', '');
               

                list<RedundantPropertyString__mdt> lstRedundantString = new list<RedundantPropertyString__mdt>();
                lstRedundantString = [Select Label,Priority__c,RedundantString__c,IsPreposition__c from RedundantPropertyString__mdt
                                    order by Priority__c ASC];
                System.debug('+++PropertyMatchString__c ++'+lstRedundantString);
                for(RedundantPropertyString__mdt strRemove:lstRedundantString){
                    if(strRemove.IsPreposition__c == true){
                        newString =' '+strRemove.RedundantString__c.toLowerCase()+' ';
                        Name = Name.replace(newString,' ');
                    }else{
                        Name = Name.remove(strRemove.RedundantString__c);
                    }  
                }

                 //Replace Double space with single space  
                Name = Name.replace('  ',' ');


                //Remove white Space from begining and End
                Name = Name.trim();
                System.debug('+++Name After++'+Name);
                return Name; 

            }
            return NULL;
        }    
        catch(Exception e){
            System.debug('Exception occured'+e.getMessage()+''+e.getStackTraceString());
            Logger.log('Exception','AddressInfoAPI','AddressInfoAPI',e.getMessage(),e.getStackTraceString(),NULL);
            return NULL;
        }
    }

    Public Static Master__c createMaster( Map<String, Object> JSON_Input, String RecordTypeID,String verificationType,String inputJson){
        try{
            Master__c objMaster = new Master__c();
            objMaster.PlaceId__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_PLACEID))? (String)JSON_Input.get(GenericConstants.PROPERTY_PLACEID):'';
            objMaster.RecordTypeId =String.isNotBlank(RecordTypeID)? RecordTypeID:''; 
            objMaster.Verification_Status__c = String.isNotBlank(verificationType)? verificationType: '';
            ObjMaster.DataBase_Type__c = verificationType == GenericConstants.PROPERTY_GOOGLE_VERIFIED ?GenericConstants.PROPERTY_VERIFYTYPE_GOOGLE:GenericConstants.PROPERTY_VERIFYTYPE_UNVERIFIED;
            objMaster.Name = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_NAME))? String.ValueOf((String)JSON_Input.get(GenericConstants.PROPERTY_NAME)).length()>80?String.ValueOf((String)JSON_Input.get(GenericConstants.PROPERTY_NAME)).substring(0, 79): (String)JSON_Input.get(GenericConstants.PROPERTY_NAME):'';
            objMaster.Full_Name__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_NAME))? (String)JSON_Input.get(GenericConstants.PROPERTY_NAME):'';
            objMaster.Property_City__c =String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_CITY))? (String)JSON_Input.get(GenericConstants.PROPERTY_CITY):'';
            objMaster.Property_Locality__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LOCALITY))? (String)JSON_Input.get(GenericConstants.PROPERTY_LOCALITY):'';
            objMaster.Property_Landmark__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LANDMARK))? (String)JSON_Input.get(GenericConstants.PROPERTY_LANDMARK):'';
            objMaster.Street__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_STREET))? (String)JSON_Input.get(GenericConstants.PROPERTY_STREET):'';
            objMaster.Property_State__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_STATE))? (String)JSON_Input.get(GenericConstants.PROPERTY_STATE):'';
            objMaster.Google_Map_Link__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_MAPLINK))? (String)JSON_Input.get(GenericConstants.PROPERTY_MAPLINK):'';
            objMaster.Property_Lat_Long__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LATLNG))? (String)JSON_Input.get(GenericConstants.PROPERTY_LATLNG):'';
            objMaster.Property_Type__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_PROP_TYPE))? (String)JSON_Input.get(GenericConstants.PROPERTY_PROP_TYPE):'';
            objMaster.Unique_Name__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_NAME))?removeString((String)JSON_Input.get(GenericConstants.PROPERTY_NAME)).replaceAll( '\\s+', ''):'';
            objMaster.JSON__c =  String.isNotBlank(String.valueOF(inputJson))?String.valueOF(inputJson):''; 
            objMaster.CreatedUser__c = String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_USERNAME))? (String)JSON_Input.get(GenericConstants.PROPERTY_USERNAME):'';
            //objMaster.Location__latitude__s = (Decimal.valueOf((String)JSON_Input.get('lat')))!=NULL?(Decimal.valueOf((String)JSON_Input.get('lat'))): NULL;
            //objMaster.Location__longitude__s = (Decimal.valueOf((String)JSON_Input.get('lng')))!=NULL? (Decimal.valueOf((String)JSON_Input.get('lng'))): NULL;
            //objMaster.Property_Postal_Code__c = Integer.valueOf((String)JSON_Input.get('Postal Code')) != NULL ?Integer.valueOf((String)JSON_Input.get('Postal Code')):NULL;
            if((String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LAT)))){objMaster.Location__latitude__s=Decimal.valueOf((String)JSON_Input.get(GenericConstants.PROPERTY_LAT));}
            if(String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_LNG))){objMaster.Location__longitude__s=Decimal.valueOf((String)JSON_Input.get(GenericConstants.PROPERTY_LNG));}
            if(String.isNotBlank((String)JSON_Input.get(GenericConstants.PROPERTY_POSTALCODE))){objMaster.Property_Postal_Code__c=Decimal.valueOf((String)JSON_Input.get(GenericConstants.PROPERTY_POSTALCODE));}
        
            insert objMaster;
            system.debug('aaaaaaaa'+objMaster);
            return objMaster;
        }
        catch(Exception e){
            Logger.log('Exception','AddressInfoAPI','createMaster',e.getMessage(),e.getStackTraceString(),NULL);
            return NULL;
        }
    }
}