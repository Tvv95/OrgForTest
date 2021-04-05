import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TodoItem extends NavigationMixin(LightningElement) {
    @api todoData;

    editTodo() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                recordId: this.todoData.Id,
                objectApiName: 'Todo__c',
                actionName: 'edit'
            }
        });
    }

    deleteTodo(event) {
        const recordId = event.target.dataset.recordid;
        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Todo ' + this.todoData.Name + ' was deleted',
                        variant: 'success'
                    })
                );
                const deleteEvent = new CustomEvent('delete');
                this.dispatchEvent(deleteEvent);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
    }
}