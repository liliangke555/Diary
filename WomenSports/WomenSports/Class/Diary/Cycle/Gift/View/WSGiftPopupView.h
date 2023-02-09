//
//  WSGiftPopupView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "MMPopupView.h"
#import "WSGetGiftListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface WSGiftPopupView : MMPopupView
@property (nonatomic, copy) void(^didSendGift)(WSGiftModel *giftModel);
@property (nonatomic, strong) NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
