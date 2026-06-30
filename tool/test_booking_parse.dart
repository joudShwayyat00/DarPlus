import 'dart:convert';

import 'package:dar_plus_app/features/booking/data/models/my_booking_item.dart';

const jsonStr = '''
[{"id":28,"customer":"test owner","asset_id":{"id":10,"name":"New Asset","description":"<p>New Asset</p>","image":"https://darplus.moneymaker-app.com/storage/assets/3lawtnlbFYyoEb8IyN20LyeiTkJjJCR9w9mR3xZT.jpg","images":["https://darplus.moneymaker-app.com/storage/assets/otNDa9OQqLl6zihGiDos0EkL67cUruZoEWJicKg7.jpg"],"space":null,"rooms":null,"is_available":1,"location":"Location","country":"Jordan","city":"city1","region":"region1","price":"222.00","phone":"12312312312","email":"douaa.hasan011@gmail.com","category":{"id":4,"name":"New Category","image":"https://darplus.moneymaker-app.com/storage/categories/N3VjJWxdIRNXTfFT5avltEltkJUpABLqHozsPlbv.png"},"owner":{"id":1,"name":"Douaa","email":"douaa.hasan011@gmail.com","phone_number":"123123123","image":null,"status":"blocked","role":"owner","rating":"4.0000","is_subscribed":false},"type":"rent","months_count":11,"rent_type":"monthly","rent_price":100,"day_price":"10.00","attributes":[{"id":3,"name":"attribute","type":"text","value":"1111","icon":"https://darplus.moneymaker-app.com/storage/attributes/1778553554.png"}],"amenities":[{"id":2,"name":"test1","icon":"https://darplus.moneymaker-app.com/storage/attributes/1778553323.jpeg"}],"latitude":"25.4561193","longitude":"46.5262979","video":"assets/videos/Wi4MSQDUo2lv62H0syFcPHZiEpdDaWPVLTnbMBXO.mp4","check_in_time":null,"check_out_time":null},"check_in_date":"20-08-2026","check_out_date":"20-11-2026","type":"rent","price":"100.00","nights":0,"months_count":4,"years_count":0,"guests":2,"total_price":"400.00","service_fee":"40.00","final_price":"440.00","payment_method":"cod","notes":null,"status":"pending","currency":"JD"}]
''';

void main() {
  final list = jsonDecode(jsonStr) as List;
  for (final item in list) {
    final booking = MyBookingItem.fromJson(item as Map<String, dynamic>);
    print('OK: ${booking.id} ${booking.asset.name}');
  }
}
