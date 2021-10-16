pipeline {
	agent any
	stages {
		stage('Init') {
			steps {
				sh 'terraform init -no-color'
				
			}
		}

		stage('Plan') {
			steps {
				sh 'terraform plan -no-color'
			}
		}
	}

	post {
		always {
			archiveArtifacts artifacts: 'tfplan.txt'
		}
	}
}
