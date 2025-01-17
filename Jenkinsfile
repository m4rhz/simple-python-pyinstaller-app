pipeline {
    agent {
        docker {
            image 'python:2-alpine'
            args '-u root:root' // Run as root to ensure permissions
        }
    }
    stages {
        stage('Clone Repository') { 
            steps {
                sh 'apk add --no-cache git && git clone -b master https://github.com/m4rhz/simple-python-pyinstaller-app .'
            }
        }
        stage('Build') {
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'python:2' // Switch to a more generic image
                }
            }
            steps {
                sh 'pip install pytest && pytest --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deliver') {
            agent {
                docker {
                    image 'cdrx/pyinstaller-linux:python2'
                }
            }
            steps {
                sh 'pyinstaller --onefile sources/add2vals.py'
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals'
                }
            }
        }
    }
}

