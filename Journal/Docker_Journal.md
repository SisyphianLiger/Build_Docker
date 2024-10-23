# Articles I am reading about Docker
https://medium.com/@kuninoto/how-does-docker-really-work-under-the-hood-a-dive-into-dockers-internals-2fef63f7c9bb
https://www.infoq.com/articles/build-a-container-golang/

# What is Docker
## Don't you mean what is a Container?
The three properties of Containers
1. Namespaces:  provide the isolation needed to run multiple containers on one maching while giving each it's own
                environment.
    - PID:  gives a process and its children their own view of a subset of the processes in the system. A mapping 
            table.
    - MNT:  Mount Namespace gives the process contained within their own mount table, can mound and unmount dir 
            without affecting other namespaces
    - NET:  Network gives process that use their own network stack
    - UTS:  gives processes their own view of the system's hostname and domain name
    - IPC:  isolates various inter-process communication
    - USER: Most powerful in terms of Sec. Maps uids a process sees to a fifferent set of uids on the host

2. CGroups: a collect set of process or task ids together and apply limits to them. cgroups enforce resource sharing

3. Layered Filesystems: How we can efficiently move whole machine images around. Optimise the call to create copy of 
                        the root filesystem for each container.

## Building The Container
I have added three functions `parent()`, `child()`, and `must()`.

### Description of Parent()
Let's start by unpacking what `parent()` does.
```Go

func parent() {
        cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
        cmd.Stdin = os.Stdin
        cmd.Stdout = os.Stdout
        cmd.Stderr = os.Stderr

        if err := cmd.Run(); err != nil {
                fmt.Println("ERROR", err)
        }
        os.Exit(1)
}

```

If ran, we runt the command `"/proc/self/exe"` which is a special file containing in-memory image of the current 
executable. So we will "re-run" ourselves but passing child as the first argument.


### Description of child()
```Go
func child() {
        cmd := exec.Command(os.Args[2], os.Args[3:]...)
        cmd.Stdin = os.Stdin
        cmd.Stdout = os.Stdout
        cmd.Stderr = os.Stderr

        if err := cmd.Run(); err != nil {
                fmt.Println("ERROR", err)
        }
        os.Exit(1)
}
```

Child is then a child of the process been made, meaning it is a program that a user has requested to run.


### Description of must()
```Go

func must(err error) {
	if err != nil {
		panic(err)
	}
}
```
For now, must is just a helper function that will allow us to abstract errors from our code


