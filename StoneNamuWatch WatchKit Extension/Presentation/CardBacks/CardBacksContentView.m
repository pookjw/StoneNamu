//
//  CardBacksContentView.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksContentView.h"

@interface CardBacksContentView ()
@property (retain) id imageView;
@end

@implementation CardBacksContentView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureImageView];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_imageView release];
    [super dealloc];
}

- (void)setConfiguration:(CardBacksContentConfiguration *)configuration {
    [self willChangeValueForKey:@"configuration"];
    [self->_configuration release];
    self->_configuration = [configuration copy];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSURLSessionTask *task = [session dataTaskWithURL:configuration.hsCardBack.image completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id image = [[UIImage alloc] initWithData:data];
        if (error) {
            NSLog(@"%@", error);
        }
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.imageView setImage:image];
        }];
    }];
    [task resume];
    [session finishTasksAndInvalidate];
    
    [self didChangeValueForKey:@"configuration"];
}

- (void)configureImageView {
    id imageView = [NSClassFromString(@"UIImageView") new];
    [imageView setContentMode:1]; // UIViewContentModeScaleAspectFit
    [self addSubview:imageView];
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSClassFromString(@"NSLayoutConstraint") activateConstraints:@[
        [[imageView topAnchor] constraintEqualToAnchor:[self topAnchor]],
        [[imageView trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
        [[imageView leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
        [[imageView bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
    ]];
    [imageView setBackgroundColor:UIColor.clearColor];
    
    self.imageView = imageView;
    [imageView release];
}

@end
