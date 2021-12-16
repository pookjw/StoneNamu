//
//  DeckDetailsSectionModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsSectionModelType) {
    DeckDetailsSectionModelTypeCards
};

@interface DeckDetailsSectionModel : NSObject
@property (readonly) DeckDetailsSectionModelType type;
@property (copy) NSString * _Nullable headerText;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckDetailsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
