#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>

@interface VPFeedDetailPhotoView : NSView

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet AVPlayerView *playerView;

@end
