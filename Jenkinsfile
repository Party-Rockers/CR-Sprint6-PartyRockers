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
                
                script {
                    results = awsCodeBuild( 
                        projectName: "${CODEBUILD_NAME}", 
                        credentialsType: 'keys', 
                        region: "${AWS_REGION}", 
                        sourceControlType: 'project', 
                        sourceVersion: "${BRANCH_NAME}" 
                    )

                    echo results.getArtifactsLocation()
                    s3Bucket = results.getArtifactsLocation().split(":::")[1].split("/")[0]
                    s3Prefix = results.getArtifactsLocation().split("/")[1]
                    s3Key    = "${s3Prefix}/${CODEBUILD_NAME}"
                }
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
        
        stage('Deploy') {
            steps {
                echo 'This is the deploy stage.'
                
                withAWS( region: "${AWS_REGION}"){
                    createDeployment(
                        s3Bucket: "${s3Bucket}",
                        s3Key: "${s3Key}",
                        s3BundleType: 'zip', // [Valid values: tar | tgz | zip | YAML | JSON]
                        applicationName: "${CODEDEPLOY_NAME}",
                        deploymentGroupName: "${DEPLOYMENT_GROUP_NAME}",
                        deploymentConfigName: 'CodeDeployDefault.AllAtOnce',
                        description: 'Test deploy',
                        waitForCompletion: 'true'
                    )
                } // withAWS
            } // steps
        }
    }
}