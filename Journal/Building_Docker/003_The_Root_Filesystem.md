# Root Filesystem

Initial mounts are inherited from the creating namespace. We can change that
by swapping into a root filesystem.

```Go
// func starts...
	must(syscall.Mount("rootfs", "rootfs", "", syscall.MS_BIND, ""))
	must(os.MkdirAll("rootfs/oldrootfs", 0700))
	must(syscall.PivotRoot("rootfs", "rootfs/oldrootfs"))
	must(os.Chdir("/"))
//...block contiues
```

What is this doing?

First we make a syscall to mount rootfs and make the directory rootfs/oldrootfs.
The first calls make sure that the swap of two filesystems are not a part of the
same tree. 

The last two steps are important, they tell the OS to move the current dir to 
/. After pivotroot is complete the / directory container will refer to the roots.

