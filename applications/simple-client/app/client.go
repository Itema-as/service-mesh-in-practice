package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

const (
	endpoint    = "/resource"
	defaultIP   = "127.0.0.1"
	defaultPort = 8080

	authHeader = "Authorization"

	hostEnv  = "ITEMA_CLIENT_ADDRESS"
	portEnv  = "ITEMA_CLIENT_PORT"
	tokenEnv = "ITEMA_TOKEN"
)

var Token string

type response struct {
	Data  string `json:"data,omitempty"`
	Error string `json:"error,omitempty"`
}

func main() {
	// Init rand generator
	rand.Seed(time.Now().UnixNano())

	nt := flag.Int("n", 1, "Number of threads")
	ip := flag.String("i", defaultIP, "IP Address")
	po := flag.Int("p", defaultPort, "Port")

	flag.Parse()

	// Read ENV
	ho := os.Getenv(hostEnv)
	if ho != "" {
		*ip = ho
	}
	pn, err := strconv.Atoi(os.Getenv(portEnv))
	if err != nil && pn != 0 {
		*po = pn
	}
	Token = os.Getenv(tokenEnv)

	addr := "http://" + *ip + ":" + strconv.Itoa(*po) + endpoint
	fmt.Println("Address: " + addr)
	i := 0
	for i < *nt {
		go loopReuest(addr, i)
		i++
	}

	blockUntilClose()
}

func loopReuest(addr string, i int) {
	for {
		if err := makeGetRequest(addr); err != nil {
			log.Println(err)
		}
		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	}
}

func makeGetRequest(addr string) error {
	client := &http.Client{}
	req, err := http.NewRequest("GET", addr, nil)
	if err != nil {
		return err
	}

	if Token != "" {
		req.Header.Set(authHeader, "Bearer "+Token)
	}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	r := response{}
	err = json.Unmarshal(body, &r)
	if err != nil {
		log.Println(err)
		return nil
	}

	log.Println(r)
	return nil
}

func blockUntilClose() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	<-c
	fmt.Println("\r- Ctrl+C pressed in Terminal")
	os.Exit(0)
}
