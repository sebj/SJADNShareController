
// SJADNShareController.h

// Seb Jachec

#import <Cocoa/Cocoa.h>

@interface SJADNShareController : NSObject <NSSharingServicePickerDelegate>

//If YES, share controller will try to use Mac app URL schemes
@property BOOL shareViaLocalApps;

/**
 * Shares the given items on App.net
 */
- (void)shareItems:(nullable NSArray*)items;

@end
