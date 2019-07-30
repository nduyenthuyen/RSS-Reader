#import "CustomCell.h"

@implementation CustomCell

@synthesize titleItem = _titleItem;
@synthesize timeItem = _timeItem;
@synthesize imageItem= _imageItem;

-(void)setImage:(UIImage*) uiImage
{
    [self.imageItem setImage:uiImage];
}
- (void)dealloc {
    [_titleItem release];
    [_timeItem release];
    [_imageItem release];
    [super dealloc];
}
@end
