import 'dart:async';

import 'api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<dynamic> sendOtpRequest(var email) =>
      apiProvider.postOtpRequest(email);

  Future<dynamic> sendRegisterRequest(
    var name,
    var email,
    var password,
    var passwordConfirmation,
    var deviceKey,
    var token,
    var phoneNum,
  ) =>
      apiProvider.postRegisterRequest(
        name,
        email,
        password,
        passwordConfirmation,
        deviceKey,
        token,
        phoneNum,
      );

  Future<dynamic> sendSocialRequest(
    var name,
    var email,
    var deviceKey,
    var uuid,
    var phoneNum,
    var providerName,
  ) =>
      apiProvider.postSocialRequest(
        name,
        email,
        deviceKey,
        uuid,
        phoneNum,
        providerName,
      );

  Future<dynamic> sendUpdateDOB(var dobDate) =>
      apiProvider.postUpdateDOBRequest(dobDate);

  Future<dynamic> sendUpdateAboutYou(
    var cityID,
    var stateID,
    var countryID,
    var salary,
    var zipCode,
    var companyRole,
    var companyName,
  ) =>
      apiProvider.postUpdateAboutRequest(
        cityID,
        stateID,
        countryID,
        salary,
        zipCode,
        companyRole,
        companyName,
      );

  Future<dynamic> sendUpdateUserName(var userName) =>
      apiProvider.postUpdateUserNameRequest(userName);

  Future<dynamic> sendUpdateImage(String imagePath) =>
      apiProvider.postUpdateImageRequest(imagePath);

  Future<dynamic> sendLoginRequest(var email, var password, var fcmToken) =>
      apiProvider.postLoginRequest(email, password, fcmToken);

  Future<dynamic> postForgetEmailRequest(var email) =>
      apiProvider.postForgetEmailRequest(email);

  Future<dynamic> postForgetOtpRequest(var email, var otp) =>
      apiProvider.postForgetOtpRequest(email, otp);

  Future<dynamic> postForgetPasswordRequest(
          var email, var password, var confirmPassword) =>
      apiProvider.postForgetPasswordRequest(email, password, confirmPassword);

  Future<dynamic> postChangePasswordRequest(
          var oldPassword, var password, var confirmPassword) =>
      apiProvider.postChangePasswordRequest(
          oldPassword, password, confirmPassword);

  Future<dynamic> sendUserProfileRequest() =>
      apiProvider.getUserProfileRequest();

  Future<dynamic> addNewContactAPI(
    var name,
    var nickName,
    var phoneNumber,
    var email,
    var streetAddress1,
    var streetAddress2,
    var address,
    var postalCode,
    var countryID,
    var stateID,
    var cityID,
    String imagePath,
  ) =>
      apiProvider.addNewContactAPI(
        name,
        nickName,
        phoneNumber,
        email,
        streetAddress1,
        streetAddress2,
        address,
        postalCode,
        countryID,
        stateID,
        cityID,
        imagePath,
      );

  Future<dynamic> updateContactRequest(
    var id,
    var name,
    var nickName,
    var phoneNumber,
    var email,
    var streetAddress1,
    var streetAddress2,
    var address,
    var postalCode,
    var countryID,
    var stateID,
    var cityID,
    String? imagePath,
  ) =>
      apiProvider.updateContactRequest(
        id,
        name,
        nickName,
        phoneNumber,
        email,
        streetAddress1,
        streetAddress2,
        address,
        postalCode,
        countryID,
        stateID,
        cityID,
        imagePath!,
      );

  Future<dynamic> getSingleContactAPI(int id) =>
      apiProvider.getSingleContactAPI(id);

  Future<dynamic> delContactsRequest(List<String> listIds) =>
      apiProvider.delContactsRequest(listIds);

  Future<dynamic> getSyncContactAPI(List<String> contacts) =>
      apiProvider.getSyncContactAPI(contacts);

  Future<dynamic> addSyncContactAPI(List<int> ids) =>
      apiProvider.addSyncContactAPI(ids);

  Future<dynamic> createGroupAPI(
    List<String> contacts,
    var groupsName,
    String imagePath,
  ) =>
      apiProvider.createGroupAPI(
        contacts,
        groupsName,
        imagePath,
      );

  Future<dynamic> updateGroupAPI(int groupID, List<String> contacts,
          var groupsName, String imagePath) =>
      apiProvider.updateGroupAPI(groupID, contacts, groupsName, imagePath);

  Future<dynamic> getNotAddedContactsAPI(String endPoint, int id) =>
      apiProvider.getNotAddedContactsAPI(endPoint, id);

  Future<dynamic> getSingleGroupDetailAPI(int groupID) =>
      apiProvider.getSingleGroupDetailAPI(groupID);

  Future<dynamic> delGroupsRequest(List<String> listIds) =>
      apiProvider.delGroupsRequest(listIds);

  Future<dynamic> saveReminderAPI(
    List<String> contacts,
    int productId,
    String productType,
    List<int> relationIds,
    List<int> groupIds,
    var groupsName,
    var date,
  ) =>
      apiProvider.saveReminderAPI(
        contacts,
        productId,
        productType,
        relationIds,
        groupIds,
        groupsName,
        date,
      );

  Future<dynamic> updateReminderAPI(
    int id,
    List<String> contacts,
    List<int> relationIds,
    var groupsName,
    var date,
  ) =>
      apiProvider.updateReminderAPI(
        id,
        contacts,
        relationIds,
        groupsName,
        date,
      );

  Future<dynamic> delReminderRequest(int id) =>
      apiProvider.delReminderRequest(id);

  Future<dynamic> saveRelationAPI(var title) =>
      apiProvider.saveRelationAPI(title);

  Future<dynamic> delRelationAPI(int id) => apiProvider.delRelationAPI(id);

  Future<dynamic> saveInterestAPI(var title) =>
      apiProvider.saveInterestAPI(title);

  Future<dynamic> delInterestAPI(int? id) => apiProvider.delInterestAPI(id!);

  Future<dynamic> addToCartRequest(int id, String type) =>
      apiProvider.addToCartRequest(id, type);

  Future<dynamic> delCartItemsRequest(int id) =>
      apiProvider.delCartItemRequest(id);

  Future<dynamic> saveShippingAddressAPI(
    String addressName,
    String streetAddress1,
    String streetAddress2,
    int postalCode,
    int countryID,
    int stateID,
    int cityID,
  ) =>
      apiProvider.saveShippingAddressAPI(
        addressName,
        streetAddress1,
        streetAddress2,
        postalCode,
        countryID,
        stateID,
        cityID,
      );

  Future<dynamic> saveDebitCardAPI(
    String cardHolderName,
    String cardNumber,
    String expireMonth,
    String expireYear,
    String cvv,
  ) =>
      apiProvider.saveDebitCardAPI(
        cardHolderName,
        cardNumber,
        expireMonth,
        expireYear,
        cvv,
      );

  Future<dynamic> updateDebitCardAPI(
    int id,
    String cardHolderName,
    String cardNumber,
    String expireMonth,
    String expireYear,
    String cvv,
  ) =>
      apiProvider.updateDebitCardAPI(
        id,
        cardHolderName,
        cardNumber,
        expireMonth,
        expireYear,
        cvv,
      );

  Future<dynamic> delDebitCardAPI(int? id) => apiProvider.delDebitCardAPI(id!);

  Future<dynamic> placeOrderApi(
    int addressId,
    int subTotal,
    double shippingFee,
    double grandTotal,
    String shippingService,
    String cardNumber,
    String cardType,
    String transactionId,
    String paymentMethod,
    List<String> cartIds,
    int pdfId,
  ) =>
      apiProvider.placeOrderApi(
          addressId,
          subTotal,
          shippingFee,
          grandTotal,
          shippingService,
          cardNumber,
          cardType,
          transactionId,
          paymentMethod,
          cartIds,
          pdfId);
}
