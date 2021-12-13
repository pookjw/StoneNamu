//
//  DeckDetailsManaCostGraphCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsManaCostGraphCollectionViewItem.h"

@interface DeckDetailsManaCostGraphCollectionViewItem ()
@property (retain) IBOutlet NSView *containerView;
@property (retain) IBOutlet NSLayoutConstraint *containreViewHeightConstraint;
@property (retain) IBOutlet NSView *costContainerView;
@property (retain) IBOutlet NSLayoutConstraint *costContainerWidthConstraint;
@property (retain) IBOutlet NSTextField *costLabel;
@property (retain) IBOutlet NSLevelIndicator *levelIndicator;
@property (retain) IBOutlet NSView *countContainerView;
@property (retain) IBOutlet NSLayoutConstraint *countContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *countLabel;
@end

@implementation DeckDetailsManaCostGraphCollectionViewItem

- (void)dealloc {
    [_containerView release];
    [_containreViewHeightConstraint release];
    [_costContainerView release];
    [_costContainerWidthConstraint release];
    [_costLabel release];
    [_levelIndicator release];
    [_countContainerView release];
    [_countContainerViewWidthConstraint release];
    [_countLabel release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAttributes];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)configureWithManaCost:(NSUInteger)manaCost percentage:(float)percentage cardCount:(NSUInteger)cardCount {
    self.costLabel.stringValue = [NSString stringWithFormat:@"%lu", manaCost];
    self.levelIndicator.floatValue = percentage;
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", cardCount];
}

- (void)setAttributes {
    
}

- (void)clearContents {
    self.costLabel.stringValue = @"";
    self.levelIndicator.floatValue = 0.0f;
    self.countLabel.stringValue = @"";
}

@end
