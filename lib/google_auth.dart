import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('GoogleAuthentication');
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com',
);

Future<void> signInWithGoogle(Function(String?) onEmailSubmitted) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      _logger.info('The user canceled the sign-in');
      return;
    } else {
      _logger.info('User signed-in: $googleUser');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    _logger.info('User authentication: $googleAuth');

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      onEmailSubmitted(user.email);
    }
  } catch (e) {
    _logger.severe('Google sign-in failed: $e');
  }
}
