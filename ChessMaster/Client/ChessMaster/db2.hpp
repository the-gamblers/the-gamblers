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


class Database {
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
    std::string testy();
    
};
#endif /* db2_hpp */
