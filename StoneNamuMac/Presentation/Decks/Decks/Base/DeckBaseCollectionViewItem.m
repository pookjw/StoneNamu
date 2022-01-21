//
//  DeckBaseCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DeckBaseCollectionViewItem.h"
#import <QuartzCore/QuartzCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckBaseCollectionViewItem ()
@property (retain) IBOutlet NSImageView *cardSetImageView;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSImageView *heroImageView;
@property (retain) CAGradientLayer *heroImageViewGradientLayer;
@property BOOL isEasterEgg;
@property (assign) id<DeckBaseCollectionViewItemDelegate> deckBaseCollectionViewItemDelegate;
@end

@implementation DeckBaseCollectionViewItem

- (void)dealloc {
    [_cardSetImageView release];
    [_nameLabel release];
    [_heroImageView release];
    [_heroImageViewGradientLayer release];
    [_localDeck release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAttributes];
    [self configureHeroImageViewGradientLayer];
    [self bind];
    [self clearContents];
    [self addGesture];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithLocalDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate {
    [self->_localDeck release];
    self->_localDeck = [localDeck retain];
    self.isEasterEgg = isEasterEgg;
    self.deckBaseCollectionViewItemDelegate = deckBaseCollectionViewItemDelegate;
    
    self.cardSetImageView.image = [ResourcesService imageForCardSet:HSCardSetFromNSString(localDeck.format)];
    
    if (isEasterEgg) {
        self.heroImageView.image = [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
    } else {
        self.heroImageView.image = [ResourcesService portraitImageForClassId:self.localDeck.classId.unsignedIntegerValue];
    }
    
    self.nameLabel.stringValue = localDeck.name;
}

- (void)setAttributes {
    self.view.postsFrameChangedNotifications = YES;
    self.heroImageView.wantsLayer = YES;
}

- (void)configureHeroImageViewGradientLayer {
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    imageViewGradientLayer.colors = @[
        (id)[NSColor.whiteColor colorWithAlphaComponent:0.0f].CGColor,
        (id)NSColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    imageViewGradientLayer.endPoint = CGPointMake(0.8f, 0.0f);
    self.heroImageView.layer.mask = imageViewGradientLayer;
    self.heroImageViewGradientLayer = imageViewGradientLayer;
    [imageViewGradientLayer release];
}

- (void)clearContents {
    self.nameLabel.stringValue = @"";
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 2;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.deckBaseCollectionViewItemDelegate deckBaseCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(viewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:self.view];
}

- (void)viewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateGradientLayer];
    }];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.heroImageViewGradientLayer.frame = self.heroImageView.bounds;
    [CATransaction commit];
}

@end
