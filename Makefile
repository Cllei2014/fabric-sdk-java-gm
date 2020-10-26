DOCKER_NS ?= hyperledger
SDKINTEGRATION = src/test/fixture/sdkintegration

IMAGES = peer orderer ca tools

%: export IMAGE_PEER=$(DOCKER_NS)/fabric-peer-gm:latest
%: export IMAGE_ORDERER=$(DOCKER_NS)/fabric-orderer-gm:latest
%: export IMAGE_CA=$(DOCKER_NS)/fabric-ca-gm:latest
%: export IMAGE_TOOLS=$(DOCKER_NS)/fabric-tools-gm:latest

image-%:
	@docker inspect --type=image $$IMAGE_$(shell echo $* | tr a-z A-Z ) > /dev/null 2>&1  \
		|| docker pull $$IMAGE_$(shell echo $* | tr a-z A-Z ) \
		&& echo "$* image exsist."

package:
	mvn package -DskipITs -DskipTests

unit-test:
	mvn clean test -DskipTests=false -Dmaven.test.failure.ignore=false

int-test:
	mvn clean integration-test -DskipITs=false -Dmaven.test.failure.ignore=false

# call fabric to restart/down
fabric-%: $(patsubst %, image-%, $(IMAGES))
	echo $$IMAGE_PEER
	cd $(SDKINTEGRATION) && ./fabric.sh $*
