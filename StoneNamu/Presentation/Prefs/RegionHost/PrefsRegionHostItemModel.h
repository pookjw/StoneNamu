//
//  PrefsRegionHostItemModel.h
//  PrefsRegionHostItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrefsRegionHostItemModel : NSObject
@property (readonly, copy) NSString * _Nullable regionHost;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
@property BOOL isSelected;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRegionHost:(NSString * _Nullable)regionHost isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
