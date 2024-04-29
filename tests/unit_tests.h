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
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    std::string username = "check_user_pass";
    std::string password = "CheckUserPass";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    bool db_result = db.check_user(username, password);

    // check
    query = ("SELECT password FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.at(0) == password && (db_result == true));
    query = ("DELETE FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
}

void change_password_pass() {
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('change_password_pass', 'ChangePasswordPass')";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "change_password_pass";
    bool db_result = db.check_user(username, "ChangePasswordPass");
    std::string new_passcode = "ChangePasswordNew";
    db.change_password(new_passcode); 
    
    // check
    query = ("SELECT password FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.at(0) == new_passcode);
    query = ("DELETE FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
}

void delete_user_pass() {
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('delete_user_pass', 'DeleteUserPass')";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "delete_user_pass";
    db.check_user(username, "DeleteUserPass");
    db.delete_user(username);

    // check
    query = ("SELECT * FROM users where username = '" + username + "'");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);

    assert(buffer.empty());
    sqlite3_close(check_db);
}

// TEST GROUP: USERS, FAIL
void create_duplicate_user_fail() { 
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string username = "check_duplicate_user_fail";
    std::string password = "CheckDuplicateUserFail";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string new_password = "CheckDuplicateUserFail2";
    db.create_user(username, new_password);
}

void check_user_fail(){ // this test should be passing but has a mem error 
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    std::string username = "check_user_fail";
    std::string password = "CheckUserFail";
    std::string notpassword = "notpassword";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);

    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    bool db_result = db.check_user(username, notpassword);
    std::cout << "result: " << db_result << std::endl;

    // check
    assert(!db_result);
}

// TEST GROUP: GAMES, PASS
void test_create_game(){ 
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test_create_game";
    std::string password = "TestCreateGame";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    std::string title = "TestTitle";
    std::string notes = "TestNotes";
    std::string uci = "TestUci";
    std::string fen = "TestFen";
    db.check_user(username, password);
    db.create_game(title, notes, uci, fen);

    // check

    query = ("SELECT * FROM games WHERE user = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    for (auto i : buffer)
        std::cout << i << std::endl;


    assert((buffer.at(1) == username) && (buffer.at(3) == title) && (buffer.at(4) == notes) && (buffer.at(5) == uci) && (buffer.at(6) == fen));
    db.delete_user(username);
    sqlite3_close(check_db);
}

void test_edit_title(){ 
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test_create_game";
    std::string password = "TestCreateGame";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    std::string title = "TestTitle";
    std::string newTitle = "NewTitle";
    db.check_user(username, password);
    db.delete_games_by_user();
    query = ("INSERT INTO games (user, title) VALUES ('" + username + "', '" + title + "')");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    db.switch_game(title);
    db.edit_title(newTitle);

    // check
    query = ("SELECT title FROM games WHERE user = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);

    assert(buffer.at(0) == newTitle);
    db.delete_user(username);
    sqlite3_close(check_db);
}

void test_edit_note(){
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test_create_game";
    std::string password = "TestCreateGame";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    std::string title = "TestTitle";
    std::string note = "testNote";
    std::string newNote = "NewNote";
    db.check_user(username, password);
    db.delete_games_by_user();
    query = ("INSERT INTO games (user, notes) VALUES ('" + username + "', '" + note + "')");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    db.switch_game(title);
    db.edit_note(newNote);

    // check
    query = ("SELECT notes FROM games WHERE user = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);

    assert(buffer.at(0) == newNote);
    db.delete_user(username);
    sqlite3_close(check_db);
}

void test_retrieve_games_by_title_pass() {
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test_create_game";
    std::string password = "TestCreateGame";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    std::string title = "TestTitle";
    std::string notes = "TestNotes";
    std::string uci = "TestUci";
    std::string fen = "TestFen";
    db.check_user(username, password);
    db.create_game(title, notes, uci, fen);
    std::vector<std::string> retrieve_games_result = db.retrieve_games_by_title(title);
    

    // check

    query = ("SELECT * FROM games WHERE title = '" + title + "' AND user = '" + username + "'");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    for (auto i : buffer)
        std::cout << i << std::endl;
    
    for (int i = 0; i < buffer.size() ;i++){
        assert(buffer.at(i) == retrieve_games_result.at(i));
    }
    db.delete_user(username);
    sqlite3_close(check_db);
}

void test_retrieve_games_by_user_pass() {
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    std::string username = "test_create_game";
    std::string password = "TestCreateGame";
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);

    // test
    std::string title = "TestTitle";
    std::string notes = "TestNotes";
    std::string uci = "TestUci";
    std::string fen = "TestFen";
    db.check_user(username, password);
    db.create_game(title, notes, uci, fen);
    std::vector<std::string> retrieve_games_result = db.retrieve_games_by_user();
    

    // check

    query = ("SELECT * FROM games WHERE user = '" + username + "'");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    for (auto i : buffer)
        std::cout << i << std::endl;
    
    for (int i = 0; i < buffer.size() ;i++){
        assert(buffer.at(i) == retrieve_games_result.at(i));
    }
    db.delete_user(username);
    sqlite3_close(check_db);
}

void delete_games_by_user_pass() {
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    std::string username = "delete_games_by_user_pass";
    std::string password = "deleteGamesByUser";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "')";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    db.check_user(username, password);
    db.create_game("game1");
    db.create_game("game2");

    db.delete_games_by_user();
    
    // check
    query = ("SELECT * FROM games WHERE user = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.empty());
    query = ("DELETE FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
} 

void delete_games_by_id_pass() {
    // setup
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    std::string username = "delete_games_by_user_pass";
    std::string password = "deleteGamesByUser";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "')";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    db.check_user(username, password);
    db.create_game("game1");
    db.switch_game("game1");

    db.delete_games_by_id();
    
    // check
    query = ("SELECT * FROM games WHERE title = 'game1';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.empty());
    query = ("DELETE FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
}


void switch_game_pass() {
    sqlite3* check_db;
    std::vector<std::string> buffer;
    char *zErrMsg;
    std::string username = "switch_game_pass";
    std::string password = "switchGame";
    sqlite3_open("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db.sqlite", &check_db);
    std::string query = "INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "')";
    int rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    
    // test
    Database db = Database("/mnt/c/Users/ansle/school/csce482/the-gamblers/tests/db");
    db.check_user(username, password);
    db.create_game("game1");
    db.create_game("game2");
    db.switch_game("game1");
    db.edit_note("testing");

    // check
    query = ("SELECT notes FROM games WHERE title = 'game1';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.at(0) == "testing");
    buffer = {};
    query = ("SELECT notes FROM games WHERE title = 'game2';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    assert(buffer.at(0) != "testing");

    query = ("SELECT * FROM games WHERE title = 'game1';");
    rc = sqlite3_exec(check_db, query.c_str(), write_data, &buffer, &zErrMsg);
    query = ("DELETE FROM users WHERE username = '" + username + "';");
    rc = sqlite3_exec(check_db, query.c_str(), NULL, 0, &zErrMsg);
    sqlite3_close(check_db);
}
