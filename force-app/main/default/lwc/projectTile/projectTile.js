import { LightningElement, api } from "lwc";

export default class ProjectTile extends LightningElement {
  @api project;
  handleLogIssue() {
    // Logic to handle the issue logging
  }
}
