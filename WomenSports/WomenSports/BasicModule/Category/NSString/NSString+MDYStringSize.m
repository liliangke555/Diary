//
//  NSString+MDYStringSize.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "NSString+MDYStringSize.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (MDYStringSize)
- (CGFloat)getLabelHeightWithWidth:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil]; return rect.size.height;
    
}
 
 
//根据高度度求宽度
 
- (CGFloat)getWidthWithHeight:(CGFloat)height font:(CGFloat)font
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil]; return rect.size.width;
    
}

- (CGFloat)getSpaceLabelHeightwithAttrDict:(NSMutableDictionary *)dict withWidth:(CGFloat)width {

    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size.height;
}
+ (NSString *)getExpectTimestamp:(NSInteger)year {
    NSDateComponents *comp = [self ddpGetExpectTimestamp:year month:0 day:0];
    return [NSString stringWithFormat:@"%ld年",comp.year + year];
}
+ (NSDateComponents *)ddpGetExpectTimestamp:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day {
 
    // 获取代表公历的NSCalendar对象
      NSCalendar *gregorian = [[NSCalendar alloc]
       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      // 获取当前日期
      NSDate* dt = [NSDate date];
    NSTimeInterval oneDay = 24*60*60*1;
    NSDate *theDate = [dt initWithTimeIntervalSinceNow:+oneDay*day];
      // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
      unsigned unitFlags = NSCalendarUnitYear |
       NSCalendarUnitMonth |  NSCalendarUnitDay |
       NSCalendarUnitHour |  NSCalendarUnitMinute |
       NSCalendarUnitSecond | NSCalendarUnitWeekday;
      // 获取不同时间字段的信息
      NSDateComponents* comp = [gregorian components: unitFlags
       fromDate:theDate];
    
    return comp;
}
+ (NSString *)dateToOld:(NSDate *)bornDate {
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

- (NSString *)changeHtmlString {
    
    NSString *content = [self stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
        content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-size:15px;}\n"
                           "</style> \n"
                           "</head> \n"
                           "<body>"
                           "<script type='text/javascript'>"
                           "window.onload = function(){\n"
                           "var $img = document.getElementsByTagName('img');\n"
                           "for(var p in  $img){\n"
                           " $img[p].style.width = '100%%';\n"
                           "$img[p].style.height ='auto'\n"
                           "}\n"
                           "}"
                           "</script>%@"
                           "</body>"
                           "</html>",content];
    
    return htmls;
}
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}
+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    
    double timeInterval = aTimeInterval;
    // judge if the argument is in secconds(for former data structure).
    if(aTimeInterval > 140000000000) {
        timeInterval = aTimeInterval / 1000;
    }
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8, 2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5, 2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0, 4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSTimeInterval ti = [aDate timeIntervalSinceDate:date];
      float fi = ti / 3600;
      if (ti < 0) {
          fi --;
      }
    NSInteger hour = fi;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *ret = @"";
    
    //If hasAMPM==TURE, use 12-hour clock, otherwise use 24-hour clock
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    NSString *string = @"";
    if (!hasAMPM) { //24-hour clock
        if (hour <= 24 && hour >= 0) {
            dateFormatter.dateFormat = @"HH:mm";
        } else if (hour < 0 && hour >= -24) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"yestorday ";
        } else {
            dateFormatter.dateFormat = @"MMMM dd";
        }
    } else {
        if (hour >= 0 && hour <= 6) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"beforedarw ";
        } else if (hour > 6 && hour <= 11 ) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"am ";
        } else if (hour > 11 && hour <= 17) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"pm ";
        } else if (hour > 17 && hour <= 24) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"night ";
        } else if (hour < 0 && hour >= -24) {
            dateFormatter.dateFormat = @"HH:mm";
            string = @"yestorday ";
        } else {
            dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
        }
    }
    
    ret = [dateFormatter stringFromDate:aDate];
    
    return [NSString stringWithFormat:@"%@%@",string,ret];
}
- (BOOL)isValidEmail {
    if (self == nil) {
        return NO;
    }
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        return NO;
    }
    NSString *string = @"^(([a-zA-Z0-9_-]+)|([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)))@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string];
    return [emailTest evaluateWithObject:self];
}
@end
