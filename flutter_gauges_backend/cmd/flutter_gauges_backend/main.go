package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"time"
)

func main() {

	var socketPath = "/Users/cory.redmond/Library/Containers/red.cory.flutterGauges/Data/tmp/flutter_gauges_backend.sock"

	// Remove the socket if it already exists
	if _, err := os.Stat(socketPath); err == nil {
		os.Remove(socketPath)
	}

	listener, err := net.Listen("unix", socketPath)
	if err != nil {
		panic(err)
	}
	defer listener.Close()

	fmt.Println("Listening on Unix domain socket...")

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("Error accepting connection:", err)
			continue
		}

		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()
	enc := json.NewEncoder(conn)

	for {
		for i := 0; i < 100; i = i + 5 {
			err := enc.Encode(map[string]interface{}{
				"afrValue":       MapIntToFloat(i, 7, 21),
				"afrTarget":      MapIntToFloat(i, 14, 15),
				"intakePressure": MapIntToFloat(i, -15, 10),
				"knocked":        false,
				"twoStep":        true,
			})
			if err != nil {
				return
			}
			time.Sleep(time.Millisecond * 100)
		}
		for i := 99; i > 0; i = i - 15 {
			err := enc.Encode(map[string]interface{}{
				"afrValue":       MapIntToFloat(i, 7, 21),
				"afrTarget":      MapIntToFloat(i, 14, 15),
				"intakePressure": MapIntToFloat(i, -15, 10),
				"knocked":        i%4 == 0,
				"twoStep":        false,
			})
			if err != nil {
				return
			}
			time.Sleep(time.Millisecond * 100)
		}
	}
}

func MapIntToFloat(input int, min, max float64) float64 {
	if input < 0 || input > 99 {
		panic("Input must be in the range 0 to 99")
	}
	return min + ((float64(input) / 99.0) * (max - min))
}
