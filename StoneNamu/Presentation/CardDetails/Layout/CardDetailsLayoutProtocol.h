//
//  CardDetailsLayoutProtocol.h
//  CardDetailsLayoutProtocol
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardDetailsLayoutProtocol <NSObject>
- (CGRect)estimatedPrimaryImageRectUsingWindow:(UIWindow *)window safeAreaInsets:(UIEdgeInsets)safeAreaInsets;
- (void)cardDetailsLayoutAddPrimaryImageView:(UIImageView *)primaryImageView;
- (void)cardDetailsLayoutAddCollectionView:(UICollectionView *)collectionView;
- (void)cardDetailsLayoutAddCloseButton:(UIButton *)closeButton;
- (void)cardDetailsLayoutRemovePrimaryImageView;
- (void)cardDetailsLayoutRemoveCollectionView;
- (void)cardDetailsLayoutRemoveCloseButton;
@end

NS_ASSUME_NONNULL_END
