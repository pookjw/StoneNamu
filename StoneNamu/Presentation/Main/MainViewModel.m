//
//  MainViewModel.m
//  MainViewModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainViewModel.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "BlizzardHSAPIKeys.h"
#import "HSCardGameMode.h"

@interface MainViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation MainViewModel

- (instancetype)initWithDataSource:(MainDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self requestDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath {
    MainSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.headerText;
}

- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath {
    MainSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.footerText;
}

- (NSDictionary<NSString *,NSString *> * _Nullable)cardOptionsFromType:(MainItemModelType)type {
    switch (type) {
        case MainItemModelTypeCardsConstructed:
            return @{BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeConstructed)};
        case MainItemModelTypeCardsMercenaries:
            return @{BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeMercenaries)};
        default:
            return nil;
    }
}

- (void)requestDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        MainSectionModel *cardsSection = [[MainSectionModel alloc] initWithType:MainSectionModelTypeCards];
        MainSectionModel *deckSection = [[MainSectionModel alloc] initWithType:MainSectionModelTypeDeck];
        
        [snapshot appendSectionsWithIdentifiers:@[cardsSection, deckSection]];
        
        //
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[MainItemModel alloc] initWithType:MainItemModelTypeCardsConstructed] autorelease],
                [[[MainItemModel alloc] initWithType:MainItemModelTypeCardsMercenaries] autorelease]
            ]
                       intoSectionWithIdentifier:cardsSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[MainItemModel alloc] initWithType:MainItemModelTypeDecks] autorelease]
            ] intoSectionWithIdentifier:deckSection];
        }
        
        [cardsSection release];
        [deckSection release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
    }];
}

@end
