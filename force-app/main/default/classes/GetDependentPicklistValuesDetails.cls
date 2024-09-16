Public class GetDependentPicklistValuesDetails{
    public static Map<String,List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        //system.debug('depend'+depend);
        //system.debug('controlToken'+controlToken);
        if (controlToken == null){ 
            return null;        
        }
        else{
            Schema.DescribeFieldResult control = controlToken.getDescribe();
            List<Schema.PicklistEntry>  controlEntries = (control.getType() == Schema.DisplayType.Boolean ? null : control.getPicklistValues());
            //system.debug('controlEntries '+controlEntries );
            for(Schema.PicklistEntry sdf :controlEntries)
            system.debug('controlEntries '+sdf );
            String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
            Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
            
            for (Schema.PicklistEntry entry : depend.getPicklistValues()) if (entry.isActive()){
                List<String> base64chars = String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                //system.debug('base64chars'+base64chars.size()+ '----->'+entry);
                if(!base64chars.isEmpty()){
                    //system.debug('base64chars11111111'+base64chars+ '----->'+entry);
                    for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                        Object controlValue = (controlEntries == null ? (Object) (index == 1) : (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getValue() : null));
                        //system.debug('--controlValue--'+controlValue);
                        Integer bitIndex = index / 6, bitShift = 5 - Math.mod(index, 6);
                        if(base64chars.size()>bitIndex){
                           // system.debug('--base64chars[ bitIndex ]--'+base64chars[ bitIndex ]);
                        
                        
                            if (controlValue == null || (base64map.indexOf(base64chars[ bitIndex ]) & (1 << bitShift)) == 0) continue;
                            
                            if (!dependentPicklistValues.containsKey(String.Valueof(controlValue)))
                            dependentPicklistValues.put( String.Valueof(controlValue), new List<String>() );
                            dependentPicklistValues.get( String.Valueof(controlValue) ).add( entry.getLabel() );
                            //system.debug('dependentPicklistValues'+dependentPicklistValues);
                            }
                    }
                }   
            }
                                
            for(String obj : dependentPicklistValues.keySet()){
                system.debug('dependentPicklistValues'+String.Valueof(obj));
               
            }
            system.debug('dependentPicklistValues'+dependentPicklistValues);
            return dependentPicklistValues;
        }

    }
    
    public static Map<String,List<String>> getDependentPicklistValues(String sObjectName, String fieldName) {
        return getDependentPicklistValues(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName));
    }
 }