class Clients {
  String uid;
  String clientName;
  String clientPhoneNumber;
  String clientCity;
  String clientBusinessSector;
  String email;
  String salesInCharge;

  Clients({
    this.uid,
    this.clientName,
    this.clientPhoneNumber,
    this.clientCity,
    this.clientBusinessSector,
    this.email,
    this.salesInCharge,
  });
}

//Sales pipeline datamodel
class SalesPipeline {
  SalesPipeline(
      {this.uid,
      this.clientId,
      this.clientName,
      this.visitDate,
      this.salesId,
      this.visitDetails,
      this.visitPurpose,
      this.purposeLabel,
      this.purposeValue,
      this.managerComments,
      this.error});
  String uid;
  String clientId;
  String clientName;
  var visitDate;
  String salesId;
  String visitDetails;
  String visitPurpose;
  String purposeLabel;
  String purposeValue;
  String managerComments;
  String error;
}
