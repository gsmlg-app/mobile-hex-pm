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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _licensesMeta =
      const VerificationMeta('licenses');
  @override
  late final GeneratedColumn<String> licenses = GeneratedColumn<String>(
      'licenses', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
    if (data.containsKey('licenses')) {
      context.handle(_licensesMeta,
          licenses.isAcceptableOrUnknown(data['licenses']!, _licensesMeta));
    } else if (isInserting) {
      context.missing(_licensesMeta);
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
      licenses: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}licenses'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $FavoritePackageTable createAlias(String alias) {
    return $FavoritePackageTable(attachedDatabase, alias);
  }
}

class FavoritePackageData extends DataClass
    implements Insertable<FavoritePackageData> {
  final int id;
  final String name;
  final String description;
  final String licenses;
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
    map['licenses'] = Variable<String>(licenses);
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
      licenses: serializer.fromJson<String>(json['licenses']),
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
      'licenses': serializer.toJson<String>(licenses),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  FavoritePackageData copyWith(
          {int? id,
          String? name,
          String? description,
          String? licenses,
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
  final Value<String> licenses;
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
    required String licenses,
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
      Value<String>? licenses,
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
      map['licenses'] = Variable<String>(licenses.value);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritePackageTable favoritePackage =
      $FavoritePackageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoritePackage];
}

typedef $$FavoritePackageTableCreateCompanionBuilder = FavoritePackageCompanion
    Function({
  Value<int> id,
  required String name,
  required String description,
  required String licenses,
  Value<DateTime?> createdAt,
});
typedef $$FavoritePackageTableUpdateCompanionBuilder = FavoritePackageCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> licenses,
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

  ColumnFilters<String> get licenses => $composableBuilder(
      column: $table.licenses, builder: (column) => ColumnFilters(column));

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

  GeneratedColumn<String> get licenses =>
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
            Value<String> licenses = const Value.absent(),
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
            required String licenses,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritePackageTableTableManager get favoritePackage =>
      $$FavoritePackageTableTableManager(_db, _db.favoritePackage);
}
