//
//  WSNewsController.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSNewsController.h"
#import "WSConversationsTableCell.h"
#import "EMConversationUserDataModel.h"
#import "WSChatController.h"

@interface WSNewsController ()<EaseConversationsViewControllerDelegate>
@property (nonatomic, strong) EaseConversationsViewController *easeConvsVC;
@end

@implementation WSNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:USERINFO_UPDATE object:nil];
    [self setupView];
}
- (void)refreshTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.view.window)
            [self.easeConvsVC refreshTable];
    });
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
- (void)setupView {
    EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init];
    viewModel.canRefresh = YES;
    viewModel.badgeLabelPosition = EMAvatarTopRight;
    
    self.easeConvsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
    [self addChildViewController:self.easeConvsVC];
    self.easeConvsVC.delegate = self;
    [self.view addSubview:self.easeConvsVC.view];
    [self.easeConvsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [self.easeConvsVC.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSConversationsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSConversationsTableCell.class)];

    [self refreshTableViewWithData];
}
#pragma mark - EaseConversationsViewControllerDelegate

- (UITableViewCell *)easeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSConversationsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSConversationsTableCell.class)];
    EaseConversationModel *model = [self.easeConvsVC.dataAry objectAtIndex:indexPath.row];
    
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarURL] placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
    [cell.nameLabel setText:model.showName];
    [cell.contentLabel setAttributedText:model.showInfo];
    [cell.timeLabel setText:[NSString formattedTimeFromTimeInterval:model.lastestUpdateTime]];
    if (model.unreadMessagesCount > 0) {
        cell.bageView.hidden = NO;
        [cell.bageLabel setText:[NSString stringWithFormat:@"%d",model.unreadMessagesCount]];
    } else {
        cell.bageView.hidden = YES;
    }
    return cell;
}
- (id<EaseUserDelegate>)easeUserDelegateAtConversationId:(NSString *)conversationId conversationType:(EMConversationType)type {
    EMConversationUserDataModel *userData = [[EMConversationUserDataModel alloc] initWithEaseId:conversationId conversationType:type];
    if(type == EMConversationTypeChat) {
        if (![conversationId isEqualToString:EMSYSTEMNOTIFICATIONID]) {
            EMUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:conversationId];
            if(userInfo) {
                if([userInfo.nickname length] > 0) {
                    userData.showName = userInfo.nickname;
                }
                if([userInfo.avatarUrl length] > 0) {
                    userData.avatarURL = userInfo.avatarUrl;
                }
            }else{
                [[UserInfoStore sharedInstance] fetchUserInfosFromServer:@[conversationId]];
            }
        }
    }
    return userData;
}
- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseConversationModel *model = [self.easeConvsVC.dataAry objectAtIndex:indexPath.row];
    if ([model.easeId isEqualToString:EMSYSTEMNOTIFICATIONID]) {
        return;
    }
//    EaseChatViewModel *viewModel = [EaseChatViewModel.alloc init];
    
    WSChatController *controller = [WSChatController.alloc initWithConversationId:model.easeId conversationType:EMConversationTypeChat];
    controller.navigationItem.title = model.showName;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (NSArray<UIContextualAction *> *)easeTableView:(UITableView *)tableView trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath actions:(NSArray<UIContextualAction *> *)actions
{
    NSMutableArray<UIContextualAction *> *array = [[NSMutableArray<UIContextualAction *> alloc]init];
    __weak typeof(self) weakself = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                               title:@""
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"deletePrompt", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO];
            [self _deleteConversation:indexPath];
        }];
        [clearAction setValue:[UIColor colorWithRed:245/255.0 green:52/255.0 blue:41/255.0 alpha:1.0] forKey:@"_titleTextColor"];
        [alertController addAction:clearAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO];
        }];
        [cancelAction  setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = 0;
        [weakself presentViewController:alertController animated:YES completion:nil];
    }];
    deleteAction.backgroundColor = [UIColor whiteColor];
    deleteAction.image = [UIImage imageNamed:@"delete_red_icon"];
    [array addObject:deleteAction];
//    [array addObject:actions[1]];
    return [array copy];
}
#pragma mark - Action

//删除会话
- (void)_deleteConversation:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSInteger row = indexPath.row;
    EaseConversationModel *model = [self.easeConvsVC.dataAry objectAtIndex:row];
    int unreadCount = [[EMClient sharedClient].chatManager getConversationWithConvId:model.easeId].unreadMessagesCount;
    [[EMClient sharedClient].chatManager deleteServerConversation:model.easeId conversationType:model.type isDeleteServerMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        if (aError) {
//            [weakSelf showHint:aError.errorDescription];
        }
        [[EMClient sharedClient].chatManager deleteConversation:model.easeId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            [weakSelf.easeConvsVC.dataAry removeObjectAtIndex:row];
            [weakSelf.easeConvsVC refreshTabView];
            if (unreadCount > 0 && weakSelf.deleteConversationCompletion) {
                weakSelf.deleteConversationCompletion(YES);
            }
        }];
    }];
}
- (void)refreshTableViewWithData
{
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager getConversationsFromServer:^(NSArray *aConversations, EMError *aError) {
        if (!aError && [aConversations count] > 0) {
            NSInteger num = 0;
            for (EMConversation *conv in aConversations) {
                num += conv.unreadMessagesCount;
            }
            if (self.reloadUnReadNum) {
                self.reloadUnReadNum(num);
            }
        }
    }];
}

@end
