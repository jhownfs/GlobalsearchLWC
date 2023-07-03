import { LightningElement, wire, track } from "lwc";
import searchRecords from "@salesforce/apex/LookupTrainingController.searchRecords";
import comboBoxObjects from "@salesforce/apex/LookupTrainingController.listObjectsSalesforce";
import { NavigationMixin } from "lightning/navigation";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class lookuptraining extends NavigationMixin(LightningElement) {
  searchTerm = null;
  object = null;
  @track loaded = false;
  @track listObjectSalesforce;
  @track valueTypedToSearch;
  @track objectInfo;
  @track iconURL =
    "https://coisadavidacast-dev-ed.my.salesforce.com/img/icon/t4v35/standard/address_120.png";
  @track objectApiName;
  @track showResults = false;

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
        this.showNotification("Error: loading objects", error, "error");
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
    } else if (error) {
      this.showNotification("Error: loading objects icons", error, "error");
    }
  }

  showNotification(_title, _message, _error) {
    const evt = new ShowToastEvent({
      title: _title,
      message: _message,
      variant: _error
    });
    this.dispatchEvent(evt);
  }

  showelement() {
    this.showResults = true;
  }

  hidelement() {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    setTimeout(() => {
      this.showResults = false;
    }, 1000);
  }
}
