({
	closemodal : function(component, event, helper) {
		console.log('close modal');
        $( "#mainmodal" ).removeClass( "slds-slide-down-cancel" );
        $( "#fadediv" ).removeClass( "slds-backdrop_open" );
        $( "#fadediv" ).addClass( "slds-backdrop_close" );
	},
    loadnews: function(component, event, helper) {
		console.log('Loading news......');
        $( "#oneHeader" ).addClass( "slds-backdrop" );
        
	}
})