package main

import (
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"log"
	"math/rand"
	"time"
)

var (
	counter = promauto.NewCounter(prometheus.CounterOpts{
		Name: "mondays_app_http_health_counter",
		Help: "Counter for counting amount of requests to health endpoint",
	})

	histogram = promauto.NewHistogram(prometheus.HistogramOpts{
		Name: "mondays_app_http_sample_histogram",
		Help: "Sample histogram for Mondays project",
	})
)

func main()  {
	log.Printf("Hello World!")
	srv := gin.Default()

	srv.GET("/health", func(context *gin.Context) {
		log.Println("new health request")
		counter.Inc()
		context.JSON(200, gin.H{
			"status": "Ok",
		})
	})

	srv.GET("/metrics", prometheusHandler())

	err := srv.Run()

	go func() {
		for {
			rand.Seed(time.Now().UnixNano())
			histogram.Observe(float64(rand.Intn(100-0+1) + 0))
			time.Sleep(1 * time.Second)
		}
	}()

	if err != nil {
		log.Fatal(err)
	}
}

func prometheusHandler() gin.HandlerFunc {
	h := promhttp.Handler()

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}