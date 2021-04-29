class Result {
  String _id;
  int _cycleLength;
  DateTime _lastPeriod;
  DateTime _nextPeriod;
  DateTime _follicularPhase;
  DateTime _ovulationPhase;
  DateTime _lutealPhase;

  Result(
    this._id,
    this._cycleLength,
    this._lastPeriod,
    this._nextPeriod,
    this._follicularPhase,
    this._ovulationPhase,
    this._lutealPhase,
  );

  String get id => this._id;
  int get cycleLength => this._cycleLength;
  DateTime get lastPeriod => this._lastPeriod;
  DateTime get nextPeriod => this._nextPeriod;
  DateTime get follicularPhase => this._follicularPhase;
  DateTime get ovulationPhase => this._ovulationPhase;
  DateTime get lutealPhase => this._lutealPhase;

  set id(String value) {
    this._id = value;
  }

  set cycleLength(int value) {
    this._cycleLength = value;
  }

  set lastPeriod(DateTime value) {
    this._lastPeriod = value;
  }

  set nextPeriod(DateTime value) {
    this._nextPeriod = value;
  }

  set follicularPhase(DateTime value) {
    this._follicularPhase = value;
  }

  set ovulationPhase(DateTime value) {
    this._ovulationPhase = value;
  }

  set lutealPhase(DateTime value) {
    this._lutealPhase = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['cycleLength'] = this.cycleLength;
    map['lastPeriod'] = this.lastPeriod.toString();
    map['nextPeriod'] = this.nextPeriod.toString();
    map['follicularPhase'] = this.follicularPhase.toString();
    map['ovulationPhase'] = this.ovulationPhase.toString();
    map['lutealPhase'] = this.lutealPhase.toString();

    return map;
  }

  Result.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.cycleLength = map['cycleLength'];
    this.lastPeriod = DateTime.parse(map['lastPeriod']);
    this.nextPeriod = DateTime.parse(map['nextPeriod']);
    this.follicularPhase = DateTime.parse(map['follicularPhase']);
    this.ovulationPhase = DateTime.parse(map['ovulationPhase']);
    this.lutealPhase = DateTime.parse(map['lutealPhase']);
  }
}
