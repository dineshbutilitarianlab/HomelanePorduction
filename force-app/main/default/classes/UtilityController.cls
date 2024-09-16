public with sharing class UtilityController {

    public list < Project_Name__c > npdPros = new list < Project_Name__c > ();
    map < Project_Name__c, list < Milestone__c >> ProjStgMap = new map < Project_Name__c, list < Milestone__c >> ();

    //the following class will be used to house the field names
    //and desired operations
    public class fieldDefinition {
        public String operation {
            get;
            set;
        }
        public String childField {
            get;
            set;
        }
        public String parentField {
            get;
            set;
        }

        public fieldDefinition(String o, String c, String p) {
            operation = o;
            childField = c;
            parentField = p;

        }
    }




    Public Static void updateDateonLeadTimeChange(map < id, Milestone__c > newlist, map < id, Milestone__c > oldlist) {
        Set < id > projectid = new Set < id > ();
        Set < id > id = new Set < id > ();
        list < Milestone__c > lstallkitchencompleted = new list < Milestone__c > ();
        list < Milestone__c > objectlist = new list < Milestone__c > ();

        for (Milestone__c mmileobj: newlist.values()) {
            if (((mmileobj.Actual_End_Date__c != oldlist.get(mmileobj.id).Actual_End_Date__c) || (mmileobj.Actual_Start_Date__c != oldlist.get(mmileobj.id).Actual_Start_Date__c))) {
                projectid.add(mmileobj.Project__c);
                id.add(mmileobj.id);
                System.debug('projectidprojectid' + projectid);
                System.debug('idid*********' + id);

            }
        }

        objectlist = [select id, Actual_End_Date__c, Actual_Start_Date__c, Type__c, Lead_Time__c from Milestone__c where id IN: id AND Project__c IN: projectid];
        System.debug('objectlist' + objectlist);

        for (Milestone__c upobj: objectlist) {
            date dToday = upobj.Actual_Start_Date__c;
            date dTodayend = upobj.Actual_End_Date__c;
            Datetime startdate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
            Datetime enddate = datetime.newInstance(dTodayend.year(), dTodayend.month(), dTodayend.day());
            upobj.Lead_Time__c = daysBetweenExcludingWeekends(startdate, enddate) + 1;
            lstallkitchencompleted.add(upobj);
            system.debug('lstallkitchencompletedinside' + lstallkitchencompleted);
        }

        system.debug('lstallkitchencompletedlstallkitchencompleted' + lstallkitchencompleted);
        if (lstallkitchencompleted.size() > 0) {
            update lstallkitchencompleted;
        }

    }



    /*******************************   To update SubMilestone with the Task Date ************************************************
     **************************************************************************************************************************/

    Public Static void updateSubMilestoneDateFromTask(map < id, Task__c > newlist, map < id, Task__c > oldlist) {
            Set < id > projectid = new Set < id > ();
            Set < id > milestoneid = new Set < id > ();
            List < Task__c > lsttask = new List < Task__c > ();
            Map < id, Milestone__c > mapParentMilestone;
            Map < id, Milestone__c > mapmile = new Map < id, Milestone__c > ();
            Date actualStartDate;
            Date actualENDDate;

            for (Task__c taskobj: newlist.values()) {
                if ((taskobj.Actual_Start_Date__c != oldlist.get(taskobj.id).Actual_Start_Date__c) || (taskobj.Actual_End_Date__c != oldlist.get(taskobj.id).Actual_End_Date__c) || (taskobj.Lead_Time__c != oldlist.get(taskobj.id).Lead_Time__c)) {
                    if (taskobj.Milestone__c != NULL)
                        milestoneid.add(taskobj.Milestone__c);
                    if (taskobj.Project__c != NULL)
                        projectid.add(taskobj.Project__c);
                }
            }

            System.debug('**************milestoneid*task******* ' + milestoneid);
            System.debug('**************projectid**task***** ' + projectid);

            // list that holds the Parent Milestone of the task
            if (milestoneid.size() > 0 && projectid.size() > 0) {
                mapParentMilestone = new Map < id, Milestone__c > ([select id, Actual_Start_Date__c, Actual_End_Date__c from Milestone__c where id IN: milestoneid and Project__c IN: projectid]);
            }

            if (milestoneid.size() > 0 && projectid.size() > 0) {
                actualStartDate = [select id, Actual_Start_Date__c, Actual_End_Date__c From Task__c where Milestone__c IN: milestoneid and Project__c IN: projectid ORDER BY Actual_Start_Date__c ASC LIMIT 1].Actual_Start_Date__c;
                actualENDDate = [select id, Actual_Start_Date__c, Actual_End_Date__c From Task__c where Milestone__c IN: milestoneid and Project__c IN: projectid ORDER BY Actual_End_Date__c DESC LIMIT 1].Actual_End_Date__c;
            }

            for (Task__c taskinsert: newlist.values()) {
                if (mapParentMilestone != NULL && !mapParentMilestone.isEmpty()) {
                    Milestone__c mile = mapParentMilestone.get(taskinsert.Milestone__c);
                    mile.Actual_Start_Date__c = actualStartDate;
                    mile.Actual_End_Date__c = actualENDDate;
                    mapmile.put(mile.id, mile);
                }
            }
            if (!mapmile.isempty()) {
                update mapmile.values();
            }
        }
        /****************************************************************************************************************************
         *****************************************************************************************************************************/




    /*******************************   To update Milestone with the SubMilestone Date ************************************************
     **************************************************************************************************************************/

    Public Static void updateMilestoneDateFromSubMilestone(map < id, Milestone__c > newlist, map < id, Milestone__c > oldlist) {

            Set < id > projectid = new Set < id > ();
            Set < id > milestoneid = new Set < id > ();
            List < Task__c > lsttask = new List < Task__c > ();
            Map < id, Milestone__c > mapParentMilestone;
            Map < id, Milestone__c > mapmile = new Map < id, Milestone__c > ();
            Date actualStartDate;
            Date actualENDDate;
            String Type;

            for (Milestone__c submileobj: newlist.values()) {
                if (((submileobj.Actual_Start_Date__c != oldlist.get(submileobj.id).Actual_Start_Date__c) || (submileobj.Actual_End_Date__c != oldlist.get(submileobj.id).Actual_End_Date__c) || (submileobj.Lead_Time__c != oldlist.get(submileobj.id).Lead_Time__c)) && submileobj.Type__c == 'Sub-Milestone') {
                    System.debug('*****hello********milestoneid******** ' + milestoneid);
                    if (submileobj.Milestone__c != NULL)
                        milestoneid.add(submileobj.Milestone__c);
                    System.debug('******hello2*******milestoneid******** ' + milestoneid);
                    if (submileobj.Project__c != NULL)
                        projectid.add(submileobj.Project__c);
                    Type = submileobj.Type__c;
                }

            }

            System.debug('**************milestoneid******** ' + milestoneid);
            System.debug('**************projectid******** ' + projectid);
            System.debug('**************Type******** ' + Type);

            // list that holds the Parent Milestone of the task
            if (milestoneid.size() > 0 && projectid.size() > 0) {
                mapParentMilestone = new Map < id, Milestone__c > ([select id, Actual_Start_Date__c, Actual_End_Date__c from Milestone__c where id IN: milestoneid and Project__c IN: projectid]);
            }


            System.debug('**************mapParentMilestone******** ' + mapParentMilestone);

            if (milestoneid.size() > 0 && projectid.size() > 0) {
                actualStartDate = [select id, Actual_Start_Date__c, Actual_End_Date__c From Milestone__c where Milestone__c IN: milestoneid and Project__c IN: projectid ORDER BY Actual_Start_Date__c ASC LIMIT 1].Actual_Start_Date__c;
                actualENDDate = [select id, Actual_Start_Date__c, Actual_End_Date__c From Milestone__c where Milestone__c IN: milestoneid and Project__c IN: projectid ORDER BY Actual_End_Date__c DESC LIMIT 1].Actual_End_Date__c;
            }

            if (Type == 'Sub-Milestone') {
                for (Milestone__c milestoneinsert: newlist.values()) {
                    if (!mapParentMilestone.isEmpty()) {
                        Milestone__c mile = mapParentMilestone.get(milestoneinsert.Milestone__c);
                        mile.Actual_Start_Date__c = actualStartDate;
                        mile.Actual_End_Date__c = actualENDDate;
                        mapmile.put(mile.id, mile);
                    }
                }
            }
            if (!mapmile.isempty()) {
                update mapmile.values();
            }
        }
        /****************************************************************************************************************************
         *****************************************************************************************************************************/


    /*******************************Calculate Weekdays between Two days********************************************************************************************/

    public static Integer daysBetweenExcludingWeekends(Datetime startDate, Datetime endDate) {
        Integer i = 0;

        while (startDate < endDate) {
            if (startDate.format('E') != 'Sat' && startDate.format('E') != 'Sun') {
                i++;
            }
            startDate = startDate.addDays(1);
        }

        return i;
    }

    /*************************************************************************************************************************************************************/
}