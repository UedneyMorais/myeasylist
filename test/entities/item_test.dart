import 'package:flutter_test/flutter_test.dart';
import 'package:myeasylist/domain/domain.dart';

void main() {

    test('GIVEN all item\'s parameters as valid,WHEN user creates an item,THEN should return an item', () {
      var systemUnderTest = Item(id: 1,checked: 1, item: "Item 1");
      
      expect(systemUnderTest, isA<Item>());
    });
  
}