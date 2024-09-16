({	//function to get all previous stage user resonses
	doInit : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getResponse(component);
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