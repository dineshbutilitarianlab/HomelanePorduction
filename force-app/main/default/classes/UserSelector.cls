public class UserSelector {
    Public Static User getUserByEmail(String userEmail){
        System.debug('userEmail: '+userEmail);
        List<User> listOfUsersQureied = new List<User>();
        User returnUserRecord;
        listOfUsersQureied = [Select id,Email,Name,Profile.Name
                                 from User 
                                 where Email =: userEmail
                                ];
        if(!listOfUsersQureied.isEmpty()){
            returnUserRecord = listOfUsersQureied[0];
        }
        System.debug('returnUserRecord: '+returnUserRecord);
        return returnUserRecord;
    }
}