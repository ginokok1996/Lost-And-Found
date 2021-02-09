import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_and_found/services/auth_service.dart';

class AuthBloc {
  final authService = AuthSerice();
  final googleSignin = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase sign in
      final result = await authService.signInWithCredential(credential);

      print('${result.user.displayName}');
    } catch (error) {
      print(error);
    }
  }

  logout() {
    authService.logout();
  }
}
