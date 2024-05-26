import { LightningElement, wire } from "lwc";
//import { getRecords } from "lightning/uiRecordApi";
import getProjectList from "@salesforce/apex/ProjectController.getProjectList";

export default class ProjectCard extends LightningElement {
  projects;
  error;

  @wire(getProjectList)
  wiredProjects({ error, data }) {
    if (data) {
      console.log("*** " + JSON.stringify(data));
      this.projects = data;
      this.error = undefined;
    } else if (error) {
      console.log("*** error: " + JSON.stringify(error));
      this.error = error; // handle errors
      this.projects = undefined;
    }
  }
}
