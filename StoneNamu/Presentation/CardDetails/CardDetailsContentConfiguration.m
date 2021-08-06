//
//  CardDetailsContentConfiguration.m
//  CardDetailsContentConfiguration
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsContentConfiguration.h"
#import "CardDetailsBasicContentView.h"

@implementation CardDetailsContentConfiguration

- (instancetype)initWithLeadingText:(NSString *)leadingText trailingText:(NSString *)trailingText {
    self = [self init];
    
    if (self) {
        self.leadingText = leadingText;
        self.trailingText = trailingText;
    }
    
    return self;
}

- (void)dealloc {
    [_leadingText release];
    [_trailingText release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        CardDetailsContentConfiguration *_copy = (CardDetailsContentConfiguration *)copy;
        
        _copy.leadingText = self.leadingText;
        _copy.trailingText = self.trailingText;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardDetailsBasicContentView *contentView = [[CardDetailsBasicContentView new] autorelease];
    contentView.configuration = self;
    return contentView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
