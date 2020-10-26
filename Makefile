SDKINTEGRATION = src/test/fixture/sdkintegration

package:
	mvn package -DskipITs -DskipTests

unit-test:
	mvn clean test -DskipTests=false -Dmaven.test.failure.ignore=false

int-test:
	mvn clean integration-test -DskipITs=false -Dmaven.test.failure.ignore=false

# call fabric to restart/down
fabric-%:
	cd $(SDKINTEGRATION) && ./fabric.sh $*
