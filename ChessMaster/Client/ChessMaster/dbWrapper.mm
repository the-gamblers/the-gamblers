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
    bool result = self.cppitem->check_user(std::string([username cStringUsingEncoding:NSUTF8StringEncoding]), std::string([password cStringUsingEncoding:NSUTF8StringEncoding]));
    return result;
}

- (void)changePassword:(NSString *)newPassword {
    self.cppitem->change_password(std::string([newPassword cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (void)deleteUser {
    self.cppitem->delete_user();
}

- (void)createGameWithTitle:(NSString *)title notes:(NSString *)notes uci:(NSString *)uci {
    self.cppitem->create_game(std::string([title cStringUsingEncoding:NSUTF8StringEncoding]), std::string([notes cStringUsingEncoding:NSUTF8StringEncoding]), std::string([uci cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (void)editNote:(NSString *)note {
    self.cppitem->edit_note(std::string([note cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (NSArray<NSString *> *)retrieveGamesByTitle:(NSString *)title {
    std::vector<std::string> games = self.cppitem->retrieve_games_by_title(std::string([title cStringUsingEncoding:NSUTF8StringEncoding]));
    
    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithCapacity:games.size()];
    for (const auto &game : games) {
        NSString *gameString = [NSString stringWithUTF8String:game.c_str()];
        [result addObject:gameString];
    }
    
    return result;

}

- (void)deleteGamesByUser {
    self.cppitem->delete_games_by_user();
}

- (void)deleteGamesById {
    self.cppitem->delete_games_by_id();
}

- (void)switchGame:(NSString *)title {
    self.cppitem->switch_game(std::string([title cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (NSString *)testy {
    return [NSString stringWithUTF8String:self.cppitem->testy().c_str()];
}

@end