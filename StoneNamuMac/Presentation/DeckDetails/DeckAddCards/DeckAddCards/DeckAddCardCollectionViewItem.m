//
//  DeckAddCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180.0f)

@interface DeckAddCardCollectionViewItem ()
@property NSUInteger count;
@property (assign) id<DeckAddCardCollectionViewItemDelegate> delegate;
@property (retain) IBOutlet NSBox *countLabelContainerBox;
@property (retain) IBOutlet NSTextField *countLabel;
@end

@implementation DeckAddCardCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [_countLabelContainerBox release];
    [_countLabel release];
    [super dealloc];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    [self drawShapeToCountLabelContainerBox];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAttributes];
    [self addGesture];
    [self bind];
}

- (void)configureWithHSCard:(HSCard *)hsCard count:(NSUInteger)count delegate:(nonnull id<DeckAddCardCollectionViewItemDelegate>)delegate {
    [self->_hsCard release];
    self->_hsCard = [hsCard copy];
    self.count = count;
    self.delegate = delegate;
    
    [self updateCountLabel];
    [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
}

- (void)setAttributes {
    self.countLabelContainerBox.wantsLayer = YES;
    self.appearanceTypes = ClickableCollectionViewItemAppearanceTypeClicked | ClickableCollectionViewItemAppearanceTypeHighlighted;
    self.countLabelContainerBox.postsFrameChangedNotifications = YES;
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 1;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegate deckAddCardCollectionViewItem:self didClickWithRecognizer:sender];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(countLabelContainerBoxDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:self.countLabelContainerBox];
}

- (void)countLabelContainerBoxDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self drawShapeToCountLabelContainerBox];
    }];
}

- (void)updateCountLabel {
    int maxCount;
    
    if (self.hsCard.rarityId == HSCardRarityLegendary) {
        maxCount = HSDECK_MAX_SINGLE_LEGENDARY_CARD;
    } else {
        maxCount = HSDECK_MAX_SINGLE_CARD;
    }
    
    //
    
    if (self.count > 0) {
        self.countLabelContainerBox.layer.opacity = 1.0f;
    } else {
        self.countLabelContainerBox.layer.opacity = 0.0f;
    }
    
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu / %d", self.count, maxCount];
}

- (void)drawShapeToCountLabelContainerBox {
    CGRect rect = self.countLabelContainerBox.bounds;
    CGSize size = rect.size;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat arrowHeight = 5.0f;
    CGFloat arrowSideLength = arrowHeight * (1.0f / cos(DEGREES_TO_RADIANS(30)));
    CGFloat radius = (size.height - arrowHeight) / 2.0f;
    CGPoint leftCenter = CGPointMake(radius, radius);
    CGPoint rightCenter = CGPointMake(size.width - radius, leftCenter.y);
    
    CGPathMoveToPoint(path, NULL, leftCenter.x, leftCenter.y + radius);
    CGPathAddLineToPoint(path, NULL, ((size.width - arrowSideLength) / 2.0f), (leftCenter.y + radius));
    CGPathAddLineToPoint(path, NULL, (size.width / 2.0f), rect.size.height);
    CGPathAddLineToPoint(path, NULL, ((size.width + arrowSideLength) / 2.0f), (rightCenter.y + radius));
    CGPathAddLineToPoint(path, NULL, rightCenter.x, (rightCenter.y + radius));
    
    CGPathAddArc(path, NULL, rightCenter.x, rightCenter.y, radius, DEGREES_TO_RADIANS(270.0f), DEGREES_TO_RADIANS(0.0f), true);
    CGPathAddArc(path, NULL, rightCenter.x, rightCenter.y, radius, DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(90.0f), true);
    
    CGPathAddLineToPoint(path, NULL, rightCenter.x, (rightCenter.y - radius));
    CGPathAddLineToPoint(path, NULL, leftCenter.x, (leftCenter.y - radius));
    
    CGPathAddArc(path, NULL, leftCenter.x, leftCenter.y, radius, DEGREES_TO_RADIANS(90.0f), DEGREES_TO_RADIANS(180.0f), true);
    CGPathAddArc(path, NULL, leftCenter.x, leftCenter.y, radius, DEGREES_TO_RADIANS(180.0f), DEGREES_TO_RADIANS(270.0f), true);
    
    CGPathAddLineToPoint(path, NULL, leftCenter.x, (leftCenter.y + radius));
    
    CGPathCloseSubpath(path);
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = path;
    CGPathRelease(path);
    
    self.countLabelContainerBox.layer.mask = mask;
    [mask release];
}

@end
