
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface MainMenu : CCLayer
{
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(void)playGame:(id)sender ;
-(void)howToPlay:(id)sender;
-(void)options:(id)sender;

@end
