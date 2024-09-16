({	//Function to previous stage user responses.
	getResponse : function(component) {
        console.log('in helper');
        var self = this;
        var action = component.get("c.getResponse");
        action.setParams({ 
            "oppId" : component.get("v.oppId"),
            "stageName" : component.get("v.stageName"),
            "RecordTypeName" :  component.get("v.recordTypeId")
        });
        action.setCallback(self, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listWrapSec",response.getReturnValue());
                console.log('in helper3333333 ',component.get("v.listWrapSec"));
                self.hideSpinner(component);
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
                self.hideSpinner(component);
            }
        });       
        $A.enqueueAction(action);
    },
    //Function to hide spinner
    hideSpinner : function(component){
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--open");
        $A.util.addClass(spin, "slds-backdrop--close");
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-open");
        $A.util.addClass(spinChild, "slds-fade-in-close");
    },    
    //Function to show spinner
    showSpinner : function(component){
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--close");
        $A.util.addClass(spin,"slds-backdrop--open");
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-close");
        $A.util.addClass(spinChild,"slds-fade-in-open");
    },
})