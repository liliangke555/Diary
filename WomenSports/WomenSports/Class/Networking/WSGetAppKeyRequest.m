//
//  WSGetAppKeyRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSGetAppKeyRequest.h"

@implementation WSGetAppKeyRequest
- (NSString *)uri {
    return @"config/getCToken";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetAppKeyModel class];
}
@end

@implementation WSGetAppKeyModel
- (void)setCustomJson:(NSString *)customJson {
    _customJson = customJson;
    if (customJson) {
        NSData *jsonData = [customJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        self.emKey = dic[@"emKey"];
        self.agKey = dic[@"agKey"];
    }
}
@end
