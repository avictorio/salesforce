trigger OpportunityRollUpPayments on Payment__c (after delete, after insert, 
after update, after undelete) {
	
    if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
		
		list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = 
		new list<RollUpSummaryUtility.fieldDefinition> {
			new RollUpSummaryUtility.fieldDefinition('SUM', 'Amount__c', 
			'Total_Payments__c'), 
			new RollUpSummaryUtility.fieldDefinition('MAX', 'Amount_2__c', 
			'Total_Payments_2__c')
		};
        
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.new, 
        'Payment__c', 'Opportunity__c', 'Opportunity', '');
        
    }
    
    if(trigger.isDelete){
        
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = 
        new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'Amount__c', 
            'Total_Payments__c'), 
            new RollUpSummaryUtility.fieldDefinition('MAX', 'Amount_2__c', 
            'Total_Payments_2__c')
        };
        
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.old, 
        'Payment__c', 'Opportunity__c', 'Opportunity', '');
        
    }
	
}