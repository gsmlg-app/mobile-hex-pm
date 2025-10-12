import 'package:drift/drift.dart';

class DocsServerConfig extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get host => text().withDefault(const Constant('localhost'))();

  IntColumn get port => integer().withDefault(const Constant(8080))();

  BoolColumn get autoStart => boolean().withDefault(const Constant(false))();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}