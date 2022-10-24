typedef struct CCUILayoutSize {
    NSUInteger width;
    NSUInteger height;
} CCUILayoutSize;

struct CCUILayoutSize CCUILayoutSizeMake2(NSUInteger width, NSUInteger height) {
    CCUILayoutSize layoutSize;
    layoutSize.width = width;
    layoutSize.height = height;
    return layoutSize;
}

@interface CCUIModuleSettings : NSObject {
	CCUILayoutSize _portraitLayoutSize;
	CCUILayoutSize _landscapeLayoutSize;
}
-(BOOL)isEqual:(id)arg1 ;
-(CCUILayoutSize)layoutSizeForInterfaceOrientation:(NSInteger)orientation;
-(id)initWithPortraitLayoutSize:(CCUILayoutSize)portraitSize landscapeLayoutSize:(CCUILayoutSize)landscapeSize;
@end