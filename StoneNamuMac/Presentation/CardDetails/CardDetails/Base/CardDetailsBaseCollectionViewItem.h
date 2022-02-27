//
//  CardDetailsBaseCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem = @"NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem";

@interface CardDetailsBaseCollectionViewItem : NSCollectionViewItem
- (void)configureWithLeadingText:(NSString *)leadingText trailingText:(NSString * _Nullable)trailingText;
@end

NS_ASSUME_NONNULL_END
