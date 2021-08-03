//
//  CardDetailsItemModel.m
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsItemModel.h"

@interface CardDetailsItemModel ()
@property (retain) NSString * _Nullable value;
@end

@implementation CardDetailsItemModel

- (instancetype)initWithType:(CardDetailsItemModelType)type value:(NSString * _Nullable)value {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.value = value;
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsItemModel class]]) {
        return NO;
    }
    
    CardDetailsItemModel *toCompare = (CardDetailsItemModel *)object;
    
    return self.type == toCompare.type;
}

- (NSString * _Nullable)text {
    switch (self.type) {
        case CardDetailsItemModelTypeName:
            return NSLocalizedString(@"CARD_NAME", @"");
        default:
            return nil;
    }
}

- (NSString * _Nullable)accessoryText {
    return self.value;
}

@end
