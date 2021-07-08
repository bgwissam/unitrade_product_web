import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/services/database.dart';

class EmailManagement {
  final CollectionReference salesPipelineMail =
      FirebaseFirestore.instance.collection('salespipeline_mail');

  //Sends email with the comments of the sales manager for the sales team
  Future sendCommentsEmail(
    List<SalesPipeline> commentList,
    String salesmanName,
    String salesmanEmail,
    String adminName,
    String adminEmail,
  ) async {
    var db = DatabaseService();
    try {
      var buffer = StringBuffer();
      //set the detais
      buffer.write(
          '<table><tr><td>Dear ${salesmanName.firstLetterToUpperCase},</td></tr><tr>&nbsp;</tr>');
      buffer.write(
          '<tr><td>Kindly find below the comment on few client visits that need your attention</td></tr><tr>&nbsp;</tr>');

      //Add row for each comment
      for (var comment in commentList) {
        buffer.write(
            '<tr><td>${comment.clientName}</td><td>${comment.managerComments}</td></tr><tr>&nbsp;</tr>');

        await db.updateCommentStatus(comment.uid).catchError((err) {
          print('An error occured while updating commnet staus: $err');
          throw err;
        });
      }

      buffer.write('<tr><td>Thank you</td></tr><tr>&nbsp;</tr>');
      buffer.write(
          '<tr><td>$adminName</td></tr><tr><td>$adminEmail</td></tr></table>');

      if (salesmanEmail != null && commentList.isNotEmpty) {
        return salesPipelineMail.add({
          'to': salesmanEmail,
          'from': adminEmail,
          'message': {
            'subject': 'Pipeline Comments',
            'html': buffer.toString(),
          }
        }).then((value) {
          return value.id;
        }).catchError((err) {
          print('Mail could not be sent because: $err');
          throw err;
        });
      }
    } catch (error, stackTrace) {
      print('the following error as occured: $error');
      throw error;
    }
  }
}

//Capitalize first letter of a string
extension StringExtension on String {
  get firstLetterToUpperCase {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1);
    } else {
      return null;
    }
  }
}
