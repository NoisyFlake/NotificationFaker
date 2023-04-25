#import <Foundation/Foundation.h>
#import <dlfcn.h>

#define NSLog(fmt, ...) NSLog((@"[InternalTest] " fmt), ##__VA_ARGS__)

@interface BBObserver : NSObject
@end

@interface BBAction : NSObject
+(id)actionWithIdentifier:(id)identifier;
@end

@interface BBBulletin : NSObject
@property (nonatomic,copy) NSString * section; 
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,copy) NSString * bulletinVersionID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,copy) NSString * publisherBulletinID;
@property (nonatomic,copy) NSString * categoryID;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDate * publicationDate;
@property (assign,nonatomic) BOOL clearable;
@property (nonatomic,copy) BBAction * defaultAction;
-(void)addObserver:(id)arg1;
@end

@interface BBServer : NSObject
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2 ;
@end

@interface NotificationFaker : NSObject
+ (instancetype)sharedInstance;
-(void)showNotificationWithTitle:(NSString*)title message:(NSString*)message bundleID:(NSString*)bundleID;
-(NSString *)newUUID;
@end