//
//  WSPersonPageController.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSPersonPController : WSBaseController
@property (nonatomic, assign, getter=isMienPage) BOOL mienPage;
@property (nonatomic, copy) NSString *userIdString;
@end

NS_ASSUME_NONNULL_END
