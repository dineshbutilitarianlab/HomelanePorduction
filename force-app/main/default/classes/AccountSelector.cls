public class AccountSelector {
    Public Static Account getAccountById(String accountId){
        List<Account> listOfAccountsQureied = new List<Account>();
        Account returnAccountRecord;
        String queryString = UtilityClass.getQueryString('Account');
        queryString += ' From Account where id=:accountId';
        listOfAccountsQureied = Database.query(queryString);
        if(!listOfAccountsQureied.isEmpty()){
            returnAccountRecord = listOfAccountsQureied[0];
        }
        return returnAccountRecord;
    }
    Public Static List<Account> getListOfAccountsByEmailOrPhone(String email,String PhoneNumber){
        List<Account> listOfAccountsQureied = new List<Account>();
        if(!String.isBlank(email) && !String.isBlank(PhoneNumber)){
            String queryString = UtilityClass.getQueryString('Account');
            queryString += ' From Account where PersonEmail =: email or Phone =: PhoneNumber';
            listOfAccountsQureied = Database.query(queryString);
        }
        else{
            System.debug('Either email or phone is blank. email: '+email+ ' . PhoneNumber: '+PhoneNumber);
        }
        return listOfAccountsQureied;
    }
}