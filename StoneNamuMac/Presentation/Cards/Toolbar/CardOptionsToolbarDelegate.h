//
//  CardOptionsToolbarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CardOptionsToolbar;

@protocol CardOptionsToolbarDelegate <NSObject>
- (void)cardOptionsToolbar:(CardOptionsToolbar *)toolbar changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
@end

NS_ASSUME_NONNULL_END

