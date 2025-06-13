class Validator {

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (value.startsWith('data:image/')) {
      return null;
    }

    final urlPattern = r'^(http|https):\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
    final result = RegExp(urlPattern).hasMatch(value);

    if (!result) return 'Introduce una URL válida';
      return null;
    }

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido.';
    }

    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'El peso es requerido';
    }

    final weightRegExp = RegExp(r'^\d+(\.\d+)?$');

    if (!weightRegExp.hasMatch(value)) {
      return 'Valor de peso invalido';
    }

    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Altura requerida';
    }

    final RegExp heightRegex = RegExp(r'^\d{3}$');

    if (!heightRegex.hasMatch(value)) {
      return 'Valor de altura invalido';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Correo es requerido';
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Dirección de correo invalida.';
    }

    return null;
  }

  static String ? validateLenght(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }

    if (value.length > 255) {
      return 'Maximima longitud de 255.';
    }

    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contraseña requerida';
    }

    if (value.length < 6) {
      return 'Contraseña debe ser de una longitud de al menos 6 ';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Contraseña debe contener por lo menos una letra mayuscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Contraseña debe contener por lo menos un numero';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Contraseña debe contener por lo menos un caractér especial.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numero de telefono es requerido.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Formato de numero de telefono invalido (10 digitos son requeridos).';
    }

    return null;
  }

  static String? validateFullName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre completo es requerido.';
  }
  final nameRegExp = RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$');

  if (!nameRegExp.hasMatch(value)) {
    return 'El nombre solo puede contener letras y espacios.';
  }

  if (value.startsWith(' ') || value.endsWith(' ')) {
    return 'El nombre no debe comenzar ni terminar con un espacio.';
  }

  return null;
}

}
