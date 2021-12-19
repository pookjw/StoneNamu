//
//  DeckDetailsManaCostGraphView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import "DeckDetailsManaCostGraphView.h"
#import "DeckDetailsManaCostGraphBaseView.h"

@interface DeckDetailsManaCostGraphView ()
@property (retain) NSVisualEffectView *blurView;
@property (retain) NSStackView *stackView;

@property (retain) DeckDetailsManaCostGraphBaseView *zeroBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *oneBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *twoBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *threeBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *fourBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *fiveBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *sixBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *sevenBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *eightBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *nineBaseView;
@property (retain) DeckDetailsManaCostGraphBaseView *tenBaseView;
@end

@implementation DeckDetailsManaCostGraphView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureBlurView];
        [self configureStackView];
        [self configureBaseViews];
    }
    
    return self;
}

- (void)dealloc {
    [_blurView release];
    [_stackView release];
    [_zeroBaseView release];
    [_twoBaseView release];
    [_threeBaseView release];
    [_fourBaseView release];
    [_fiveBaseView release];
    [_sixBaseView release];
    [_sevenBaseView release];
    [_eightBaseView release];
    [_nineBaseView release];
    [_tenBaseView release];
    [super dealloc];
}

- (NSSize)intrinsicContentSize {
    return NSMakeSize(300.0f, 100.0f);
}

- (void)configureWithDatas:(NSArray<DeckDetailsManaCostGraphData *> *)datas {
    [datas enumerateObjectsUsingBlock:^(DeckDetailsManaCostGraphData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.manaCost) {
            case 0:
                [self.zeroBaseView configureWithData:obj];
                break;
            case 1:
                [self.oneBaseView configureWithData:obj];
                break;
            case 2:
                [self.twoBaseView configureWithData:obj];
                break;
            case 3:
                [self.threeBaseView configureWithData:obj];
                break;
            case 4:
                [self.fourBaseView configureWithData:obj];
                break;
            case 5:
                [self.fiveBaseView configureWithData:obj];
                break;
            case 6:
                [self.sixBaseView configureWithData:obj];
                break;
            case 7:
                [self.sevenBaseView configureWithData:obj];
                break;
            case 8:
                [self.eightBaseView configureWithData:obj];
                break;
            case 9:
                [self.nineBaseView configureWithData:obj];
                break;
            case 10:
                [self.tenBaseView configureWithData:obj];
                break;
            default:
                break;
        }
    }];
}

- (void)configureBlurView {
    NSVisualEffectView *blurView = [NSVisualEffectView new];
    self.blurView = blurView;
    
    [self addSubview:blurView];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    blurView.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    
    [NSLayoutConstraint activateConstraints:@[
        [blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [blurView release];
}

- (void)configureStackView {
    NSStackView *stackView = [NSStackView new];
    self.stackView = stackView;
    
    stackView.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.distribution = NSStackViewDistributionFillEqually;
    
    [self.blurView addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.blurView.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.blurView.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.blurView.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.blurView.bottomAnchor]
    ]];
    
    [stackView release];
}

- (void)configureBaseViews {
    DeckDetailsManaCostGraphBaseView *zeroBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.zeroBaseView = zeroBaseView;
    [self.stackView addArrangedSubview:zeroBaseView];
    [zeroBaseView release];
    
    DeckDetailsManaCostGraphBaseView *oneBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.oneBaseView = oneBaseView;
    [self.stackView addArrangedSubview:oneBaseView];
    [oneBaseView release];
    
    DeckDetailsManaCostGraphBaseView *twoBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.twoBaseView = twoBaseView;
    [self.stackView addArrangedSubview:twoBaseView];
    [twoBaseView release];
    
    DeckDetailsManaCostGraphBaseView *threeBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.threeBaseView = threeBaseView;
    [self.stackView addArrangedSubview:threeBaseView];
    [threeBaseView release];
    
    DeckDetailsManaCostGraphBaseView *fourBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.fourBaseView = fourBaseView;
    [self.stackView addArrangedSubview:fourBaseView];
    [fourBaseView release];
    
    DeckDetailsManaCostGraphBaseView *fiveBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.fiveBaseView = fiveBaseView;
    [self.stackView addArrangedSubview:fiveBaseView];
    [fiveBaseView release];
    
    DeckDetailsManaCostGraphBaseView *sixBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.sixBaseView = sixBaseView;
    [self.stackView addArrangedSubview:sixBaseView];
    [sixBaseView release];
    
    DeckDetailsManaCostGraphBaseView *sevenBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.sevenBaseView = sevenBaseView;
    [self.stackView addArrangedSubview:sevenBaseView];
    [sevenBaseView release];
    
    DeckDetailsManaCostGraphBaseView *eightBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.eightBaseView = eightBaseView;
    [self.stackView addArrangedSubview:eightBaseView];
    [eightBaseView release];
    
    DeckDetailsManaCostGraphBaseView *nineBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.nineBaseView = nineBaseView;
    [self.stackView addArrangedSubview:nineBaseView];
    [nineBaseView release];
    
    DeckDetailsManaCostGraphBaseView *tenBaseView = [DeckDetailsManaCostGraphBaseView new];
    self.tenBaseView = tenBaseView;
    [self.stackView addArrangedSubview:tenBaseView];
    [tenBaseView release];
}

@end