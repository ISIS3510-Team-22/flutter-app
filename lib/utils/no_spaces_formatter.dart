import 'package:flutter/services.dart';

class NoSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Elimina todos los espacios del nuevo valor
    String newText = newValue.text.replaceAll(' ', '');
    
    // Ajusta la posición del cursor si es necesario
    int cursorPosition = newValue.selection.baseOffset;
    if (cursorPosition > newText.length) {
      cursorPosition = newText.length;
    }

    // Retorna el nuevo valor con el cursor en la posición correcta
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
