#include <cassert>
#include "db.cpp"
// #include "test.cpp"

// HELPER FUNCTIONS

// sqlite3* setup_test() {
//     sqlite3* db;
//     if (sqlite3_open(("test_db.sqlite"), &db) != SQLITE_OK)
//     {
//         std::cout << "ERROR: database not open" << std::endl;
//         std::cout << sqlite3_open(("test_db.sqlite"), &db) << std::endl;
//         return nullptr;
//     }

//     return db;

// }

// TEST GROUP: USERS, PASS
void create_user_pass() {
    // test();
    sqlite3* check_db;
    // sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    // sqlite3_exec(check_db, "CREATE TABLE IF NOT EXISTS users (username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, wins INTEGER, losses INTEGER, draws INTEGER, primary key (username));", NULL, 0, NULL);
    // sqlite3_exec(check_db, "CREATE TABLE IF NOT EXISTS games(GAMEID INTEGER, user TEXT NOT NULL, date DATETIME DEFAULT CURRENT_DATE, title TEXT, notes TEXT, uci TEXT, fens TEXT, time TEXT, primary key (GAMEID), FOREIGN KEY (user) REFERENCES users(username));", NULL, 0, NULL);
    // sqlite3_close(check_db);

    // sqlite3 *check_db;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    db.create_user("test1", "pass");
    // db.check_user("test", "pass");
    // for (auto i : db.get_all_users())
    //     std::cout << i << std::endl;

    PW u;
    char *zErrMsg;
    std::string query = ("SELECT * FROM users WHERE username = 'test';");
    int rc = sqlite3_exec(check_db, query.c_str(), check_password, &u, &zErrMsg);
    std::cout << "password: " << u.password << " result: " << u.result << std::endl;

    db.delete_user();

    assert(1 == 1);
}

void check_user_pass() {
    Database db = Database("test");
    std::string a = db.test();
    assert(a == "Hello");
}

void change_password_pass() {
    Database db = Database("test");
    std::string a = db.test();
    assert(a == "Hello");
}

void delete_user_pass() {
    Database db = Database("test");
    std::string a = db.test();
    assert(a == "Hello");
}

// TEST GROUP: USERS, FAIL
void create_duplicate_user_fail() {
    Database db = Database("test");
    
    assert(1 == 0);
}

// TEST GROUP: GAMES, PASS
void test_fail() {
    assert(1 == 0);
}

// TEST GROUP: GAMES, FAIL

// TEST GROUP: UTILITY, PASS

// TEST GROUP: UTILITY, FAIL