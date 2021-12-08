//
//  DeckAddCardSectionModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardSectionModelType) {
    DeckAddCardSectionModelTypeCards
};

@interface DeckAddCardSectionModel : NSObject
@property (readonly) DeckAddCardSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckAddCardSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
