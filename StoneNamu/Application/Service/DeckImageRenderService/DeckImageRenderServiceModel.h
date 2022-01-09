//
//  DeckImageRenderServiceModel.h
//  DeckImageRenderServiceModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <UIKit/UIKit.h>
#import "DeckImageRenderServiceSectionModel.h"
#import "DeckImageRenderServiceItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<DeckImageRenderServiceSectionModel *, DeckImageRenderServiceItemModel *> DeckImageRenderServiceDataSource;

typedef void (^DeckImageRenderServiceModelUpdateWithCompletion)(NSUInteger);

@interface DeckImageRenderServiceModel : NSObject
@property (readonly, retain) DeckImageRenderServiceDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckImageRenderServiceDataSource *)dataSource;
- (void)updateDataSourceWithLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceModelUpdateWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
