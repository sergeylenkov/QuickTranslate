#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "SGHotKey.h"
#import "SGHotKeyCenter.h"
#import "PTLoginItem.h"

@protocol PrefsControllerDelegate <NSObject>

@optional

- (void)settingsDidChange;

@end

@interface PrefsController : NSWindowController <NSToolbarDelegate> {
    IBOutlet NSView *generalView;
    IBOutlet NSView *advancedView;
    IBOutlet NSView *languagesView;
	IBOutlet NSPopUpButton *fromLanguagesButton;
    IBOutlet NSPopUpButton *toLanguagesButton;
    IBOutlet NSButton *autodetectButton;
    IBOutlet NSButton *openAtCursorButton;
    IBOutlet NSPopUpButton *openingActionButton;
    IBOutlet NSButton *startAtLoginButton;
    IBOutlet NSButton *copyToClipboardButton;
    IBOutlet SRRecorderControl *hotKeyControl;
    IBOutlet NSPopUpButton *serviceButton;
	NSUserDefaults *defaults;
    NSMutableArray *googleLanguageNames;
    NSMutableArray *googleLanguageCodes;
    NSMutableArray *bingLanguageNames;
    NSMutableArray *bingLanguageCodes;
    SGHotKey *hotKey;
    id _delegate;
}

@property (nonatomic, retain) NSMutableArray *googleLanguageNames;
@property (nonatomic, retain) NSMutableArray *googleLanguageCodes;
@property (nonatomic, retain) NSMutableArray *bingLanguageNames;
@property (nonatomic, retain) NSMutableArray *bingLanguageCodes;

- (id)initWithDelegate:(id)delegate;

- (void)setPrefView:(id)sender;
- (void)reloadLanguages;
- (void)refresh;
- (void)selectTabWithIndetifier:(NSString *)identifier;

- (IBAction)changeFromLanguage:(id)sender;
- (IBAction)changeToLanguage:(id)sender;
- (IBAction)changeAutoDetect:(id)sender;
- (IBAction)changeOpenAtCursor:(id)sender;
- (IBAction)openingActionDidChange:(id)sender;
- (IBAction)copyToClipboardDidChange:(id)sender;
- (IBAction)changeStartAtLogin:(id)sender;
- (IBAction)changeService:(id)sender;

@end
