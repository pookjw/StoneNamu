//
//  HSCardPromiseProvider.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import "HSCardPromiseProvider.h"
#import "NSImage+pngData.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@implementation HSCard (Pasteboard)

#pragma mark - NSPasteboardWriting

- (nonnull NSArray<NSPasteboardType> *)writableTypesForPasteboard:(nonnull NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeHSCard];
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSPasteboardType)type pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (id)pasteboardPropertyListForType:(NSPasteboardType)type {
    if ([type isEqualToString:NSPasteboardTypeHSCard]) {
        NSData *hsCardsData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:nil];
        return hsCardsData;
    } else {
        return nil;
    }
}

@end

@interface HSCardPromiseProvider () <NSFilePromiseProviderDelegate>
@property (copy) HSCard *hsCard;
@property (retain) NSImage *image;
@property (retain) NSURL *imageURL;
@property (retain) NSString *imageFileName;
@property (retain) NSOperationQueue *queue;
@end

@implementation HSCardPromiseProvider

+ (NSArray<NSPasteboardType> *)pasteboardTypes {
    return @[NSPasteboardTypeFileURL, NSPasteboardTypePNG, NSPasteboardTypeHSCard];
}

- (instancetype)initWithHSCard:(HSCard *)hsCard image:(NSImage *)image {
    UTType *type = [UTType typeWithFilenameExtension:@"png"];
    
    self = [self initWithFileType:type.identifier delegate:self];
    
    if (self) {
        self.hsCard = hsCard;
        self.image = image;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInteractive;
        [queue release];
        
        //
    
        NSURL *imageURL = [[[NSFileManager.defaultManager temporaryDirectory] URLByAppendingPathComponent:hsCard.slug] URLByAppendingPathExtension:@"png"];
        self.imageURL = imageURL;
        
        self.imageFileName = [[NSURL URLWithString:hsCard.name] URLByAppendingPathExtension:@"png"].path;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_image release];
    [_imageURL release];
    [_imageFileName release];
    [_queue release];
    [super dealloc];
}

- (NSArray<NSPasteboardType> *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return HSCardPromiseProvider.pasteboardTypes;
}

- (id)pasteboardPropertyListForType:(NSPasteboardType)type {
    if ([type isEqualToString:NSPasteboardTypeFileURL]) {
        NSData *imagePNGData = self.image.pngData;
        if ([NSFileManager.defaultManager fileExistsAtPath:self.imageURL.path]) {
            [NSFileManager.defaultManager removeItemAtURL:self.imageURL error:nil];
        }
        [imagePNGData writeToURL:self.imageURL options:NSDataWritingAtomic error:nil];
        return [self.imageURL pasteboardPropertyListForType:NSPasteboardTypeURL];
    } else if ([type isEqualToString:NSPasteboardTypePNG]) {
        return self.image.pngData;
    } else if ([type isEqualToString:NSPasteboardTypeHSCard]) {
        return [self.hsCard pasteboardPropertyListForType:NSPasteboardTypeHSCard];
    } else {
        return [super pasteboardPropertyListForType:type];
    }
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSPasteboardType)type pasteboard:(NSPasteboard *)pasteboard {
    return [super writingOptionsForType:type pasteboard:pasteboard];
}

#pragma mark - NSFilePromiseProviderDelegate

- (nonnull NSString *)filePromiseProvider:(nonnull NSFilePromiseProvider *)filePromiseProvider fileNameForType:(nonnull NSString *)fileType {
    return self.imageFileName;
}

- (void)filePromiseProvider:(nonnull NSFilePromiseProvider *)filePromiseProvider writePromiseToURL:(nonnull NSURL *)url completionHandler:(nonnull void (^)(NSError * _Nullable))completionHandler {
    
    NSError * _Nullable error = nil;
    
    NSURL *newURL = url;
    NSUInteger index = 1;
    
    while ([NSFileManager.defaultManager fileExistsAtPath:newURL.path]) {
        NSString *newName = [url.lastPathComponent stringByAppendingString:[NSString stringWithFormat:@" (%lu)", index]];
        newURL = [[[newURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:newName] URLByAppendingPathExtension:newURL.pathExtension];
        index += 1;
    }
    
    [NSFileManager.defaultManager copyItemAtURL:self.imageURL toURL:newURL error:&error];
    
    completionHandler(error);
}

- (NSOperationQueue *)operationQueueForFilePromiseProvider:(NSFilePromiseProvider *)filePromiseProvider {
    return self.queue;
}

@end
