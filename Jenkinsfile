
pipeline{
    agent any
    environment {
    PATH = "${PATH}:${getTerraformPath()}"
}

    stages{
        stage('terraform init -dev'){
            steps{
                sh returnStatus: true, script: 'terraform workspace new dev'
                sh "terraform init"
            }

        }

        stage('terraform apply - dev'){
            steps{
                sh "terraform apply -auto-approve"
            }

        }


        stage('terraform destroy'){
            steps{
                sh "terraform destroy -auto-approve"
            }

        }
    }
}

// below code return the location ( Directory ) where terraform is installed.

def getTerraformPath(){
    def tfHome = tool name: 'terraform-12', type: 'terraform'
    return tfHome
}



