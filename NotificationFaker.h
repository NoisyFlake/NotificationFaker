@interface NotificationFaker : NSObject
+ (instancetype)sharedInstance;
-(void)showNotificationWithTitle:(NSString*)title message:(NSString*)message bundleID:(NSString*)bundleID;
-(NSString *)newUUID;
@end