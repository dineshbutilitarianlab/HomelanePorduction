({
	searchHelper : function(component,event,getInputkeyWord,picklistValue) {
	  // call the apex class method 
	 var action= "";
        if(picklistValue == "Property") {
      		action = component.get("c.fetchLookUpValuesProperty");
        }
        else if(picklistValue == "Builder") {
      		action = component.get("c.fetchLookUpValuesBuilder");
        } 
        else if(picklistValue == "Showroom") {
      		action = component.get("c.fetchLookUpValuesShowroom");
        }
        else if(picklistValue == ""){
            action = component.get("c.fetchLookUpValues");    
        }
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})