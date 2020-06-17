public with sharing class AP_pdf {
    @AuraEnabled(Cacheable = true)
    
    public static List<Employee__c> getRecords(String recordId) {
        String param = '%' + recordId + '%';
        List<Employee__c> values = [SELECT Name,Id,Email__c,Grade__c
        FROM Employee__c WHERE Id =: param];
        return values;
        
    }
    @auraEnabled
    public static Attachment pdfgenerator(string accId) {
       
        system.debug('currentRecordId'+accId);
        
        Id currentRecordId  = Id.valueof(accId);
    	List<Employee__c> emp=new List<Employee__c>();
        if(currentRecordId!=null){
            for(Employee__c e:[SELECT FirstName__c,Id,Email__c,Gender__c,Grade__c,Nationality__c  FROM Employee__c where id =: currentRecordId])
          	{
            emp.add(e);
        	}
        }            
        String objType = String.valueOf(emp);
        system.debug(objType);
        
        Blob myBlob = Blob.valueof(objType);
      
        system.debug('myBlob'+myBlob);
        list<Attachment> attachList = new List<Attachment>();
        Attachment attach = new Attachment();
        attach.Name ='text'+currentRecordId+'.pdf';  
       
        attach.Body = blob.toPdf(objType);
        
        attach.ParentID =  currentRecordId ;
        Attachment checkDuplicate=new Attachment();
       
        system.debug('attach'+attach);
        attachList.add(attach);
        database.upsert(attachList);
        system.debug('attachList'+attachList);
        return attach;
        
}
}