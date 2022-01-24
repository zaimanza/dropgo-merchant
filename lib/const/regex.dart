RegExp regExpPassword = RegExp(
  r"/\_{2}|\.{2}|[\<|\>|\'|\`]| /g",
  caseSensitive: false,
  multiLine: false,
);

RegExp regExpUsername = RegExp(
  r"/[\_{2}|\.{2}|\||\^|\*|\<|\>|\?|\\|\/|\;|\&|\=|\'|\+|\,]|\-|\{|\}|\[|\]|\(|\)|\:|\#| /g",
  caseSensitive: false,
  multiLine: false,
);

RegExp regExpPNumber = RegExp(
  r"/[^0-9]/g",
  caseSensitive: false,
  multiLine: false,
);

RegExp regName = RegExp(
  r"/[^A-Z]/g",
  caseSensitive: false,
  multiLine: false,
);
