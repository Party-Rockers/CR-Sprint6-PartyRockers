pipeline {
    agent {
        docker {
            image 'maven:3.8.4-eclipse-temurin-11'
            args '-v /root/.m2:/root/.m2'
        }
    }

    stages {
        stage('Build') {

            steps {
               echo 'This is the build stage.'
               awsCodeBuild projectName: "${CODEBUILD_NAME}", credentialsType: 'keys', region: "${AWS_REGION}", sourceControlType: 'project', sourceVersion: "${BRANCH_NAME}"
            }

        }

        // stage('Testing') {
        //     steps {

        //        echo 'This is the test stage.'
        //     }
        // }

        // stage('E2E Testing') {
        //     steps {

        //        echo 'This is the E2E Testing stage.'
        //     }
        // }

        // stage('Deploy') {
        //     steps {

        //        echo 'This is the deploy stage.'
        //     }
        // }
    }
}