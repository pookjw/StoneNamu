//
//  Prefs.h
//  Prefs
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Prefs : NSManagedObject
@property (assign) NSString * _Nullable locale;
@property (assign) NSString * _Nullable apiRegionHost;
@property (class, readonly, nonatomic) NSString *alternativeLocale;
@property (class, readonly, nonatomic) NSString *alternativeAPIRegionHost;
- (NSDictionary *)addLocalKeyIfNeedToOptions:(NSDictionary * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
