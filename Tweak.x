// Shadow by jjolano

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "Includes/Shadow.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <unistd.h>
#include <spawn.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <sys/sysctl.h>
#include "Includes/codesign.h"


static Shadow *_shadow = nil;

static NSMutableDictionary *enum_path = nil;

static NSArray *dyld_array = nil;
static uint32_t dyld_array_count = 0;

static NSError *_error_file_not_found = nil;

static BOOL passthrough = NO;
static BOOL extra_compat = YES;

static NSArray *JBFile_DYLIB = nil;

static void init_DIY_dylib(NSArray *DYLIB) {
	DYLIB = @[
		@"libcurses.dylib",
		@"libncurses.dylib",
		@"applenb.dylib",
		@"lib4758cca.dylib",
		@"libaep.dylib",
		@"libatalla.dylib",
		@"libcapi.dylib",
		@"libchil.dylib",
		@"libcswift.dylib",
		@"libgmp.dylib",
		@"libgost.dylib",
		@"libnuron.dylib",
		@"libpadlock.dylib",
		@"libsureware.dylib",
		@"libubsec.dylib",
		@"capi.dylib",
		@"padlock.dylib",
		@"libMTLCapture.dylib",
		@"libapplist.dylib",
		@"libapt-inst.2.0.0.dylib",
		@"libapt-inst.2.0.dylib",
		@"libapt-pkg.5.0.2.dylib",
		@"libapt-pkg.5.0.dylib",
		@"libapt-private.0.0.0.dylib",
		@"libapt-private.0.0.dylib",
		@"libasprintf.0.dylib",
		@"libasprintf.dylib",
		@"libassuan.0.dylib",
		@"libassuan.dylib",
		@"libdb-6.2.dylib",
		@"libdb-6.dylib",
		@"libdb.dylib",
		@"libffi-trampolines.dylib",
		@"libgcrypt.20.dylib",
		@"libgcrypt.dylib",
		@"libgettextlib-0.19.8.dylib",
		@"libgettextlib.dylib",
		@"libgettextpo.1.dylib",
		@"libgettextpo.dylib",
		@"libgettextsrc-0.19.8.dylib",
		@"libgettextsrc.dylib",
		@"libgmp.10.dylib",
		@"libgmp.dylib",
		@"libgnutls.30.dylib",
		@"libgnutls.dylib",
		@"libgnutlsxx.28.dylib",
		@"libgnutlsxx.dylib",
		@"libgpg-error.0.dylib",
		@"libgpg-error.dylib",
		@"libhistory.5.2.dylib",
		@"libhistory.5.dylib",
		@"libhistory.6.0.dylib",
		@"libhistory.7.0.dylib",
		@"libhistory.7.dylib",
		@"libhistory.8.0.dylib",
		@"libhistory.8.dylib",
		@"libhistory.dylib",
		@"libhogweed.4.5.dylib",
		@"libhogweed.4.dylib",
		@"libhogweed.dylib",
		@"libidn2.0.dylib",
		@"libidn2.dylib",
		@"libimg4_development.dylib",
		@"libintl.9.dylib",
		@"libintl.dylib",
		@"libksba.8.dylib",
		@"libksba.dylib",
		@"liblz4.1.7.5.dylib",
		@"liblz4.1.dylib",
		@"liblz4.dylib",
		@"libnettle.6.5.dylib",
		@"libnettle.6.dylib",
		@"libnettle.dylib",
		@"libnghttp2.14.dylib",
		@"libnpth.0.dylib",
		@"libnpth.dylib",
		@"libp11-kit.0.dylib",
		@"libp11-kit.dylib",
		@"libpanel.5.dylib",
		@"libpanel.6.dylib",
		@"libpanel.dylib",
		@"libpanel5.dylib",
		@"libpanelw.5.dylib",
		@"libpanelw.6.dylib",
		@"libpanelw.dylib",
		@"libpanelw5.dylib",
		@"libpcre2-8.0.dylib",
		@"libpcre2-8.dylib",
		@"libpcre2-posix.2.dylib",
		@"libpcre2-posix.dylib",
		@"libplist.3.dylib",
		@"libprefs.dylib",
		@"libreadline.5.2.dylib",
		@"libreadline.5.dylib",
		@"libreadline.6.0.dylib",
		@"libreadline.7.0.dylib",
		@"libreadline.7.dylib",
		@"libreadline.8.0.dylib",
		@"libreadline.8.dylib",
		@"libreadline.dylib",
		@"librocketbootstrap.dylib",
		@"libsnappy.dylib",
		@"libssh2.1.dylib",
		@"libssh2.dylib",
		@"libssl.1.0.0.dylib",
		@"libssl.1.1.dylib",
		@"libsubstrate.dylib",
		@"libtasn1.6.dylib",
		@"libtasn1.dylib",
		@"libunistring.2.dylib",
		@"libunistring.dylib",
		@"p11-kit-proxy.dylib",
		@"SubstrateBootstrap.dylib",
		@"SubstrateInserter.dylib",
		@"SubstrateLoader.dylib",
		@"libswiftDemangle.dylib",
		@"libswiftXCTest.dylib",
		@"libmis.dylib",
		@"libcurses.dylib",
		@"libncurses.dylib",
		@"applenb.dylib",
		@"lib4758cca.dylib",
		@"libaep.dylib",
		@"libatalla.dylib",
		@"libcapi.dylib",
		@"libchil.dylib",
		@"libcswift.dylib",
		@"libgmp.dylib",
		@"libgost.dylib",
		@"libnuron.dylib",
		@"libpadlock.dylib",
		@"libsureware.dylib",
		@"libubsec.dylib",
		@"capi.dylib",
		@"padlock.dylib",
		@"libMTLCapture.dylib",
		@"libapplist.dylib",
		@"libapt-inst.2.0.0.dylib",
		@"libapt-inst.2.0.dylib",
		@"libapt-pkg.5.0.2.dylib",
		@"libapt-pkg.5.0.dylib",
		@"libapt-private.0.0.0.dylib",
		@"libapt-private.0.0.dylib",
		@"libasprintf.0.dylib",
		@"libasprintf.dylib",
		@"libassuan.0.dylib",
		@"libassuan.dylib",
		@"libdb-6.2.dylib",
		@"libdb-6.dylib",
		@"libdb.dylib",
		@"libffi-trampolines.dylib",
		@"libgcrypt.20.dylib",
		@"libgcrypt.dylib",
		@"libgettextlib-0.19.8.dylib",
		@"libgettextlib.dylib",
		@"libgettextpo.1.dylib",
		@"libgettextpo.dylib",
		@"libgettextsrc-0.19.8.dylib",
		@"libgettextsrc.dylib",
		@"libgmp.10.dylib",
		@"libgmp.dylib",
		@"libgnutls.30.dylib",
		@"libgnutls.dylib",
		@"libgnutlsxx.28.dylib",
		@"libgnutlsxx.dylib",
		@"libgpg-error.0.dylib",
		@"libgpg-error.dylib",
		@"libhistory.5.2.dylib",
		@"libhistory.5.dylib",
		@"libhistory.6.0.dylib",
		@"libhistory.7.0.dylib",
		@"libhistory.7.dylib",
		@"libhistory.8.0.dylib",
		@"libhistory.8.dylib",
		@"libhistory.dylib",
		@"libhogweed.4.5.dylib",
		@"libhogweed.4.dylib",
		@"libhogweed.dylib",
		@"libidn2.0.dylib",
		@"libidn2.dylib",
		@"libimg4_development.dylib",
		@"libintl.9.dylib",
		@"libintl.dylib",
		@"libksba.8.dylib",
		@"libksba.dylib",
		@"liblz4.1.7.5.dylib",
		@"liblz4.1.dylib",
		@"liblz4.dylib",
		@"libnettle.6.5.dylib",
		@"libnettle.6.dylib",
		@"libnettle.dylib",
		@"libnghttp2.14.dylib",
		@"libnpth.0.dylib",
		@"libnpth.dylib",
		@"libp11-kit.0.dylib",
		@"libp11-kit.dylib",
		@"libpanel.5.dylib",
		@"libpanel.6.dylib",
		@"libpanel.dylib",
		@"libpanel5.dylib",
		@"libpanelw.5.dylib",
		@"libpanelw.6.dylib",
		@"libpanelw.dylib",
		@"libpanelw5.dylib",
		@"libpcre2-8.0.dylib",
		@"libpcre2-8.dylib",
		@"libpcre2-posix.2.dylib",
		@"libpcre2-posix.dylib",
		@"libplist.3.dylib",
		@"libprefs.dylib",
		@"libreadline.5.2.dylib",
		@"libreadline.5.dylib",
		@"libreadline.6.0.dylib",
		@"libreadline.7.0.dylib",
		@"libreadline.7.dylib",
		@"libreadline.8.0.dylib",
		@"libreadline.8.dylib",
		@"libreadline.dylib",
		@"librocketbootstrap.dylib",
		@"libsnappy.dylib",
		@"libssh2.1.dylib",
		@"usrlibssh2.dylib",
		@"usrlibssl.1.0.0.dylib",
		@"usrlibssl.1.1.dylib",
		@"usrlibsubstrate.dylib",
		@"usrlibtasn1.6.dylib",
		@"usrlibtasn1.dylib",
		@"usrlibunistring.2.dylib",
		@"usrlibunistring.dylib",
		@"usrp11-kit-proxy.dylib",
		@"usrSubstrateBootstrap.dylib",
		@"usrSubstrateInserter.dylib",
		@"usrSubstrateLoader.dylib",
		@"usrlibswiftDemangle.dylib",
		@"usrlibswiftXCTest.dylib",
		@"liblzma.5.dylib",
		@"liblzma.dylib",
		@"lib4758cca.dylib",
		@"libaep.dylib",
		@"libatalla.dylib",
		@"libcapi.dylib",
		@"libchil.dylib",
		@"libcswift.dylib",
		@"libgmp.dylib",
		@"libgost.dylib",
		@"libnuron.dylib",
		@"libpadlock.dylib",
		@"libsureware.dylib",
		@"libubsec.dylib",
		@"capi.dylib",
		@"padlock.dylib",
		@"libCRFSuite0.12.dylib",
		@"libDHCPServer.dylib",
		@"libMTLCapture.dylib",
		@"libMatch.dylib",
		@"libSystem.B_asan.dylib",
		@"libSystem.dylib",
		@"libSystem_asan.dylib",
		@"libapplist.dylib",
		@"libapt-inst.2.0.0.dylib",
		@"libapt-inst.2.0.dylib",
		@"libapt-pkg.5.0.2.dylib",
		@"libapt-pkg.5.0.dylib",
		@"libapt-private.0.0.0.dylib",
		@"libapt-private.0.0.dylib",
		@"libarchive.dylib",
		@"libasprintf.0.dylib",
		@"libasprintf.dylib",
		@"libassuan.0.dylib",
		@"libassuan.dylib",
		@"libassuan.la",
		@"libbsm.dylib",
		@"libbz2.1.0.5.dylib",
		@"libbz2.dylib",
		@"libc++.dylib",
		@"libc.dylib",
		@"libcharset.1.0.0.dylib",
		@"libcharset.dylib",
		@"libcrypto.1.0.0.dylib",
		@"libcrypto.1.1.dylib",
		@"libcups.dylib",
		@"libcurl.4.dylib",
		@"libcurl.dylib",
		@"libcurses.dylib",
		@"libdb-6.2.dylib",
		@"libdb-6.dylib",
		@"libdb.dylib",
		@"libdbm.dylib",
		@"libdl.dylib",
		@"libdpkg.a",
		@"libeasyperf.dylib",
		@"libedit.2.dylib",
		@"libedit.3.0.dylib",
		@"libedit.dylib",
		@"libexslt.dylib",
		@"libextension.dylib",
		@"libffi-trampolines.dylib",
		@"libform.5.dylib",
		@"libform.6.dylib",
		@"libform.dylib",
		@"libform5.dylib",
		@"libformw.5.dylib",
		@"libformw.6.dylib",
		@"libformw.dylib",
		@"libformw5.dylib",
		@"libgcrypt.20.dylib",
		@"libgcrypt.dylib",
		@"libgcrypt.la",
		@"libgettextlib-0.19.8.dylib",
		@"libgettextlib.dylib",
		@"libgettextpo.1.dylib",
		@"libgettextpo.dylib",
		@"libgettextsrc-0.19.8.dylib",
		@"libgettextsrc.dylib",
		@"libgmp.10.dylib",
		@"libgmp.dylib",
		@"libgmp.la",
		@"libgnutls.30.dylib",
		@"libgnutls.dylib",
		@"libgnutlsxx.28.dylib",
		@"libgnutlsxx.dylib",
		@"libgpg-error.0.dylib",
		@"libgpg-error.dylib",
		@"libgpg-error.la",
		@"libhistory.5.2.dylib",
		@"libhistory.5.dylib",
		@"libhistory.6.0.dylib",
		@"libhistory.7.0.dylib",
		@"libhistory.7.dylib",
		@"libhistory.8.0.dylib",
		@"libhistory.8.dylib",
		@"libhistory.dylib",
		@"libhogweed.4.5.dylib",
		@"libhogweed.4.dylib",
		@"libhogweed.dylib",
		@"libiconv.2.4.0.dylib",
		@"libiconv.dylib",
		@"libicucore.dylib",
		@"libidn2.0.dylib",
		@"libidn2.dylib",
		@"libidn2.la",
		@"libimg4_development.dylib",
		@"libinfo.dylib",
		@"libintl.9.dylib",
		@"libintl.dylib",
		@"libipsec.dylib",
		@"libksba.8.dylib",
		@"libksba.dylib",
		@"libksba.la",
		@"liblz4.1.7.5.dylib",
		@"liblz4.1.dylib",
		@"liblz4.dylib",
		@"liblzma.dylib",
		@"liblzmadec.0.dylib",
		@"liblzmadec.dylib",
		@"libm.dylib",
		@"libmagic.1.dylib",
		@"libmagic.a",
		@"libmagic.dylib",
		@"libmenu.5.dylib",
		@"libmenu.6.dylib",
		@"libmenu.dylib",
		@"libmenu5.dylib",
		@"libmenuw.5.dylib",
		@"libmenuw.6.dylib",
		@"libmenuw.dylib",
		@"libmenuw5.dylib",
		@"libncurses.5.dylib",
		@"libncurses.6.dylib",
		@"libncurses.dylib",
		@"libncurses5.dylib",
		@"libncurses6.dylib",
		@"libncursesw.5.dylib",
		@"libncursesw.6.dylib",
		@"libncursesw.dylib",
		@"libncursesw5.dylib",
		@"libncursesw6.dylib",
		@"libnettle.6.5.dylib",
		@"libnettle.6.dylib",
		@"libnettle.dylib",
		@"libnghttp2.14.dylib",
		@"libnpth.0.dylib",
		@"libnpth.dylib",
		@"libnpth.la",
		@"libobjc-trampolines.dylib",
		@"libobjc.dylib",
		@"libp11-kit.0.dylib",
		@"libp11-kit.dylib",
		@"libp11-kit.la",
		@"libpanel.5.dylib",
		@"libpanel.6.dylib",
		@"libpanel.dylib",
		@"libpanel5.dylib",
		@"libpanelw.5.dylib",
		@"libpanelw.6.dylib",
		@"libpanelw.dylib",
		@"libpanelw5.dylib",
		@"libpcap.dylib",
		@"libpcre2-8.0.dylib",
		@"libpcre2-8.dylib",
		@"libpcre2-posix.2.dylib",
		@"libpcre2-posix.dylib",
		@"libplist.3.dylib",
		@"libpoll.dylib",
		@"libprefs.dylib",
		@"libproc.dylib",
		@"libpthread.dylib",
		@"libreadline.5.2.dylib",
		@"libreadline.5.dylib",
		@"libreadline.6.0.dylib",
		@"libreadline.7.0.dylib",
		@"libreadline.7.dylib",
		@"libreadline.8.0.dylib",
		@"libreadline.8.dylib",
		@"libreadline.dylib",
		@"libresolv.dylib",
		@"librocketbootstrap.dylib",
		@"librpcsvc.dylib",
		@"libsandbox.dylib",
		@"libsnappy.dylib",
		@"libsqlite3.0.dylib",
		@"libssh2.1.dylib",
		@"libssh2.dylib",
		@"libssl.1.0.0.dylib",
		@"libssl.1.1.dylib",
		@"libstdc++.6.0.9.dylib",
		@"libstdc++.6.dylib",
		@"libstdc++.dylib",
		@"libsubstrate.dylib",
		@"libtasn1.6.dylib",
		@"libtasn1.dylib",
		@"libtasn1.la",
		@"libtidy.dylib",
		@"libunistring.2.dylib",
		@"libunistring.dylib",
		@"libunistring.la",
		@"libutil1.0.dylib",
		@"libxml2.dylib",
		@"libxslt.dylib",
		@"libz.1.1.3.dylib",
		@"libz.1.2.11.dylib",
		@"libz.1.2.5.dylib",
		@"libz.1.2.8.dylib",
		@"libz.dylib",
		@"p11-kit-proxy.dylib",
		@"SubstrateBootstrap.dylib",
		@"SubstrateInserter.dylib",
		@"SubstrateLoader.dylib",
		@"libswiftDemangle.dylib",
		@"libswiftXCTest.dylib",
		@"libdispatch.dylib",
		@"AppList.dylib",
		@"AppList.plist",
		@"MobileSafety.dylib",
		@"MobileSafety.plist",
		@"PreferenceLoader.dylib",
		@"PreferenceLoader.plist",
		@"RocketBootstrap.dylib",
		@"RocketBootstrap.plist",
		@"TSActivator.dylib",
		@"TSActivator.plist",
		@"TSEventTweak.dylib",
		@"TSEventTweak.plist",
		@"TSTweak.dylib",
		@"TSTweak.plist",
		@"TSTweakEx.dylib",
		@"0Shadow.dylib",
		@"bbp.dylib",
		@"bbp.plist",
		@"zorro.dylib",
		@"zorro.plist",
		@"MobileSafety.png",
		@"MobileSubstrate.dylib",
		@"libhooker",
		@"0Shadow",
		@"ServerPlugins",
		@"SubstrateLoader",
		@"MobileSafety",
		@"PreferenceLoader",
		@"RocketBootstrap",
		@"TSActivator",
		@"TSEventTweak",
		@"TSTweak",
		@"TSTweakEx",
		@"afc2dService",
		@"afc2dSupport",
		@"zorro",
		@"touchsprite",
		@"DYLD_INSERT_LIBRARIES",
		@"_MSSafeMode",
		@"_SafeMode",
	];
}

static void updateDyldArray(void) {
    dyld_array_count = 0;
    dyld_array = [_shadow generateDyldArray];
    dyld_array_count = (uint32_t) [dyld_array count];
}

static void dyld_image_added(const struct mach_header *mh, intptr_t slide) {
    passthrough = YES;

    Dl_info info;
    int addr = dladdr(mh, &info);
    int type = 0;
    
    if(addr) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:info.dli_fname length:strlen(info.dli_fname)];

	    for (NSString *Prefix in JBFile_DYLIB) {
			if ([path rangeOfString:Prefix].location != NSNotFound) {
				type = 1;
				break;
			}
	    }


        if([_shadow isImageRestricted:path] && type == 0) {
            void *handle = dlopen(info.dli_fname, RTLD_NOLOAD);

            if(handle) {
                dlclose(handle);
            }
        }
    }

    passthrough = NO;
}

// Stable Hooks
%group hook_libc
%hookf(int, access, const char *pathname, int mode) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        // workaround for tweaks not loading properly in Substrate
        if([_shadow useInjectCompatibilityMode]) {
            if([[path pathExtension] isEqualToString:@"plist"] && [path hasPrefix:@"/Library/MobileSubstrate"]) {
                return %orig;
            }
        }

        for (NSString *Prefix in JBFile_DYLIB) {
		if ([path rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return -1;
		}
        }


        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(char *, strstr, const char *haystack, const char *needle) {
    if(haystack) {
        NSString *env = [NSString stringWithUTF8String:haystack];
        
        for (NSString *Prefix in JBFile_DYLIB) {
		if ([env rangeOfString:Prefix].location != NSNotFound) {
		    return NULL;
		}
        }
        
        if([_shadow isPathRestricted:env]) {
            return NULL;
        }
        
        if([env isEqualToString:@"DYLD_INSERT_LIBRARIES"]
        || [env isEqualToString:@"_MSSafeMode"]
        || [env isEqualToString:@"_SafeMode"]) {
            return NULL;
        }
    }

    return %orig;
}


%hookf(char *, getenv, const char *name) {
    if(name) {
        NSString *env = [NSString stringWithUTF8String:name];
        
        for (NSString *Prefix in JBFile_DYLIB) {
		if ([env rangeOfString:Prefix].location != NSNotFound) {
		    return NULL;
		}
        }
        
        if([env isEqualToString:@"DYLD_INSERT_LIBRARIES"]
        || [env isEqualToString:@"_MSSafeMode"]
        || [env isEqualToString:@"_SafeMode"]) {
            return NULL;
        }
    }

    return %orig;
}

%hookf(FILE *, fopen, const char *pathname, const char *mode) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        for (NSString *Prefix in JBFile_DYLIB) {
		if ([path rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return NULL;
		}
        }

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return NULL;
        }
    }

    return %orig;
}

%hookf(FILE *, freopen, const char *pathname, const char *mode, FILE *stream) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        for (NSString *Prefix in JBFile_DYLIB) {
		if ([path rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return NULL;
		}
        }

        if([_shadow isPathRestricted:path]) {
            fclose(stream);
            errno = ENOENT;
            return NULL;
        }
    }

    return %orig;
}

%hookf(int, stat, const char *pathname, struct stat *statbuf) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        for (NSString *Prefix in JBFile_DYLIB) {
		if ([path rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return -1;
		}
        }


        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }

        // Maybe some filesize overrides?
        if(statbuf) {
            if([path isEqualToString:@"/bin"]) {
                int ret = %orig;

                if(ret == 0 && statbuf->st_size > 128) {
                    statbuf->st_size = 128;
                    return ret;
                }
            }
        }
    }

    return %orig;
}

%hookf(int, lstat, const char *pathname, struct stat *statbuf) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        for (NSString *Prefix in JBFile_DYLIB) {
		if ([path rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return -1;
		}
        }

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }

        // Maybe some filesize overrides?
        if(statbuf) {
            if([path isEqualToString:@"/Applications"]
            || [path isEqualToString:@"/usr/share"]
            || [path isEqualToString:@"/usr/libexec"]
            || [path isEqualToString:@"/usr/include"]
            || [path isEqualToString:@"/Library/Ringtones"]
            || [path isEqualToString:@"/Library/Wallpaper"]) {
                int ret = %orig;

                if(ret == 0 && (statbuf->st_mode & S_IFLNK) == S_IFLNK) {
                    statbuf->st_mode &= ~S_IFLNK;
                    return ret;
                }
            }

            if([path isEqualToString:@"/bin"]) {
                int ret = %orig;

                if(ret == 0 && statbuf->st_size > 128) {
                    statbuf->st_size = 128;
                    return ret;
                }
            }
        }
    }

    return %orig;
}

%hookf(int, fstatfs, int fd, struct statfs *buf) {
    int ret = %orig;

    if(ret == 0) {
        // Get path of dirfd.
        char path[PATH_MAX];

        if(fcntl(fd, F_GETPATH, path) != -1) {
            NSString *pathname = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

	    for (NSString *Prefix in JBFile_DYLIB) {
			if ([pathname rangeOfString:Prefix].location != NSNotFound) {
			    errno = ENOENT;
			    return -1;
			}
	    }


            if([_shadow isPathRestricted:pathname]) {
                errno = ENOENT;
                return -1;
            }

            pathname = [_shadow resolveLinkInPath:pathname];
            
            if(![pathname hasPrefix:@"/var"]
            && ![pathname hasPrefix:@"/private/var"]) {
                if(buf) {
                    // Ensure root fs is marked read-only.
                    buf->f_flags |= MNT_RDONLY | MNT_ROOTFS;
                    return ret;
                }
            } else {
                // Ensure var fs is marked NOSUID.
                buf->f_flags |= MNT_NOSUID | MNT_NODEV;
                return ret;
            }
        }
    }

    return ret;
}

%hookf(int, statfs, const char *path, struct statfs *buf) {
    int ret = %orig;

    if(ret == 0) {
        NSString *pathname = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];


        for (NSString *Prefix in JBFile_DYLIB) {
		if ([pathname rangeOfString:Prefix].location != NSNotFound) {
		    errno = ENOENT;
		    return -1;
		}
        }

        if([_shadow isPathRestricted:pathname]) {
            errno = ENOENT;
            return -1;
        }

        pathname = [_shadow resolveLinkInPath:pathname];

        if(![pathname hasPrefix:@"/var"]
        && ![pathname hasPrefix:@"/private/var"]) {
            if(buf) {
                // Ensure root fs is marked read-only.
                buf->f_flags |= MNT_RDONLY | MNT_ROOTFS;
                return ret;
            }
        } else {
            // Ensure var fs is marked NOSUID.
            buf->f_flags |= MNT_NOSUID | MNT_NODEV;
            return ret;
        }
    }

    return ret;
}

%hookf(int, posix_spawn, pid_t *pid, const char *pathname, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t *attrp, char *const argv[], char *const envp[]) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            return ENOENT;
        }
    }

    return %orig;
}

%hookf(int, posix_spawnp, pid_t *pid, const char *pathname, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t *attrp, char *const argv[], char *const envp[]) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            return ENOENT;
        }
    }

    return %orig;
}

%hookf(char *, realpath, const char *pathname, char *resolved_path) {
    BOOL doFree = (resolved_path != NULL);
    NSString *path = nil;

    if(pathname) {
        path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return NULL;
        }
    }

    char *ret = %orig;

    // Recheck resolved path.
    if(ret) {
        NSString *resolved_path_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:ret length:strlen(ret)];


        if([_shadow isPathRestricted:resolved_path_ns]) {
            errno = ENOENT;

            // Free resolved_path if it was allocated by libc.
            if(doFree) {
                free(ret);
            }

            return NULL;
        }

        if(strcmp(ret, pathname) != 0) {
            // Possible symbolic link? Track it in Shadow
            [_shadow addLinkFromPath:path toPath:resolved_path_ns];
        }
    }

    return ret;
}

%hookf(int, symlink, const char *path1, const char *path2) {
    NSString *path1_ns = nil;
    NSString *path2_ns = nil;

    if(path1 && path2) {
        path1_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path1 length:strlen(path1)];
        path2_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path2 length:strlen(path2)];

        if([_shadow isPathRestricted:path1_ns] || [_shadow isPathRestricted:path2_ns]) {
            errno = ENOENT;
            return -1;
        }
    }

    int ret = %orig;

    if(ret == 0) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:path1_ns toPath:path2_ns];
    }

    return ret;
}

%hookf(int, rename, const char *oldname, const char *newname) {
    NSString *oldname_ns = nil;
    NSString *newname_ns = nil;

    if(oldname && newname) {
        oldname_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:oldname length:strlen(oldname)];
        newname_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:newname length:strlen(newname)];


        if([_shadow isPathRestricted:oldname_ns] || [_shadow isPathRestricted:newname_ns]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, remove, const char *filename) {
    if(filename) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:filename length:strlen(filename)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, unlink, const char *pathname) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, unlinkat, int dirfd, const char *pathname, int flags) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if(![path isAbsolutePath]) {
            // Get path of dirfd.
            char dirfdpath[PATH_MAX];
        
            if(fcntl(dirfd, F_GETPATH, dirfdpath) != -1) {
                NSString *dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
                path = [dirfd_path stringByAppendingPathComponent:path];
            }
        }
        
        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, rmdir, const char *pathname) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, chdir, const char *pathname) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, fchdir, int fd) {
    char dirfdpath[PATH_MAX];

    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];


        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, link, const char *path1, const char *path2) {
    NSString *path1_ns = nil;
    NSString *path2_ns = nil;

    if(path1 && path2) {
        path1_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path1 length:strlen(path1)];
        path2_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path2 length:strlen(path2)];

        if([_shadow isPathRestricted:path1_ns] || [_shadow isPathRestricted:path2_ns]) {
            errno = ENOENT;
            return -1;
        }
    }

    int ret = %orig;

    if(ret == 0) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:path1_ns toPath:path2_ns];
    }

    return ret;
}

%hookf(int, fstatat, int dirfd, const char *pathname, struct stat *buf, int flags) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if(![path isAbsolutePath]) {
            // Get path of dirfd.
            char dirfdpath[PATH_MAX];
        
            if(fcntl(dirfd, F_GETPATH, dirfdpath) != -1) {
                NSString *dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
                path = [dirfd_path stringByAppendingPathComponent:path];
            }
        }
        
        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, faccessat, int dirfd, const char *pathname, int mode, int flags) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if(![path isAbsolutePath]) {
            // Get path of dirfd.
            char dirfdpath[PATH_MAX];
        
            if(fcntl(dirfd, F_GETPATH, dirfdpath) != -1) {
                NSString *dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
                path = [dirfd_path stringByAppendingPathComponent:path];
            }
        }
        
        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    return %orig;
}

%hookf(int, chroot, const char *dirname) {
    if(dirname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirname length:strlen(dirname)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return -1;
        }
    }

    int ret = %orig;

    if(ret == 0) {
        [_shadow addLinkFromPath:@"/" toPath:[[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirname length:strlen(dirname)]];
    }

    return ret;
}
%end

%group hook_libc_inject
%hookf(int, fstat, int fd, struct stat *buf) {
    // Get path of dirfd.
    char fdpath[PATH_MAX];

    if(fcntl(fd, F_GETPATH, fdpath) != -1) {
        NSString *fd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:fdpath length:strlen(fdpath)];

        if([_shadow isPathRestricted:fd_path]) {
            errno = EBADF;
            return -1;
        }

        if(buf) {
            if([fd_path isEqualToString:@"/bin"]) {
                int ret = %orig;

                if(ret == 0 && buf->st_size > 128) {
                    buf->st_size = 128;
                    return ret;
                }
            }
        }
    }

    return %orig;
}
%end

%group hook_dlopen_inject
%hookf(void *, dlopen, const char *path, int mode) {
    if(!passthrough && path) {
        NSString *image_name = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

        if([_shadow isImageRestricted:image_name]) {
            return NULL;
        }
    }

    return %orig;
}
%end

%group hook_NSFileHandle
// #include "Hooks/Stable/NSFileHandle.xm"
%hook NSFileHandle
+ (instancetype)fileHandleForReadingAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)fileHandleForReadingFromURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (instancetype)fileHandleForWritingAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)fileHandleForWritingToURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (instancetype)fileHandleForUpdatingAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)fileHandleForUpdatingURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}
%end
%end

%group hook_NSFileManager
%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {

    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    return %orig;
}

- (BOOL)isReadableFileAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    return %orig;
}

- (BOOL)isWritableFileAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    return %orig;
}

- (BOOL)isDeletableFileAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    return %orig;
}

- (BOOL)isExecutableFileAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }
    for (NSString *Prefix in JBFile_DYLIB) {
    	if ([path rangeOfString:Prefix].location != NSNotFound) {
    		return NO;
    	}
    }
    return %orig;
}

- (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domain appropriateForURL:(NSURL *)url create:(BOOL)shouldCreate error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (NSArray<NSURL *> *)URLsForDirectory:(NSSearchPathDirectory)directory inDomains:(NSSearchPathDomainMask)domainMask {
    NSArray *ret = %orig;

    if(ret) {
        NSMutableArray *toRemove = [NSMutableArray new];
        NSMutableArray *filtered = [ret mutableCopy];

        for(NSURL *url in filtered) {
            if([_shadow isURLRestricted:url manager:self]) {
                [toRemove addObject:url];
            }
        }

        [filtered removeObjectsInArray:toRemove];
        ret = [filtered copy];
    }

    return ret;
}

- (BOOL)isUbiquitousItemAtURL:(NSURL *)url {
    if([_shadow isURLRestricted:url manager:self]) {
        return NO;
    }

    return %orig;
}

- (BOOL)setUbiquitous:(BOOL)flag itemAtURL:(NSURL *)url destinationURL:(NSURL *)destinationURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)replaceItemAtURL:(NSURL *)originalItemURL withItemAtURL:(NSURL *)newItemURL backupItemName:(NSString *)backupItemName options:(NSFileManagerItemReplacementOptions)options resultingItemURL:(NSURL * _Nullable *)resultingURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:originalItemURL manager:self] || [_shadow isURLRestricted:newItemURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (NSArray<NSURL *> *)contentsOfDirectoryAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray<NSURLResourceKey> *)keys options:(NSDirectoryEnumerationOptions)mask error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    // Filter array.
    NSMutableArray *filtered_ret = nil;
    NSArray *ret = %orig;

    if(ret) {
        filtered_ret = [NSMutableArray new];

        for(NSURL *ret_url in ret) {
            if(![_shadow isURLRestricted:ret_url manager:self]) {
                [filtered_ret addObject:ret_url];
            }
        }
    }

    return ret ? [filtered_ret copy] : ret;
}

- (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    // Filter array.
    NSMutableArray *filtered_ret = nil;
    NSArray *ret = %orig;

    if(ret) {
        filtered_ret = [NSMutableArray new];

        for(NSString *ret_path in ret) {
            // Ensure absolute path for path.
            if(![_shadow isPathRestricted:[path stringByAppendingPathComponent:ret_path] manager:self]) {
                [filtered_ret addObject:ret_path];
            }
        }
    }

    return ret ? [filtered_ret copy] : ret;
}

- (NSDirectoryEnumerator<NSURL *> *)enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray<NSURLResourceKey> *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler {
    if([_shadow isURLRestricted:url manager:self]) {
        return %orig([NSURL fileURLWithPath:@"/.file"], keys, mask, handler);
    }

    return %orig;
}

- (NSDirectoryEnumerator<NSString *> *)enumeratorAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return %orig(@"/.file");
    }

    NSDirectoryEnumerator *ret = %orig;

    if(ret && enum_path) {
        // Store this path.
        [enum_path setObject:path forKey:[NSValue valueWithNonretainedObject:ret]];
    }

    return ret;
}

- (NSArray<NSString *> *)subpathsOfDirectoryAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    // Filter array.
    NSMutableArray *filtered_ret = nil;
    NSArray *ret = %orig;

    if(ret) {
        filtered_ret = [NSMutableArray new];

        for(NSString *ret_path in ret) {
            // Ensure absolute path for path.
            if(![_shadow isPathRestricted:[path stringByAppendingPathComponent:ret_path] manager:self]) {
                [filtered_ret addObject:ret_path];
            }
        }
    }

    return ret ? [filtered_ret copy] : ret;
}

- (NSArray<NSString *> *)subpathsAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return nil;
    }

    // Filter array.
    NSMutableArray *filtered_ret = nil;
    NSArray *ret = %orig;

    if(ret) {
        filtered_ret = [NSMutableArray new];

        for(NSString *ret_path in ret) {
            // Ensure absolute path for path.
            if(![_shadow isPathRestricted:[path stringByAppendingPathComponent:ret_path] manager:self]) {
                [filtered_ret addObject:ret_path];
            }
        }
    }

    return ret ? [filtered_ret copy] : ret;
}

- (BOOL)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:srcURL manager:self] || [_shadow isURLRestricted:dstURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:srcPath manager:self] || [_shadow isPathRestricted:dstPath manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:srcURL manager:self] || [_shadow isURLRestricted:dstURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:srcPath manager:self] || [_shadow isPathRestricted:dstPath manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (NSArray<NSString *> *)componentsToDisplayForPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return nil;
    }

    return %orig;
}

- (NSString *)displayNameAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return path;
    }

    return %orig;
}

- (NSDictionary<NSFileAttributeKey, id> *)attributesOfItemAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (NSDictionary<NSFileAttributeKey, id> *)attributesOfFileSystemForPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (BOOL)setAttributes:(NSDictionary<NSFileAttributeKey, id> *)attributes ofItemAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (NSData *)contentsAtPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return nil;
    }

    return %orig;
}

- (BOOL)contentsEqualAtPath:(NSString *)path1 andPath:(NSString *)path2 {
    if([_shadow isPathRestricted:path1] || [_shadow isPathRestricted:path2]) {
        return NO;
    }

    return %orig;
}

- (BOOL)getRelationship:(NSURLRelationship *)outRelationship ofDirectoryAtURL:(NSURL *)directoryURL toItemAtURL:(NSURL *)otherURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:directoryURL manager:self] || [_shadow isURLRestricted:otherURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)getRelationship:(NSURLRelationship *)outRelationship ofDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domainMask toItemAtURL:(NSURL *)otherURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:otherURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)changeCurrentDirectoryPath:(NSString *)path {
    if([_shadow isPathRestricted:path manager:self]) {
        return NO;
    }

    return %orig;
}

- (BOOL)createSymbolicLinkAtURL:(NSURL *)url withDestinationURL:(NSURL *)destURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url manager:self] || [_shadow isURLRestricted:destURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    BOOL ret = %orig;

    if(ret) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:[url path] toPath:[destURL path]];
    }

    return ret;
}

- (BOOL)createSymbolicLinkAtPath:(NSString *)path withDestinationPath:(NSString *)destPath error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path] || [_shadow isPathRestricted:destPath]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    BOOL ret = %orig;

    if(ret) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:path toPath:destPath];
    }

    return ret;
}

- (BOOL)linkItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:srcURL manager:self] || [_shadow isURLRestricted:dstURL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    BOOL ret = %orig;

    if(ret) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:[srcURL path] toPath:[dstURL path]];
    }

    return ret;
}

- (BOOL)linkItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:srcPath manager:self] || [_shadow isPathRestricted:dstPath manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    BOOL ret = %orig;

    if(ret) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:srcPath toPath:dstPath];
    }

    return ret;
}

- (NSString *)destinationOfSymbolicLinkAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    NSString *ret = %orig;

    if(ret) {
        // Track this symlink in Shadow
        [_shadow addLinkFromPath:path toPath:ret];
    }

    return ret;
}
%end
%end

%group hook_NSEnumerator
%hook NSDirectoryEnumerator
- (id)nextObject {
    id ret = nil;
    NSString *parent = nil;

    if(enum_path) {
        parent = enum_path[[NSValue valueWithNonretainedObject:self]];
    }

    while((ret = %orig)) {
        if([ret isKindOfClass:[NSURL class]]) {
            if(![_shadow isURLRestricted:ret]) {
                break;
            }
        }

        if([ret isKindOfClass:[NSString class]]) {
            if(parent) {
                NSString *path = [parent stringByAppendingPathComponent:ret];

                if(![_shadow isPathRestricted:path]) {
                    break;
                }
            } else {
                break;
            }
        }
    }

    return ret;
}
%end
%end

%group hook_NSFileWrapper
%hook NSFileWrapper
- (instancetype)initWithURL:(NSURL *)url options:(NSFileWrapperReadingOptions)options error:(NSError * _Nullable *)outError {
    if([_shadow isURLRestricted:url]) {
        if(outError) {
            *outError = _error_file_not_found;
        }

        return 0;
    }

    return %orig;
}

- (instancetype)initSymbolicLinkWithDestinationURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return 0;
    }

    return %orig;
}

- (BOOL)matchesContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return NO;
    }

    return %orig;
}

- (BOOL)readFromURL:(NSURL *)url options:(NSFileWrapperReadingOptions)options error:(NSError * _Nullable *)outError {
    if([_shadow isURLRestricted:url]) {
        if(outError) {
            *outError = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url options:(NSFileWrapperWritingOptions)options originalContentsURL:(NSURL *)originalContentsURL error:(NSError * _Nullable *)outError {
    if([_shadow isURLRestricted:url]) {
        if(outError) {
            *outError = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}
%end
%end

%group hook_NSFileVersion
%hook NSFileVersion
+ (NSFileVersion *)currentVersionOfItemAtURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }

    return %orig;
}

+ (NSArray<NSFileVersion *> *)otherVersionsOfItemAtURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }

    return %orig;
}

+ (NSFileVersion *)versionOfItemAtURL:(NSURL *)url forPersistentIdentifier:(id)persistentIdentifier {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }

    return %orig;
}

+ (NSURL *)temporaryDirectoryURLForNewVersionOfItemAtURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }

    return %orig;
}

+ (NSFileVersion *)addVersionOfItemAtURL:(NSURL *)url withContentsOfURL:(NSURL *)contentsURL options:(NSFileVersionAddingOptions)options error:(NSError * _Nullable *)outError {
    if([_shadow isURLRestricted:url] || [_shadow isURLRestricted:contentsURL]) {
        if(outError) {
            *outError = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (NSArray<NSFileVersion *> *)unresolvedConflictVersionsOfItemAtURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }

    return %orig;
}

- (NSURL *)replaceItemAtURL:(NSURL *)url options:(NSFileVersionReplacingOptions)options error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (BOOL)removeOtherVersionsOfItemAtURL:(NSURL *)url error:(NSError * _Nullable *)outError {
    if([_shadow isURLRestricted:url]) {
        if(outError) {
            *outError = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

+ (void)getNonlocalVersionsOfItemAtURL:(NSURL *)url completionHandler:(void (^)(NSArray<NSFileVersion *> *nonlocalFileVersions, NSError *error))completionHandler {
    if([_shadow isURLRestricted:url]) {
        if(completionHandler) {
            completionHandler(nil, _error_file_not_found);
        }

        return;
    }

    %orig;
}
%end
%end

%group hook_NSURL
%hook NSURL
- (BOOL)checkResourceIsReachableAndReturnError:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (NSURL *)fileReferenceURL {
    if([_shadow isURLRestricted:self]) {
        return nil;
    }

    return %orig;
}
%end
%end

%group hook_UIApplication
%hook UIApplication
- (BOOL)canOpenURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return NO;
    }

    return %orig;
}
/*
- (BOOL)openURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return NO;
    }

    return %orig;
}

- (void)openURL:(NSURL *)url options:(NSDictionary<id, id> *)options completionHandler:(void (^)(BOOL success))completion {
    if([_shadow isURLRestricted:url]) {
        completion(NO);
        return;
    }

    %orig;
}
*/
%end
%end

%group hook_NSBundle
// #include "Hooks/Testing/NSBundle.xm"
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if([key isEqualToString:@"SignerIdentity"]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)bundleWithURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }
    
    return %orig;
}

+ (instancetype)bundleWithPath:(NSString *)path {
    if([_shadow isPathRestricted:path]) {
        return nil;
    }

    return %orig;
}

- (instancetype)initWithURL:(NSURL *)url {
    if([_shadow isURLRestricted:url]) {
        return nil;
    }
    
    return %orig;
}

- (instancetype)initWithPath:(NSString *)path {
    if([_shadow isPathRestricted:path]) {
        return nil;
    }

    return %orig;
}
%end
%end
/*
%group hook_CoreFoundation
%hookf(CFArrayRef, CFBundleGetAllBundles) {
    CFArrayRef cfbundles = %orig;
    CFIndex cfcount = CFArrayGetCount(cfbundles);

    NSMutableArray *filter = [NSMutableArray new];
    NSMutableArray *bundles = [NSMutableArray arrayWithArray:(__bridge NSArray *) cfbundles];

    // Filter return value.
    int i;
    for(i = 0; i < cfcount; i++) {
        CFBundleRef cfbundle = (CFBundleRef) CFArrayGetValueAtIndex(cfbundles, i);
        CFURLRef cfbundle_cfurl = CFBundleCopyExecutableURL(cfbundle);

        if(cfbundle_cfurl) {
            NSURL *bundle_url = (__bridge NSURL *) cfbundle_cfurl;

            if([_shadow isURLRestricted:bundle_url]) {
                continue;
            }
        }

        [filter addObject:bundles[i]];
    }

    return (__bridge CFArrayRef) [filter copy];
}

%hookf(CFReadStreamRef, CFReadStreamCreateWithFile, CFAllocatorRef alloc, CFURLRef fileURL) {
    NSURL *nsurl = (__bridge NSURL *)fileURL;

    if([nsurl isFileURL] && [_shadow isPathRestricted:[nsurl path] partial:NO]) {
        return NULL;
    }

    return %orig;
}

%hookf(CFWriteStreamRef, CFWriteStreamCreateWithFile, CFAllocatorRef alloc, CFURLRef fileURL) {
    NSURL *nsurl = (__bridge NSURL *)fileURL;

    if([nsurl isFileURL] && [_shadow isPathRestricted:[nsurl path] partial:NO]) {
        return NULL;
    }

    return %orig;
}

%hookf(CFURLRef, CFURLCreateFilePathURL, CFAllocatorRef allocator, CFURLRef url, CFErrorRef *error) {
    NSURL *nsurl = (__bridge NSURL *)url;

    if([nsurl isFileURL] && [_shadow isPathRestricted:[nsurl path] partial:NO]) {
        if(error) {
            *error = (__bridge CFErrorRef) _error_file_not_found;
        }
        
        return NULL;
    }

    return %orig;
}

%hookf(CFURLRef, CFURLCreateFileReferenceURL, CFAllocatorRef allocator, CFURLRef url, CFErrorRef *error) {
    NSURL *nsurl = (__bridge NSURL *)url;

    if([nsurl isFileURL] && [_shadow isPathRestricted:[nsurl path] partial:NO]) {
        if(error) {
            *error = (__bridge CFErrorRef) _error_file_not_found;
        }
        
        return NULL;
    }

    return %orig;
}
%end
*/
%group hook_NSUtilities
%hook NSProcessInfo
- (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version {
    // Override version checks that use this method.
    return YES;
}
%end

%hook UIImage
- (instancetype)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}
%end

%hook NSMutableArray
- (id)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

- (id)initWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)arrayWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)arrayWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}
%end

%hook NSArray
- (id)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)arrayWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)arrayWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}
%end

%hook NSMutableDictionary
- (id)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

- (id)initWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}
%end

%hook NSDictionary
- (id)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

- (id)initWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (id)dictionaryWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)dictionaryWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (id)dictionaryWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}
%end

%hook NSString
- (instancetype)initWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (instancetype)initWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (instancetype)stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (instancetype)stringWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (NSUInteger)completePathIntoString:(NSString * _Nullable *)outputName caseSensitive:(BOOL)flag matchesIntoArray:(NSArray<NSString *> * _Nullable *)outputArray filterTypes:(NSArray<NSString *> *)filterTypes {
    if([_shadow isPathRestricted:self]) {
        *outputName = nil;
        *outputArray = nil;

        return 0;
    }

    return %orig;
}
%end
%end

// Other Hooks
%group hook_private
%hookf(int, csops, pid_t pid, unsigned int ops, void *useraddr, size_t usersize) {
    int ret = %orig;

    if(ops == CS_OPS_STATUS && (ret & CS_PLATFORM_BINARY) == CS_PLATFORM_BINARY && pid == getpid()) {
        // Ensure that the platform binary flag is not set.
        ret &= ~CS_PLATFORM_BINARY;
    }

    return ret;
}
%end

%group hook_debugging
%hookf(int, sysctl, int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
    if(namelen == 4
    && name[0] == CTL_KERN
    && name[1] == KERN_PROC
    && name[2] == KERN_PROC_ALL
    && name[3] == 0) {
        // Running process check.
        *oldlenp = 0;
        return 0;
    }

    int ret = %orig;

    if(ret == 0
    && name[0] == CTL_KERN
    && name[1] == KERN_PROC
    && name[2] == KERN_PROC_PID
    && name[3] == getpid()) {
        // Remove trace flag.
        if(oldp) {
            struct kinfo_proc *p = ((struct kinfo_proc *) oldp);

            if((p->kp_proc.p_flag & P_TRACED) == P_TRACED) {
                p->kp_proc.p_flag &= ~P_TRACED;
            }
        }
    }

    return ret;
}

%hookf(pid_t, getppid) {
    return 1;
}
%end

%group hook_dyld_image
%hookf(uint32_t, _dyld_image_count) {
    if(dyld_array_count > 0) {
        return dyld_array_count;
    }

    return %orig;
}

%hookf(const char *, _dyld_get_image_name, uint32_t image_index) {
    if(dyld_array_count > 0) {

        if(image_index >= dyld_array_count) {
            return NULL;
        }

        image_index = (uint32_t) [dyld_array[image_index] unsignedIntValue];
    }

    // Basic filter.
    const char *ret = %orig(image_index);

    if(ret) {
        NSString *image_name = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:ret length:strlen(ret)];
        
	for (NSString *Prefix in JBFile_DYLIB) {
		if ([image_name rangeOfString:Prefix].location != NSNotFound) {
			return "";
		}
	 }
	 
        if([_shadow isImageRestricted:image_name]) {
            return "";
        }
    }

    return ret;
}

%hookf(bool, dlopen_preflight, const char *path) {
    if(path) {
        NSString *image_name = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

	for (NSString *Prefix in JBFile_DYLIB) {
		if ([image_name rangeOfString:Prefix].location != NSNotFound) {
			return NULL;
		}
	 }

        if([_shadow isImageRestricted:image_name]) {
            return false;
        }
    }

    return %orig;
}
%end

%group hook_dyld_dlsym
%hookf(void *, dlsym, void *handle, const char *symbol) {
    if(symbol) {
        NSString *sym = [NSString stringWithUTF8String:symbol];

	for (NSString *Prefix in JBFile_DYLIB) {
		if ([sym rangeOfString:Prefix].location != NSNotFound) {
			return NULL;
		}
	 }

        if([sym hasPrefix:@"MS"]
        || [sym hasPrefix:@"Sub"]
        || [sym hasPrefix:@"PS"]
        || [sym hasPrefix:@"rocketbootstrap"]
        || [sym hasPrefix:@"LM"]
        || [sym hasPrefix:@"substitute"]
        || [sym hasPrefix:@"_logos"]) {
            return NULL;
        }
    }

    return %orig;
}
%end

%group hook_sandbox
%hook NSArray
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    if([_shadow isPathRestricted:path partial:NO]) {
        return NO;
    }
    if([path isEqualToString:@"/private/"]) {
        return NO;
    }
    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically {
    if([_shadow isURLRestricted:url partial:NO]) {
        return NO;
    }

    return %orig;
}
%end

%hook NSDictionary
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    if([_shadow isPathRestricted:path partial:NO]) {
        return NO;
    }
    if([path isEqualToString:@"/private/"]) {
        return NO;
    }
    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically {
    if([_shadow isURLRestricted:url partial:NO]) {
        return NO;
    }

    return %orig;
}
%end

%hook NSData
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    if([_shadow isPathRestricted:path partial:NO]) {
        return NO;
    }
    if([path isEqualToString:@"/private/"]) {
        return NO;
    }
    return %orig;
}

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)writeOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }
        return NO;
    }
    if([path isEqualToString:@"/private/"]) {
    	*error = _error_file_not_found;
        return NO;
    }
    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile {
    if([_shadow isURLRestricted:url partial:NO]) {
        return NO;
    }

    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url options:(NSDataWritingOptions)writeOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}
%end

%hook NSString
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }
    if([path isEqualToString:@"/private/"]) {
    	*error = _error_file_not_found;
        return NO;
    }
    return %orig;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}
%end

%hook NSFileManager
- (BOOL)createDirectoryAtURL:(NSURL *)url withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary<NSFileAttributeKey, id> *)attr {
    if([_shadow isPathRestricted:path partial:NO]) {
        return NO;
    }

    return %orig;
}

- (BOOL)removeItemAtURL:(NSURL *)URL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:URL manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}

- (BOOL)trashItemAtURL:(NSURL *)url resultingItemURL:(NSURL * _Nullable *)outResultingURL error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url manager:self]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return NO;
    }

    return %orig;
}
%end

%hookf(int, creat, const char *pathname, mode_t mode) {
    if(pathname) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

        if([_shadow isPathRestricted:path]) {
            errno = EACCES;
            return -1;
        }
    }

    return %orig;
}

%hookf(pid_t, vfork) {
    errno = ENOSYS;
    return -1;
}

%hookf(pid_t, fork) {
    errno = ENOSYS;
    return -1;
}

%hookf(FILE *, popen, const char *command, const char *type) {
    errno = ENOSYS;
    return NULL;
}

%hookf(int, setgid, gid_t gid) {
    // Block setgid for root.
    if(gid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}

%hookf(int, setuid, uid_t uid) {
    // Block setuid for root.
    if(uid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}

%hookf(int, setegid, gid_t gid) {
    // Block setegid for root.
    if(gid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}

%hookf(int, seteuid, uid_t uid) {
    // Block seteuid for root.
    if(uid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}

%hookf(uid_t, getuid) {
    // Return uid for mobile.
    return 501;
}

%hookf(gid_t, getgid) {
    // Return gid for mobile.
    return 501;
}

%hookf(uid_t, geteuid) {
    // Return uid for mobile.
    return 501;
}

%hookf(uid_t, getegid) {
    // Return gid for mobile.
    return 501;
}

%hookf(int, setreuid, uid_t ruid, uid_t euid) {
    // Block for root.
    if(ruid == 0 || euid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}

%hookf(int, setregid, gid_t rgid, gid_t egid) {
    // Block for root.
    if(rgid == 0 || egid == 0) {
        errno = EPERM;
        return -1;
    }

    return %orig;
}
%end

%group hook_runtime
%hookf(const char * _Nonnull *, objc_copyImageNames, unsigned int *outCount) {
    const char * _Nonnull *ret = %orig;

    if(ret && outCount) {

        const char *exec_name = _dyld_get_image_name(0);
        unsigned int i;

        for(i = 0; i < *outCount; i++) {
            if(strcmp(ret[i], exec_name) == 0) {
                // Stop after app executable.
                *outCount = (i + 1);
                break;
            }
        }
    }

    return ret;
}

%hookf(const char * _Nonnull *, objc_copyClassNamesForImage, const char *image, unsigned int *outCount) {
    if(image) {

        NSString *image_ns = [NSString stringWithUTF8String:image];

        if([_shadow isImageRestricted:image_ns]) {
            *outCount = 0;
            return NULL;
        }
    }

    return %orig;
}
%end

%group hook_libraries
%hook UIDevice
+ (BOOL)isJailbroken {
    return NO;
}

- (BOOL)isJailBreak {
    return NO;
}

- (BOOL)isJailBroken {
    return NO;
}
%end

%hook SFAntiPiracy
+ (int)isJailbroken {
    return 4783242;
}
%end

%hook JailbreakDetectionVC
- (BOOL)isJailbroken {
    return NO;
}
%end

%hook DTTJailbreakDetection
+ (BOOL)isJailbroken {
    return NO;
}
%end

%hook ANSMetadata
- (BOOL)computeIsJailbroken {
    return NO;
}

- (BOOL)isJailbroken {
    return NO;
}
%end

%hook GBDeviceInfo
- (BOOL)isJailbroken {
    return NO;
}
%end

%hook CMARAppRestrictionsDelegate
- (bool)isDeviceNonCompliant {
    return false;
}
%end

%hook ADYSecurityChecks
+ (bool)isDeviceJailbroken {
    return false;
}
%end

%hook UBReportMetadataDevice
- (void *)is_rooted {
    return NULL;
}
%end

%hook UtilitySystem
+ (bool)isJailbreak {
    return false;
}
%end

%hook GemaltoConfiguration
+ (bool)isJailbreak {
    return false;
}
%end

%hook CPWRDeviceInfo
- (bool)isJailbroken {
    return false;
}
%end

%hook CPWRSessionInfo
- (bool)isJailbroken {
    return false;
}
%end

%hook KSSystemInfo
+ (bool)isJailbroken {
    return false;
}
%end

%hook EMDSKPPConfiguration
- (bool)jailBroken {
    return false;
}
%end

%hook EnrollParameters
- (void *)jailbroken {
    return NULL;
}
%end

%hook EMDskppConfigurationBuilder
- (bool)jailbreakStatus {
    return false;
}
%end

%hook FCRSystemMetadata
- (bool)isJailbroken {
    return false;
}
%end

%hook v_VDMap
- (bool)isJailBrokenDetectedByVOS {
    return false;
}

- (bool)isDFPHookedDetecedByVOS {
    return false;
}

- (bool)isCodeInjectionDetectedByVOS {
    return false;
}

- (bool)isDebuggerCheckDetectedByVOS {
    return false;
}

- (bool)isAppSignerCheckDetectedByVOS {
    return false;
}

- (bool)v_checkAModified {
    return false;
}
%end

%hook SDMUtils
- (BOOL)isJailBroken {
    return NO;
}
%end

%hook OneSignalJailbreakDetection
+ (BOOL)isJailbroken {
    return NO;
}
%end

%hook DigiPassHandler
- (BOOL)rootedDeviceTestResult {
    return NO;
}
%end

%hook AWMyDeviceGeneralInfo
- (bool)isCompliant {
    return true;
}
%end
%end

%group hook_experimental
%hook NSData
- (id)initWithContentsOfMappedFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (id)dataWithContentsOfMappedFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}

- (instancetype)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url options:(NSDataReadingOptions)readOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }
        
        return nil;
    }

    return %orig;
}

+ (instancetype)dataWithContentsOfFile:(NSString *)path {
    if([_shadow isPathRestricted:path partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)dataWithContentsOfURL:(NSURL *)url {
    if([_shadow isURLRestricted:url partial:NO]) {
        return nil;
    }

    return %orig;
}

+ (instancetype)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isPathRestricted:path partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}

+ (instancetype)dataWithContentsOfURL:(NSURL *)url options:(NSDataReadingOptions)readOptionsMask error:(NSError * _Nullable *)error {
    if([_shadow isURLRestricted:url partial:NO]) {
        if(error) {
            *error = _error_file_not_found;
        }

        return nil;
    }

    return %orig;
}
%end

%hookf(int32_t, NSVersionOfRunTimeLibrary, const char *libraryName) {
    if(libraryName) {
        NSString *name = [NSString stringWithUTF8String:libraryName];

        if([_shadow isImageRestricted:name]) {
            return -1;
        }
    }
    
    return %orig;
}

%hookf(int32_t, NSVersionOfLinkTimeLibrary, const char *libraryName) {
    if(libraryName) {
        NSString *name = [NSString stringWithUTF8String:libraryName];

        if([_shadow isImageRestricted:name]) {
            return -1;
        }
    }
    
    return %orig;
}
%end


void init_path_map(Shadow *shadow) {
    // Restrict / by whitelisting
    [shadow addPath:@"/" restricted:YES hidden:NO];
    [shadow addPath:@"/.mount_rw" restricted:YES];
    [shadow addPath:@"/.file" restricted:NO];
    [shadow addPath:@"/.ba" restricted:NO];
    [shadow addPath:@"/.mb" restricted:NO];
    [shadow addPath:@"/.HFS" restricted:NO];
    [shadow addPath:@"/.Trashes" restricted:NO];
    // [shadow addPath:@"/AppleInternal" restricted:NO];
    [shadow addPath:@"/cores" restricted:NO];
    [shadow addPath:@"/Developer" restricted:NO];
    [shadow addPath:@"/lib" restricted:NO];
    [shadow addPath:@"/mnt" restricted:NO];

    // Restrict /bin by whitelisting
    [shadow addPath:@"/bin" restricted:YES hidden:NO];
    [shadow addPath:@"/bin/bash" restricted:YES];
    [shadow addPath:@"/bin/sh" restricted:YES];
    [shadow addPath:@"/bin/bunzip2" restricted:YES];
    [shadow addPath:@"/bin/bzcat" restricted:YES];
    [shadow addPath:@"/bin/bzzip2" restricted:YES];
    [shadow addPath:@"/bin/bzip2recover" restricted:YES];
    [shadow addPath:@"/bin/df" restricted:NO];
    [shadow addPath:@"/bin/ps" restricted:NO];

    // Restrict /sbin by whitelisting
    [shadow addPath:@"/sbin" restricted:YES hidden:NO];
    [shadow addPath:@"/sbin/dmesg" restricted:YES];
    [shadow addPath:@"/sbin/dynamic_pager" restricted:YES];
    [shadow addPath:@"/sbin/fstyp" restricted:YES];
    [shadow addPath:@"/sbin/fstyp_msdos" restricted:YES];
    [shadow addPath:@"/sbin/fstyp_ntfs" restricted:YES];
    [shadow addPath:@"/sbin/fstyp_udf" restricted:YES];
    [shadow addPath:@"/sbin/halt" restricted:YES];
    [shadow addPath:@"/sbin/launchctl" restricted:YES];
    [shadow addPath:@"/sbin/newfs_apfs" restricted:YES];
    [shadow addPath:@"/sbin/newfs_apfs.sbin" restricted:YES];
    [shadow addPath:@"/sbin/newfs_hfs" restricted:YES];
    [shadow addPath:@"/sbin/newfs_hfs.sbin" restricted:YES];
    [shadow addPath:@"/sbin/quotacheck" restricted:YES];
    [shadow addPath:@"/sbin/umount" restricted:YES];
    [shadow addPath:@"/sbin/umount.distrib" restricted:YES];
    [shadow addPath:@"/sbin/fsck" restricted:NO];
    [shadow addPath:@"/sbin/launchd" restricted:NO];
    [shadow addPath:@"/sbin/mount" restricted:NO];
    [shadow addPath:@"/sbin/pfctl" restricted:NO];

    // Restrict /Applications by whitelisting
    [shadow addPath:@"/Applications" restricted:YES hidden:NO];
    [shadow addPath:@"/Applications/Cydia.app" restricted:YES];
    [shadow addPath:@"/Applications/TouchSprite.app" restricted:YES];
    [shadow addPath:@"/Applications/zorro.app" restricted:YES];
    [shadow addPath:@"/Applications/Filza.app" restricted:YES];
    [shadow addPath:@"/Applications/AXUIViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/AccountAuthenticationDialog.app" restricted:NO];
    [shadow addPath:@"/Applications/ActivityMessagesApp.app" restricted:NO];
    [shadow addPath:@"/Applications/AdPlatformsDiagnostics.app" restricted:NO];
    [shadow addPath:@"/Applications/AppStore.app" restricted:NO];
    [shadow addPath:@"/Applications/AskPermissionUI.app" restricted:NO];
    [shadow addPath:@"/Applications/BusinessExtensionsWrapper.app" restricted:NO];
    [shadow addPath:@"/Applications/CTCarrierSpaceAuth.app" restricted:NO];
    [shadow addPath:@"/Applications/Camera.app" restricted:NO];
    [shadow addPath:@"/Applications/CheckerBoard.app" restricted:NO];
    [shadow addPath:@"/Applications/CompassCalibrationViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/ContinuityCamera.app" restricted:NO];
    [shadow addPath:@"/Applications/CoreAuthUI.app" restricted:NO];
    [shadow addPath:@"/Applications/DDActionsService.app" restricted:NO];
    [shadow addPath:@"/Applications/DNDBuddy.app" restricted:NO];
    [shadow addPath:@"/Applications/DataActivation.app" restricted:NO];
    [shadow addPath:@"/Applications/DemoApp.app" restricted:NO];
    [shadow addPath:@"/Applications/Diagnostics.app" restricted:NO];
    [shadow addPath:@"/Applications/DiagnosticsService.app" restricted:NO];
    [shadow addPath:@"/Applications/FTMInternal-4.app" restricted:NO];
    [shadow addPath:@"/Applications/Family.app" restricted:NO];
    [shadow addPath:@"/Applications/Feedback Assistant iOS.app" restricted:NO];
    [shadow addPath:@"/Applications/FieldTest.app" restricted:NO];
    [shadow addPath:@"/Applications/FindMyiPhone.app" restricted:NO];
    [shadow addPath:@"/Applications/FunCameraShapes.app" restricted:NO];
    [shadow addPath:@"/Applications/FunCameraText.app" restricted:NO];
    [shadow addPath:@"/Applications/GameCenterUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/HashtagImages.app" restricted:NO];
    [shadow addPath:@"/Applications/Health.app" restricted:NO];
    [shadow addPath:@"/Applications/HealthPrivacyService.app" restricted:NO];
    [shadow addPath:@"/Applications/HomeUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/InCallService.app" restricted:NO];
    [shadow addPath:@"/Applications/Magnifier.app" restricted:NO];
    [shadow addPath:@"/Applications/MailCompositionService.app" restricted:NO];
    [shadow addPath:@"/Applications/MessagesViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/MobilePhone.app" restricted:NO];
    [shadow addPath:@"/Applications/MobileSMS.app" restricted:NO];
    [shadow addPath:@"/Applications/MobileSafari.app" restricted:NO];
    [shadow addPath:@"/Applications/MobileSlideShow.app" restricted:NO];
    [shadow addPath:@"/Applications/MobileTimer.app" restricted:NO];
    [shadow addPath:@"/Applications/MusicUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/Passbook.app" restricted:NO];
    [shadow addPath:@"/Applications/PassbookUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/PhotosViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/PreBoard.app" restricted:NO];
    [shadow addPath:@"/Applications/Preferences.app" restricted:NO];
    [shadow addPath:@"/Applications/Print Center.app" restricted:NO];
    [shadow addPath:@"/Applications/SIMSetupUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/SLGoogleAuth.app" restricted:NO];
    [shadow addPath:@"/Applications/SLYahooAuth.app" restricted:NO];
    [shadow addPath:@"/Applications/SafariViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/ScreenSharingViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/ScreenshotServicesService.app" restricted:NO];
    [shadow addPath:@"/Applications/Setup.app" restricted:NO];
    [shadow addPath:@"/Applications/SharedWebCredentialViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/SharingViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/SiriViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/SoftwareUpdateUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/StoreDemoViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/StoreKitUIService.app" restricted:NO];
    [shadow addPath:@"/Applications/TrustMe.app" restricted:NO];
    [shadow addPath:@"/Applications/Utilities" restricted:NO];
    [shadow addPath:@"/Applications/VideoSubscriberAccountViewService.app" restricted:NO];
    [shadow addPath:@"/Applications/WLAccessService.app" restricted:NO];
    [shadow addPath:@"/Applications/Web.app" restricted:NO];
    [shadow addPath:@"/Applications/WebApp1.app" restricted:NO];
    [shadow addPath:@"/Applications/WebContentAnalysisUI.app" restricted:NO];
    [shadow addPath:@"/Applications/WebSheet.app" restricted:NO];
    [shadow addPath:@"/Applications/iAdOptOut.app" restricted:NO];
    [shadow addPath:@"/Applications/iCloud.app" restricted:NO];

    // Restrict /dev
    [shadow addPath:@"/dev" restricted:NO];
    [shadow addPath:@"/dev/dlci." restricted:YES];
    [shadow addPath:@"/dev/vn0" restricted:YES];
    [shadow addPath:@"/dev/vn1" restricted:YES];
    [shadow addPath:@"/dev/kmem" restricted:YES];
    [shadow addPath:@"/dev/mem" restricted:YES];

    // Restrict /private by whitelisting
    [shadow addPath:@"/private" restricted:YES hidden:NO];
    [shadow addPath:@"/private/etc" restricted:YES hidden:NO];
    [shadow addPath:@"/private/etc/rc.d" restricted:YES];
    [shadow addPath:@"/private/etc/default" restricted:YES];
    [shadow addPath:@"/private/etc/ssl" restricted:YES];
    [shadow addPath:@"/private/etc/ssh" restricted:YES];
    [shadow addPath:@"/private/etc/profile" restricted:YES];
    [shadow addPath:@"/private/etc/porfile.d" restricted:YES];
    [shadow addPath:@"/private/etc/apt" restricted:YES];
    [shadow addPath:@"/private/etc/alternatives" restricted:YES];
    [shadow addPath:@"/private/etc/dpkg" restricted:YES];
    [shadow addPath:@"/private/etc/preferences.d" restricted:YES];
    [shadow addPath:@"/private/etc/default" restricted:YES];
    [shadow addPath:@"/private/var/lib/" restricted:YES hidden:NO];
    [shadow addPath:@"/private/var/lib/cydia" restricted:YES];
    [shadow addPath:@"/private/var/checkra1n.dmg" restricted:YES];
    [shadow addPath:@"/private/var/log" restricted:YES hidden:NO];
    [shadow addPath:@"/private/var/log/alternatives.log" restricted:YES];
    [shadow addPath:@"/private/var/log/apt" restricted:YES];
    [shadow addPath:@"/private/var/log/dpkg" restricted:YES];
    [shadow addPath:@"/private/etc" restricted:NO];
    [shadow addPath:@"/private/system_data" restricted:NO];
    [shadow addPath:@"/private/var" restricted:NO];
    [shadow addPath:@"/private/xarts" restricted:NO];

    // Restrict /etc by whitelisting
    [shadow addPath:@"/etc" restricted:YES hidden:NO];
    [shadow addPath:@"/etc/clutch.conf" restricted:YES];
    [shadow addPath:@"/etc/rc.d" restricted:YES];
    [shadow addPath:@"/etc/default" restricted:YES];
    [shadow addPath:@"/etc/ssl" restricted:YES];
    [shadow addPath:@"/etc/ssh" restricted:YES];
    [shadow addPath:@"/etc/profile" restricted:YES];
    [shadow addPath:@"/etc/porfile.d" restricted:YES];
    [shadow addPath:@"/etc/apt" restricted:YES];
    [shadow addPath:@"/etc/alternatives" restricted:YES];
    [shadow addPath:@"/etc/dpkg" restricted:YES];
    [shadow addPath:@"/etc/preferences.d" restricted:YES];
    [shadow addPath:@"/etc/default" restricted:YES];
    [shadow addPath:@"/etc/asl" restricted:NO];
    [shadow addPath:@"/etc/asl.conf" restricted:NO];
    [shadow addPath:@"/etc/fstab" restricted:NO];
    [shadow addPath:@"/etc/group" restricted:NO];
    [shadow addPath:@"/etc/hosts" restricted:NO];
    [shadow addPath:@"/etc/hosts.equiv" restricted:NO];
    [shadow addPath:@"/etc/master.passwd" restricted:NO];
    [shadow addPath:@"/etc/networks" restricted:NO];
    [shadow addPath:@"/etc/notify.conf" restricted:NO];
    [shadow addPath:@"/etc/passwd" restricted:NO];
    [shadow addPath:@"/etc/ppp" restricted:NO];
    [shadow addPath:@"/etc/protocols" restricted:NO];
    [shadow addPath:@"/etc/racoon" restricted:NO];
    [shadow addPath:@"/etc/services" restricted:NO];
    [shadow addPath:@"/etc/ttys" restricted:NO];
    
    // Restrict /Library by whitelisting
    [shadow addPath:@"/Library" restricted:YES hidden:NO];
    [shadow addPath:@"/Library/dpkg" restricted:YES];
    [shadow addPath:@"/Library/Wallpaper" restricted:YES];
    [shadow addPath:@"/Library/Ringtones" restricted:YES];
    [shadow addPath:@"/Library/Preferences" restricted:YES];
    [shadow addPath:@"/Library/MobileSubstrate" restricted:YES];
    [shadow addPath:@"/Library/Frameworks" restricted:YES];
    [shadow addPath:@"/Library/LaunchAgents" restricted:YES];
    [shadow addPath:@"/Library/LaunchDaemons" restricted:YES];
    [shadow addPath:@"/Library/Internet Plug-Ins" restricted:YES];
    [shadow addPath:@"/Library/Application Support" restricted:YES hidden:NO];
    [shadow addPath:@"/Library/Application Support/AggregateDictionary" restricted:NO];
    [shadow addPath:@"/Library/Application Support/BTServer" restricted:NO];
    [shadow addPath:@"/Library/Audio" restricted:NO];
    [shadow addPath:@"/Library/Caches" restricted:NO];
    [shadow addPath:@"/Library/Caches/cy-" restricted:YES];
    [shadow addPath:@"/Library/Filesystems" restricted:NO];
    [shadow addPath:@"/Library/Internet Plug-Ins" restricted:NO];
    [shadow addPath:@"/Library/Keychains" restricted:NO];
    [shadow addPath:@"/Library/LaunchAgents" restricted:NO];
    [shadow addPath:@"/Library/LaunchDaemons" restricted:YES hidden:NO];
    [shadow addPath:@"/Library/Logs" restricted:NO];
    [shadow addPath:@"/Library/Managed Preferences" restricted:NO];
    [shadow addPath:@"/Library/MobileDevice" restricted:NO];
    [shadow addPath:@"/Library/MusicUISupport" restricted:NO];
    [shadow addPath:@"/Library/Preferences" restricted:NO];
    [shadow addPath:@"/Library/Printers" restricted:NO];
    [shadow addPath:@"/Library/Ringtones" restricted:NO];
    [shadow addPath:@"/Library/Updates" restricted:NO];
    [shadow addPath:@"/Library/Wallpaper" restricted:NO];
    
    // Restrict /tmp
    [shadow addPath:@"/tmp" restricted:YES hidden:NO];
    [shadow addPath:@"/tmp/cydia.log" restricted:YES];
    [shadow addPath:@"/tmp/.req" restricted:YES];
    [shadow addPath:@"/tmp/.opt" restricted:YES];
    [shadow addPath:@"/tmp/substrate" restricted:YES];
    [shadow addPath:@"/tmp/syslog" restricted:YES];
    [shadow addPath:@"/tmp/slide.txt" restricted:YES];
    [shadow addPath:@"/tmp/amfidebilitate.out" restricted:YES];
    [shadow addPath:@"/tmp/org.coolstar" restricted:YES];
    [shadow addPath:@"/tmp/amfid_payload.alive" restricted:YES];
    [shadow addPath:@"/tmp/jailbreakd.pid" restricted:YES];
    [shadow addPath:@"/tmp/com.apple" restricted:NO];


    // Restrict /var by whitelisting
    [shadow addPath:@"/var" restricted:YES hidden:NO];
    [shadow addPath:@"/var/dropbear_rsa_host_key" restricted:YES];
    [shadow addPath:@"/var/binpack" restricted:YES];
    [shadow addPath:@"/var/checkra1n.dmg" restricted:YES];
    [shadow addPath:@"/var/.overprovisioning_file" restricted:YES];
    [shadow addPath:@"/var/cache" restricted:YES];
    [shadow addPath:@"/var/cache/clutch.plist" restricted:YES];
    [shadow addPath:@"/var/cache/clutch_cracked.plist" restricted:YES];
    [shadow addPath:@"/var/db" restricted:YES];
    [shadow addPath:@"/var/empty" restricted:YES];
    [shadow addPath:@"/var/libexec" restricted:YES];
    [shadow addPath:@"/var/lib" restricted:YES];
    [shadow addPath:@"/var/local" restricted:YES];
    [shadow addPath:@"/var/lock" restricted:YES];
    [shadow addPath:@"/var/log/apt" restricted:YES];
    [shadow addPath:@"/var/log/dpkg" restricted:YES];
    [shadow addPath:@"/var/logs" restricted:YES];
    [shadow addPath:@"/var/msgs" restricted:YES];
    [shadow addPath:@"/var/preferences" restricted:YES];
    [shadow addPath:@"/var/run/utmp" restricted:YES];
    [shadow addPath:@"/var/run/fudinit" restricted:YES];
    [shadow addPath:@"/var/run/utmpx" restricted:YES];
    [shadow addPath:@"/var/spool" restricted:YES];
    [shadow addPath:@"/var/tmp/cydia.log" restricted:YES];
    [shadow addPath:@"/var/tmp/.opt" restricted:YES];
    [shadow addPath:@"/var/tmp/.req" restricted:YES];
    [shadow addPath:@"/var/vm" restricted:YES];
    [shadow addPath:@"/var/lib" restricted:YES];
    [shadow addPath:@"/var/lib/clutch" restricted:YES];
    [shadow addPath:@"/var/lib/cydia" restricted:YES];
    [shadow addPath:@"/var/lib/apt" restricted:YES];
    [shadow addPath:@"/var/lib/dpkg" restricted:YES];
    [shadow addPath:@"/var/stash/Applications" restricted:YES];
    [shadow addPath:@"/var/MobileSoftwareUpdate" restricted:YES];
    [shadow addPath:@"/var/MobileSoftwareUpdate/mnt1" restricted:YES];
    [shadow addPath:@"/var/root/Documents" restricted:YES];
    [shadow addPath:@"/var/.DocumentRevisions" restricted:NO];
    [shadow addPath:@"/var/.fseventsd" restricted:NO];
    [shadow addPath:@"/var/.overprovisioning_file" restricted:NO];
    [shadow addPath:@"/var/audit" restricted:NO];
    [shadow addPath:@"/var/backups" restricted:NO];
    [shadow addPath:@"/var/buddy" restricted:NO];
    [shadow addPath:@"/var/containers" restricted:NO];
    [shadow addPath:@"/var/containers/Bundle" restricted:YES hidden:NO];
    [shadow addPath:@"/var/containers/Bundle/Application" restricted:NO];
    [shadow addPath:@"/var/containers/Bundle/Framework" restricted:NO];
    [shadow addPath:@"/var/containers/Bundle/PluginKitPlugin" restricted:NO];
    [shadow addPath:@"/var/containers/Bundle/VPNPlugin" restricted:NO];
    [shadow addPath:@"/var/cores" restricted:NO];
    [shadow addPath:@"/var/db" restricted:NO];
    [shadow addPath:@"/var/db/stash" restricted:YES];
    [shadow addPath:@"/var/ea" restricted:NO];
    [shadow addPath:@"/var/empty" restricted:NO];
    [shadow addPath:@"/var/folders" restricted:NO];
    [shadow addPath:@"/var/hardware" restricted:NO];
    [shadow addPath:@"/var/installd" restricted:NO];
    [shadow addPath:@"/var/internal" restricted:NO];
    [shadow addPath:@"/var/keybags" restricted:NO];
    [shadow addPath:@"/var/Keychains" restricted:NO];
    [shadow addPath:@"/var/lib" restricted:YES hidden:NO];
    [shadow addPath:@"/var/local" restricted:NO];
    [shadow addPath:@"/var/lock" restricted:NO];
    [shadow addPath:@"/var/log" restricted:YES hidden:NO];
    [shadow addPath:@"/var/log/asl" restricted:NO];
    [shadow addPath:@"/var/log/com.apple.xpc.launchd" restricted:NO];
    [shadow addPath:@"/var/log/corecaptured.log" restricted:NO];
    [shadow addPath:@"/var/log/ppp" restricted:NO];
    [shadow addPath:@"/var/log/ppp.log" restricted:NO];
    [shadow addPath:@"/var/log/racoon.log" restricted:NO];
    [shadow addPath:@"/var/log/sa" restricted:NO];
    [shadow addPath:@"/var/logs" restricted:NO];
    [shadow addPath:@"/var/Managed Preferences" restricted:NO];
    [shadow addPath:@"/var/MobileAsset" restricted:NO];
    [shadow addPath:@"/var/MobileDevice" restricted:NO];
    [shadow addPath:@"/var/msgs" restricted:NO];
    [shadow addPath:@"/var/networkd" restricted:NO];
    [shadow addPath:@"/var/preferences" restricted:NO];
    [shadow addPath:@"/var/root" restricted:NO];
    [shadow addPath:@"/var/run" restricted:YES hidden:NO];
    [shadow addPath:@"/var/run/lockdown" restricted:NO];
    [shadow addPath:@"/var/run/lockdown.sock" restricted:NO];
    [shadow addPath:@"/var/run/lockdown_first_run" restricted:NO];
    [shadow addPath:@"/var/run/mDNSResponder" restricted:NO];
    [shadow addPath:@"/var/run/printd" restricted:NO];
    [shadow addPath:@"/var/run/syslog" restricted:NO];
    [shadow addPath:@"/var/run/syslog.pid" restricted:NO];
    [shadow addPath:@"/var/run/utmpx" restricted:NO];
    [shadow addPath:@"/var/run/vpncontrol.sock" restricted:NO];
    [shadow addPath:@"/var/run/asl_input" restricted:NO];
    [shadow addPath:@"/var/run/configd.pid" restricted:NO];
    [shadow addPath:@"/var/run/lockbot" restricted:NO];
    [shadow addPath:@"/var/run/pppconfd" restricted:NO];
    [shadow addPath:@"/var/run/fudinit" restricted:NO];
    [shadow addPath:@"/var/spool" restricted:NO];
    [shadow addPath:@"/var/staged_system_apps" restricted:NO];
    [shadow addPath:@"/var/tmp" restricted:NO];
    [shadow addPath:@"/var/vm" restricted:NO];
    [shadow addPath:@"/var/wireless" restricted:NO];
    
    // Restrict /var/mobile by whitelisting
    [shadow addPath:@"/var/mobile" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Media/TouchSprite" restricted:YES];
    [shadow addPath:@"/var/mobile/Media/ZORRO" restricted:YES];
    [shadow addPath:@"/var/mobile/test.dmg" restricted:YES];
    [shadow addPath:@"/var/mobile/Library" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Cydia" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Logs/Cydia" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Caches" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/com.apple" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/com.saurik.Cydia" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Caches/Checkpoint.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Caches/DateFormats.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Caches/AccountMigrationInProgress" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.apple" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.saurik.Cydia.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/llll2.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Applications" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Containers/Data" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/Application" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/InternalDaemon" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/PluginKitPlugin" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/TempDir" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/VPNPlugin" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Data/XPCService" restricted:NO];
    [shadow addPath:@"/var/mobile/Containers/Shared" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Containers/Shared/AppGroup" restricted:NO];
    [shadow addPath:@"/var/mobile/Documents" restricted:NO];
    [shadow addPath:@"/var/mobile/Downloads" restricted:NO];
    [shadow addPath:@"/var/mobile/Library" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/com.apple" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/.com.apple" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/AdMob" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/AccountMigrationInProgress" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/ACMigrationLock" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/BTAvrcp" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/cache" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/Checkpoint.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/ckkeyrolld" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/CloudKit" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/DateFormats.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/FamilyCircle" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/GameKit" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/GeoServices" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/AccountMigrationInProgress" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/MappedImageCache" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/OTACrashCopier" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/PassKit" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/rtcreportingd" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/sharedCaches" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/Snapshots" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/Snapshots/com.apple" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/TelephonyUI" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Caches/Weather" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/ControlCenter" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/ControlCenter/ModuleConfiguration.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Cydia" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Logs/Cydia" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/SBSettings" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Sileo" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences" restricted:YES hidden:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.apple." restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/.GlobalPreferences.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/ckkeyrolld.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/nfcd.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/UITextInputContextIdentifiers.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/Wallpaper.png" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.saurik.Cydia.plist" restricted:NO];
    [shadow addPath:@"/var/mobile/Library/Preferences/zorrono.txt" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/llll2.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.zorro.adv.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.zorro_enc.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.zdinfo.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/zorro" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/com.touchsprite.ios.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/cn.tinyapps.Renet.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/Library/Preferences/kNPProgressTrackerDomain.plist" restricted:YES];
    [shadow addPath:@"/var/mobile/MobileSoftwareUpdate" restricted:NO];

    // Restrict /usr by whitelisting
    [shadow addPath:@"/usr" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/test.dmg" restricted:YES];
    [shadow addPath:@"/usr/sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/BTAvrcp" restricted:YES];
    [shadow addPath:@"/usr/sbin/BTAvrcp.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/BTLEServer" restricted:YES];
    [shadow addPath:@"/usr/sbin/BTLEServer.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/absd" restricted:YES];
    [shadow addPath:@"/usr/sbin/absd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/ac" restricted:YES];
    [shadow addPath:@"/usr/sbin/accton" restricted:YES];
    [shadow addPath:@"/usr/sbin/addNetworkInterface" restricted:YES];
    [shadow addPath:@"/usr/sbin/addNetworkInterface.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/addgnupghome" restricted:YES];
    [shadow addPath:@"/usr/sbin/applygnupgdefaults" restricted:YES];
    [shadow addPath:@"/usr/sbin/aslmanager" restricted:YES];
    [shadow addPath:@"/usr/sbin/aslmanager.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/cfprefsd" restricted:YES];
    [shadow addPath:@"/usr/sbin/cfprefsd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/chown" restricted:YES];
    [shadow addPath:@"/usr/sbin/chroot" restricted:YES];
    [shadow addPath:@"/usr/sbin/ckksctl" restricted:YES];
    [shadow addPath:@"/usr/sbin/dev_mkdb" restricted:YES];
    [shadow addPath:@"/usr/sbin/distnoted" restricted:YES];
    [shadow addPath:@"/usr/sbin/distnoted.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/edquota" restricted:YES];
    [shadow addPath:@"/usr/sbin/fairplayd.H2" restricted:YES];
    [shadow addPath:@"/usr/sbin/fdisk" restricted:YES];
    [shadow addPath:@"/usr/sbin/filecoordinationd" restricted:YES];
    [shadow addPath:@"/usr/sbin/filecoordinationd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/hdik" restricted:YES];
    [shadow addPath:@"/usr/sbin/ioreg" restricted:YES];
    [shadow addPath:@"/usr/sbin/ioreg.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/iostat" restricted:YES];
    [shadow addPath:@"/usr/sbin/ipconfig" restricted:YES];
    [shadow addPath:@"/usr/sbin/ipconfig.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/mediaserverd" restricted:YES];
    [shadow addPath:@"/usr/sbin/mediaserverd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/mkfile" restricted:YES];
    [shadow addPath:@"/usr/sbin/nologin" restricted:YES];
    [shadow addPath:@"/usr/sbin/notifyd" restricted:YES];
    [shadow addPath:@"/usr/sbin/notifyd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/nvram" restricted:YES];
    [shadow addPath:@"/usr/sbin/nvram.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/otctl" restricted:YES];
    [shadow addPath:@"/usr/sbin/pppd" restricted:YES];
    [shadow addPath:@"/usr/sbin/pppd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/pwd_mkdb" restricted:YES];
    [shadow addPath:@"/usr/sbin/quotaon" restricted:YES];
    [shadow addPath:@"/usr/sbin/racoon" restricted:YES];
    [shadow addPath:@"/usr/sbin/racoon.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/reboot" restricted:YES];
    [shadow addPath:@"/usr/sbin/repquota" restricted:YES];
    [shadow addPath:@"/usr/sbin/rtadvd" restricted:YES];
    [shadow addPath:@"/usr/sbin/rtadvd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/scutil" restricted:YES];
    [shadow addPath:@"/usr/sbin/scutil.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/spindump" restricted:YES];
    [shadow addPath:@"/usr/sbin/spindump.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/sshd" restricted:YES];
    [shadow addPath:@"/usr/sbin/startupfiletool" restricted:YES];
    [shadow addPath:@"/usr/sbin/sysctl" restricted:YES];
    [shadow addPath:@"/usr/sbin/syslogd" restricted:YES];
    [shadow addPath:@"/usr/sbin/syslogd.sbin" restricted:YES];
    [shadow addPath:@"/usr/sbin/vifs" restricted:YES];
    [shadow addPath:@"/usr/sbin/vipw" restricted:YES];
    [shadow addPath:@"/usr/sbin/vsdbutil" restricted:YES];
    [shadow addPath:@"/usr/sbin/zdump" restricted:YES];
    [shadow addPath:@"/usr/sbin/zic" restricted:YES];


    [shadow addPath:@"/usr/bin" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/bin/7z" restricted:YES];
    [shadow addPath:@"/usr/bin/7za" restricted:YES];
    [shadow addPath:@"/usr/bin/Filza" restricted:YES];
    [shadow addPath:@"/usr/bin/[" restricted:YES];
    [shadow addPath:@"/usr/bin/apt" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-cache" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-cdrom" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-config" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-extracttemplates" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-ftparchive" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-get" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-key" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-mark" restricted:YES];
    [shadow addPath:@"/usr/bin/apt-sortpkgs" restricted:YES];
    [shadow addPath:@"/usr/bin/arch" restricted:YES];
    [shadow addPath:@"/usr/bin/asn1Coding" restricted:YES];
    [shadow addPath:@"/usr/bin/asn1Decoding" restricted:YES];
    [shadow addPath:@"/usr/bin/asn1Parser" restricted:YES];
    [shadow addPath:@"/usr/bin/autopoint" restricted:YES];
    [shadow addPath:@"/usr/bin/b2sum" restricted:YES];
    [shadow addPath:@"/usr/bin/base32" restricted:YES];
    [shadow addPath:@"/usr/bin/base64" restricted:YES];
    [shadow addPath:@"/usr/bin/basename" restricted:YES];
    [shadow addPath:@"/usr/bin/basenc" restricted:YES];
    [shadow addPath:@"/usr/bin/bashbug" restricted:YES];
    [shadow addPath:@"/usr/bin/bbp" restricted:YES];
    [shadow addPath:@"/usr/bin/captoinfo" restricted:YES];
    [shadow addPath:@"/usr/bin/certtool" restricted:YES];
    [shadow addPath:@"/usr/bin/cfversion" restricted:YES];
    [shadow addPath:@"/usr/bin/chcon" restricted:YES];
    [shadow addPath:@"/usr/bin/chfn" restricted:YES];
    [shadow addPath:@"/usr/bin/chown" restricted:YES];
    [shadow addPath:@"/usr/bin/chsh" restricted:YES];
    [shadow addPath:@"/usr/bin/cksum" restricted:YES];
    [shadow addPath:@"/usr/bin/clear" restricted:YES];
    [shadow addPath:@"/usr/bin/cmp" restricted:YES];
    [shadow addPath:@"/usr/bin/comm" restricted:YES];
    [shadow addPath:@"/usr/bin/csplit" restricted:YES];
    [shadow addPath:@"/usr/bin/curl" restricted:YES];
    [shadow addPath:@"/usr/bin/curl-config" restricted:YES];
    [shadow addPath:@"/usr/bin/cut" restricted:YES];
    [shadow addPath:@"/usr/bin/cycc" restricted:YES];
    [shadow addPath:@"/usr/bin/cynject" restricted:YES];
    [shadow addPath:@"/usr/bin/db_archive" restricted:YES];
    [shadow addPath:@"/usr/bin/db_checkpoint" restricted:YES];
    [shadow addPath:@"/usr/bin/db_convert" restricted:YES];
    [shadow addPath:@"/usr/bin/db_deadlock" restricted:YES];
    [shadow addPath:@"/usr/bin/db_dump" restricted:YES];
    [shadow addPath:@"/usr/bin/db_hotbackup" restricted:YES];
    [shadow addPath:@"/usr/bin/db_load" restricted:YES];
    [shadow addPath:@"/usr/bin/db_log_verify" restricted:YES];
    [shadow addPath:@"/usr/bin/db_printlog" restricted:YES];
    [shadow addPath:@"/usr/bin/db_recover" restricted:YES];
    [shadow addPath:@"/usr/bin/db_replicate" restricted:YES];
    [shadow addPath:@"/usr/bin/db_stat" restricted:YES];
    [shadow addPath:@"/usr/bin/db_tuner" restricted:YES];
    [shadow addPath:@"/usr/bin/db_upgrade" restricted:YES];
    [shadow addPath:@"/usr/bin/db_verify" restricted:YES];
    [shadow addPath:@"/usr/bin/diff" restricted:YES];
    [shadow addPath:@"/usr/bin/diff3" restricted:YES];
    [shadow addPath:@"/usr/bin/dircolors" restricted:YES];
    [shadow addPath:@"/usr/bin/dirmngr" restricted:YES];
    [shadow addPath:@"/usr/bin/dirmngr-client" restricted:YES];
    [shadow addPath:@"/usr/bin/dirname" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-deb" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-divert" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-maintscript-helper" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-query" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-split" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-statoverride" restricted:YES];
    [shadow addPath:@"/usr/bin/dpkg-trigger" restricted:YES];
    [shadow addPath:@"/usr/bin/dselect" restricted:YES];
    [shadow addPath:@"/usr/bin/du" restricted:YES];
    [shadow addPath:@"/usr/bin/dumpsexp" restricted:YES];
    [shadow addPath:@"/usr/bin/ecidecid" restricted:YES];
    [shadow addPath:@"/usr/bin/env" restricted:YES];
    [shadow addPath:@"/usr/bin/envsubst" restricted:YES];
    [shadow addPath:@"/usr/bin/expand" restricted:YES];
    [shadow addPath:@"/usr/bin/expr" restricted:YES];
    [shadow addPath:@"/usr/bin/factor" restricted:YES];
    [shadow addPath:@"/usr/bin/file" restricted:YES];
    [shadow addPath:@"/usr/bin/fileproviderctl" restricted:YES];
    [shadow addPath:@"/usr/bin/find" restricted:YES];
    [shadow addPath:@"/usr/bin/fmt" restricted:YES];
    [shadow addPath:@"/usr/bin/fold" restricted:YES];
    [shadow addPath:@"/usr/bin/funzip" restricted:YES];
    [shadow addPath:@"/usr/bin/getconf" restricted:YES];
    [shadow addPath:@"/usr/bin/getopt" restricted:YES];
    [shadow addPath:@"/usr/bin/gettext" restricted:YES];
    [shadow addPath:@"/usr/bin/gettext.sh" restricted:YES];
    [shadow addPath:@"/usr/bin/gettextize" restricted:YES];
    [shadow addPath:@"/usr/bin/getty" restricted:YES];
    [shadow addPath:@"/usr/bin/gnupg2" restricted:YES];
    [shadow addPath:@"/usr/bin/gnutls-cli" restricted:YES];
    [shadow addPath:@"/usr/bin/gnutls-cli-debug" restricted:YES];
    [shadow addPath:@"/usr/bin/gnutls-serv" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg-agent" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg-connect-agent" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg-error" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg-error-config" restricted:YES];
    [shadow addPath:@"/usr/bin/gpg-wks-server" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgconf" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgparsemail" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgrt-config" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgscm" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgsm" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgtar" restricted:YES];
    [shadow addPath:@"/usr/bin/gpgv" restricted:YES];
    [shadow addPath:@"/usr/bin/groups" restricted:YES];
    [shadow addPath:@"/usr/bin/gssc" restricted:YES];
    [shadow addPath:@"/usr/bin/head" restricted:YES];
    [shadow addPath:@"/usr/bin/hmac256" restricted:YES];
    [shadow addPath:@"/usr/bin/hostid" restricted:YES];
    [shadow addPath:@"/usr/bin/hostinfo" restricted:YES];
    [shadow addPath:@"/usr/bin/id" restricted:YES];
    [shadow addPath:@"/usr/bin/idn2" restricted:YES];
    [shadow addPath:@"/usr/bin/infocmp" restricted:YES];
    [shadow addPath:@"/usr/bin/infotocap" restricted:YES];
    [shadow addPath:@"/usr/bin/install" restricted:YES];
    [shadow addPath:@"/usr/bin/iomfsetgamma" restricted:YES];
    [shadow addPath:@"/usr/bin/join" restricted:YES];
    [shadow addPath:@"/usr/bin/kbxutil" restricted:YES];
    [shadow addPath:@"/usr/bin/killall" restricted:YES];
    [shadow addPath:@"/usr/bin/ksba-config" restricted:YES];
    [shadow addPath:@"/usr/bin/ldid" restricted:YES];
    [shadow addPath:@"/usr/bin/ldrestart" restricted:YES];
    [shadow addPath:@"/usr/bin/libassuan-config" restricted:YES];
    [shadow addPath:@"/usr/bin/libgcrypt-config" restricted:YES];
    [shadow addPath:@"/usr/bin/link" restricted:YES];
    [shadow addPath:@"/usr/bin/locate" restricted:YES];
    [shadow addPath:@"/usr/bin/login" restricted:YES];
    [shadow addPath:@"/usr/bin/logname" restricted:YES];
    [shadow addPath:@"/usr/bin/lsdiagnose" restricted:YES];
    [shadow addPath:@"/usr/bin/lz4" restricted:YES];
    [shadow addPath:@"/usr/bin/lz4c" restricted:YES];
    [shadow addPath:@"/usr/bin/lz4cat" restricted:YES];
    [shadow addPath:@"/usr/bin/lzcat" restricted:YES];
    [shadow addPath:@"/usr/bin/lzcmp" restricted:YES];
    [shadow addPath:@"/usr/bin/lzdiff" restricted:YES];
    [shadow addPath:@"/usr/bin/lzegrep" restricted:YES];
    [shadow addPath:@"/usr/bin/lzfgrep" restricted:YES];
    [shadow addPath:@"/usr/bin/lzgrep" restricted:YES];
    [shadow addPath:@"/usr/bin/lzless" restricted:YES];
    [shadow addPath:@"/usr/bin/lzma" restricted:YES];
    [shadow addPath:@"/usr/bin/lzmadec" restricted:YES];
    [shadow addPath:@"/usr/bin/lzmainfo" restricted:YES];
    [shadow addPath:@"/usr/bin/lzmore" restricted:YES];
    [shadow addPath:@"/usr/bin/md5sum" restricted:YES];
    [shadow addPath:@"/usr/bin/mkfifo" restricted:YES];
    [shadow addPath:@"/usr/bin/mktemp" restricted:YES];
    [shadow addPath:@"/usr/bin/mpicalc" restricted:YES];
    [shadow addPath:@"/usr/bin/msgattrib" restricted:YES];
    [shadow addPath:@"/usr/bin/msgcat" restricted:YES];
    [shadow addPath:@"/usr/bin/msgcmp" restricted:YES];
    [shadow addPath:@"/usr/bin/msgcomm" restricted:YES];
    [shadow addPath:@"/usr/bin/msgconv" restricted:YES];
    [shadow addPath:@"/usr/bin/msgen" restricted:YES];
    [shadow addPath:@"/usr/bin/msgexec" restricted:YES];
    [shadow addPath:@"/usr/bin/msgfilter" restricted:YES];
    [shadow addPath:@"/usr/bin/msgfmt" restricted:YES];
    [shadow addPath:@"/usr/bin/msggrep" restricted:YES];
    [shadow addPath:@"/usr/bin/msginit" restricted:YES];
    [shadow addPath:@"/usr/bin/msgmerge" restricted:YES];
    [shadow addPath:@"/usr/bin/msgunfmt" restricted:YES];
    [shadow addPath:@"/usr/bin/msguniq" restricted:YES];
    [shadow addPath:@"/usr/bin/ncurses6-config" restricted:YES];
    [shadow addPath:@"/usr/bin/ncursesw6-config" restricted:YES];
    [shadow addPath:@"/usr/bin/nettle-hash" restricted:YES];
    [shadow addPath:@"/usr/bin/nettle-lfib-stream" restricted:YES];
    [shadow addPath:@"/usr/bin/nettle-pbkdf2" restricted:YES];
    [shadow addPath:@"/usr/bin/nfsstat" restricted:YES];
    [shadow addPath:@"/usr/bin/ngettext" restricted:YES];
    [shadow addPath:@"/usr/bin/nice" restricted:YES];
    [shadow addPath:@"/usr/bin/nl" restricted:YES];
    [shadow addPath:@"/usr/bin/nohup" restricted:YES];
    [shadow addPath:@"/usr/bin/nproc" restricted:YES];
    [shadow addPath:@"/usr/bin/npth-config" restricted:YES];
    [shadow addPath:@"/usr/bin/numfmt" restricted:YES];
    [shadow addPath:@"/usr/bin/ocsptool" restricted:YES];
    [shadow addPath:@"/usr/bin/od" restricted:YES];
    [shadow addPath:@"/usr/bin/p11-kit" restricted:YES];
    [shadow addPath:@"/usr/bin/p11tool" restricted:YES];
    [shadow addPath:@"/usr/bin/pager" restricted:YES];
    [shadow addPath:@"/usr/bin/pagesize" restricted:YES];
    [shadow addPath:@"/usr/bin/passwd" restricted:YES];
    [shadow addPath:@"/usr/bin/paste" restricted:YES];
    [shadow addPath:@"/usr/bin/pathchk" restricted:YES];
    [shadow addPath:@"/usr/bin/pcre2-config" restricted:YES];
    [shadow addPath:@"/usr/bin/pcre2grep" restricted:YES];
    [shadow addPath:@"/usr/bin/pcre2test" restricted:YES];
    [shadow addPath:@"/usr/bin/pinky" restricted:YES];
    [shadow addPath:@"/usr/bin/pkcs1-conv" restricted:YES];
    [shadow addPath:@"/usr/bin/pr" restricted:YES];
    [shadow addPath:@"/usr/bin/printenv" restricted:YES];
    [shadow addPath:@"/usr/bin/printf" restricted:YES];
    [shadow addPath:@"/usr/bin/psktool" restricted:YES];
    [shadow addPath:@"/usr/bin/ptx" restricted:YES];
    [shadow addPath:@"/usr/bin/quota" restricted:YES];
    [shadow addPath:@"/usr/bin/realpath" restricted:YES];
    [shadow addPath:@"/usr/bin/recode-sr-latin" restricted:YES];
    [shadow addPath:@"/usr/bin/renice" restricted:YES];
    [shadow addPath:@"/usr/bin/reset" restricted:YES];
    [shadow addPath:@"/usr/bin/runcon" restricted:YES];
    [shadow addPath:@"/usr/bin/sbdidlaunch" restricted:YES];
    [shadow addPath:@"/usr/bin/sbreload" restricted:YES];
    [shadow addPath:@"/usr/bin/scp" restricted:YES];
    [shadow addPath:@"/usr/bin/script" restricted:YES];
    [shadow addPath:@"/usr/bin/sdiff" restricted:YES];
    [shadow addPath:@"/usr/bin/seq" restricted:YES];
    [shadow addPath:@"/usr/bin/sexp-conv" restricted:YES];
    [shadow addPath:@"/usr/bin/sftp" restricted:YES];
    [shadow addPath:@"/usr/bin/sha1sum" restricted:YES];
    [shadow addPath:@"/usr/bin/sha224sum" restricted:YES];
    [shadow addPath:@"/usr/bin/sha256sum" restricted:YES];
    [shadow addPath:@"/usr/bin/sha384sum" restricted:YES];
    [shadow addPath:@"/usr/bin/sha512sum" restricted:YES];
    [shadow addPath:@"/usr/bin/shred" restricted:YES];
    [shadow addPath:@"/usr/bin/shuf" restricted:YES];
    [shadow addPath:@"/usr/bin/snappy" restricted:YES];
    [shadow addPath:@"/usr/bin/sort" restricted:YES];
    [shadow addPath:@"/usr/bin/split" restricted:YES];
    [shadow addPath:@"/usr/bin/srptool" restricted:YES];
    [shadow addPath:@"/usr/bin/ssh" restricted:YES];
    [shadow addPath:@"/usr/bin/ssh-add" restricted:YES];
    [shadow addPath:@"/usr/bin/ssh-agent" restricted:YES];
    [shadow addPath:@"/usr/bin/ssh-keygen" restricted:YES];
    [shadow addPath:@"/usr/bin/ssh-keyscan" restricted:YES];
    [shadow addPath:@"/usr/bin/stat" restricted:YES];
    [shadow addPath:@"/usr/bin/stdbuf" restricted:YES];
    [shadow addPath:@"/usr/bin/sum" restricted:YES];
    [shadow addPath:@"/usr/bin/sw_vers" restricted:YES];
    [shadow addPath:@"/usr/bin/tac" restricted:YES];
    [shadow addPath:@"/usr/bin/tail" restricted:YES];
    [shadow addPath:@"/usr/bin/tar" restricted:YES];
    [shadow addPath:@"/usr/bin/tee" restricted:YES];
    [shadow addPath:@"/usr/bin/test" restricted:YES];
    [shadow addPath:@"/usr/bin/tic" restricted:YES];
    [shadow addPath:@"/usr/bin/time" restricted:YES];
    [shadow addPath:@"/usr/bin/timeout" restricted:YES];
    [shadow addPath:@"/usr/bin/toe" restricted:YES];
    [shadow addPath:@"/usr/bin/tput" restricted:YES];
    [shadow addPath:@"/usr/bin/tr" restricted:YES];
    [shadow addPath:@"/usr/bin/truncate" restricted:YES];
    [shadow addPath:@"/usr/bin/trust" restricted:YES];
    [shadow addPath:@"/usr/bin/tset" restricted:YES];
    [shadow addPath:@"/usr/bin/tsort" restricted:YES];
    [shadow addPath:@"/usr/bin/tsplugin" restricted:YES];
    [shadow addPath:@"/usr/bin/tsplugin/cloudOcr.so" restricted:YES];
    [shadow addPath:@"/usr/bin/tsplugin/ts.so" restricted:YES];
    [shadow addPath:@"/usr/bin/tsplugin/tsimg.so" restricted:YES];
    [shadow addPath:@"/usr/bin/tsplugin/tsnet.so" restricted:YES];
    [shadow addPath:@"/usr/bin/tty" restricted:YES];
    [shadow addPath:@"/usr/bin/uicache" restricted:YES];
    [shadow addPath:@"/usr/bin/uiduid" restricted:YES];
    [shadow addPath:@"/usr/bin/uiopen" restricted:YES];
    [shadow addPath:@"/usr/bin/unexpand" restricted:YES];
    [shadow addPath:@"/usr/bin/uniq" restricted:YES];
    [shadow addPath:@"/usr/bin/unlink" restricted:YES];
    [shadow addPath:@"/usr/bin/unlz4" restricted:YES];
    [shadow addPath:@"/usr/bin/unlzma" restricted:YES];
    [shadow addPath:@"/usr/bin/unrar" restricted:YES];
    [shadow addPath:@"/usr/bin/unxz" restricted:YES];
    [shadow addPath:@"/usr/bin/unzip" restricted:YES];
    [shadow addPath:@"/usr/bin/unzipsfx" restricted:YES];
    [shadow addPath:@"/usr/bin/update-alternatives" restricted:YES];
    [shadow addPath:@"/usr/bin/updatedb" restricted:YES];
    [shadow addPath:@"/usr/bin/uptime" restricted:YES];
    [shadow addPath:@"/usr/bin/users" restricted:YES];
    [shadow addPath:@"/usr/bin/watchgnupg" restricted:YES];
    [shadow addPath:@"/usr/bin/wc" restricted:YES];
    [shadow addPath:@"/usr/bin/wget" restricted:YES];
    [shadow addPath:@"/usr/bin/which" restricted:YES];
    [shadow addPath:@"/usr/bin/who" restricted:YES];
    [shadow addPath:@"/usr/bin/whoami" restricted:YES];
    [shadow addPath:@"/usr/bin/xargs" restricted:YES];
    [shadow addPath:@"/usr/bin/xgettext" restricted:YES];
    [shadow addPath:@"/usr/bin/xz" restricted:YES];
    [shadow addPath:@"/usr/bin/xzcat" restricted:YES];
    [shadow addPath:@"/usr/bin/xzcmp" restricted:YES];
    [shadow addPath:@"/usr/bin/xzdec" restricted:YES];
    [shadow addPath:@"/usr/bin/xzdiff" restricted:YES];
    [shadow addPath:@"/usr/bin/xzegrep" restricted:YES];
    [shadow addPath:@"/usr/bin/xzfgrep" restricted:YES];
    [shadow addPath:@"/usr/bin/xzgrep" restricted:YES];
    [shadow addPath:@"/usr/bin/xzless" restricted:YES];
    [shadow addPath:@"/usr/bin/xzmore" restricted:YES];
    [shadow addPath:@"/usr/bin/yat2m" restricted:YES];
    [shadow addPath:@"/usr/bin/yes" restricted:YES];
    [shadow addPath:@"/usr/bin/zip" restricted:YES];
    [shadow addPath:@"/usr/bin/zipcloak" restricted:YES];
    [shadow addPath:@"/usr/bin/zipnote" restricted:YES];
    [shadow addPath:@"/usr/bin/zipsplit" restricted:YES];
    [shadow addPath:@"/usr/bin/zorrodaemon" restricted:YES];
    [shadow addPath:@"/usr/bin/zorrodo" restricted:YES];


    [shadow addPath:@"/usr/bin/DumpBasebandCrash" restricted:NO];
    [shadow addPath:@"/usr/bin/PerfPowerServicesExtended" restricted:NO];
    [shadow addPath:@"/usr/bin/abmlite" restricted:NO];
    [shadow addPath:@"/usr/bin/brctl" restricted:NO];
    [shadow addPath:@"/usr/bin/footprint" restricted:NO];
    [shadow addPath:@"/usr/bin/hidutil" restricted:NO];
    [shadow addPath:@"/usr/bin/hpmdiagnose" restricted:NO];
    [shadow addPath:@"/usr/bin/kbdebug" restricted:NO];
    [shadow addPath:@"/usr/bin/powerlogHelperd" restricted:NO];
    [shadow addPath:@"/usr/bin/sysdiagnose" restricted:NO];
    [shadow addPath:@"/usr/bin/tailspin" restricted:NO];
    [shadow addPath:@"/usr/bin/taskinfo" restricted:NO];
    [shadow addPath:@"/usr/bin/vm_stat" restricted:NO];
    [shadow addPath:@"/usr/bin/zprint" restricted:NO];

    if([shadow useTweakCompatibilityMode] && extra_compat) {
        //DIY-A
        [shadow addPath:@"/usr/etc" restricted:YES];
        [shadow addPath:@"/usr/lib" restricted:YES];
        [shadow addPath:@"/usr/games" restricted:YES];
        [shadow addPath:@"/usr/include" restricted:YES];
        [shadow addPath:@"/usr/sbin" restricted:YES];
        [shadow addPath:@"/usr/local" restricted:YES];
        [shadow addPath:@"/usr/libexec" restricted:YES];
        [shadow addPath:@"/usr/share" restricted:YES];
        [shadow addPath:@"/usr/standalone" restricted:YES];
        [shadow addPath:@"/usr/lib/apt" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses/libcurses.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses/libncurses.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/applenb.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/bash" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik/substrate" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik/substrate/MS.cy" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/lib4758cca.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libaep.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libatalla.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libcapi.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libchil.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libcswift.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libgmp.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libgost.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libnuron.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libpadlock.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libsureware.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libubsec.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1/capi.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1/padlock.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/cldr-plurals" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/hostname" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/project-id" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/urlget" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/user-email" restricted:YES];
        [shadow addPath:@"/usr/lib/libMTLCapture.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapplist.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-inst.2.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-inst.2.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-pkg.5.0.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-pkg.5.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-private.0.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-private.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libasprintf.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libasprintf.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb-6.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb-6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdpkg.a" restricted:YES];
        [shadow addPath:@"/usr/lib/libffi-trampolines.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.20.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextlib-0.19.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextlib.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextpo.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextpo.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextsrc-0.19.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextsrc.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.10.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutls.30.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutls.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutlsxx.28.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutlsxx.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.5.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.6.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.7.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.7.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.4.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.4.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libimg4_development.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libintl.9.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libintl.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.la" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.1.7.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.6.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnghttp2.14.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-posix.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-posix.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libplist.3.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libprefs.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.5.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.6.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.7.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.7.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/librocketbootstrap.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libsnappy.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssh2.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssh2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssl.1.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssl.1.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libsubstrate.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.la" restricted:YES];
        [shadow addPath:@"/usr/lib/p11-kit-proxy.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7z" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7z.so" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7zCon.sfx" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7za" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/Codecs" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/Codecs/Rar.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-client.la" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-client.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-trust.la" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-trust.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/bash.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/form.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/formw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/gnutls.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/hogweed.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libcurl.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libdpkg.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libidn2.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/liblz4.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libpcre2-8.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libpcre2-posix.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libssh2.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libtasn1.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/menu.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/menuw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/ncurses.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/ncursesw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/nettle.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/p11-kit-1.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/panel.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/panelw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/readline.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl/cert.pem" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl/certs" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateBootstrap.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateInserter.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateLoader.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/swift" restricted:YES];
        [shadow addPath:@"/usr/lib/swift/libswiftDemangle.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/swift/libswiftXCTest.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/terminfo" restricted:YES];
        [shadow addPath:@"/usr/lib/libsubstrate" restricted:YES];
        [shadow addPath:@"/usr/lib/libsubstitute" restricted:YES];
        [shadow addPath:@"/usr/lib/libSubstitrate" restricted:YES];
        [shadow addPath:@"/usr/lib/TweakInject" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate" restricted:YES];
        [shadow addPath:@"/usr/lib/tweaks" restricted:YES];
        [shadow addPath:@"/usr/lib/apt" restricted:YES];
        [shadow addPath:@"/usr/lib/bash" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript" restricted:YES];
        [shadow addPath:@"/usr/lib/libmis.dylib" restricted:YES];
	//DIY-B
    } else {
        [shadow addPath:@"/usr/lib" restricted:YES hidden:NO];
        //DIY-A
        [shadow addPath:@"/usr/lib/apt" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses/libcurses.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/_ncurses/libncurses.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/applenb.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/bash" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik/substrate" restricted:YES];
        [shadow addPath:@"/usr/lib/cycript0.9/com/saurik/substrate/MS.cy" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/lib4758cca.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libaep.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libatalla.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libcapi.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libchil.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libcswift.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libgmp.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libgost.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libnuron.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libpadlock.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libsureware.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.0/libubsec.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1/capi.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/engines-1.1/padlock.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/cldr-plurals" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/hostname" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/project-id" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/urlget" restricted:YES];
        [shadow addPath:@"/usr/lib/gettext/user-email" restricted:YES];
        [shadow addPath:@"/usr/lib/libMTLCapture.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapplist.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-inst.2.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-inst.2.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-pkg.5.0.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-pkg.5.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-private.0.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libapt-private.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libasprintf.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libasprintf.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libassuan.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb-6.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb-6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdb.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libdpkg.a" restricted:YES];
        [shadow addPath:@"/usr/lib/libffi-trampolines.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.20.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgcrypt.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextlib-0.19.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextlib.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextpo.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextpo.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextsrc-0.19.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgettextsrc.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.10.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgmp.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutls.30.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutls.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutlsxx.28.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgnutlsxx.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libgpg-error.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.5.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.6.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.7.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.7.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhistory.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.4.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.4.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libhogweed.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libidn2.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libimg4_development.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libintl.9.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libintl.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libksba.la" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.1.7.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/liblz4.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.6.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnettle.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnghttp2.14.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libnpth.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libp11-kit.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanel5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpanelw5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-posix.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libpcre2-posix.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libplist.3.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libprefs.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.5.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.5.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.6.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.7.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.7.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.8.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.8.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libreadline.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/librocketbootstrap.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libsnappy.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssh2.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssh2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssl.1.0.0.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libssl.1.1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libsubstrate.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.6.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libtasn1.la" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.2.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/libunistring.la" restricted:YES];
        [shadow addPath:@"/usr/lib/p11-kit-proxy.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7z" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7z.so" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7zCon.sfx" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/7za" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/Codecs" restricted:YES];
        [shadow addPath:@"/usr/lib/p7zip/Codecs/Rar.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-client.la" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-client.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-trust.la" restricted:YES];
        [shadow addPath:@"/usr/lib/pkcs11/p11-kit-trust.so" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/bash.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/form.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/formw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/gnutls.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/hogweed.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libcurl.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libdpkg.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libidn2.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/liblz4.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libpcre2-8.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libpcre2-posix.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libssh2.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/libtasn1.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/menu.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/menuw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/ncurses.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/ncursesw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/nettle.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/p11-kit-1.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/panel.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/panelw.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/pkgconfig/readline.pc" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl/cert.pem" restricted:YES];
        [shadow addPath:@"/usr/lib/ssl/certs" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateBootstrap.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateInserter.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/substrate/SubstrateLoader.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/swift" restricted:YES];
        [shadow addPath:@"/usr/lib/swift/libswiftDemangle.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/swift/libswiftXCTest.dylib" restricted:YES];
        [shadow addPath:@"/usr/lib/terminfo" restricted:YES];
	//DIY-B
        [shadow addPath:@"/usr/lib/FDRSealingMap.plist" restricted:NO];
        [shadow addPath:@"/usr/lib/bbmasks" restricted:NO];
        [shadow addPath:@"/usr/lib/dyld" restricted:NO];
        [shadow addPath:@"/usr/lib/libCRFSuite" restricted:NO];
        [shadow addPath:@"/usr/lib/libDHCPServer" restricted:NO];
        [shadow addPath:@"/usr/lib/libMatch" restricted:NO];
        [shadow addPath:@"/usr/lib/libSystem" restricted:NO];
        [shadow addPath:@"/usr/lib/libarchive" restricted:NO];
        [shadow addPath:@"/usr/lib/libbsm" restricted:NO];
        [shadow addPath:@"/usr/lib/libbz2" restricted:NO];
        [shadow addPath:@"/usr/lib/libc++" restricted:NO];
        [shadow addPath:@"/usr/lib/libc" restricted:NO];
        [shadow addPath:@"/usr/lib/libcharset" restricted:NO];
        [shadow addPath:@"/usr/lib/libcurses" restricted:NO];
        [shadow addPath:@"/usr/lib/libdbm" restricted:NO];
        [shadow addPath:@"/usr/lib/libdl" restricted:NO];
        [shadow addPath:@"/usr/lib/libeasyperf" restricted:NO];
        [shadow addPath:@"/usr/lib/libedit" restricted:NO];
        [shadow addPath:@"/usr/lib/libexslt" restricted:NO];
        [shadow addPath:@"/usr/lib/libextension" restricted:NO];
        [shadow addPath:@"/usr/lib/libform" restricted:NO];
        [shadow addPath:@"/usr/lib/libiconv" restricted:NO];
        [shadow addPath:@"/usr/lib/libicucore" restricted:NO];
        [shadow addPath:@"/usr/lib/libinfo" restricted:NO];
        [shadow addPath:@"/usr/lib/libipsec" restricted:NO];
        [shadow addPath:@"/usr/lib/liblzma" restricted:NO];
        [shadow addPath:@"/usr/lib/libm" restricted:NO];
        [shadow addPath:@"/usr/lib/libmecab" restricted:NO];
        [shadow addPath:@"/usr/lib/libncurses" restricted:NO];
        [shadow addPath:@"/usr/lib/libobjc" restricted:NO];
        [shadow addPath:@"/usr/lib/libpcap" restricted:NO];
        [shadow addPath:@"/usr/lib/libpmsample" restricted:NO];
        [shadow addPath:@"/usr/lib/libpoll" restricted:NO];
        [shadow addPath:@"/usr/lib/libproc" restricted:NO];
        [shadow addPath:@"/usr/lib/libpthread" restricted:NO];
        [shadow addPath:@"/usr/lib/libresolv" restricted:NO];
        [shadow addPath:@"/usr/lib/librpcsvc" restricted:NO];
        [shadow addPath:@"/usr/lib/libsandbox" restricted:NO];
        [shadow addPath:@"/usr/lib/libsqlite3" restricted:NO];
        [shadow addPath:@"/usr/lib/libstdc++" restricted:NO];
        [shadow addPath:@"/usr/lib/libtidy" restricted:NO];
        [shadow addPath:@"/usr/lib/libutil" restricted:NO];
        [shadow addPath:@"/usr/lib/libxml2" restricted:NO];
        [shadow addPath:@"/usr/lib/libxslt" restricted:NO];
        [shadow addPath:@"/usr/lib/libz" restricted:NO];
        [shadow addPath:@"/usr/lib/libperfcheck" restricted:NO];
        [shadow addPath:@"/usr/lib/libedit" restricted:NO];
        [shadow addPath:@"/usr/lib/log" restricted:NO];
        [shadow addPath:@"/usr/lib/system" restricted:NO];
        [shadow addPath:@"/usr/lib/updaters" restricted:NO];
        [shadow addPath:@"/usr/lib/xpc" restricted:NO];
    }
    
    [shadow addPath:@"/usr/libexec" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/libexec/MSUEarlyBootTask" restricted:YES];
    [shadow addPath:@"/usr/libexec/SensorKitALSHelper" restricted:YES];
    [shadow addPath:@"/usr/libexec/System" restricted:YES];
    [shadow addPath:@"/usr/libexec/System/Library" restricted:YES];
    [shadow addPath:@"/usr/libexec/System/Library/Preferences" restricted:YES];
    [shadow addPath:@"/usr/libexec/System/Library/Preferences/Logging" restricted:YES];
    [shadow addPath:@"/usr/libexec/System/Library/Preferences/Logging/Subsystems" restricted:YES];
    [shadow addPath:@"/usr/libexec/System/Library/Preferences/Logging/Subsystems/com.apple.mobileassetd.plist" restricted:YES];
    [shadow addPath:@"/usr/libexec/_rocketd_reenable" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/apt-helper" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/cdrom" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/copy" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/file" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/ftp" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/gpgv" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/http" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/https" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror+copy" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror+file" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror+ftp" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror+http" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/mirror+https" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/rred" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/rsh" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/ssh" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/methods/store" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/planners" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/planners/apt" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/planners/dump" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/solvers" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/solvers/apt" restricted:YES];
    [shadow addPath:@"/usr/libexec/apt/solvers/dump" restricted:YES];
    [shadow addPath:@"/usr/libexec/bigram" restricted:YES];
    [shadow addPath:@"/usr/libexec/checkerboardd" restricted:YES];
    [shadow addPath:@"/usr/libexec/code" restricted:YES];
    [shadow addPath:@"/usr/libexec/corebrightnessdiag" restricted:YES];
    [shadow addPath:@"/usr/libexec/coredatad" restricted:YES];
    [shadow addPath:@"/usr/libexec/coreidvd" restricted:YES];
    [shadow addPath:@"/usr/libexec/coreutils" restricted:YES];
    [shadow addPath:@"/usr/libexec/coreutils/libstdbuf.so" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/asuser" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/cfversion" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/cydo" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/du" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/finish.sh" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/firmware.sh" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/firmware.sh.distrib" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/free.sh" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/move.sh" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/setnsfpn" restricted:YES];
    [shadow addPath:@"/usr/libexec/cydia/startup" restricted:YES];
    [shadow addPath:@"/usr/libexec/datastored" restricted:YES];
    [shadow addPath:@"/usr/libexec/deferredmediad" restricted:YES];
    [shadow addPath:@"/usr/libexec/dhcp6d" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt/desc.apt" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt/install" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt/names" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt/setup" restricted:YES];
    [shadow addPath:@"/usr/libexec/dpkg/methods/apt/update" restricted:YES];
    [shadow addPath:@"/usr/libexec/filza" restricted:YES];
    [shadow addPath:@"/usr/libexec/filza/Filza" restricted:YES];
    [shadow addPath:@"/usr/libexec/filza/FilzaHelper" restricted:YES];
    [shadow addPath:@"/usr/libexec/filza/FilzaWebDAVServer" restricted:YES];
    [shadow addPath:@"/usr/libexec/firmware.sh" restricted:YES];
    [shadow addPath:@"/usr/libexec/frcode" restricted:YES];
    [shadow addPath:@"/usr/libexec/fusiond" restricted:YES];
    [shadow addPath:@"/usr/libexec/gpg-check-pattern" restricted:YES];
    [shadow addPath:@"/usr/libexec/gpg-preset-passphrase" restricted:YES];
    [shadow addPath:@"/usr/libexec/gpg-protect-tool" restricted:YES];
    [shadow addPath:@"/usr/libexec/gpg-wks-client" restricted:YES];
    [shadow addPath:@"/usr/libexec/handwritingd" restricted:YES];
    [shadow addPath:@"/usr/libexec/init_data_protection" restricted:YES];
    [shadow addPath:@"/usr/libexec/init_featureflags" restricted:YES];
    [shadow addPath:@"/usr/libexec/launchd_cache_loader" restricted:YES];
    [shadow addPath:@"/usr/libexec/ldid" restricted:YES];
    [shadow addPath:@"/usr/libexec/mdmd" restricted:YES];
    [shadow addPath:@"/usr/libexec/mdmuserd" restricted:YES];
    [shadow addPath:@"/usr/libexec/metrickitd" restricted:YES];
    [shadow addPath:@"/usr/libexec/nearbyd" restricted:YES];
    [shadow addPath:@"/usr/libexec/otpaird" restricted:YES];
    [shadow addPath:@"/usr/libexec/p11-kit" restricted:YES];
    [shadow addPath:@"/usr/libexec/p11-kit/p11-kit-remote" restricted:YES];
    [shadow addPath:@"/usr/libexec/p11-kit/p11-kit-server" restricted:YES];
    [shadow addPath:@"/usr/libexec/p11-kit/trust-extract-compat" restricted:YES];
    [shadow addPath:@"/usr/libexec/passcodenagd" restricted:YES];
    [shadow addPath:@"/usr/libexec/perfdiagsselfenabled" restricted:YES];
    [shadow addPath:@"/usr/libexec/prng_seedctl" restricted:YES];
    [shadow addPath:@"/usr/libexec/proactiveeventtrackerd" restricted:YES];
    [shadow addPath:@"/usr/libexec/profiled" restricted:YES];
    [shadow addPath:@"/usr/libexec/ptpcamerad" restricted:YES];
    [shadow addPath:@"/usr/libexec/relatived" restricted:YES];
    [shadow addPath:@"/usr/libexec/remindd" restricted:YES];
    [shadow addPath:@"/usr/libexec/remotectl" restricted:YES];
    [shadow addPath:@"/usr/libexec/rocketd" restricted:YES];
    [shadow addPath:@"/usr/libexec/runningboardd" restricted:YES];
    [shadow addPath:@"/usr/libexec/scdaemon" restricted:YES];
    [shadow addPath:@"/usr/libexec/searchpartyd" restricted:YES];
    [shadow addPath:@"/usr/libexec/sensorkitd" restricted:YES];
    [shadow addPath:@"/usr/libexec/seserviced" restricted:YES];
    [shadow addPath:@"/usr/libexec/sftp-server" restricted:YES];
    [shadow addPath:@"/usr/libexec/ssh-keysign" restricted:YES];
    [shadow addPath:@"/usr/libexec/ssh-pkcs11-helper" restricted:YES];
    [shadow addPath:@"/usr/libexec/ssh-sk-helper" restricted:YES];
    [shadow addPath:@"/usr/libexec/sshd-keygen-wrapper" restricted:YES];
    [shadow addPath:@"/usr/libexec/substrate" restricted:YES];
    [shadow addPath:@"/usr/libexec/substrated" restricted:YES];
    [shadow addPath:@"/usr/libexec/terminusd" restricted:YES];
    [shadow addPath:@"/usr/libexec/teslad" restricted:YES];
    [shadow addPath:@"/usr/libexec/thermalmonitord" restricted:YES];
    [shadow addPath:@"/usr/libexec/transparencyd" restricted:YES];
    [shadow addPath:@"/usr/libexec/triald" restricted:YES];
    [shadow addPath:@"/usr/libexec/vndevice" restricted:YES];
    [shadow addPath:@"/usr/libexec/watchdogd" restricted:YES];
    [shadow addPath:@"/usr/libexec/wifianalyticsd" restricted:YES];
    [shadow addPath:@"/usr/libexec/wifip2pd" restricted:YES];


    [shadow addPath:@"/usr/libexec/BackupAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/BackupAgent2" restricted:NO];
    [shadow addPath:@"/usr/libexec/CrashHousekeeping" restricted:NO];
    [shadow addPath:@"/usr/libexec/DataDetectorsSourceAccess" restricted:NO];
    [shadow addPath:@"/usr/libexec/FSTaskScheduler" restricted:NO];
    [shadow addPath:@"/usr/libexec/FinishRestoreFromBackup" restricted:NO];
    [shadow addPath:@"/usr/libexec/IOAccelMemoryInfoCollector" restricted:NO];
    [shadow addPath:@"/usr/libexec/IOMFB_bics_daemon" restricted:NO];
    [shadow addPath:@"/usr/libexec/Library" restricted:NO];
    [shadow addPath:@"/usr/libexec/MobileGestaltHelper" restricted:NO];
    [shadow addPath:@"/usr/libexec/MobileStorageMounter" restricted:NO];
    [shadow addPath:@"/usr/libexec/NANDTaskScheduler" restricted:NO];
    [shadow addPath:@"/usr/libexec/OTATaskingAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/PowerUIAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/PreboardService" restricted:NO];
    [shadow addPath:@"/usr/libexec/ProxiedCrashCopier" restricted:NO];
    [shadow addPath:@"/usr/libexec/PurpleReverseProxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/ReportMemoryException" restricted:NO];
    [shadow addPath:@"/usr/libexec/SafariCloudHistoryPushAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/SidecarRelay" restricted:NO];
    [shadow addPath:@"/usr/libexec/SyncAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/UserEventAgent" restricted:NO];
    [shadow addPath:@"/usr/libexec/addressbooksyncd" restricted:NO];
    [shadow addPath:@"/usr/libexec/adid" restricted:NO];
    [shadow addPath:@"/usr/libexec/adprivacyd" restricted:NO];
    [shadow addPath:@"/usr/libexec/adservicesd" restricted:NO];
    [shadow addPath:@"/usr/libexec/afcd" restricted:NO];
    [shadow addPath:@"/usr/libexec/airtunesd" restricted:NO];
    [shadow addPath:@"/usr/libexec/amfid" restricted:NO];
    [shadow addPath:@"/usr/libexec/asd" restricted:NO];
    [shadow addPath:@"/usr/libexec/assertiond" restricted:NO];
    [shadow addPath:@"/usr/libexec/atc" restricted:NO];
    [shadow addPath:@"/usr/libexec/atwakeup" restricted:NO];
    [shadow addPath:@"/usr/libexec/backboardd" restricted:NO];
    [shadow addPath:@"/usr/libexec/biometrickitd" restricted:NO];
    [shadow addPath:@"/usr/libexec/bootpd" restricted:NO];
    [shadow addPath:@"/usr/libexec/bulletindistributord" restricted:NO];
    [shadow addPath:@"/usr/libexec/captiveagent" restricted:NO];
    [shadow addPath:@"/usr/libexec/cc_fips_test" restricted:NO];
    [shadow addPath:@"/usr/libexec/checkpointd" restricted:NO];
    [shadow addPath:@"/usr/libexec/cloudpaird" restricted:NO];
    [shadow addPath:@"/usr/libexec/com.apple" restricted:NO];
    [shadow addPath:@"/usr/libexec/companion_proxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/configd" restricted:NO];
    [shadow addPath:@"/usr/libexec/corecaptured" restricted:NO];
    [shadow addPath:@"/usr/libexec/coreduetd" restricted:NO];
    [shadow addPath:@"/usr/libexec/crash_mover" restricted:NO];
    [shadow addPath:@"/usr/libexec/dasd" restricted:NO];
    [shadow addPath:@"/usr/libexec/demod" restricted:NO];
    [shadow addPath:@"/usr/libexec/demod_helper" restricted:NO];
    [shadow addPath:@"/usr/libexec/dhcpd" restricted:NO];
    [shadow addPath:@"/usr/libexec/diagnosticd" restricted:NO];
    [shadow addPath:@"/usr/libexec/diagnosticextensionsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/dmd" restricted:NO];
    [shadow addPath:@"/usr/libexec/dprivacyd" restricted:NO];
    [shadow addPath:@"/usr/libexec/dtrace" restricted:NO];
    [shadow addPath:@"/usr/libexec/duetexpertd" restricted:NO];
    [shadow addPath:@"/usr/libexec/eventkitsyncd" restricted:NO];
    [shadow addPath:@"/usr/libexec/fdrhelper" restricted:NO];
    [shadow addPath:@"/usr/libexec/findmydeviced" restricted:NO];
    [shadow addPath:@"/usr/libexec/finish_demo_restore" restricted:NO];
    [shadow addPath:@"/usr/libexec/fmfd" restricted:NO];
    [shadow addPath:@"/usr/libexec/fmflocatord" restricted:NO];
    [shadow addPath:@"/usr/libexec/fseventsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/ftp-proxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/gamecontrollerd" restricted:NO];
    [shadow addPath:@"/usr/libexec/gamed" restricted:NO];
    [shadow addPath:@"/usr/libexec/gpsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/hangreporter" restricted:NO];
    [shadow addPath:@"/usr/libexec/hangtracerd" restricted:NO];
    [shadow addPath:@"/usr/libexec/heartbeatd" restricted:NO];
    [shadow addPath:@"/usr/libexec/hostapd" restricted:NO];
    [shadow addPath:@"/usr/libexec/idamd" restricted:NO];
    [shadow addPath:@"/usr/libexec/init_data_protection -> seputil" restricted:NO];
    [shadow addPath:@"/usr/libexec/installd" restricted:NO];
    [shadow addPath:@"/usr/libexec/ioupsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/keybagd" restricted:NO];
    [shadow addPath:@"/usr/libexec/languageassetd" restricted:NO];
    [shadow addPath:@"/usr/libexec/locationd" restricted:NO];
    [shadow addPath:@"/usr/libexec/lockdownd" restricted:NO];
    [shadow addPath:@"/usr/libexec/logd" restricted:NO];
    [shadow addPath:@"/usr/libexec/lsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/lskdd" restricted:NO];
    [shadow addPath:@"/usr/libexec/lskdmsed" restricted:NO];
    [shadow addPath:@"/usr/libexec/magicswitchd" restricted:NO];
    [shadow addPath:@"/usr/libexec/mc_mobile_tunnel" restricted:NO];
    [shadow addPath:@"/usr/libexec/microstackshot" restricted:NO];
    [shadow addPath:@"/usr/libexec/misagent" restricted:NO];
    [shadow addPath:@"/usr/libexec/misd" restricted:NO];
    [shadow addPath:@"/usr/libexec/mmaintenanced" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_assertion_agent" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_diagnostics_relay" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_house_arrest" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_installation_proxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_obliterator" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobile_storage_proxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobileactivationd" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobileassetd" restricted:NO];
    [shadow addPath:@"/usr/libexec/mobilewatchdog" restricted:NO];
    [shadow addPath:@"/usr/libexec/mtmergeprops" restricted:NO];
    [shadow addPath:@"/usr/libexec/nanomediaremotelinkagent" restricted:NO];
    [shadow addPath:@"/usr/libexec/nanoregistryd" restricted:NO];
    [shadow addPath:@"/usr/libexec/nanoregistrylaunchd" restricted:NO];
    [shadow addPath:@"/usr/libexec/neagent" restricted:NO];
    [shadow addPath:@"/usr/libexec/nehelper" restricted:NO];
    [shadow addPath:@"/usr/libexec/nesessionmanager" restricted:NO];
    [shadow addPath:@"/usr/libexec/networkserviceproxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/nfcd" restricted:NO];
    [shadow addPath:@"/usr/libexec/nfrestore_service" restricted:NO];
    [shadow addPath:@"/usr/libexec/nlcd" restricted:NO];
    [shadow addPath:@"/usr/libexec/notification_proxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/nptocompaniond" restricted:NO];
    [shadow addPath:@"/usr/libexec/nsurlsessiond" restricted:NO];
    [shadow addPath:@"/usr/libexec/nsurlstoraged" restricted:NO];
    [shadow addPath:@"/usr/libexec/online-auth-agent" restricted:NO];
    [shadow addPath:@"/usr/libexec/oscard" restricted:NO];
    [shadow addPath:@"/usr/libexec/pcapd" restricted:NO];
    [shadow addPath:@"/usr/libexec/pcsstatus" restricted:NO];
    [shadow addPath:@"/usr/libexec/pfd" restricted:NO];
    [shadow addPath:@"/usr/libexec/pipelined" restricted:NO];
    [shadow addPath:@"/usr/libexec/pkd" restricted:NO];
    [shadow addPath:@"/usr/libexec/pkreporter" restricted:NO];
    [shadow addPath:@"/usr/libexec/ptpd" restricted:NO];
    [shadow addPath:@"/usr/libexec/rapportd" restricted:NO];
    [shadow addPath:@"/usr/libexec/replayd" restricted:NO];
    [shadow addPath:@"/usr/libexec/resourcegrabberd" restricted:NO];
    [shadow addPath:@"/usr/libexec/rolld" restricted:NO];
    [shadow addPath:@"/usr/libexec/routined" restricted:NO];
    [shadow addPath:@"/usr/libexec/rtbuddyd" restricted:NO];
    [shadow addPath:@"/usr/libexec/rtcreportingd" restricted:NO];
    [shadow addPath:@"/usr/libexec/safarifetcherd" restricted:NO];
    [shadow addPath:@"/usr/libexec/screenshotsyncd" restricted:NO];
    [shadow addPath:@"/usr/libexec/security-sysdiagnose" restricted:NO];
    [shadow addPath:@"/usr/libexec/securityd" restricted:NO];
    [shadow addPath:@"/usr/libexec/securityuploadd" restricted:NO];
    [shadow addPath:@"/usr/libexec/seld" restricted:NO];
    [shadow addPath:@"/usr/libexec/seputil" restricted:NO];
    [shadow addPath:@"/usr/libexec/sharingd" restricted:NO];
    [shadow addPath:@"/usr/libexec/signpost_reporter" restricted:NO];
    [shadow addPath:@"/usr/libexec/silhouette" restricted:NO];
    [shadow addPath:@"/usr/libexec/siriknowledged" restricted:NO];
    [shadow addPath:@"/usr/libexec/smcDiagnose" restricted:NO];
    [shadow addPath:@"/usr/libexec/splashboardd" restricted:NO];
    [shadow addPath:@"/usr/libexec/springboardservicesrelay" restricted:NO];
    [shadow addPath:@"/usr/libexec/streaming_zip_conduit" restricted:NO];
    [shadow addPath:@"/usr/libexec/swcd" restricted:NO];
    [shadow addPath:@"/usr/libexec/symptomsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/symptomsd-helper" restricted:NO];
    [shadow addPath:@"/usr/libexec/sysdiagnose_helper" restricted:NO];
    [shadow addPath:@"/usr/libexec/sysstatuscheck" restricted:NO];
    [shadow addPath:@"/usr/libexec/tailspind" restricted:NO];
    [shadow addPath:@"/usr/libexec/timed" restricted:NO];
    [shadow addPath:@"/usr/libexec/tipsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/topicsmap.db" restricted:NO];
    [shadow addPath:@"/usr/libexec/transitd" restricted:NO];
    [shadow addPath:@"/usr/libexec/trustd" restricted:NO];
    [shadow addPath:@"/usr/libexec/tursd" restricted:NO];
    [shadow addPath:@"/usr/libexec/tzd" restricted:NO];
    [shadow addPath:@"/usr/libexec/tzinit" restricted:NO];
    [shadow addPath:@"/usr/libexec/tzlinkd" restricted:NO];
    [shadow addPath:@"/usr/libexec/videosubscriptionsd" restricted:NO];
    [shadow addPath:@"/usr/libexec/wapic" restricted:NO];
    [shadow addPath:@"/usr/libexec/wcd" restricted:NO];
    [shadow addPath:@"/usr/libexec/webbookmarksd" restricted:NO];
    [shadow addPath:@"/usr/libexec/webinspectord" restricted:NO];
    [shadow addPath:@"/usr/libexec/wifiFirmwareLoader" restricted:NO];
    [shadow addPath:@"/usr/libexec/wifivelocityd" restricted:NO];
    [shadow addPath:@"/usr/libexec/xpcproxy" restricted:NO];
    [shadow addPath:@"/usr/libexec/xpcroleaccountd" restricted:NO];
    
    [shadow addPath:@"/usr/local" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/local/bin" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/local/lib" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/local/lib/liblzma.5.dylib" restricted:YES];
    [shadow addPath:@"/usr/local/lib/liblzma.dylib" restricted:YES];
    [shadow addPath:@"/usr/local/lib/pkgconfig" restricted:YES];
    [shadow addPath:@"/usr/local/standalone" restricted:NO];
    
    [shadow addPath:@"/usr/sbin" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/sbin/BTAvrcp" restricted:NO];
    [shadow addPath:@"/usr/sbin/BTLEServer" restricted:NO];
    [shadow addPath:@"/usr/sbin/BTMap" restricted:NO];
    [shadow addPath:@"/usr/sbin/BTPbap" restricted:NO];
    [shadow addPath:@"/usr/sbin/BlueTool" restricted:NO];
    [shadow addPath:@"/usr/sbin/WiFiNetworkStoreModel.momd" restricted:NO];
    [shadow addPath:@"/usr/sbin/WirelessRadioManagerd" restricted:NO];
    [shadow addPath:@"/usr/sbin/absd" restricted:NO];
    [shadow addPath:@"/usr/sbin/addNetworkInterface" restricted:NO];
    [shadow addPath:@"/usr/sbin/applecamerad" restricted:NO];
    [shadow addPath:@"/usr/sbin/aslmanager" restricted:NO];
    [shadow addPath:@"/usr/sbin/bluetoothd" restricted:NO];
    [shadow addPath:@"/usr/sbin/cfprefsd" restricted:NO];
    [shadow addPath:@"/usr/sbin/ckksctl" restricted:NO];
    [shadow addPath:@"/usr/sbin/distnoted" restricted:NO];
    [shadow addPath:@"/usr/sbin/fairplayd.H2" restricted:NO];
    [shadow addPath:@"/usr/sbin/filecoordinationd" restricted:NO];
    [shadow addPath:@"/usr/sbin/ioreg" restricted:NO];
    [shadow addPath:@"/usr/sbin/ipconfig" restricted:NO];
    [shadow addPath:@"/usr/sbin/mDNSResponder" restricted:NO];
    [shadow addPath:@"/usr/sbin/mDNSResponderHelper" restricted:NO];
    [shadow addPath:@"/usr/sbin/mediaserverd" restricted:NO];
    [shadow addPath:@"/usr/sbin/notifyd" restricted:NO];
    [shadow addPath:@"/usr/sbin/nvram" restricted:NO];
    [shadow addPath:@"/usr/sbin/pppd" restricted:NO];
    [shadow addPath:@"/usr/sbin/racoon" restricted:NO];
    [shadow addPath:@"/usr/sbin/rtadvd" restricted:NO];
    [shadow addPath:@"/usr/sbin/scutil" restricted:NO];
    [shadow addPath:@"/usr/sbin/spindump" restricted:NO];
    [shadow addPath:@"/usr/sbin/syslogd" restricted:NO];
    [shadow addPath:@"/usr/sbin/wifid" restricted:NO];
    [shadow addPath:@"/usr/sbin/wirelessproxd" restricted:NO];
    
    [shadow addPath:@"/usr/share" restricted:YES hidden:NO];
    [shadow addPath:@"/usr/share/aclocal" restricted:YES];
    [shadow addPath:@"/usr/share/bigboss" restricted:YES];
    [shadow addPath:@"/usr/share/common-lisp" restricted:YES];
    [shadow addPath:@"/usr/share/dict" restricted:YES];
    [shadow addPath:@"/usr/share/dpkg" restricted:YES];
    [shadow addPath:@"/usr/share/gnupg" restricted:YES];
    [shadow addPath:@"/usr/share/libgpg-error" restricted:YES];
    [shadow addPath:@"/usr/share/p11-kit" restricted:YES];
    [shadow addPath:@"/usr/share/polkit-1" restricted:YES];
    [shadow addPath:@"/usr/share/tabset" restricted:YES];
    [shadow addPath:@"/usr/share/terminfo" restricted:YES];

    [shadow addPath:@"/usr/share/com.apple" restricted:NO];
    [shadow addPath:@"/usr/share/CSI" restricted:NO];
    [shadow addPath:@"/usr/share/firmware" restricted:NO];
    [shadow addPath:@"/usr/share/icu" restricted:NO];
    [shadow addPath:@"/usr/share/langid" restricted:NO];
    [shadow addPath:@"/usr/share/locale" restricted:NO];
    [shadow addPath:@"/usr/share/mecabra" restricted:NO];
    [shadow addPath:@"/usr/share/misc" restricted:NO];
    [shadow addPath:@"/usr/share/progressui" restricted:NO];
    [shadow addPath:@"/usr/share/tokenizer" restricted:NO];
    [shadow addPath:@"/usr/share/zoneinfo" restricted:NO];
    [shadow addPath:@"/usr/share/zoneinfo.default" restricted:NO];
    [shadow addPath:@"/usr/standalone" restricted:NO];
    
    
    // Restrict /System
    [shadow addPath:@"/System" restricted:NO];
    [shadow addPath:@"/System/Library/PreferenceBundles/AppList.bundle" restricted:YES];
        [shadow addPath:@"/System/Library/AWD" restricted:YES];
        [shadow addPath:@"/System/Library/CardKit" restricted:YES];
        [shadow addPath:@"/System/Library/DuetActivityScheduler" restricted:YES];
        [shadow addPath:@"/System/Library/LinguisticData" restricted:YES];
        [shadow addPath:@"/System/Library/PreferencesSyncBundles" restricted:YES];
        [shadow addPath:@"/System/Library/SyncBundles" restricted:YES];
        [shadow addPath:@"/System/Library/AccessibilityBundles" restricted:YES];
        [shadow addPath:@"/System/Library/CardServices" restricted:YES];
        [shadow addPath:@"/System/Library/DuetExpertCenter" restricted:YES];
        [shadow addPath:@"/System/Library/LocationBundles" restricted:YES];
        [shadow addPath:@"/System/Library/PreinstalledAssets" restricted:YES];
        [shadow addPath:@"/System/Library/SystemConfiguration" restricted:YES];
        [shadow addPath:@"/System/Library/AccessoryUpdaterBundles" restricted:YES];
        [shadow addPath:@"/System/Library/DuetKnowledgeBase" restricted:YES];
        [shadow addPath:@"/System/Library/Lockdown" restricted:YES];
        [shadow addPath:@"/System/Library/PreinstalledAssetsV2" restricted:YES];
        [shadow addPath:@"/System/Library/TTSPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/Accounts" restricted:YES];
        [shadow addPath:@"/System/Library/ColorSync" restricted:YES];
        [shadow addPath:@"/System/Library/Extensions" restricted:YES];
        [shadow addPath:@"/System/Library/MediaCapture" restricted:YES];
        [shadow addPath:@"/System/Library/AppPlaceholders" restricted:YES];
        [shadow addPath:@"/System/Library/ControlCenter" restricted:YES];
        [shadow addPath:@"/System/Library/FDR" restricted:YES];
        [shadow addPath:@"/System/Library/MediaStreamPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/ProceduralWallpaper" restricted:YES];
        [shadow addPath:@"/System/Library/TextInput" restricted:YES];
        [shadow addPath:@"/System/Library/AppRemovalServices" restricted:YES];
        [shadow addPath:@"/System/Library/CoreAS" restricted:YES];
        [shadow addPath:@"/System/Library/FeatureFlags" restricted:YES];
        [shadow addPath:@"/System/Library/Messages" restricted:YES];
        [shadow addPath:@"/System/Library/ProductDocuments" restricted:YES];
        [shadow addPath:@"/System/Library/ThermalMonitor" restricted:YES];
        [shadow addPath:@"/System/Library/AppSignatures" restricted:YES];
        [shadow addPath:@"/System/Library/CoreAccessories" restricted:YES];
        [shadow addPath:@"/System/Library/Filesystems" restricted:YES];
        [shadow addPath:@"/System/Library/NanoLaunchDaemons" restricted:YES];
        [shadow addPath:@"/System/Library/Recents" restricted:YES];
        [shadow addPath:@"/System/Library/Trial" restricted:YES];
        [shadow addPath:@"/System/Library/CoreDuet" restricted:YES];
        [shadow addPath:@"/System/Library/NanoPreferenceBundles" restricted:YES];
        [shadow addPath:@"/System/Library/RelevanceEngine" restricted:YES];
        [shadow addPath:@"/System/Library/UsageBundles" restricted:YES];
        [shadow addPath:@"/System/Library/CoreImage" restricted:YES];
        [shadow addPath:@"/System/Library/NanoTimeKit" restricted:YES];
        [shadow addPath:@"/System/Library/RunningBoard" restricted:YES];
        [shadow addPath:@"/System/Library/UserEventPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/AssetTypeDescriptors" restricted:YES];
        [shadow addPath:@"/System/Library/HIDPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/NetworkServiceProxy" restricted:YES];
        [shadow addPath:@"/System/Library/SESStorage" restricted:YES];
        [shadow addPath:@"/System/Library/UserManagement" restricted:YES];
        [shadow addPath:@"/System/Library/Assistant" restricted:YES];
        [shadow addPath:@"/System/Library/DataClassMigrators" restricted:YES];
        [shadow addPath:@"/System/Library/Health" restricted:YES];
        [shadow addPath:@"/System/Library/Obliteration" restricted:YES];
        [shadow addPath:@"/System/Library/UserNotifications" restricted:YES];
        [shadow addPath:@"/System/Library/DefaultsConfigurations" restricted:YES];
        [shadow addPath:@"/System/Library/IdentityServices" restricted:YES];
        [shadow addPath:@"/System/Library/OnBoardingBundles" restricted:YES];
        [shadow addPath:@"/System/Library/ScreenReader" restricted:YES];
        [shadow addPath:@"/System/Library/VideoCodecs" restricted:YES];
        [shadow addPath:@"/System/Library/Backup" restricted:YES];
        [shadow addPath:@"/System/Library/DeviceOMatic" restricted:YES];
        [shadow addPath:@"/System/Library/Internet Plug-Ins" restricted:YES];
        [shadow addPath:@"/System/Library/PairedSyncServices" restricted:YES];
        [shadow addPath:@"/System/Library/Security" restricted:YES];
        [shadow addPath:@"/System/Library/VideoDecoders" restricted:YES];
        [shadow addPath:@"/System/Library/BridgeManifests" restricted:YES];
        [shadow addPath:@"/System/Library/DifferentialPrivacy" restricted:YES];
        [shadow addPath:@"/System/Library/KerberosPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/PreferenceBundles" restricted:YES];
        [shadow addPath:@"/System/Library/SetupAssistantBundles" restricted:YES];
        [shadow addPath:@"/System/Library/VideoEncoders" restricted:YES];
        [shadow addPath:@"/System/Library/BulletinDistributor" restricted:YES];
        [shadow addPath:@"/System/Library/DistributedEvaluation" restricted:YES];
        [shadow addPath:@"/System/Library/KeyboardDictionaries" restricted:YES];
        [shadow addPath:@"/System/Library/PreferenceManifests" restricted:YES];
        [shadow addPath:@"/System/Library/SoftwareUpdateCertificates" restricted:YES];
        [shadow addPath:@"/System/Library/VideoProcessors" restricted:YES];
        [shadow addPath:@"/System/Library/CacheDelete" restricted:YES];
        [shadow addPath:@"/System/Library/DoNotDisturb" restricted:YES];
        [shadow addPath:@"/System/Library/KeyboardLayouts" restricted:YES];
        [shadow addPath:@"/System/Library/PreferenceManifestsInternal" restricted:YES];
        [shadow addPath:@"/System/Library/Spotlight" restricted:YES];
        [shadow addPath:@"/System/Library/Duet" restricted:YES];
        [shadow addPath:@"/System/Library/LaunchDaemons" restricted:YES];
        [shadow addPath:@"/System/Library/Preferences" restricted:YES];
        [shadow addPath:@"/System/Library/SpringBoardPlugins" restricted:YES];
        [shadow addPath:@"/System/Library/fps" restricted:YES];
    
    
        [shadow addPath:@"/User/Library/Logs/Cydia" restricted:YES];
        [shadow addPath:@"/User/Library/Cydia" restricted:YES];
}

// Manual hooks
#include <dirent.h>

static int (*orig_open)(const char *path, int oflag, ...);
static int hook_open(const char *path, int oflag, ...) {
    int result = 0;

    if(path) {
        NSString *pathname = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

        if([_shadow isPathRestricted:pathname]) {
            errno = ((oflag & O_CREAT) == O_CREAT) ? EACCES : ENOENT;
            return -1;
        }
    }
    
    if((oflag & O_CREAT) == O_CREAT) {
        mode_t mode;
        va_list args;
        
        va_start(args, oflag);
        mode = (mode_t) va_arg(args, int);
        va_end(args);

        result = orig_open(path, oflag, mode);
    } else {
        result = orig_open(path, oflag);
    }

    return result;
}

static int (*orig_openat)(int fd, const char *path, int oflag, ...);
static int hook_openat(int fd, const char *path, int oflag, ...) {
    int result = 0;

    if(path) {
        NSString *nspath = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

        if(![nspath isAbsolutePath]) {
            // Get path of dirfd.
            char dirfdpath[PATH_MAX];
        
            if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
                NSString *dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
                nspath = [dirfd_path stringByAppendingPathComponent:nspath];
            }
        }
        
        if([_shadow isPathRestricted:nspath]) {
            errno = ((oflag & O_CREAT) == O_CREAT) ? EACCES : ENOENT;
            return -1;
        }
    }
    
    if((oflag & O_CREAT) == O_CREAT) {
        mode_t mode;
        va_list args;
        
        va_start(args, oflag);
        mode = (mode_t) va_arg(args, int);
        va_end(args);

        result = orig_openat(fd, path, oflag, mode);
    } else {
        result = orig_openat(fd, path, oflag);
    }

    return result;
}

static DIR *(*orig_opendir)(const char *filename);
static DIR *hook_opendir(const char *filename) {
    if(filename) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:filename length:strlen(filename)];

        if([_shadow isPathRestricted:path]) {
            errno = ENOENT;
            return NULL;
        }
    }

    return orig_opendir(filename);
}

static struct dirent *(*orig_readdir)(DIR *dirp);
static struct dirent *hook_readdir(DIR *dirp) {
    struct dirent *ret = NULL;
    NSString *path = nil;

    // Get path of dirfd.
    NSString *dirfd_path = nil;
    int fd = dirfd(dirp);
    char dirfdpath[PATH_MAX];

    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
        dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
    } else {
        return orig_readdir(dirp);
    }

    // Filter returned results, skipping over restricted paths.
    do {
        ret = orig_readdir(dirp);

        if(ret) {
            path = [dirfd_path stringByAppendingPathComponent:[NSString stringWithUTF8String:ret->d_name]];
        } else {
            break;
        }
    } while([_shadow isPathRestricted:path]);

    return ret;
}

static int (*orig_dladdr)(const void *addr, Dl_info *info);
static int hook_dladdr(const void *addr, Dl_info *info) {
    int ret = orig_dladdr(addr, info);

    if(!passthrough && ret) {
        NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:info->dli_fname length:strlen(info->dli_fname)];

        if([_shadow isImageRestricted:path]) {
            return 0;
        }
    }

    return ret;
}

static ssize_t (*orig_readlink)(const char *path, char *buf, size_t bufsiz);
static ssize_t hook_readlink(const char *path, char *buf, size_t bufsiz) {
    if(!path || !buf) {
        return orig_readlink(path, buf, bufsiz);
    }

    NSString *nspath = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

    if([_shadow isPathRestricted:nspath]) {
        errno = ENOENT;
        return -1;
    }

    ssize_t ret = orig_readlink(path, buf, bufsiz);

    if(ret != -1) {
        buf[ret] = '\0';

        // Track this symlink in Shadow
        [_shadow addLinkFromPath:nspath toPath:[[NSFileManager defaultManager] stringWithFileSystemRepresentation:buf length:strlen(buf)]];
    }

    return ret;
}

static ssize_t (*orig_readlinkat)(int fd, const char *path, char *buf, size_t bufsiz);
static ssize_t hook_readlinkat(int fd, const char *path, char *buf, size_t bufsiz) {
    if(!path || !buf) {
        return orig_readlinkat(fd, path, buf, bufsiz);
    }

    NSString *nspath = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

    if(![nspath isAbsolutePath]) {
        // Get path of dirfd.
        char dirfdpath[PATH_MAX];
    
        if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
            NSString *dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
            nspath = [dirfd_path stringByAppendingPathComponent:nspath];
        }
    }

    if([_shadow isPathRestricted:nspath]) {
        errno = ENOENT;
        return -1;
    }

    ssize_t ret = orig_readlinkat(fd, path, buf, bufsiz);

    if(ret != -1) {
        buf[ret] = '\0';

        // Track this symlink in Shadow
        [_shadow addLinkFromPath:nspath toPath:[[NSFileManager defaultManager] stringWithFileSystemRepresentation:buf length:strlen(buf)]];
    }

    return ret;
}

%group hook_springboard
%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;

    HBPreferences *prefs = [HBPreferences preferencesForIdentifier:BLACKLIST_PATH];

    NSArray *file_map = [Shadow generateFileMap];
    NSArray *url_set = [Shadow generateSchemeArray];

    [prefs setObject:file_map forKey:@"files"];
    [prefs setObject:url_set forKey:@"schemes"];
}
%end
%end

%group hook_jailbroken
%hook BDADeviceHelper
+(bool)isJailBroken {
	return NO;
}
%end

%hook TTInstallUtil
+(bool)isJailBroken {
	return NO;
}
%end

%hook AppsFlyerUtils
+(bool)isJailbrokenWithSkipAdvancedJailbreakValidation:(bool)arg2 {
	return NO;
}
%end

%hook PIPOIAPStoreManager
-(bool)_pipo_isJailBrokenDeviceWithProductID:(id)arg2 orderID:(id)arg3 {
	return NO;
}
%end

%hook IESLiveDeviceInfo
+(bool)isJailBroken {
	return NO;
}
%end

%hook PIPOStoreKitHelper
-(bool)isJailBroken {
	return NO;
}
%end

%hook BDInstallNetworkUtility
+(bool)isJailBroken {
	return NO;
}
%end

%hook TTAdSplashDeviceHelper
+(bool)isJailBroken {
	return NO;
}
%end

%hook ASSStaticInfoCollector
+(bool)checkJB {
	return NO;
}
%end

%hook AWECloudJailBreakUtility
+(bool)jailbroken {
	return NO;
}
%end

%hook AWEYAMInfoHelper
+(bool)isJailBroken {
	return NO;
}
%end

%hook BDLogDeviceHelper
+(bool)isJailBroken {
	return NO;
}
%end

%hook HMDCrashBinaryImage
+(bool)isJailBroken {
	return NO;
}
%end

%hook HMDInfo
+(bool)isJailBroken {
	return NO;
}
%end

%hook MobClick
+(bool)isJailbroken {
	return NO;
}
%end

%hook TTInstallDeviceHelper
+(bool)isJailBroken {
	return NO;
}
%end

%hook UAConveniece
+(bool)deviceWasJailed {
	return NO;
}
%end

%hook UMANProtocolData
+(bool)isDeviceJailBreak {
	return NO;
}
%end

%hook WXOMTAHelper
+(bool)isJB {
	return NO;
}
%end
%end


%ctor {
    NSString *processName = [[NSProcessInfo processInfo] processName];

    if([processName isEqualToString:@"SpringBoard"]) {
        HBPreferences *prefs = [HBPreferences preferencesForIdentifier:PREFS_TWEAK_ID];

        if(prefs && [prefs boolForKey:@"auto_file_map_generation_enabled"]) {
            %init(hook_springboard);
        }

        return;
    }

    NSBundle *bundle = [NSBundle mainBundle];

    if(bundle != nil) {
        NSString *executablePath = [bundle executablePath];
        NSString *bundleIdentifier = [bundle bundleIdentifier];

        // User (Sandboxed) Applications
        if([executablePath hasPrefix:@"/var/containers/Bundle/Application"]
        || [executablePath hasPrefix:@"/private/var/containers/Bundle/Application"]
        || [executablePath hasPrefix:@"/var/mobile/Containers/Bundle/Application"]
        || [executablePath hasPrefix:@"/private/var/mobile/Containers/Bundle/Application"]) {

            HBPreferences *prefs = [HBPreferences preferencesForIdentifier:PREFS_TWEAK_ID];

            [prefs registerDefaults:@{
                @"enabled" : @YES,
                @"mode" : @"whitelist",
                @"bypass_checks" : @YES,
                @"exclude_system_apps" : @YES,
                @"dyld_hooks_enabled" : @YES,
                @"extra_compat_enabled" : @YES
            }];

            extra_compat = [prefs boolForKey:@"extra_compat_enabled"];
            
            // Check if Shadow is enabled
            if(![prefs boolForKey:@"enabled"]) {
                // Shadow disabled in preferences
                return;
            }

            // Check if safe bundleIdentifier
            if([prefs boolForKey:@"exclude_system_apps"]) {
                // Disable Shadow for Apple and jailbreak apps
                NSArray *excluded_bundleids = @[
                    @"com.apple", // Apple apps
                    @"is.workflow.my.app", // Shortcuts
                    @"science.xnu.undecimus", // unc0ver
                    @"com.electrateam.chimera", // Chimera
                    @"org.coolstar.electra" // Electra
                ];

                for(NSString *bundle_id in excluded_bundleids) {
                    if([bundleIdentifier hasPrefix:bundle_id]) {
                        return;
                    }
                }
            }

            HBPreferences *prefs_apps = [HBPreferences preferencesForIdentifier:APPS_PATH];

            // Check if excluded bundleIdentifier
            NSString *mode = [prefs objectForKey:@"mode"];

            if([mode isEqualToString:@"whitelist"]) {
                // Whitelist - disable Shadow if not enabled for this bundleIdentifier
                if(![prefs_apps boolForKey:bundleIdentifier]) {
                    return;
                }
            } else {
                // Blacklist - disable Shadow if enabled for this bundleIdentifier
                if([prefs_apps boolForKey:bundleIdentifier]) {
                    return;
                }
            }

            HBPreferences *prefs_blacklist = [HBPreferences preferencesForIdentifier:BLACKLIST_PATH];
            HBPreferences *prefs_tweakcompat = [HBPreferences preferencesForIdentifier:TWEAKCOMPAT_PATH];
            HBPreferences *prefs_lockdown = [HBPreferences preferencesForIdentifier:LOCKDOWN_PATH];
            HBPreferences *prefs_dlfcn = [HBPreferences preferencesForIdentifier:DLFCN_PATH];

            // Initialize Shadow
            _shadow = [Shadow new];

            if(!_shadow) {
                return;
            }

            // Compatibility mode
            [_shadow setUseTweakCompatibilityMode:[prefs_tweakcompat boolForKey:bundleIdentifier] ? NO : YES];

            // Disable inject compatibility if we are using Substitute.
            NSFileManager *fm = [NSFileManager defaultManager];
            BOOL isSubstitute = ([fm fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"] && ![fm fileExistsAtPath:@"/usr/lib/substrate"]);

            if(isSubstitute) {
                [_shadow setUseInjectCompatibilityMode:NO];
            } else {
                [_shadow setUseInjectCompatibilityMode:YES];
            }

            // Lockdown mode
            if([prefs_lockdown boolForKey:bundleIdentifier]) {
                %init(hook_libc_inject);
                %init(hook_dlopen_inject);

                MSHookFunction((void *) open, (void *) hook_open, (void **) &orig_open);
                MSHookFunction((void *) openat, (void *) hook_openat, (void **) &orig_openat);

                [_shadow setUseInjectCompatibilityMode:NO];
                [_shadow setUseTweakCompatibilityMode:NO];

                _dyld_register_func_for_add_image(dyld_image_added);

                if([prefs boolForKey:@"experimental_enabled"]) {
                    %init(hook_experimental);
                }

                if([prefs boolForKey:@"standardize_paths"]) {
                    [_shadow setUsePathStandardization:YES];
                }

            }

            if([_shadow useInjectCompatibilityMode]) {
                NSLog(@"using injection compatibility mode");
            } else {
                // Substitute doesn't like hooking opendir :(
                if(!isSubstitute) {
                    MSHookFunction((void *) opendir, (void *) hook_opendir, (void **) &orig_opendir);
                }

                MSHookFunction((void *) readdir, (void *) hook_readdir, (void **) &orig_readdir);
            }

            // Initialize restricted path map
            init_path_map(_shadow);
            init_DIY_dylib(JBFile_DYLIB);

            // Initialize file map
            NSArray *file_map = [prefs_blacklist objectForKey:@"files"];
            NSArray *url_set = [prefs_blacklist objectForKey:@"schemes"];

            if(file_map) {
                [_shadow addPathsFromFileMap:file_map];
            }

            if(url_set) {
                [_shadow addSchemesFromURLSet:url_set];
            }

            // Initialize stable hooks
            %init(hook_private);
            %init(hook_NSFileManager);
            %init(hook_NSFileWrapper);
            %init(hook_NSFileVersion);
            %init(hook_libc);
            %init(hook_debugging);
            %init(hook_NSFileHandle);
            %init(hook_NSURL);
            %init(hook_UIApplication);
            %init(hook_NSBundle);
            %init(hook_NSUtilities);
            %init(hook_NSEnumerator);
            %init(hook_jailbroken);
            
            MSHookFunction((void *) readlink, (void *) hook_readlink, (void **) &orig_readlink);
            MSHookFunction((void *) readlinkat, (void *) hook_readlinkat, (void **) &orig_readlinkat);

            // Initialize other hooks
            if([prefs boolForKey:@"bypass_checks"]) {
                %init(hook_libraries);
            }

            if([prefs boolForKey:@"dyld_hooks_enabled"]) {
                %init(hook_dyld_image);
                MSHookFunction((void *) dladdr, (void *) hook_dladdr, (void **) &orig_dladdr);
            }

            if([prefs boolForKey:@"sandbox_hooks_enabled"]) {
                %init(hook_sandbox);
            }

            // Generate filtered dyld array
            if([prefs boolForKey:@"dyld_filter_enabled"]) {
                updateDyldArray();

                %init(hook_runtime);
            }

            if([prefs_dlfcn boolForKey:bundleIdentifier]) {
                %init(hook_dyld_dlsym);
            }
            
            _error_file_not_found = [Shadow generateFileNotFoundError];
            enum_path = [NSMutableDictionary new];
        }
    }
}
