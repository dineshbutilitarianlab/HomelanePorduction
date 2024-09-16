@istest
public class CreateCustomTask_Test {
    public testMethod static void test() {
        Lead l = new Lead();
        l.FirstName = 'Hamsa';
        l.LastName = 'Raj';
        l.Email = 'HamsaRaj@gmail.com';
        l.Phone = '9000000009';
        l.City = 'Bengaluru';
        l.LeadSource = 'Google Ad';
        l.Status = 'Fresh Lead';
        l.Sub_Status__c = 'New';
        insert l;
        
        List<Task> insertTask = new List<Task>();        
        Task t = new Task();
        t.Subject = 'UCID';
        t.WhoId = l.Id;        
        insert t;
        
        Task t2 = new Task();
        t2.id = t.id;
        t2.WhoId = l.Id;
        t2.Subject = 'UCID';
        t2.CallDisposition = 'Unable_to_Connect';
        insertTask.add(t2);
        update insertTask;
        
        Map<Id, Task> updateTask = new Map<Id, Task>();
        Task t1 = new Task();
        t1.id = t.id;
        t1.WhoId = l.Id;
        t1.Subject = 'UCID';
        t1.CallDisposition = null;
        updateTask.put(t1.Id,t1);
        update updateTask.values();
        
        CreateCustomTask.insertTaskCustom(insertTask, updateTask);
        
        insert (new Task_Custom__c(Name = 'UCID', Lead__c = l.Id));
    }
}