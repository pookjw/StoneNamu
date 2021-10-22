//
//  DeckDetailsManaCostContentSectionModel.h
//  DeckDetailsManaCostContentSectionModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsManaCostContentSectionModelType) {
    DeckDetailsManaCostContentSectionModelTypeNoName
};

@interface DeckDetailsManaCostContentSectionModel : NSObject
@property (readonly) DeckDetailsManaCostContentSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckDetailsManaCostContentSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
