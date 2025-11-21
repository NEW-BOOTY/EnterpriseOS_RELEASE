deps: ; mvn dependency:resolve; cd go && go mod tidy
build: ; mvn package; cd go && go build -o ../../pkg/synergy
test: ; mvn test; cd go && go test
package: ; cp go/synergy ../../pkg/
