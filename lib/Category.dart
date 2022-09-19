/// status : "1"
/// message : "Record Available"
/// data : [{"c_id":"1","c_name":"Inspirational Quote"},{"c_id":"2","c_name":"Swami Vivekanand Quote"},{"c_id":"3","c_name":"Hardwork Quote"},{"c_id":"4","c_name":"Cool Quote"},{"c_id":"5","c_name":"Sandeep Maheshwari\r\n Quote"},{"c_id":"6","c_name":"Bussiness Quote"},{"c_id":"7","c_name":"Motivational Quote"},{"c_id":"8","c_name":"Attitude Quote"},{"c_id":"9","c_name":"Positive Quote"},{"c_id":"10","c_name":"Life Quote"},{"c_id":"11","c_name":"Morning Quote"}]

class Category {
  Category({
    String? status,
    String? message,
    List<Data>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Category.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  String? _status;
  String? _message;
  List<Data>? _data;

  Category copyWith({
    String? status,
    String? message,
    List<Data>? data,
  }) =>
      Category(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  String? get status => _status;

  String? get message => _message;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// c_id : "1"
/// c_name : "Inspirational Quote"

class Data {
  Data({
    String? cId,
    String? cName,
  }) {
    _cId = cId;
    _cName = cName;
  }

  Data.fromJson(dynamic json) {
    _cId = json['c_id'];
    _cName = json['c_name'];
  }

  String? _cId;
  String? _cName;

  Data copyWith({
    String? cId,
    String? cName,
  }) =>
      Data(
        cId: cId ?? _cId,
        cName: cName ?? _cName,
      );

  String? get cId => _cId;

  String? get cName => _cName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['c_id'] = _cId;
    map['c_name'] = _cName;
    return map;
  }
}
