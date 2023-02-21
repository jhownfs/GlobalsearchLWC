import { LightningElement, wire, track } from "lwc";
import searchRecords from "@salesforce/apex/LookupTrainingController.searchRecords";
import comboBoxObjects from "@salesforce/apex/LookupTrainingController.listObjectsSalesforce";

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

  @wire(searchRecords, {
    keyTerm: "$searchTerm",
    objectSearch: "$valueTypedToSearch"
  })
  listRecordsFound;

  handleontype(event) {
    this.searchTerm = event.target.value;
  }
}
