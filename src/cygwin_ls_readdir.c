///usr/bin/gcc -shared "$0" "$@" -lntdll; exit
// Written by Bill Zissimopoulos, 2015-2017.

#include <dirent.h>
#include <io.h>
#include <sys/cygwin.h>
#include <wchar.h>
#include <winternl.h>

#if 0
#include <stdio.h>
#define TRACE(...) fprintf(stderr, __VA_ARGS__)
#else
#define TRACE(...) ((void)0)
#endif

static struct dirent *(*real_readdir)(DIR *dirp);

struct dirent *readdir(DIR *dirp)
{
    NTSTATUS NTAPI NtQueryAttributesFile(
        POBJECT_ATTRIBUTES ObjectAttributes,
        PFILE_BASIC_INFORMATION FileInformation);
    HANDLE h;
    struct dirent *dirent;
    WCHAR name[NAME_MAX + 1];
    UNICODE_STRING uname;
    OBJECT_ATTRIBUTES obja;
    FILE_BASIC_INFORMATION info;
    NTSTATUS status;

    h = (HANDLE)_get_osfhandle(dirfd(dirp));
    if ((HANDLE)-1 == h)
        return real_readdir(dirp);

    while (0 != (dirent = real_readdir(dirp)))
    {
        if ('.' == dirent->d_name[0] && ('\0' == dirent->d_name[1] ||
            ('.' == dirent->d_name[1] && '\0' == dirent->d_name[2])))
            break;

        if (0 != cygwin_conv_path(CCP_POSIX_TO_WIN_W | CCP_RELATIVE, dirent->d_name, name, sizeof name))
            break;

        uname.Length = uname.MaximumLength = wcslen(name) * sizeof(WCHAR);
        uname.Buffer = name;

        InitializeObjectAttributes(&obja, &uname, 0, h, 0);
        status = NtQueryAttributesFile(&obja, &info);
        TRACE("%s: NtQueryAttributesFile(\"%ls\")=%lx\n", __func__, uname.Buffer, status);
        if (!NT_SUCCESS(status) || 0 == (info.FileAttributes & FILE_ATTRIBUTE_HIDDEN))
            break;
    }

    TRACE("%s: name=\"%s\"\n", __func__, 0 != dirent ? dirent->d_name : (char *)0);

    return dirent;
}
static __attribute__((constructor)) void init(void)
{
    real_readdir = (void *)cygwin_internal(CW_HOOK, "readdir", readdir);
}