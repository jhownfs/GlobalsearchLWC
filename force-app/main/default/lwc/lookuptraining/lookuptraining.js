import { LightningElement, wire, track } from 'lwc';
import buscaRegistros from '@salesforce/apex/LookupTrainingController.buscaRegistros';
import comboBoxobjetos from '@salesforce/apex/LookupTrainingController.listaObjetos';

export default class lookuptraining extends LightningElement {

  termoBusca;
  objeto;
  @track listaObjetoSalesforce;
  @track valorObjetoSelecionado;

  connectedCallback() {
    this.getObjetos();
  }

  getObjetos(){
    comboBoxobjetos({})
    .then((result) => {
     
      let objetos = [];
      if(result){
        result.forEach( obj => {
          objetos.push({
            label: obj,
            value: obj,
          });
        });
      }
      this.listaObjetoSalesforce = objetos;
  }).catch(( error ) => {
    console.log('error', error);
  })
}

  handleChange(event) {
    this.valorObjetoSelecionado = event.detail.value;
  }

  @wire(buscaRegistros, { termo: '$termoBusca' , objeto: '$valorObjetoSelecionado'})
  listaRegistros;

  handleontype(event){
     
    this.termoBusca = event.target.value;
  }
  
}