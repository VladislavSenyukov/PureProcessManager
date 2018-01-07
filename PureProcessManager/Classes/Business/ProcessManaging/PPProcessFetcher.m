//
//  PPProcessFetcher.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessFetcher.h"
#include <sys/sysctl.h>
#import <libproc.h>
#include <pwd.h>

typedef struct kinfo_proc kinfo_proc;
static int GetBSDProcessList(kinfo_proc **procList, size_t *procCount);

@implementation PPProcessFetcher

+ (NSArray<PPProcessInfo *> *)fetchAllSystemProcesses {
    kinfo_proc *processList = NULL;
    size_t processCount = 0;
    GetBSDProcessList(&processList, &processCount);
    NSMutableArray *allProcessesInfo = @[].mutableCopy;
    for (int i = 0; i < processCount; i++) {
        kinfo_proc *process = &processList[i];
        PPProcessInfo *processInfo = [PPProcessInfo new];
        int processID = process->kp_proc.p_pid;
        processInfo.processID = processID;
        // At first a process name is being evaluated by its path. This approach is used because a BSD info structure has only 17 chars to write a process name to, and it often gets truncated
        int maxProcPathLength = 500; // this path length seems to be enough to store a process name at the end
        char *bufferProcPath = calloc(maxProcPathLength, sizeof(char*));
        proc_pidpath(processID, bufferProcPath, maxProcPathLength * sizeof(char*));
        if (strlen(bufferProcPath)) {
            NSString *processPath = [NSString stringWithUTF8String:bufferProcPath];
            processInfo.processName = processPath.lastPathComponent;
        } else {
            // If the process path can't be evaluated, then BSD process info is used
            processInfo.processName = [NSString stringWithUTF8String:process->kp_proc.p_comm];
        }
        free(bufferProcPath);
        struct passwd *owner = getpwuid(process->kp_eproc.e_ucred.cr_uid);
        processInfo.ownerName = [NSString stringWithUTF8String:owner->pw_name];
        [allProcessesInfo addObject:processInfo];
    }
    free(processList);
    return [NSArray arrayWithArray:allProcessesInfo];
}

@end

/**
 * This function has been copied from the Apple developer documentation open source
 * https://developer.apple.com/legacy/library/qa/qa2001/qa1123.html
 */
static int GetBSDProcessList(kinfo_proc **procList, size_t *procCount)
// Returns a list of all BSD processes on the system.  This routine
// allocates the list and puts it in *procList and a count of the
// number of entries in *procCount.  You are responsible for freeing
// this list (use "free" from System framework).
// On success, the function returns 0.
// On error, the function returns a BSD errno value.
{
    int                 err;
    kinfo_proc *        result;
    bool                done;
    static const int    name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
    // Declaring name as const requires us to cast it when passing it to
    // sysctl because the prototype doesn't include the const modifier.
    size_t              length;
    
    assert( procList != NULL);
    assert(*procList == NULL);
    assert(procCount != NULL);
    
    *procCount = 0;
    
    // We start by calling sysctl with result == NULL and length == 0.
    // That will succeed, and set length to the appropriate length.
    // We then allocate a buffer of that size and call sysctl again
    // with that buffer.  If that succeeds, we're done.  If that fails
    // with ENOMEM, we have to throw away our buffer and loop.  Note
    // that the loop causes use to call sysctl with NULL again; this
    // is necessary because the ENOMEM failure case sets length to
    // the amount of data returned, not the amount of data that
    // could have been returned.
    
    result = NULL;
    done = false;
    do {
        assert(result == NULL);
        
        // Call sysctl with a NULL buffer.
        
        length = 0;
        err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1,
                     NULL, &length,
                     NULL, 0);
        if (err == -1) {
            err = errno;
        }
        
        // Allocate an appropriately sized buffer based on the results
        // from the previous call.
        
        if (err == 0) {
            result = malloc(length);
            if (result == NULL) {
                err = ENOMEM;
            }
        }
        
        // Call sysctl again with the new buffer.  If we get an ENOMEM
        // error, toss away our buffer and start again.
        
        if (err == 0) {
            err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1,
                         result, &length,
                         NULL, 0);
            if (err == -1) {
                err = errno;
            }
            if (err == 0) {
                done = true;
            } else if (err == ENOMEM) {
                assert(result != NULL);
                free(result);
                result = NULL;
                err = 0;
            }
        }
    } while (err == 0 && ! done);
    
    // Clean up and establish post conditions.
    
    if (err != 0 && result != NULL) {
        free(result);
        result = NULL;
    }
    *procList = result;
    if (err == 0) {
        *procCount = length / sizeof(kinfo_proc);
    }
    
    assert( (err == 0) == (*procList != NULL) );
    
    return err;
}
