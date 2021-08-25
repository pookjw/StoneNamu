//
//  DeckDetailsSectionModel.h
//  DeckDetailsSectionModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsSectionModelType) {
    DeckDetailsSectionModelTypeCostGraph,
    DeckDetailsSectionModelTypeCards
};

@interface DeckDetailsSectionModel : NSObject
@property (readonly) DeckDetailsSectionModelType type;
- (instancetype)initWithType:(DeckDetailsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
