#import "RSSEntity.h"

@implementation RSSEntity

-(id)init
{
    if ((self = [super init])) {
        _articleUrl = [[NSMutableString alloc] init];
        _articleTitle = [[NSMutableString alloc] init];
        _articleDate = [[NSMutableString alloc] init];
        _srcImage = [[NSMutableString alloc] init];
    }
    return self;
}

-(void) setArticleTitle:(NSString*) articleTitle{
    [_articleTitle appendFormat:@"%@",articleTitle];
}
-(NSMutableString*) articleTitle{
    return _articleTitle;
}

-(void) setArticleUrl:(NSString*) articleUrl{
    [_articleUrl appendFormat:@"%@",articleUrl];
}
-(NSMutableString*) articleUrl{
    return _articleUrl;
}
-(void) changeArticleUrl:(NSString*) articleUrl{
    [_articleUrl setString:articleUrl];
}

-(void) setSrcImage:(NSString*) srcImage{
    [_srcImage appendFormat:@"%@",srcImage];
}
-(NSMutableString*) srcImage{
    return _srcImage;
}
-(void) changeSrcImage:(NSString*) srcImage{
    [_srcImage setString:srcImage];
}


-(void) setArticleDate:(NSString*) articleDate{
    [_articleDate appendFormat:@"%@",articleDate];
}
-(NSMutableString*) articleDate{
    return _articleDate;
}

-(void) clearEntityData{
    [_articleTitle setString:@""];
    [_articleUrl setString:@""];
    [_articleDate setString:@""];
    [_srcImage setString:@""];
}


- (void)dealloc {
    
    [_articleTitle release];
    _articleTitle = nil;
    [_articleUrl release];
    _articleUrl = nil;
    [_articleDate release];
    _articleDate = nil;
    [_srcImage release];
    _srcImage = nil;
    [super dealloc];
}
@end
