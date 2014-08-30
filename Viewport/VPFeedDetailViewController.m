#import "VPFeedDetailViewController.h"
#import "TKImageLoader.h"
#import "VPFeedDetailPhotoView.h"
#import "VPFeedDetailCommentView.h"
#import "NSTextField+LayoutContraintTag.h"
#import "NS(Attributed)String+Geometrics.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VPFeedDetailViewController ()

@end

@implementation VPFeedDetailViewController

static NSFont *defaultFont;

@synthesize feed, playerView;

+(void)initialize
{
    defaultFont = [NSFont fontWithName:@"Lucida Grande" size:13];
}

-(void)prepare
{
    NSNib *photo = [[NSNib alloc]initWithNibNamed:@"VPFeedDetailPhotoView" bundle:nil];
    [self.tableView registerNib:photo forIdentifier:@"photo"];
    
    NSNib *comment = [[NSNib alloc] initWithNibNamed:@"VPFeedDetailCommentView" bundle:nil];
    [self.tableView registerNib:comment forIdentifier:@"comment"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

-(void)show
{
    [self.tableView reloadData];
}

-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0){
        return 430.0;
    } else {
        
        VPComment *comment = feed.comments.comments[row - 1];
        return 35 + [self getTextHeight:comment];
    }
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return feed.comments.comments.count + 1;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return false;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"obj:%@", [change objectForKey:@"status"]);
}

-(NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"videos:%@", feed.videos.standardResolution.url);
    if (row == 0){
        VPFeedDetailPhotoView *photoView = [tableView makeViewWithIdentifier:@"photo" owner:self];
        if (feed.videos.standardResolution.url != nil) {
            NSURL *url = [NSURL URLWithString:feed.videos.standardResolution.url];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
            [playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
            photoView.playerView.player = [AVPlayer playerWithPlayerItem:playerItem];
            
            self.playerView = photoView.playerView;
            [photoView.imageView setHidden:YES];
            [photoView.playerView setHidden:NO];
        } else {
            TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.images.standardResolution.url]
                                                             imageView:photoView.imageView];
            
            [photoView.imageView setHidden:NO];
            [photoView.playerView setHidden:YES];
            [loader start];
        }
        return photoView;
    } else {
        VPFeedDetailCommentView *commentView = [tableView makeViewWithIdentifier:@"comment" owner:self];
        VPComment *comment = feed.comments.comments[row - 1];
        
        TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString: comment.user.profilePicture]
                                                         imageView:commentView.imageView];
        [loader start];
        commentView.userName.textColor = [NSColor colorWithCalibratedRed:0.19 green:0.36 blue:0.55 alpha:1];
        commentView.userName.stringValue = comment.user.name;
        commentView.imageView.wantsLayer = YES;
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = 3;
        layer.masksToBounds = YES;
        commentView.imageView.layer = layer;
        
        commentView.imageView.target = self;
        commentView.imageView.action = @selector(userProfileDidSelect:);
        
        NSTextField *textView = commentView.textView;
        textView.stringValue = comment.text;
        if (textView.tag) {
            [textView removeConstraints:textView.tag];
        }
        textView.tag =
        [NSLayoutConstraint constraintsWithVisualFormat:[NSString
                                                         stringWithFormat:@"V:[textView(%f)]",
                                                         [self getTextHeight:comment]]
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(textView)];
        [textView addConstraints:textView.tag];
        return commentView;
    }
}

-(IBAction)userProfileDidSelect:(id)sender
{
    if (self.modelDelegate){
        VPFeed *comment = feed.comments.comments[[self.tableView rowForView:sender] - 1];
        [self.modelDelegate modelDidSelect:comment.user];
    }
}

-(CGFloat)getTextHeight:(VPComment *) comment
{
    return [comment.text heightForWidth:360 font:defaultFont];
}

@end