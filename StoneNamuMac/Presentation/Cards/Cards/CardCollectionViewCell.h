//
//  CardCollectionViewCell.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : NSCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
