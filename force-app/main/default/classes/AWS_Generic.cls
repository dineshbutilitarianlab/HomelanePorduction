public with sharing class AWS_Generic {

    //All interfaces definition goes here
    public interface UIConfigurable{
        //void updateConfig(AWS_GenericModels.ComponentConfig c);
    }
        
    public interface DataSource{
        //AWS_GenericModels.ModelData getData(AWS_GenericModels.DataSourceCriteria cr);
        String doUpdate(List<AWS_Generic.Modelable> Modelables);
        String doSave(List<AWS_Generic.Modelable> Modelables);
        String doDelete(List<AWS_Generic.Modelable> Modelables);
        List <AWS_GenericModels.ModelMapping> getModelableFieldMapping();
        System.type getParamType();
        //String getModelableClassName();
    }
    
    public interface Modelable{
        sObject toSObject();
        void setValue(sObject obj);
    }
    
    public interface UserPicModelable extends Modelable{
        Id getUserId();
        void setPhoto(String usrImg);
    }
    
    
    //All generic Class
    public class FTException extends Exception {}
    
}