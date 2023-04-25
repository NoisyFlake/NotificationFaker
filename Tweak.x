#import "Headers.h"

static BBServer *notificationserver = nil;

static dispatch_queue_t getBBServerQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        void *handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) {
                queue = *pointer;
            }
            dlclose(handle);
        }
    });
    return queue;
}

%hook BBServer
-(id)initWithQueue:(id)arg1 {
    notificationserver = %orig;
    return notificationserver;
}
%end

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
	request.bulletinID = [self newUUID];
	request.bulletinVersionID = [self newUUID];
	request.publisherBulletinID = [self newUUID];
    request.recordID = [self newUUID];
	request.title = title;
	request.message = message;
	request.date = date;
    request.publicationDate = date;
	request.clearable = YES;

    BBAction *defaultAction = [NSClassFromString(@"BBAction") actionWithIdentifier:@"com.apple.UNNotificationDefaultActionIdentifier"];
	request.defaultAction = defaultAction;

    dispatch_sync(getBBServerQueue(), ^{
        [notificationserver publishBulletin:request destinations:14];
    });
}

-(NSString *)newUUID {
	NSUUID *uuid = [NSUUID UUID];
    return [uuid UUIDString];
}
@end

%ctor {
    %init;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Home"  message:@"It's time to turn the lights on" bundleID:@"com.apple.Home"];
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"iTunes Store"  message:@"There might or might not be a new release by your favorite artist" bundleID:@"com.apple.MobileStore"];
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Discord"  message:@"@everyone: iOS 16 JB eta wen?" bundleID:@"com.hammerandchisel.discord"];
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Sileo"  message:@"An update for Velvet is available" bundleID:@"org.coolstar.SileoStore"];
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Messages"  message:@"This is another test notification" bundleID:@"com.apple.MobileSMS"];
        [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Tim Cook"  message:@"Sorry again about stealing your notification design, I was desperate." bundleID:@"com.apple.MobileSMS"];
	});
}