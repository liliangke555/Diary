//
//  WSUploadFileRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "WSUploadFileRequest.h"

@implementation WSUploadFileRequest
- (NSString *)uri {
    return @"fupload/upload";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUploadFileModel class];
}
@end

@implementation WSUploadFileModel

@end
