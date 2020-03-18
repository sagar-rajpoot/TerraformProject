pipeline{
    
    agent any
    environment {
    PATH = "${PATH}:${getTerraformPath()}"
}

    stages{
        
        stage('terraform init -dev'){
            steps{
                sh "sh returnStatus: true, script: 'terraform workspace new dev'"
                sh "terraform init"
                }
                                    }
        stage('terraform apply -dev'){
                steps{
                    sh "terraform apply -var-file=dev.tfvars -auto-approve"
                }
                                    }

        stage('terraform init -prod'){
            steps{
                sh "sh returnStatus: true, script: 'terraform workspace new prod'"
                sh "terraform init"
            }
                                    }
        stages('terraform apply -prod'){
                steps{
                    sh "terraform apply -var-file=prod.tfvars -auto-approve"
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



