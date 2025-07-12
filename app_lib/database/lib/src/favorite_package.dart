import 'package:app_database/src/type_converter.dart';
import 'package:drift/drift.dart';

class FavoritePackage extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('name').unique()();
  TextColumn get description => text().named('description')();
  TextColumn get licenses =>
      text().map(const StringListConverter()).named('licenses')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
