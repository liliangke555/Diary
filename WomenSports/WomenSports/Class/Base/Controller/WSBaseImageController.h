//
//  WSBaseImageController.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "WSBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSBaseImageController : WSBaseController
@property (nonatomic, assign) NSInteger maxPhoto;
@property (nonatomic, strong) NSMutableArray *photoSource;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

- (void)addImage;
- (void)reviewImage:(NSInteger)index;
-(void)refreshView;
- (void)pushTZImagePickerController;
- (void)takePhoto;
@end

NS_ASSUME_NONNULL_END
