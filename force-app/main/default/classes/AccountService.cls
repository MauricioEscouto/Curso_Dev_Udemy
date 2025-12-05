public with sharing class AccountService {

    @AuraEnabled(cacheable=true)
    public static List<Projeto__c> obterProjetos(Id accountId){
        try {
            return [
                SELECT Id, Name, Conta__c, DataInicio__c, Status__c, ValorProjeto__c
                FROM Projeto__c
                WHERE Conta__c = :accountId
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao obter projetos: ' + e.getMessage());
        }
    }
}