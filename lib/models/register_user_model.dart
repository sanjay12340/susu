// To parse this JSON data, do
//
//     final registerUserModal = registerUserModalFromJson(jsonString);

import 'dart:convert';

RegisterUserModal registerUserModalFromJson(String str) => RegisterUserModal.fromJson(json.decode(str));

String registerUserModalToJson(RegisterUserModal data) => json.encode(data.toJson());

class RegisterUserModal {
    RegisterUserModal({
        this.id,
        this.username,
        this.password,
        this.name,
        this.dob,
        this.sex,
        this.height,
        this.weight,
        this.email,
        this.labName,
        this.phone,
        this.userType,
        this.deviceToken,
        this.loginToken,
        this.otp,
        this.otpStatus,
        this.point,
    
    });

    final String? id;
    final String? username;
    final String? password;
    final String? name;
    final String? dob;
    final String? sex;
    final String? height;
    final String? weight;
    final String? email;
    final String? labName;
    final String? phone;
    final String? userType;
    final String? deviceToken;
    final String? loginToken;
    final String? otp;
    final String? otpStatus;
    final int? point;


    factory RegisterUserModal.fromJson(Map<String, dynamic> json) => RegisterUserModal(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        dob: json["dob"] ,
        sex: json["sex"],
        height: json["height"],
        weight: json["weight"],
        email: json["email"],
        labName: json["lab_name"],
        phone: json["phone"],
        userType: json["user_type"],
        deviceToken: json["device_token"],
        loginToken: json["login_token"],
        otp: json["otp"],
        otpStatus: json["otp_status"],
      

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "name": name,
        "dob": dob,
        "sex": sex,
        "height": height,
        "weight": weight,
        "email": email,
        "lab_name": labName,
        "phone": phone,
        "user_type": userType,
        "device_token": deviceToken,
        "login_token": loginToken,
        "otp": otp,
        "otp_status": otpStatus,
    };
}
