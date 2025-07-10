import 'package:drift/drift.dart';

class FavoritePackage extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('name')();
  TextColumn get description => text().named('description')();
  TextColumn get licenses => text().named('licenses')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
