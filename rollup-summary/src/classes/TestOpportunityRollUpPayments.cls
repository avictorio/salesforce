@isTest
private class TestOpportunityRollUpPayments {
    
    static testMethod void myUnitTest() {
        
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@test123456789.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'testuser@test123456789.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        system.runAs(u){
        
            Opportunity o = new Opportunity();
            o.Name = 'Test Opportunity';
            o.StageName = 'Closed Won';
            o.CloseDate = system.today();
            insert o;
            
            system.assertEquals(o.Total_Payments__c, null);
            
            //Test payments on insert
            Payment__c p1 = new Payment__c();
            p1.Opportunity__c = o.Id;
            p1.Amount__c = 100;
            insert p1;
            
            Opportunity ou1 = [select Total_Payments__c from Opportunity where Id = :o.Id];
            system.assertEquals(ou1.Total_Payments__c,p1.Amount__c);
            
            //Test payments on update
            Payment__c p1u = [select Amount__c from Payment__c where Id = :p1.Id];
            p1u.Amount__c = 200;
            update p1u;
            
            Opportunity ou2 = [select Total_Payments__c from Opportunity where Id = :o.Id];
            system.assertEquals(ou2.Total_Payments__c,p1u.Amount__c);
            
            //Test payments on second insert
            Payment__c p2 = new Payment__c();
            p2.Opportunity__c = o.Id;
            p2.Amount__c = 800;
            insert p2;
            
            AggregateResult ag1 = [select sum(Amount__c) from Payment__c where Opportunity__c = :o.Id];
            
            Opportunity ou3 = [select Total_Payments__c from Opportunity where Id = :o.Id];
            system.assertEquals(ou3.Total_Payments__c,ag1.get('expr0'));
            
            //Test payment on delete
            delete p2;
            
            AggregateResult ag2 = [select sum(Amount__c) from Payment__c where Opportunity__c = :o.Id];
            
            Opportunity ou4 = [select Total_Payments__c from Opportunity where Id = :o.Id];
            system.assertEquals(ou4.Total_Payments__c,ag2.get('expr0'));
            
        }
        
    }
    
}