({
	getAllPreviousStage : function(component) {
        var self="this";
        console.log('in helper previouse component');
        var action = component.get("c.getAllPreviousStage");
        //console.log('in helper previouse component111',component.get("v.theOpp.StageName"));
        action.setParams({ 
            "stageName" : component.get("v.stageName")
        });
        action.setCallback(self, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listWrapSec",response.getReturnValue());
                console.log('in helper previouse component3333333sssssssss ',response.getReturnValue());
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
    setShow : function(component,indexNum) {
        var listWrapSec = component.get("v.listWrapSec");
        listWrapSec[indexNum].isShow = true;
    },
})