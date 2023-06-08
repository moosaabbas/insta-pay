
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthentication{

    final email;
    final password;
    var errorMessage;
    late FirebaseAuth auth;

    FirebaseAuthentication({required this.email, required this.password}){
          auth = FirebaseAuth.instance;
    }

    Future<bool> signIn() async {

      try{

        await auth.signInWithEmailAndPassword(email: email, password: password);
        return Future.value(true);
      
      } catch(e){
        
        errorMessage = e;
        // print(e);
        return Future.value(false);

      }

    }
    
    showErrorMessage(){
      return errorMessage;
    }

}