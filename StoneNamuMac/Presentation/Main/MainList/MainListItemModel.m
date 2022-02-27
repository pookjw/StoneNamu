//
//  MainListItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation MainListItemModel

- (instancetype)initWithType:(MainListItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MainListItemModel class]]) {
        return NO;
    }
    
    MainListItemModel *toCompare = (MainListItemModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (NSImage * _Nullable)image {
    switch (self.type) {
        case MainListItemModelTypeCards:
            return [NSImage imageWithSystemSymbolName:@"text.book.closed" accessibilityDescription:nil];
        case MainListItemModelTypeBattlegrounds:
            return [NSImage imageWithSystemSymbolName:@"flag.and.flag.filled.crossed" accessibilityDescription:nil];
        case MainListItemModelTypeDecks:
            return [NSImage imageWithSystemSymbolName:@"books.vertical" accessibilityDescription:nil];
        default:
            return nil;
    }
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case MainListItemModelTypeCards:
            return [ResourcesService localizationForKey:LocalizableKeyCards];
        case MainListItemModelTypeBattlegrounds:
            return [ResourcesService localizationForKey:LocalizableKeyBattlegrounds];
        case MainListItemModelTypeDecks:
            return [ResourcesService localizationForKey:LocalizableKeyDecks];
        default:
            return nil;
    }
}

@end
