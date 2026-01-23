all: clean goapplicationframework

goapplicationframework:
	CGO_ENABLED=0 go build -o $@ -ldflags "-X github.com/robstradling/goapplicationframework/config.BuildTimestamp=`date --utc +%Y-%m-%dT%H:%M:%SZ`"

clean:
	rm -f goapplicationframework
