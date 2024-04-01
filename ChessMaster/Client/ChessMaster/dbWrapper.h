#import <Foundation/Foundation.h>

@interface dbWrapper : NSObject

- (instancetype)initWithTitle:(NSString *)title;
- (void)createUser:(NSString *)username password:(NSString *)password;
- (BOOL)checkUser:(NSString *)username password:(NSString *)password;
- (void)changePassword:(NSString *)newPassword;
- (void)deleteUser;
- (void)createGameWithTitle:(NSString *)title notes:(NSString *)notes uci:(NSString *)uci;
- (void)editNote:(NSString *)note;
- (NSArray<NSString *> *)retrieveGamesByTitle:(NSString *)title;
- (void)deleteGamesByUser;
- (void)deleteGamesById;
- (void)switchGame:(NSString *)title;
- (NSString *)testy;

@end
