global class PreviousStageSections implements Comparable{
        @AuraEnabled
        public String section {get;set;}
        @AuraEnabled
        public String stageName{get;set;}
        @AuraEnabled
        public Boolean isShow {get;set;}
        @AuraEnabled
        public Integer orderNum {get;set;}
        @AuraEnabled
        public Integer indexNum {get;set;}
        public PreviousStageSections(String section, String stageName,Integer orderNum, Integer indexNum ){
            // this.section   = stageName.toUpperCase()+': '+section;
            this.section   = stageName+': '+section;
            this.isShow    = false;
            this.stageName = stageName ;
            this.orderNum  = orderNum;
            this.indexNum  = indexNum;
        }
        global Integer compareTo(Object compareTo) {
            PreviousStageSections preStage = (PreviousStageSections)compareTo;
            system.debug('in sorting :::' +preStage);
            if (orderNum == preStage.orderNum) return 0;
            if (orderNum > preStage.orderNum) return 1;
            return -1;        
        }
    }