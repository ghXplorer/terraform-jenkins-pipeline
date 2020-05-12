// Jenkinsfile

try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  // Run terraform init
  stage('init') {
    node {
      ansiColor('xterm') {
        sh 'terraform init'
      }
    }
  }

  // Run terraform plan
  stage('plan') {
    node {
      ansiColor('xterm') {
        sh 'terraform plan'
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {

    // Run terraform apply
    stage('apply') {
      node {
        ansiColor('xterm') {
          sh 'terraform apply -auto-approve'
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
        ansiColor('xterm') {
          sh 'terraform show'
        }
      }
    }

    currentBuild.result = 'SUCCESS'
  }
}

catch (err) {
  currentBuild.result = 'FAILURE'
  echo "Caught: ${err}"
}

finally {
  if (currentBuild.result == 'SUCCESS') {
    echo "SUCCESS!"
  }
}
