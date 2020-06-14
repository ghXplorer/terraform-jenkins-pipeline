pipeline {
    agent any 
    environment {
        DESTROY = """${sh(
                returnStatus: true,
                script: 'test -e destroy'
            )}"""
    }
    options {
        ansiColor('xterm')
    }
    
    stages {
        stage('Init') {
            steps {
              cleanWs()
              sh 'terraform init -input=false'
            }
          }
        stage('Destroy') {
            when {
              expression {
                env.DESTROY == '0'
              }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }        
        stage('Provision') {
            when {
              expression {
                env.DESTROY == '1' 
              }
            }
            stages {
              stage('Plan') {
                steps {
                  sh 'terraform plan'
                }
              }
              stage('Deploy') {
                when {
                  branch 'master'
                }
                steps {
                  sh 'terraform apply -auto-approve'
                }
              }
              stage('Show') {
                steps {
                  sh 'terraform show'
                }
              }
            }
        }
    }
}
