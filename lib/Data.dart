class Data {
  Data({
      required this.id,
      required this.quoteData,
      required this.quoteName,
      required this.time,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    quoteData = json['quote_data'];
    quoteName = json['quote_name'];
    time = json['time'];
  }
  String? id;
  String? quoteData;
  String? quoteName;
  String? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['quote_data'] = quoteData;
    map['quote_name'] = quoteName;
    map['time'] = time;
    return map;
  }

}