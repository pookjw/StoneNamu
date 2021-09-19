//
//  DeckAddCardOptionSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardOptionSectionModelType) {
    DeckAddCardOptionSectionModelTypeFirst,
    DeckAddCardOptionSectionModelTypeSecond,
    DeckAddCardOptionSectionModelTypeThird,
    DeckAddCardOptionSectionModelTypeForth,
    DeckAddCardOptionSectionModelTypeFifth
};

@interface DeckAddCardOptionSectionModel : NSObject
@property (readonly) DeckAddCardOptionSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckAddCardOptionSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
