//
//  CardDetailsCollectionViewLayout.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/13/21.
//

#import <UIKit/UIKit.h>
#import "CardDetailsCollectionViewLayoutDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsCollectionViewLayout : UICollectionViewCompositionalLayout
- (instancetype)initWithCardDetailsCollectionViewLayoutDelegate:(id<CardDetailsCollectionViewLayoutDelegate>)cardDetailsCollectionViewLayoutDelegate;
@end

NS_ASSUME_NONNULL_END
