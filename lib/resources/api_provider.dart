import 'dart:convert';

import 'package:http/http.dart'
    show Client, MultipartFile, MultipartRequest, Response;

import 'cache_manager.dart';
import 'models/common_model.dart';
import 'models/get_contact_sync_model.dart';
import 'models/login_error_model.dart';
import 'models/login_model.dart';
import 'models/not_added_contacts_model.dart';
import 'models/register_error_model.dart';
import 'models/register_model.dart';
import 'models/single_contact_model.dart';
import 'models/single_group_detail_model.dart';
import 'models/social_model.dart';
import 'models/user_profile_model.dart';
import 'models/user_update_detail_model.dart';
import 'urls.dart';

class ApiProvider with CacheManager {
  Client client = Client();

  String? get id => getId();

  String? get pn => getNumber();

  String? get token => getToken();

  postOtpRequest(var email) async {
    print("Call Email Otp API");

    final response = await client.post(
      Uri.parse(baseUrl + 'auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  postRegisterRequest(
    var name,
    var email,
    var password,
    var passwordConfirmation,
    var deviceKey,
    var token,
    var phoneNum,
  ) async {
    print("Call Register User API");

    final response = await client.post(
      Uri.parse(baseUrl + 'verify_otp'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_key': deviceKey,
        'token': token,
        'phone_num': phoneNum,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return registerModelFromJson(response, response.body);
    } else {
      return registerErrorModelFromJson(response, response.body);
    }
  }

  postSocialRequest(
    var name,
    var email,
    var deviceKey,
    var uuid,
    var phoneNum,
    var providerName,
  ) async {
    print("Call Social User API");

    final response = await client.post(
      Uri.parse(baseUrl + 'social/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'providerUserEmail': email,
        'device_key': deviceKey,
        'phone_num': phoneNum,
        'providerUserId': uuid,
        'provider_name': providerName,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return socialModelFromJson(response.body);
    }
  }

  postLoginRequest(var email, var password, var fcmToken) async {
    print("Call Login API");

    final response = await client.post(
      Uri.parse(baseUrl + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_key': fcmToken,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return loginModelFromJson(response, response.body);
    } else {
      return loginErrorModelFromJson(response, response.body);
    }
  }

  postForgetEmailRequest(var email) async {
    print("Call Forget Email API");

    print(email);

    final response = await client.post(
      Uri.parse(baseUrl + 'password/forgot-password?email=$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  postForgetOtpRequest(var email, var otp) async {
    print("Call Forget Otp Verify API");

    final response = await client.post(
      Uri.parse(baseUrl + 'password/verifyOtp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'token': otp,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      return commonModelFromJson(response, response.body);
    } else {
      return commonModelFromJson(response, response.body);
    }
  }

  postForgetPasswordRequest(
      var email, var password, var confirmPassword) async {
    print("Call Forget Change Password API");

    final response = await client.post(
      Uri.parse(baseUrl + 'password/change'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  postChangePasswordRequest(
      var oldPassword, var password, var confirmPassword) async {
    print("Call Change Password API");

    final response = await client.post(
      Uri.parse(baseUrl + 'user/password/change'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    } else if (response.statusCode == 422) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  getUserProfileRequest() async {
    print("Call User Profile API");

    print("Token ::" + token.toString());

    final response = await client.get(
      Uri.parse(baseUrl + 'user'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url::" + baseUrl + "user");
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return userProfileModelFromJson(response.body);
    }
  }

  postUpdateDOBRequest(var dobDate) async {
    print("Call Update DOB API");

    final response = await client.post(
      Uri.parse(baseUrl + 'details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'dob_date': dobDate,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
      return userUpdateDetailModelFromJson(response.body);
    }
  }

  postUpdateAboutRequest(
    var cityID,
    var stateID,
    var countryID,
    var salary,
    var zipCode,
    var companyRole,
    var companyName,
  ) async {
    print("Call Update About You API");

    final response = await client.post(
      Uri.parse(baseUrl + 'details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'city_id': cityID,
        'state_id': stateID,
        'country_id': countryID,
        'salary': salary,
        'zip_code': zipCode,
        'company_role': companyRole,
        'company_name': companyName,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
      return userUpdateDetailModelFromJson(response.body);
    }
  }

  postUpdateUserNameRequest(var name) async {
    print("Call User Name API");

    final response = await client.post(
      Uri.parse(baseUrl + 'details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
      return userUpdateDetailModelFromJson(response.body);
    }
  }

  postUpdateImageRequest(String imagePath) async {
    print("Call Image Update API");

    var request = MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'details'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    request.files.add(await MultipartFile.fromPath('user_image', imagePath));
    var streamResponse = await request.send();

    var response = await Response.fromStream(streamResponse);

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
      return userUpdateDetailModelFromJson(response.body);
    }
  }

  addNewContactAPI(
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
  ) async {
    var request = MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'contacts'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    try {
      request.files.add(await MultipartFile.fromPath('contact_img', imagePath));
    } catch (e) {
      print(e);
      request.fields['contact_img'] = imagePath;
    }

    request.fields['name'] = name;
    request.fields['nick_name'] = nickName;
    request.fields['phone_num'] = phoneNumber;
    request.fields['email'] = email;
    request.fields['street_address1'] = streetAddress1;
    request.fields['street_address2'] = streetAddress2;
    request.fields['address'] = address;
    request.fields['postal_code'] = postalCode;
    request.fields['country_id'] = countryID.toString();
    request.fields['state_id'] = stateID.toString();
    request.fields['city_id'] = cityID.toString();

    print("Call Add New Contact API");
    var streamResponse = await request.send();
    var response = await Response.fromStream(streamResponse);
    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      return commonModelFromJson(response, response.body);
    }
  }

  updateContactRequest(
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
    String imagePath,
  ) async {
    var request = MultipartRequest('POST', Uri.parse(baseUrl + 'contacts/$id'));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      request.files.add(await MultipartFile.fromPath('contact_img', imagePath));
    } catch (e) {
      print(e);
      request.fields['contact_img'] = imagePath;
    }

    request.fields['name'] = name;
    request.fields['nick_name'] = nickName;
    request.fields['phone_num'] = phoneNumber;
    request.fields['email'] = email;
    request.fields['street_address1'] = streetAddress1;
    request.fields['street_address2'] = streetAddress2;
    request.fields['address'] = address;
    request.fields['postal_code'] = postalCode;
    request.fields['country_id'] = countryID.toString();
    request.fields['state_id'] = stateID.toString();
    request.fields['city_id'] = cityID.toString();
    request.fields['_method'] = 'put';

    print("Call Update Contact API");
    var streamResponse = await request.send();
    var response = await Response.fromStream(streamResponse);

    print(response.body);

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      return commonModelFromJson(response, response.body);
    }
  }

  getSingleContactAPI(int id) async {
    print("Call All Contact API");
    final response = await client.get(
      Uri.parse(baseUrl + 'contacts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "contact");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return singleContactModelFromJson(response.body.toString());
    }
  }

  delContactsRequest(List<String> listIds) async {
    print("Call Delete Contacts API ::" + listIds.length.toString());

    List<int> list = [];

    listIds.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    final response = await client.post(
      Uri.parse(baseUrl + 'multiple-delete'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': list,
        '_method': "delete",
      }),
    );

    print("url ::" + baseUrl + "multiple-delete");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  getSyncContactAPI(List<String> contacts) async {
    print("Call Sync Contacts API");

    final response = await client.post(
      Uri.parse(baseUrl + 'contactSync'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'contact_num': contacts,
      }),
    );

    print("url ::" + baseUrl + "contactSync");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return getContactSyncModelFromJson(response.body.toString());
    }
  }

  addSyncContactAPI(List<int> ids) async {
    print("Call Add Sync Contacts API");

    final response = await client.post(
      Uri.parse(baseUrl + 'addSyncContact'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'users_id': ids,
      }),
    );

    print("url ::" + baseUrl + "addSyncContact");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body.toString());
    }
  }

  createGroupAPI(
    List<String> contacts,
    var groupName,
    String imagePath,
  ) async {
    print("Call Create Group API ::" + contacts.length.toString());

    List<int> list = [];

    contacts.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    var request = MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'group'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      request.files.add(await MultipartFile.fromPath('group_img', imagePath));
    } catch (e) {
      print(e);
      request.fields['group_img'] = imagePath;
    }
    request.fields['title'] = groupName;

    for (int i = 0; i < list.length; i++) {
      request.fields['contact_ids[$i]'] = '${list[i]}';
    }

    var streamResponse = await request.send();

    var response = await Response.fromStream(streamResponse);

    print("url ::" + baseUrl + "group");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  getNotAddedContactsAPI(String endPoint, int id) async {
    print("Call Not Added Contacts API ");

    final response = await client.get(
      Uri.parse(baseUrl + '$endPoint/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "$endPoint/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());
    if (response.statusCode == 200) {
      print(response.body.toString());
      return notAddedContactsModelFromJson(response.body.toString());
    }
  }

  getSingleGroupDetailAPI(int groupID) async {
    print("Call Get Single Group Detail API ");

    final response = await client.get(
      Uri.parse(baseUrl + 'group/$groupID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "groupContacts/$groupID");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());
    if (response.statusCode == 200) {
      print(response.body.toString());
      return getSingleGroupModelFromJson(response.body.toString());
    }
  }

  updateGroupAPI(
    int groupID,
    List<String> contacts,
    var groupName,
    String imagePath,
  ) async {
    print("Call Update Group API ::" + contacts.length.toString());

    List<int> list = [];

    contacts.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    var request = MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'group/$groupID'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      request.files.add(await MultipartFile.fromPath('group_img', imagePath));
    } catch (e) {
      print(e);
    }
    request.fields['title'] = groupName;
    request.fields['_method'] = 'put';
    for (int i = 0; i < list.length; i++) {
      request.fields['contact_id[$i]'] = '${list[i]}';
    }

    var streamResponse = await request.send();

    var response = await Response.fromStream(streamResponse);

    print("url ::" + baseUrl + "group/$groupID");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  delGroupsRequest(List<String> listIds) async {
    print("Call Delete Groups API ::" + listIds.length.toString());

    List<int> list = [];

    listIds.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    final response = await client.post(
      Uri.parse(baseUrl + 'delete-groups'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': list,
      }),
    );

    print("url ::" + baseUrl + "delete-groups");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  saveReminderAPI(
    List<String> contacts,
    int productId,
    String productType,
    List<int> relationIds,
    List<int> groupIds,
    var groupsName,
    var date,
  ) async {
    print("Call Create Reminder API ::" + contacts.length.toString());

    List<int> list = [];

    contacts.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    final response = await client.post(
      Uri.parse(baseUrl + 'reminder'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': groupsName,
        'contact_ids': list,
        '$productType': productId,
        'relation_ids': relationIds,
        'group_ids': groupIds,
        'date_time': date,
      }),
    );

    print("url ::" + baseUrl + "reminder");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  updateReminderAPI(
    int id,
    List<String> contacts,
    List<int> relationIds,
    var groupsName,
    var date,
  ) async {
    print("Call update Reminder API ::" + contacts.length.toString());

    List<int> list = [];

    contacts.forEach((element) {
      int contact = int.parse(element);
      list.add(contact);
    });

    final response = await client.post(
      Uri.parse(baseUrl + 'reminder/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': groupsName,
        'contact_ids': list,
        'relation_ids': relationIds,
        'date_time': date,
        '_method': 'put',
      }),
    );

    print("url ::" + baseUrl + "reminder/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  delReminderRequest(int id) async {
    print("Call Delete Reminder API");
    final response = await client.delete(
      Uri.parse(baseUrl + 'reminder/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "reminder/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  saveInterestAPI(var title) async {
    print("Call Add Interest You API");

    final response = await client.post(
      Uri.parse(baseUrl + 'interest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return commonModelFromJson(response, response.body);
    }
  }

  delInterestAPI(int id) async {
    print("Call Delete Interest API");
    final response = await client.delete(
      Uri.parse(baseUrl + 'interest/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "interest/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  addToCartRequest(int itemId, String type) async {
    print("Call Add To Cart API");

    if (type == "gift") {
      final response = await client.post(
        Uri.parse(baseUrl + 'cart'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'gift_id': itemId,
        }),
      );

      print("url ::" + baseUrl + "cart");

      print(
          response.statusCode == 200 ? 'Status OK' : response.body.toString());

      if (response.statusCode == 200) {
        print(response.body.toString());
        return commonModelFromJson(response, response.body.toString());
      }
    } else if (type == "card") {
      final response = await client.post(
        Uri.parse(baseUrl + 'cart'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'card_id': itemId,
        }),
      );

      print(
          response.statusCode == 200 ? 'Status OK' : response.body.toString());

      if (response.statusCode == 200) {
        print(response.body.toString());
        return commonModelFromJson(response, response.body.toString());
      }
    }
  }

  delCartItemRequest(int id) async {
    print("Call Delete Interest API");
    final response = await client.delete(
      Uri.parse(baseUrl + 'cart/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "cart/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      return commonModelFromJson(response, response.body);
    }
  }

  saveRelationAPI(var title) async {
    print("url ::" + baseUrl + "relation");

    final response = await client.post(
      Uri.parse(baseUrl + 'relation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return commonModelFromJson(response, response.body);
    }
  }

  delRelationAPI(int id) async {
    print("url ::" + baseUrl + "relation/$id");

    final response = await client.delete(
      Uri.parse(baseUrl + 'relation/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  saveShippingAddressAPI(
    String addressName,
    String streetAddress1,
    String streetAddress2,
    int postalCode,
    int countryID,
    int stateID,
    int cityID,
  ) async {
    print("Call Save Shipping Address API");

    final response = await client.post(
      Uri.parse(baseUrl + 'address'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'address_name': addressName,
        'street_address1': streetAddress1,
        'street_address2': streetAddress2,
        'postal_code': postalCode,
        'country_id': countryID,
        'state_id': stateID,
        'city_id': cityID,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return commonModelFromJson(response, response.body);
    } else {
      return commonModelFromJson(response, response.body);
    }
  }

  delShippingAddressAPI(int id) async {
    print("Call Delete Shipping Address API");

    final response = await client.delete(
      Uri.parse(baseUrl + 'interest/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "address/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());

      return commonModelFromJson(response, response.body);
    }
  }

  saveDebitCardAPI(
    String cardHolderName,
    String cardNumber,
    String expireMonth,
    String expireYear,
    String cvv,
  ) async {
    print("Call Add DebitCard API");

    final response = await client.post(
      Uri.parse(baseUrl + 'payment_cards'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'card_holder_name': cardHolderName,
        'card_number': cardNumber,
        'expire_month': expireMonth,
        'expire_year': expireYear,
        'cvv': cvv,
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return commonModelFromJson(response, response.body);
    }
  }

  updateDebitCardAPI(
    int id,
    String cardHolderName,
    String cardNumber,
    String expireMonth,
    String expireYear,
    String cvv,
  ) async {
    print("Call Update DebitCard API");

    final response = await client.post(
      Uri.parse(baseUrl + 'payment_cards/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'card_holder_name': cardHolderName,
        'card_number': cardNumber,
        'expire_month': expireMonth,
        'expire_year': expireYear,
        'cvv': cvv,
        '_method': 'patch',
      }),
    );

    print(response.statusCode == 200 ? 'Status: OK' : response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return commonModelFromJson(response, response.body);
    }
  }

  delDebitCardAPI(int id) async {
    print("Call Remove DebitCard API");
    final response = await client.delete(
      Uri.parse(baseUrl + 'payment_cards/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("url ::" + baseUrl + "payment_cards/$id");
    print(response.statusCode == 200 ? 'Status OK' : response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      return commonModelFromJson(response, response.body);
    }
  }

  placeOrderApi(
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
  ) async {
    print("Call Place Order API");

    final response = await client.post(
      Uri.parse(baseUrl + 'order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'address_id': addressId,
        'sub_total': subTotal,
        'shipping_fee': shippingFee,
        'grand_total': grandTotal,
        'shipping_service': shippingService,
        'card_number': cardNumber,
        'card_type': cardType,
        'transaction_id': transactionId,
        'payment_method': paymentMethod,
        'cart_ids': cartIds,
        'pdf_id': pdfId,
      }),
    );
    print(response.statusCode == 200 ? 'Status: OK' : response.body.toString());

    if (response.statusCode == 200) {
      return commonModelFromJson(response, response.body);
    }
  }
}
