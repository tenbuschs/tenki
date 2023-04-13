
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{

  final String userID;
  DatabaseService(this.userID);
  final CollectionReference userData=
      Firestore.instance.collection("userData");
  Future setData(String item, bool value)async {
    return await userData.document(userID).setData(
        {item: value}, merge: true);
  }
    Future deleteData(String key) async{
      return await userData.document(userID.updateData({
        key: FieldValue.delete(),
      });
    }
    Future checkIfUserExists() async{
      if((await firestoreData.document(userID).det()).exists){
      return true;
      } else{
        return false;
      }
    }

      ))
    }
  }
