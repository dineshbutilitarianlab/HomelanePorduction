({
    doInit : function(component, event, helper) {
        
        var currentStage = component.get("v.currentStage");
        if(currentStage == 'Closed Won'){
            component.set("v.isWon",true);
            component.set("v.isLost",false);
            component.set("v.isClosed",false);
        }else if(currentStage == 'Closed Lost'){
            component.set("v.isWon",false);
            component.set("v.isLost",true);
            component.set("v.isClosed",false);
        }else{
            component.set("v.isWon",false);
            component.set("v.isLost",false);
            component.set("v.isClosed",true);
        }
        if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
            component.set("v.isLightning",false);
        }else{
            component.set("v.isLightning",true);            
        }
        helper.getOpprtunityStages(component);
        
    },    
    doneRendering : function(component, event, helper) {
        var componentStage = component.find("test");
        var currentStage = component.get("v.currentStage");
        if(componentStage != undefined){
            if(componentStage.length > 0){
                for(var i=0;i<componentStage.length;i++){
                    if(componentStage[i].elements[0] != undefined && currentStage != undefined){
                        if(componentStage[i].elements[0].textContent === currentStage ){
                            if(componentStage[i].elements[0].textContent === 'Closed Lost'){
                                $A.util.addClass(componentStage[i], ' closedlost');
                            }else if(componentStage[i].elements[0].textContent === 'Closed Won'){
                                $A.util.removeClass(componentStage[i], 'slds-is-incomplete');
                                $A.util.addClass(componentStage[i], 'slds-is-current closedwon');
                            }else{
                                $A.util.removeClass(componentStage[i], 'slds-is-incomplete');
                                $A.util.addClass(componentStage[i], 'slds-is-current');
                                break;
                            }
                        }else{
                            if(currentStage !== 'Closed Lost'){
                                $A.util.removeClass(componentStage[i], 'slds-is-incomplete');
                                $A.util.addClass(componentStage[i], 'slds-is-complete');
                            }
                        }
                    }
                }
            }
        }
    },
    refreshCom : function(component, event, helper) {
        helper.refresh(component);
        //console.log('refresh...');
    },
})