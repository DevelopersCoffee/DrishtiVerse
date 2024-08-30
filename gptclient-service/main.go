package main

import (
	"log"
	"net/http"
)

func main() {
	log.Println("GPTClient Service running on port 8081")
	http.ListenAndServe(":8081", nil)
}
