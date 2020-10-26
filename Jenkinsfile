void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/tw-bc-group/fabric-sdk-java-gm"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

pipeline {
    agent any

    stages {
        stage('Unit Tests') {
            steps {
                setBuildStatus("Build Started", "PENDING");

                sh '''
                make fabric-restart &
                sleep 5
                make unit-test
                kill %1
                '''
            }

            post {
                always {
                    sh 'make fabric-down'
                }
            }
        }

        stage('Int Tests') {
            steps {
                sh '''
                make fabric-restart &
                sleep 5
                make int-test
                kill %1
                '''
            }

            post {
                always {
                    sh 'make fabric-down'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'make package'
            }

            post {
                success {
                    archiveArtifacts 'target/*.jar'
                }
            }
        }
    }

    post {
        success {
            setBuildStatus("Build succeeded", "SUCCESS");
        }
        unsuccessful {
            setBuildStatus("Build failed", "FAILURE");
        }
    }
}

