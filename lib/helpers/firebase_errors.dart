String getErrorString(String code) {
  switch (code) {
    case 'ERROR_WEAK_PASSWORD':
      return 'Sua senha é muito fraca.';
    case 'ERROR_INVALID_EMAIL':
      return 'Seu e-mail é inválido.';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    case 'user-not-found':
      return 'Não há usuário com este e-mail.';
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'Operação não permitida.';

    default:
      return 'Um erro indefinido ocorreu.';
  }
}
