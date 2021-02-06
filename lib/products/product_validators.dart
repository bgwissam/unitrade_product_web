import 'package:unitrade_web_v2/shared/string.dart';

class ProductValidators {
  //Length Validators
  productLengthValidator(String value) {
    if (value.isNotEmpty) {
      if (double.parse(value) <= 0) {
        return PRODUCT_LENGTH_VAL_ZERO;
      }
    } else {
      return PRODUCT_LENGTH_VAL_EMPTY;
    }
  }

  //Width Validators
  productWidthValidator(String value) {
    if (value.isNotEmpty) {
      if (double.parse(value) <= 0) {
        return PRODUCT_WIDTH_VAL_ZERO;
      }
    } else {
      return PRODUCT_WIDTH_VAL_EMPTY;
    }
  }

  //Thickness Validators
  productThicknessValidator(String value) {
    if (value.isNotEmpty) {
      if (double.parse(value) <= 0) {
        return PRODUCT_THICKNESS_VAL_ZERO;
      }
    } else {
      return PRODUCT_THICKNESS_VAL_EMPTY;
    }
  }

  //Price Validators
  productPriceValidator(String value) {
    if (value.isNotEmpty) {
      if (double.parse(value) <= 0) {
        return PRODUCT_PRICE_VAL_ZERO;
      }
    } else {
      return PRODUCT_PRICE_VAL_EMPTY;
    }
  }

  //Pack validator
  productPackValidator(String value) {
    if(value.isNotEmpty){
      if(double.parse(value) <= 0) {
        return PRODUCT_PACKAGE_VALIDATION;
      }
    } else {
      return PRODUCT_PACKAGE_VAL_EMPTY;
    }
  }
}
