// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoritePackageTable extends FavoritePackage
    with TableInfo<$FavoritePackageTable, FavoritePackageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritePackageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> licenses =
      GeneratedColumn<String>('licenses', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $FavoritePackageTable.$converterlicenses);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, licenses, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_package';
  @override
  VerificationContext validateIntegrity(
      Insertable<FavoritePackageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoritePackageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritePackageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      licenses: $FavoritePackageTable.$converterlicenses.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}licenses'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $FavoritePackageTable createAlias(String alias) {
    return $FavoritePackageTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterlicenses =
      const StringListConverter();
}

class FavoritePackageData extends DataClass
    implements Insertable<FavoritePackageData> {
  final int id;
  final String name;
  final String description;
  final List<String> licenses;
  final DateTime? createdAt;
  const FavoritePackageData(
      {required this.id,
      required this.name,
      required this.description,
      required this.licenses,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    {
      map['licenses'] = Variable<String>(
          $FavoritePackageTable.$converterlicenses.toSql(licenses));
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  FavoritePackageCompanion toCompanion(bool nullToAbsent) {
    return FavoritePackageCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      licenses: Value(licenses),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory FavoritePackageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritePackageData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      licenses: serializer.fromJson<List<String>>(json['licenses']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'licenses': serializer.toJson<List<String>>(licenses),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  FavoritePackageData copyWith(
          {int? id,
          String? name,
          String? description,
          List<String>? licenses,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      FavoritePackageData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        licenses: licenses ?? this.licenses,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  FavoritePackageData copyWithCompanion(FavoritePackageCompanion data) {
    return FavoritePackageData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      licenses: data.licenses.present ? data.licenses.value : this.licenses,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePackageData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('licenses: $licenses, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, licenses, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritePackageData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.licenses == this.licenses &&
          other.createdAt == this.createdAt);
}

class FavoritePackageCompanion extends UpdateCompanion<FavoritePackageData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<List<String>> licenses;
  final Value<DateTime?> createdAt;
  const FavoritePackageCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.licenses = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoritePackageCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required List<String> licenses,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        description = Value(description),
        licenses = Value(licenses);
  static Insertable<FavoritePackageData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? licenses,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (licenses != null) 'licenses': licenses,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritePackageCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<List<String>>? licenses,
      Value<DateTime?>? createdAt}) {
    return FavoritePackageCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      licenses: licenses ?? this.licenses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (licenses.present) {
      map['licenses'] = Variable<String>(
          $FavoritePackageTable.$converterlicenses.toSql(licenses.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePackageCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('licenses: $licenses, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocsServerConfigTable extends DocsServerConfig
    with TableInfo<$DocsServerConfigTable, DocsServerConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocsServerConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
      'host', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('localhost'));
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(8080));
  static const VerificationMeta _autoStartMeta =
      const VerificationMeta('autoStart');
  @override
  late final GeneratedColumn<bool> autoStart = GeneratedColumn<bool>(
      'auto_start', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_start" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, host, port, autoStart, enabled, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'docs_server_config';
  @override
  VerificationContext validateIntegrity(
      Insertable<DocsServerConfigData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('auto_start')) {
      context.handle(_autoStartMeta,
          autoStart.isAcceptableOrUnknown(data['auto_start']!, _autoStartMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocsServerConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocsServerConfigData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      host: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port'])!,
      autoStart: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_start'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DocsServerConfigTable createAlias(String alias) {
    return $DocsServerConfigTable(attachedDatabase, alias);
  }
}

class DocsServerConfigData extends DataClass
    implements Insertable<DocsServerConfigData> {
  final int id;
  final String host;
  final int port;
  final bool autoStart;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DocsServerConfigData(
      {required this.id,
      required this.host,
      required this.port,
      required this.autoStart,
      required this.enabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['auto_start'] = Variable<bool>(autoStart);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocsServerConfigCompanion toCompanion(bool nullToAbsent) {
    return DocsServerConfigCompanion(
      id: Value(id),
      host: Value(host),
      port: Value(port),
      autoStart: Value(autoStart),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DocsServerConfigData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocsServerConfigData(
      id: serializer.fromJson<int>(json['id']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      autoStart: serializer.fromJson<bool>(json['autoStart']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'autoStart': serializer.toJson<bool>(autoStart),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DocsServerConfigData copyWith(
          {int? id,
          String? host,
          int? port,
          bool? autoStart,
          bool? enabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DocsServerConfigData(
        id: id ?? this.id,
        host: host ?? this.host,
        port: port ?? this.port,
        autoStart: autoStart ?? this.autoStart,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DocsServerConfigData copyWithCompanion(DocsServerConfigCompanion data) {
    return DocsServerConfigData(
      id: data.id.present ? data.id.value : this.id,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      autoStart: data.autoStart.present ? data.autoStart.value : this.autoStart,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocsServerConfigData(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('autoStart: $autoStart, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, host, port, autoStart, enabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocsServerConfigData &&
          other.id == this.id &&
          other.host == this.host &&
          other.port == this.port &&
          other.autoStart == this.autoStart &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocsServerConfigCompanion extends UpdateCompanion<DocsServerConfigData> {
  final Value<int> id;
  final Value<String> host;
  final Value<int> port;
  final Value<bool> autoStart;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DocsServerConfigCompanion({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.autoStart = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DocsServerConfigCompanion.insert({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.autoStart = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<DocsServerConfigData> custom({
    Expression<int>? id,
    Expression<String>? host,
    Expression<int>? port,
    Expression<bool>? autoStart,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (autoStart != null) 'auto_start': autoStart,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DocsServerConfigCompanion copyWith(
      {Value<int>? id,
      Value<String>? host,
      Value<int>? port,
      Value<bool>? autoStart,
      Value<bool>? enabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DocsServerConfigCompanion(
      id: id ?? this.id,
      host: host ?? this.host,
      port: port ?? this.port,
      autoStart: autoStart ?? this.autoStart,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (autoStart.present) {
      map['auto_start'] = Variable<bool>(autoStart.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocsServerConfigCompanion(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('autoStart: $autoStart, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritePackageTable favoritePackage =
      $FavoritePackageTable(this);
  late final $DocsServerConfigTable docsServerConfig =
      $DocsServerConfigTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [favoritePackage, docsServerConfig];
}

typedef $$FavoritePackageTableCreateCompanionBuilder = FavoritePackageCompanion
    Function({
  Value<int> id,
  required String name,
  required String description,
  required List<String> licenses,
  Value<DateTime?> createdAt,
});
typedef $$FavoritePackageTableUpdateCompanionBuilder = FavoritePackageCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<List<String>> licenses,
  Value<DateTime?> createdAt,
});

class $$FavoritePackageTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritePackageTable> {
  $$FavoritePackageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get licenses => $composableBuilder(
          column: $table.licenses,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritePackageTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritePackageTable> {
  $$FavoritePackageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenses => $composableBuilder(
      column: $table.licenses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritePackageTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritePackageTable> {
  $$FavoritePackageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get licenses =>
      $composableBuilder(column: $table.licenses, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritePackageTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritePackageTable,
    FavoritePackageData,
    $$FavoritePackageTableFilterComposer,
    $$FavoritePackageTableOrderingComposer,
    $$FavoritePackageTableAnnotationComposer,
    $$FavoritePackageTableCreateCompanionBuilder,
    $$FavoritePackageTableUpdateCompanionBuilder,
    (
      FavoritePackageData,
      BaseReferences<_$AppDatabase, $FavoritePackageTable, FavoritePackageData>
    ),
    FavoritePackageData,
    PrefetchHooks Function()> {
  $$FavoritePackageTableTableManager(
      _$AppDatabase db, $FavoritePackageTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritePackageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritePackageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritePackageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<List<String>> licenses = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              FavoritePackageCompanion(
            id: id,
            name: name,
            description: description,
            licenses: licenses,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String description,
            required List<String> licenses,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              FavoritePackageCompanion.insert(
            id: id,
            name: name,
            description: description,
            licenses: licenses,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritePackageTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritePackageTable,
    FavoritePackageData,
    $$FavoritePackageTableFilterComposer,
    $$FavoritePackageTableOrderingComposer,
    $$FavoritePackageTableAnnotationComposer,
    $$FavoritePackageTableCreateCompanionBuilder,
    $$FavoritePackageTableUpdateCompanionBuilder,
    (
      FavoritePackageData,
      BaseReferences<_$AppDatabase, $FavoritePackageTable, FavoritePackageData>
    ),
    FavoritePackageData,
    PrefetchHooks Function()>;
typedef $$DocsServerConfigTableCreateCompanionBuilder
    = DocsServerConfigCompanion Function({
  Value<int> id,
  Value<String> host,
  Value<int> port,
  Value<bool> autoStart,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DocsServerConfigTableUpdateCompanionBuilder
    = DocsServerConfigCompanion Function({
  Value<int> id,
  Value<String> host,
  Value<int> port,
  Value<bool> autoStart,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$DocsServerConfigTableFilterComposer
    extends Composer<_$AppDatabase, $DocsServerConfigTable> {
  $$DocsServerConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoStart => $composableBuilder(
      column: $table.autoStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DocsServerConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $DocsServerConfigTable> {
  $$DocsServerConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoStart => $composableBuilder(
      column: $table.autoStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DocsServerConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocsServerConfigTable> {
  $$DocsServerConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<bool> get autoStart =>
      $composableBuilder(column: $table.autoStart, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocsServerConfigTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocsServerConfigTable,
    DocsServerConfigData,
    $$DocsServerConfigTableFilterComposer,
    $$DocsServerConfigTableOrderingComposer,
    $$DocsServerConfigTableAnnotationComposer,
    $$DocsServerConfigTableCreateCompanionBuilder,
    $$DocsServerConfigTableUpdateCompanionBuilder,
    (
      DocsServerConfigData,
      BaseReferences<_$AppDatabase, $DocsServerConfigTable,
          DocsServerConfigData>
    ),
    DocsServerConfigData,
    PrefetchHooks Function()> {
  $$DocsServerConfigTableTableManager(
      _$AppDatabase db, $DocsServerConfigTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocsServerConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocsServerConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocsServerConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> host = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<bool> autoStart = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DocsServerConfigCompanion(
            id: id,
            host: host,
            port: port,
            autoStart: autoStart,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> host = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<bool> autoStart = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DocsServerConfigCompanion.insert(
            id: id,
            host: host,
            port: port,
            autoStart: autoStart,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocsServerConfigTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocsServerConfigTable,
    DocsServerConfigData,
    $$DocsServerConfigTableFilterComposer,
    $$DocsServerConfigTableOrderingComposer,
    $$DocsServerConfigTableAnnotationComposer,
    $$DocsServerConfigTableCreateCompanionBuilder,
    $$DocsServerConfigTableUpdateCompanionBuilder,
    (
      DocsServerConfigData,
      BaseReferences<_$AppDatabase, $DocsServerConfigTable,
          DocsServerConfigData>
    ),
    DocsServerConfigData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritePackageTableTableManager get favoritePackage =>
      $$FavoritePackageTableTableManager(_db, _db.favoritePackage);
  $$DocsServerConfigTableTableManager get docsServerConfig =>
      $$DocsServerConfigTableTableManager(_db, _db.docsServerConfig);
}
