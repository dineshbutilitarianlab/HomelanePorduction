({
    clickjs : function(component, event, helper) {
        //console.log('8');
        helper.showSpinner(component);
        var proid = component.get("v.productid");
        helper.getProjectrec(component, proid);
        //console.log("completed..........");
    },
     editall:function(component, event, helper) {
        var prjectid = component.get("v.productid");
        //console.log('project id----->',prjectid);
        component.set("v.isEdit",true);
        
        
        console.log('test 1',prjectid);
 		console.log('seting value---- ',component.get("v.editallproductid"));
        component.set("v.editallproductid",prjectid);
 
         console.log('test 2');
         
         console.log('seting id --------',component.get("v.editallproductid"));
    },
    getsubmilestone : function(component, event, helper) {
        helper.showSpinner(component);
        //console.log('submilestone------',component.get('v.submilestone'))
        //console.log('event',event.target.getAttribute('id'));
        var submileid = event.target.getAttribute('id');
        component.set("v.parentid",submileid);
        helper.getSubmiles(component, submileid);
        
    },
    gettasks : function(component, event, helper) {
        helper.showSpinner(component);
        var submilesid = event.target.getAttribute('id');
        //console.log('submilesid',submilesid);
        component.set("v.submileparentid",submilesid);
        helper.getTask(component, submilesid);
        
    },
    getsubtasks : function(component, event, helper) {
		helper.showSpinner(component);
        var taskiids = event.target.getAttribute('ids');
        //console.log('taskiids',taskiids);
        helper.getSubtask(component, taskiids);
    },

    editRecord : function(component, event, helper) {
		//console.log('get status value ------->',component.get("v.statusval"));
        var prorecid = event.target.getAttribute('id');
        helper.editMilestone(component, prorecid);
    },
    edittaskseRec : function(component, event, helper) {
        var tasksrecid = event.target.getAttribute('id');
        helper.editTasks(component, tasksrecid);       
    },
   
     Popup: function(cmp){
        var cmpForm1 = cmp.find('form1');
        var cmpForm2 = cmp.find('form2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
    },
    
    submilePopup: function(cmp){
        var cmpForm1 = cmp.find('submileform1');
        var cmpForm2 = cmp.find('submileform2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
    },
    taskPopup: function(cmp){
        var cmpForm1 = cmp.find('taskform1');
        var cmpForm2 = cmp.find('taskform2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
    },
    savemile: function(cmp, event, helper){
        
        helper.showSpinner(cmp);

        var mileoldlist = cmp.get("v.projectrec");
        var submilrecid = event.target.getAttribute('id')
        console.log('submilrecid',submilrecid);
        var title = cmp.find('expname').get("v.value");
        var leadtime = cmp.find('leadtime').get("v.value");
        var actstr = cmp.find('actualstrtdate').get("v.value");
        var actend = cmp.find('actualenddate').get("v.value");
        var expstr = cmp.find('expectstrtdate').get("v.value");
        console.log('selected actstr ------->',expstr);
        var expend = cmp.find('expectenddate').get("v.value");
        var stats = cmp.find('selected-status').get("v.value");
        console.log('selected status ------->',stats);
        var compl = cmp.find('completion').get("v.value");
        var succ = cmp.find('successor').get("v.value");
        var prede = cmp.find('pedecessor').get("v.value");
        
        var obj = cmp.get("v.editrecordObj");
        
        obj.Title__c = title;
        obj.Id = submilrecid;
        obj.Expected_End_Date__c = expend;
        obj.Expected_Start_Date__c = expstr;
        obj.Completion__c = compl;
        obj.Actual_End_Date__c = actend;
        obj.Actual_Start_Date__c = actstr;
        obj.Lead_Time__c = leadtime;
        obj.Predecessor__c = prede;
        obj.Status__c = stats;
        obj.Successor__c = succ;
        var statusval = cmp.get("v.editrecord");
        console.log('statusval .....',statusval);
        
         console.log('typeof expstr',typeof expstr);
        console.log('typeof expend',typeof expend);
        console.log('typeof stats',typeof stats);
        console.log('stats',stats);
        console.log('statusval[0].Status__c',statusval[0].Status__c);
        if(   (typeof expstr == 'undefined' && typeof expend == 'undefined' ) || (typeof expstr == 'string' && typeof expend == 'undefined' ) || (typeof expstr == 'undefined' && typeof expend == 'string' )  && (( (stats == 'Not Started' || typeof stats === 'undefined' ) || statusval[0].Status__c == 'Started' || statusval[0].Status__c == 'Completed' || statusval[0].Status__c == 'Not Started') || (actstr > actend || expstr > expend))){
                console.log('if part8');
                var cmpForm1 = cmp.find('error1');
                var cmpForm2 = cmp.find('error2');
                $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
                $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
                $A.util.addClass(cmpForm1, 'slds-fade-in-open');
                $A.util.addClass(cmpForm2, 'slds-backdrop--open');
         }
        else{
            console.log('else part8');
            helper.saveMilerec(cmp,obj,mileoldlist);
            var proid = cmp.get("v.productid");
            helper.getProjectrec(cmp, proid);
        }
    },
    errorpopup:function(component, event, helper){
        var cmpForm1 = component.find('error1');
        var cmpForm2 = component.find('error2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
       
    },
    savesubmile: function(cmp, event, helper){
        
        var cmpForm1 = cmp.find('submileform1');
        var cmpForm2 = cmp.find('submileform2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
        helper.showSpinner(cmp);
        
        var mileoldlist = cmp.get("v.submilestone");
        
        var submilrecid = event.target.getAttribute('id')
        console.log('submilrecid2',submilrecid);
        var title = cmp.find('submileexpname').get("v.value");
        
        var leadtime = cmp.find('submileleadtime').get("v.value");
        var actstr = cmp.find('submileactualstrtdate').get("v.value");
        var actend = cmp.find('submileactualenddate').get("v.value");
        var expstr = cmp.find('submileexpectstrtdate').get("v.value");
        var expend = cmp.find('submileexpectenddate').get("v.value");
        var stats = cmp.find('submileselected-status').get("v.value");
        var compl = cmp.find('submilecompletion').get("v.value");
        var succ = cmp.find('submilesuccessor').get("v.value");
        var prede = cmp.find('submilepedecessor').get("v.value");
        
        
        
        var obj = cmp.get("v.editsubmilerecordObj");
        console.log('obj',obj);
        obj.Title__c = title;
        obj.Id = submilrecid;
        
        obj.Expected_End_Date__c = expend;
        obj.Expected_Start_Date__c = expstr;
        obj.Completion__c = compl;
        obj.Actual_End_Date__c = actend;
        obj.Actual_Start_Date__c = actstr;
        obj.Lead_Time__c = leadtime;
        obj.Predecessor__c = prede;
        obj.Status__c = stats;
        obj.Successor__c = succ;
        
        var statusval = cmp.get("v.editsubmilerecord");
       
        if(   (typeof expstr == 'undefined' && typeof expend == 'undefined' ) || (typeof expstr == 'string' && typeof expend == 'undefined' ) || (typeof expstr == 'undefined' && typeof expend == 'string' )  && (( (stats == 'Not Started' || typeof stats === 'undefined' ) || statusval[0].Status__c == 'Started' || statusval[0].Status__c == 'Completed' || statusval[0].Status__c == 'Not Started') || (actstr > actend || expstr > expend))){
                console.log('if part');
                var cmpForm1 = cmp.find('error1');
                var cmpForm2 = cmp.find('error2');
                $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
                $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
                $A.util.addClass(cmpForm1, 'slds-fade-in-open');
                $A.util.addClass(cmpForm2, 'slds-backdrop--open');
         }
        else{
            console.log('else part');
            helper.savesubmilerec(cmp,obj,mileoldlist);
            
            helper.getSubmiles(cmp, cmp.get("v.parentid"));
            
            var proid = cmp.get("v.productid");
            helper.getProjectrec(cmp, proid);
        }
        
    },
    savetask: function (cmp,event,helper){
        
        var cmpForm1 = cmp.find('taskform1');
        var cmpForm2 = cmp.find('taskform2');
        $A.util.removeClass(cmpForm1, 'slds-fade-in-open');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--open');
        $A.util.addClass(cmpForm1, 'slds-fade-in-close');
        $A.util.addClass(cmpForm2, 'slds-backdrop--close');
        
         helper.showSpinner(cmp);
        
        
        var tskoldlist = cmp.get("v.tasks");  
        var taskrecid = event.target.getAttribute('Id');
        
        
        //var submilrecid = event.target.getAttribute('id')
        var title = cmp.find('taskexpname').get("v.value");
        var leadtime = cmp.find('taskleadtime').get("v.value");
        var actstr = cmp.find('taskactualstrtdate').get("v.value");
        var actend = cmp.find('taskactualenddate').get("v.value");
 
        
        var expstr = cmp.find('taskexpectstrtdate').get("v.value");
        var expend = cmp.find('taskexpectenddate').get("v.value");
        var stats = cmp.find('taskselected-status').get("v.value");
        var compl = cmp.find('taskcompletion').get("v.value");
        var succ = cmp.find('tasksuccessor').get("v.value");
        var prede = cmp.find('taskpedecessor').get("v.value");
        
        
        
        console.log('title',title);
        var obj = cmp.get("v.tskeditrecordObj");
        console.log('obj',obj);
        obj.Title__c = title;
        obj.Id = taskrecid;
        
        obj.Expected_End_Date__c = expend;
        obj.Expected_Start_Date__c = expstr;
        obj.Completion__c = compl;
        obj.Actual_End_Date__c = actend;
        obj.Actual_Start_Date__c = actstr;
        obj.Lead_Time__c = leadtime;
        obj.Predecessor__c = prede;
        obj.Status__c = stats;
        obj.Successor__c = succ;
        
        var statusval = cmp.get("v.edittskrecord");
        console.log('statusval for task---------->',statusval);
        console.log('statusval[0].Status__c for task---------->',statusval[0].Status__c);
        
        if(   (typeof expstr == 'undefined' && typeof expend == 'undefined' ) || (typeof expstr == 'string' && typeof expend == 'undefined' ) || (typeof expstr == 'undefined' && typeof expend == 'string' )  && (( (stats == 'Not Started' || typeof stats === 'undefined' ) || statusval[0].Status__c == 'Started' || statusval[0].Status__c == 'Completed' || statusval[0].Status__c == 'Not Started') || (actstr > actend || expstr > expend))){
                console.log('if part');
                var cmpForm1 = cmp.find('error1');
                var cmpForm2 = cmp.find('error2');
                $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
                $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
                $A.util.addClass(cmpForm1, 'slds-fade-in-open');
                $A.util.addClass(cmpForm2, 'slds-backdrop--open');
         }
        else{
            console.log('else part');
            helper.saveTaskrec(cmp,obj,tskoldlist);
            helper.getTask(cmp, cmp.get("v.submileparentid"));
            var proid = cmp.get("v.productid");
            helper.getProjectrec(cmp, proid);
        }
       
    },
    editRecordsubmile :function(component, event, helper) {
        var prorecid = event.target.getAttribute('id');
        var action = component.get("c.editsubmilestone");
        action.setParams({ 
            "prorecid": prorecid
        });
        action.setCallback(this, function(a) {
            //console.log('-----------edit submilerecord-----------',a.getReturnValue());
            if(a.getReturnValue()==''){
                console.log('empty');
            }
            else{
                console.log(' Not empty');
                component.set("v.editsubmilerecord",a.getReturnValue());
                console.log('editsubmilerecord record',component.get("v.editsubmilerecord"));
                
                 var s = component.get("v.statusval");
                var newstatusval = [];
                for(var i = 0;i<s.length;i++){
                    console.log(s[i]);
                    if(s[i] == component.get("v.editsubmilerecord[0].Status__c")){
                    }
                    else{
                        newstatusval.push(s[i]);
                    }
                }
                component.set("v.submilestatusval",newstatusval)
                
                
                var cmpForm1 = component.find('submileform1');
        var cmpForm2 = component.find('submileform2');
        
        $A.util.removeClass(cmpForm1, 'slds-fade-in-close');
        $A.util.removeClass(cmpForm2, 'slds-backdrop--close');
        $A.util.addClass(cmpForm1, 'slds-fade-in-open');
        $A.util.addClass(cmpForm2, 'slds-backdrop--open');
       
            }
        });
        
          $A.enqueueAction(action);
    
    },
    loadstatus : function(component, event, helper) {
        helper.getStatus(component);
        //console.log('statusval - val ......',component.get("v.statusval"));
    },
    
    loadstatustsk : function(component, event, helper) {
        helper.getTaskstatus(component);
    } 
})