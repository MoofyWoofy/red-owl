// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HistoryTable extends History with TableInfo<$HistoryTable, HistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _guessCorrectMeta =
      const VerificationMeta('guessCorrect');
  @override
  late final GeneratedColumn<bool> guessCorrect = GeneratedColumn<bool>(
      'guess_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("guess_correct" IN (0, 1))'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [word, guessCorrect, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('guess_correct')) {
      context.handle(
          _guessCorrectMeta,
          guessCorrect.isAcceptableOrUnknown(
              data['guess_correct']!, _guessCorrectMeta));
    } else if (isInserting) {
      context.missing(_guessCorrectMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  HistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryData(
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      guessCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}guess_correct'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryData extends DataClass implements Insertable<HistoryData> {
  final String word;
  final bool guessCorrect;
  final DateTime date;
  const HistoryData(
      {required this.word, required this.guessCorrect, required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word'] = Variable<String>(word);
    map['guess_correct'] = Variable<bool>(guessCorrect);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      word: Value(word),
      guessCorrect: Value(guessCorrect),
      date: Value(date),
    );
  }

  factory HistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryData(
      word: serializer.fromJson<String>(json['word']),
      guessCorrect: serializer.fromJson<bool>(json['guessCorrect']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'word': serializer.toJson<String>(word),
      'guessCorrect': serializer.toJson<bool>(guessCorrect),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  HistoryData copyWith({String? word, bool? guessCorrect, DateTime? date}) =>
      HistoryData(
        word: word ?? this.word,
        guessCorrect: guessCorrect ?? this.guessCorrect,
        date: date ?? this.date,
      );
  HistoryData copyWithCompanion(HistoryCompanion data) {
    return HistoryData(
      word: data.word.present ? data.word.value : this.word,
      guessCorrect: data.guessCorrect.present
          ? data.guessCorrect.value
          : this.guessCorrect,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryData(')
          ..write('word: $word, ')
          ..write('guessCorrect: $guessCorrect, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(word, guessCorrect, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryData &&
          other.word == this.word &&
          other.guessCorrect == this.guessCorrect &&
          other.date == this.date);
}

class HistoryCompanion extends UpdateCompanion<HistoryData> {
  final Value<String> word;
  final Value<bool> guessCorrect;
  final Value<DateTime> date;
  final Value<int> rowid;
  const HistoryCompanion({
    this.word = const Value.absent(),
    this.guessCorrect = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryCompanion.insert({
    required String word,
    required bool guessCorrect,
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : word = Value(word),
        guessCorrect = Value(guessCorrect),
        date = Value(date);
  static Insertable<HistoryData> custom({
    Expression<String>? word,
    Expression<bool>? guessCorrect,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (word != null) 'word': word,
      if (guessCorrect != null) 'guess_correct': guessCorrect,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryCompanion copyWith(
      {Value<String>? word,
      Value<bool>? guessCorrect,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return HistoryCompanion(
      word: word ?? this.word,
      guessCorrect: guessCorrect ?? this.guessCorrect,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (guessCorrect.present) {
      map['guess_correct'] = Variable<bool>(guessCorrect.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryCompanion(')
          ..write('word: $word, ')
          ..write('guessCorrect: $guessCorrect, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HistoryTable history = $HistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [history];
}

typedef $$HistoryTableCreateCompanionBuilder = HistoryCompanion Function({
  required String word,
  required bool guessCorrect,
  required DateTime date,
  Value<int> rowid,
});
typedef $$HistoryTableUpdateCompanionBuilder = HistoryCompanion Function({
  Value<String> word,
  Value<bool> guessCorrect,
  Value<DateTime> date,
  Value<int> rowid,
});

class $$HistoryTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer(super.$state);
  ColumnFilters<String> get word => $state.composableBuilder(
      column: $state.table.word,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get guessCorrect => $state.composableBuilder(
      column: $state.table.guessCorrect,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HistoryTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer(super.$state);
  ColumnOrderings<String> get word => $state.composableBuilder(
      column: $state.table.word,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get guessCorrect => $state.composableBuilder(
      column: $state.table.guessCorrect,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$HistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryTable,
    HistoryData,
    $$HistoryTableFilterComposer,
    $$HistoryTableOrderingComposer,
    $$HistoryTableCreateCompanionBuilder,
    $$HistoryTableUpdateCompanionBuilder,
    (HistoryData, BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>),
    HistoryData,
    PrefetchHooks Function()> {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HistoryTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HistoryTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> word = const Value.absent(),
            Value<bool> guessCorrect = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoryCompanion(
            word: word,
            guessCorrect: guessCorrect,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String word,
            required bool guessCorrect,
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoryCompanion.insert(
            word: word,
            guessCorrect: guessCorrect,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoryTable,
    HistoryData,
    $$HistoryTableFilterComposer,
    $$HistoryTableOrderingComposer,
    $$HistoryTableCreateCompanionBuilder,
    $$HistoryTableUpdateCompanionBuilder,
    (HistoryData, BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>),
    HistoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HistoryTableTableManager get history =>
      $$HistoryTableTableManager(_db, _db.history);
}
