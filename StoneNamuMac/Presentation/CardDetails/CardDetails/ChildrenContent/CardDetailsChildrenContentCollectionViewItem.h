//
//  CardDetailsChildrenContentCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildrenContentCollectionViewItem : NSCollectionViewItem
- (void)configureWithChildCards:(NSArray<HSCard *> *)childCards;
@end

NS_ASSUME_NONNULL_END
