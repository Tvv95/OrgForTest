import { LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class TodoApp extends NavigationMixin(LightningElement) {
  radioValue = "%";

  get options() {
    return [
      { label: "All", value: "%" },
      { label: "Today", value: "Today" },
      { label: "Tomorrow", value: "Tomorrow" },
      { label: "Later", value: "Later" }
    ];
  }

  handleRadio(event) {
    this.radioValue = event.detail.value;
  }

  createTodo() {
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Todo__c",
        actionName: "new"
      },
      state: {
        navigationLocation: "RELATED_LIST"
      }
    });
  }
}
