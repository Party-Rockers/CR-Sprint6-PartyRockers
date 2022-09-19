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
                echo 'Building the application...'
                script {
                    results = awsCodeBuild( 
                        projectName: "${CODEBUILD_NAME}", 
                        credentialsType: 'keys', 
                        region: "${AWS_REGION}", 
                        sourceControlType: 'project', 
                        sourceVersion: "${BRANCH_NAME}" 
                    )
                    s3Bucket = results.getArtifactsLocation().split(":::")[1].split("/")[0]
                    s3Prefix = results.getArtifactsLocation().split("/")[1]
                    s3PrimaryKey = "${s3Prefix}/${CODEBUILD_NAME}"
                    s3ReportKey = "${s3Prefix}/reports"
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing the application...'
                withAWS(region: "${AWS_REGION}") {
                    s3Download(bucket: "${s3Bucket}", path: "${s3ReportKey}", file: "reports.zip")
                    unzip zipFile: "reports.zip", dir: "reports"
                    junit "reports/*.xml"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                withAWS( region: "${AWS_REGION}"){
                    createDeployment(
                        s3Bucket: "${s3Bucket}",
                        s3Key: "${s3PrimaryKey}",
                        s3BundleType: 'zip',
                        applicationName: "${CODEDEPLOY_NAME}",
                        deploymentGroupName: "${DEPLOYMENT_GROUP_NAME}",
                        deploymentConfigName: 'CodeDeployDefault.AllAtOnce',
                        description: 'Test deploy',
                        waitForCompletion: 'true'
                    )
                }
            }
        }
    }
}