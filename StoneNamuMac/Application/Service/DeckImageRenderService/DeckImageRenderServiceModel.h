//
//  DeckImageRenderServiceModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import "DeckImageRenderServiceSectionModel.h"
#import "DeckImageRenderServiceItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<DeckImageRenderServiceSectionModel *, DeckImageRenderServiceItemModel *> DeckImageRenderServiceDataSource;

typedef void (^DeckImageRenderServiceModelUpdateWithCompletion)(NSUInteger);

@interface DeckImageRenderServiceModel : NSObject
@property (readonly, retain) DeckImageRenderServiceDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckImageRenderServiceDataSource *)dataSource;
- (void)updateDataSourceWithLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceModelUpdateWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
