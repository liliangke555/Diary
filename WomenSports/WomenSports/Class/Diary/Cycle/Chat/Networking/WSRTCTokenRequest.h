//
//  WSRTCTokenRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/3.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSRTCTokenRequest : BaseRequest
CopyStringProperty userId;
CopyStringProperty channelName;
CopyStringProperty type;
@end

@interface WSRTCTokenModel : NSObject
CopyStringProperty talkingId;
CopyStringProperty userId;
CopyStringProperty channelName;
CopyStringProperty role;
CopyStringProperty token;
CopyStringProperty privilegeExpiredTs;
@end

NS_ASSUME_NONNULL_END
