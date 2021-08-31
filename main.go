package main

import (
	"fmt"
	"time"

	uuid "github.com/satori/go.uuid"
)

func main() {
	for {
		fmt.Print(uuid.NewV4().String() + "\n")
		time.Sleep(time.Second * 5)
	}
}
