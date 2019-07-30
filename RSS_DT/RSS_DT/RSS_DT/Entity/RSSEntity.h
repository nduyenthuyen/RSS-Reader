#import <Foundation/Foundation.h>
@interface RSSEntity : NSObject {
    NSMutableString *_articleTitle;
    NSMutableString *_articleUrl;
    NSMutableString *_srcImage;
    NSMutableString *_articleDate;
}

-(void) setArticleTitle:(NSString*) articleTitle;
-(NSMutableString*) articleTitle;

-(void) setArticleUrl:(NSString*) articleUrl;
-(NSMutableString*) articleUrl;
-(void) changeArticleUrl:(NSString*) articleUrl;

-(void) setSrcImage:(NSString*) srcImage;
-(NSMutableString*) srcImage;
-(void) changeSrcImage:(NSString*) srcImage;

-(void) setArticleDate:(NSString*) articleDate;
-(NSMutableString*) articleDate;

-(void) clearEntityData;

@end
