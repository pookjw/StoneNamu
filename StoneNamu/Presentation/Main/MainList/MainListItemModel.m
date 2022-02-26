//
//  MainListItemModel.m
//  MainListItemModel
//
//  Created by Jinwoo Kim on 10/15/21.
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
    MainListItemModel *toCompare = (MainListItemModel *)object;
    
    if (![toCompare isKindOfClass:[MainListItemModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (UIImage * _Nullable)primaryImage {
    switch (self.type) {
        case MainListItemModelTypeCards:
            return [UIImage systemImageNamed:@"text.book.closed"];
        case MainListItemModelTypeBattlegrounds:
            return [UIImage systemImageNamed:@"flag.and.flag.filled.crossed"];
        case MainListItemModelTypeDecks:
            return [UIImage systemImageNamed:@"books.vertical"];
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

- (NSString * _Nullable)secondaryText {
    return nil;
}

@end
