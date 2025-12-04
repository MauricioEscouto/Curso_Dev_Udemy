import { api, LightningElement, wire } from 'lwc';
import obterProjetosService from '@salesforce/apex/AccountService.obterProjetos';

export default class ListarProjetos extends LightningElement {
    @api recordId;

    projetos_obtidos;
    error;

    @wire(obterProjetosService, { accountId: '$recordId' })
    obterProjetos({error, data}) {
    if (data) {
      this.projetos_obtidos = data.map((element) => {
        return {
          projeto: {
            Id: element.Id,
            Name: element.Name,
            Data_de_Inicio__c: element.DataInicio__c,
            Status__c: element.Status__c
          }
        };
      });

    } else if (error) {
      this.error = error;
    }
  }
}