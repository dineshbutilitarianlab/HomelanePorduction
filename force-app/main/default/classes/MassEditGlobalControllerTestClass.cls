@isTest
public class MassEditGlobalControllerTestClass {
    
    @isTest
    public static void testmet()
    {
        List<Opportunity> opplst = new List<opportunity>();
        ApexPages.StandardsetController stdLead = new ApexPages.StandardSetController(opplst);
        MassEditGlobalController mgc = new MassEditGlobalController(stdLead);
        mgc.OppName = 'anan';
        mgc.OppNumber = '99';
        mgc.next();
        mgc.FirstPage();
        mgc.LastPage();
        mgc.previous();
        mgc.getprev();
        mgc.getnxt();  
        mgc.saveRec();
    }
    
}