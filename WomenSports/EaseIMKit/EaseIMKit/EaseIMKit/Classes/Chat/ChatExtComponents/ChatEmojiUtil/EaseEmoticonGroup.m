//
//  EaseEmoticonGroup.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/31.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseEmoticonGroup.h"
#import "EaseHeaders.h"
#import "UIImage+EaseUI.h"
#import "HorizontalLayout.h"

EaseEmoticonGroup *gGifGroup = nil;

@implementation EaseEmoticonModel

- (instancetype)initWithType:(EMEmotionType)aType
{
    self = [super init];
    if (self) {
        _type = aType;
    }
    
    return self;
}

@end


@implementation EaseEmoticonGroup

- (instancetype)initWithType:(EMEmotionType)aType
                   dataArray:(NSArray<EaseEmoticonModel *> *)aDataArray
                        icon:(UIImage *)aIcon
                    rowCount:(NSInteger)aRowCount
                    colCount:(NSInteger)aColCount
{
    self = [super init];
    if (self) {
        _type = aType;
        _dataArray = aDataArray;
        _icon = aIcon;
        _rowCount = aRowCount;
        _colCount = aColCount;
    }
    
    return self;
}

+ (instancetype)getGifGroup
{
    if (gGifGroup) {
        return gGifGroup;
    }
    
    NSMutableArray *models2 = [[NSMutableArray alloc] init];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        ++index;
        EaseEmoticonModel *model = [[EaseEmoticonModel alloc] initWithType:EMEmotionTypeGif];
        model.eId = [NSString stringWithFormat:@"em%d",(1000 + index)];
        model.name = [NSString stringWithFormat:EaseLocalizableString(@"[example]", nil), index];
        model.imgName = [NSString stringWithFormat:@"%@_cover", name];
        model.original = name;
        [models2 addObject:model];
    }
    NSString *tagImgName = [models2[0] imgName];
    gGifGroup = [[EaseEmoticonGroup alloc] initWithType:EMEmotionTypeGif dataArray:models2 icon:[UIImage easeUIImageNamed:tagImgName] rowCount:2 colCount:4];
    return gGifGroup;
}

@end


@implementation EMEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgView];
    [self.imgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor grayColor];
    self.label.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.label];
    [self.label Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.imgView.ease_bottom).offset(5);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.height.greaterThanOrEqualTo(@14);
    }];
}

#pragma mark - Setter

- (void)setModel:(EaseEmoticonModel *)model
{
    _model = model;
    
    if (model.type == EMEmotionTypeEmoji) {
        self.label.font = [UIFont fontWithName:@"AppleColorEmoji" size:29.0];
    }
    self.label.text = model.name;
    
    if ([model.imgName length] > 0) {
        self.imgView.image = [UIImage easeUIImageNamed:model.imgName];
    }
}

@end


@interface EMEmoticonView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) EaseEmoticonGroup *emotionGroup;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic) CGSize itemSize;

@property (nonatomic) CGFloat itemMargin;

@end

@implementation EMEmoticonView

- (instancetype)initWithEmotionGroup:(EaseEmoticonGroup *)aEmotionGroup
{
    self = [super init];
    if (self) {
        _emotionGroup = aEmotionGroup;
        
        _viewHeight = 160;
        _itemMargin = 8;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - (_itemMargin * (aEmotionGroup.colCount + 1))) / aEmotionGroup.colCount;
        CGFloat height = (_viewHeight - (_itemMargin * (aEmotionGroup.rowCount + 1))) / aEmotionGroup.rowCount;
        _itemSize = CGSizeMake(width, height);
        
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    HorizontalLayout *layout = [[HorizontalLayout alloc] initWithOffset:([UIScreen mainScreen].bounds.size.width - _itemSize.width * 7)/8 yOffset:(_viewHeight - _itemSize.height * 3)/4];
    layout.itemSize = CGSizeMake(_itemSize.width, _itemSize.height);
    layout.rowCount = 7;
    layout.columCount = 3;
    layout.itemCountSum = 19;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_emotionGroup.type == EMEmotionTypeEmoji ? layout : flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.pagingEnabled = YES;
    //    self.collectionView.userInteractionEnabled = YES;
    [self.collectionView registerClass:[EMEmoticonCell class] forCellWithReuseIdentifier:@"EMEmoticonCell"];
    [self addSubview:self.collectionView];
    [self.collectionView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.emotionGroup.dataArray count] < 19) {
        return 1;
    }
    if ([self.emotionGroup.dataArray count] % 19 == 0) {
        return [self.emotionGroup.dataArray count] / 19;
    }
    return [self.emotionGroup.dataArray count] / 19 + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.emotionGroup.dataArray count] < 19) {
        return [self.emotionGroup.dataArray count];
    }
    return 19;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMEmoticonCell" forIndexPath:indexPath];
    long count = indexPath.section * 19 + indexPath.row;
    if (count >= [self.emotionGroup.dataArray count]) {
        cell.model = [[EaseEmoticonModel alloc]initWithType:EMEmotionTypeEmoji];
        return cell;
    }
    cell.model = self.emotionGroup.dataArray[indexPath.section * 19 + indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMEmoticonCell *cell = (EMEmoticonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonViewDidSelectedModel:)]) {
        [self.delegate emoticonViewDidSelectedModel:cell.model];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemSize;
}

// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(self.itemMargin, self.itemMargin, self.itemMargin, self.itemMargin);
}

//设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemMargin;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemMargin;
}

@end
