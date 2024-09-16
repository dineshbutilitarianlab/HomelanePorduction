({
    //To get all Sections,SubSections,Items,Responses
    doInit : function(component, event, helper) {
        //to check we are in lightning or not
        if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
            component.set("v.isLightning",false); //set flase if we are in lightning.
        }else{
            component.set("v.isLightning",true); // set true if we are not in lightning.
        }
        helper.getOpprtunityStages(component);
 
        // To get all Sections,Sub Sections,Items and Responses from data base.
        helper.getResponse(component,component.get("v.theOpp.StageName"));
    },
    edit : function(component, event, helper) {
        component.set("v.edit", true);
    },
    //on click of 'Cancel' button page will be redirected to Detail viewof Opportunity.
    cancel : function(component, event, helper) {
        component.set("v.edit",false);
    },
    //On Click of 'Save' button saving Opportunity information and SalesCoach information. 
    save : function(component, event, helper) {
        helper.showSpinner(component);  
        var oppData = JSON.stringify($( '[id$=formId]' ).serializeArray());
        //Converting SalesCoach data into JSON.
        var data = $A.util.json.encode(component.get("v.listWrapSec"));
        helper.saveData(component, data,oppData);
        
    },
    //Function to toggle [+] or [-] icon. 
    toggleCollapse : function(component, event, helper) {
        var curElement = event.target || event.srcElement;
        var parElement = event.target.parentElement.parentElement.parentElement || event.srcElement.parentElement.parentElement.parentElement;
        if( curElement.classList[3] === 'fa-plus-square-o'){
            $A.util.removeClass(curElement, 'fa-plus-square-o');
            $A.util.addClass(curElement, 'fa-minus-square-o');
        }else{
            $A.util.removeClass(curElement, 'fa-minus-square-o');
            $A.util.addClass(curElement, 'fa-plus-square-o');
        }     
        $A.util.toggleClass(parElement.childNodes[1],"toggle");
    },
    toggleSubSec : function(component, event, helper) {
        var curElement = event.target || event.srcElement;
        // to Hide sub section content
        var subSecContentElement = curElement.parentElement.parentElement.nextSibling.nextSibling;
        $(subSecContentElement).toggleClass("hideReasonWon");
        
        // to change icon.
        if( curElement.classList[3] === 'fa-sort-asc'){
            $A.util.removeClass(curElement, 'fa-sort-asc');
            $A.util.addClass(curElement, 'fa-sort-desc');
        }else{
            $A.util.removeClass(curElement, 'fa-sort-desc');
            $A.util.addClass(curElement, 'fa-sort-asc');
        }                 
    }
})