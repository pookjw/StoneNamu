//
//  DeckImageRenderServiceModel.m
//  DeckImageRenderServiceModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceModel.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckImageRenderServiceModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation DeckImageRenderServiceModel

- (instancetype)initWithDataSource:(DeckImageRenderServiceDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_dataCacheUseCase release];
    [_localDeckUseCase release];
    [_hsMetaDataUseCase release];
    [_queue release];
    [super dealloc];
}

- (void)updateDataSourceWithLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceModelUpdateWithCompletion)completion {
    [self.queue addBarrierBlock:^{
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            [self.queue addBarrierBlock:^{
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                [snapshot deleteAllItems];
                
                //
                
                NSArray<HSCard *> *hsCards = localDeck.hsCards;
                NSString *deckName = localDeck.name;
                NSNumber *classId = localDeck.classId;
                HSDeckFormat deckFormat = localDeck.format;
                
                //
                
                NSMutableDictionary<HSCard *, NSNumber *> *countOfEachCards = [NSMutableDictionary<HSCard *, NSNumber *> new];
                NSNumber *totalArcaneDust = @0;
                
                HSCardRarity *freeRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeFree usingHSMetaData:hsMetaData];
                HSCardRarity *commonRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeCommon usingHSMetaData:hsMetaData];
                HSCardRarity *rareRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeRare usingHSMetaData:hsMetaData];
                HSCardRarity *epicRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeEpic usingHSMetaData:hsMetaData];
                HSCardRarity *legendaryRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeLegendary usingHSMetaData:hsMetaData];
                
                NSNumber * (^lowestNumber)(NSSet<NSNumber *> *) = ^NSNumber *(NSSet<NSNumber *> *numbers) {
                    NSNumber * _Nullable __block result = nil;
                    
                    [numbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
                        if (result == nil) {
                            result = obj;
                        } else {
                            result = [NSNumber numberWithInt:MIN(obj.intValue, result.intValue)];
                        }
                    }];
                    
                    return result;
                };
                
                NSNumber *freeCost = lowestNumber(freeRarity.craftingCost);
                NSNumber *commonCost = lowestNumber(commonRarity.craftingCost);
                NSNumber *rareCost = lowestNumber(rareRarity.craftingCost);
                NSNumber *epicCost = lowestNumber(epicRarity.craftingCost);
                NSNumber *legendaryCost = lowestNumber(legendaryRarity.craftingCost);
                
                for (HSCard *hsCard in hsCards) {
                    @autoreleasepool {
                        if (countOfEachCards[hsCard] == nil) {
                            countOfEachCards[hsCard] = @1;
                        } else {
                            NSNumber *old = countOfEachCards[hsCard];
                            NSNumber *new = [NSNumber numberWithUnsignedInteger:old.unsignedIntegerValue + 1];
                            countOfEachCards[hsCard] = new;
                        }
                        
                        //
                        
                        NSNumber * _Nullable toAdd = nil;
                        
                        if (compareNullableValues(freeRarity.rarityId, hsCard.rarityId, @selector(isEqualToNumber:))) {
                            toAdd = freeCost;
                        } else if (compareNullableValues(commonRarity.rarityId, hsCard.rarityId, @selector(isEqualToNumber:))) {
                            toAdd = commonCost;
                        } else if (compareNullableValues(rareRarity.rarityId, hsCard.rarityId, @selector(isEqualToNumber:))) {
                            toAdd = rareCost;
                        } else if (compareNullableValues(epicRarity.rarityId, hsCard.rarityId, @selector(isEqualToNumber:))) {
                            toAdd = epicCost;
                        } else if (compareNullableValues(legendaryRarity.rarityId, hsCard.rarityId, @selector(isEqualToNumber:))) {
                            toAdd = legendaryCost;
                        }
                        
                        if (toAdd != nil) {
                            totalArcaneDust = [NSNumber numberWithUnsignedInteger:totalArcaneDust.unsignedIntegerValue + toAdd.unsignedIntegerValue];
                        }
                    }
                }
                
                //
                
                DeckImageRenderServiceSectionModel *introSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeIntro];
                [snapshot appendSectionsWithIdentifiers:@[introSectionModel]];
                
                DeckImageRenderServiceItemModel *introItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeIntro];
                HSCardClass *hsCardClass = [self.hsMetaDataUseCase hsCardClassFromClassId:classId usingHSMetaData:hsMetaData];
                introItemModel.classSlug = hsCardClass.slug;
                introItemModel.className = hsCardClass.name;
                introItemModel.deckName = deckName;
                introItemModel.deckFormat = deckFormat;
                introItemModel.isEasterEgg = [self.localDeckUseCase isEasterEggDeckFromLocalDeck:localDeck];
                
                [snapshot appendItemsWithIdentifiers:@[introItemModel] intoSectionWithIdentifier:introSectionModel];
                [introSectionModel release];
                [introItemModel release];
                
                //
                
                DeckImageRenderServiceSectionModel *cardsSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeCards];
                [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel]];
                
                NSUInteger __block countOfCardItem = 0;
                
                [countOfEachCards enumerateKeysAndObjectsUsingBlock:^(HSCard * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
                    HSCardRarity *hsCardRarity = [self.hsMetaDataUseCase hsCardRarityFromRarityId:key.rarityId usingHSMetaData:hsMetaData];
                    
                    DeckImageRenderServiceItemModel *cardItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeCard];
                    cardItemModel.hsCard = key;
                    cardItemModel.hsCardCount = obj.unsignedIntegerValue;
                    cardItemModel.raritySlug = hsCardRarity.slug;
                    
                    SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
                    
                    if (key.cropImage != nil) {
                        [self fetchImageCacheWithURL:key.cropImage completion:^(UIImage * _Nullable image) {
                            cardItemModel.hsCardImage = image;
                            [semaphore signal];
                        }];
                    } else {
                        [self fetchImageCacheWithURL:key.image completion:^(UIImage * _Nullable image) {
                            cardItemModel.hsCardImage = image;
                            [semaphore signal];
                        }];
                    }
                    
                    [semaphore wait];
                    [semaphore release];
                    
                    [snapshot appendItemsWithIdentifiers:@[cardItemModel] intoSectionWithIdentifier:cardsSectionModel];
                    [cardItemModel release];
                    
                    countOfCardItem += 1;
                }];
                
                [cardsSectionModel release];
                
                //
                
                DeckImageRenderServiceSectionModel *aboutSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeAbout];
                [snapshot appendSectionsWithIdentifiers:@[aboutSectionModel]];
                DeckImageRenderServiceItemModel *aboutItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeAbout];
                
                HSCardSetGroups *latestSetGroup = [self.hsMetaDataUseCase latestHSCardSetGroupsUsingHSMetaData:hsMetaData];
                
                aboutItemModel.totalArcaneDust = totalArcaneDust;
                aboutItemModel.hsYearCurrentName = latestSetGroup.name;
                
                [snapshot appendItemsWithIdentifiers:@[aboutItemModel] intoSectionWithIdentifier:aboutSectionModel];
                [aboutSectionModel release];
                [aboutItemModel release];
                
                //
                
                DeckImageRenderServiceSectionModel *appNameSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeAppName];
                [snapshot appendSectionsWithIdentifiers:@[appNameSectionModel]];
                DeckImageRenderServiceItemModel *appNameItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeAppName];
                [snapshot appendItemsWithIdentifiers:@[appNameItemModel] intoSectionWithIdentifier:appNameSectionModel];
                [appNameSectionModel release];
                [appNameItemModel release];
                
                //
                
                [self sortSnapshot:snapshot];
                
                //
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{
                    completion(countOfCardItem);
                }];
                
                [snapshot release];
                [countOfEachCards release];
            }];
        }];
    }];
}

- (void)fetchImageCacheWithURL:(NSURL *)url completion:(void (^)(UIImage * _Nullable))completion {
    [self.dataCacheUseCase dataCachesWithIdentity:url.absoluteString completion:^(NSArray<NSData *> * _Nullable cachedDatas, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSData * _Nullable cachedData = cachedDatas.lastObject;
        
        if (cachedData != nil) {
            UIImage *image = [UIImage imageWithData:cachedData];
            completion(image);
            return;
        } else {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
            NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    completion(nil);
                } else {
                    [self.dataCacheUseCase makeDataCache:data identity:url.absoluteString completion:^{
                        UIImage *image = [UIImage imageWithData:data];
                        completion(image);
                    }];
                }
            }];
            
            [sessionTask resume];
            [session finishTasksAndInvalidate];
        }
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortSectionsUsingComparator:^NSComparisonResult(DeckImageRenderServiceSectionModel * _Nonnull obj1, DeckImageRenderServiceSectionModel * _Nonnull obj2) {
        if (obj1.type < obj2.type) {
            return NSOrderedAscending;
        } else if (obj1.type > obj2.type) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers usingComparator:^NSComparisonResult(DeckImageRenderServiceItemModel * _Nonnull obj1, DeckImageRenderServiceItemModel * _Nonnull obj2) {
        
        if ((obj1.type == DeckImageRenderServiceItemModelTypeCard) && (obj2.type == DeckImageRenderServiceItemModelTypeCard)) {
            return [obj1.hsCard compare:obj2.hsCard];
        } else {
            return NSOrderedSame;
        }
    }];
}

@end
