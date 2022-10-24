@interface BBObserver : NSObject
@end

@interface BBAction : NSObject
+(id)actionWithIdentifier:(id)identifier;
@end

@interface BBBulletin : NSObject
@property (nonatomic,copy) NSString * section; 
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) NSString * sectionBundlePath;
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
@property (nonatomic,retain) NSDate * lastInterruptDate;
@property (nonatomic,copy) NSString * contentType;
@property (assign,nonatomic) BOOL clearable;
@property (nonatomic,copy) BBAction * defaultAction;
@property (assign,nonatomic) unsigned long long interruptionLevel;
-(void)addObserver:(id)arg1;
@end

@interface BBBulletinRequest : BBBulletin
@end