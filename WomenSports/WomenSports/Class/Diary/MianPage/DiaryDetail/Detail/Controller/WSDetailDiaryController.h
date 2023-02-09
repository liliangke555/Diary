//
//  WSDetailDiaryController.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/15.
//

#import "WSBaseController.h"
#import "WSDiaryFindRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSDetailDiaryController : WSBaseController
@property (nonatomic, strong) WSDiaryDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
