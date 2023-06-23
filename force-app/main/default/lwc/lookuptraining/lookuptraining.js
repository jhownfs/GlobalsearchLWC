import { LightningElement, wire, track } from "lwc";
import searchRecords from "@salesforce/apex/LookupTrainingController.searchRecords";
import comboBoxObjects from "@salesforce/apex/LookupTrainingController.listObjectsSalesforce";
import { NavigationMixin } from "lightning/navigation";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class lookuptraining extends NavigationMixin(LightningElement) {
  searchTerm;
  object;
  @track loaded = false;
  @track listObjectSalesforce;
  @track valueTypedToSearch;
  @track objectInfo;
  objectApiName;

  connectedCallback() {
    this.loaded = true;
    this.getObjects();
  }

  getObjects() {
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
    this.objectApiName = event.detail.value
  }

  @wire(getObjectInfo, { objectApiName: '$objectApiName' })
  objectInfo;


  @wire(searchRecords, {
    keyTerm: "$searchTerm",
    objectSearch: "$valueTypedToSearch"
  })
  listRecordsFound;

  handleontype(event) {
    this.searchTerm = event.target.value;
  }

  navigatetorecord(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.target.dataset.id,
        objectApiName: this.valueTypedToSearch,
        actionName: "view"
      }
    });
  }
}
