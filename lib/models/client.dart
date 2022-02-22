class Clients {
  String uid;
  String lcNumber;
  String clientName;
  String clientPhoneNumber;
  String clientCity;
  String clientBusinessSector;
  var email;
  String salesInCharge;
  String contactPerson;
  String paymentTerms;
  String clientGoogleAddress;
  double lat;
  double long;
  List<dynamic> clientVisits;
  double wonQuotesValue;
  List<dynamic> imageUrls;
  Map company212;
  Map company150;

  Clients(
      {this.uid,
      this.lcNumber,
      this.clientName,
      this.clientPhoneNumber,
      this.clientCity,
      this.clientBusinessSector,
      this.email,
      this.salesInCharge,
      this.contactPerson,
      this.paymentTerms,
      this.clientGoogleAddress,
      this.lat,
      this.long,
      this.clientVisits,
      this.wonQuotesValue,
      this.imageUrls,
      this.company150,
      this.company212});
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

class PurchaseModel {
  PurchaseModel(
      {this.uid,
      this.salesId,
      this.requestDate,
      this.clientName,
      this.clientId,
      this.itemsRequested,
      this.productBrand,
      this.responseDate,
      this.leadTime,
      this.validity,
      this.orderStatus,
      this.emailStatus,
      this.comments});

  String uid;
  String salesId;
  var requestDate;
  String clientName;
  String clientId;
  var itemsRequested;
  String productBrand;
  var responseDate;
  String leadTime;
  String validity;
  String orderStatus;
  String emailStatus;
  String comments;
}
