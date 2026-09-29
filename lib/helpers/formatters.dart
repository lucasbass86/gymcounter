import 'package:flutter/services.dart';

class PaceBlockingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Solo dígitos
    var raw = newValue.text.replaceAll(':', '');

    // Limitar a 4 dígitos (MMSS)
    if (raw.length > 4) {
      raw = raw.substring(0, 4);
    }

    // Validación en tiempo real
    if (raw.isNotEmpty) {
      final mm = int.tryParse(raw.substring(0, raw.length.clamp(0, 2))) ?? 0;
      if (mm > 59) return oldValue; // minutos inválidos
    }

    if (raw.length >= 3) {
      final ss = int.tryParse(raw.substring(2, raw.length)) ?? 0;
      if (ss > 59) return oldValue; // segundos inválidos
    }

    // Construcción del formato MM:SS
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      buffer.write(raw[i]);
      if (i == 1 && raw.length > 2) {
        buffer.write(':');
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
