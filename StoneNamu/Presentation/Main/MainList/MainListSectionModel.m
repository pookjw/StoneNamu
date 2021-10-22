//
//  MainListSectionModel.m
//  MainListSectionModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainListSectionModel.h"

@implementation MainListSectionModel

- (instancetype)initWithType:(MainSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    MainListSectionModel *toCompare = (MainListSectionModel *)object;
    
    if (![toCompare isKindOfClass:[MainListSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (NSString * _Nullable)headerText {
    switch (self.type) {
        case MainSectionModelTypeCards:
            return NSLocalizedString(@"CARDS", @"");
        case MainSectionModelTypeDeck:
            return NSLocalizedString(@"DECKS", @"");
        default:
            return nil;;
    }
}

- (NSString * _Nullable)footerText {
    return nil;
}

@end
