@interface NCBulletinNotificationSource : NSObject
@property (nonatomic,retain) BBObserver * observer;
-(void)observer:(id)observer addBulletin:(id)bulletin forFeed:(unsigned long long)feed playLightsAndSirens:(BOOL)lightsAndSirens withReply:(/*^block*/id)reply;
-(void)observer:(id)observer addBulletin:(id)bulletin forFeed:(unsigned long long)feed;
@end