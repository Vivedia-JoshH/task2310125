pipeline {
    agent any
    environment {
        DOCKERHUB_CRED = credentials('dockerhubcred')
    }
    stages {
        stage('Cleanup') {
            steps {
                echo 'Cleaning up existing Containers and Images'
                sh 'docker rm -f $(docker ps -aq) || true'
                sh 'docker rmi -f $(docker images -q) || true'
            }
        }
        
        stage('Build') {
            steps {
                sh 'docker network create task2webhooknetwork || true' 
                sh 'docker volume create task2volumewebhook || true'
                sh 'docker build -t trio-task-mysql:5.7 db'
                sh 'docker build -t trio-task-flask-app:latest flask-app'
            }
        }
        
        stage('Run') {
            steps {
                sh 'docker run -d  --name mysql  --network task2webhooknetwork --mount type=volume,source=task2volumewebhook,target=/var/lib/mysql trio-task-mysql:5.7'
                sh 'docker run -d --name flask-app --network task2webhooknetwork trio-task-flask-app:latest'
                sh 'docker run -d --name nginx -p 80:80 --network task2webhooknetwork --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf nginx:latest'
            }
        }
         stage('push'){
            steps{
                sh "echo \$DOCKERHUB_CRED_PSW | docker login -u \$DOCKERHUB_CRED_USR --password-stdin"
                sh "docker tag mysql joshhillvivedia/mysql1:latest"
                sh "docker tag flask-app joshhillvivedia/flask-app1:latest"
                sh "docker tag nginx joshhillvivedia/nginx1:latest"
                sh "docker push joshhillvivedia/mysql1:latest"
                sh "docker push joshhillvivedia/flask-app1:latest"
                sh "docker push joshhillvivedia/newmynginx1:latest"
            }
        }

      
    
    }
}
