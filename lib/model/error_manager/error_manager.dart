class ErrorManager {
  static String show(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Bu mail adresi kullanılıyor. Giriş yapmayı deneyin";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Mail adresi veya şifreniz yanlış";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Kullanıcı bulunamadı. Kayıt olmayı deneyin";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Kullanıcı devre dışı bırakıldı";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Çok fazla istekre bulundunuz daha sonra tekrar deneyiniz";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Beklenmeyen bir hata oluştu daha sonra terar deneyin";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Geçersiz mail adresi girdiniz";
      default:
        return "Beklenmeyen bir hata oluştu daha sonra terar deneyin";
    }
  }
}
