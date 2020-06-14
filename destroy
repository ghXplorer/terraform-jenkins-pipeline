// Jenkinsfile for scripted pipeline

node {
  try {
    // Checking repo and searching for 'destroy flag'
    stage('checkout') {
      cleanWs()
      checkout scm
      try {
        sh 'test -e destroy'
      } catch (err) {
          flag_destroy = 0
          return
      }
      flag_destroy = 1
   }
  
    // Run terraform init
    stage('init') {
      ansiColor('xterm') {
        sh 'terraform init -input=false'
      }
    }

    // Run terraform plan
    stage('plan or destroy') {
      if (flag_destroy == 1) {
          echo 'Destroying AWS infrastructure - DESTROY FLAG detected!'
          ansiColor('xterm') {
            sh 'terraform destroy -auto-approve'
          }
          return
      }
      ansiColor('xterm') {
        sh 'terraform plan'
      }
    }
  
    if (env.BRANCH_NAME == 'master' && flag_destroy == 0) {
  
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
