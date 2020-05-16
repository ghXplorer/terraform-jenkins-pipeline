// Jenkinsfile for scripted pipeline

node {
  try {
    stage('checkout') {
      cleanWs()
      checkout scm
      sh label: '', script: 'export TF_DESTROY_CHECK=$(ls -al | grep "destroy" | wc -l)'
    }
  
    if (env.TF_DESTROY_CHECK == 1) {
      stage('destroy') {
        ansiColor('xterm') {
          sh 'terraform destroy -auto-approve'
        }
      }
      return
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
