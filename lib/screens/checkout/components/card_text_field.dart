import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String? title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int? maxLength;
  final TextAlign? textAlign;

  const CardTextField(
      {super.key,
      this.title,
      this.bold = false,
      required this.hint,
      required this.textInputType,
      required this.inputFormatters,
      required this.validator,
      this.maxLength,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        initialValue: '',
        validator: validator,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      if (state.hasError)
                        Text(
                          '   Inválido',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
                TextFormField(
                  cursorColor: Colors.white,
                  textAlign: textAlign ?? TextAlign.start,
                  maxLength: maxLength,
                  style: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red
                        : Colors.white,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title == null && state.hasError
                          ? Colors.red.withAlpha(100)
                          : Colors.white.withAlpha(100),
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                ),
              ],
            ),
          );
        });
  }
}
