node {
    stage('Clone') {
        git branch: 'master', 
            url: 'https://github.com/m4rhz/simple-python-pyinstaller-app'
    }
    
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            try {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                junit 'test-reports/results.xml'
            }
        }
    } 
    
    stage('Deliver') {
        // Using cdrx/pyinstaller-linux image which comes with PyInstaller pre-installed
        docker.image('cdrx/pyinstaller-linux:latest').inside {
            try {
                sh '''
                    python --version
                    ls -la sources/
                    python -m PyInstaller --onefile sources/add2vals.py
                    ls -la dist/
                '''
                
                if (currentBuild.currentResult == 'SUCCESS') {
                    archiveArtifacts artifacts: 'dist/add2vals', fingerprint: true
                }
            } catch (Exception e) {
                echo "Error in Deliver stage: ${e.message}"
                currentBuild.result = 'FAILURE'
                throw e
            }
        }
    }
}