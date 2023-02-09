//
//  WSSingleCache.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import <Foundation/Foundation.h>
#import "WSUserModel.h"
NS_ASSUME_NONNULL_BEGIN

#define kUser [WSSingleCache shareSingleCache].userModel
@interface WSSingleCache : NSObject
//创建单例对象
+ (instancetype)shareSingleCache;
+ (void)clean;
- (BOOL)checkLoginState;

/**
 * 当前用户
 */
@property (nonatomic, strong, nullable) WSUserModel *userModel;

@property (nonatomic, copy) NSString *token;
@end

NS_ASSUME_NONNULL_END
