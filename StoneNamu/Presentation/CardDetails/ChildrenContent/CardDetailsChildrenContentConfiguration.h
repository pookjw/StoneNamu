//
//  CardDetailsChildrenContentConfiguration.h
//  CardDetailsChildrenContentConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"
#import "CardDetailsChildrenContentConfigurationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildrenContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSArray<HSCard *> *childCards;
@property (weak) id<CardDetailsChildrenContentConfigurationDelegate> delegate;
- (instancetype)initwithChildCards:(NSArray<HSCard *> *)childCards;
@end

NS_ASSUME_NONNULL_END
