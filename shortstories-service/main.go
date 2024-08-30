package main

import (
	"log"
	"net/http"
)

func main() {
	log.Println("Shortstories Service running on port 8082")
	http.ListenAndServe(":8082", nil)
}
