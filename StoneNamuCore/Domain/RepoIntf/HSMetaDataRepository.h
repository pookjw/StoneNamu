//
//  HSMetaDataRepository.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSMetaData.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSMetaDataRepositoryFetchMetaDataCompletion)(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error);

@protocol HSMetaDataRepository <NSObject>

- (void)fetchMetaDataAtRegion:(BlizzardAPIRegionHost)regionHost
                  withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
            completionHandler:(HSMetaDataRepositoryFetchMetaDataCompletion)completion;

@end

NS_ASSUME_NONNULL_END
