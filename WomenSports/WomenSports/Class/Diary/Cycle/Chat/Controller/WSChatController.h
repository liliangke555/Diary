//
//  WSChatController.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/2.
//

#import "WSBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSChatController : WSBaseController
- (instancetype)initWithConversationId:(NSString *)conversationId conversationType:(EMConversationType)conType;
@end

NS_ASSUME_NONNULL_END
