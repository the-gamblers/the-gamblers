#include "db.cpp"

static int test() {
    sqlite3 *check_db;
    sqlite3_open("./db.sqlite", &check_db);
    sqlite3_exec(check_db, "CREATE TABLE IF NOT EXISTS users (username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, wins INTEGER, losses INTEGER, draws INTEGER, primary key (username));", NULL, 0, NULL);
    sqlite3_exec(check_db, "CREATE TABLE IF NOT EXISTS games(GAMEID INTEGER, user TEXT NOT NULL, date DATETIME DEFAULT CURRENT_DATE, title TEXT, notes TEXT, uci TEXT, fens TEXT, time TEXT, primary key (GAMEID), FOREIGN KEY (user) REFERENCES users(username));", NULL, 0, NULL);
    sqlite3_close(check_db);

    Database db = Database("./db");
    db.create_user("ansley", "ansley");
    return 0;
}