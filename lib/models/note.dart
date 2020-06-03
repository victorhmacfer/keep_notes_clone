class Note {
  String title;
  String text;
  bool _pinned;
  bool _archived;
  int colorIndex;

  Note(
      {this.title = '',
      this.text = '',
      this.colorIndex = 0,
      pinned = false,
      archived = false}) {
    _pinned = pinned;
    _archived = archived;
  }

  bool get pinned => _pinned;
  bool get archived => _archived;

  // pinning a note should unarchive it
  set pinned(bool newValue) {
    if ((newValue == true) && (_archived)) _archived = false;
    _pinned = newValue;
  }

  // archiving a note should unpin it.
  set archived(bool newValue) {
    if ((newValue == true) && (_pinned)) _pinned = false;
    _archived = newValue;
  }
}
