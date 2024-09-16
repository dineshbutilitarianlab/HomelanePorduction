public class EmailReplyfromCustomerController {

    Public String Reply {
        get;
        set;
    }
    Public String D3 {
        get;
        set;
    }
    Public String D3_Initial {
        get;
        set;
    }
    Public String D2 {
        get;
        set;
    }
    Public String Id {
        get;
        set;
    }

    public PageReference updateoppStatus() {
        Reply = ApexPages.currentPage().getParameters().get('reply');
        D3 = ApexPages.currentPage().getParameters().get('D3');
        D3_Initial = ApexPages.currentPage().getParameters().get('D3_Initial');
        D2 = ApexPages.currentPage().getParameters().get('D2');
        Id = ApexPages.currentPage().getParameters().get('id');


        if (null == D3 && null == D2 && null == D3_Initial) {

            Opportunity oppty1 = getOpportunityRecord(Id);
            sYSTEM.DEBUG('oppty**********' + oppty1.ID);
            for (Opportunity oppty: [select id, StageName from Opportunity where id =: oppty1.ID]) {

                if (Reply == 'YES' && oppty.StageName == 'Initial Quote Sent') {

                    oppty.StageName = 'Initial Quote Approved';
                } else if (Reply == 'NO' && oppty.StageName == 'Initial Quote Sent') {

                    oppty.StageName = 'Initial Quote Rejected';

                }

                try {
                    update oppty;
                } catch (DMLException DMLEx) {
                    system.debug('*** DMLEx is ' + DMLEx);
                }
            }

        } else if (null != D3 && null == D2 && null == D3_Initial) {
            Opportunity oppty1 = getOpportunityRecord(Id);


            for (Opportunity oppty: [select id, StageName, Sub_Status__c from Opportunity where id =: oppty1.ID]) {
                if (null != oppty && D3 == 'YES' && oppty.Sub_Status__c == 'Final Drawings, Quote & Works Contract Sent') {
                    oppty.Sub_Status__c = 'Final Drawings, Quote & Works Contract Approved';
                } else if (null != oppty && D3 == 'NO' && oppty.Sub_Status__c == 'Final Drawings, Quote & Works Contract Sent') {
                    oppty.Sub_Status__c = 'Final Drawings, Quote & Works Contract Rejected';
                }

                try {
                    update oppty;
                } catch (DMLException DMLEx) {
                    system.debug('*** DMLEx is ' + DMLEx);
                }

            }
        } else if (null == D3 && null != D2 && null == D3_Initial) {
            Opportunity oppty1 = getOpportunityRecord(Id);
            for (Opportunity oppty: [select id, StageName, Sub_Status__c from Opportunity where id =: oppty1.ID]) {

                if (null != oppty && D2 == 'YES' && oppty.Sub_Status__c == 'Final 3D Design & Quote Sent') {
                    oppty.Sub_Status__c = '3D Design & Quote Approved';
                } else if (null != oppty && D2 == 'NO' && oppty.Sub_Status__c == 'Final 3D Design & Quote Sent') {
                    oppty.Sub_Status__c = '3D Design & Quote Rejected';
                }

                try {
                    update oppty;
                } catch (DMLException DMLEx) {
                    system.debug('*** DMLEx is ' + DMLEx);
                }
            }
        } else if (null != D3_Initial) {
            Opportunity oppty1 = getOpportunityRecord(Id);
            for (Opportunity oppty: [select id, StageName, Sub_Status__c from Opportunity where id =: oppty1.ID]) {
                if (null != oppty && D3_Initial == 'YES' && oppty.Sub_Status__c == 'D3: Production Drawings Sent') {
                    oppty.Sub_Status__c = 'Drawings & Quote Approved';
                } else if (null != oppty && D3_Initial == 'NO' && oppty.Sub_Status__c == 'D3: Production Drawings Sent') {
                    oppty.Sub_Status__c = 'Drawings & Quote Rejected';
                }

                try {
                    update oppty;
                } catch (DMLException DMLEx) {
                    system.debug('*** DMLEx is ' + DMLEx);
                }
            }
        }
 
        PageReference pageRef = new PageReference('http://www.homelane.com/thankyou1?undefined&redirecturl=/solutions');
        pageRef.setRedirect(true);
        return pageRef;

    }

    public static Opportunity getOpportunityRecord(Id opptyId) {
        Opportunity opportunityrec = new Opportunity();
        opportunityrec = [select id, name, Sub_Status__c from Opportunity where id =: opptyId];

        return opportunityrec;
    }

}