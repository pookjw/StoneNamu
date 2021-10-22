//
//  DeckAddCardSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardsSectionModelType) {
    DeckCardsSectionModelTypeCards
};

@interface DeckAddCardSectionModel : NSObject
@property (readonly) DeckAddCardsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckAddCardsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
