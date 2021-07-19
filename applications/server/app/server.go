package main

import (
	"encoding/base64"
	"encoding/json"
	"flag"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	authHeader = "Authorization"

	portEnv  = "ITEMA_SERVER_PORT"
)

var R *rand.Rand

type response struct {
	Data  string `json:"data,omitempty"`
	Error string `json:"error,omitempty"`
}

func main() {

	p := flag.Int("p", 8080, "Server Port")
	flag.Parse()

	// Read ENV
	pn, err := strconv.Atoi(os.Getenv(portEnv))
	if err != nil && pn != 0 {
		*p = pn
	}

	// Init rand
	R = rand.New(rand.NewSource(time.Now().UnixNano()))

	// Run server
	http.HandleFunc("/resource", Resource)
	log.Println("Server started - Port: " + strconv.Itoa(*p))
	http.ListenAndServe(":"+strconv.Itoa(*p), nil)
}

func Resource(w http.ResponseWriter, r *http.Request) {
	log.Println("Resource called")

	// Random fail
	if R.Intn(100) < 30 {
		log.Println("Random failure")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(response{Error: "Random failure"})
		return
	}
	if r.Header[authHeader] != nil {
		hd := strings.Split(r.Header[authHeader][0], " ")
		if len(hd) != 2 {
			log.Println("Wrong header: ", hd, " size: ", strconv.Itoa(len(hd)))
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(response{Error: "Header length unexpected"})
			return
		}
		// Token
		token := hd[1]
		log.Println("Token:", token)
		if err := decodeToken(token); err != nil {
			log.Println("Token decode error:", err)
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(response{Error: "Token decode error"})
		}
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(response{Data: "Token: " + token})
		return
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response{Data: "OK"})
	return
}

func decodeToken(t string) error {
	tp := strings.Split(t, ".")
	for i, d := range tp {
		if i == 2 {
			return nil
		}
		data, err := base64.RawURLEncoding.DecodeString(d)
		if err != nil {
			return err
		}
		log.Println("Token Part " + strconv.Itoa(i+1) + ": " + string(data))
	}
	return nil
}
