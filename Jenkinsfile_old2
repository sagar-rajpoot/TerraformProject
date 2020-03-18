pipeline{
    agent any
    environment {
    PATH = "${PATH}:${getTerraformPath()}"
}

    stages{
        stage('terraform init and apply'){
            steps{
                sh "terraform init"
                sh "terraform apply -auto-approve"
            }

        }
    }
}


// below code return the location ( Directory ) where terraform is installed.
def getTerraformPath(){
    def tfHome = tool name: 'terraform-12', type: 'terraform'
// def tfHome = tool name: 'terraform-12', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
    return tfHome
}



