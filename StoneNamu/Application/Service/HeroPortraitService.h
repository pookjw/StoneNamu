//
//  HeroPortraitService.h
//  HeroPortraitService
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import "HSCardClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeroPortraitService : NSObject
@property (class, readonly, nonatomic) HeroPortraitService *sharedInstance;
- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId;
@end

NS_ASSUME_NONNULL_END
