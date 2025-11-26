pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    IMAGE_NAME = "shorten-url"
    IMAGE_TAG = "${BUILD_NUMBER}"


  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/ibrahim-mintal/DEPI_Graduation_Project.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DOCKERHUB_CREDENTIALS_USR/$IMAGE_NAME:$IMAGE_TAG ./app'
      }
    }

    stage('Push to DockerHub') {
      steps {
        sh '''
          echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
          docker push $DOCKERHUB_CREDENTIALS_USR/$IMAGE_NAME:$IMAGE_TAG
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''        
          echo "Deploying to EKS cluster..."
          kubectl set image deployment/app-deployment app-container=$DOCKERHUB_CREDENTIALS_USR/$IMAGE_NAME:$IMAGE_TAG -n app-ns
          kubectl rollout restart deployment/app-deployment -n app-ns
          kubectl rollout status deployment/app-deployment -n app-ns
        '''
      }
    }

    
  }
}

