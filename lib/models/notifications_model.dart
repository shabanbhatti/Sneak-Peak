class NotificationsModel {
  
final String? title;
final String? body;
final int? id;
final String? metaDataTitle;
final String? metaDataBody;
final String? date;
final bool? isRead;

const NotificationsModel({this.body,this.date , this.id, this.isRead, this.title, this.metaDataTitle, this.metaDataBody});


factory NotificationsModel.fromMap(Map<String,dynamic> data){
  return NotificationsModel(title: data['title']??'', id: data['id']??0, body: data['body']??'',isRead: data['isRead']??false,metaDataTitle: data['metaDataTitle']??'', metaDataBody: data['metaDataBody']??'', date: data['date']??'');
}


Map<String,dynamic> toMap(int myId){
  return {
    'title': title??'',
    'id': myId,
    'body':body??'',
    'date':date,
    'isRead': isRead??false,
    'metaDataTitle':metaDataTitle,
    'metaDataBody':metaDataBody
  };
}


}

