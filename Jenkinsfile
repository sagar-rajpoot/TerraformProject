pipeline{
    agent any
environment {
  PATH = tool name: 'terraform-12', type: 'terraform'
}


    stages{
        stage('terraform init'){
            steps{
                sh 'sudo terraform init'
            }

        }
    }
}

def getTerraformPath(){
    def tfHome = tool name: 'terraform-12', type: 'terraform'
    return tfHome
}


