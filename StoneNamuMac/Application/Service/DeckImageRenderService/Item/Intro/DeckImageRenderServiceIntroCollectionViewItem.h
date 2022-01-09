//
//  DeckImageRenderServiceIntroCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceIntroCollectionViewItem : NSCollectionViewItem
- (void)configureWithClassId:(HSCardClass)classId deckName:(NSString *)deckName deckFormat:(HSDeckFormat)deckFormat isEasterEgg:(BOOL)isEasterEgg;
@end

NS_ASSUME_NONNULL_END
