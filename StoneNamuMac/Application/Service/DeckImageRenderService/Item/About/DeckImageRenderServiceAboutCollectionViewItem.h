//
//  DeckImageRenderServiceAboutCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceAboutCollectionViewItem : NSCollectionViewItem
- (void)configureWithTotalArcaneDust:(NSNumber *)totalArcaneDust hsYearCurrentName:(NSString *)hsYearCurrentName;
@end

NS_ASSUME_NONNULL_END
