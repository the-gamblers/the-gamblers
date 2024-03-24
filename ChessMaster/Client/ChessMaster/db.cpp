#include "db.h"
#include <iostream>

static int print_data(void *data, int num_cols, char **col_vals, char **col_names)
{
    for (int i = 0; i < num_cols; i++)
    {
        std::cout << col_names[i] << ": " << (col_vals[i] ? col_vals[i] : "NULL") << " ";
    }
    std::cout << std::endl;
    return 0;
}

// static int return_bool(void *data, int num_cols, char **col_vals, char **col_names)
// {
//     if (num_cols > 0)
//     {
//         const char *storedPassword = col_vals[0];
//         const char *givenPassword = static_cast<const char *>(data);

//         if (storedPassword == givenPassword && strcmp(storedPassword, givenPassword) == 0)
//             return true;
//     }

//     return false;
// }

// Database::Database(std::string name)
// {
//     curr_user = "";
//     curr_game = "";
//     if (sqlite3_open((name + ".sqlite").c_str(), &db) != SQLITE_OK)
//         std::cout << "ERROR: database not open" << std::endl;
// }
// Database::~Database()
// {
//     sqlite3_close(db);
// }
// void Database::create_user(std::string username, std::string password)
// {
//     const char *query = ("INSERT INTO users (username, password) VALUES ('" + username + "', '" + password + "')").c_str();
//     sqlite3_exec(db, query, NULL, 0, &zErrMsg);
// }

// // call during login process
// bool Database::check_user(std::string username, std::string password)
// {
//     bool *result = false;
//     const char *query = ("SELECT password FROM users WHERE username = '" + username).c_str();
//     sqlite3_exec(db, query, return_bool, &result, &zErrMsg);
//     if (&result)
//         curr_user = username;
//     return &result;
// }

// void Database::change_password(std::string new_password)
// {
//     const char *query = ("UPDATE users SET password = '" + new_password + "' WHERE username = '" + curr_user + "'").c_str();
//     sqlite3_exec(db, query, NULL, 0, &zErrMsg);
// }

// void Database::delete_user()
// {
//     const char *query = ("DELETE FROM users WHERE username = '" + curr_user + "'").c_str();
//     sqlite3_exec(db, query, NULL, 0, &zErrMsg);
// }

// void Database::create_game(std::string title = NULL, std::string notes = NULL, std::string uci = NULL)
// {
//     const char *query = ("INSERT INTO games (user, title, notes, uci) VALUES ('" + curr_user + "', '" + title + "', '" + notes + "', '" + uci + "')").c_str();
//     sqlite3_exec(db, query, NULL, 0, &zErrMsg);
// }
// void Database::edit_note(int gameID, std::string note)
// {
//     const char *query = ("UPDATE games SET notes = '" + note + "' WHERE GAMEID = '" + gameID + "'").c_str();
//     sqlite3_exec(db, query, NULL, 0, &zErrMsg);
// }
// std::vector<std::string> Database::retrieve_games_by_title(std::string title);
// void Database::delete_games_by_user();
// void Database::delete_games_by_id(int gameID);
// switch current game and get new id to grab data from
// void switch_game(std::string title);

// void start_app()

int main(int argc, char **argv)
{
    std::cout << "Hello, world!" << std::endl;
    sqlite3 *db;
    char *zErrMsg = 0;

    if (sqlite3_open("test.sqlite", &db) == SQLITE_OK)
        std::cout
            << "db open!" << std::endl;
    else
        std::cout << "db not open:(" << std::endl;

    std::cout << sqlite3_exec(db, "SELECT * FROM games WHERE user = 'ansley'", print_data, 0, &zErrMsg) << std::endl;
    sqlite3_close(db);
}
