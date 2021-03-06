//
//  DeckImageRenderService.m
//  DeckImageRenderService
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderService.h"
#import "UIView+imageRendered.h"
#import "DeckImageRenderServiceModel.h"
#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "DeckImageRenderServiceAppNameContentConfiguration.h"
#import "IntrinsicCollectionView.h"

@interface DeckImageRenderService ()
@property (retain) IntrinsicCollectionView *collectionView;
@property (retain) DeckImageRenderServiceModel *model;
@property (retain) NSOperationQueue *queue;
@end

@implementation DeckImageRenderService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self configureCollectionView];
        [self configureModel];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_model release];
    [_queue release];
    [super dealloc];
}

- (void)imageFromLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
        [self.model updateDataSourceWithLocalDeck:localDeck
                                       completion:^(NSUInteger countOfCardItem){
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                self.collectionView.frame = CGRectMake(0, 0, 300, self.collectionView.contentSize.height);
                UIImage *image = self.collectionView.imageRendered;
                completion(image);
                [semaphore signal];
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
    layoutConfiguration.backgroundColor = UIColor.clearColor;
    
    UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearancePlain];
    separatorConfiguration.topSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.color = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    layoutConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    // height will be 1313 when filled 30 cards with sigle cards
    IntrinsicCollectionView *collectionView = [[IntrinsicCollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 1313) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.blackColor;
    collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    
    [collectionView release];
}

- (void)configureModel {
    DeckImageRenderServiceModel *model = [[DeckImageRenderServiceModel alloc] initWithDataSource:[self makeDataSource]];
    self.model = model;
    [model release];
}

- (DeckImageRenderServiceDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    DeckImageRenderServiceDataSource *dataSource = [[DeckImageRenderServiceDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        DeckImageRenderServiceItemModel *itemModel = (DeckImageRenderServiceItemModel *)item;
        
        if (![itemModel isKindOfClass:[DeckImageRenderServiceItemModel class]]) return;
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration listPlainCellConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.clearColor;
        cell.backgroundConfiguration = backgroundConfiguration;
        
        switch (itemModel.type) {
            case DeckImageRenderServiceItemModelTypeIntro: {
                DeckImageRenderServiceIntroContentConfiguration *configuration = [[DeckImageRenderServiceIntroContentConfiguration alloc] initWithClassSlug:itemModel.classSlug
                                                                                                                                                  className:itemModel.className
                                                                                                                                                   deckName:itemModel.deckName
                                                                                                                                                 deckFormat:itemModel.deckFormat
                                                                                                                                                isEasterEgg:itemModel.isEasterEgg];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            case DeckImageRenderServiceItemModelTypeCard: {
                DeckImageRenderServiceCardContentConfiguration *configuration = [[DeckImageRenderServiceCardContentConfiguration alloc] initWithHSCard:itemModel.hsCard
                                                                                                                                           hsCardImage:itemModel.hsCardImage
                                                                                                                                           hsCardCount:itemModel.hsCardCount
                                                                                                                                            raritySlug:itemModel.raritySlug];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            case DeckImageRenderServiceItemModelTypeAbout: {
                DeckImageRenderServiceAboutContentConfiguration *configuration = [[DeckImageRenderServiceAboutContentConfiguration alloc] initWithTotalArcaneDust:itemModel.totalArcaneDust
                                                                                                                                                    hsYearCurrentName:itemModel.hsYearCurrentName];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            case DeckImageRenderServiceItemModelTypeAppName: {
                DeckImageRenderServiceAppNameContentConfiguration *configuration = [DeckImageRenderServiceAppNameContentConfiguration new];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            default:
                break;
        }
    }];
    
    return cellRegistration;
}

@end
