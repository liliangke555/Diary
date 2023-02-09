//
//  WSUserModel.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSUserModel : NSObject
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *anchorRate;
@property (nonatomic, copy) NSString *brokerRate;
@property (nonatomic, copy) NSString *brokerType;
@property (nonatomic, copy) NSString *chatStatus;

@property (nonatomic, copy) NSString *commissionAmount;
@property (nonatomic, copy) NSString *easemobStatus;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *followerNumber;
@property (nonatomic, copy) NSString *followingNumber;

@property (nonatomic, copy) NSString *freeNumber;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *likesNumber;

@property (nonatomic, copy) NSString *userGold;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *profileStatus;
@property (nonatomic, copy) NSString *rechargeStatus;
@property (nonatomic, copy) NSString *reviewScore;

@property (nonatomic, copy) NSString *subscribStatus;
@property (nonatomic, copy) NSString *talkingGoldPerMin;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *changeHeaderUrl;
@property (nonatomic, copy) NSString *changeName;

@property (nonatomic, copy) NSString *anonymousHeaderUrl;
@property (nonatomic, copy) NSString *anonymousName;

@property (nonatomic, copy) NSString *headerUrl;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
