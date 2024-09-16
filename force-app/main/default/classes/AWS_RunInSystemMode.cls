public with sharing class AWS_RunInSystemMode {
    public static void insertAsAdmininstrator(List<sObject> lst){
		try{
			insert lst;
		}catch(Exception e){
			system.debug('Error on insert  AWS_RunInSystemMode : '+e); 
		}
		system.debug('lst after insert AWS_RunInSystemMode : '+lst); 
	}
}