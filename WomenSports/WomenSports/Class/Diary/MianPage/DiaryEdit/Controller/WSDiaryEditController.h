//
//  WSDiaryEditController.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSBaseImageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSDiaryEditController : WSBaseImageController
@property (nonatomic, strong) WSDiaryAddOrEditRequest *saveRequest;
@property (nonatomic, copy) void(^didReloadList)(void);
@end

NS_ASSUME_NONNULL_END
