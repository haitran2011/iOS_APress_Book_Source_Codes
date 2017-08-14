//
// From the book Pro Core Data for iOS, 2nd Edition
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//


#import "UIColorTransformer.h"

@implementation UIColorTransformer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

+ (Class)transformedValueClass {
  return [NSData class];
}

- (id)transformedValue:(id)value {
  UIColor* color = (UIColor *)value;
  const CGFloat *components = CGColorGetComponents(color.CGColor);
  
  NSString* result = [NSString stringWithFormat:@"%f,%f,%f", components[0], components[1], components[2]];
  return [result dataUsingEncoding:[NSString defaultCStringEncoding]];
}

- (id)reverseTransformedValue:(id)value {
  NSString *string = [[NSString alloc] initWithData:value
                                           encoding:[NSString defaultCStringEncoding]];
  
  NSArray *components = [string componentsSeparatedByString:@","];
  CGFloat red = [[components objectAtIndex:0] floatValue];
  CGFloat green = [[components objectAtIndex:1] floatValue];
  CGFloat blue = [[components objectAtIndex:2] floatValue];
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
