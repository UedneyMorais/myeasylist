import 'package:flutter_test/flutter_test.dart';
import 'package:myeasylist/domain/domain.dart';

void main() {
    late Map<String, dynamic> rawJson;

group('description', (){

    setUp(() {
      rawJson = {"id": 1, "checked": 1, "item": "Item 1"};
    });

    test('GIVEN all item\'s parameters as valid,WHEN user creates an item,THEN should return an item', () {
      var systemUnderTest = Item(id: 1,checked: 1, item: "Item 1");
      
      expect(systemUnderTest, isA<Item>());
    });

    test('GIVEN an item read request with null id on json response,WHEN decode json,THEN should return an item', () {
      rawJson['id'] = null;
      var systemUnderTest = Item(id: 1,checked: 1, item: "Item 1");
      expect(systemUnderTest.id, 1);
    });

});



}