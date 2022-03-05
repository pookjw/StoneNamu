//
//  CardBacksViewController.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksViewController.h"
#import "CardBacksContentConfiguration.h"
#import "CardBacksViewModel.h"

@interface CardBacksViewController ()
@property (retain) id collectionView;
@property (retain) CardBacksViewModel *viewModel;
@end

@implementation CardBacksViewController

- (instancetype)init {
    id layout = [[NSClassFromString(@"UICollectionViewFlowLayout") alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    self = [super initWithCollectionViewLayout:layout];
    [layout release];
    
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewModel];
    [self bind];
    [self.viewModel requestDataSourceWithOptions:nil reset:YES];
}

- (void)configureViewModel {
    CardBacksViewModel *viewModel = [[CardBacksViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (id)makeDataSource {
    id cellRegistration = [self makeCellRegistration];
    
    id dataSource = [[NSClassFromString(@"UICollectionViewDiffableDataSource") alloc] initWithCollectionView:self.collectionView
                                                                                                cellProvider:^id _Nullable(id collectionView, NSIndexPath *indexPath, id itemIdentifier) {
        id cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration
                                                                   forIndexPath:indexPath
                                                                           item:itemIdentifier];
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (id)makeCellRegistration {
    id cellRegistration = [NSClassFromString(@"UICollectionViewCellRegistration") registrationWithCellClass:NSClassFromString(@"UICollectionViewCell")
                                                                                       configurationHandler:^(id cell, NSIndexPath *indexPath, id item){
        if (![item isKindOfClass:[CardBacksItemModel class]]) {
            return;
        }
        
        CardBacksItemModel *itemModel = (CardBacksItemModel *)item;
        
        CardBacksContentConfiguration *configuration = [[CardBacksContentConfiguration alloc] initWithHSCardBack:itemModel.hsCardBack];
        
        [cell setContentConfiguration:configuration];
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(id)collectionView layout:(id)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize contentSize = ^CGSize(void) {
        CGSize contentSize;

        SEL sel = NSSelectorFromString(@"contentSize");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSClassFromString(@"PUICCollectionView") instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = collectionView;
        [invocation invoke];
        [invocation getReturnValue:&contentSize];
        return contentSize;
    }();

    CGFloat width = (contentSize.width / 2.0f);
    CGFloat height = (width * (242.0f / 198.0f));

    return CGSizeMake(width, height);
}

@end
