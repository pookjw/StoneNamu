//
//  DataCache.m
//  DataCache
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DataCache.h"

@implementation DataCache

@dynamic identity;
@dynamic data;

+ (NSFetchRequest<DataCache *> *)_fetchRequest {
    return [NSFetchRequest<DataCache *> fetchRequestWithEntityName:@"DataCache"];
}

@end
