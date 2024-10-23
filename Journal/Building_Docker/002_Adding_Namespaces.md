# Namespaces
Adding the second property of a container to our program, namespaces, we can 
add the `SysProcAttr` struct to add a UTS, PID, and NS namespace.

Thus we updated `parent()` to include these attributes
```Go

func child() {
	cmd := exec.Command(os.Args[2], os.Args[3:]...)
        // New Code Here
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Cloneflags: syscall.CLONE_NEWUTS | syscall.CLONE_NEWPID | syscall.CLONE_NEWNS}

	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		fmt.Println("ERROR", err)
	}
	os.Exit(1)
}
```
