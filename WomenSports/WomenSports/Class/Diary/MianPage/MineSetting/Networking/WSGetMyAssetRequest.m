//
//  WSGetMyAssetRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSGetMyAssetRequest.h"

@implementation WSGetMyAssetRequest
- (NSString *)uri {
    return @"users/getMyAsset";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetMyAssetModel class];
}
@end

@implementation WSGetMyAssetModel

@end
