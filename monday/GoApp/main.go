package main

import (
	"github.com/gin-gonic/gin"
	"log"
)

func main()  {
	log.Printf("Hello World!")
	srv := gin.Default()

	srv.GET("/health", func(context *gin.Context) {
		context.JSON(200, gin.H{
			"status": "Ok",
		})
	})

	err := srv.Run()

	if err != nil {
		log.Fatal(err)
	}
}