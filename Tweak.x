#import <UIKit/UIKit.h>
#import "NotificationFaker.h"

#define NSLog(fmt, ...) NSLog((@"[InternalTest] " fmt), ##__VA_ARGS__)

@interface PLPlatterView : UIView
@end

@interface MTMaterialView : UIView
@property (assign,nonatomic) long long recipe;
@property (nonatomic,copy) NSString * recipeName;
@end

@interface NCNotificationRequest : NSObject
@property (nonatomic,copy,readonly) NSString * sectionIdentifier;
@end

@interface NCNotificationViewController : UIViewController
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;
@end

@interface NCNotificationShortLookView : UIView
@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView;
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic,readonly) UIView * viewForPreview;
@property (nonatomic,retain) UIView *borderView;
@property (nonatomic,retain) UIView *shadowView;
@end

@interface NCNotificationSeamlessContentView : UIView
@end

@interface LSBundleProxy
@property (nonatomic,readonly) NSURL * bundleURL;
@end

@interface LSApplicationProxy : LSBundleProxy
@property (nonatomic,readonly) NSString * applicationType;
@property (nonatomic,readonly) NSString * applicationIdentifier;
@property (getter=isRestricted,nonatomic,readonly) BOOL restricted;
@property (nonatomic,readonly) NSArray * appTags;
@property (getter=isLaunchProhibited,nonatomic,readonly) BOOL launchProhibited;
@property (getter=isPlaceholder,nonatomic,readonly) BOOL placeholder;
@property (getter=isRemovedSystemApp,nonatomic,readonly) BOOL removedSystemApp;
-(id)localizedNameForContext:(id)arg1 ;
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(id)allInstalledApplications;
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * displayName;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface CALayer (Private)
@property (assign) BOOL continuousCorners; 
@end

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"[InternalTest] " fmt), ##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;
%property (nonatomic,retain) UIView *shadowView;

// -(NCNotificationShortLookView *)viewForPreview {
//     NCNotificationShortLookView *orig = %orig;
//     MTMaterialView *materialView = orig.backgroundMaterialView;
    

//     return orig;
// }
-(void)viewDidLayoutSubviews {
    %orig;

    NSLog(@"Notification: %@", self.notificationRequest.sectionIdentifier);

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;
    MTMaterialView *materialView = view.backgroundMaterialView;

    if (materialView.frame.size.width == 0) return;

    NSLog(@"BorderView: %@", self.borderView);
    if (self.borderView == nil) {
        UIView *borderView = [[UIView alloc] initWithFrame:materialView.frame];
        borderView.layer.cornerRadius = materialView.layer.cornerRadius;
        borderView.layer.continuousCorners = YES;

        PLPlatterView *platterView = [view valueForKey:@"platterView"];
        [platterView insertSubview:borderView atIndex:1];

        self.borderView = borderView;
    }

    if (self.shadowView == nil) {
        UIView *shadowView = [[UIView alloc] initWithFrame:materialView.frame];
        shadowView.layer.cornerRadius = materialView.layer.cornerRadius;
        shadowView.layer.continuousCorners = YES;

        PLPlatterView *platterView = [view valueForKey:@"platterView"];
        [platterView insertSubview:shadowView atIndex:0];

        self.shadowView = shadowView;
    }

    self.borderView.frame = materialView.frame;
    self.shadowView.frame = materialView.frame;

    self.borderView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];

    // materialView.alpha = 0;
    // materialView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.3];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = materialView.frame;
    gradient.colors = @[(id)[UIColor colorWithRed: 0.35 green: 0.71 blue: 0.67 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.64 green: 0.80 blue: 0.50 alpha: 1.00].CGColor];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);

    CAShapeLayer *shapeLayer =[[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 3;
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:materialView.bounds cornerRadius:materialView.layer.cornerRadius].CGPath;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    gradient.mask = shapeLayer;

    self.borderView.layer.masksToBounds = YES;
    [self.borderView.layer insertSublayer:gradient atIndex:0];

    // materialView.layer.borderWidth = 1;
	// materialView.layer.borderColor = UIColor.greenColor.CGColor;

    // self.shadowView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
	// self.shadowView.layer.shadowOpacity = 1.0;
	// self.shadowView.layer.shadowOffset = CGSizeZero;
	// self.shadowView.layer.shadowRadius = 3;
	// self.shadowView.layer.shadowColor = UIColor.greenColor.CGColor;
    // self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:materialView.bounds cornerRadius:materialView.layer.cornerRadius].CGPath;

    // NCNotificationSeamlessContentView *contentView = [view valueForKey:@"notificationContentView"];
    // UILabel *title = [contentView valueForKey:@"primaryTextLabel"];
    // title.textColor = UIColor.cyanColor;

    // NSLog(@"Was: %f", title.frame.origin.y);
    // CGRect frame = title.frame;
    // frame.origin.y += 20;
    // title.frame = frame;
    // NSLog(@"Now: %f", title.frame.origin.y);

    // UILabel *message = [contentView valueForKey:@"secondaryTextElement"];
    // message.textColor = UIColor.redColor;
    // message.textAlignment = NSTextAlignmentCenter;

    // UILabel *dateLabel = [contentView valueForKey:@"dateLabel"];
    // dateLabel.textColor = UIColor.redColor;
    // dateLabel.layer.filters = nil;
}
%end

%ctor {
    %init;

    // ========== TODO ============== //

    // - Border one side
    // - Different indicator (dots, line, etc)
    // - App Icon Size
    // - App Icon Corner Radius
    // - Force Dark/Light Mode
    // - Gradient background/border?
    // - Set effects not on materialView so we can hide it
    // - Per-App settings maybe schmaybe?

    // ========== END ============== //
    // <OS_dispatch_queue_serial: com.apple.UserNotificationsUI.BulletinNotificationSource>
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        // [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Velvet Notification"
        //                                                     message:@"Test notification"
        //                                                     bundleID:@"com.apple.mobilecal"];
		// NSMutableDictionary *installedApps = [[NSMutableDictionary alloc] init];

        // NSArray *apps = [[%c(LSApplicationWorkspace) defaultWorkspace] allInstalledApplications];
        // for (LSApplicationProxy *app in apps) {
        //     if ([app.applicationType isEqual:@"User"] ||
        //         (
        //             [app.applicationType isEqual:@"System"] &&
        //             ![app.appTags containsObject:@"hidden"] &&
        //             !app.launchProhibited &&
        //             !app.placeholder &&
        //             !app.removedSystemApp
        //         )
        //     ) {
        //         [installedApps setObject:[app localizedNameForContext:nil] forKey:app.applicationIdentifier];
        //     }
        // }

        // NSArray *bundleIds = [installedApps allKeys];
        // for (int i = 0; i < 5; i++) {
        //     NSString *bundleId = [bundleIds objectAtIndex:(arc4random()%[bundleIds count])];
        //     NSString *appName = installedApps[bundleId];
        //     NSLog(@"%@", appName);

        //     if (i == 4) {
        //         [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Velvet Notification"
        //                                                     message:[NSString stringWithFormat:@"This is a second notification for %@", appName]
        //                                                     bundleID:bundleId];
        //     }

        //     [[%c(NotificationFaker) sharedInstance] showNotificationWithTitle:@"Velvet Notification"
        //                                                     message:[NSString stringWithFormat:@"This is a test notification for %@", appName]
        //                                                     bundleID:bundleId];

        // }
	});
}