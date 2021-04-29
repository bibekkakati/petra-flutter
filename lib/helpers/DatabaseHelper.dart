import 'package:petra/models/Result.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _ongoingTable = "ongoingTable";
  String _recordsTable = "recordsTable";
  String _colId = "id";
  String _colTitle = "title";
  String _colCycleLength = "cycleLength";
  String _colLastPeriod = "lastPeriod";
  String _colNextPeriod = "nextPeriod";
  String _colFollicularPhase = "follicularPhase";
  String _colOvulationPhase = "ovulationPhase";
  String _colLutealPhase = "lutealPhase";

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'periods.db';

    var periodsDatabase =
        await openDatabase(path, version: 1, onCreate: _createTables);
    return periodsDatabase;
  }

  void _createTables(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $_ongoingTable($_colId TEXT PRIMARY KEY, $_colTitle TEXT, $_colCycleLength INTEGER, $_colLastPeriod TEXT, $_colNextPeriod TEXT, $_colFollicularPhase TEXT, $_colOvulationPhase TEXT,  $_colLutealPhase TEXT )");
    await db.execute(
        "CREATE TABLE $_recordsTable($_colId TEXT PRIMARY KEY, $_colTitle TEXT, $_colCycleLength INTEGER, $_colLastPeriod TEXT, $_colNextPeriod TEXT, $_colFollicularPhase TEXT, $_colOvulationPhase TEXT,  $_colLutealPhase TEXT )");
  }

  Future<bool> insertCycle(Result cycle) async {
    Database db = await this.database;
    int result = await db.insert(_ongoingTable, cycle.toMap());
    return result != null ? true : false;
  }

  Future<bool> deleteCycle(Result cycle) async {
    Database db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $_ongoingTable WHERE $_colId = ?', [cycle.id]);
    return result > 0 ? true : false;
  }

  Future<bool> deleteAllCycles() async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $_ongoingTable');
    return result > 0 ? true : false;
  }

  Future<bool> deleteRecord(Result cycle) async {
    Database db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $_recordsTable WHERE $_colId = ?', [cycle.id]);
    return result > 0 ? true : false;
  }

  Future<bool> moveCycle(Result cycle) async {
    Database db = await this.database;
    int q;
    await db.transaction((txn) async {
      q = await txn.insert(_recordsTable, cycle.toMap());
      q = await txn.rawDelete(
          'DELETE FROM $_ongoingTable WHERE $_colId = ?', [cycle.id]);
    });
    return q > 0 ? true : false;
  }

  Future<List<Map<String, dynamic>>> getOngoingCyclesMapList() async {
    Database db = await this.database;
    var result = await db.query(_ongoingTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getRecordCyclesMapList() async {
    Database db = await this.database;
    var result = await db.query(_recordsTable);
    return result;
  }

  Future<List<Result>> getOngoingCycles() async {
    var cycleMapList = await getOngoingCyclesMapList();
    int count = cycleMapList.length;

    List<Result> cycleList = [];
    for (int i = 0; i < count; i++) {
      cycleList.add(Result.fromMapObject(cycleMapList[i]));
    }
    return cycleList;
  }

  Future<List<Result>> getRecordCycles() async {
    var cycleMapList = await getRecordCyclesMapList();
    int count = cycleMapList.length;

    List<Result> cycleList = [];
    for (int i = 0; i < count; i++) {
      cycleList.add(Result.fromMapObject(cycleMapList[i]));
    }
    return cycleList;
  }
}
