//
//  DecksSectionModel.h
//  DecksSectionModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DecksSectionModelType) {
    DecksSectionModelTypeNoName
};

@interface DecksSectionModel : NSObject
@property (readonly) DecksSectionModelType type;
- (instancetype)initWithType:(DecksSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
