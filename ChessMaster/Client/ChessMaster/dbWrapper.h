#import <Foundation/Foundation.h>

@interface dbWrapper : NSObject

- (instancetype)initWithTitle:(NSString *)title;
- (void)createUser:(NSString *)username password:(NSString *)password;
- (BOOL)checkUser:(NSString *)username password:(NSString *)password;
- (void)changePassword:(NSString *)newPassword;
- (void)deleteUser;
- (void)createGameWithTitle:(NSString *)title notes:(NSString *)notes uci:(NSString *)uci fen:(NSString *)fen;
- (void)editNote:(NSString *)note;
- (void)editTitle:(NSString *)title;
- (NSArray<NSString *> *)retrieveGamesByTitle:(NSString *)title;
- (NSArray<NSString *> *)retrieveGamesByUser;
- (void)deleteGamesByUser;
//- (void)deleteGamesById;
- (void)deleteGamesById:(NSString *)gameid;
- (void)switchGame:(NSString *)title;
- (NSString *)testy;
- (void)recordGameResultForUser:(NSString *)username result:(NSString *)result;
- (NSInteger)getTotalGames:(NSString *)username;
- (NSDictionary *)getUserStats:(NSString *)username;
- (NSArray<NSString *> *)getFen:(NSInteger)gameid;
- (NSArray<NSString *> *)getUci:(NSInteger)gameid;

@end
