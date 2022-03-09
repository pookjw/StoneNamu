//
//  CardBacksController.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import "CardBacksController.h"
#import "CardBacksViewModel.h"
#import "ActivityIndicatorService.h"
#import "ImageViewAsyncService.h"

@interface CardBacksController ()
@property (retain) id viewController;
@property (retain) ActivityIndicatorService *activityIndicatorService;
@property (retain) ImageViewAsyncService *imageViewAsyncService;
@property (retain) CardBacksViewModel *viewModel;
@end

@implementation CardBacksController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureViewController];
        [self configureActivityIndicatorService];
        [self configureImageViewAsyncService];
        [self configureViewModel];
        [self bind];
        [self.viewModel requestDataSourceWithOptions:nil reset:YES];
    }
    
    return self;
}

- (void)dealloc {
    [_viewController release];
    [_activityIndicatorService release];
    [_imageViewAsyncService release];
    [_viewModel release];
    [super dealloc];
}

- (void)push {
    id application = [NSClassFromString(@"SPApplication") sharedApplication];
    id delegate = [application delegate];
    id window = [delegate window];
    id rootViewController = [window rootViewController];
    
    NSArray *viewControllers = [(NSArray *)[rootViewController viewControllers] arrayByAddingObject:self.viewController];
    [rootViewController setViewControllers:viewControllers animated:NO];
    [self retain];
}

- (void)pop {
    id application = [NSClassFromString(@"SPApplication") sharedApplication];
    id delegate = [application delegate];
    id window = [delegate window];
    id rootViewController = [window rootViewController];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![self isEqual:evaluatedObject];
    }];
    NSArray *viewControllers = [(NSArray *)[rootViewController viewControllers] filteredArrayUsingPredicate:predicate];
    [rootViewController setViewControllers:viewControllers animated:NO];
    [self release];
}

- (void)configureViewController {
    id layout = [[NSClassFromString(@"UICollectionViewFlowLayout") alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    id viewController = [[NSClassFromString(@"PUICCollectionViewController") alloc] initWithCollectionViewLayout:layout];
    [layout release];
    
    [[viewController collectionView] setDelegate:self];
    
    self.viewController = viewController;
    [viewController release];
}

- (void)configureActivityIndicatorService {
    ActivityIndicatorService *activityIndicatorService = [ActivityIndicatorService new];
    self.activityIndicatorService = activityIndicatorService;
    [activityIndicatorService release];
}

- (void)configureImageViewAsyncService {
    ImageViewAsyncService *imageViewAsyncService = [ImageViewAsyncService new];
    self.imageViewAsyncService = imageViewAsyncService;
    [imageViewAsyncService release];
}

- (void)configureViewModel {
    CardBacksViewModel *viewModel = [[CardBacksViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (id)makeDataSource {
    id cellRegistration = [self makeCellRegistration];
    
    id dataSource = [[NSClassFromString(@"UICollectionViewDiffableDataSource") alloc] initWithCollectionView:[self.viewController collectionView]
                                                                                                cellProvider:^id _Nullable(id collectionView, NSIndexPath *indexPath, id itemIdentifier) {
        id cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration
                                                                   forIndexPath:indexPath
                                                                           item:itemIdentifier];
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (id)makeCellRegistration {
    CardBacksController * __block unretainedSelf = self;
    
    id cellRegistration = [NSClassFromString(@"UICollectionViewCellRegistration") registrationWithCellClass:NSClassFromString(@"UICollectionViewCell")
                                                                                       configurationHandler:^(id cell, NSIndexPath *indexPath, id item){
        if (![item isKindOfClass:[CardBacksItemModel class]]) {
            return;
        }
        
        CardBacksItemModel *itemModel = (CardBacksItemModel *)item;
        
        id _Nullable __block imageView = nil;
        
        [(NSArray *)[cell subviews] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UIImageView")]) {
                imageView = [obj retain];
                *stop = YES;
            }
        }];
        
        if (imageView == nil) {
            imageView = [NSClassFromString(@"UIImageView") new];
            [imageView setContentMode:1]; // UIViewContentModeScaleAspectFit
            [cell addSubview:imageView];
            
            [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSClassFromString(@"NSLayoutConstraint") activateConstraints:@[
                [[imageView topAnchor] constraintEqualToAnchor:[cell topAnchor]],
                [[imageView trailingAnchor] constraintEqualToAnchor:[cell trailingAnchor]],
                [[imageView leadingAnchor] constraintEqualToAnchor:[cell leadingAnchor]],
                [[imageView bottomAnchor] constraintEqualToAnchor:[cell bottomAnchor]]
            ]];
            [imageView setBackgroundColor:UIColor.clearColor];
        }
        
        [unretainedSelf.imageViewAsyncService setAsyncImageToImageView:imageView withURL:itemModel.hsCardBack.image indicator:YES];
        
        [imageView release];
    }];
    
    return cellRegistration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)startedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.activityIndicatorService showActivityIndicatorViewOnView:[self.viewController view] superviewIfNeeded:YES];
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.activityIndicatorService removeActivityIndicatorViewFromView:[self.viewController view] superviewIfNeeded:YES];
    }];
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

- (void)collectionView:(id)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

- (void)scrollViewDidEndDecelerating:(id)scrollView {
    CGSize contentSize = ^CGSize(void) {
        CGSize contentSize;

        SEL sel = NSSelectorFromString(@"contentSize");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSClassFromString(@"PUICCollectionView") instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = scrollView;
        [invocation invoke];
        [invocation getReturnValue:&contentSize];
        return contentSize;
    }();
    
    CGPoint contentOffset = ^CGPoint(void) {
        CGPoint contentOffset;

        SEL sel = NSSelectorFromString(@"contentOffset");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSClassFromString(@"PUICCollectionView") instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = scrollView;
        [invocation invoke];
        [invocation getReturnValue:&contentOffset];
        return contentOffset;
    }();
    
    CGRect bounds = ^CGRect(void) {
        CGRect bounds;

        SEL sel = NSSelectorFromString(@"bounds");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSClassFromString(@"PUICCollectionView") instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = scrollView;
        [invocation invoke];
        [invocation getReturnValue:&bounds];
        return bounds;
    }();
    
    if ((contentOffset.y + bounds.size.height) >= (contentSize.height)) {
        [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
    }
}

@end
