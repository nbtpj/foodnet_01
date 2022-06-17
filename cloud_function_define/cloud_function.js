/** các cloud function này được triển khai tại một thư mục độc lập dưới dạng 1 Firebase Project
File này mang tính biểu diễn các cài đặt logic và KHÔNG THỂ TRIỂN KHAI TRỰC TIẾP TỪ ĐÂY.**/

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./mobile-foodnet-firebase-adminsdk-86jzq-71d45cbb23.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const firestore = admin.firestore();

exports.reactionListener = functions
  .region("asia-east1")
  .firestore
  .document('flatten-reactions/{reactionId}')
  .onWrite((change, context) => {
    // onCreate
    if (!change.before.exists && change.after.exists) {
      const postId = change.after.data().postId;
      firestore
        .collection("posts")
        .doc(postId)
        .update({react: FieldValue.increment(1)});
    }
    // onDelete
    else if (change.before.exists && !change.after.exists) {
      const postId = change.before.data().postId;
      firestore
        .collection("posts")
        .doc(postId)
        .update({react: FieldValue.increment(-1)});
    };
    return;
  })

exports.calcMutualism = functions
  .region("asia-east1")
  .https
  .onCall((data, context) => {
    const senderId = context.auth.uid;
    const needCalcIdList = data.idList;
    if (needCalcIdList.length == 0) return {data: null};
    const result = {}
    return firestore.collection("friends").doc(senderId).collection("profiles").get()
        .then(async (snapshot) => {
            let senderFriendIdList = snapshot.docs.map(item => item.id);
            for (let id of needCalcIdList) {
                result[id] = 0;
                const needCalcFriendDoc = await firestore.collection("friends").doc(id).collection("profiles").get();
                for (let doc of needCalcFriendDoc.docs) {
                    if (senderFriendIdList.includes(doc.id)) {
                        result[id]++;
                    }
                }
            }
            return {data: result};
        })
  });

exports.numCite = functions
  .region("asia-east1")
  .https
  .onCall((data, context) => {
    const title = data.title;
    return firestore.collection("posts").where("cateList", "array-contains", title)
        .get()
        .then((snapshot) => {
            return {total: snapshot.size};
        })
  });

exports.getUpvote = functions
  .region("asia-east1")
  .https
  .onCall((data, context) => {
    const postId = data.postId;
    return firestore
        .collection("flatten-reactions")
        .where("postId", "==", postId)
        .where("type", "==", 1)
        .get()
        .then((snapshot) => {
            return {total: snapshot.size}
        })
  });

exports.getDownvote = functions
  .region("asia-east1")
  .https
  .onCall((data, context) => {
    const postId = data.postId;
    return firestore
        .collection("flatten-reactions")
        .where("postId", "==", postId)
        .where("type", "==", -1)
        .get()
        .then((snapshot) => {
            return {total: snapshot.size}
        })
  });
