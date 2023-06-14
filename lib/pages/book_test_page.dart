import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';
import 'package:susu/pages/home_page.dart';
import 'package:susu/services/dashboard_service.dart';
import 'package:susu/utils/storage_constant.dart';

class BookTestPage extends StatefulWidget {
  const BookTestPage({super.key});

  @override
  State<BookTestPage> createState() => _BookTestPageState();
}

class _BookTestPageState extends State<BookTestPage> {
  var address = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController();
  var pin = TextEditingController();
  var phone = TextEditingController();
  var box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  String? addressId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress();
  }

  void fetchAddress() {
    DashboardService.fetchAddress(box.read(StorageConstant.id)).then((value) {
      if (value != null) {
        print(value);
        setState(() {
          Map<String, dynamic> data = value['data'] ?? {};
          address.text = data['address'] ?? "";
          city.text = data['city'] ?? "";
          state.text = data['state'] ?? "";
          country.text = data['country'] ?? "";
          pin.text = data['pin'] ?? "";
          phone.text = data['phone1'] ?? "";
          addressId = data['id'];
        });
      }
    });
  }

  var date;
  String dateError = "";
  var time;
  String timeError = "";
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      if (value != null) {
        setState(() {
          time = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Test"),
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            date == null
                                ? "Select Date"
                                : DateFormat('dd-MM-yyyy').format(date),
                            style: TextStyle(
                                color: date == null
                                    ? Colors.black54
                                    : Colors.black87)),
                        Icon(Icons.calendar_month)
                      ],
                    ),
                  ),
                ),
              ),
              dateError.isEmpty
                  ? SizedBox.shrink()
                  : Text(
                      dateError,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextButton(
                    onPressed: () {
                      _showTimePicker();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            time == null
                                ? "Select Time"
                                : DateFormat('h:mm a').format(DateTime(
                                    2023, 1, 1, time.hour, time.minute)),
                            style: TextStyle(
                                color: time == null
                                    ? Colors.black54
                                    : Colors.black87)),
                        Icon(Icons.timer)
                      ],
                    ),
                  ),
                ),
              ),
              timeError.isEmpty
                  ? SizedBox.shrink()
                  : Text(
                      timeError,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Address",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      addressFormField(
                        controller: address,
                        name: "Address",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid Address";
                          }
                          return null;
                        },
                      ),
                      addressFormField(
                        controller: city,
                        name: "City",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid City";
                          }
                          return null;
                        },
                      ),
                      addressFormField(
                        controller: state,
                        name: "State",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid State";
                          }
                          return null;
                        },
                      ),
                      addressFormField(
                        controller: country,
                        name: "Country",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid Country";
                          }
                          return null;
                        },
                      ),
                      addressFormField(
                        controller: pin,
                        name: "Pin Code",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid Pin Code";
                          }
                          return null;
                        },
                      ),
                      addressFormField(
                        controller: phone,
                        name: "Phone",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Provide Valid Pin Code";
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            bool flag = true;
                            if (date == null) {
                              flag = false;
                              setState(() {
                                dateError = "Please Select date";
                              });
                            } else {
                              setState(() {
                                dateError = "";
                              });
                            }
                            if (time == null) {
                              flag = false;
                              setState(() {
                                timeError = "Please Select time";
                              });
                            } else {
                              setState(() {
                                timeError = "";
                              });
                            }

                            if (_formKey.currentState!.validate() && flag) {
                              DashboardService.bookTest(
                                      addressId: addressId,
                                      date:
                                          DateFormat("yyyy-MM-dd").format(date),
                                      time: DateFormat('HH:mm:00').format(
                                          DateTime(2023, 1, 1, time.hour,
                                              time.minute)),
                                      address: address.text,
                                      city: city.text,
                                      state: state.text,
                                      country: country.text,
                                      pin: pin.text,
                                      phone: phone.text,
                                      userId: box.read(StorageConstant.id))
                                  .then((value) {
                                if (value != null) {
                                  if (value['status']) {
                                    box.write(StorageConstant.lastOrderDate,
                                        DateFormat("dd-MM-yyyy").format(date));
                                    if (value['next_date'] != null) {
                                      box.write(StorageConstant.next_date,
                                          value['next_date']);
                                    }

                                    setState(() {});
                                    Get.defaultDialog(
                                      title: "Congratulation",
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Order id is ${value['order_no']}"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "Be ready On ${DateFormat("dd-MM-yyyy").format(date)}\nat time ${DateFormat('h:mm a').format(DateTime(2023, 1, 1, time.hour, time.minute))}"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Thank you for joining us"),
                                        ],
                                      ),
                                      barrierDismissible: false,
                                      confirmTextColor: Colors.black,
                                      onConfirm: () {
                                        Get.off(HomePage());
                                      },
                                    );
                                  }
                                }
                              });
                            }
                          },
                          child: Text("Book Test"))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressFormField(
      {TextEditingController? controller,
      String? Function(String?)? validator,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? textInputType,
      String? name}) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              labelText: name),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
