//
//  DecksMenuFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "DecksMenuFactory.h"
#import "StorableMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DecksMenuFactory ()
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation DecksMenuFactory

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self->_slugsAndIds release];
        self->_slugsAndIds = nil;
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = nil;
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_hsMetaDataUseCase release];
    [_queue release];
    [_slugsAndNames release];
    [_slugsAndIds release];
    [super dealloc];
}

- (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

- (NSMenu *)menuForHSDeckFormat:(HSDeckFormat)deckFormat target:(id _Nullable)target {
    NSMutableArray<NSMenuItem *> *itemArray = [NSMutableArray<NSMenuItem *> new];
    NSDictionary<NSString *, NSString *> *dic = self.slugsAndNames[deckFormat];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                  action:self.keyMenuItemTriggeredSelector
                                                           keyEquivalent:@""
                                                                userInfo:@{deckFormat: key}];
        item.target = target;
        
        [itemArray addObject:item];
        [item release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(StorableMenuItem* obj1, StorableMenuItem* obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    //
    
    NSMenu *menu = [NSMenu new];
    menu.autoenablesItems = NO;
    menu.itemArray = itemArray;
    [itemArray release];
    
    return [menu autorelease];
}

- (void)load {
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        HSMetaData * _Nullable __block hsMetaData = nil;
        
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable _hsMetaData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                [semaphore signal];
                return;
            }
            
            hsMetaData = [_hsMetaData copy];
            [semaphore signal];
        }];
        
        [semaphore wait];
        [semaphore release];
        
        if (hsMetaData == nil) {
            [hsMetaData release];
            return;
        }
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds = [self.hsMetaDataUseCase hsDeckFormatsAndClassesSlugsAndIdsUsingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *slugsAndNames = [self.hsMetaDataUseCase hsDeckFormatsAndClassesSlugsAndNamesUsingHSMetaData:hsMetaData];
        [hsMetaData release];
        
        [self->_slugsAndIds release];
        self->_slugsAndIds = [slugsAndIds copy];
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = [slugsAndNames copy];
        
        [self postShouldUpdateItems];
    }];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(hsMetaDataClearCacheReceived:)
                                               name:NSNotificationNameHSMetaDataUseCaseClearCache
                                             object:nil];
}

- (void)hsMetaDataClearCacheReceived:(NSNotification *)notification {
    [self load];
}

- (void)postShouldUpdateItems {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDecksMenuFactoryShouldUpdateItems
                                                      object:self
                                                    userInfo:nil];
}


@end
