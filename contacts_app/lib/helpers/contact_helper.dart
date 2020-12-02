import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contact_tb = 'contact_tb';
final String idContact = 'idContact';
final String nameContact = 'nameContact';
final String emailContact = 'emailContact';
final String phoneContact = 'phoneContact';
final String imgContact = 'imgContact';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $contact_tb('
              '$idContact INTEGER PRIMARY KEY,'
              '$nameContact TEXT,'
              '$emailContact TEXT,'
              '$phoneContact TEXT,'
              '$imgContact TEXT)'
        );
      },);
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contact_tb, contact.toMap());

    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contact_tb,
      columns: [idContact, nameContact, emailContact, phoneContact, imgContact],
      where: '$idContact = ?',
      whereArgs: [id]
    );
    if(maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(contact_tb, where: '$idContact = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contact_tb,
        contact.toMap(),
        where: '$idContact = ?',
        whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContact() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery('SELECT * FROM $contact_tb');
    List<Contact> listContact = List();
    for(Map map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery('SELECT COUNT(*) FROM $contact_tb'));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idContact];
    name = map[nameContact];
    email = map[emailContact];
    phone = map[phoneContact];
    img = map[imgContact];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameContact: name,
      emailContact: email,
      phoneContact: phone,
      imgContact: img
    };

    if (id != null) {
      map[idContact] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)';
  }
}
