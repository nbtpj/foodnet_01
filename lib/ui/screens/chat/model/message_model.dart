import 'package:foodnet_01/ui/screens/chat/model/user_model.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;


  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread

  });
}

final User currentUser = User(
    id: 0,
    name: "Foydalanuvchi",
    imgURL: "assets/chat/me.png"
);

final User abdulloh = User(
    id: 1,
    name: "Abdulloh",
    imgURL: "assets/chat/gerb.jpg"
);

final User jobirhon = User(
    id: 2,
    name: "Jobirhon",
    imgURL: "assets/chat/magistrial.jpg"
);
final User javohir = User(
    id: 3,
    name: "Javohir",
    imgURL: "assets/chat/nature.jpg"
);
final User odilbek = User(
    id: 4,
    name: "Odilbek",
    imgURL: "assets/chat/night.jpg"
);
final User samandar = User(
    id: 5,
    name: "Samandar",
    imgURL: "assets/chat/night.jpg"
);

final User bobur = User(
    id: 6,
    name: "Boburjon",
    imgURL: "assets/chat/me.png"
);

final User sobirxon = User(
    id: 7,
    name: "Sobirxon",
    imgURL: "assets/chat/boys.jpg"
);
List<User> favorites = [samandar,sobirxon,odilbek,javohir,abdulloh];
List<Message>  chats = [
  Message(
    sender: jobirhon,
    time: "5:30",
    text: 'Salom. Ahvolariz qanday?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: "4:30",
    text: 'Salom.Nima gaplar Nimalar qilyasan?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: odilbek,
    time: "3:45",
    text: 'Nima yangiliklar?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: javohir,
    time: "3:15",
    text: 'Darslar qalay ketyapti?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: bobur,
    time: "2:30",
    text: 'Nima yangiliklar?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sobirxon,
    time: "2:00",
    text: 'Uydagilar yaxshimi?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: samandar,
    time: "2:20",
    text: 'Uydagilar qayda',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: abdulloh,
    time: "12:00",
    text: 'Nima qilyapsan?',
    isLiked: false,
    unread: false,
  ),
];


List<Message>  messages = [
  Message(
    sender: jobirhon,
    time: "5:30",
    text: 'Salom. Ahvolariz qanday?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: "4:30",
    text: 'Salom.Nima gaplar Nimalar qilyasan?',
    isLiked: false,
    unread: false,
  ),

  Message(
    sender: odilbek,
    time: "3:45",
    text: 'Nima yangiliklar?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: javohir,
    time: "3:15",
    text: 'Darslar qalay ketyapti?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: bobur,
    time: "2:30",
    text: 'Nima yangiliklar?',
    isLiked: false,
    unread: false,
  ),


  Message(
    sender: currentUser,
    time: "12:00",
    text: "Hammasi yaxshi yaxshi yuribman ozingchi \nBizda hammasi yaxshi yangilik yo'q hozir",
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sobirxon,
    time: "2:00",
    text: 'Uydagilar yaxshimi?',
    isLiked: false,
    unread: true,
  ),
];


