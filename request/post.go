package request

import (
	"context"
	"time"

	"github.com/robstradling/goapplicationframework/config"
	"github.com/robstradling/goapplicationframework/health"

	"github.com/valyala/fasthttp"
)

func POST(fhctx *fasthttp.RequestCtx, path string) int {
	status := fasthttp.StatusBadRequest

	ctxWithDeadline, cancel := context.WithDeadline(context.Background(), fhctx.Time().Add(time.Duration(config.Config.Server.RequestTimeout)))
	defer cancel()

	doneChan := make(chan int, 1)
	go func() {
		// TODO: Do some work.

		fhctx.SetStatusCode(status)
		doneChan <- 0
	}()

	return health.CompleteRequest(ctxWithDeadline, doneChan)
}
