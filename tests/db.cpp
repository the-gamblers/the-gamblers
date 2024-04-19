#include "db.hpp"
#include <iostream>
#include <cstring>
#include <regex>
#include <iterator>
#include <ctime>

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

static int write_data(void *data, int num_cols, char **col_vals, char **col_names)
{
    std::vector<std::string> *buf = static_cast<std::vector<std::string> *>(data);

    for (int i = 0; i < num_cols; i++)
    {
        buf->push_back(col_vals[i] ? std::string(col_vals[i]) : "NULL");
    }

    return 0;
}

// ------------------------------------ DATABASE ------------------------------------

Database::Database(std::string name) : db(nullptr), curr_user(""), curr_game(-1), zErrMsg(nullptr), buffer({})
{
    if (sqlite3_open((name + ".sqlite").c_str(), &db) != SQLITE_OK)
    {
        std::cout << "ERROR: database not open" << std::endl;
        std::cout << sqlite3_open((name + ".sqlite").c_str(), &db) << std::endl;
        return;
    }

    // sqlite3_exec(db, "DROP TABLE games;", NULL, 0, NULL);


    // sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS users(username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, wins INTEGER, losses INTEGER, draws INTEGER, primary key (username));", NULL, 0, NULL);
    // sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS games(GAMEID INTEGER, user TEXT NOT NULL, date DATETIME DEFAULT CURRENT_DATE, title TEXT, notes TEXT, uci TEXT, fens TEXT, time TEXT, primary key (GAMEID), FOREIGN KEY (user) REFERENCES users(username));", NULL, 0, NULL);
    // sqlite3_exec(db, "ALTER TABLE games ADD COLUMN fens TEXT", NULL, 0, &zErrMsg);
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
    std::cout << query << std::endl;
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    if (rc != SQLITE_OK)
        std::cerr << "ERROR: " << zErrMsg << std::endl;
}

std::vector<std::string> Database::get_all_users()
{
    buffer = {};
    std::string query = ("SELECT * FROM users");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }
    return buffer;
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

// this is called when someone starts a game
void Database::create_game(std::string title = "", std::string notes = "", std::string uci = "", std::string fen = "")
{
    if (title.empty())
    {
        std::time_t now = std::time(nullptr);
        char buff[80];
        std::strftime(buff, sizeof(buff), "%Y-%m-%d %H:%M:%S", std::localtime(&now));
        std::string currentDateTime(buff);
        title = currentDateTime;
    }
    std::string query = ("INSERT INTO games (user, title, notes, uci, fens) VALUES ('" + curr_user + "', '" + title + "', '" + notes + "', '" + uci + "', '" + fen + "')");
    int rc = sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);

    // switch curr_game to the game being played
    switch_game(title);

    if (rc != SQLITE_OK)
        std::cerr
            << "ERROR: " << zErrMsg << std::endl;
}

void Database::edit_title(std::string title)
{
    std::string query = ("UPDATE games SET title = '" + title + "' WHERE GAMEID = '" + std::to_string(curr_game) + "'");
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
    buffer = {};
    std::string query = ("SELECT * FROM games WHERE title = '" + title + "' AND user = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }
    return buffer;
}

std::vector<std::string> Database::retrieve_games_by_user()
{
    buffer = {};
    std::string query = ("SELECT * FROM games WHERE user = '" + curr_user + "'");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }
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

void Database::edit_fen(std::string fen)
{
    buffer = {};
    std::string query = ("UPDATE games SET fen = '" + fen + "' WHERE GAMEID = '" + std::to_string(curr_game) + "'");
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
    }
}

void Database::record_game_result(std::string username, std::string result)
{
    std::string query = "UPDATE users SET ";
    if (result == "win")
    {
        query += "wins = wins + 1";
    }
    else if (result == "loss")
    {
        query += "losses = losses + 1";
    }
    else if (result == "draw")
    {
        query += "draws = draws + 1";
    }
    query += " WHERE username = '" + username + "';";
    sqlite3_exec(db, query.c_str(), NULL, 0, &zErrMsg);
}

std::tuple<int, int, int, int> Database::get_user_stats(std::string username)
{
    std::string query = "SELECT wins, losses, draws FROM users WHERE username = '" + username + "';";
    return std::make_tuple(0, 0, 0, 0);
}

std::vector<std::string> Database::get_fen(int gameid = -1)
{
    buffer = {};
    gameid = gameid == -1 ? curr_game : gameid;
    std::string query = ("SELECT fens FROM games WHERE GAMEID = " + std::to_string(gameid));

    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }

    // replace column title, only get fen between commas
    std::string fenstr = buffer.at(0);

    std::vector<std::string> res = {};
    std::regex pattern("(.*?),");
    auto bufStart = std::sregex_iterator(fenstr.begin(), fenstr.end(), pattern);
    auto bufEnd = std::sregex_iterator();

    for (std::sregex_iterator i = bufStart; i != bufEnd; i++)
    {
        std::smatch match = *i;
        res.push_back(match[1].str());
    }

    return res;
}

std::vector<std::string> Database::get_uci(int gameid = -1)
{
    buffer = {};
    gameid = gameid == -1 ? curr_game : gameid;
    std::string query = ("SELECT uci FROM games WHERE GAMEID = " + std::to_string(gameid));
    int rc = sqlite3_exec(db, query.c_str(), write_data, &buffer, &zErrMsg);

    if (rc != SQLITE_OK)
    {
        std::cerr << "ERROR: " << zErrMsg << std::endl;
        return {};
    }

    std::string ucistr = buffer.at(0);
    std::vector<std::string> res = {};
    std::regex pattern("[a-h][1-8][a-h][1-8][q]?");
    auto bufStart = std::sregex_iterator(ucistr.begin(), ucistr.end(), pattern);
    auto bufEnd = std::sregex_iterator();

    for (std::sregex_iterator i = bufStart; i != bufEnd; i++)
    {
        std::smatch match = *i;
        res.push_back(match[0].str());
    }

    return res;
}

std::string Database::test() {
    return "Hello";
}