//
//  WSPushCommunityController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/9.
//

#import "WSPushCommunityController.h"

@interface WSPushCommunityController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WSPushCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Post";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.sendButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:15];
    [flowLayout setMinimumLineSpacing:15];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH-105) / 4.0f, (CK_WIDTH-105) / 4.0f)];
    [flowLayout setSectionHeadersPinToVisibleBounds:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
#pragma mark - IBActon
- (void)sendButtonAcion:(UIButton *)sender {
    
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 1;
//}
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
#pragma mark - Getter
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton k_mainButtonWithTarget:self action:@selector(sendButtonAcion:)];
        _sendButton.frame = CGRectMake(0, 0, 70, 30);
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:KBoldFont(16)];
        [_sendButton.layer setCornerRadius:15];
    }
    return  _sendButton;
}

@end
