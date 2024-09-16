public class LeadGenerationHelper {
    public static Master__c LeadPropertyCreation(String inputData){
        
        
        list<Master__c> lstPropertyWithInOneKm = new list<Master__c>();
        list<Master__c> lstGoogleVerifiedProperty = new list<Master__c>();
        list<Master__c> lstManuallyVerifiedProperty = new list<Master__c>();
        list<Master__c> lstPropertyWithPropertyId = new list<Master__c>();
        Map<String,String> mapRecordType = new Map<String,String>();
        String Name;
        String sGooglePlaceId;
        String GooglePropertyID;
        String sUniqueName;
        Boolean bGoogleVerifiedExactStringMatch = false;
        Boolean bGoogleVerifiedStringMatch = false;
        Boolean bManuallyVerifiedExactMatch = false;
        Boolean bManuallyVerifiedMatch = false;
        Boolean bPropertIdMatch = false; 
        
        
        Master__c leadProperty = new Master__c();
        Map<String, Object> JSON_Input = (Map<String, Object>)JSON.deserializeUntyped(inputData);
        //Name = (String) JSON_Input.get('Name');
            Name = (String) JSON_Input.get(GenericConstants.PROPERTY_NAME);
           GooglePropertyID = (String) JSON_Input.get(GenericConstants.PROPERTY_PLACEID);
        //Get RecordTypeID and RecordTypeName From Salesforce 
                Schema.DescribeSObjectResult Master = Schema.SObjectType.Master__c;
                for(RecordTypeInfo reType : Master.getRecordTypeInfosByID().values()){
                   mapRecordType.put(reType.getDeveloperName(),reType.getRecordTypeId()); 
                }
        system.debug('propertyName'+ Name);
        system.debug('propertyName'+ GooglePropertyID );
        
           
        if(String.isNotBlank(Name) && String.isNotBlank(GooglePropertyID)){
            if(String.isNotBlank(GooglePropertyID)){
                sGooglePlaceId = '%'+GooglePropertyID+'%';
                lstPropertyWithPropertyId = [Select id,Name,PlaceId__c,Description__c from Master__c
                                             where PlaceId__c Like :sGooglePlaceId and Verification_Status__c = 'Google Verified'
                                             Limit 1];
                if(lstPropertyWithPropertyId!= NULL && !lstPropertyWithPropertyId.isEmpty()){
                    leadProperty = lstPropertyWithPropertyId[0];
                    
                    bPropertIdMatch = true;  
                    
                }                          
            }
                }
        if(!bPropertIdMatch){
                        sUniqueName = AddressInfoAPI.removeString(Name);
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
                                                leadProperty = objPro;
                                               // objLead.Lead_Property_Name__c =objPro.Name;
                                                //update objLead;
                                                bGoogleVerifiedExactStringMatch = true;
                                                AddressInfoAPI.updateMaster(Name,objPro,GooglePropertyID,null);
                                                
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
                                            leadProperty = objPro ;
                                            //objLead.Lead_Property_Name__c = objPro.Name;
                                            //update objLead;
                                            bManuallyVerifiedExactMatch = true;
                                            AddressInfoAPI.updateMaster(Name,objPro,GooglePropertyID,null);
                                            
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
                                        if(AddressInfoAPI.matchPropertyName(objPro.Name,sUniqueName)){                                         
                                            LeadProperty = objPro;
                                            //objLead.Lead_Property_Name__c = objPro.Name;
                                            //update objLead;
                                            bManuallyVerifiedMatch = true;
                                            AddressInfoAPI.updateMaster(Name,objPro,GooglePropertyID,null);
                                            
                                            break;      
                                        } 
                                    } 
                                }   
                            }

                            if(!bGoogleVerifiedExactStringMatch && !bGoogleVerifiedStringMatch && 
                                !bManuallyVerifiedExactMatch && !bManuallyVerifiedMatch){
                                   LeadProperty  = AddressInfoAPI.createMaster(JSON_Input,mapRecordType.get((String)JSON_Input.get(GenericConstants.PROPERTY_TYPE_INPUT)),GenericConstants.PROPERTY_GOOGLE_VERIFIED,inputData);
                                    //objLead.Property__c = newProperty.Id;
                                   //objLead.Lead_Property_Name__c= newProperty.Name;
                                    //update objLead;
                                    
                            }
                        }
                            
                
                else{
                        LeadProperty = AddressInfoAPI.createMaster(JSON_Input,mapRecordType.get((String)JSON_Input.get(GenericConstants.PROPERTY_TYPE_INPUT)),GenericConstants.PROPERTY_GOOGLE_NOT_VERIFIED,inputData);
                }
   
        
        
        return leadProperty;
        
    }
}