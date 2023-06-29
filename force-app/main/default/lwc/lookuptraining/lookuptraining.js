import { LightningElement, wire, track } from "lwc";
import searchRecords from "@salesforce/apex/LookupTrainingController.searchRecords";
import comboBoxObjects from "@salesforce/apex/LookupTrainingController.listObjectsSalesforce";
import { NavigationMixin } from "lightning/navigation";
import { getObjectInfo } from "lightning/uiObjectInfoApi";

export default class lookuptraining extends NavigationMixin(LightningElement) {
  searchTerm = null;
  object = null;
  @track loaded = false;
  @track listObjectSalesforce;
  @track valueTypedToSearch;
  @track objectInfo;
  @track iconURL =
    "https://coisadavidacast-dev-ed.my.salesforce.com/img/icon/t4v35/standard/address_120.png";
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
    this.objectApiName = event.detail.value;
  }

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

  @wire(getObjectInfo, { objectApiName: "$valueTypedToSearch" })
  handleResult({ error, data }) {
    if (data) {
      this.iconURL = data.themeInfo.iconUrl;
      this.template
        .querySelector("lightning-card")
        .style.setProperty("--iconColor", "#" + data.themeInfo.color);
    }
    if (error) {
      // handle error
    }
  }
}
