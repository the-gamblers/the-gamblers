#include "db.h"
#include <iostream>
#include <cstring>

struct PW
{
    std::string password;
    bool result;
};

// struct Game {

// }

static int print_data(void *data, int num_cols, char **col_vals, char **col_names)
{
    std::cout << "print_data" << std::endl;
    for (int i = 0; i < num_cols; i++)
    {
        std::cout << col_names[i] << ": " << (col_vals[i] ? col_vals[i] : "NULL") << " ";
    }
    return 0;
}

static int check_password(void *data, int num_cols, char **col_vals, char **col_names)
{
    if (num_cols > 0)
    {
        const char *storedPassword = col_vals[0];
        PW *givenPassword = static_cast<PW *>(data);

        std::cout << storedPassword << std::endl;
        std::cout << givenPassword->password << std::endl;

        if (storedPassword == givenPassword->password)
            givenPassword->result = true;
        else
            givenPassword->result = false;
    }

    return 0;
}

static int return_int(void *data, int num_cols, char **col_vals, char **col_names)
{
    int *res = static_cast<int *>(data);
    if (num_cols > 0)
        *res = std::stoi(col_vals[0]);

    return 0;
}

// FIXME: makes more sense to be vect<list[string]> bc the list will be static
static int write_data(void *data, int num_cols, char **col_vals, char **col_names)
{
    // std::vector<std::list<std::string>> *buf = static_cast<std::vector<std::list<std::string>> *>(data);
    std::vector<std::string> *buf = static_cast<std::vector<std::string> *>(data);

    for (int i = 0; i < num_cols; i++)
    {

        // std::list<std::string> temp = {col_vals[i]};

        // buf->push_back(temp);
        buf->push_back(std::string(col_names[i]) + ": " + (col_vals[i] ? std::string(col_vals[i]) : "NULL") + " ");
    }

    return 0;
}

// ------------------------------------ DATABASE ------------------------------------

Database::Database(std::string name) : db(nullptr), curr_user(""), curr_game(-1), zErrMsg(nullptr), buffer({})
{
    if (sqlite3_open((name + ".sqlite").c_str(), &db) != SQLITE_OK)
    {
        std::cout << "ERROR: database not open" << std::endl;
        return;
    }

    // sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS users(username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, primary key (username));", NULL, 0, NULL);
    // sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS games(GAMEID INTEGER, user TEXT NOT NULL, date DATETIME DEFAULT CURRENT_DATE, title TEXT, notes TEXT, uci TEXT, primary key (GAMEID), FOREIGN KEY (user) REFERENCES users(username));", NULL, 0, NULL);
    std::cout << "DATABASE OPEN!" << std::endl;
}

Database::~Database()
{
    sqlite3_close(db);
    std::cout << "DATABASE CLOSED!" << std::endl;
}

void Database::create_user(std::string username, std::string password)
{
    // const char *query = "SELECT * FROM sqlite_master;";
    std::string query = ("INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "');");
    // std::cout << query << std::endl;
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

// call during login process
bool Database::check_user(std::string username, std::string password)
{
    PW pw;
    pw.password = password;
    std::string query = ("SELECT password FROM users WHERE username = '" + username + "';");
    int rc = sqlite3_exec(db, query.c_str(), check_password, &pw, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR in check_user: " << zErrMsg << std::endl;

    if (pw.result)
        curr_user = username;

    return pw.result;
}

void Database::change_password(std::string new_password)
{
    if (curr_user != "")
    {
        std::string query = ("UPDATE users SET password = '" + new_password + "' WHERE username = '" + curr_user + "'");
        int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

        if (rc != SQLITE_OK)
            std::cerr << "ERROR: " << zErrMsg << std::endl;
    }
}

void Database::delete_user()
{
    delete_games_by_user();
    std::string query = ("DELETE FROM users WHERE username = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

void Database::create_game(std::string title = "", std::string notes = "", std::string uci = "")
{
    std::string query = ("INSERT INTO games (user, title, notes, uci) VALUES ('" + curr_user + "', '" + title + "', '" + notes + "', '" + uci + "')");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

void Database::edit_note(std::string note)
{
    std::string query = ("UPDATE games SET notes = '" + note + "' WHERE GAMEID = '" + std::to_string(curr_game) + "'");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

std::vector<std::string> Database::retrieve_games_by_title(std::string title)
{
    std::string query = ("SELECT * FROM games WHERE title = '" + title + "' AND user = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }

    for (auto a : buffer)
        std::cout << a << std::endl;
    return buffer;
}

std::vector<std::string> Database::retrieve_games_by_user(std::string title)
{
    std::string query = ("SELECT * FROM games WHERE user = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }

    for (auto a : buffer)
        std::cout << a << std::endl;
    return buffer;
}

void Database::delete_games_by_user()
{
    std::string query = ("DELETE FROM games WHERE user = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

void Database::delete_games_by_id()
{
    std::string query = ("DELETE FROM games WHERE GAMEID = '" + std::to_string(curr_game) + "'");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

// switch current game and get new id to grab data from
void Database::switch_game(std::string title)
{
    int temp = 1;
    int *id = &temp;
    std::string query = ("SELECT GAMEID FROM games WHERE title = '" + title + "'");
    int rc = sqlite3_exec(db, query.c_str(), return_int, id, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
    curr_game = *id;
}

int main(int argc, char **argv)
{
    Database db = Database("test");

    std::cout << "valid user? " << db.check_user("jim", "halpert") << std::endl;

    db.retrieve_games_by_title("game3");
    db.switch_game("game4");
    std::cout << "before edit note" << std::endl;
    db.edit_note("howdy");
}
