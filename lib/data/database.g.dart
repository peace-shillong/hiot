// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nrMeta = const VerificationMeta('nr');
  @override
  late final GeneratedColumn<int> nr = GeneratedColumn<int>(
    'nr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [nr, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('nr')) {
      context.handle(_nrMeta, nr.isAcceptableOrUnknown(data['nr']!, _nrMeta));
    } else if (isInserting) {
      context.missing(_nrMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      nr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nr'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int nr;
  final String name;
  const Book({required this.nr, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['nr'] = Variable<int>(nr);
    map['name'] = Variable<String>(name);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(nr: Value(nr), name: Value(name));
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      nr: serializer.fromJson<int>(json['nr']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nr': serializer.toJson<int>(nr),
      'name': serializer.toJson<String>(name),
    };
  }

  Book copyWith({int? nr, String? name}) =>
      Book(nr: nr ?? this.nr, name: name ?? this.name);
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      nr: data.nr.present ? data.nr.value : this.nr,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('nr: $nr, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(nr, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book && other.nr == this.nr && other.name == this.name);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> nr;
  final Value<String> name;
  final Value<int> rowid;
  const BooksCompanion({
    this.nr = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required int nr,
    required String name,
    this.rowid = const Value.absent(),
  }) : nr = Value(nr),
       name = Value(name);
  static Insertable<Book> custom({
    Expression<int>? nr,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (nr != null) 'nr': nr,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<int>? nr,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      nr: nr ?? this.nr,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nr.present) {
      map['nr'] = Variable<int>(nr.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('nr: $nr, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentTable extends Content with TableInfo<$ContentTable, ContentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordnrMeta = const VerificationMeta('wordnr');
  @override
  late final GeneratedColumn<int> wordnr = GeneratedColumn<int>(
    'wordnr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _concordanceMeta = const VerificationMeta(
    'concordance',
  );
  @override
  late final GeneratedColumn<String> concordance = GeneratedColumn<String>(
    'concordance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translitMeta = const VerificationMeta(
    'translit',
  );
  @override
  late final GeneratedColumn<String> translit = GeneratedColumn<String>(
    'translit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strongsMeta = const VerificationMeta(
    'strongs',
  );
  @override
  late final GeneratedColumn<String> strongs = GeneratedColumn<String>(
    'strongs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    verse,
    wordnr,
    word,
    concordance,
    translit,
    strongs,
    lemma,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('wordnr')) {
      context.handle(
        _wordnrMeta,
        wordnr.isAcceptableOrUnknown(data['wordnr']!, _wordnrMeta),
      );
    } else if (isInserting) {
      context.missing(_wordnrMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('concordance')) {
      context.handle(
        _concordanceMeta,
        concordance.isAcceptableOrUnknown(
          data['concordance']!,
          _concordanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_concordanceMeta);
    }
    if (data.containsKey('translit')) {
      context.handle(
        _translitMeta,
        translit.isAcceptableOrUnknown(data['translit']!, _translitMeta),
      );
    } else if (isInserting) {
      context.missing(_translitMeta);
    }
    if (data.containsKey('strongs')) {
      context.handle(
        _strongsMeta,
        strongs.isAcceptableOrUnknown(data['strongs']!, _strongsMeta),
      );
    } else if (isInserting) {
      context.missing(_strongsMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      wordnr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wordnr'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      concordance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concordance'],
      )!,
      translit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translit'],
      )!,
      strongs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strongs'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
    );
  }

  @override
  $ContentTable createAlias(String alias) {
    return $ContentTable(attachedDatabase, alias);
  }
}

class ContentData extends DataClass implements Insertable<ContentData> {
  final int id;
  final String book;
  final int chapter;
  final int verse;
  final int wordnr;
  final String word;
  final String concordance;
  final String translit;
  final String strongs;
  final String lemma;
  const ContentData({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.wordnr,
    required this.word,
    required this.concordance,
    required this.translit,
    required this.strongs,
    required this.lemma,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['wordnr'] = Variable<int>(wordnr);
    map['word'] = Variable<String>(word);
    map['concordance'] = Variable<String>(concordance);
    map['translit'] = Variable<String>(translit);
    map['strongs'] = Variable<String>(strongs);
    map['lemma'] = Variable<String>(lemma);
    return map;
  }

  ContentCompanion toCompanion(bool nullToAbsent) {
    return ContentCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      wordnr: Value(wordnr),
      word: Value(word),
      concordance: Value(concordance),
      translit: Value(translit),
      strongs: Value(strongs),
      lemma: Value(lemma),
    );
  }

  factory ContentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentData(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      wordnr: serializer.fromJson<int>(json['wordnr']),
      word: serializer.fromJson<String>(json['word']),
      concordance: serializer.fromJson<String>(json['concordance']),
      translit: serializer.fromJson<String>(json['translit']),
      strongs: serializer.fromJson<String>(json['strongs']),
      lemma: serializer.fromJson<String>(json['lemma']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'wordnr': serializer.toJson<int>(wordnr),
      'word': serializer.toJson<String>(word),
      'concordance': serializer.toJson<String>(concordance),
      'translit': serializer.toJson<String>(translit),
      'strongs': serializer.toJson<String>(strongs),
      'lemma': serializer.toJson<String>(lemma),
    };
  }

  ContentData copyWith({
    int? id,
    String? book,
    int? chapter,
    int? verse,
    int? wordnr,
    String? word,
    String? concordance,
    String? translit,
    String? strongs,
    String? lemma,
  }) => ContentData(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    wordnr: wordnr ?? this.wordnr,
    word: word ?? this.word,
    concordance: concordance ?? this.concordance,
    translit: translit ?? this.translit,
    strongs: strongs ?? this.strongs,
    lemma: lemma ?? this.lemma,
  );
  ContentData copyWithCompanion(ContentCompanion data) {
    return ContentData(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      wordnr: data.wordnr.present ? data.wordnr.value : this.wordnr,
      word: data.word.present ? data.word.value : this.word,
      concordance: data.concordance.present
          ? data.concordance.value
          : this.concordance,
      translit: data.translit.present ? data.translit.value : this.translit,
      strongs: data.strongs.present ? data.strongs.value : this.strongs,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentData(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('wordnr: $wordnr, ')
          ..write('word: $word, ')
          ..write('concordance: $concordance, ')
          ..write('translit: $translit, ')
          ..write('strongs: $strongs, ')
          ..write('lemma: $lemma')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    book,
    chapter,
    verse,
    wordnr,
    word,
    concordance,
    translit,
    strongs,
    lemma,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentData &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.wordnr == this.wordnr &&
          other.word == this.word &&
          other.concordance == this.concordance &&
          other.translit == this.translit &&
          other.strongs == this.strongs &&
          other.lemma == this.lemma);
}

class ContentCompanion extends UpdateCompanion<ContentData> {
  final Value<int> id;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> wordnr;
  final Value<String> word;
  final Value<String> concordance;
  final Value<String> translit;
  final Value<String> strongs;
  final Value<String> lemma;
  const ContentCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.wordnr = const Value.absent(),
    this.word = const Value.absent(),
    this.concordance = const Value.absent(),
    this.translit = const Value.absent(),
    this.strongs = const Value.absent(),
    this.lemma = const Value.absent(),
  });
  ContentCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required int chapter,
    required int verse,
    required int wordnr,
    required String word,
    required String concordance,
    required String translit,
    required String strongs,
    required String lemma,
  }) : book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse),
       wordnr = Value(wordnr),
       word = Value(word),
       concordance = Value(concordance),
       translit = Value(translit),
       strongs = Value(strongs),
       lemma = Value(lemma);
  static Insertable<ContentData> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<int>? wordnr,
    Expression<String>? word,
    Expression<String>? concordance,
    Expression<String>? translit,
    Expression<String>? strongs,
    Expression<String>? lemma,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (wordnr != null) 'wordnr': wordnr,
      if (word != null) 'word': word,
      if (concordance != null) 'concordance': concordance,
      if (translit != null) 'translit': translit,
      if (strongs != null) 'strongs': strongs,
      if (lemma != null) 'lemma': lemma,
    });
  }

  ContentCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? verse,
    Value<int>? wordnr,
    Value<String>? word,
    Value<String>? concordance,
    Value<String>? translit,
    Value<String>? strongs,
    Value<String>? lemma,
  }) {
    return ContentCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      wordnr: wordnr ?? this.wordnr,
      word: word ?? this.word,
      concordance: concordance ?? this.concordance,
      translit: translit ?? this.translit,
      strongs: strongs ?? this.strongs,
      lemma: lemma ?? this.lemma,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (wordnr.present) {
      map['wordnr'] = Variable<int>(wordnr.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (concordance.present) {
      map['concordance'] = Variable<String>(concordance.value);
    }
    if (translit.present) {
      map['translit'] = Variable<String>(translit.value);
    }
    if (strongs.present) {
      map['strongs'] = Variable<String>(strongs.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('wordnr: $wordnr, ')
          ..write('word: $word, ')
          ..write('concordance: $concordance, ')
          ..write('translit: $translit, ')
          ..write('strongs: $strongs, ')
          ..write('lemma: $lemma')
          ..write(')'))
        .toString();
  }
}

class $StrongsTable extends Strongs with TableInfo<$StrongsTable, Strong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strongs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Strong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Strong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Strong(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $StrongsTable createAlias(String alias) {
    return $StrongsTable(attachedDatabase, alias);
  }
}

class Strong extends DataClass implements Insertable<Strong> {
  final String id;
  final String tag;
  const Strong({required this.id, required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  StrongsCompanion toCompanion(bool nullToAbsent) {
    return StrongsCompanion(id: Value(id), tag: Value(tag));
  }

  factory Strong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Strong(
      id: serializer.fromJson<String>(json['id']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tag': serializer.toJson<String>(tag),
    };
  }

  Strong copyWith({String? id, String? tag}) =>
      Strong(id: id ?? this.id, tag: tag ?? this.tag);
  Strong copyWithCompanion(StrongsCompanion data) {
    return Strong(
      id: data.id.present ? data.id.value : this.id,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Strong(')
          ..write('id: $id, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Strong && other.id == this.id && other.tag == this.tag);
}

class StrongsCompanion extends UpdateCompanion<Strong> {
  final Value<String> id;
  final Value<String> tag;
  final Value<int> rowid;
  const StrongsCompanion({
    this.id = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrongsCompanion.insert({
    required String id,
    required String tag,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tag = Value(tag);
  static Insertable<Strong> custom({
    Expression<String>? id,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrongsCompanion copyWith({
    Value<String>? id,
    Value<String>? tag,
    Value<int>? rowid,
  }) {
    return StrongsCompanion(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrongsCompanion(')
          ..write('id: $id, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ContentTable content = $ContentTable(this);
  late final $StrongsTable strongs = $StrongsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [books, content, strongs];
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required int nr,
      required String name,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> nr,
      Value<String> name,
      Value<int> rowid,
    });

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nr => $composableBuilder(
    column: $table.nr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nr => $composableBuilder(
    column: $table.nr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nr =>
      $composableBuilder(column: $table.nr, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
          Book,
          PrefetchHooks Function()
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> nr = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(nr: nr, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required int nr,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(nr: nr, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
      Book,
      PrefetchHooks Function()
    >;
typedef $$ContentTableCreateCompanionBuilder =
    ContentCompanion Function({
      Value<int> id,
      required String book,
      required int chapter,
      required int verse,
      required int wordnr,
      required String word,
      required String concordance,
      required String translit,
      required String strongs,
      required String lemma,
    });
typedef $$ContentTableUpdateCompanionBuilder =
    ContentCompanion Function({
      Value<int> id,
      Value<String> book,
      Value<int> chapter,
      Value<int> verse,
      Value<int> wordnr,
      Value<String> word,
      Value<String> concordance,
      Value<String> translit,
      Value<String> strongs,
      Value<String> lemma,
    });

class $$ContentTableFilterComposer
    extends Composer<_$AppDatabase, $ContentTable> {
  $$ContentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordnr => $composableBuilder(
    column: $table.wordnr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concordance => $composableBuilder(
    column: $table.concordance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translit => $composableBuilder(
    column: $table.translit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strongs => $composableBuilder(
    column: $table.strongs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentTable> {
  $$ContentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordnr => $composableBuilder(
    column: $table.wordnr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concordance => $composableBuilder(
    column: $table.concordance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translit => $composableBuilder(
    column: $table.translit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strongs => $composableBuilder(
    column: $table.strongs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentTable> {
  $$ContentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<int> get wordnr =>
      $composableBuilder(column: $table.wordnr, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get concordance => $composableBuilder(
    column: $table.concordance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translit =>
      $composableBuilder(column: $table.translit, builder: (column) => column);

  GeneratedColumn<String> get strongs =>
      $composableBuilder(column: $table.strongs, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);
}

class $$ContentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentTable,
          ContentData,
          $$ContentTableFilterComposer,
          $$ContentTableOrderingComposer,
          $$ContentTableAnnotationComposer,
          $$ContentTableCreateCompanionBuilder,
          $$ContentTableUpdateCompanionBuilder,
          (
            ContentData,
            BaseReferences<_$AppDatabase, $ContentTable, ContentData>,
          ),
          ContentData,
          PrefetchHooks Function()
        > {
  $$ContentTableTableManager(_$AppDatabase db, $ContentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<int> wordnr = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> concordance = const Value.absent(),
                Value<String> translit = const Value.absent(),
                Value<String> strongs = const Value.absent(),
                Value<String> lemma = const Value.absent(),
              }) => ContentCompanion(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                wordnr: wordnr,
                word: word,
                concordance: concordance,
                translit: translit,
                strongs: strongs,
                lemma: lemma,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required int chapter,
                required int verse,
                required int wordnr,
                required String word,
                required String concordance,
                required String translit,
                required String strongs,
                required String lemma,
              }) => ContentCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                wordnr: wordnr,
                word: word,
                concordance: concordance,
                translit: translit,
                strongs: strongs,
                lemma: lemma,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentTable,
      ContentData,
      $$ContentTableFilterComposer,
      $$ContentTableOrderingComposer,
      $$ContentTableAnnotationComposer,
      $$ContentTableCreateCompanionBuilder,
      $$ContentTableUpdateCompanionBuilder,
      (ContentData, BaseReferences<_$AppDatabase, $ContentTable, ContentData>),
      ContentData,
      PrefetchHooks Function()
    >;
typedef $$StrongsTableCreateCompanionBuilder =
    StrongsCompanion Function({
      required String id,
      required String tag,
      Value<int> rowid,
    });
typedef $$StrongsTableUpdateCompanionBuilder =
    StrongsCompanion Function({
      Value<String> id,
      Value<String> tag,
      Value<int> rowid,
    });

class $$StrongsTableFilterComposer
    extends Composer<_$AppDatabase, $StrongsTable> {
  $$StrongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StrongsTableOrderingComposer
    extends Composer<_$AppDatabase, $StrongsTable> {
  $$StrongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StrongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrongsTable> {
  $$StrongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$StrongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StrongsTable,
          Strong,
          $$StrongsTableFilterComposer,
          $$StrongsTableOrderingComposer,
          $$StrongsTableAnnotationComposer,
          $$StrongsTableCreateCompanionBuilder,
          $$StrongsTableUpdateCompanionBuilder,
          (Strong, BaseReferences<_$AppDatabase, $StrongsTable, Strong>),
          Strong,
          PrefetchHooks Function()
        > {
  $$StrongsTableTableManager(_$AppDatabase db, $StrongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StrongsCompanion(id: id, tag: tag, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String tag,
                Value<int> rowid = const Value.absent(),
              }) => StrongsCompanion.insert(id: id, tag: tag, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StrongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StrongsTable,
      Strong,
      $$StrongsTableFilterComposer,
      $$StrongsTableOrderingComposer,
      $$StrongsTableAnnotationComposer,
      $$StrongsTableCreateCompanionBuilder,
      $$StrongsTableUpdateCompanionBuilder,
      (Strong, BaseReferences<_$AppDatabase, $StrongsTable, Strong>),
      Strong,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ContentTableTableManager get content =>
      $$ContentTableTableManager(_db, _db.content);
  $$StrongsTableTableManager get strongs =>
      $$StrongsTableTableManager(_db, _db.strongs);
}
