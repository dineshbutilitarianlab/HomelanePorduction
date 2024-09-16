global class Sections implements Comparable {
        @AuraEnabled        
        public List<SC_MISalesProcess.Items> item {get;set;}
        @AuraEnabled        
        public List<Sections> section {get;set;}
        @AuraEnabled
        public String sectionName {get;set;}
        @AuraEnabled
        public Integer orderNumber {get;set;}
        public Sections(String sectionName,Integer ordNum){
            this.sectionName = sectionName;
            item = new List<SC_MISalesProcess.Items>();
            section = new List<Sections>();
            this.orderNumber = ordNum;
        }
        
        // Implement the compareTo() method
        global Integer compareTo(Object compareTo) {
            Sections compareToSec = (Sections)compareTo;
            system.debug('in sorting :::' +compareToSec);
            if (orderNumber == compareToSec.orderNumber) return 0;
            if (orderNumber > compareToSec.orderNumber) return 1;
            return -1;        
        }
    }