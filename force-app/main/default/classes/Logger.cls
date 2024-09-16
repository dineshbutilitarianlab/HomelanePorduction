/**
 * @File Name          : Logger.cls
 * @Description        : 
 * @Author             : Bharatesh Shetty
 * @Group              : 
 * @Last Modified By   : Bharatesh Shetty
 * @Last Modified On   : 9/19/2019, 11:36:07 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/19/2019, 11:07:03 AM   Bharatesh Shetty     Initial Version
**/
public class Logger {

  public static void log(String Type, String className,String methodName, String message,String stackTrace,String recordId) { 
    insert (new Log__c(Type__c=Type,
                       class__c=className,
                       Method__c = methodName,
                       message__c=message,
                       RecordId__c = recordId,
                       StackTrace__c = stackTrace,
                       Name = className));
                    //   System.debug('Log--->  '+Log__c);
  }
  
  public static void logWithPhone(String Type, String className,String methodName, String message,String stackTrace,String recordId, String ph) { 
    insert (new Log__c(Type__c=Type,
                       class__c=className,
                       Method__c = methodName,
                       message__c=message,
                       RecordId__c = recordId,
                       StackTrace__c = stackTrace,
                       Lead_Opp_Phone__c = ph,
                       Name = className));
                     //  System.debug('Log--->  '+Log__c);
  }
  public static Log__c returnLog(String Type, String className,String methodName, String message,String stackTrace,String recordId) { 
    return (new Log__c(Type__c=Type,
                       class__c=className,
                       Method__c = methodName,
                       message__c=message,
                       RecordId__c = recordId,
                       StackTrace__c = stackTrace,
                       Name = className));
                    //   System.debug('Log--->  '+Log__c);
  }
 
}