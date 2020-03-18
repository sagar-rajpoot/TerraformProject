pipeline{
    agent any
    environment {
    PATH = "${PATH}:${getTerraformPath()}"
}

    stages{
        stage('terraform init'){
            steps{
                sh "terraform init"
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



