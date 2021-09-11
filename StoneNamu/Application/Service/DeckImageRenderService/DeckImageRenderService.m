//
//  DeckImageRenderService.m
//  DeckImageRenderService
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderService.h"
#import "UIView+imageRendered.h"
#import "DeckImageRenderServiceModel.h"
#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "NSSemaphoreCondition.h"

@interface DeckImageRenderService ()
@property (retain) UICollectionView *collectionView;
@property (retain) DeckImageRenderServiceModel *model;
@property (retain) NSOperationQueue *queue;
@end

@implementation DeckImageRenderService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
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
        [self.model updateDataSourceWithHSCards:localDeck.cards
                                       deckName:localDeck.name
                                        classId:localDeck.classId.unsignedIntegerValue
                                     deckFormat:localDeck.format
                                     completion:^(NSUInteger countOfCardItem){
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView layoutIfNeeded];
                [self.collectionView.collectionViewLayout invalidateLayout];
                self.collectionView.frame = CGRectMake(0, 0, 300, self.collectionView.contentSize.height);
                
                [self.queue addBarrierBlock:^{
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        UIImage *image = self.collectionView.imageRendered;
                        completion(image);
                    }];
                }];
            }];
        }];
    }];
}

- (void)imageFromHSDeck:(HSDeck *)hsDeck completion:(DeckImageRenderServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        [self.model updateDataSourceWithHSCards:hsDeck.cards
                                       deckName:hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsDeck.classId)]
                                        classId:hsDeck.classId
                                     deckFormat:hsDeck.format
                                     completion:^(NSUInteger countOfCardItem){
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView layoutIfNeeded];
                [self.collectionView.collectionViewLayout invalidateLayout];
                self.collectionView.frame = CGRectMake(0, 0, 300, self.collectionView.contentSize.height);
                
                [self.queue addBarrierBlock:^{
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        UIImage *image = self.collectionView.imageRendered;
                        completion(image);
                    }];
                }];
            }];
        }];
    }];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
    layoutConfiguration.backgroundColor = UIColor.clearColor;
    
    UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearancePlain];
    separatorConfiguration.topSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.color = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    layoutConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 1) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.blackColor;
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
                UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
                configuration.text = itemModel.deckName;
                cell.contentConfiguration = configuration;
                break;
            }
            case DeckImageRenderServiceItemModelTypeInfo: {
                UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
                configuration.text = itemModel.deckFormat;
                cell.contentConfiguration = configuration;
                break;
            }
            case DeckImageRenderServiceItemModelTypeCard: {
                DeckImageRenderServiceCardContentConfiguration *configuration = [[DeckImageRenderServiceCardContentConfiguration alloc] initWithHSCard:itemModel.hsCard
                                                                                                                                           hsCardImage:itemModel.hsCardImage
                                                                                                                                           hsCardCount:itemModel.hsCardCount];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            case DeckImageRenderServiceItemModelTypeAbout: {
                UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
                configuration.text = @"StoneNamu";
                cell.contentConfiguration = configuration;
                break;
            }
            default:
                break;
        }
    }];
    
    return cellRegistration;
}

@end
