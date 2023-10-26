public with sharing class BillAPI {
    
    public static void getBills() {
        //start by creating an HttpRequest object and set the endpoint and method.
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://my-json-server.typicode.com/grizzleevelyn/231017_dev_clicked/bills');
        req.setMethod('GET');   
        //set up an Http object and an HTTPResponse Object and use the .getBody() method here.
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        //A wrapper clas allows us to create an instance of a class
    public class BillWrapper {
        public String billId;
        public String accountName;
        public String balance;
    }
        //Use the following to deserialize the JSON response into a wrapper class:
        List<BillWrapper> bwList = (List<BillWrapper>)JSON.deserialize(res.getBody(), List<BillWrapper>.class);      
        // Define a list to hold the bills
        // Query for active accounts with Active__c = 'Yes'
        List<Bill__c> billsToInsert = new List<Bill__c>();
        List<Account> activeAccounts = [SELECT Id, Name FROM Account WHERE Active__c = 'Yes'];
        // Create a map to store active accounts (Name as the key and Id as the value)
        Map<String, Id> activeAccountMap = new Map<String, Id>();
        //iterate over the list of active accounts,use .put() method of Map class to insert the account name and Id as the key value pair.
        for (Account acc : activeAccounts) {
        activeAccountMap.put(acc.Name, acc.Id);
        }     
        //iterate over the list of BillWrappers, bwList, and create a new bill in each iteration.
		 for(BillWrapper eachBill:bwList){
                 Bill__c billToInsert = new Bill__c();
                 billToInsert.Balance__c= Decimal.valueOf(eachBill.balance.replace('$', ''));
             	 billToInsert.Bill_Id__c=eachBill.billId;
             	 billToInsert.Account__c= activeAccountMap.get(eachBill.accountName);
                 billsToInsert.add(billToInsert);  
         //finally, insert the new bills list  
        }
        if (!billsToInsert.isEmpty()) {
		 insert billsToInsert;
        }
    }
}