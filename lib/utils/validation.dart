import 'package:flutter/services.dart';

class Validation {}

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    String oText = oldValue.text;
    String nText = newValue.text;

    int oLen = oText.length;
    int nLen = nText.length;
    if(nLen == 1){
      if(nText != '0'){
        nText = oText;
      }
    } else if(nLen == 2){
      if(nText.substring(1,2) != '9'){
        nText = oText;
      }
    }else if(nLen == 4 && oLen != 5){
      nText += ' ';
    }else if(nLen == 5 ){
      if(oLen == 6) {
        nText = nText.substring(0, 4);
      } else if(oLen == 4){
        nText = '${nText.substring(0,4)} ${nText.substring(4,5)}';
      }
    }else if(nLen == 8 && oLen != 9){
      nText += ' ';
    }else if(nLen == 9 ) {
      if (oLen == 10) {
        nText = nText.substring(0, 8);
      } else if (oLen == 8) {
        nText = '${nText.substring(0, 8)} ${nText.substring(8, 9)}';
      }
    }else if(nLen > 13){
      nText = oText;
    }


    return TextEditingValue(
      text: nText,
      selection: TextSelection.collapsed(offset: nText.length),
    );
  }
}
