//
//  DeckImageRenderServiceModel.m
//  DeckImageRenderServiceModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceModel.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "DataCacheUseCaseImpl.h"
#import "NSSemaphoreCondition.h"

@interface DeckImageRenderServiceModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation DeckImageRenderServiceModel

- (instancetype)initWithDataSource:(DeckImageRenderServiceDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = [dataSource retain];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_dataCacheUseCase release];
    [_queue release];
    [super dealloc];
}

- (void)updateDataSourceWithHSCards:(NSArray<HSCard *> *)hsCards
                           deckName:(NSString *)deckName
                            classId:(HSCardClass)classId
                         deckFormat:(HSDeckFormat)deckFormat
                         completion:(DeckImageRenderServiceModelUpdateWithCompletion)completion {
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        //
        
        NSMutableDictionary<HSCard *, NSNumber *> *countOfEachCards = [@{} mutableCopy];
        NSNumber *totalArcaneDust = @0;
        
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
                
                NSUInteger toAdd = 0;
                
                switch (hsCard.rarityId) {
                    case HSCardRarityCommon:
                        toAdd += 40;
                        break;
                    case HSCardRarityRare:
                        toAdd += 100;
                        break;
                    case HSCardRarityEpic:
                        toAdd += 400;
                        break;
                    case HSCardRarityLegendary:
                        toAdd += 1600;
                        break;
                    default:
                        break;
                }
                
                totalArcaneDust = [NSNumber numberWithUnsignedInteger:totalArcaneDust.unsignedIntegerValue + toAdd];
            }
        }
        
        //
        
        DeckImageRenderServiceSectionModel *introSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeIntro];
        [snapshot appendSectionsWithIdentifiers:@[introSectionModel]];
        
        DeckImageRenderServiceItemModel *introItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeIntro];
        introItemModel.classId = classId;
        introItemModel.totalArcaneDust = totalArcaneDust;
        introItemModel.deckName = deckName;
        
        [snapshot appendItemsWithIdentifiers:@[introItemModel] intoSectionWithIdentifier:introSectionModel];
        [introSectionModel release];
        [introItemModel release];
        
        //
        
        DeckImageRenderServiceSectionModel *infoSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeInfo];
        [snapshot appendSectionsWithIdentifiers:@[infoSectionModel]];

        DeckImageRenderServiceItemModel *infoItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeInfo];
        infoItemModel.deckFormat = deckFormat;
        [snapshot appendItemsWithIdentifiers:@[infoItemModel] intoSectionWithIdentifier:infoSectionModel];
        [infoSectionModel release];
        [infoItemModel release];
        
        //
        
        DeckImageRenderServiceSectionModel *cardsSectionModel = [[DeckImageRenderServiceSectionModel alloc] initWithType:DeckImageRenderServiceSectionModelTypeCards];
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel]];
        
        NSUInteger __block countOfCardItem = 0;
        
        [countOfEachCards enumerateKeysAndObjectsUsingBlock:^(HSCard * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            DeckImageRenderServiceItemModel *cardItemModel = [[DeckImageRenderServiceItemModel alloc] initWithType:DeckImageRenderServiceItemModelTypeCard];
            cardItemModel.hsCard = key;
            cardItemModel.hsCardCount = obj.unsignedIntegerValue;
            
            NSSemaphoreCondition *semaphore = [[NSSemaphoreCondition alloc] initWithValue:0];
            
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
        [snapshot appendItemsWithIdentifiers:@[aboutItemModel] intoSectionWithIdentifier:aboutSectionModel];
        [aboutSectionModel release];
        [aboutItemModel release];
        
        //
        
        [self sortSnapshot:snapshot];
        
        //
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:NO completion:^{
                [snapshot release];
                [countOfEachCards release];
                completion(countOfCardItem);
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
            NSURLSession *sharedSession = NSURLSession.sharedSession;
            NSURLSessionTask *sessionTask = [sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    completion(nil);
                } else {
                    [self.dataCacheUseCase makeDataCache:data identity:url.absoluteString];
                    [self.dataCacheUseCase saveChanges];
                    
                    UIImage *image = [UIImage imageWithData:data];
                    completion(image);
                }
            }];
            
            [sessionTask resume];
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
