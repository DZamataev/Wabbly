//
//  NSString+HTML.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSString+WAAdditions.h"
#import "GTMNSString+HTML.h"

@implementation NSString (WAAdditions)

#pragma mark - Instance Methods

- (NSString *)wa_stringByConvertingHTMLToPlainText {
    @autoreleasepool {
	
        // Character sets
        NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        
        // Scan and find all tags
        NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
        NSScanner *scanner = [[NSScanner alloc] initWithString:self];
        [scanner setCharactersToBeSkipped:nil];
        [scanner setCaseSensitive:YES];
        NSString *str = nil, *tagName = nil;
        BOOL dontReplaceTagWithSpace = NO;
        do {
            
            // Scan up to the start of a tag or whitespace
            if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
                [result appendString:str];
                str = nil; // reset
            }
            
            // Check if we've stopped at a tag/comment or whitespace
            if ([scanner scanString:@"<" intoString:NULL]) {
                
                // Stopped at a comment or tag
                if ([scanner scanString:@"!--" intoString:NULL]) {
                    
                    // Comment
                    [scanner scanUpToString:@"-->" intoString:NULL]; 
                    [scanner scanString:@"-->" intoString:NULL];
                    
                } else {
                    
                    // Tag - remove and replace with space unless it's
                    // a closing inline tag then dont replace with a space
                    if ([scanner scanString:@"/" intoString:NULL]) {
                        
                        // Closing tag - replace with space unless it's inline
                        tagName = nil; dontReplaceTagWithSpace = NO;
                        if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
                            tagName = [tagName lowercaseString];
                            dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                                       [tagName isEqualToString:@"b"] ||
                                                       [tagName isEqualToString:@"i"] ||
                                                       [tagName isEqualToString:@"q"] ||
                                                       [tagName isEqualToString:@"span"] ||
                                                       [tagName isEqualToString:@"em"] ||
                                                       [tagName isEqualToString:@"strong"] ||
                                                       [tagName isEqualToString:@"cite"] ||
                                                       [tagName isEqualToString:@"abbr"] ||
                                                       [tagName isEqualToString:@"acronym"] ||
                                                       [tagName isEqualToString:@"label"]);
                        }
                        
                        // Replace tag with string unless it was an inline
                        if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                        
                    }
                    
                    // Scan past tag
                    [scanner scanUpToString:@">" intoString:NULL];
                    [scanner scanString:@">" intoString:NULL];
                    
                }
                
            } else {
                
                // Stopped at whitespace - replace all whitespace and newlines with a space
                if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                    if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
                }
                
            }
            
        } while (![scanner isAtEnd]);
        
        // Cleanup
        
        // Decode HTML entities and return
        NSString *retString = [result wa_stringByDecodingHTMLEntities];

        // Return
        return retString;
            
    }
}

- (NSString *)wa_stringByDecodingHTMLEntities {
    // Can return self so create new string if we're a mutable string
    return [NSString stringWithString:[self gtm_stringByUnescapingFromHTML]];
}


- (NSString *)wa_stringByEncodingHTMLEntities {
    // Can return self so create new string if we're a mutable string
    return [NSString stringWithString:[self gtm_stringByEscapingForAsciiHTML]];
}

- (NSString *)wa_stringByEncodingHTMLEntities:(BOOL)isUnicode {
    // Can return self so create new string if we're a mutable string
    return [NSString stringWithString:(isUnicode ? [self gtm_stringByEscapingForHTML] : [self gtm_stringByEscapingForAsciiHTML])];
}

- (NSString *)wa_stringWithNewLinesAsBRs {
	@autoreleasepool {
        
        // Strange New lines:
        //	Next Line, U+0085
        //	Form Feed, U+000C
        //	Line Separator, U+2028
        //	Paragraph Separator, U+2029
        
        // Scanner
        NSScanner *scanner = [[NSScanner alloc] initWithString:self];
        [scanner setCharactersToBeSkipped:nil];
        NSMutableString *result = [[NSMutableString alloc] init];
        NSString *temp;
        NSCharacterSet *newLineCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                             [NSString stringWithFormat:@"\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        // Scan
        do {
            
            // Get non new line characters
            temp = nil;
            [scanner scanUpToCharactersFromSet:newLineCharacters intoString:&temp];
            if (temp) [result appendString:temp];
            temp = nil;
            
            // Add <br /> s
            if ([scanner scanString:@"\r\n" intoString:nil]) {
                
                // Combine \r\n into just 1 <br />
                [result appendString:@"<br />"];
                
            } else if ([scanner scanCharactersFromSet:newLineCharacters intoString:&temp]) {
                
                // Scan other new line characters and add <br /> s
                if (temp) {
                    for (NSUInteger i = 0; i < temp.length; i++) {
                        [result appendString:@"<br />"];
                    }
                }
                
            }
            
        } while (![scanner isAtEnd]);
        
        // Cleanup & return
        NSString *retString = [NSString stringWithString:result];

        // Return
        return retString;
        
	}
}

- (NSString *)wa_stringByRemovingNewLinesAndWhitespace {
	@autoreleasepool {
        
        // Strange New lines:
        //	Next Line, U+0085
        //	Form Feed, U+000C
        //	Line Separator, U+2028
        //	Paragraph Separator, U+2029
        
        // Scanner
        NSScanner *scanner = [[NSScanner alloc] initWithString:self];
        [scanner setCharactersToBeSkipped:nil];
        NSMutableString *result = [[NSMutableString alloc] init];
        NSString *temp;
        NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                                          [NSString stringWithFormat:@" \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        // Scan
        while (![scanner isAtEnd]) {
            
            // Get non new line or whitespace characters
            temp = nil;
            [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
            if (temp) [result appendString:temp];
            
            // Replace with a space
            if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                    [result appendString:@" "];
            }
            
        }
        
        // Cleanup
        
        // Return
        NSString *retString = [NSString stringWithString:result];
        
        // Return
        return retString;
	}
}

- (NSString *)wa_stringByLinkifyingURLs {
    if (!NSClassFromString(@"NSRegularExpression")) return self;
    @autoreleasepool {
        NSString *pattern = @"(?<!=\")\\b((http|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%%&amp;:/~\\+#]*[\\w\\-\\@?^=%%&amp;/~\\+#])?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length])
                                                               withTemplate:@"<a href=\"$1\" class=\"linkified\">$1</a>"];
        return modifiedString;
    }
}

+ (BOOL)wa_isNullOrEmpty:(NSString*)s {
    return ((s == nil) || (s.length == 0));
}

- (NSString *)wa_urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
