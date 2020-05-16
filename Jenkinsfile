// Jenkinsfile for scripted pipeline

node {
  try {
    // checking repo and searching for 'destroy flag'
    stage('checkout') {
      cleanWs()
      checkout scm
      sh 'ls -al | grep "destroy" | wc -l > temp.value'
      sh 'more temp.value'
      try {
        sh 'grep -i 1 temp.value'
      } catch (err) {
        flag_destroy = 0
      }
      flag_destroy = 1
   }
  
    // Run terraform init
    stage('init') {
      ansiColor('xterm') {
        sh 'terraform init'
        if (flag_destroy == 1) {
          echo 'Destroying AWS infrastructure - DESTROY FLAG detected!'
          ansiColor('xterm') {
            sh 'terraform destroy -auto-approve'
          }
          return
        }
      }
    }

    // Run terraform plan
    stage('plan') {
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
