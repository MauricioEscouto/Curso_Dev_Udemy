@IsTest
private class AccountServiceTest {

    @testSetup
    static void makeData() {
        Account acc = new Account(
            Name = 'Conta de Teste'
        );
        insert acc;

        List<Projeto__c> projetos = new List<Projeto__c>{
            new Projeto__c(
                Name = 'Projeto 1',
                Conta__c = acc.Id,
                DataInicio__c = Date.today(),
                Status__c = 'Em andamento',
                ValorProjeto__c = 1000
            ),
            new Projeto__c(
                Name = 'Projeto 2',
                Conta__c = acc.Id,
                DataInicio__c = Date.today().addDays(-5),
                Status__c = 'Concluído',
                ValorProjeto__c = 1500
            )
        };
        insert projetos;
    }

    // Helper para recuperar o Account criado no setup
    private static Account getContaData() {
        return [SELECT Id FROM Account LIMIT 1];
    }

    // Cenário 1 — Conta com projetos
    @IsTest
    static void testeObterProjetos_ComProjetos() {
        Account acc = getContaData();

        Test.startTest();
        List<Projeto__c> resultado = AccountService.obterProjetos(acc.Id);
        Test.stopTest();

        Assert.isNotNull(resultado);
        Assert.areEqual(2, resultado.size(), 'Deve retornar 2 projetos.');
    }

    // Cenário 2 — Conta sem projetos (cria nova conta sem projetos)
    @IsTest
    static void testeObterProjetos_SemProjetos() {
        Account accSemProjetos = new Account(Name = 'Conta Sem Projetos');
        insert accSemProjetos;

        Test.startTest();
        List<Projeto__c> resultado = AccountService.obterProjetos(accSemProjetos.Id);
        Test.stopTest();

        Assert.isTrue(resultado.isEmpty(), 'Lista deve estar vazia.');
    }

    // Cenário 3 — ID nulo deve lançar AuraHandledException
    @IsTest
    static void testeObterProjetos_IdNulo() {
        Test.startTest();
        List<Projeto__c> resultado = AccountService.obterProjetos(null);
        Test.stopTest();

        Assert.isTrue(resultado.isEmpty(), 'Quando o Id é nulo deve retornar lista vazia.');
    }
}