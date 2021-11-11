//
//  MainListItemModel.m
//  MainListItemModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainListItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation MainListItemModel

- (instancetype)initWithType:(MainItemModelType)type {
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
        case MainItemModelTypeCards:
            return [UIImage systemImageNamed:@"text.book.closed"];
        case MainItemModelTypeDecks:
            return [UIImage systemImageNamed:@"books.vertical"];
        default:
            return nil;
    }
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case MainItemModelTypeCards:
            return [ResourcesService localizaedStringForKey:@"CARDS"];
        case MainItemModelTypeDecks:
            return [ResourcesService localizaedStringForKey:@"DECKS"];
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    return nil;
}

@end
