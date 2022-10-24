#import <Foundation/Foundation.h>
#import "NotificationFaker.h"
#import "BulletinBoard.h"
#import "UserNotificationsUIKit.h"

#define NSLog(fmt, ...) NSLog((@"[NotificationFaker] " fmt), ##__VA_ARGS__)

@interface SBNCNotificationDispatcher : NSObject
@property (nonatomic,readonly) NCBulletinNotificationSource *notificationSource;
@end

@interface SpringBoard
@property (nonatomic,readonly) SBNCNotificationDispatcher * notificationDispatcher;
@end

@interface UIResponder : NSObject
@end

@interface UIApplication : UIResponder
+(id)sharedApplication;
@end

@implementation NotificationFaker
+ (instancetype)sharedInstance {
    static NotificationFaker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NotificationFaker alloc] init];
    });
    return sharedInstance;
}

-(void)showNotificationWithTitle:(NSString*)title message:(NSString*)message bundleID:(NSString*)bundleID {
    BBBulletin *request = [NSClassFromString(@"BBBulletin") new];

    NSDate *date = [NSDate date];

    request.section = bundleID;
	request.sectionID = bundleID;
    request.sectionBundlePath = @"/System/Library/UserNotifications/Bundles/com.apple.mobilecal.bundle";
	request.bulletinID = [self newUUID];
	request.bulletinVersionID = [self newUUID];
	request.publisherBulletinID = [NSString stringWithFormat:@"notification.faker/%@", [self newUUID]];
    request.recordID = request.publisherBulletinID;
    request.categoryID = @"NotificationFaker";
	request.title = title;
	request.message = message;
	request.date = date;
    request.publicationDate = date;
	request.lastInterruptDate = date;
    request.contentType = @"BBBulletinContentTypeDefault";
	request.clearable = YES;
    request.interruptionLevel = 1;

    BBAction *defaultAction = [NSClassFromString(@"BBAction") actionWithIdentifier:@"com.apple.UNNotificationDefaultActionIdentifier"];
	request.defaultAction = defaultAction;

    SpringBoard *springBoard = [UIApplication sharedApplication];
    NCBulletinNotificationSource *source = [springBoard.notificationDispatcher notificationSource];
    BBObserver *observer = source.observer;

    [source observer:observer addBulletin:request forFeed:1];
}

-(NSString *)newUUID {
	NSUUID *uuid = [NSUUID UUID];
    return [uuid UUIDString];
}
@end
