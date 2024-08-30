package main

import (
	"log"
	"net/http"
)

func main() {
	log.Println("quiz Service running on port 8083")
	http.ListenAndServe(":8083", nil)
}
