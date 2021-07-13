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
      this.error,
      this.commentsSent});
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
  bool commentsSent;
}

class QuoteData {
  QuoteData(
      {this.quoteId,
      this.products,
      this.itemQuoted,
      this.dateTime,
      this.userId,
      this.clientId,
      this.clientName,
      this.paymentTerms,
      this.status,
      this.sendingStatus,
      this.pdfUrl,
      this.error});
  String quoteId;
  List<Map<String, dynamic>> products;
  List<dynamic> itemQuoted;
  String userId;
  var dateTime;
  String clientId;
  String clientName;
  String paymentTerms;
  String status;
  String sendingStatus;
  String pdfUrl;
  String error;
}
