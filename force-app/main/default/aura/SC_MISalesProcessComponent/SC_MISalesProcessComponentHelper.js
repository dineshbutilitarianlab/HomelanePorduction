({	
    //function to save Opportunity Data and Sales coach data.
    saveData : function(component, data,oppData) {

        var StageToSave;
        var listStage = component.get("v.listStage");
        var StageName = component.get("v.theOpp.StageName");
        var newStage = component.get("v.newStage");
        if(newStage != 'none' && listStage.indexOf(newStage) < listStage.indexOf(StageName) ){
            StageToSave = newStage;
        }else{
            StageToSave = StageName;
        }
        //Calling 'saveData' apex controller with parameters.
        var action = component.get("c.saveData");
        action.setParams({
            "data" : data,
            "oppId" : component.get("v.theOpp.Id"),
            "stageName" : StageToSave,
        });
        //call back from Apex controller
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                component.set("v.edit",false);

            }
            this.hideSpinner(component)
        });       
        $A.enqueueAction(action);
    },
    //function to display Spinner
    showSpinner : function(component){
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--close");
        $A.util.addClass(spin, "slds-backdrop--open");
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-close");
        $A.util.addClass(spinChild, "slds-fade-in-open");
    },
    //function to hide Spinner
    hideSpinner : function(component){
        var spin = component.find("spinnerId");
        $A.util.removeClass(spin,"slds-backdrop--open");
        $A.util.addClass(spin, "slds-backdrop--close");
        
        var spinChild = component.find("spinnerIdChild");
        $A.util.removeClass(spinChild,"slds-fade-in-open");
        $A.util.addClass(spinChild, "slds-fade-in-close");
    },    
    //To get all Section,Subsections, Items and responses.
    getResponse : function(component) {
        var action = component.get("c.getResponse");
        console.log('Id--->'+component.get("v.theOpp.Id"));
        action.setParams({ 
            "oppId" : component.get("v.theOpp.Id"),
            "stageName" : component.get("v.theOpp.StageName"),
            "RecordTypeName": component.get("v.theOpp.RecordTypeId"),
            "NoOfKitchen":parseInt(component.get("v.theOpp.Additional_Number_Of_Kitchens__c")),
            "NoOfBedrooms":parseInt(component.get("v.theOpp.Additional_Number_Of_Bedrooms__c")),
            "NoOfFoyers":parseInt(component.get("v.theOpp.Additional_Number_Of_Foyers__c")),
            "NoOfLivingRooms":parseInt(component.get("v.theOpp.Additional_Number_Of_Living_Rooms__c")),
            "NoOfBathrooms":parseInt(component.get("v.theOpp.Additional_Number_Of_Bathrooms__c"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('list wrap sec ----->',response.getReturnValue());
                try{
                    component.set("v.listWrapSec",response.getReturnValue());
                }catch(e){
                    console.log('aura Exception : ',e.message);
                }
                if(component.get("v.edit")){ 
                    hideSpinnerDtl();
                }else{
                    hideSpinnerDtl();
                }
            }
            else if (state === "ERROR") {
                console.log('in error');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            if(component.get("v.edit")){ 
                hideSpinnerDtl();
            }
        });       
        $A.enqueueAction(action);
    },
    getOpprtunityStages : function(component) {
        var action = component.get("c.getOpportunityStages");
        var self = this;
        action.setCallback(this, function(response) {                  
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
    dltCommitmentUsrRsp : function(component) {
        var action = component.get("c.dltCommitmentUsrRsp"); 
        action.setParams({ 
            "oppId" : component.get("v.theOpp.Id"),
        });
        action.setCallback(this, function(response) {                  
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }           
        });
        $A.enqueueAction(action);
    },
})