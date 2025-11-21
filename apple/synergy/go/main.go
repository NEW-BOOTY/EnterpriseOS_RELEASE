package main

import "fmt"
import "github.com/securecodewarrior/sarif"

func main() {
    report := sarif.Report{Version: "2.1.0", Runs: []sarif.Run{{Tool: sarif.Tool{Driver: sarif.Driver{Name: "synergy"}}}}}
    fmt.Println("SARIF generated")
}
