//
//  DeckBackgroundBox.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/22/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSCollectionViewDecorationElementKind const NSCollectionViewDecorationElementKindDeckBackgroundBox = @"NSCollectionViewDecorationElementKindDeckBackgroundBox";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckBackgroundBox = @"NSUserInterfaceItemIdentifierDeckBackgroundBox";

typedef NS_ENUM(NSUInteger, DeckBackgroundBoxType) {
    DeckBackgroundBoxTypePrimary,
    DeckBackgroundBoxTypeSecondary
};

@interface DeckBackgroundBox : NSBox <NSCollectionViewElement>
- (void)configureWithType:(DeckBackgroundBoxType)type;
@end

NS_ASSUME_NONNULL_END
