//
//  db2.hpp
//  ChessMaster
//
//  Created by Roee Belkin on 3/31/24.
//

#ifndef db2_hpp
#define db2_hpp

#include <stdio.h>
#include <string>
#include <sqlite3.h>
#include <vector>

class Database
{
private:
    sqlite3 *db;
    std::string curr_user;
    int curr_game;
    char *zErrMsg;
    std::vector<std::string> buffer;

public:
    Database(std::string name);
    ~Database();
    void create_user(std::string username, std::string password);
    bool check_user(std::string username, std::string password);
    void change_password(std::string new_password);
    void delete_user();
    void create_game(std::string title, std::string notes, std::string uci, std::string fen);
    void edit_title(std::string title);
    void edit_note(std::string note);
    std::vector<std::string> retrieve_games_by_title(std::string title);
    std::vector<std::string> retrieve_games_by_user();
    void delete_games_by_user();
    void delete_games_by_id();
    void switch_game(std::string title);
    void edit_fen(std::string fen);
    std::vector<std::string> get_fen();
    std::vector<std::string> get_uci();
};
#endif /* db2_hpp */
