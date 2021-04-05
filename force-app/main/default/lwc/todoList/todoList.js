import { LightningElement, wire, api } from 'lwc';
import getTodoList from '@salesforce/apex/TodoController.getTodoList';
import {refreshApex} from '@salesforce/apex';

export default class TodoList extends LightningElement {
    @api category;
    searchValue = '';
    todos
    error;
    resultForRefresh;

    handleSearch(event) {
        this.searchValue = event.detail;
    }

    @wire(getTodoList, { category: '$category', searchValue: '$searchValue' })
        wiredTodos(result) {
        if (result.data != undefined && result.data.length > 0) {
            this.resultForRefresh = result;
            this.todos = result.data;
            this.error = false;
        } else {
            this.todos = false;
            this.error = true;
        }
    }

    handleDelete() {
        return refreshApex(this.resultForRefresh);
    }
}