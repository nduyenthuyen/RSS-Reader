
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 *
 *    Customcell with 3 item in table_cell : title, time and picture.
 *
 */@interface CustomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleItem;
@property (retain, nonatomic) IBOutlet UILabel *timeItem;
@property (retain, nonatomic) IBOutlet UIImageView *imageItem;
-(void)setImage:(UIImage*) uiImage;

@end
