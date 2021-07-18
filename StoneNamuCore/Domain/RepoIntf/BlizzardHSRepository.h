//
//  BlizzardHSRepository.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import "BlizzardAPIRegionHost.h"

typedef void (^BlizzardHSRepositoryCompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol BlizzardHSRepository <NSObject>
- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
            options:(NSDictionary<NSString *, id> *)options
  completionHandler:(BlizzardHSRepositoryCompletion)completion;
@end

NS_ASSUME_NONNULL_END
