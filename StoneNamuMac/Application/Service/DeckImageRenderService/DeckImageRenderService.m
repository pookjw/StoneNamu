//
//  DeckImageRenderService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import "DeckImageRenderService.h"
#import "NSView+imageRendered.h"
#import "DeckImageRenderServiceModel.h"
#import "DeckImageRenderServiceSeparatorBox.h"
#import "DeckImageRenderServiceCollectionViewLayout.h"
#import "DeckImageRenderServiceIntroCollectionViewItem.h"
#import "DeckImageRenderServiceCardCollectionViewItem.h"
#import "DeckImageRenderServiceAboutCollectionViewItem.h"
#import "DeckImageRenderServiceAppNameCollectionViewItem.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceSeparatorBox = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceSeparatorBox";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceCardCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceCardCollectionViewItem";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceAboutCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceAboutCollectionViewItem";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceAppNameCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceAppNameCollectionViewItem";

@interface DeckImageRenderService ()
@property (retain) NSCollectionView *collectionView;
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

- (void)imageFromLocalDeck:(LocalDeck *)localDeck fromWindow:(nonnull NSWindow *)window completion:(DeckImageRenderServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
        [self.model updateDataSourceWithLocalDeck:localDeck
                                       completion:^(NSUInteger countOfCardItem) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                self.collectionView.frame = NSMakeRect(0.0f, 0.0f, 300.0f, 1313.0f);
                [self.collectionView layoutSubtreeIfNeeded];
                [self.collectionView.collectionViewLayout invalidateLayout];
                NSSize contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
                self.collectionView.frame = NSMakeRect(0.0f, 0.0f, contentSize.width, contentSize.height);
                
                //
                
                NSView *contentView = window.contentView;
                [contentView addSubview:self.collectionView];
                self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:@[
                    [self.collectionView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
                    [self.collectionView.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor],
                    [self.collectionView.widthAnchor constraintEqualToConstant:contentSize.width],
                    [self.collectionView.heightAnchor constraintEqualToConstant:contentSize.height]
                ]];
                
                //
                
                NSImage *image = self.collectionView.imageRendered;
                [self.collectionView removeFromSuperview];
                
                completion(image);
                [semaphore signal];
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

- (void)configureCollectionView {
    NSCollectionView *collectionView = [[NSCollectionView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 1313.0f)];
    
    DeckImageRenderServiceCollectionViewLayout *layout = [DeckImageRenderServiceCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];
    
    NSNib *separatorNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckImageRenderServiceSeparatorBox class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:separatorNib forSupplementaryViewOfKind:NSStringFromClass([DeckImageRenderServiceSeparatorBox class]) withIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceSeparatorBox];
    [separatorNib release];
    
    NSNib *introNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckImageRenderServiceIntroCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:introNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem];
    [introNib release];
    
    NSNib *cardNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckImageRenderServiceCardCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:cardNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceCardCollectionViewItem];
    [cardNib release];
    
    NSNib *aboutNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckImageRenderServiceAboutCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:aboutNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceAboutCollectionViewItem];
    [aboutNib release];
    
    NSNib *appNameNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckImageRenderServiceAppNameCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:appNameNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceAppNameCollectionViewItem];
    [appNameNib release];
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)configureModel {
    DeckImageRenderServiceModel *model = [[DeckImageRenderServiceModel alloc] initWithDataSource:[self makeDataSource]];
    self.model = model;
    [model release];
}

- (DeckImageRenderServiceDataSource *)makeDataSource {
    DeckImageRenderServiceDataSource *dataSource = [[DeckImageRenderServiceDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DeckImageRenderServiceItemModel * _Nonnull itemModel) {
        
        switch (itemModel.type) {
            case DeckImageRenderServiceItemModelTypeIntro: {
                DeckImageRenderServiceIntroCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem forIndexPath:indexPath];
                [item configureWithClassId:itemModel.classId
                                  deckName:itemModel.deckName
                                deckFormat:itemModel.deckFormat
                               isEasterEgg:itemModel.isEasterEgg];
                return item;
            }
            case DeckImageRenderServiceItemModelTypeCard: {
                DeckImageRenderServiceCardCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceCardCollectionViewItem forIndexPath:indexPath];
                [item configureWithHSCard:itemModel.hsCard
                              hsCardImage:itemModel.hsCardImage
                              hsCardCount:itemModel.hsCardCount];
                return item;
            }
            case DeckImageRenderServiceItemModelTypeAbout: {
                DeckImageRenderServiceAboutCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceAboutCollectionViewItem forIndexPath:indexPath];
                [item configureWithTotalArcaneDust:itemModel.totalArcaneDust
                                     hsYearCurrent:itemModel.hsYearCurrent];
                return item;
            }
            case DeckImageRenderServiceItemModelTypeAppName: {
                DeckImageRenderServiceAppNameCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceAppNameCollectionViewItem forIndexPath:indexPath];
                return item;
            }
            default:
                return nil;
        }
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull collectinView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        if ([elementKind isEqualToString:NSStringFromClass([DeckImageRenderServiceSeparatorBox class])]) {
            DeckImageRenderServiceSeparatorBox *view = (DeckImageRenderServiceSeparatorBox *)[collectinView makeSupplementaryViewOfKind:elementKind withIdentifier:NSUserInterfaceItemIdentifierDeckImageRenderServiceSeparatorBox forIndexPath:indexPath];
            return view;
        } else {
            return nil;
        }
    };
    
    return [dataSource autorelease];
}

@end
