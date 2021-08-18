//
//  DecksViewModel.h
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LocalDeck.h"
#import "HSDeck.h"
#import "DecksSectionModel.h"
#import "DecksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DecksViewModelFetchDeckCodeCompletion)(NSManagedObjectID * _Nullable, HSDeck * _Nullable, NSError * _Nullable);

typedef UICollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)fetchDeckCode:(NSString *)deckCode completion:(DecksViewModelFetchDeckCodeCompletion)completion;

- (void)testFetchUsingObjectId:(NSManagedObjectID *)objectId;
@end

NS_ASSUME_NONNULL_END
