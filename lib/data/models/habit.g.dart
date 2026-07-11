// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitCollection on Isar {
  IsarCollection<Habit> get habits => this.collection();
}

const HabitSchema = CollectionSchema(
  name: r'Habit',
  id: 3896650575830519340,
  properties: {
    r'creationDate': PropertySchema(
      id: 0,
      name: r'creationDate',
      type: IsarType.dateTime,
    ),
    r'currentStreak': PropertySchema(
      id: 1,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'highestStreak': PropertySchema(
      id: 2,
      name: r'highestStreak',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 3,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isBloodOath': PropertySchema(
      id: 4,
      name: r'isBloodOath',
      type: IsarType.bool,
    ),
    r'isCompletedToday': PropertySchema(
      id: 5,
      name: r'isCompletedToday',
      type: IsarType.bool,
    ),
    r'lastCompletedDate': PropertySchema(
      id: 6,
      name: r'lastCompletedDate',
      type: IsarType.dateTime,
    ),
    r'punishmentThreat': PropertySchema(
      id: 7,
      name: r'punishmentThreat',
      type: IsarType.string,
    ),
    r'reminderTimeStr': PropertySchema(
      id: 8,
      name: r'reminderTimeStr',
      type: IsarType.string,
    ),
    r'severityLevel': PropertySchema(
      id: 9,
      name: r'severityLevel',
      type: IsarType.string,
    ),
    r'shatteredDate': PropertySchema(
      id: 10,
      name: r'shatteredDate',
      type: IsarType.dateTime,
    ),
    r'sins': PropertySchema(
      id: 11,
      name: r'sins',
      type: IsarType.long,
    ),
    r'targetDurationSeconds': PropertySchema(
      id: 12,
      name: r'targetDurationSeconds',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    ),
    r'virtues': PropertySchema(
      id: 14,
      name: r'virtues',
      type: IsarType.long,
    ),
    r'warningMinutes': PropertySchema(
      id: 15,
      name: r'warningMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _habitEstimateSize,
  serialize: _habitSerialize,
  deserialize: _habitDeserialize,
  deserializeProp: _habitDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _habitGetId,
  getLinks: _habitGetLinks,
  attach: _habitAttach,
  version: '3.1.0+1',
);

int _habitEstimateSize(
  Habit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.punishmentThreat.length * 3;
  {
    final value = object.reminderTimeStr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.severityLevel.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _habitSerialize(
  Habit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.creationDate);
  writer.writeLong(offsets[1], object.currentStreak);
  writer.writeLong(offsets[2], object.highestStreak);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeBool(offsets[4], object.isBloodOath);
  writer.writeBool(offsets[5], object.isCompletedToday);
  writer.writeDateTime(offsets[6], object.lastCompletedDate);
  writer.writeString(offsets[7], object.punishmentThreat);
  writer.writeString(offsets[8], object.reminderTimeStr);
  writer.writeString(offsets[9], object.severityLevel);
  writer.writeDateTime(offsets[10], object.shatteredDate);
  writer.writeLong(offsets[11], object.sins);
  writer.writeLong(offsets[12], object.targetDurationSeconds);
  writer.writeString(offsets[13], object.title);
  writer.writeLong(offsets[14], object.virtues);
  writer.writeLong(offsets[15], object.warningMinutes);
}

Habit _habitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Habit();
  object.creationDate = reader.readDateTime(offsets[0]);
  object.currentStreak = reader.readLong(offsets[1]);
  object.highestStreak = reader.readLong(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.isBloodOath = reader.readBool(offsets[4]);
  object.isCompletedToday = reader.readBool(offsets[5]);
  object.lastCompletedDate = reader.readDateTimeOrNull(offsets[6]);
  object.punishmentThreat = reader.readString(offsets[7]);
  object.reminderTimeStr = reader.readStringOrNull(offsets[8]);
  object.severityLevel = reader.readString(offsets[9]);
  object.shatteredDate = reader.readDateTimeOrNull(offsets[10]);
  object.sins = reader.readLong(offsets[11]);
  object.targetDurationSeconds = reader.readLong(offsets[12]);
  object.title = reader.readString(offsets[13]);
  object.virtues = reader.readLong(offsets[14]);
  object.warningMinutes = reader.readLong(offsets[15]);
  return object;
}

P _habitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitGetId(Habit object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitGetLinks(Habit object) {
  return [];
}

void _habitAttach(IsarCollection<dynamic> col, Id id, Habit object) {
  object.id = id;
}

extension HabitQueryWhereSort on QueryBuilder<Habit, Habit, QWhere> {
  QueryBuilder<Habit, Habit, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhere> anyTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'title'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhere> anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension HabitQueryWhere on QueryBuilder<Habit, Habit, QWhereClause> {
  QueryBuilder<Habit, Habit, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleGreaterThan(
    String title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [title],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleLessThan(
    String title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [],
        upper: [title],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleBetween(
    String lowerTitle,
    String upperTitle, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [lowerTitle],
        includeLower: includeLower,
        upper: [upperTitle],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleStartsWith(
      String TitlePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [TitlePrefix],
        upper: ['$TitlePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [''],
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> isActiveEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isActive',
        value: [isActive],
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> isActiveNotEqualTo(
      bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HabitQueryFilter on QueryBuilder<Habit, Habit, QFilterCondition> {
  QueryBuilder<Habit, Habit, QAfterFilterCondition> creationDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> creationDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> creationDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creationDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> creationDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> currentStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> highestStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> highestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> highestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> highestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> isBloodOathEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBloodOath',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> isCompletedTodayEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompletedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> lastCompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      lastCompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> lastCompletedDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      lastCompletedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> lastCompletedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> lastCompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'punishmentThreat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'punishmentThreat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'punishmentThreat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> punishmentThreatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'punishmentThreat',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      punishmentThreatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'punishmentThreat',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderTimeStr',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderTimeStr',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderTimeStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderTimeStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderTimeStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTimeStr',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      reminderTimeStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderTimeStr',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'severityLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'severityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'severityLevel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severityLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> severityLevelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'severityLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shatteredDate',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shatteredDate',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shatteredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shatteredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shatteredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> shatteredDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shatteredDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sinsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sins',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sinsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sins',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sinsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sins',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sinsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sins',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      targetDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      targetDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      targetDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      targetDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> virtuesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtues',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> virtuesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'virtues',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> virtuesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'virtues',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> virtuesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'virtues',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> warningMinutesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'warningMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> warningMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'warningMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> warningMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'warningMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> warningMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'warningMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HabitQueryObject on QueryBuilder<Habit, Habit, QFilterCondition> {}

extension HabitQueryLinks on QueryBuilder<Habit, Habit, QFilterCondition> {}

extension HabitQuerySortBy on QueryBuilder<Habit, Habit, QSortBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByHighestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highestStreak', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByHighestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highestStreak', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsBloodOath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBloodOath', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsBloodOathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBloodOath', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsCompletedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByPunishmentThreat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'punishmentThreat', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByPunishmentThreatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'punishmentThreat', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByReminderTimeStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTimeStr', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByReminderTimeStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTimeStr', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySeverityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severityLevel', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySeverityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severityLevel', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByShatteredDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shatteredDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByShatteredDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shatteredDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sins', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sins', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTargetDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTargetDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByVirtues() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtues', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByVirtuesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtues', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByWarningMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningMinutes', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByWarningMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningMinutes', Sort.desc);
    });
  }
}

extension HabitQuerySortThenBy on QueryBuilder<Habit, Habit, QSortThenBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByHighestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highestStreak', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByHighestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highestStreak', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsBloodOath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBloodOath', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsBloodOathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBloodOath', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsCompletedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByPunishmentThreat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'punishmentThreat', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByPunishmentThreatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'punishmentThreat', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByReminderTimeStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTimeStr', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByReminderTimeStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTimeStr', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySeverityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severityLevel', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySeverityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severityLevel', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByShatteredDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shatteredDate', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByShatteredDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shatteredDate', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sins', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sins', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTargetDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTargetDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByVirtues() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtues', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByVirtuesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtues', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByWarningMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningMinutes', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByWarningMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningMinutes', Sort.desc);
    });
  }
}

extension HabitQueryWhereDistinct on QueryBuilder<Habit, Habit, QDistinct> {
  QueryBuilder<Habit, Habit, QDistinct> distinctByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByHighestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highestStreak');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIsBloodOath() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBloodOath');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompletedToday');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDate');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByPunishmentThreat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'punishmentThreat',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByReminderTimeStr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderTimeStr',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctBySeverityLevel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'severityLevel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByShatteredDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shatteredDate');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctBySins() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sins');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByTargetDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDurationSeconds');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByVirtues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'virtues');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByWarningMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'warningMinutes');
    });
  }
}

extension HabitQueryProperty on QueryBuilder<Habit, Habit, QQueryProperty> {
  QueryBuilder<Habit, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Habit, DateTime, QQueryOperations> creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> highestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highestStreak');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> isBloodOathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBloodOath');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> isCompletedTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompletedToday');
    });
  }

  QueryBuilder<Habit, DateTime?, QQueryOperations> lastCompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDate');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> punishmentThreatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'punishmentThreat');
    });
  }

  QueryBuilder<Habit, String?, QQueryOperations> reminderTimeStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderTimeStr');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> severityLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'severityLevel');
    });
  }

  QueryBuilder<Habit, DateTime?, QQueryOperations> shatteredDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shatteredDate');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> sinsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sins');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> targetDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDurationSeconds');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> virtuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'virtues');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> warningMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'warningMinutes');
    });
  }
}
