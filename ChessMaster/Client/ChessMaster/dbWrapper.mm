//
//  dbWrapper.m
//  ChessMaster
//
//  Created by Roee Belkin on 3/31/24.
//

#import <Foundation/Foundation.h>
#import "dbWrapper.h"
#import "db2.hpp"
#import <sqlite3.h> // Include SQLite3 header if needed

@interface dbWrapper()
@property Database * cppitem;
@end

@implementation dbWrapper

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]){
        self.cppitem = new Database(std::string([title cStringUsingEncoding:NSUTF8StringEncoding]));
    }
    return self;
}

- (void)createUser:(NSString *)username password:(NSString *)password {
    self.cppitem->create_user(std::string([username cStringUsingEncoding:NSUTF8StringEncoding]), std::string([password cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (BOOL)checkUser:(NSString *)username password:(NSString *)password {
    return [_database check_user:username password:password];
}

- (void)changePassword:(NSString *)newPassword {
    [_database change_password:newPassword];
}

- (void)deleteUser {
    [_database delete_user];
}

- (void)createGameWithTitle:(NSString *)title notes:(NSString *)notes uci:(NSString *)uci {
    [_database create_game:title notes:notes uci:uci];
}

- (void)editNote:(NSString *)note {
    [_database edit_note:note];
}

- (NSArray<NSString *> *)retrieveGamesByTitle:(NSString *)title {
    return [_database retrieve_games_by_title:title];
}

- (void)deleteGamesByUser {
    [_database delete_games_by_user];
}

- (void)deleteGamesById {
    [_database delete_games_by_id];
}

- (void)switchGame:(NSString *)title {
    [_database switch_game:title];
}

@end
