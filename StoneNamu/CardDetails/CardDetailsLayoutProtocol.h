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
- (void)cardDetailsLayoutRemovePrimaryImageView;
- (void)cardDetailsLayoutRemoveCollectionView;
@end

NS_ASSUME_NONNULL_END
