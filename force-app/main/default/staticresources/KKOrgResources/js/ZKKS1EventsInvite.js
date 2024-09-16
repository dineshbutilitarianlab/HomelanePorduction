/**********************************************/
/*    
    Global Variables
*/
/**********************************************/
Visualforce.remoting.timeout = 120000; // Sets the timeout for the VF remoting calls; max 120000 milliseconds allowed
var recentlyViewed = new Object();
var searchResult = new Object();
var selectedItems = new Array();
var selectedPeople = new Array();
var alreadyInvitedPeople = new Array();
init();

/**********************************************/
/*    
    Init functions
*/
/**********************************************/
function init() {
    getRecentlyViewedPeople();
    Sfdc.canvas.publisher.subscribe({name: "publisher.showPanel",
            onData:function(e) {
                Sfdc.canvas.publisher.publish({name:"publisher.setValidForSubmit", payload:"true"});
        }});

    Sfdc.canvas.publisher.subscribe({ 
            name:"publisher.post",
            onData: function(e){
                addInvitees();
            }    
        })
}

/**********************************************/
/*    
    Create Event Relations
*/
/**********************************************/
function addInvitees(){
	//var relIds = _.pluck(selectedPeople,'id');
	var relIds = selectedPeople.map(function(item){
					return item.id;
				})
	console.log('relation ids',relIds);
	console.log('Event id is', evtId);
	Visualforce.remoting.Manager.invokeAction(
        'ZKKS1EventsInviteController.addInvitees', evtId, relIds,
        function(result, event) {
            if (!!result && event.status) {
                var ret = JSON.parse(result);
                if (ret.success) {
                    alert(ret.message);
                    Sfdc.canvas.publisher.publish({name:"publisher.close",payload:{refresh:"true"}});
                } else {
                	alert('Error in adding invites: ' + JSON.parse(ret.message));
                }
            } else {
            	alert('Error in calling addInvitees module')
            }
        }, {
            escape: false
        });	
}


/**********************************************/
/*    
    Get recently viewed people
*/
/**********************************************/
function getRecentlyViewedPeople() {
    Visualforce.remoting.Manager.invokeAction(
        'ZKKS1EventsInviteController.getRecentlyViewedPeople',
        function(result, event) {
            if (!!result && event.status) {
                var ret = JSON.parse(result);
                if (ret.success) {
                    recentlyViewed = JSON.parse(ret.message);
                } else {

                }
            } else {
                console.log('Error in calling search function');
            }
           	getAlreadySelectedPeople()
            show('_searchContainer');

        }, {
            escape: false
        });
}


function getAlreadySelectedPeople(){

	// Remove recently viewed people from already selected people
	filterRecentlyViewed();

	hide('_spinner');
	showSelectedPeople();

}

function filterRecentlyViewed(){
	_.each(selectedPeople,function(item){
		var removedItem = _.remove(recentlyViewed,function(sitem){
			return sitem.id==item.id;
		})
	})
}

/**********************************************/
/*    
    Search for people to add to the invite
*/
/**********************************************/
function searchPeople(q) {
	show('_spinner');
    Visualforce.remoting.Manager.invokeAction(
        'ZKKS1EventsInviteController.searchPeople', q,
        function(result, event) {
            if (!!result && event.status) {
                var ret = JSON.parse(result);
                if (ret.success) {
                    searchResult = JSON.parse(ret.message);
                    filterAlreadySelectedItems();
                } else {

                }
            } else {
                console.log('Error in calling search function');
            }
            hide('_spinner');
        }, {
            escape: false
        });
}

/**********************************************/
/*    
    Filter search results
*/
/**********************************************/

function filterAlreadySelectedItems(){
	_.each(selectedPeople,function(item){
		var removedItem = _.remove(searchResult,function(sitem){
			return sitem.id==item.id;
		})
	})
	console.log('Search results is', searchResult);
	searchResult = _.uniqBy(searchResult,'id');

	if(_.size(searchResult)>0){
		showSearchResults();
	}else{
		alert('No matching results');
		document.getElementById("_lookup").value = '';
		searchDropDownHide();
	}
}


/**********************************************/
/*    
    Show search results
*/
/**********************************************/
function showSearchResults() {
    var html = '<ul class="slds-list--vertical slds-has-dividers--bottom-space slds-has-selection slds-m-top--small">' + 
    				'<div class="slds-grid">'+
    				'<button id="_selectButton" class="slds-col slds-size--1-of-2 slds-button slds-button--brand" disabled onclick="addSelectedItemstoPeople();">Select</button>'+
        			'<button class="slds-col slds-size--1-of-2 slds-button slds-button--neutral" onclick="cancelSelectedItems();">Cancel</button>'+
        			'</div>';

    _.each(searchResult, function(item, index) {
        var icon = getIconType(item.type);
        html = html +
        	'<li class="slds-list__item" onclick="toggleSelect(' + "'" + item.id + "');" + '">' +
            '<div class="slds-media slds-tile">' +
            '<div class="slds-media__figure">' +
            '<svg aria-hidden="true" class="slds-icon ' + icon.type + '">' +
            '<use xlink:href="' + sldsAssetUrl + icon.svg + '"></use>' +
            '</svg>' +
            '</div>' +
            '<div class="slds-media__body">' +
            '<p class="slds-tile__title slds-truncate"><a>' + item.name + '</a></p>' +
            '<ul class="slds-tile__detail slds-list--horizontal slds-has-dividers slds-text-body--small">' +
            '<li class="slds-truncate slds-list__item">' + item.email + '</li>' +
            '</ul>' +
            '</div>' +

            '<div id="_check' + item.id + '" class="slds-media__figure slds-hide">' +
            '<svg aria-hidden="true" class="slds-icon slds-icon-text-default slds-icon--small">' +
            '<use xlink:href="' + sldsAssetUrl + 'icons/utility-sprite/svg/symbols.svg#check"></use>' +
            '</svg>' +
            '</div>' +

            '</div>' +
            '</li>';
    });

    html = html + '</ul>';

    hide('_lookupListBox');
    show("_searchListContainer");
    var searchListContainer = document.getElementById("_searchListContainer");
    searchListContainer.innerHTML = html;


}


/**********************************************/
/*    
    Show selected people
*/
/**********************************************/
function showSelectedPeople() {
    var html = '<ul class="slds-list--vertical slds-has-dividers--bottom-space slds-has-selection slds-m-top--small">' ;

    _.each(selectedPeople, function(item, index) {
        var icon = getIconType(item.type);
        html = html +
        	'<li id="_people' + item.id + '" class="slds-list__item ">'+ 
            '<div class="slds-media slds-tile">' +
            '<div class="slds-media__figure">' +
            '<svg aria-hidden="true" class="slds-icon ' + icon.type + '">' +
            '<use xlink:href="' + sldsAssetUrl + icon.svg + '"></use>' +
            '</svg>' +
            '</div>' +
            '<div class="slds-media__body">' +
            '<p class="slds-tile__title slds-truncate"><a>' + item.name + '</a></p>' +
            '<ul class="slds-tile__detail slds-list--horizontal slds-has-dividers slds-text-body--small">' +
            '<li class="slds-truncate slds-list__item">' + item.email + '</li>' +
            '</ul>' +
            '</div>' +

            '<div class="slds-media__figure" ' + 'onclick="deleteSelectedPeople(' + "'" + item.id + "');" + '">' +
            '<svg aria-hidden="true" class="slds-icon slds-icon-text-default slds-icon--small">' +
            '<use xlink:href="' + sldsAssetUrl + 'icons/utility-sprite/svg/symbols.svg#close"></use>' +
            '</svg>' +
            '</div>' +

            '</div>' +
            '</li>';
    });

    html = html + '</ul>';

    show("_selectedListContainer");
    var selectedListContainer = document.getElementById("_selectedListContainer");
    selectedListContainer.innerHTML = html;
    filterRecentlyViewed();
   

}

/**********************************************/
/*    
    Delete Item
*/
/**********************************************/

function deleteSelectedPeople(id){
	var removeItem = _.remove(selectedPeople,function(item){
						return item.id==id;
					})
	recentlyViewed = _.union(recentlyViewed,removeItem);
	hide('_people'+id);
}

/**********************************************/
/*    
    Select Item
*/
/**********************************************/
function toggleSelect(id) {

    var selectedItem = _.find(searchResult, function(item) {
        return item.id == id;
    });
    var alreadySelectedItem = _.find(selectedItems, function(item) {
        return item.id == id;
    })
 
    if (_.isUndefined(alreadySelectedItem)) {
        show('_check' + id);
        selectedItems.push(selectedItem);
    } else {
        hide('_check' + id);
        removedItems = _.remove(selectedItems,function(item){
        					return item.id==id;
        				})
         
    }

    var selectButton = document.getElementById('_selectButton');
    if(_.size(selectedItems)>0){
    	selectButton.disabled = false;
    }else{
    	selectButton.disabled = true;
    }

    
}

/**********************************************/
/*    
    Add selected record to selected people
*/
/**********************************************/
function addSelectedItemstoPeople(){
	document.getElementById("_lookup").value = '';
	searchDropDownHide();
	if(_.size(selectedItems)>0)  selectedPeople = _.union(selectedPeople,selectedItems);
	selectedPeple = _.uniqBy(selectedPeople,'id');
	selectedItems = new Array();
	showSelectedPeople();
	hide('_searchListContainer');
}

/**********************************************/
/*    
    Cancel selected record to selected people
*/
/**********************************************/
function cancelSelectedItems(){
	document.getElementById("_lookup").value = '';
	hide('_searchListContainer');
	show('_selectedListContainer');
}



/**********************************************/
/*    
    Hide Search dropdown
*/
/**********************************************/
function searchDropDownHide() {
    var value = document.getElementById("_lookup").value;
    if (value == null || value == '' || value == ' ') {
        hide('_lookupListBox');
        show('_selectedListContainer');
    }
}


/**********************************************/
/*    
    Type Ahead function
*/
/**********************************************/
function typeAhead() {
    hide('_selectedListContainer');
    hide('_searchListContainer');
    var value = document.getElementById("_lookup").value;
    var lookupList = document.getElementById("_lookupList");
    var html = '';

    var filteredList;
    //var filteredList = _.clone(recentlyViewed);

    if (value != null && value != '') {

        html = '<button class="slds-button" onClick="searchPeople(' + "'" + value + "');" + '">' +
            ' <svg aria-hidden="true" class="slds-icon slds-icon-text-default slds-icon--small">' +
            '<use xlink:href="' + sldsAssetUrl + 'icons/utility-sprite/svg/symbols.svg#search"></use>' +
            '</svg>&quot;' + value + '&quot; in Contacts, Leads & Users</button>';

        //Recently viewed contacts
        filteredList = _.filter(recentlyViewed, function(item) {
            return (item.name.toLowerCase().indexOf(value.toLowerCase()) > -1);
        });

    };


    if (_.size(filteredList) > 0) {
   		 show('_lookupListBox');
        _.each(filteredList, function(item, index) {
            var icon = getIconType(item.type);
            html = html +
                '<li class="slds-lookup__item" role="presentation">' +
                '<a role="option" onclick="addRecentToSelectedItem(' + "'" + item.id + "');" + '">' +
                '<svg aria-hidden="true" class="slds-icon slds-icon--small ' + icon.type + '">' +
                '<use xlink:href="' + sldsAssetUrl + icon.svg + '"></use>' +
                '</svg>' + item.name + '</a></li>';
        });
    }

    lookupList.innerHTML = html;
}

/**********************************************/
/*    
    Get Icons and Icon Type
*/
/**********************************************/

function addRecentToSelectedItem(id){

	var selectedItem = _.find(recentlyViewed, function(item) {
        return item.id == id;
    });
    selectedItems.push(selectedItem);
    addSelectedItemstoPeople();

}

/**********************************************/
/*    
    Get Icons and Icon Type
*/
/**********************************************/
function getIconType(type) {
    var icon = new Object();
    icon.type = 'slds-icon-standard-contact';
    icon.svg = 'icons/standard-sprite/svg/symbols.svg#contact';
    switch (type) {
        case 'Lead':
            icon.type = 'slds-icon-standard-lead';
            icon.svg = 'icons/standard-sprite/svg/symbols.svg#lead';
            break;
        case 'User':
            icon.type = 'slds-icon-standard-user';
            icon.svg = 'icons/standard-sprite/svg/symbols.svg#user';
            break;
    }
    return icon;

}
