import { LightningElement, wire, track } from "lwc";
import buscaRegistros from "@salesforce/apex/LookupTrainingController.buscaRegistros";
import comboBoxObjects from "@salesforce/apex/LookupTrainingController.listaObjetos";

export default class lookuptraining extends LightningElement {
  searchTerm;
  object;
  @track loaded = false;
  @track listObjectSalesforce;
  @track valueTypedToSearch;

  connectedCallback() {
    this.loaded = true;
    this.getObjetos();
  }

  getObjetos() {
    comboBoxObjects({})
      .then((result) => {
        let objectsArray = [];
        if (result) {
          result.forEach((obj) => {
            objectsArray.push({
              label: obj,
              value: obj
            });
          });
        }
        this.listObjectSalesforce = objectsArray;
        this.loaded = false;
      })
      .catch((error) => {
        console.log("error", error);
      });
  }

  changeobject(event) {
    this.valueTypedToSearch = event.detail.value;
    this.listRecordsFound = [];
  }

  @wire(buscaRegistros, { termo: "$searchTerm", objeto: "$valueTypedToSearch" })
  listRecordsFound;

  handleontype(event) {
    this.searchTerm = event.target.value;
  }
}
