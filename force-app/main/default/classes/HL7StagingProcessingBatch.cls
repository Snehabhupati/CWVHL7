public class HL7StagingProcessingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Name, IsProcessed__c,HL7_Message__c, AccountID__c FROM HL7_Staging__c WHERE IsProcessed__c = false';
        System.debug('query '+query);
        return Database.getQueryLocator(query);
    }   
    
      
    public class accessTokenWrapper{
        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public string signature;
    }
    
    public static accessTokenWrapper generateAccessToken(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://cgpowerindustrialpvtltd3-dev-ed.my.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setBody('grant_type=password&client_id='
                    + '3MVG9pRzvMkjMb6mUxfmT.RERI80.9hyb9CdGabtLvNLt5JBb2xu5wQGY09NmLbjJiB21KuO546Dq8ewsAmkH' +
                    '&client_secret=' + '1B09348689477F2962DF2DE0BCDA87EEC6B4B21B7EBC648914155B879CB201B6' +
                    '&username=' + 'snehabhupati1002@gmail.com' +
                    '&password=' + 'Sneha@2001ASeXCLMbTXRRLQxB6TUU2td5');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('res.Body'+res.getBody());
        
        if(res.getStatusCode() == 200){
            accessTokenWrapper accessToken =  (accessTokenWrapper) System.JSON.deserialize(res.getBody(), accessTokenWrapper.class);
            System.debug('accessToken ' +accessToken);
            return(accessTokenWrapper) System.JSON.deserialize(res.getBody(), accessTokenWrapper.class);
        }
        else{
            return null;
        }
        
    }
  
    public void execute(Database.BatchableContext context, List<HL7_Staging__c> scope) {
        System.debug('in ex');
        for (HL7_Staging__c record : scope) {
            record.IsProcessed__c = true;
            record.Processed_Date__c = System.now();
        }
        
        HL7StagingProcessingBatch.generateAccessToken();
        
        accessTokenWrapper objAccecc = generateAccessToken();
        
        system.debug('objAccecc-'+objAccecc);
        system.debug('objAccecc.access_token-'+objAccecc.access_token);
        if(objAccecc != null && objAccecc.access_token != null){
            String requestBody = JSON.serialize(scope);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://cgpowerindustrialpvtltd3-dev-ed.my.salesforce.com/services/apexrest/Hl7/insertHL7Messages');
            req.setMethod('POST');
            req.setBody(requestBody);
            req.setHeader('Authorization', 'Bearer ' + objAccecc.access_token);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug(res.getStatusCode());
        }  
        update scope;
        
    }
    public void finish(Database.BatchableContext context) {
        
    } 
    
}