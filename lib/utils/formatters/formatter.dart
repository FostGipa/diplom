import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TFormatters {

  final MaskTextInputFormatter passportFormatter = MaskTextInputFormatter(
    mask: '#### ######',
    filter: {"#": RegExp(r'[0-9A-Z]')},
  );

  // Маска на DobroID
  final MaskTextInputFormatter dobroIdFormatter = MaskTextInputFormatter(
    filter: {"#": RegExp(r'[0-9A-Z]')},
  );

  final MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
  );
}