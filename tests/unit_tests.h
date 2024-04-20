#include <cassert>
#include "db.cpp"
#include <ctime>

// HELPER FUNCTIONS

// TEST GROUP: USERS, PASS
void create_user_pass() {
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test" + std::to_string(std::time(0));
    db.create_user(username, "pass");

    // check
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);

    std::string query = ("SELECT * FROM users WHERE username = '" + username + "';");
    int rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);

    assert(buffer.at(1) == "pass");
    db.delete_user(username);
    sqlite3_close(check_db);
}

void check_user_pass() {
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test" + std::to_string(std::time(0));
    db.create_user(username, "pass");

    // check
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);

    std::string query = ("SELECT * FROM users WHERE username = '" + username + "';");
    int rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);

    assert(buffer.at(1) == "pass");
    sqlite3_close(check_db);
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