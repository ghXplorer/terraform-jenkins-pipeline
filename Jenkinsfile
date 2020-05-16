// Jenkinsfile

node {
  try {
    stage('checkout') {
      cleanWs()
      checkout scm
    }
  
    // Run terraform init
    stage('init') {
      ansiColor('xterm') {
        sh 'terraform init'
      }
    }
  
    // Run terraform plan
    stage('plan') {
      ansiColor('xterm') {
        sh 'terraform plan'
      }
    }
  
    if (env.BRANCH_NAME == 'master') {
  
      // Run terraform apply
      stage('apply') {
        ansiColor('xterm') {
            sh 'terraform apply -auto-approve'
        }
      }
  
      // Run terraform show
      stage('show') {
        ansiColor('xterm') {
          sh 'terraform show'
        }
      }
  
      currentBuild.result = 'SUCCESS'
    }
  }
  
  catch (err) {
    currentBuild.result = 'FAILURE'
    echo "Caught: ${err}"
    throw err
  }
  
  finally {
    if (currentBuild.result == 'SUCCESS') {
      echo "SUCCESS!"
    }
  }
}
