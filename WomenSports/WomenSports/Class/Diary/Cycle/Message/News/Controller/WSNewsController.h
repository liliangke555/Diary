//
//  WSNewsController.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSNewsController : WSBaseController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void (^deleteConversationCompletion)(BOOL isDelete);
@property (nonatomic, copy) void (^reloadUnReadNum)(NSInteger num);
@end

NS_ASSUME_NONNULL_END
