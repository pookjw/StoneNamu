//
//  DeckAddCardSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardSectionModelType) {
    DeckCardsSectionModelTypeCards
};

@interface DeckAddCardSectionModel : NSObject
@property (readonly) DeckAddCardSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckAddCardSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
