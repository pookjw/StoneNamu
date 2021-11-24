//
//  DecksSectionModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DecksSectionModelType) {
    DecksSectionModelTypeNoName
};

@interface DecksSectionModel : NSObject
@property (readonly) DecksSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DecksSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
