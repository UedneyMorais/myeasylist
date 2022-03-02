class Item {
  int _id;
  int get id => this._id;
  set id(int value) => this._id = value;

  String _item;
  String get item => this._item;
  set item(String value) => this._item = value;

  int _checked;
  int get checked => this._checked;
  set checked(int value) => this._checked = value;

  Item({id, item, checked})
      : _id = id ?? 1,
        _item = item ?? '',
        _checked = checked ?? 0;
}
