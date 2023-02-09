//
//  NSString+MDYStringSize.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MDYStringSize)
- (CGFloat)getLabelHeightWithWidth:(CGFloat)width font: (CGFloat)font;

- (CGFloat)getWidthWithHeight:(CGFloat)height font:(CGFloat)font;
- (CGFloat)getSpaceLabelHeightwithAttrDict:(NSMutableDictionary *)dict withWidth:(CGFloat)width;
- (NSString *)changeHtmlString;
+ (NSString *)getExpectTimestamp:(NSInteger)year;
+ (NSDateComponents *)ddpGetExpectTimestamp:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSString *)dateToOld:(NSDate *)bornDate;
+ (NSString *)getUUID;
+(NSString *)MD5ForLower32Bate:(NSString *)str;
+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval;
- (BOOL)isValidEmail;
@end

NS_ASSUME_NONNULL_END
