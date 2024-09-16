({
	doInit : function(component, event, helper) {
        helper.getAllPreviousStage(component);
        var currentStage = component.get("v.stageName");       
	},
    toggleCollapse : function(component, event, helper) { 
        var curElement = event.target;       
        var indexNum = event.target.parentElement.id; 
        var isShow = component.get("v.listWrapSec["+indexNum+"].isShow");
        if(!isShow){
            component.set("v.listWrapSec["+indexNum+"].isShow",true);
        }
        var parElement = event.target.parentElement.parentElement.parentElement || event.srcElement.parentElement.parentElement.parentElement;   
        if( $('#'+indexNum+'-icn').hasClass('fa-plus-square-o')){               
            $A.util.removeClass(curElement, 'fa-plus-square-o');
            $A.util.addClass(curElement, 'fa-minus-square-o');
        }else{
            $A.util.removeClass(curElement, 'fa-minus-square-o');
            $A.util.addClass(curElement, 'fa-plus-square-o');
        }        
        $A.util.toggleClass(parElement.childNodes[1],"toggle");
    },
})