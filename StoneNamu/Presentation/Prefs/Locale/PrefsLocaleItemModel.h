//
//  PrefsLocaleItemModel.h
//  PrefsLocaleItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrefsLocaleItemModel : NSObject
@property (readonly) BlizzardHSAPILocale _Nullable locale;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
@property BOOL isSelected;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocale:(BlizzardHSAPILocale _Nullable)locale isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
