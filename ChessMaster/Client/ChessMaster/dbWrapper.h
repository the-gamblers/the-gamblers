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
- (void)deleteGamesById;
- (void)switchGame:(NSString *)title;
- (void)editFen:(NSString *)fen;
- (NSString *)testy;
- (NSArray<NSString *> *)getFen;
- (NSArray<NSString *> *)getUci;


@end
