//
// From the book Pro Core Data for iOS
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//

#import "Note.h"
#import "NSData+Encryption.h"

@implementation Note 

@synthesize password;

@dynamic title;
@dynamic body;

-(void)setText:(NSString*)_text {
  text = [_text copy];
  
  if(text == nil) {
    self.body = nil;
    return;
  }
  
  NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
  
  self.body = [data encryptWithKey:self.password];
}

-(NSString*)text {
  if(text == nil) {
    NSData *data = self.body;
    if(data == nil) return nil;
    
    data = [data decryptWithKey:self.password];
    
    NSString *_text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    text = [_text copy];
    [_text release];
  }
  
  return text;
}

@end
