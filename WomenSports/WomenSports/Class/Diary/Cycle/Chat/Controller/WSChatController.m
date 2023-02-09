//
//  WSChatController.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/2.
//

#import "WSChatController.h"
#import "EMUserDataModel.h"
#import "WSPersonPController.h"
#import <EaseCallUIKit.h>
#import "WSRTCTokenRequest.h"
#import "AppDelegate.h"
#import "WSSheetView.h"
#import "WSAddBlacklistRequest.h"
#import "WSBlackListRepoRequest.h"

@interface WSChatController ()<EaseChatViewControllerDelegate>
@property (nonatomic, strong) EaseConversationModel *conversationModel;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) EaseChatViewController *chatController;
@property (nonatomic, strong) NSString *moreMsgId;  //第一条消息的消息id
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation WSChatController
- (instancetype)initWithConversationId:(NSString *)conversationId conversationType:(EMConversationType)conType {
    if (self = [super init]) {
        _conversation = [EMClient.sharedClient.chatManager getConversation:conversationId type:conType createIfNotExist:YES];
        _conversationModel = [[EaseConversationModel alloc] initWithConversation:_conversation];
        
        EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init];
        [viewModel setChatViewBgColor:UIColor.whiteColor];
        [viewModel setChatBarBgColor:UIColor.whiteColor];
        [viewModel setMsgTimeItemBgColor:UIColor.whiteColor];
        [viewModel setMsgTimeItemFontColor:[UIColor k_colorWithHex:0xC6C6C6FF]];
        [viewModel setAvatarStyle:RoundedCorner];
        [viewModel setAvatarCornerRadius:20];
        [viewModel setContentFontSize:14];
        [viewModel setContentSendFontColor:K_BlackColor];
        [viewModel setContentFontColor:UIColor.whiteColor];
        [viewModel setBubbleBgEdgeInset:UIEdgeInsetsMake(18, 18, 18, 18)];
        [viewModel setSendBubbleBgPicture:[UIImage imageNamed:@"chat_send_icon"]];
        [viewModel setReceiveBubbleBgPicture:[UIImage imageNamed:@"chat_receive_icon"]];
        _chatController = [EaseChatViewController initWithConversationId:conversationId
                                                    conversationType:conType
                                                        chatViewModel:viewModel];
        [_chatController setEditingStatusVisible:NO];
        _chatController.delegate = self;
    }
    return self;
}
- (void)dealloc
{
//    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:USERINFO_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wsSendMessageAction:) name:@"WSSendMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertLocationCallRecord:) name:EMCOMMMUNICATE_RECORD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationTitle) name:CHATROOM_INFO_UPDATED object:nil];
    [self setupView];
    if (_conversation.unreadMessagesCount > 0) {
        [[EMClient sharedClient].chatManager ackConversationRead:_conversation.conversationId completion:^(EMError * _Nullable aError) {
            if (aError) {
                
            }
        }];
    }
}
- (void)setupView {
    [self addChildViewController:_chatController];
    [self.view addSubview:_chatController.view];
    _chatController.view.frame = self.view.bounds;
//    [_chatController.tableView setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.moreButton];
    [self loadData:YES];
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton k_buttonWithTarget:self action:@selector(moreButtonAction:)];
        [_moreButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_moreButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (void)moreButtonAction:(UIButton *)sender {
    [self showMoreSheet];
}
- (void)showMoreSheet {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 2) {
            [weakSelf addBlackList];
        }
        if (index == 1) {
            [weakSelf showReportSheet];
        }
        if (index == 0) {
            [weakSelf deleteCon];
        }
    };
    NSArray *items = @[
                       MMItemMake(@"Delete", MMItemTypeHighlight, block),
                       MMItemMake(@"Report", MMItemTypeNormal, block),
                       MMItemMake(@"Block", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    view.cancelColor = K_TextLightGrayColor;
    [view show];
}
- (void)deleteCon {
    CKWeakify(self);
    [[EMClient sharedClient].chatManager deleteServerConversation:self.conversation.conversationId conversationType:self.conversation.type isDeleteServerMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        if (aError) {
            [MBProgressHUD showMessage:aError.errorDescription];
        }
        [[EMClient sharedClient].chatManager deleteConversation:weakSelf.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}
- (void)showReportSheet {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        NSString *string = @"Other";
        if (index == 0) {
            string = @"Pornographic vulgar";
        } else if (index == 1) {
            string = @"Advertising fraud";
        } else if (index == 2) {
            string = @"Politically sensitive";
        } else if (index == 3) {
            string = @"Bloody terror";
        } else if (index == 4) {
            string = @"Incite war and abuse";
        }
        [weakSelf repoWithUserContent:string];
    };
    NSArray *items = @[MMItemMake(@"Pornographic vulgar", MMItemTypeNormal, block),
                       MMItemMake(@"Advertising fraud", MMItemTypeNormal, block),
                       MMItemMake(@"Politically sensitive", MMItemTypeNormal, block),
                       MMItemMake(@"Bloody terror", MMItemTypeNormal, block),
                       MMItemMake(@"Incite war and abuse", MMItemTypeNormal, block),
                       MMItemMake(@"Other", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    view.cancelColor = K_TextLightGrayColor;
    [view show];
}
- (void)addBlackList {
    WSAddBlacklistRequest *request = [WSAddBlacklistRequest.alloc init];
    request.userId = self.conversation.conversationId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)repoWithUserContent:(NSString *)content {
    WSBlackListRepoRequest *request = [WSBlackListRepoRequest.alloc init];
    request.userId = self.conversation.conversationId;
    request.content = content;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)refreshTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.view.window)
            [self.chatController triggerUserInfoCallBack:YES];
    });
}
- (void)wsSendMessageAction:(NSNotification *)info {
    EMChatMessage *messages = info.object;
    if(messages) {
        NSArray *formated = [self formatMessages:@[messages]];
        [self.chatController.dataArray addObjectsFromArray:formated];
        if (!self.chatController.moreMsgId)
            //新会话的第一条消息
        self.chatController.moreMsgId = messages.messageId;
        [self.chatController refreshTableView:YES];
    }
}
//本地通话记录
- (void)insertLocationCallRecord:(NSNotification*)noti {
    NSArray<EMChatMessage *> * messages = (NSArray *)[noti.object objectForKey:@"msg"];
    if(messages && messages.count > 0) {
        NSArray *formated = [self formatMessages:messages];
        [self.chatController.dataArray addObjectsFromArray:formated];
        if (!self.chatController.moreMsgId)
            //新会话的第一条消息
        self.chatController.moreMsgId = [messages objectAtIndex:0].messageId;
        [self.chatController refreshTableView:YES];
    }
}
- (void)updateNavigationTitle {
    self.navigationItem.title = _conversationModel.showName;
    if (self.conversation.type == EMConversationTypeChat) {
        EMUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:self.conversation.conversationId];
        if(userInfo && userInfo.nickname.length > 0)
            self.navigationItem.title = userInfo.nickname;
    }
}
#pragma mark - data
- (void)loadData:(BOOL)isScrollBottom
{
    __weak typeof(self) weakself = self;
    void (^block)(NSArray *aMessages, EMError *aError) = ^(NSArray *aMessages, EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.chatController refreshTableViewWithData:aMessages isInsertBottom:NO isScrollBottom:isScrollBottom];
        });
    };
    
    if (YES) {
        EMConversation *conversation = self.conversation;
        [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:conversation.conversationId conversationType:conversation.type startMessageId:self.moreMsgId pageSize:10 completion:^(EMCursorResult *aResult, EMError *aError) {
            [self.conversation loadMessagesStartFromId:self.moreMsgId count:10 searchDirection:EMMessageSearchDirectionUp completion:block];
         }];
    } else {
        [self.conversation loadMessagesStartFromId:self.moreMsgId count:50 searchDirection:EMMessageSearchDirectionUp completion:block];
    }
}
- (NSArray *)formatMessages:(NSArray<EMChatMessage *> *)aMessages
{
    NSMutableArray *formated = [[NSMutableArray alloc] init];

    for (int i = 0; i < [aMessages count]; i++) {
        EMChatMessage *msg = aMessages[i];
        if (msg.chatType == EMChatTypeChat && msg.isReadAcked && (msg.body.type == EMMessageBodyTypeText || msg.body.type == EMMessageBodyTypeLocation)) {
            [[EMClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
        }
        
        CGFloat interval = (self.chatController.msgTimelTag - msg.timestamp) / 1000;
        if (self.chatController.msgTimelTag < 0 || interval > 60 || interval < -60) {
            NSString *timeStr = [NSString formattedTimeFromTimeInterval:msg.timestamp];
            [formated addObject:timeStr];
            self.chatController.msgTimelTag = msg.timestamp;
        }
        EaseMessageModel *model = nil;
        model = [[EaseMessageModel alloc] initWithEMMessage:msg];
        if (!model) {
            model = [[EaseMessageModel alloc]init];
        }
        model.userDataDelegate = [self userData:msg.from];
        [formated addObject:model];
    }
    
    return formated;
}
#pragma mark - EaseChatViewControllerDelegate
- (void)loadMoreMessageData:(NSString *)firstMessageId currentMessageList:(NSArray<EMChatMessage *> *)messageList
{
    self.moreMsgId = firstMessageId;
    [self loadData:NO];
}
//userdata
- (id<EaseUserDelegate>)userData:(NSString *)huanxinID
{
    EMUserDataModel *model = [[EMUserDataModel alloc] initWithEaseId:huanxinID];
    EMUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:huanxinID];
    if(userInfo) {
        if(userInfo.avatarUrl.length > 0) {
            model.avatarURL = userInfo.avatarUrl;
        }
        if(userInfo.nickname.length > 0) {
            model.showName = userInfo.nickname;
        }
    }else{
        [[UserInfoStore sharedInstance] fetchUserInfosFromServer:@[huanxinID]];
    }
    return model;
}
//头像点击
- (void)avatarDidSelected:(id<EaseUserDelegate>)userData
{
    if (userData && userData.easeId) {
        [self personData:userData.easeId];
    }
}
//个人资料页
- (void)personData:(NSString*)contanct
{
    WSPersonPController* controller = [WSPersonPController.alloc init];
//    if([[EMClient sharedClient].currentUsername isEqualToString:contanct]) {
//        controller = [[EMAccountViewController alloc] init];
//    }else{
//        controller = [[EMPersonalDataViewController alloc]initWithNickName:contanct];
//    }
    controller.userIdString = contanct;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didSendMessage:(EMChatMessage *)message error:(EMError *)error
{
    if (error) {
//        [EMAlertController showErrorAlert:error.errorDescription];
        [MBProgressHUD showMessage:error.errorDescription];
    }
}
- (void)didClickVideoAction {
    CKWeakify(self);
    [[EaseCallManager sharedManager] startSingleCallWithUId:self.conversation.conversationId type:EaseCallType1v1Video ext:@{@"SendName":kUser.name,@"SendUrl":kUser.headerUrl} completion:^(NSString * callId, EaseCallError * aError) {
        if (aError) {

        } else {
            EaseCallUser* user = [[EaseCallUser alloc] init];
            user.nickName = kUser.name;
            user.headImage = [NSURL URLWithString:kUser.headerUrl];
            [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:kUser.uid info:user];
            
            EMUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:weakSelf.conversation.conversationId];
            EaseCallUser* user1 = [[EaseCallUser alloc] init];
            user1.nickName = userInfo.nickname;
            user1.headImage = [NSURL URLWithString:userInfo.avatarUrl];
            [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:weakSelf.conversation.conversationId info:user1];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.inviteeUid = weakSelf.conversation.conversationId;
        }
    }];
}
@end
