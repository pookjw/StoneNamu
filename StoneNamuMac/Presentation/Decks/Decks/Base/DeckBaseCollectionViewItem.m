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
@property (retain) IBOutlet NSView *countLabelContainerView;
@property (retain) IBOutlet NSBox *countLabelContainerBox;
@property (retain) IBOutlet NSTextField *countLabel;
@property (retain) CAGradientLayer *heroImageViewGradientLayer;
@property BOOL isEasterEgg;
@property (assign) id<DeckBaseCollectionViewItemDelegate> deckBaseCollectionViewItemDelegate;
@end

@implementation DeckBaseCollectionViewItem

- (void)dealloc {
    [_cardSetImageView release];
    [_nameLabel release];
    [_heroImageView release];
    [_countLabelContainerView release];
    [_countLabelContainerBox release];
    [_countLabel release];
    [_heroImageViewGradientLayer release];
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

- (void)viewDidLayout {
    [super viewDidLayout];
    [self updateCountLabelLayer];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateStates];
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)highlightState {
    [super setHighlightState:highlightState];
    [self updateStates];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithLocalDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count maxCardsCount:(NSUInteger)maxCardsCount deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate {
    self.isEasterEgg = isEasterEgg;
    self.deckBaseCollectionViewItemDelegate = deckBaseCollectionViewItemDelegate;
    
    self.cardSetImageView.image = [ResourcesService imageForDeckFormat:localDeck.format];
    
    if (isEasterEgg) {
        self.heroImageView.image = [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
    } else {
        self.heroImageView.image = [ResourcesService portraitImageForHSCardClassSlugType:classSlug];
    }
    
    NSString *name;
    
    if (localDeck.name == nil) {
        name = @"";
    } else {
        name = localDeck.name;
    }
    self.nameLabel.stringValue = name;
    
    if (count >= maxCardsCount) {
        self.countLabelContainerView.hidden = YES;
    } else {
        self.countLabelContainerView.hidden = NO;
    }
    
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu / %lu", count, maxCardsCount];
    [self updateCountLabelLayer];
    
    [self updateStates];
}

- (void)setAttributes {
    self.view.postsFrameChangedNotifications = YES;
    self.heroImageView.wantsLayer = YES;
    self.countLabelContainerBox.wantsLayer = YES;
    self.countLabelContainerBox.layer.cornerCurve = kCACornerCurveContinuous;
    self.countLabelContainerBox.layer.masksToBounds = YES;
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

- (void)updateCountLabelLayer {
    [self.countLabel sizeToFit];
    [self.countLabelContainerBox layoutSubtreeIfNeeded];
    self.countLabelContainerBox.layer.cornerRadius = self.countLabelContainerBox.frame.size.height / 2.0f;
}

- (void)updateStates {
    if ((self.isSelected) || (self.highlightState == NSCollectionViewItemHighlightForSelection)) {
        self.cardSetImageView.contentTintColor = NSColor.windowBackgroundColor;
        self.countLabelContainerBox.fillColor = NSColor.windowBackgroundColor;
        self.countLabel.textColor = NSColor.controlAccentColor;
    } else {
        self.cardSetImageView.contentTintColor = NSColor.controlAccentColor;
        self.countLabelContainerBox.fillColor = NSColor.controlAccentColor;
        self.countLabel.textColor = NSColor.whiteColor;
    }
}

@end
