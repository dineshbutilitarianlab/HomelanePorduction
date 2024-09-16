({
	getOpprtunityStages : function(component) {
        var action = component.get("c.getOpportunityStages");
        var self = this;
        action.setCallback(self, function(response) {                  
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listStage",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }           
        });
        $A.enqueueAction(action);
    },
    refresh : function(component) {
        var action = component.get("c.refresh");
        var self = this;
        
        action.setCallback(self, function(response) {                  
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isRefresh",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }           
        });
        $A.enqueueAction(action);
    },
})