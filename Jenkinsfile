pipeline{
    agent any
    environment {
    //  tool name: 'terraform-12', type: 'terraform'   
//   PATH = "${getTerraformPath()}:${PATH}"
PATH = tool name: 'terraform-12', type: 'terraform' 
}

    stages{
        stage('terraform init'){
            steps{
                sh "terraform init"
            }

        }
    }
}

def getTerraformPath(){
    def tfHome = tool name: 'terraform-12', type: 'terraform'
    return tfHome
}


