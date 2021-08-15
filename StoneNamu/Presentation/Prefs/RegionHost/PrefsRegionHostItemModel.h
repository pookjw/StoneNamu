//
//  PrefsRegionHostItemModel.h
//  PrefsRegionHostItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>
#import "BlizzardAPIRegionHost.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefsRegionHostItemModel : NSObject
@property (readonly, copy) NSString * _Nullable regionHost;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
@property BOOL isSelected;
- (instancetype)initWithRegionHost:(NSString * _Nullable)regionHost isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
