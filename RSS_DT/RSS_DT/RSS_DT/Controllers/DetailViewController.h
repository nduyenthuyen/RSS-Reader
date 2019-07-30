#import <UIKit/UIKit.h>
#import "RSSEntity.h"
@interface DetailViewController : UIViewController
{
    RSSEntity *_entity;
}
@property (retain) RSSEntity *entity;
@property (copy, nonatomic) NSString *url;
@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end

