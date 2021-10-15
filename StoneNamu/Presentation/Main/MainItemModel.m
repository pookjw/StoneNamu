//
//  MainItemModel.m
//  MainItemModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainItemModel.h"
#import "HSCardGameMode.h"

@implementation MainItemModel

- (instancetype)initWithType:(MainItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    MainItemModel *toCompare = (MainItemModel *)object;
    
    if (![toCompare isKindOfClass:[MainItemModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (UIImage * _Nullable)primaryImage {
    switch (self.type) {
        case MainItemModelTypeCardsConstructed:
            return [UIImage systemImageNamed:@"text.book.closed"];
        case MainItemModelTypeCardsMercenaries:
            return [UIImage systemImageNamed:@"text.book.closed"];
        case MainItemModelTypeDecks:
            return [UIImage systemImageNamed:@"books.vertical"];
        default:
            return nil;
    }
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case MainItemModelTypeCardsConstructed:
            return hsCardGameModesWithLocalizable()[NSStringFromHSCardGameMode(HSCardGameModeConstructed)];
        case MainItemModelTypeCardsMercenaries:
            return hsCardGameModesWithLocalizable()[NSStringFromHSCardGameMode(HSCardGameModeMercenaries)];
        case MainItemModelTypeDecks:
            return NSLocalizedString(@"DECKS", @"");
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    return nil;
}

@end
