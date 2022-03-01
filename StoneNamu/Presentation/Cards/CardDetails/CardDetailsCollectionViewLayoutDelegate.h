//
//  CardDetailsCollectionViewLayoutDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 3/2/22.
//

#import <Foundation/Foundation.h>
#import "CardDetailsSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CardDetailsCollectionViewLayout;

@protocol CardDetailsCollectionViewLayoutDelegate <NSObject>
- (CardDetailsSectionModelType)cardDetailsCollectionViewLayout:(CardDetailsCollectionViewLayout *)layout cardDetailsSectionModelTypeForSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
