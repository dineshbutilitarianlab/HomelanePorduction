/**********************************************/
/*    
    Utility Classes
*/
/**********************************************/
//Add a class to a DOM element
function addClass(id,className){
 var doc = document.getElementById(id);
 doc.className = doc.className.replace(className,"");
 doc.className = doc.className + className;
}
//Remove a class to a DOM element
function removeClass(id,className){
 var doc = document.getElementById(id);
 doc.className = doc.className.replace(className,"");
}
//Toggle a class in a DOM element
function toggleClass(id,from,to){
 removeClass(id,from);
 addClass(id,to);
}
//Show DOM element
function show(id){
	toggleClass(id,'slds-hide','slds-show');
}
//Hide DOM element
function hide(id){
	toggleClass(id,'slds-show','slds-hide');
}

