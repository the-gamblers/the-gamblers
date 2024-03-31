#ifdef __cplusplus
extern "C" {
#endif

#include <sqlite3.h>
//#include <vector>
//#incude <string>

typedef struct {
    sqlite3 *db;
    char *curr_user;
    int curr_game;
    char *zErrMsg;
    char **buffer;
    int buffer_size;
} Database;

void database_init(Database *db, const char *name);
void database_destroy(Database *db);
void database_create_user(Database *db, const char *username, const char *password);
int database_check_user(Database *db, const char *username, const char *password);
void database_change_password(Database *db, const char *new_password);
void database_delete_user(Database *db);
void database_create_game(Database *db, const char *title, const char *notes, const char *uci);
void database_edit_note(Database *db, const char *note);
char **database_retrieve_games_by_title(Database *db, const char *title);
void database_delete_games_by_user(Database *db);
void database_delete_games_by_id(Database *db);
void database_switch_game(Database *db, const char *title);



#ifdef __cplusplus
}
#endif