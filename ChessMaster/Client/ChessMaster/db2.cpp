//
//  db2.cpp
//  ChessMaster
//
//  Created by Roee Belkin on 3/31/24.
//

#include "db2.hpp"
#include <iostream>

struct PW
{
    std::string password;
    bool result;
};

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
