//
//  DeckDetailsCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsCardCollectionViewItem.h"
#import <QuartzCore/QuartzCore.h>
#import "NSImageView+setAsyncImage.h"

@interface DeckDetailsCardCollectionViewItem ()
@property (assign) IBOutlet NSView *containerView;
@property (retain) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (retain) IBOutlet NSView *manaCostContainerView;
@property (retain) IBOutlet NSLayoutConstraint *manaCostContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *manaCostLabel;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSView *countContainerView;
@property (retain) IBOutlet NSLayoutConstraint *countContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *countLabel;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@end

@implementation DeckDetailsCardCollectionViewItem

- (void)dealloc {
    [_containerViewHeightConstraint release];
    [_manaCostContainerView release];
    [_manaCostContainerViewWidthConstraint release];
    [_manaCostLabel release];
    [_nameLabel release];
    [_countContainerView release];
    [_countContainerViewWidthConstraint release];
    [_countLabel release];
    [_imageViewGradientLayer release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureImageViewGradientLayer];
    [self setAttributes];
    [self bind];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithHSCard:(HSCard *)hsCard hsCardCount:(NSUInteger)hsCardCount {
    self.manaCostLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCard.manaCost];
    self.nameLabel.stringValue = hsCard.name;
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCardCount];
    [self.imageView setAsyncImageWithURL:hsCard.cropImage indicator:YES];
}

- (void)configureImageViewGradientLayer {
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    self.imageViewGradientLayer = imageViewGradientLayer;
    imageViewGradientLayer.colors = @[
        (id)[NSColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)NSColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
    self.imageView.wantsLayer = YES;
    self.imageView.layer.mask = imageViewGradientLayer;
    [imageViewGradientLayer release];
}


- (void)setAttributes {
    self.manaCostContainerView.wantsLayer = YES;
    self.manaCostContainerView.layer.backgroundColor = NSColor.systemBlueColor.CGColor;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(containerViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:self.containerView];
}

- (void)containerViewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateGradientLayer];
    }];
}

- (void)clearContents {
    self.manaCostLabel.stringValue = @"";
    self.nameLabel.stringValue = @"";
    self.countLabel.stringValue = @"";
    self.imageView.image = nil;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

@end
